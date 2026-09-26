#!/usr/bin/env python3
from pathlib import Path

symbols = Path('symbols.asm').read_text()
constants = Path('constants/unit_constants.inc').read_text()
doc = Path('docs/battle/battle_combat_math_runtime.md').read_text()

for needle in [
    'sym $13, $4861, Battle_GetCoverValue',
    'sym $13, $486d, Battle_CoverValueTable',
]:
    assert needle in symbols, needle

for needle in [
    'DEF MOVEMENT_DATA_PROFILE_SIZE EQU 23',
    'DEF BATTLE_COVER_CLASS_COUNT EQU MOVEMENT_DATA_PROFILE_SIZE',
    'DEF BATTLE_COVER_VALUE_TABLE_SIZE EQU BATTLE_COVER_CLASS_COUNT',
    'DEF BATTLE_COVER_CLASS_00 EQU 0',
    'DEF BATTLE_COVER_CLASS_01 EQU 1',
    'DEF BATTLE_COVER_CLASS_CITY EQU MOVEMENT_TERRAIN_CITY',
    'DEF BATTLE_COVER_CLASS_SHOAL EQU MOVEMENT_TERRAIN_SHOAL',
]:
    assert needle in constants, needle

assert 0x486D - 0x4861 == 12
assert 0x4884 - 0x486D == 23

# Classes 2-22 must be explicit aliases of the already-proven movement terrain
# namespace; the first two are deliberately positional and must not be aliased.
pairs = [
    ('CITY', 'CITY'), ('CITY_RUINS', 'CITY_RUINS'),
    ('BASE', 'BASE'), ('BASE_RUINS', 'BASE_RUINS'),
    ('AIRPORT', 'AIRPORT'), ('AIRPORT_RUINS', 'AIRPORT_RUINS'),
    ('RUNWAY', 'RUNWAY'), ('PORT', 'PORT'), ('PORT_RUINS', 'PORT_RUINS'),
    ('COM_TOWER', 'COM_TOWER'), ('PLAIN', 'PLAIN'), ('ROAD', 'ROAD'),
    ('BRIDGE_1', 'BRIDGE_1'), ('BRIDGE_2', 'BRIDGE_2'),
    ('MOUNTAIN', 'MOUNTAIN'), ('WOOD', 'WOOD'), ('WASTELAND', 'WASTELAND'),
    ('DESERT', 'DESERT'), ('RIVER', 'RIVER'), ('SEA', 'SEA'), ('SHOAL', 'SHOAL'),
]
for cover, movement in pairs:
    needle = f'DEF BATTLE_COVER_CLASS_{cover} EQU MOVEMENT_TERRAIN_{movement}'
    assert needle in constants, needle

assert 'BATTLE_COVER_CLASS_00 EQU MOVEMENT_TERRAIN_HQ_0' not in constants
assert 'BATTLE_COVER_CLASS_01 EQU MOVEMENT_TERRAIN_HQ_1' not in constants

for phrase in [
    'exactly **23 bytes**',
    'source-backed movement namespace has two HQ variants',
    'does not alias those first two classes',
    'values not yet imported',
]:
    assert phrase in doc, phrase

print('[ok] Cover lookup anchor: $13:$4861-$486C')
print('[ok] Cover table geometry: $13:$486D-$4883 = 23 bytes')
print('[ok] Cover classes 2-22 align with proven movement terrain classes')
print('[ok] Cover classes 0-1 remain intentionally positional/unresolved')
print('[ok] Cover bytes remain overlay-owned')
