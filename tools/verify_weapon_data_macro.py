#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
UNIT = ROOT / 'engine/unit/unit.asm'
MACROS = ROOT / 'macros/unit_macros.inc'
CONSTANTS = ROOT / 'constants/unit_constants.inc'
CHARMAP = ROOT / 'charmaps/char_unit.inc'

EXPECTED_COUNT = 33
EXPECTED_RECORD_SIZE = 0x10
EXPECTED_NAME_LEN = 8
EXPECTED_SHA1 = 'b68642066c77923ca6895eb595c35c99ed1aa42e'


def require(cond, msg):
    if not cond:
        raise SystemExit(f'[fail] {msg}')


def parse_def(text, name):
    m = re.search(rf'^DEF\s+{re.escape(name)}\s+EQU\s+([^;\n]+)', text, re.M)
    require(m, f'missing {name}')
    v = m.group(1).strip()
    return int(v[1:], 16) if v.startswith('$') else int(v, 0)

const = CONSTANTS.read_text(encoding='utf-8')
expected_offsets = {
    'WEAPON_DATA_MIN_RANGE_OFFSET': 0x08,
    'WEAPON_DATA_MAX_RANGE_OFFSET': 0x09,
    'WEAPON_DATA_ATTACK_ARMORED_OFFSET': 0x0A,
    'WEAPON_DATA_ATTACK_UNARMORED_OFFSET': 0x0B,
    'WEAPON_DATA_ATTACK_AIR_OFFSET': 0x0C,
    'WEAPON_DATA_ATTACK_SEA_OFFSET': 0x0D,
    'WEAPON_DATA_ATTACK_SUBMARINE_OFFSET': 0x0E,
    'WEAPON_DATA_COST_PER_SHOT_OFFSET': 0x0F,
}
for name, value in expected_offsets.items():
    require(parse_def(const, name) == value, f'{name} changed')
require(parse_def(const, 'WEAPON_DATA_TARGET_VALUES_COUNT') == 5, 'target-family count changed')

macro = MACROS.read_text(encoding='utf-8')
start = macro.index('macro weapon_data')
end = macro.index('endm', start)
body = macro[start:end]
require('rept WEAPON_DATA_RECORD_SIZE - WEAPON_DATA_NAME_LENGTH' not in body,
        'weapon_data still uses anonymous repeated numeric tail')
for phrase in ('minimum range', 'maximum range', 'attack: armored', 'attack: unarmored',
               'attack: air', 'attack: sea', 'attack: submarine', 'cost per shot'):
    require(phrase in body, f'weapon_data missing semantic field comment: {phrase}')
require(body.count('shift') == 8, 'weapon_data does not consume exactly eight numeric arguments')

# Build active charmap for the customized English names.
charmap = {}
for line in CHARMAP.read_text(encoding='utf-8').splitlines():
    m = re.match(r'charmap\s+"([^"]+)",\s*\$([0-9a-fA-F]{2})', line)
    if m:
        charmap[m.group(1)] = int(m.group(2), 16)
keys = sorted(charmap, key=len, reverse=True)

def encode(text):
    out=[]; i=0
    while i < len(text):
        for key in keys:
            if text.startswith(key, i):
                out.append(charmap[key]); i += len(key); break
        else:
            raise SystemExit(f'[fail] no charmap token for {text[i:]!r}')
    return out

unit = UNIT.read_text(encoding='utf-8')
ptr = unit[unit.index('WeaponData:'):unit.index('WeaponDataRecords::')]
pointers = re.findall(r'^\s*dw\s+(\.[A-Za-z0-9_]+)\s*$', ptr, re.M)
require(len(pointers) == EXPECTED_COUNT, f'expected {EXPECTED_COUNT} pointers, found {len(pointers)}')
records = unit[unit.index('WeaponDataRecords::'):unit.index('section_end $54a8')]
rows = re.findall(r'^\s*(\.[A-Za-z0-9_]+):\s+weapon_data\s+"([^"]*)",\s*([^;\n]+)', records, re.M)
require(len(rows) == EXPECTED_COUNT, f'expected {EXPECTED_COUNT} rows, found {len(rows)}')
require([r[0] for r in rows] == pointers, 'pointer/record order mismatch')

blob=bytearray()
for label, name, nums in rows:
    enc = encode(name)
    require(len(enc) == EXPECTED_NAME_LEN, f'{label} name length changed')
    vals = [x.strip() for x in nums.split(',') if x.strip()]
    require(len(vals) == 8, f'{label} should have 8 numeric fields')
    parsed=[]
    for x in vals:
        n = int(x[1:],16) if x.startswith('$') else int(x,0)
        require(0 <= n <= 0xff, f'{label} out-of-range value {x}')
        parsed.append(n)
    min_r,max_r,*rest = parsed
    require(min_r <= max_r or (min_r == 0 and max_r == 0), f'{label} has inverted range')
    blob.extend(enc); blob.extend(parsed)

require(len(blob) == EXPECTED_COUNT * EXPECTED_RECORD_SIZE, 'WeaponData payload size changed')
sha1=hashlib.sha1(blob).hexdigest()
require(sha1 == EXPECTED_SHA1, f'WeaponData payload changed: {sha1}')
require((ROOT / 'docs/battle/weapon_data_schema.md').exists(), 'schema document missing')
print(f'[ok] {EXPECTED_COUNT} semantic WeaponData records / {len(blob)} bytes')
print(f'[ok] WeaponData SHA-1 {sha1}')
print('[ok] min/max range, five target-family attacks, and per-shot cost are explicit macro fields')
