#!/usr/bin/env python3
from pathlib import Path
import re, sys
ROOT=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else ROOT/'baserom.gbc').read_bytes()
out=ROOT/'gfx/environment/battle_places/resources';out.mkdir(parents=True,exist_ok=True)
src=(ROOT/'engine/battle/battle_place_graphics.asm').read_text()
labels=[]
for m in re.finditer(r'^BattlePlace(Layout|Attributes|Graphics|Palette)_([0-9A-F]{4})::',src,re.M):
    labels.append((m.group(1),int(m.group(2),16)))
labels.sort(key=lambda x:x[1])
for i,(kind,a) in enumerate(labels):
    b=labels[i+1][1] if i+1<len(labels) else 0x6bf3
    ext={'Layout':'.tilemap','Attributes':'.attrmap','Graphics':'.2bpp','Palette':'.pal'}[kind]
    name={'Layout':'layout','Attributes':'attributes','Graphics':'graphics','Palette':'palette'}[kind]
    off=0x17*0x4000+(a-0x4000)
    (out/f'{name}_{a:04x}{ext}').write_bytes(rom[off:off+(b-a)])
print(f'wrote {len(labels)} battle-place format-specific resource slices')
