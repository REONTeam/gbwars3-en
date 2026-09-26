#!/usr/bin/env python3
"""Render UnitData map icons from the ROM-authored overlay metatile table."""
from pathlib import Path
from PIL import Image, ImageOps
import re, sys
ROOT=Path(__file__).resolve().parents[1]
ROM=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
if not ROM.exists(): raise SystemExit(f'missing ROM: {ROM}')
rom=ROM.read_bytes()
text=(ROOT/'engine/unit/unit.asm').read_text(); block=text.split('UnitData:',1)[1].split('assert @ - UnitData',1)[0]
labels=re.findall(r'^\s*dw \.([A-Za-z0-9_]+)\s*$',block,re.M)
if len(labels)!=53: raise SystemExit(f'expected 53 UnitData pointers, found {len(labels)}')
master=Image.open(ROOT/'gfx/units/source_tiles/map_icons.png').convert('L')
if master.size!=(128,112): raise SystemExit(f'unexpected map icon master dimensions: {master.size}')
def tile(tid):
    x=(tid%16)*8; y=(tid//16)*8; return master.crop((x,y,x+8,y+8))
def qtile(tid,attr):
    im=tile(tid)
    if attr & 0x20: im=ImageOps.mirror(im)
    if attr & 0x40: im=ImageOps.flip(im)
    return im
def cat(i):
    if i in (0,52): return 'special'
    if i<=28: return 'ground'
    if i<=43: return 'air'
    return 'sea'
def render_def(raw):
    canvas=Image.new('L',(16,16),255); pairs=[(raw[j],raw[j+1]) for j in range(0,8,2)]
    for q,(tid,attr) in enumerate(pairs): canvas.paste(qtile(tid,attr),((q%2)*8,(q//2)*8))
    return canvas,pairs
base=0x1e0c; outroot=ROOT/'gfx/units/map_icons/composed'; count=0
for i,name in enumerate(labels):
    d=outroot/cat(i)/f'{i:02d}_{name}'; d.mkdir(parents=True,exist_ok=True); metas=[]
    for side in (0,1):
        rel=i*2+side; raw=rom[base+rel*8:base+(rel+1)*8]
        canvas,pairs=render_def(raw)
        if side == 0:
            canvas.save(d/'icon.png'); count+=1
        metas.append(f'side{side} metatile ${0x34+rel:02X}: '+', '.join(f'tile ${t:02X} attr ${a:02X}' for t,a in pairs))
    (d/'metatile.txt').write_text('\n'.join(metas)+'\n')
special=outroot/'special_overlays'; special.mkdir(parents=True,exist_ok=True)
raw=rom[base+106*8:base+107*8]; render_def(raw)[0].save(special/'9e_special.png')
print(f'[ok] rendered {count} neutral UnitData icons + special $9E overlay; both side definitions remain in metadata')
