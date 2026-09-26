#!/usr/bin/env python3
from pathlib import Path
from PIL import Image
import csv, sys

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1] if len(sys.argv) > 1 else ROOT / 'baserom.gbc')
BASE = 0x17 * 0x4000
rom = ROM.read_bytes()
BPROOT = ROOT / 'gfx/environment/battle_places'
REC = list(csv.DictReader((BPROOT / 'logical_resources/record_manifest.csv').open()))
OUT = BPROOT / 'composites'; OUT.mkdir(parents=True, exist_ok=True)
NEUTRAL=[(255,255,255),(170,170,170),(85,85,85),(0,0,0)]

def rb(addr, n):
    return rom[BASE + addr - 0x4000:BASE + addr - 0x4000 + n]

def tile_pixels(data):
    out = [[0]*8 for _ in range(8)]
    for y in range(8):
        lo, hi = data[y*2:y*2+2]
        for x in range(8):
            bit = 7-x
            out[y][x] = (((hi >> bit) & 1) << 1) | ((lo >> bit) & 1)
    return out

names = {}
for p in (BPROOT / 'runtime_windows').glob('*.png'):
    try: tid = int(p.stem.split('_',1)[0], 16)
    except Exception: continue
    names[tid] = p.stem.split('_',1)[1]

manifest=[]
for r in REC:
    tid=int(r['map_tile'],16); gp=int(r['graphics'],16); lp=int(r['layout'],16); ap=int(r['attributes'],16); pp=int(r['palette'],16); sel=int(r['palette_variant'],16)
    gfx=rb(gp,0x160); layout=rb(lp,27); attrs=rb(ap,27)
    im=Image.new('RGB',(72,24),(255,255,255))
    for i,t in enumerate(layout):
        assert t < 22
        attr=attrs[i]
        pix=tile_pixels(gfx[t*16:(t+1)*16])
        xf=bool(attr & 0x20); yf=bool(attr & 0x40)
        ox=(i%9)*8; oy=(i//9)*8
        for y in range(8):
            for x in range(8):
                sx=7-x if xf else x; sy=7-y if yf else y
                im.putpixel((ox+x,oy+y),NEUTRAL[pix[sy][sx]])
    name=names.get(tid,f'tile_{tid:02x}')
    fn=f'{tid:02x}_{name}.png'; im.save(OUT/fn)
    manifest.append([f'{tid:02X}',name,f'{gp:04X}',f'{lp:04X}',f'{ap:04X}',f'{pp:04X}',f'{sel:04X}',fn])
with (OUT/'manifest.csv').open('w',newline='') as f:
    w=csv.writer(f); w.writerow(['map_tile','name','graphics','layout','attributes','palette','palette_variant','png']); w.writerows(manifest)
print(f'[ok] rendered {len(manifest)} neutral map-tile battle-place composites; palette metadata remains in logical resources')
