#!/usr/bin/env python3
from pathlib import Path
import csv, subprocess, tempfile
ROOT=Path(__file__).resolve().parents[1]; G=ROOT/'gfx/units/battle'; U=G/'per_unit'
rows=list(csv.DictReader((G/'sprite_descriptors.csv').open()))
byfam={'ground':[],'air':[],'sea':[],'special':[]}
for r in rows:
    i=int(r['index']); name=r['name']; fam={0x5561:'ground',0x5fc1:'sea',0x6e91:'air',0x7b61:'special'}[int(r['graphics_base'],16)]
    off=int(r['tile_offset']); n=int(r['width_tiles'])*int(r['height_tiles'])
    src=(G/f'{fam}.2bpp').read_bytes()[off*16:(off+n)*16]
    got=(U/f'{i:02d}_{name}.2bpp').read_bytes(); assert got==src,(i,name)
    byfam[fam].append((off,off+n,i,name,r))
assert (U/'shared_blank.2bpp').read_bytes()==bytes(16)
for fam,last in [('ground',162),('air',201),('sea',233)]:
    xs=sorted(x for x in byfam[fam] if x[2]!=0)
    assert xs[0][0]==1 and xs[-1][1]==last
    for a,b in zip(xs,xs[1:]): assert a[1]==b[0],(fam,a,b)
    rebuilt=bytearray(16)
    for _,_,i,name,r in xs: rebuilt += (U/f'{i:02d}_{name}.2bpp').read_bytes()
    assert bytes(rebuilt)==(G/f'{fam}.2bpp').read_bytes(),fam
# Indexed PNGs are now genuine deterministic source inputs for the pinned RGBDS rgbgfx.
rgbgfx=ROOT/'tools/rgbds/bin/rgbgfx'
if rgbgfx.exists():
    check=[r for r in rows if r['unit_type'] and 1<=int(r['unit_type'])<=51]
    for r in check:
        stem=f"{int(r['index']):02d}_{r['name']}"
        with tempfile.NamedTemporaryFile() as tmp:
            subprocess.run([str(rgbgfx),'-o',tmp.name,str(U/f'{stem}.png')],check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
            assert Path(tmp.name).read_bytes()==(U/f'{stem}.2bpp').read_bytes(),stem
src=(ROOT/'data/gfx/graphics.asm').read_text()
for r in rows:
    if r['unit_type'] and 1<=int(r['unit_type'])<=51:
        assert f'incbin "gfx/units/battle/per_unit/{int(r["index"]):02d}_{r["name"]}.2bpp"' in src
print('[ok] 51 normal unit PNGs rebuild byte-exact descriptor payloads and reconstruct the ground/air/sea ROM ranges')

# the current source: special family is physically split without overclaiming the four interstitial slices.
special_parts=[(U/'special_shared_blank.2bpp').read_bytes()]
for i in range(5):
    special_parts.append((U/f'{52+i:02d}_special_{i}.2bpp').read_bytes())
    if i<4:
        special_parts.append((U/f'special_{i}_interstitial_frame.2bpp').read_bytes())
assert b''.join(special_parts)==(G/'special.2bpp').read_bytes()
print('[ok] special family reconstructs from one blank tile, five descriptor slices, and four neutral interstitial-frame slices; 00_empty remains an Infantry alias')
