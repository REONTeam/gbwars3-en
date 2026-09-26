#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
UNIT = ROOT / 'engine/unit/unit.asm'
CONSTANTS = ROOT / 'constants/unit_constants.inc'
MACROS = ROOT / 'macros/unit_macros.inc'
CHARMAP = ROOT / 'charmaps/char_unit.inc'

EXPECTED_WEAPON_COUNT = 33
EXPECTED_WEAPON_RECORD_SIZE = 0x10
EXPECTED_WEAPON_NAME_LENGTH = 8
EXPECTED_WEAPON_SHA1 = 'b68642066c77923ca6895eb595c35c99ed1aa42e'
EXPECTED_WEAPON_START = 0x5256
EXPECTED_WEAPON_END = 0x54A8

EXPECTED_MOVEMENT_COUNT = 15
EXPECTED_MOVEMENT_PROFILE_SIZE = 23
EXPECTED_MOVEMENT_SHA1 = '4f2a657c0be8d1aaf6e369e0cc5600e4f5a6651f'
EXPECTED_MOVEMENT_START = 0x54A8
EXPECTED_MOVEMENT_DATA_END = 0x561F


def require(cond, msg):
    if not cond:
        raise SystemExit(f'[fail] {msg}')


def parse_def(text, name):
    m = re.search(rf'^DEF\s+{re.escape(name)}\s+EQU\s+([^;\n]+)', text, re.M)
    require(m, f'missing constant {name}')
    value = m.group(1).strip()
    if value.startswith('$'):
        return int(value[1:], 16)
    return int(value, 0)

const = CONSTANTS.read_text(encoding='utf-8')
for name, expected in {
    'WEAPON_DATA_COUNT': EXPECTED_WEAPON_COUNT,
    'WEAPON_DATA_RECORD_SIZE': EXPECTED_WEAPON_RECORD_SIZE,
    'WEAPON_DATA_NAME_LENGTH': EXPECTED_WEAPON_NAME_LENGTH,
    'WEAPON_DATA_MIN_RANGE_OFFSET': 0x08,
    'WEAPON_DATA_MAX_RANGE_OFFSET': 0x09,
    'WEAPON_DATA_TARGET_VALUES_OFFSET': 0x0A,
    'WEAPON_DATA_TARGET_VALUES_COUNT': 5,
    'WEAPON_DATA_COST_OFFSET': 0x0F,
    'MOVEMENT_DATA_PROFILE_COUNT': EXPECTED_MOVEMENT_COUNT,
    'MOVEMENT_DATA_PROFILE_SIZE': EXPECTED_MOVEMENT_PROFILE_SIZE,
}.items():
    require(parse_def(const, name) == expected, f'{name} changed')

macro_text = MACROS.read_text(encoding='utf-8')
require('macro weapon_data' in macro_text, 'weapon_data macro missing')
weapon_macro = macro_text[macro_text.index('macro weapon_data'):]
weapon_macro = weapon_macro[:weapon_macro.index('endm')]
require(weapon_macro.count('shift') == EXPECTED_WEAPON_RECORD_SIZE - EXPECTED_WEAPON_NAME_LENGTH,
        'weapon_data does not consume the fixed eight numeric fields')
for phrase in ('minimum range', 'maximum range', 'attack: armored', 'attack: unarmored',
               'attack: air', 'attack: sea', 'attack: submarine', 'cost per shot'):
    require(phrase in weapon_macro, f'weapon_data missing semantic field comment: {phrase}')
require('macro movement_profile' in macro_text, 'movement_profile macro missing')
movement_macro = macro_text[macro_text.index('macro movement_profile'):]
movement_macro = movement_macro[:movement_macro.index('endm')]
require('rept' not in movement_macro, 'movement_profile unexpectedly uses an opaque rept body')
require(movement_macro.count('db \\1') == EXPECTED_MOVEMENT_PROFILE_SIZE,
        'movement_profile does not expose all 23 terrain columns explicitly')
require(movement_macro.count('shift') == EXPECTED_MOVEMENT_PROFILE_SIZE,
        'movement_profile does not consume all 23 terrain arguments')

unit = UNIT.read_text(encoding='utf-8')
require('assert @ - WeaponData == WEAPON_DATA_COUNT * 2' in unit,
        'WeaponData pointer-table assertion missing')
require('assert @ - WeaponDataRecords == WEAPON_DATA_COUNT * WEAPON_DATA_RECORD_SIZE' in unit,
        'WeaponData record assertion missing')
require('assert @ - MovementData == MOVEMENT_DATA_PROFILE_COUNT * 2' in unit,
        'MovementData pointer-table assertion missing')
require('assert @ - MovementDataProfiles == MOVEMENT_DATA_PROFILE_COUNT * MOVEMENT_DATA_PROFILE_SIZE' in unit,
        'MovementData profile assertion missing')

# Active unit charmap protects custom English weapon strings as encoded bytes.
charmap = {}
for line in CHARMAP.read_text(encoding='utf-8').splitlines():
    m = re.match(r'charmap\s+"([^"]+)",\s*\$([0-9a-fA-F]{2})', line)
    if m:
        charmap[m.group(1)] = int(m.group(2), 16)
keys = sorted(charmap, key=len, reverse=True)


def encode(text):
    out = []
    i = 0
    while i < len(text):
        for key in keys:
            if text.startswith(key, i):
                out.append(charmap[key])
                i += len(key)
                break
        else:
            raise SystemExit(f'[fail] no unit charmap token for {text[i:]!r}')
    return out

# Weapon pointer and record layers.
ptr_block = unit[unit.index('WeaponData:'):unit.index('WeaponDataRecords::')]
pointers = re.findall(r'^\s*dw\s+(\.[A-Za-z0-9_]+)\s*$', ptr_block, re.M)
require(len(pointers) == EXPECTED_WEAPON_COUNT,
        f'expected {EXPECTED_WEAPON_COUNT} WeaponData pointers, found {len(pointers)}')

record_block = unit[unit.index('WeaponDataRecords::'):unit.index('section_end $54a8')]
rows = re.findall(r'^\s*(\.[A-Za-z0-9_]+):\s+weapon_data\s+"([^"]*)",\s*([^;\n]+)', record_block, re.M)
require(len(rows) == EXPECTED_WEAPON_COUNT,
        f'expected {EXPECTED_WEAPON_COUNT} weapon_data rows, found {len(rows)}')
require([row[0] for row in rows] == pointers, 'WeaponData pointer order no longer matches record order')

weapon_blob = bytearray()
for label, display_name, numeric_text in rows:
    name_bytes = encode(display_name)
    require(len(name_bytes) == EXPECTED_WEAPON_NAME_LENGTH,
            f'{label} name encodes to {len(name_bytes)} bytes')
    values = [v.strip() for v in numeric_text.split(',') if v.strip()]
    require(len(values) == EXPECTED_WEAPON_RECORD_SIZE - EXPECTED_WEAPON_NAME_LENGTH,
            f'{label} has {len(values)} numeric bytes')
    weapon_blob.extend(name_bytes)
    for value in values:
        n = int(value[1:], 16) if value.startswith('$') else int(value, 0)
        require(0 <= n <= 0xFF, f'{label} value out of range: {value}')
        weapon_blob.append(n)

weapon_sha1 = hashlib.sha1(weapon_blob).hexdigest()
require(weapon_sha1 == EXPECTED_WEAPON_SHA1,
        f'custom WeaponData bytes changed: {weapon_sha1} != {EXPECTED_WEAPON_SHA1}')
require(EXPECTED_WEAPON_START + EXPECTED_WEAPON_COUNT * 2 + len(weapon_blob) == EXPECTED_WEAPON_END,
        'WeaponData geometry no longer reaches $54A8')

# Movement pointer and profile layers.
move_ptr_block = unit[unit.index('MovementData:'):unit.index('MovementDataProfiles::')]
move_pointers = re.findall(r'^\s*dw\s+(\.Profile\d\d)\s*$', move_ptr_block, re.M)
require(len(move_pointers) == EXPECTED_MOVEMENT_COUNT,
        f'expected {EXPECTED_MOVEMENT_COUNT} MovementData pointers, found {len(move_pointers)}')
expected_labels = [f'.Profile{i:02d}' for i in range(EXPECTED_MOVEMENT_COUNT)]
require(move_pointers == expected_labels, 'MovementData profile pointers are not in stable Profile00-Profile14 order')

move_block = unit[unit.index('MovementDataProfiles::'):unit.index('section_end $8000')]
move_rows = re.findall(r'^(\.Profile\d\d):\s+movement_profile\s+([^\n]+)$', move_block, re.M)
require(len(move_rows) == EXPECTED_MOVEMENT_COUNT,
        f'expected {EXPECTED_MOVEMENT_COUNT} movement profiles, found {len(move_rows)}')
require([r[0] for r in move_rows] == expected_labels, 'MovementData record order changed')

movement_blob = bytearray()
for label, numeric_text in move_rows:
    values = [v.strip() for v in numeric_text.split(',') if v.strip()]
    require(len(values) == EXPECTED_MOVEMENT_PROFILE_SIZE,
            f'{label} has {len(values)} values; expected {EXPECTED_MOVEMENT_PROFILE_SIZE}')
    for value in values:
        n = int(value[1:], 16) if value.startswith('$') else int(value, 0)
        require(0 <= n <= 0xFF, f'{label} value out of range: {value}')
        movement_blob.append(n)

movement_sha1 = hashlib.sha1(movement_blob).hexdigest()
require(movement_sha1 == EXPECTED_MOVEMENT_SHA1,
        f'MovementData bytes changed: {movement_sha1} != {EXPECTED_MOVEMENT_SHA1}')
require(EXPECTED_MOVEMENT_START + EXPECTED_MOVEMENT_COUNT * 2 + len(movement_blob) == EXPECTED_MOVEMENT_DATA_END,
        'MovementData geometry no longer reaches $561F')

print(f'[ok] {EXPECTED_WEAPON_COUNT} WeaponData pointers / fixed {EXPECTED_WEAPON_RECORD_SIZE}-byte records')
print(f'[ok] WeaponData bytes: {len(weapon_blob)} bytes, SHA-1 {weapon_sha1}')
print('[ok] custom English weapon names protected through active unit charmap encoding')
print(f'[ok] {EXPECTED_MOVEMENT_COUNT} MovementData pointers / fixed {EXPECTED_MOVEMENT_PROFILE_SIZE}-byte profiles')
print(f'[ok] MovementData bytes: {len(movement_blob)} bytes, SHA-1 {movement_sha1}')
print('[ok] Bank $12 support-data geometry remains WeaponData $5256-$54A7, MovementData $54A8-$561E')
