#!/usr/bin/env python3
from pathlib import Path
import hashlib
ROOT=Path(__file__).resolve().parents[1]
rom=(ROOT/'baserom.gbc').read_bytes()
exp=hashlib.sha1(rom[0x2164:0x2273]).hexdigest()
assert exp=='f23c0d875667e006cc492360f9f59fa9176e1f15',exp
base=rom[0x5268:0x5868]
ranges={'sea':(0x2273,0x2333,0x51),'river':(0x2333,0x23f3,0x4d),'bridge1':(0x23f3,0x24b3,0x35),'bridge2':(0x24b3,0x2573,0x39),'shoal':(0x2573,0x2633,0x55)}
for name,(s,e,tile) in ranges.items():
 data=rom[s:e]; assert len(data)==0xc0
 assert data[:0x40]==base[tile*16:tile*16+0x40]
 built=ROOT/f'gfx/environment/map/animations/{name}.2bpp'
 assert built.exists() and built.read_bytes()==data,(name,'build mismatch')
src=(ROOT/'engine/home/home_map.asm').read_text()
for t in ['MapTerrainAnimation_Reset::','MapTerrainAnimation_Update::','MapTerrainAnimation_Sea::','MapTerrainAnimation_River::','MapTerrainAnimation_Bridge1::','MapTerrainAnimation_Bridge2::','MapTerrainAnimation_Shoal::','assert @ == $2633']:
 assert t in src,t
assert 'call MapTerrainAnimation_Update' in src
assert 'call MapTerrainAnimation_Reset' in (ROOT/'engine/map/map_editor.asm').read_text()
print('[ok] map animation runtime and 5 x 3-phase terrain animation assets')
print('runtime sha1',exp)
