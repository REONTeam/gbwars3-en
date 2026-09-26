#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
constants = (ROOT / "constants/unit_constants.inc").read_text()
home_map = (ROOT / "engine/home/home_map.asm").read_text()
core = (ROOT / "engine/home/home_arithmetic_core.asm").read_text()
doc = (ROOT / "docs/home/rom0_arithmetic_contract.md").read_text()

def equ(name):
    m = re.search(rf"^DEF {re.escape(name)} EQU \$(?P<h>[0-9A-Fa-f]+)$", constants, re.M)
    if m:
        return int(m.group('h'), 16)
    m = re.search(rf"^DEF {re.escape(name)} EQU (?P<n>[0-9]+)$", constants, re.M)
    if m:
        return int(m.group('n'))
    raise AssertionError(name)

ranges = [
    (0x29AD, 0x29BB, 'Math_MultiplyHLBy100'),
    (0x29BC, 0x29C2, 'AddAtoHL'),
    (0x29C3, 0x29C9, 'Math_SubtractDEFromHL'),
    (0x29CA, 0x29D7, 'Math_CompareHLToDE'),
    (0x29D8, 0x2A1C, 'Math_SignedMultiplyHLByDE'),
    (0x2A1D, 0x2A20, 'Math_ZeroHL'),
    (0x2A21, 0x2A6F, 'Math_DivideDEByBC'),
    (0x2A70, 0x2A78, 'Math_AdjustNegativeBCAndDecrementAtHL'),
    (0x2A79, 0x2A81, 'Math_AdjustNegativeDEAndDecrementAtHL'),
]
assert ranges[0][0] == 0x29AD and ranges[-1][1] == 0x2A81
for left, right in zip(ranges, ranges[1:]):
    assert left[1] + 1 == right[0]
assert sum(end-start+1 for start,end,_ in ranges) == 0x2A81-0x29AD+1 == 213

assert equ('ROM0_ARITHMETIC_CLUSTER_START') == 0x29AD
assert equ('ROM0_ARITHMETIC_CLUSTER_END') == 0x2A81

for start, end, name in ranges:
    text = home_map if name == 'AddAtoHL' else core
    assert f'{name}::' in text, name
    assert name in doc

for token in (
    'section "Multiply HL by 100", rom0[$29ad]', 'assert @ == $29bc',
    'section "Subtract DE from HL", rom0[$29c3]', 'assert @ == $29ca',
    'section "Compare DE against HL", rom0[$29ca]', 'assert @ == $29d8',
    'section "Signed multiply HL by DE", rom0[$29d8]', 'assert @ == $2a1d',
    'section "Zero HL", rom0[$2a1d]', 'assert @ == $2a21',
    'section "Divide DE by BC", rom0[$2a21]', 'assert @ == $2a70',
    'section "Adjust negative BC", rom0[$2a70]', 'Math_NegateBC::', 'assert @ == $2a79',
    'section "Adjust negative DE", rom0[$2a79]', 'Math_NegateDE::', 'assert @ == $2a82',
):
    assert token in core, token

expected_sizes = {
'MATH_MULTIPLY_HL_BY_100_SIZE':0x0F, 'MATH_ADD_A_TO_HL_SIZE':0x07,
'MATH_SUBTRACT_DE_FROM_HL_SIZE':0x07, 'MATH_COMPARE_HL_TO_DE_SIZE':0x0E,
'MATH_SIGNED_MULTIPLY_SIZE':0x45, 'MATH_ZERO_HL_SIZE':0x04,
'MATH_DIVIDE_DE_BY_BC_SIZE':0x4F, 'MATH_ADJUST_NEGATIVE_BC_SIZE':0x09,
'MATH_ADJUST_NEGATIVE_DE_SIZE':0x09}
for name, value in expected_sizes.items():
    assert equ(name) == value, (name, equ(name), value)

if len(sys.argv) > 1:
    rom = Path(sys.argv[1]).read_bytes()
    expected = '91383643cff2d5e94e87a382b43c64a0dc34178e'
    got = hashlib.sha1(rom[0x29AD:0x2A82]).hexdigest()
    assert got == expected, (got, expected)

assert 'quotient returned in `DE`, remainder in `BC`' in doc
assert 'No divide-by-zero special case' in doc
print('[ok] ROM0 arithmetic cluster $29AD-$2A81 is fully source-backed / 213 bytes')
print('[ok] multiply, subtraction, comparison, signed multiply, zero, signed division, and negate helpers are ROM-locked')
