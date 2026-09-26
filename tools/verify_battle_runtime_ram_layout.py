#!/usr/bin/env python3
from pathlib import Path

symbols = Path('symbols.asm').read_text()
constants = Path('constants/unit_constants.inc').read_text()
doc = Path('docs/battle/battle_runtime_ram_layout.md').read_text()

required_constants = [
    'DEF BATTLE_STATS_UNIT_ID_COUNT EQU 2',
    'DEF BATTLE_STATS_PARTICIPANT_RECORD_SIZE EQU $15',
    'DEF BATTLE_STATS_PARTICIPANT_COUNT EQU 2',
    'DEF BATTLE_STATS_OTHER_COORD_SIZE EQU 2',
    'DEF BATTLE_STATS_WORKSPACE_SIZE EQU BATTLE_STATS_UNIT_ID_COUNT + BATTLE_STATS_PARTICIPANT_RECORD_SIZE * BATTLE_STATS_PARTICIPANT_COUNT + BATTLE_STATS_OTHER_COORD_SIZE',
    'DEF BATTLE_STATS_UNIT_TYPE_OFFSET EQU 0',
    'DEF BATTLE_STATS_NEW_HP_A_OFFSET EQU 2',
    'DEF BATTLE_STATS_UNIT_FAMILY_OFFSET EQU 8',
    'DEF BATTLE_STATS_NEW_HP_B_OFFSET EQU 9',
    'DEF BATTLE_STATS_RANK_VALUE_OFFSET EQU 13',
    'DEF BATTLE_STATS_TOTAL_ATTACK_OFFSET EQU 16',
    'DEF BATTLE_STATS_TOTAL_DEFENSE_OFFSET EQU 18',
    'DEF BATTLE_STATS_WEAPON_CHOICE_OFFSET EQU 20',
]
for needle in required_constants:
    assert needle in constants, needle

required_symbols = [
    'wBattleAttackerUnitID equ $dbc8',
    'wBattleDefenderUnitID equ $dbc9',
    'wBattleAttackerStats equ $dbca',
    'wBattleDefenderStats equ wBattleAttackerStats + BATTLE_STATS_PARTICIPANT_RECORD_SIZE',
    'wBattleAttackerUnitFamily equ wBattleAttackerStats + BATTLE_STATS_UNIT_FAMILY_OFFSET',
    'wBattleAttackerRankValue equ wBattleAttackerStats + BATTLE_STATS_RANK_VALUE_OFFSET',
    'wBattleAttackerTotalAttack equ wBattleAttackerStats + BATTLE_STATS_TOTAL_ATTACK_OFFSET',
    'wBattleAttackerTotalDefense equ wBattleAttackerStats + BATTLE_STATS_TOTAL_DEFENSE_OFFSET',
    'wBattleDefenderUnitFamily equ wBattleDefenderStats + BATTLE_STATS_UNIT_FAMILY_OFFSET',
    'wBattleDefenderRankValue equ wBattleDefenderStats + BATTLE_STATS_RANK_VALUE_OFFSET',
    'wBattleDefenderTotalAttack equ wBattleDefenderStats + BATTLE_STATS_TOTAL_ATTACK_OFFSET',
    'wBattleDefenderTotalDefense equ wBattleDefenderStats + BATTLE_STATS_TOTAL_DEFENSE_OFFSET',
    'wBattleOtherX equ $dbf4',
    'wBattleOtherY equ $dbf5',
    'wBattleStatsWorkspaceEnd equ $dbf6',
]
for needle in required_symbols:
    assert needle in symbols, needle

assert 0xDBDF - 0xDBCA == 0x15
assert 0xDBF4 - 0xDBDF == 0x15
assert 0xDBF6 - 0xDBC8 == 46
assert 20 + 1 == 0x15

for phrase in [
    '**46 bytes**',
    'same 21-byte geometry',
    'NewHPA` / `NewHPB`',
    'Total ATK` and `Total DEF` are explicitly 16-bit',
    'Used weapon` / `Weapon choice`',
    'RAM naming/geometry only',
]:
    assert phrase in doc, phrase

print('[ok] battle workspace: $DBC8-$DBF5 = 46 bytes')
print('[ok] attacker/defender records: 21 bytes each')
print('[ok] participant field offsets: $00-$14')
print('[ok] duplicate New HP and weapon fields remain conservatively distinct')
print('[ok] battle RAM contract remains non-emitting/source-only')
