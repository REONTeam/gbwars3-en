#!/usr/bin/env python3
from pathlib import Path
import hashlib,re
ROOT=Path(__file__).resolve().parents[1]
ROM=ROOT/'baserom.gbc'; SRC=ROOT/'engine/unit/unit_status_controller.asm'; SYM=ROOT/'symbols.asm'
RANGES=[(0x4110,0x42BE,'6496e937dacfd0eb73bfa31be33775269fe47a0e'),(0x43BD,0x448C,'6d196bc1caff9b43fc0c43e9680e149f054205d6')]
expected={'wUnitStatusCursorSpriteID':0xC61A,'wUnitStatusPaneSide':0xC61F,'wUnitStatusPaneXOffset':0xC620,'wUnitStatusInitialLeftValue':0xC622,'wUnitTransferTargetUnitID':0xC941,'wUnitTransferSourceHP':0xC942,'wUnitTransferTargetHP':0xC943,'wUnitTransferMaxHP':0xC944}
text=SRC.read_text(); syms=SYM.read_text()
for n,a in expected.items():
    if not re.search(rf'^(?:EXPORT\s+DEF\s+)?{n}\s+(?:EQU|equ)\s+\${a:04x}\s*$',syms,re.M|re.I): raise SystemExit(f'missing alias {n}')
    if n not in text: raise SystemExit(f'source does not use {n}')
code_only='\n'.join(x.split(';',1)[0] for x in text.splitlines()).lower()
for raw in ['$c61a','$c61f','$c620','$c622','$c941','$c942','$c943','$c944']:
    if raw in code_only: raise SystemExit(f'raw controller scratch literal remains: {raw}')
# Parse each section independently.
sections=[]; current=None
for line in text.splitlines():
    code=line.split(';',1)[0].strip()
    m=re.search(r'romx\[\$(....)\]',code,re.I)
    if code.lower().startswith('section ') and m:
        if current: sections.append(current)
        current=[int(m.group(1),16),[]]
        continue
    if current and code.startswith('db '):
        for tok in [x.strip() for x in code[3:].split(',')]:
            if tok.startswith('$'): current[1].append(int(tok[1:],16)); continue
            m2=re.fullmatch(r'(LOW|HIGH)\((w\w+)\)',tok)
            if not m2 or m2.group(2) not in expected: raise SystemExit(f'unsupported db token {tok}')
            v=expected[m2.group(2)]; current[1].append(v&0xff if m2.group(1)=='LOW' else v>>8)
if current: sections.append(current)
by_start={s:bytes(v) for s,v in sections}
for start,end,sha in RANGES:
    got=by_start.get(start)
    if got is None: raise SystemExit(f'missing source section ${start:04X}')
    if len(got)!=end-start: raise SystemExit(f'${start:04X} reconstructed {len(got)} bytes, expected {end-start}')
    if ROM.exists():
        off=0x25*0x4000+(start-0x4000); d=ROM.read_bytes()[off:off+end-start]
        h=hashlib.sha1(d).hexdigest()
        if h!=sha: raise SystemExit(f'ROM hash mismatch ${start:04X}: {h}')
        if got!=d: raise SystemExit(f'source byte mismatch ${start:04X}')
        print(f'[ok] Unit Status controller ${start:04X}-${end-1:04X}: {len(d)} bytes, SHA-1 {h}')
    else: print(f'[skip] baserom absent; structural check ${start:04X}-${end-1:04X}')
