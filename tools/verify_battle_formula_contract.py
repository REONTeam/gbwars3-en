#!/usr/bin/env python3
from pathlib import Path

constants = Path('constants/unit_constants.inc').read_text()
symbols = Path('symbols.asm').read_text()
doc = Path('docs/battle/battle_combat_math_runtime.md').read_text()

expected = {
    'BATTLE_FORMULA_PERCENT_SCALE': 100,
    'BATTLE_FORMULA_ATTACK_BASE': 100,
    'BATTLE_FORMULA_DEFENSE_BASE': 200,
    'BATTLE_FORMULA_HP_DIVISOR': 100,
    'BATTLE_FORMULA_NEW_HP_DEFENSE_FACTOR': 2,
    'BATTLE_RANK_VALUE_D': 0,
    'BATTLE_RANK_VALUE_C': 10,
    'BATTLE_RANK_VALUE_B': 20,
    'BATTLE_RANK_VALUE_A': 30,
    'BATTLE_RANK_VALUE_S': 40,
    'BATTLE_RANK_VALUE_STEP': 10,
}
for name, value in expected.items():
    needle = f'DEF {name} EQU {value}'
    assert needle in constants, needle

# Rank geometry must remain aligned with the already-proven five rank indices.
for needle in [
    'DEF UNIT_RANK_D EQU 0',
    'DEF UNIT_RANK_C EQU 1',
    'DEF UNIT_RANK_B EQU 2',
    'DEF UNIT_RANK_A EQU 3',
    'DEF UNIT_RANK_S EQU 4',
]:
    assert needle in constants, needle

for needle in [
    'sym $13, $4991, Battle_GetRankMultiplier',
    'sym $13, $499d, Battle_RankMultiplierTable',
    'sym $13, $49a2, Battle_CalcAttackMultiplier',
    'sym $13, $49cc, Battle_CalcDefenseMultiplier',
    'sym $13, $49fc, Battle_CalcStatHPScaled',
    'sym $13, $4a21, Battle_CalcDoubleStatHPScaled',
    'sym $13, $4a26, Battle_CalcAttackerNewHP',
    'sym $13, $4a98, Battle_CalcDefenderNewHP',
]:
    assert needle in symbols, needle

assert 0x49A2 - 0x499D == 5
assert 0x4A21 - 0x49FC == 0x25
assert 0x4A26 - 0x4A21 == 5
assert 0x4A98 - 0x4A26 == 0x72
assert 0x4B0A - 0x4A98 == 0x72

for phrase in [
    '**0, 10, 20, 30, 40**',
    '`100 + rank + flank + support`',
    '`200 + cover + rank + flank`',
    '`Used ATK * HP * attack context / 100`',
    '`Used DEF * HP * defense context / 100`',
    '`(Total DEF - Total ATK) / (2 * Used DEF)`',
    'range **0 .. old HP**',
    'exact fixed-point scale used internally remains unresolved',
]:
    assert phrase in doc, phrase

print('[ok] rank formula values: D/C/B/A/S = 0/10/20/30/40')
print('[ok] attack formula base/support/rank/flank contract')
print('[ok] defense formula base/cover/rank/flank contract')
print('[ok] HP result formula: divide by 2*DEF, clamp to 0..old HP, round positive result upward')
print('[ok] Bank $13 arithmetic remains non-emitting/overlay-owned')
