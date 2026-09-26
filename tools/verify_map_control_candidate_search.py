#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys

ROOT=Path(__file__).resolve().parents[1]
ROM=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=ROM.read_bytes()

def retail(bank,start,end):
    off=start if bank==0 else bank*0x4000+(start-0x4000)
    return rom[off:off+end-start]

checks=[
    (0,0x0985,0x099b,'MapGrid_GetBaseTileAtCoordinates','5b831fe93918c6d015e3bfb36b3678fa1c32f638'),
    (0,0x099b,0x09a6,'Terrain_GetNameIndexROM0','a9cbe0ba388cc75bec32d135f7af04b2a3bb8d3a'),
    (0,0x291d,0x2949,'HexGrid_GetDistance','d0f5b7419f5cac19785f2da333b672b96523af59'),
    (0,0x298f,0x2996,'AbsA','b2ac5a803506c161f316d2af1817240319964a9d'),
    (0x0d,0x5ac2,0x5b1a,'MapControl_FindNearestPortRecordToCurrentHQ','fae8e5ca4954cff6f9f07ee5c678b3afe11c8836'),
    (0x0d,0x5b1a,0x5b8a,'MapControl_FindNearestOpposingHQRegionCell','c6e3720e79090c6833ed0e454f082acab287228e'),
]
for bank,a,b,name,sha in checks:
    data=retail(bank,a,b)
    if hashlib.sha1(data).hexdigest()!=sha:
        raise SystemExit(f'ROM hash mismatch: {name}')

home=(ROOT/'engine/home/home_map.asm').read_text()
analysis=(ROOT/'engine/map/ai/map_control_analysis_runtime.asm').read_text()
helptext=(ROOT/'engine/map/ai/map_control_resolution_helpers.asm').read_text()
syms=(ROOT/'symbols.asm').read_text()
doc=(ROOT/'docs/map/map_control_candidate_search.md').read_text()
for label in ('MapGrid_GetBaseTileAtCoordinates::','Terrain_GetNameIndexROM0::','HexGrid_GetDistance::','AbsA::'):
    if label not in home: raise SystemExit(f'missing ROM0 helper {label}')
for label in ('MapControl_FindNearestPortRecordToCurrentHQ::','MapControl_FindNearestOpposingHQRegionCell::'):
    if label not in analysis: raise SystemExit(f'missing search source {label}')
for token in ('cp MOVEMENT_TERRAIN_PORT','call HexGrid_GetDistance','call MapControl_GetCurrentPhaseSidePair','call MapControl_GetOpposingPhaseSidePair'):
    if token not in analysis: raise SystemExit(f'missing semantic search token: {token}')
for token in ('call MapControl_FindNearestPortRecordToCurrentHQ','call MapControl_FindNearestOpposingHQRegionCell','UNIT_TYPE_TRANSPORT_SHIP << 1','MAP_CONTROL_ANALYSIS_TRANSPORT_ROUTE_F'):
    if token not in helptext: raise SystemExit(f'transport-route caller is not symbolic: {token}')
for token in ('wMapControlTransportPortX equ $de9c','wMapControlTransportApproachX equ $de9e'):
    if token.lower() not in syms.lower(): raise SystemExit(f'missing transport candidate alias: {token}')
for phrase in ('MOVEMENT_TERRAIN_PORT','Transport Ship movement-cost field','opposing HQ'):
    if phrase not in doc: raise SystemExit(f'missing documentation: {phrase}')
print('[ok] phase candidate-search criteria and ROM0 distance/tile helpers ROM-locked')
print('[ok] Transport Ship Port/approach route semantics integrated')
