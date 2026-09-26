#!/usr/bin/env python3
from pathlib import Path
import re,sys
ROOT=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else ROOT/'baserom.gbc').read_bytes()
def off(bank,addr):return bank*0x4000+(addr-0x4000)
src=(ROOT/'engine/battle/battle_place_graphics.asm').read_text()
pat=re.compile(r'^BattlePlace(Layout|Attributes|Graphics|Palette)_([0-9A-F]{4})::\n\s+incbin "([^"]+)"',re.M)
rows=[(kind,int(a,16),ROOT/path) for kind,a,path in pat.findall(src)]
rows.sort(key=lambda x:x[1])
if len(rows)!=96:raise SystemExit(f'[fail] expected 96 battle-place resource slices, found {len(rows)}')
for i,(kind,a,p) in enumerate(rows):
    b=rows[i+1][1] if i+1<len(rows) else 0x6bf3
    exp=rom[off(0x17,a):off(0x17,b)]
    if p.read_bytes()!=exp:raise SystemExit(f'[fail] mismatch {p.relative_to(ROOT)}')
print('battle-place format-specific resource arena: 96 slices [ok]')
