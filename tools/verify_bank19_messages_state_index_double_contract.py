#!/usr/bin/env python3
from pathlib import Path
import hashlib, re

ROOT = Path(__file__).resolve().parents[1]
RETAIL = ROOT / 'baserom.gbc'
BUILT = ROOT / 'GBWARS3.gbc'
SOURCE = ROOT / 'engine/network/bank19_network_messages_tail.asm'
BANK = 0x19
CONTRACTS = [
    (0x7AB2, 0x7BB3, 'bc267695281c3027c590e175445ade230d40d6e0', 'Messages common input/state loop'),
    (0x7BB3, 0x7C39, 'b5c40b1013f08249064a213b365263cbc25db883', 'Messages special/indexed-entry helpers'),
]
REQUIRED = [
    'NetworkMessages_StateCommonReturn::',
    'NetworkMessages_ControllerCommonExit::',
    'NetworkMessages_ControllerSpecialPath::',
    'NetworkMessages_TestIndexedEntry::',
    'NetworkMessages_TestCurrentSelectionEntry::',
    'NetworkMessages_ReturnClear::',
    'assert @ == $7bb3',
    'assert @ == $7c39',
]

def rom_offset(addr: int) -> int:
    return BANK * 0x4000 + (addr - 0x4000)

def fail(msg: str) -> None:
    raise SystemExit('FAIL - ' + msg)

def main() -> None:
    if not RETAIL.exists(): fail('baserom.gbc is required')
    if not BUILT.exists(): fail('GBWARS3.gbc is required')
    retail = RETAIL.read_bytes(); built = BUILT.read_bytes()
    for start, end, expected, name in CONTRACTS:
        s, e = rom_offset(start), rom_offset(end)
        blob = retail[s:e]
        digest = hashlib.sha1(blob).hexdigest()
        if digest != expected: fail(f'{name}: retail SHA-1 {digest} != {expected}')
        if built[s:e] != blob: fail(f'{name}: built bytes differ from retail')
        print(f'PASS - {name}: {end-start} bytes, SHA-1 {digest}')

    src = SOURCE.read_text(encoding='utf-8')
    for needle in REQUIRED:
        if needle not in src: fail('missing source marker: ' + needle)
    owned = src.split('NetworkMessages_StateCommonReturn::',1)[1].split('NetworkMessages_RefreshSelectedEntry::',1)[0]
    if re.search(r'(?m)^\s*db\s+', owned):
        fail('raw db remains inside newly mnemonic $7AB2-$7C38 ownership')
    print('PASS - $7AB2-$7C38 contains no raw db executable block')

    numeric = re.compile(r'\bfarcall\s+\$[0-9A-Fa-f]{1,2}\s*,\s*\$[0-9A-Fa-f]{4}\b')
    hits=[]
    for path in ROOT.rglob('*.asm'):
        for lineno, line in enumerate(path.read_text(errors='replace').splitlines(),1):
            if numeric.search(line): hits.append(f'{path.relative_to(ROOT)}:{lineno}')
    if hits: fail('raw numeric farcall remains: ' + ', '.join(hits[:5]))
    print('PASS - project-wide raw numeric farcall audit: 0')

    source_dirs = [ROOT / name for name in ('engine','data','audio','source')]
    modules = [p for d in source_dirs if d.exists() for p in d.rglob('*.asm')]
    makefile = (ROOT/'Makefile').read_text(encoding='utf-8')
    objs=set(re.findall(r'\b(?:engine|data|audio|source)/[A-Za-z0-9_./-]+\.o\b',makefile))
    source_count=len(modules)+(1 if (ROOT/'symbols.asm').exists() else 0)
    object_count=len(objs)+(1 if re.search(r'\bsymbols\.o\b',makefile) else 0)
    if object_count != source_count: fail(f'Makefile object/source inventory {object_count} / {source_count}')
    print(f'PASS - Makefile object/source inventory: {object_count} / {source_count}')

    digest=hashlib.sha256(built).hexdigest()
    expected='e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
    if digest != expected: fail('custom-English ROM SHA-256 changed: ' + digest)
    print('PASS - corrected custom-English ROM SHA-256: ' + digest)

if __name__ == '__main__':
    main()
