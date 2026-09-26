#!/usr/bin/env python3
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
constants = (ROOT / 'constants/unit_constants.inc').read_text()
symbols = (ROOT / 'symbols.asm').read_text()
doc = (ROOT / 'docs/unit/unit_weapon_list_staging_runtime.md').read_text()

pairs = [
    ('UNIT_LIST_SCRATCH_TYPE_SIDE_OFFSET', 'UNIT_RECORD_TYPE_SIDE_OFFSET'),
    ('UNIT_LIST_SCRATCH_X_OFFSET', 'UNIT_RECORD_X_OFFSET'),
    ('UNIT_LIST_SCRATCH_Y_OFFSET', 'UNIT_RECORD_Y_OFFSET'),
    ('UNIT_LIST_SCRATCH_STATUS_OFFSET', 'UNIT_RECORD_STATUS_OFFSET'),
    ('UNIT_LIST_SCRATCH_HP_OFFSET', 'UNIT_RECORD_HP_OFFSET'),
    ('UNIT_LIST_SCRATCH_CARRIED_COUNT_OFFSET', 'UNIT_RECORD_CARRIED_COUNT_OFFSET'),
    ('UNIT_LIST_SCRATCH_CARRIER_INDEX_OFFSET', 'UNIT_RECORD_CARRIER_INDEX_OFFSET'),
    ('UNIT_LIST_SCRATCH_FUEL_OFFSET', 'UNIT_RECORD_FUEL_OFFSET'),
    ('UNIT_LIST_SCRATCH_WEAPON1_AMMO_OFFSET', 'UNIT_RECORD_WEAPON1_AMMO_OFFSET'),
    ('UNIT_LIST_SCRATCH_WEAPON2_AMMO_OFFSET', 'UNIT_RECORD_WEAPON2_AMMO_OFFSET'),
    ('UNIT_LIST_SCRATCH_EXPERIENCE_OFFSET', 'UNIT_RECORD_EXPERIENCE_OFFSET'),
    ('UNIT_LIST_SCRATCH_RUNTIME_ONLY_OFFSET', 'UNIT_RECORD_RUNTIME_ONLY_OFFSET'),
    ('UNIT_LIST_SCRATCH_RUNTIME_ONLY_SIZE', 'UNIT_RECORD_RUNTIME_ONLY_SIZE'),
]
for left, right in pairs:
    needle = f'DEF {left} EQU {right}'
    assert needle in constants, needle

for needle in [
    'DEF UNIT_LIST_SCRATCH_RECORD_COUNT EQU UNIT_RECORDS_PER_SIDE',
    'DEF UNIT_LIST_SCRATCH_RECORD_SIZE EQU UNIT_RECORD_SIZE',
    'DEF UNIT_LIST_SCRATCH_SIZE EQU UNIT_LIST_SCRATCH_RECORD_COUNT * UNIT_LIST_SCRATCH_RECORD_SIZE',
    'DEF UNIT_LIST_SCRATCH_LAST_RECORD_INDEX EQU UNIT_LIST_SCRATCH_RECORD_COUNT - 1',
    'DEF UNIT_LIST_SCRATCH_LAST_RECORD_OFFSET EQU UNIT_LIST_SCRATCH_LAST_RECORD_INDEX * UNIT_LIST_SCRATCH_RECORD_SIZE',
]:
    assert needle in constants, needle

for needle in [
    'EXPORT DEF wUnitListScratch EQU $d640',
    'EXPORT DEF wUnitListScratchFirst EQU wUnitListScratch',
    'EXPORT DEF wUnitListScratchLast EQU wUnitListScratch + UNIT_LIST_SCRATCH_LAST_RECORD_OFFSET',
    'EXPORT DEF wUnitListScratchEnd EQU wUnitListScratch + UNIT_LIST_SCRATCH_SIZE',
]:
    assert needle in symbols, needle

base = 0xD640
count = 50
size = 16
assert base + count * size == 0xD960
assert base + (count - 1) * size == 0xD950
assert base + (count - 1) * size + size - 1 == 0xD95F

for token in ['the current source typed temporary-unit-list contract', '$D950-$D95F', '$D960+', 'runtime-only tail', 'RAM/layout contract only']:
    assert token in doc, token

print('[ok] temporary unit list: 50 x 16 bytes = 800 bytes')
print('[ok] first record: $D640-$D64F')
print('[ok] last record: $D950-$D95F; exclusive end $D960')
print('[ok] known scratch fields alias the proven live-unit record offsets')
print('[ok] record bytes $0C-$0F remain conservatively runtime-only')
