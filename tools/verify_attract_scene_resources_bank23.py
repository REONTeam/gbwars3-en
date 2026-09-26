#!/usr/bin/env python3
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else ROOT/'baserom.gbc').read_bytes()
def off(bank,addr): return bank*0x4000+(addr-0x4000)
def chunk(a,b): return rom[off(0x23,a):off(0x23,b)]
def req(c,m):
    if not c: raise AssertionError(m)
d=ROOT/'gfx/attract/resources_bank23'
spec=[('scene1.tilemap',0x4fc7,0x508f),('scene1.attrmap',0x508f,0x5157),('scene1.2bpp',0x5157,0x5dd7),('scene1_pal_0.pal',0x5dd7,0x5dff),('scene1_pal_1.pal',0x5dff,0x5e17),('scene3.tilemap',0x5e17,0x5edf),('scene3.attrmap',0x5edf,0x5fa7),('scene3.2bpp',0x5fa7,0x6bc7),('scene3_pal_0.pal',0x6bc7,0x6bef),('scene3_pal_1.pal',0x6bef,0x6c07),('scene4.tilemap',0x6c07,0x6ccf),('scene4.attrmap',0x6ccf,0x6d97),('scene4.2bpp',0x6d97,0x7a07),('scene4_pal_0.pal',0x7a07,0x7a2f),('scene4_pal_1.pal',0x7a2f,0x7a47),('scene4_tail_tiles.2bpp',0x7a47,0x7ba7)]
for n,a,b in spec:req((d/n).read_bytes()==chunk(a,b),f'{n} mismatch')
req(all(x==0xff for x in chunk(0x7ba7,0x8000)),'Bank23 tail padding mismatch')
s=(ROOT/'engine/ui/attract_scene_resources_bank23.asm').read_text()
for t in ('AttractScene1Tilemap::','AttractScene3Tilemap::','AttractScene4Tilemap::','AttractScene4TailTiles::','ds $1f0, $ff'):req(t in s,f'missing source token {t}')
print('attract Bank23 format-specific resources [ok]')
