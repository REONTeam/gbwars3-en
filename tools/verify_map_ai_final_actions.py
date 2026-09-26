#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'baserom.gbc'
rom = ROM.read_bytes()

def chunk(bank, start, end):
    off = bank * 0x4000 + (start - 0x4000)
    return rom[off:off + end - start]

checks = [
    (0x0d, 0x6183, 0x6325, '44b3b5a151a5f74d884d623ae3d7a0ddf16f17e9', 'bridge/direct-attack planners'),
    (0x0d, 0x469f, 0x46b7, '4eaed8b50ad3d2939787a583f8feb4fe8c30c777', 'bridge action staging'),
    (0x0d, 0x471d, 0x4749, '3e5887adf16bfb7b599359d270ab7decf1c6728b', 'direct attack staging'),
    (0x0b, 0x4bf2, 0x4c18, '2d8dc123de5e1736ba436b85f35d2df877c36833', 'bridge construction executor'),
    (0x0c, 0x43cf, 0x4488, '07f1e438ac02855c23475a824cfa6079f8c7e6f5', 'direct battle executor'),
]
for bank, start, end, expected, name in checks:
    data = chunk(bank, start, end)
    got = hashlib.sha1(data).hexdigest()
    assert got == expected, f'{name}: {got} != {expected}'
    print(f'[ok] {name}: ${bank:02X}:${start:04X}-${end-1:04X}, {len(data)} bytes, sha1 {got}')

planner = (ROOT/'engine/map/ai/map_ai_bridge_attack_planning.asm').read_text()
for token in [
    'MapAI_PlanBridgeConstruction::', 'MapAI_PlanDirectAttackFamily0::',
    'MapAI_PlanDirectAttackFamily1::', 'assert @ == $6325',
]: assert token in planner, token

bridge = (ROOT/'engine/unit/unit_bridge_action.asm').read_text()
for token in [
    'Unit_BuildBridgeAtCoordinates::', 'UNIT_RECORD_WEAPON1_AMMO_OFFSET',
    'sub 2', 'MAP_TERRAIN_BRIDGE_1', 'MapTile_SetBaseIdAtCoordinates',
    'CampaignStats_IncrementDevelopedProperties', 'assert @ == $4c18',
]: assert token in bridge, token

attack = (ROOT/'engine/battle/battle_direct_attack.asm').read_text()
for token in ['Battle_ExecuteDirectUnitAttack::', 'assert @ == $4488']:
    assert token in attack, token

stage = (ROOT/'engine/map/ai/map_ai_bridge_attack_execution.asm').read_text()
for token in [
    'MapAI_ExecuteBridgeConstruction::', 'Unit_BuildBridgeAtCoordinates',
    'MapAI_ExecuteDirectAttack::', 'Battle_ExecuteDirectUnitAttack',
    'assert @ == $46b7', 'assert @ == $4749',
]: assert token in stage, token

dispatch = (ROOT/'engine/map/ai/map_ai_action_dispatch.asm').read_text()
for token in [
    'dw MapAI_ActionMove', 'dw MapAI_ActionCaptureProperty', 'dw MapAI_ActionDevelopTerrain',
    'dw MapAI_ActionDirectAttack', 'dw MapAI_ActionBuildBridge', 'dw MapAI_ActionAreaAttack',
    'dw MapAI_ActionLoadIntoCarrier', 'MapAI_ActionHandler0:: ; compatibility alias',
    'MapAI_ActionHandler3:: ; compatibility alias', 'MapAI_ActionHandler4:: ; compatibility alias',
]: assert token in dispatch, token

constants = (ROOT/'constants/map_constants.inc').read_text()
expected = {
    'MAP_AI_ACTION_MOVE': 0, 'MAP_AI_ACTION_CAPTURE_PROPERTY': 1,
    'MAP_AI_ACTION_DEVELOP_TERRAIN': 2, 'MAP_AI_ACTION_DIRECT_ATTACK': 3,
    'MAP_AI_ACTION_BUILD_BRIDGE': 4, 'MAP_AI_ACTION_AREA_ATTACK': 5,
    'MAP_AI_ACTION_LOAD_INTO_CARRIER': 6, 'MAP_AI_ACTION_COUNT': 7,
}
for name, value in expected.items():
    assert re.search(rf'DEF\s+{name}\s+EQU\s+{value}\b', constants), name

# Producer-side proof points in retail: bridge planner compares decoded unit type 4
# (Construction Truck), requires first ammo >= 2, then writes action 4 only when
# hex distance to the River reference is exactly 1. The adjacent fallback writes 0.
r = chunk(0x0d, 0x6183, 0x6235)
for seq in [bytes.fromhex('cb3ffe04'), bytes.fromhex('0e08cd0b09fe0238'), bytes.fromhex('fe01200e3e04ea ecc5'.replace(' ','')), bytes.fromhex('3e00ea ecc5'.replace(' ',''))]:
    assert seq in r, seq.hex()
# Bridge executor consumes two ammo and writes map terrain $22 (BRIDGE_1).
b = chunk(0x0b, 0x4bf2, 0x4c18)
assert bytes.fromhex('fae5ccd602eae5cc') in b
assert bytes.fromhex('3e22cd7647') in b

# Direct-attack staging passes active/target IDs in D/E into Bank $0C:$43CF.
a = chunk(0x0d, 0x471d, 0x4749)
assert bytes.fromhex('fad8c957faefc55fef0ccf43') in a

print('[ok] the current source complete map-AI action identity contract')
