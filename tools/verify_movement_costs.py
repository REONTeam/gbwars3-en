#!/usr/bin/env python3
from pathlib import Path
import hashlib, re
ROOT=Path(__file__).resolve().parents[1]
ROM=ROOT/'baserom.gbc'
rom=ROM.read_bytes()
start,end=0x479f,0x47ce
off=0x12*0x4000+(start-0x4000)
data=rom[off:off+end-start]
assert hashlib.sha1(data).hexdigest()=="9591a8c3c726eea6597f2a9b6d35fa423c763b8d"
src=(ROOT/'engine/unit/unit_setup.asm').read_text()
for t in ['MovementData_GetCost::','MovementData_BuildMapTileCosts::','farcall $0b, Terrain_GetNameIndex','wMovementCostByMapTile','assert @ == $47ce']:
    assert t in src,t
const=(ROOT/'constants/unit_constants.inc').read_text()
names=['HQ_0','HQ_1','CITY','CITY_RUINS','BASE','BASE_RUINS','AIRPORT','AIRPORT_RUINS','RUNWAY','PORT','PORT_RUINS','COM_TOWER','PLAIN','ROAD','BRIDGE_1','BRIDGE_2','MOUNTAIN','WOOD','WASTELAND','DESERT','RIVER','SEA','SHOAL']
for i,n in enumerate(names):
    assert re.search(rf'DEF MOVEMENT_TERRAIN_{n}\s+EQU {i}\b', const), (n,i)
home=(ROOT/'engine/home/home_map.asm').read_text()
assert 'TerrainNameIndexByMapTile::' in home and 'assert TerrainNameIndexByMapTile_End - TerrainNameIndexByMapTile == $34' in home
print('[ok] Bank $12:$479F-$47CD movement-cost runtime ROM-verified')
print('[ok] 23 MovementData columns tied to terrain-name classes; 52 raw map tiles cache through Terrain_GetNameIndex')
