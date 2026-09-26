#!/usr/bin/env python3
from pathlib import Path
import hashlib,re
ROOT=Path(__file__).resolve().parents[1]; ROM=ROOT/'baserom.gbc'; SRC=ROOT/'engine/unit/unit_status_controller.asm'; SYM=ROOT/'symbols.asm'
START,END=0x4110,0x42BE; EXPECT='6496e937dacfd0eb73bfa31be33775269fe47a0e'
expected={'wUnitStatusCursorSpriteID':0xC61A,'wUnitStatusInitialLeftValue':0xC622,'wUnitStatusPaneSide':0xC61F,'wUnitStatusPaneXOffset':0xC620,'wUnitTransferTargetUnitID':0xC941,'wUnitTransferSourceHP':0xC942,'wUnitTransferTargetHP':0xC943,'wUnitTransferMaxHP':0xC944}
text=SRC.read_text(); syms=SYM.read_text()
for n,a in expected.items():
    if not re.search(rf'^(?:EXPORT\s+DEF\s+)?{n}\s+(?:EQU|equ)\s+\${a:04x}\s*$',syms,re.M|re.I): raise SystemExit(f'missing alias {n}')
code='\n'.join(x.split(';',1)[0] for x in text.splitlines()).lower()
for raw in ('$c61a','$c622'):
    if raw in code: raise SystemExit(f'raw controller scratch remains: {raw}')
# Restrict reconstruction to the first fixed section only.
part=text.split('section "UnitStatus Controller Runtime"',1)[1].split('section "UnitStatus Panel Graphics Runtime"',1)[0]
vals=[]
for line in part.splitlines():
    c=line.split(';',1)[0].strip()
    if not c.startswith('db '): continue
    for tok in [x.strip() for x in c[3:].split(',')]:
        if tok.startswith('$'): vals.append(int(tok[1:],16)); continue
        m=re.fullmatch(r'(LOW|HIGH)\((w\w+)\)',tok)
        if not m or m.group(2) not in expected: raise SystemExit(f'unsupported token {tok}')
        v=expected[m.group(2)]; vals.append(v&255 if m.group(1)=='LOW' else v>>8)
if len(vals)!=END-START: raise SystemExit(f'reconstructed {len(vals)} bytes, expected {END-START}')
if ROM.exists():
    off=0x25*0x4000+(START-0x4000); d=ROM.read_bytes()[off:off+END-START]; h=hashlib.sha1(d).hexdigest()
    if h!=EXPECT: raise SystemExit(f'ROM hash mismatch {h}')
    if bytes(vals)!=d: raise SystemExit('source reconstruction mismatch')
    print(f'[ok] Unit Status controller ${START:04X}-${END-1:04X}: {len(d)} bytes, SHA-1 {h}')
else: print('[skip] baserom.gbc unavailable; structural checks passed')
