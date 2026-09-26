#!/usr/bin/env python3
from pathlib import Path
import csv
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
GFX=ROOT/'gfx/units/battle'
OUT=GFX/'per_unit'
OUT.mkdir(parents=True, exist_ok=True)

def decode_2bpp(data,wtiles,htiles):
    im=Image.new('P',(wtiles*8,htiles*8),0); im.putpalette([255,255,255,169,169,169,85,85,85,0,0,0] + [0,0,0]*252); px=im.load()
    for t in range(wtiles*htiles):
        tx=(t%wtiles)*8; ty=(t//wtiles)*8
        tile=data[t*16:(t+1)*16]
        for y in range(8):
            lo,hi=tile[y*2:y*2+2]
            for x in range(8):
                bit=7-x; v=((hi>>bit)&1)*2+((lo>>bit)&1)
                px[tx+x,ty+y]=v
    return im
rows=list(csv.DictReader((GFX/'sprite_descriptors.csv').open()))
manifest=[]
for r in rows:
    idx=int(r['index']); unit=(int(r['unit_type']) if r['unit_type'] else ''); name=r['name']; base=int(r['graphics_base'],16)
    off=int(r['tile_offset']); w=int(r['width_tiles']); h=int(r['height_tiles']); n=w*h
    family={0x5561:'ground',0x5fc1:'sea',0x6e91:'air',0x7b61:'special'}[base]
    blob=(GFX/f'{family}.2bpp').read_bytes()[off*16:(off+n)*16]
    stem=f'{idx:02d}_{name}'
    (OUT/f'{stem}.2bpp').write_bytes(blob)
    decode_2bpp(blob,w,h).save(OUT/f'{stem}.png', bits=2)
    build_input = 'yes' if (unit != '' and 1 <= int(unit) <= 51) or family == 'special' else 'no'
    manifest.append([idx,unit,name,family,f'{base:04x}',off,w,h,n,f'{stem}.2bpp',f'{stem}.png',build_input])
with (OUT/'manifest.csv').open('w',newline='') as f:
    w=csv.writer(f); w.writerow(['descriptor_index','unit_type','name','family','graphics_base','tile_offset','width_tiles','height_tiles','tile_count','2bpp','png','build_input']); w.writerows(manifest)
(OUT/'README.md').write_text('''# Per-unit battle sprites\n\nthe current source preserves each Bank $16 battle sprite directly from `BattleUnitSpriteDescriptors`. Each PNG uses the exact descriptor width/height and tile offset; each `.2bpp` is the exact underlying retail tile slice.\n\nFor normal units, the ground/air/sea descriptor slices are contiguous and non-overlapping after a single shared blank tile. Those 51 normal-unit PNG/`.2bpp` pairs are now the actual build inputs; the grouped ground/air/sea sheets are retained only as reference composites. `00_empty` aliases the same four tiles as Infantry and remains a reference duplicate rather than a separately emitted build payload.\n\nthe current source also promotes the five `special_*` descriptor crops into build inputs. Their four intervening nonzero three-tile slices are emitted separately by `extract_battle_special_frames.py` under neutral `interstitial_frame` names; together with one shared blank tile these ten components reconstruct the full 28-tile special family exactly.\n''')
print(f'[ok] wrote {len(rows)} descriptor-accurate sprite crops to {OUT}')
