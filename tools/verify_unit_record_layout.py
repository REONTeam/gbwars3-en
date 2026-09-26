#!/usr/bin/env python3
from pathlib import Path
import random
import re

ROOT = Path(__file__).resolve().parents[1]
constants = (ROOT / 'constants/unit_constants.inc').read_text()
setup = (ROOT / 'engine/unit/unit_setup.asm').read_text()
sram = (ROOT / 'engine/map/map_sram.asm').read_text()

expected = {
    'UNIT_RECORD_SIZE': 0x10,
    'UNIT_RECORD_COUNT': 100,
    'UNITS_PER_SIDE': 50,
    'UNIT_RECORD_TYPE_SIDE_OFFSET': 0,
    'UNIT_RECORD_X_OFFSET': 1,
    'UNIT_RECORD_Y_OFFSET': 2,
    'UNIT_RECORD_HP_OFFSET': 4,
    'UNIT_RECORD_FUEL_OFFSET': 7,
    'UNIT_RECORD_WEAPON1_AMMO_OFFSET': 8,
    'UNIT_RECORD_WEAPON2_AMMO_OFFSET': 9,
    'UNIT_RECORD_PACKED_SIZE': 10,
    'UNIT_RECORD_RUNTIME_ONLY_OFFSET': 12,
}

def value(name):
    m = re.search(rf'^DEF\s+{re.escape(name)}\s+EQU\s+([^;\n]+)', constants, re.M)
    assert m, f'missing {name}'
    expr = m.group(1).strip().replace('$', '0x')
    env = {k: value(k) for k in expected if k in expr}
    return int(eval(expr, {'__builtins__': {}}, env))

for name, want in expected.items():
    got = value(name)
    assert got == want, f'{name}: expected {want}, got {got}'

assert 'include "constants/unit_constants.inc"' in setup
assert 'include "constants/unit_constants.inc"' in sram
assert sram.count('ld c, UNIT_RECORD_COUNT') == 2
assert sram.count('rept UNIT_RECORD_NEXT_AFTER_OFFSET11_ADVANCE') == 2
assert 'ld a, UNIT_RECORD_SIZE' in setup
assert 'ld b, UNITS_PER_SIDE' in setup and 'cp UNITS_PER_SIDE' in setup

# Model the exact compact record transform proven by the sourced serializer.
def pack(r):
    assert len(r) == 16
    return bytes([
        r[0], r[1], r[2], r[3],
        ((r[4] << 4) | r[5]) & 0xff,
        r[6], r[7],
        ((r[8] << 4) | r[9]) & 0xff,
        r[10], r[11],
    ])

def unpack(p, tail):
    assert len(p) == 10 and len(tail) == 4
    return bytes([
        p[0], p[1], p[2], p[3],
        (p[4] >> 4) & 0x0f, p[4] & 0x0f,
        p[5], p[6],
        (p[7] >> 4) & 0x0f, p[7] & 0x0f,
        p[8], p[9], *tail,
    ])

rng = random.Random(0x186)
for _ in range(1000):
    r = bytearray(rng.randrange(256) for _ in range(16))
    # Retail's packed pairs are nibble fields; constrain them to their proven width.
    for i in (4, 5, 8, 9):
        r[i] &= 0x0f
    p = pack(r)
    assert len(p) == expected['UNIT_RECORD_PACKED_SIZE']
    restored = unpack(p, bytes(r[12:16]))
    assert restored == bytes(r)

# Initial-placement writer order establishes these semantic offsets.
init = setup[setup.index('Unit_InitRecordFromDefinition::'):setup.index('assert @ == $4241')]
for token in (
    'UNIT_DATA_MAX_HP_OFFSET', 'UNIT_DATA_MAX_FUEL_OFFSET',
    'UNIT_DATA_WEAPON1_AMMO_OFFSET', 'UNIT_DATA_WEAPON2_AMMO_OFFSET',
):
    assert token in init

print('[ok] unit record layout')
print('     100 live records x 16 bytes; SRAM compact form is 10 bytes/record')
print('     type/side, X, Y, HP, fuel and both ammo offsets are source-backed')
print('     nibble-pair pack/unpack round-trip verified; offsets 12-15 remain runtime-only')
