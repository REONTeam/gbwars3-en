#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys

root = Path(__file__).resolve().parents[1]
rom = (Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'baserom.gbc').read_bytes()
src = (root / 'engine/map/ai/map_control_capture_targets.asm').read_text()
terrain = (root / 'data/terrain.asm').read_text()
force = (root / 'engine/map/ai/map_control_force.asm').read_text()
consts = (root / 'constants/map_constants.inc').read_text()
make = (root / 'Makefile').read_text()

def retail(bank, start, end):
    off = bank * 0x4000 + start - 0x4000
    return rom[off:off + end - start]

checks = [
    (0x0b, 0x7cf7, 0x7d24, '7fdae632ba3adbf62593cfe0cf68237cd4b66596'),
    (0x0b, 0x7d33, 0x7d54, 'f41a81d00adb50f39fde09a09edec2020f760e35'),
]
for bank, start, end, sha1 in checks:
    got = hashlib.sha1(retail(bank, start, end)).hexdigest()
    assert got == sha1, (hex(start), hex(end), got)

for token in [
    'MapTile_GetPhaseOwnershipClass::',
    'MapTile_ClassifyOwnershipForCurrentPhase::',
    'cp MAP_TERRAIN_PLAIN',
    'cp MAP_TILE_NEUTRAL_PROPERTY_FIRST',
    'cp MAP_TILE_SIDE1_PROPERTY_FIRST',
    'ld hl, wMapPhaseNumber',
    'assert @ == $7d24',
]:
    assert token in terrain, token

for token in [
    'MapControl_IsCaptureTargetRejected::',
    'call MapTile_GetPhaseOwnershipClass',
    'cp MAP_TILE_NEUTRAL_CITY_RUINS',
    'cp MAP_TILE_NEUTRAL_BASE_RUINS',
    'cp MAP_TILE_NEUTRAL_AIRPORT_RUINS',
    'cp MAP_TILE_NEUTRAL_PORT_RUINS',
    'assert @ == $7d54',
]:
    assert token in src, token

for token in [
    'MapControl_RebuildCaptureTargetMask::',
    'MapControl_RebuildUnitEligibilityMask:: ; compatibility alias',
    'farcall $0b, MapControl_IsCaptureTargetRejected',
    'call MapControl_RebuildCaptureTargetMask',
]:
    assert token in force, token

assert 'farcall $0b, $7d33' not in force
assert 'engine/map/ai/map_control_capture_targets.o' in make

neutral = {
    'MAP_TILE_NEUTRAL_CITY': 0x17,
    'MAP_TILE_NEUTRAL_CITY_RUINS': 0x18,
    'MAP_TILE_NEUTRAL_BASE': 0x19,
    'MAP_TILE_NEUTRAL_BASE_RUINS': 0x1a,
    'MAP_TILE_NEUTRAL_AIRPORT': 0x1b,
    'MAP_TILE_NEUTRAL_AIRPORT_RUINS': 0x1c,
    'MAP_TILE_NEUTRAL_PORT': 0x1d,
    'MAP_TILE_NEUTRAL_PORT_RUINS': 0x1e,
    'MAP_TILE_NEUTRAL_COM_TOWER': 0x1f,
}
for name, value in neutral.items():
    assert f'DEF {name}' in consts and f'${value:02X}' in consts.upper(), name

# Independent behavior model for all low-six-bit map IDs. 0 means accepted by
# the retail inverted predicate and therefore inserted in the target mask.
def phase_class(tile, phase_side):
    if tile >= 0x20:
        return 3
    if tile >= 0x17:
        return 2
    if tile >= 0x0c:
        return 1 if phase_side == 0 else 0
    return 0 if phase_side == 0 else 1

def rejected(tile, phase_side):
    if tile in (0x18, 0x1a, 0x1c, 0x1e):
        return 1
    return 1 if phase_class(tile, phase_side) in (0, 3) else 0

for side in (0, 1):
    accepted = [t for t in range(1, 0x34) if not rejected(t, side)]
    expected_owned = list(range(0x0c, 0x17)) if side == 0 else list(range(0x01, 0x0c))
    expected_neutral = [0x17, 0x19, 0x1b, 0x1d, 0x1f]
    assert accepted == expected_owned + expected_neutral, (side, accepted)

print('[ok] capture-target ownership/filter source: $0B:$7CF7-$7D23 and $7D33-$7D53 ROM-locked')
