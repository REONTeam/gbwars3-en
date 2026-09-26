#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys, re
ROOT=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else ROOT/'baserom.gbc').read_bytes()

def retail(bank,a,b):
    off=bank*0x4000 + (a-(0x4000 if bank else 0))
    return rom[off:off+b-a]
checks=[
 (0x00,0x0850,0x08f5,'ef362ea8ffdba1085ba2cb0c1d2bd9066433d00b'),
 (0x0d,0x58f2,0x599b,'4a29ce4b9342936e6a1ac19537f67b36f8492456'),
 (0x0d,0x59d4,0x5a86,'8368231dda6caee6173cdcf59a61b63d2855bcb2'),
 (0x0d,0x6870,0x68c2,'e2b427885bb831b120514cc08f37916948c91f76'),
]
for bank,a,b,sha in checks:
    d=retail(bank,a,b)
    assert hashlib.sha1(d).hexdigest()==sha,(hex(bank),hex(a),hex(b))

home=(ROOT/'engine/home/home_map.asm').read_text()
analysis=(ROOT/'engine/map/ai/map_control_analysis_runtime.asm').read_text()
helpers=(ROOT/'engine/map/ai/map_control_resolution_helpers.asm').read_text()
force=(ROOT/'engine/map/ai/map_control_force.asm').read_text()
syms=(ROOT/'symbols.asm').read_text()
const=(ROOT/'constants/map_constants.inc').read_text()
doc=(ROOT/'docs/map/map_control_movement_cost_field.md').read_text()
for token in [
 'HexGrid_RunCallbackFloodFill::','CallIndirectFromPointer::','HexGrid_FloodFillEnqueueBC::',
 'MapControl_BuildMovementCostField::','MapControl_SeedMovementCostField::',
 'MapControl_LoadMovementCostFieldCell::','MapControl_StoreMovementCostFieldCell::',
 'MapControl_TestMovementCostFieldCandidate::','MapControl_FindRouteRiverReference::',
 'MAP_TERRAIN_RIVER','UNIT_TYPE_DUMMY << 1','UNIT_TYPE_INFANTRY << 1',
 'MAP_CONTROL_ANALYSIS_INFANTRY_HQ_ROUTE_F','MAP_CONTROL_ANALYSIS_READY_F',
 'MAP_CONTROL_ANALYSIS_PORT_AND_HQ_REGION_CANDIDATES_F','wMapControlRouteRiverX','wMapControlRouteRiverY',
]:
    if token not in home+analysis+helpers+force+syms+const:
        raise SystemExit('missing semantic token: '+token)
for old,new in [('wMapControlReferenceCellX','wMapControlRouteRiverX'),('wMapControlReferenceCellY','wMapControlRouteRiverY')]:
    if not re.search(rf'^\s*{old}\s+equ\s+{new}',syms,re.M):
        raise SystemExit('missing compatibility alias '+old)
for phrase in ['shortest route','Infantry-profile HQ-to-HQ reachability','phase-analysis-ready','UNIT_TYPE_TRANSPORT_SHIP']:
    if phrase not in doc:
        raise SystemExit('missing doc contract: '+phrase)
# Critical producer bytes: DUMMY profile, River test, Infantry profile, and bit setters.
assert retail(0x0d,0x59e1,0x59e6)==bytes.fromhex('3e68cda258')
assert retail(0x0d,0x5a1d,0x5a21)==bytes.fromhex('fe282006')
assert bytes.fromhex('3e02cda258') in retail(0x0d,0x6870,0x68c2)
assert bytes.fromhex('cbc7') in retail(0x0d,0x6870,0x68c2)
assert bytes.fromhex('cbcf') in retail(0x0d,0x6870,0x68c2)
assert bytes.fromhex('cbd7') in retail(0x0d,0x5a86,0x5ac2)
print('[ok] the current source movement-cost field, route-river reference, and phase-analysis flag contracts ROM-locked')
