#!/usr/bin/env python3
import csv, sys, hashlib
from pathlib import Path
from PIL import Image
rom=Path(sys.argv[1]).read_bytes()
root=Path('gfx/environment/battle_places')
rows=list(csv.DictReader((root/'runtime_windows/map_tile_records.csv').open()))
out=root/'unique_windows'; out.mkdir(exist_ok=True)
by={}
for r in rows: by.setdefault(r['graphics_window_ptr'].upper(),[]).append(r)
manifest=[]
for ptr,rs in sorted(by.items(), key=lambda kv:int(kv[0],16)):
    cpu=int(ptr,16); off=0x17*0x4000+(cpu-0x4000)
    data=rom[off:off+0x160]
    # 22 Game Boy 2bpp tiles, laid out as the runtime window: 11 x 2 tiles.
    pix=[]
    for t in range(22):
        tile=[]
        for y in range(8):
            lo=data[t*16+y*2]; hi=data[t*16+y*2+1]
            tile.append([((hi>>(7-x))&1)*2+((lo>>(7-x))&1) for x in range(8)])
        pix.append(tile)
    im=Image.new('L',(88,16),255); p=im.load(); shades=(255,170,85,0)
    for t,tile in enumerate(pix):
        tx=(t%11)*8; ty=(t//11)*8
        for y in range(8):
            for x in range(8): p[tx+x,ty+y]=shades[tile[y][x]]
    aliases='__'.join(f"{r['map_tile_id']}_{r['terrain_class']}" for r in rs)
    fn=f'{ptr.lower()}_{aliases}.png'
    im.save(out/fn)
    manifest.append({'graphics_window_ptr':ptr,'filename':fn,'map_tiles':'|'.join(f"{r['map_tile_id']}:{r['terrain_class']}" for r in rs),'sha1':hashlib.sha1(data).hexdigest()})
with (out/'manifest.csv').open('w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=manifest[0].keys()); w.writeheader(); w.writerows(manifest)
print(f'wrote {len(manifest)} unique windows')
