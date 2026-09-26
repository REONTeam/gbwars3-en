#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
ROM=ROOT/'baserom.gbc'; SRC=ROOT/'engine/unit/unit_status_runtime.asm'; SYM=ROOT/'symbols.asm'
START,END=0x42BE,0x43B3; EXPECT='18e09bd027c12d613f0b2b15907c228f88e4a30f'
text=SRC.read_text(); syms=SYM.read_text()
expected={
'wUnitStatusTypeSide':0xC61B,'wUnitStatusHP':0xC61C,'wUnitStatusFuel':0xC61D,
'wUnitStatusRank':0xC61E,'wUnitStatusPaneSide':0xC61F,'wUnitStatusPaneXOffset':0xC620,
'wUnitStatusSelectedUnitIndex':0xC621,
}
for n,a in expected.items():
    if not re.search(rf'^(?:EXPORT\s+DEF\s+)?{n}\s+(?:EQU|equ)\s+\${a:04x}\s*$',syms,re.M|re.I): raise SystemExit(f'missing alias {n}')
    if n not in text: raise SystemExit(f'helper does not use {n}')
code_only='\n'.join(line.split(';',1)[0] for line in text.splitlines()).lower()
for raw in ['$c61b','$c61c','$c61d','$c61e','$c61f','$c620','$c621']:
    if raw in code_only: raise SystemExit(f'raw scratch literal remains: {raw}')
if 'romx[$42be]' not in text.lower() or 'assert @ == $43b3' not in text.lower(): raise SystemExit('wrong source boundaries')
if 'lifetime-scoped aliases' not in (ROOT/'docs/unit/unit_status_scratch_lifetime.md').read_text(): raise SystemExit('lifetime warning missing')
# Reconstruct the exact byte rows, resolving LOW/HIGH shared-scratch aliases.
vals=[]
for line in text.splitlines():
    code=line.split(';',1)[0].strip()
    if not code.startswith('db '): continue
    for tok in [x.strip() for x in code[3:].split(',')]:
        if tok.startswith('$'): vals.append(int(tok[1:],16)); continue
        m=re.fullmatch(r'(LOW|HIGH)\((w\w+)\)',tok)
        if not m or m.group(2) not in expected: raise SystemExit(f'unsupported db token {tok}')
        v=expected[m.group(2)]; vals.append(v&0xff if m.group(1)=='LOW' else v>>8)
if len(vals)!=END-START: raise SystemExit(f'source reconstructed {len(vals)} bytes, expected {END-START}')
if ROM.exists():
    off=0x25*0x4000+(START-0x4000); d=ROM.read_bytes()[off:off+(END-START)]
    h=hashlib.sha1(d).hexdigest()
    if h!=EXPECT: raise SystemExit(f'ROM hash mismatch: {h}')
    if bytes(vals)!=d: raise SystemExit('source byte reconstruction mismatch')
    print(f'[ok] Unit Status staging ${START:04X}-${END-1:04X}: {len(d)} bytes, SHA-1 {h}')
else:
    print('[skip] baserom.gbc unavailable; structural Unit Status scratch checks passed')
