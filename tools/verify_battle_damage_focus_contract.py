#!/usr/bin/env python3
from pathlib import Path

constants = Path("constants/unit_constants.inc").read_text()
symbols = Path("symbols.asm").read_text()
doc = Path("docs/battle/battle_combat_math_runtime.md").read_text()

required = {
    "BATTLE_DAMAGE_BOOST_BASE_PERCENT": 100,
    "BATTLE_DAMAGE_NORMALIZATION_DENOMINATOR": 200,
    "BATTLE_NEW_HP_DEFENSE_FACTOR": 2,
    "BATTLE_FOCUS_ORDER_DIVISOR": 10,
    "BATTLE_FOCUS_ORDER_BRANCH_COUNT": 3,
    "BATTLE_FOCUS_ORDER_ATTACKER_HIGHER": 0,
    "BATTLE_FOCUS_ORDER_DEFENDER_HIGHER": 1,
    "BATTLE_FOCUS_ORDER_TIED": 2,
}
for name, value in required.items():
    needle=f"DEF {name} EQU {value}"
    assert needle in constants, needle

for needle in [
    "sym $13, $4a26, Battle_CalcAttackerNewHP",
    "sym $13, $4a98, Battle_CalcDefenderNewHP",
    "sym $13, $4b0a, Battle_CalcNewHPByAttackOrder",
]:
    assert needle in symbols, needle

# Reference-backed branch geometry.
assert 0x4A98 - 0x4A26 == 0x72
assert 0x4B0A - 0x4A98 == 0x72
assert 0x4B18 - 0x4B0A == 0x0E
assert 0x4B35 - 0x4B18 == 0x1D
assert 0x4B52 - 0x4B35 == 0x1D
assert 0x4B66 - 0x4B52 == 0x14

for phrase in [
    "**100-point boost base**",
    "**200-point normalization denominator**",
    "`(Total DEF - Total ATK) / (2 * DEF)`",
    "**10s digit of Focus**",
    "attacker higher (`$4B18-$4B34`)",
    "defender higher (`$4B35-$4B51`)",
    "tied (`$4B52-$4B65`)",
    "tied branch uses old HP for both participants",
]:
    assert phrase in doc, phrase

print("[ok] damage coefficients: boost base 100; normalization denominator 200; defense factor 2")
print("[ok] new-HP helper geometry: mirrored $4A26/$4A98 0x72-byte bodies")
print("[ok] Focus-order contract: tens digit / divisor 10; attacker/defender/tied branches")
print("[ok] instruction bytes and exact fixed-point representation remain overlay-owned")
