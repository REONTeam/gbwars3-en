#!/usr/bin/env python3
from pathlib import Path
import csv, sys
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1] if len(sys.argv) > 1 else ROOT / 'baserom.gbc')
OUT = ROOT / 'gfx/units/battle/per_unit'
rom = ROM.read_bytes()
base = 0x16 * 0x4000
special = rom[base + (0x7B61 - 0x4000):base + (0x7D21 - 0x4000)]
assert len(special) == 28 * 16

def decode_2bpp(data):
    n = len(data) // 16
    im = Image.new('P', (n * 8, 8), 0)
    im.putpalette([255,255,255,169,169,169,85,85,85,0,0,0] + [0,0,0] * 252)
    px = im.load()
    for t in range(n):
        tile = data[t*16:(t+1)*16]
        for y in range(8):
            lo, hi = tile[y*2:y*2+2]
            for x in range(8):
                bit = 7 - x
                px[t*8+x, y] = (((hi >> bit) & 1) << 1) | ((lo >> bit) & 1)
    return im

def emit(stem, offset, count):
    data = special[offset*16:(offset+count)*16]
    (OUT / f'{stem}.2bpp').write_bytes(data)
    decode_2bpp(data).save(OUT / f'{stem}.png', bits=2)

emit('special_shared_blank', 0, 1)
rows = []
for i in range(5):
    off = 1 + i * 6
    stem = f'{52+i:02d}_special_{i}'
    emit(stem, off, 3)
    rows.append([i, 52+i, off, 3, f'{stem}.2bpp', f'{stem}.png', 'descriptor'])
    if i < 4:
        stem = f'special_{i}_interstitial_frame'
        emit(stem, off + 3, 3)
        rows.append([i, '', off+3, 3, f'{stem}.2bpp', f'{stem}.png', 'paired_interstitial'])
with (OUT / 'special_frame_manifest.csv').open('w', newline='') as f:
    w = csv.writer(f)
    w.writerow(['special_index','descriptor_index','tile_offset','tile_count','2bpp','png','role'])
    w.writerows(rows)
print('[ok] split 28-tile special family into one blank tile, five descriptor slices, and four exact 3-tile interstitial slices')
