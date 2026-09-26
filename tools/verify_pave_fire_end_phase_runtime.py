#!/usr/bin/env python3
"""Verify FIRE availability, PAVE, selected-map END prep, and aircraft fuel upkeep."""
from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'baserom.gbc'
BUILT = ROOT / 'GBWARS3.gbc'
SYM = ROOT / 'GBWARS3.sym'
EXPECTED_ROM_SHA256 = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
RANGES = (
    (0x0C, 0x4000, 0x40C1, '0aebd9df6271d34bf70d1ffc5b2d688dc161f907'),
    (0x0C, 0x7078, 0x72B4, '518229afb92a4e67a3f9fb3d67120cdfd5b6a258'),
    (0x0C, 0x72B4, 0x72DE, '7092acd6c2a7a0b7f1e27dccac6be934984e3006'),
    (0x0C, 0x72DE, 0x73A5, '4f836b34e1560a4adbd326425a6dde80c503c9c9'),
)
PUBLIC = {
    'UnitAction_CheckFireAvailable': (0x0C, 0x4000),
    'FireTargetList_BuildAttackableUnits': (0x0C, 0x400C),
    'UnitPave_CheckAvailableAtOrAdjacent': (0x0C, 0x7078),
    'UnitPave_GetTerrainCost': (0x0C, 0x70CD),
    'UnitPave_BuildRouteAnalysisWorkspace': (0x0C, 0x70E6),
    'UnitPave_ExecuteSelectedRoute': (0x0C, 0x725F),
    'MapControl_PrepareSelectedMapEndCommand': (0x0C, 0x72B4),
    'UnitPhase_ProcessAircraftFuelUpkeep': (0x0C, 0x72DE),
}
SOURCES = {
    'fire': ROOT / 'engine/battle/battle_fire_availability_4000.asm',
    'pave': ROOT / 'engine/unit/unit_pave_runtime_7078.asm',
    'end': ROOT / 'engine/map/map_control_end_command_72b4.asm',
    'fuel': ROOT / 'engine/unit/unit_aircraft_fuel_upkeep_72de.asm',
    'fire_menu': ROOT / 'engine/unit/unit_action_fire_availability_60f7.asm',
    'pave_menu': ROOT / 'engine/unit/unit_action_pave_availability_60a2.asm',
    'context': ROOT / 'engine/unit/unit_action_context_controller_61da.asm',
    'cursor': ROOT / 'engine/map/bank0b_map_cursor_runtime_52bc.asm',
    'command': ROOT / 'engine/map/ai/map_control_selected_map_command_controller_7226.asm',
}

def fail(msg):
    raise SystemExit('FAIL: ' + msg)

def bank_slice(blob, bank, start, end):
    off = bank * 0x4000 + (start - 0x4000)
    return blob[off:off + end - start]

for p in (BASE, BUILT, SYM, *SOURCES.values()):
    if not p.is_file():
        fail(f'missing {p.relative_to(ROOT)}')
retail = BASE.read_bytes()
built = BUILT.read_bytes()
for bank, start, end, sha1 in RANGES:
    expected = bank_slice(retail, bank, start, end)
    actual = bank_slice(built, bank, start, end)
    if hashlib.sha1(expected).hexdigest() != sha1:
        fail(f'retail fingerprint mismatch ${bank:02X}:${start:04X}-${end-1:04X}')
    if actual != expected:
        fail(f'linked byte drift ${bank:02X}:${start:04X}-${end-1:04X}')
if hashlib.sha256(built).hexdigest() != EXPECTED_ROM_SHA256:
    fail('custom-English ROM hash drift')

fire = SOURCES['fire'].read_text(encoding='utf-8')
for token in ('UnitAction_CheckFireAvailable::', 'FireTargetList_BuildAttackableUnits::',
              'Battle_SelectWeaponAttackIgnoringAmmo', 'wFireAvailabilityTargetIDs',
              'assert @ == $40c1'):
    if token not in fire:
        fail(f'missing FIRE availability contract: {token}')

pave = SOURCES['pave'].read_text(encoding='utf-8')
for token in ('UnitPave_CheckAvailableAtOrAdjacent::', 'UnitPave_GetTerrainCost::',
              'UnitPave_BuildRouteAnalysisWorkspace::', 'UnitPave_ExecuteSelectedRoute::',
              'MOVEMENT_TERRAIN_PLAIN', 'MOVEMENT_TERRAIN_WOOD', 'MOVEMENT_TERRAIN_WASTELAND',
              'MAP_TERRAIN_ROAD', 'CampaignStats_IncrementDevelopedProperties'):
    if token not in pave:
        fail(f'missing PAVE contract: {token}')

end = SOURCES['end'].read_text(encoding='utf-8')
if 'MapControl_PrepareSelectedMapEndCommand::' not in end or 'assert @ == $72de' not in end:
    fail('selected-map END preparation boundary/entry missing')

fuel = SOURCES['fuel'].read_text(encoding='utf-8')
for token in ('UnitPhase_ProcessAircraftFuelUpkeep::', 'UNIT_TARGET_CLASS_AIR',
              'MOVEMENT_TERRAIN_AIRPORT', 'MOVEMENT_TERRAIN_RUNWAY',
              'Unit_DestroyWithMapAnimation', 'assert @ == $73a5'):
    if token not in fuel:
        fail(f'missing aircraft-fuel contract: {token}')

if 'farcall $0c, UnitAction_CheckFireAvailable' not in SOURCES['fire_menu'].read_text(encoding='utf-8'):
    fail('FIRE availability menu caller is not symbolic')
if 'farcall $0c, UnitPave_CheckAvailableAtOrAdjacent' not in SOURCES['pave_menu'].read_text(encoding='utf-8'):
    fail('PAVE availability menu caller is not symbolic')
if 'farcall $0c, UnitPave_ExecuteSelectedRoute' not in SOURCES['context'].read_text(encoding='utf-8'):
    fail('PAVE executor caller is not symbolic')
if 'farcall $0c, UnitPave_BuildRouteAnalysisWorkspace' not in SOURCES['cursor'].read_text(encoding='utf-8'):
    fail('PAVE analysis caller is not symbolic')
if 'farcall $0c, MapControl_PrepareSelectedMapEndCommand' not in SOURCES['command'].read_text(encoding='utf-8'):
    fail('selected-map END preparation caller is not symbolic')

# The old numeric action filenames should not survive as authoritative owners.
for obsolete in ('engine/unit/unit_action_09_availability_60f7.asm',
                 'engine/unit/unit_action_14_availability_60a2.asm'):
    if (ROOT / obsolete).exists():
        fail(f'obsolete numeric action source remains: {obsolete}')

sym = SYM.read_text(encoding='utf-8', errors='replace')
for name, (bank, addr) in PUBLIC.items():
    if not re.search(rf'(?mi)^{bank:02x}:{addr:04x}\s+{re.escape(name)}$', sym):
        fail(f'{name} is not linked at ${bank:02X}:${addr:04X}')

print('FIRE availability + PAVE + END/aircraft-fuel runtime verification: PASS')
print('  $0C:$4000-$40C0: 193 bytes FIRE availability target scan')
print('  $0C:$7078-$72B3: 572 bytes PAVE availability/analysis/execution')
print('  $0C:$72B4-$72DD: 42 bytes selected-map END preparation')
print('  $0C:$72DE-$73A4: 199 bytes aircraft fuel upkeep')
print('  total newly explicit bytes: 1006')
print(f'  linked ROM SHA-256: {EXPECTED_ROM_SHA256}')
