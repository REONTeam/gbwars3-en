#!/usr/bin/env python3
from pathlib import Path

constants = Path('constants/unit_constants.inc').read_text()
symbols = Path('symbols.asm').read_text()
doc = Path('docs/battle/battle_combat_math_runtime.md').read_text()

for needle in [
    'DEF BATTLE_MULTIPLIER_INPUT_COUNT EQU 3',
    'DEF BATTLE_ATTACK_MULTIPLIER_SUPPORT_INPUT EQU 0',
    'DEF BATTLE_ATTACK_MULTIPLIER_RANK_INPUT EQU 1',
    'DEF BATTLE_ATTACK_MULTIPLIER_FLANK_INPUT EQU 2',
    'DEF BATTLE_DEFENSE_MULTIPLIER_COVER_INPUT EQU 0',
    'DEF BATTLE_DEFENSE_MULTIPLIER_RANK_INPUT EQU 1',
    'DEF BATTLE_DEFENSE_MULTIPLIER_FLANK_INPUT EQU 2',
    'DEF BATTLE_MULTIPLIER_RESULT_SIZE EQU 2',
    'DEF BATTLE_STATS_COVER_OFFSET EQU 12',
    'DEF BATTLE_STATS_RANK_VALUE_OFFSET EQU 13',
    'DEF BATTLE_STATS_FLANK_OFFSET EQU 14',
    'DEF BATTLE_STATS_SUPPORT_OFFSET EQU 15',
]:
    assert needle in constants, needle

for needle in [
    'sym $13, $49a2, Battle_CalcAttackMultiplier',
    'sym $13, $49cc, Battle_CalcDefenseMultiplier',
    'wBattleAttackerCover equ wBattleAttackerStats + BATTLE_STATS_COVER_OFFSET',
    'wBattleAttackerRankValue equ wBattleAttackerStats + BATTLE_STATS_RANK_VALUE_OFFSET',
    'wBattleAttackerFlank equ wBattleAttackerStats + BATTLE_STATS_FLANK_OFFSET',
    'wBattleAttackerSupport equ wBattleAttackerStats + BATTLE_STATS_SUPPORT_OFFSET',
    'wBattleDefenderCover equ wBattleDefenderStats + BATTLE_STATS_COVER_OFFSET',
    'wBattleDefenderRankValue equ wBattleDefenderStats + BATTLE_STATS_RANK_VALUE_OFFSET',
    'wBattleDefenderFlank equ wBattleDefenderStats + BATTLE_STATS_FLANK_OFFSET',
    'wBattleDefenderSupport equ wBattleDefenderStats + BATTLE_STATS_SUPPORT_OFFSET',
]:
    assert needle in symbols, needle

assert 0x49CC - 0x49A2 == 0x2A
assert 0x49FC - 0x49CC == 0x30

for phrase in [
    'attack tuple is `(Support, rank/level, Flank)`',
    'defense tuple is `(Cover, rank/level, Flank)`',
    'returning a 16-bit value in `HL`',
    '`L` carrying the fractional portion',
    'no guessed 8.8 or quarter-step fixed-point constant',
]:
    assert phrase in doc, phrase

print('[ok] attack multiplier inputs: Support / rank / Flank')
print('[ok] defense multiplier inputs: Cover / rank / Flank')
print('[ok] multiplier result width: 16-bit HL; fractional scale intentionally unresolved')
print('[ok] typed battle RAM exposes all four contributing context fields')
