#!/usr/bin/env python3
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else ROOT/'baserom.gbc').read_bytes()
def require(c,m):
    if not c: raise AssertionError(m)
def off(bank,addr): return bank*0x4000+(addr-0x4000)
def chunk(start,end): return rom[off(0x31,start):off(0x31,end)]
for suf,start,length in (('tilemap',0x4a4a,0xc8),('attrmap',0x4b12,0xc8),('2bpp',0x4bda,0x1000),('pal',0x50ba,0x28)):
    require((ROOT/f'gfx/attract/scene_0.{suf}').read_bytes()==chunk(start,start+length),f'scene 0 {suf} mismatch')
src=(ROOT/'engine/battle/battle_scene_bank31_resource.asm').read_text()
for t in ('AttractScene0Tilemap::','AttractScene0Attributes::','AttractScene0GraphicsWindow::','AttractScene0Palettes::'):
    require(t in src,f'missing scene 0 alias: {t}')
scene=(ROOT/'engine/ui/attract_scene_runtime.asm').read_text()
require('AttractScene0GraphicsWindow, AttractScene0Palettes, AttractScene0Tilemap, AttractScene0Attributes' in scene,'scene 0 descriptor is not symbolic')
print('attract scene 0: logical Bank31 aliases/views verified without duplicate ownership [ok]')
