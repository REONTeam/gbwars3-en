#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys

root = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'baserom.gbc'
rom = rom_path.read_bytes()
if len(rom) != 0x100000:
    raise SystemExit(f'[fail] unexpected ROM size: {len(rom):#x}')

def cut(a, b):
    off = 0x12 * 0x4000 + (a - 0x4000)
    return rom[off:off + b - a]

checks = [
    (0x4329, 0x4351, '585334248b369b78b85f8c9a8b4d49ddb8473bce'),
    (0x4351, 0x43b9, 'c59386791ee88afc288acebea2bafef654be4816'),
    (0x4329, 0x43b9, '4cf9e36dfe6b695c7560789d1b5c76d5734c011c'),
]
for a, b, expected in checks:
    got = hashlib.sha1(cut(a, b)).hexdigest()
    if got != expected:
        raise SystemExit(f'[fail] Bank $12:${a:04X}-${b-1:04X} SHA-1 {got} != {expected}')

src = (root / 'engine/unit/unit_setup.asm').read_text()
consts = (root / 'constants/unit_constants.inc').read_text()
for token in [
    'section "Unit Definition Pair Filters", romx[$4329], bank[$12]',
    'UnitData_CheckLoadingCompatibility::',
    'Unit_CanReceiveSupplyFrom::',
    'ld c, UNIT_DATA_TARGET_CLASS_OFFSET',
    'cp UNIT_TARGET_CLASS_AIR',
    'cp UNIT_TARGET_CLASS_SEA',
    'cp UNIT_TARGET_CLASS_SUBMARINE',
    'ld c, UNIT_DATA_CARRYING_TYPE_OFFSET',
    'ld c, UNIT_DATA_CARRIED_TYPE3_OFFSET',
    'assert @ == $43b9',
]:
    if token not in src:
        raise SystemExit(f'[fail] missing source form: {token}')

for token in [
    'DEF UNIT_DATA_TARGET_CLASS_OFFSET EQU $18',
    'DEF UNIT_TARGET_CLASS_ARMORED     EQU 0',
    'DEF UNIT_TARGET_CLASS_UNARMORED   EQU 1',
    'DEF UNIT_TARGET_CLASS_AIR         EQU 2',
    'DEF UNIT_TARGET_CLASS_SEA         EQU 3',
    'DEF UNIT_TARGET_CLASS_SUBMARINE   EQU 4',
    'DEF UNIT_DATA_CARRYING_TYPE_OFFSET EQU $1a',
    'DEF UNIT_DATA_CARRIED_TYPE1_OFFSET EQU $1b',
    'DEF UNIT_DATA_CARRIED_TYPE2_OFFSET EQU $1c',
    'DEF UNIT_DATA_CARRIED_TYPE3_OFFSET EQU $1d',
]:
    if token not in consts:
        raise SystemExit(f'[fail] missing constant: {token}')

# the current source ended the free-slot routine one byte late in its source assertion.
# Retail confirms $4329 is the first byte (push bc) of this newly sourced block.
if 'assert @ == $4329\n\nsection "Unit Definition Pair Filters"' not in src:
    raise SystemExit('[fail] corrected $4329 boundary not represented')

print('[ok] Bank $12:$4329-$43B8: 144 retail bytes source-backed')
print('[ok] relation comparator subrange: 40 bytes; pair filter: 104 bytes')
print('[ok] UnitData target-class field $18 exposed as armored/unarmored/air/sea/submarine')
print('[ok] fields $1A-$1D remain conservatively relation-oriented pending higher-level caller semantics')
print('[ok] the current source free-slot end boundary corrected from $432A to retail $4329')
