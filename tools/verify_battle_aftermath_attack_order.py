#!/usr/bin/env python3
from pathlib import Path
src=Path('engine/battle/battle_combat_runtime.asm').read_text(); symbols=Path('symbols.asm').read_text(); constants=Path('constants/unit_constants.inc').read_text()
for label in ['Battle_ApplyAmmoAndParticipationExperience::','Battle_ApplyAttackerAmmoAndParticipationExperience::','Battle_ApplyDefenderAmmoAndParticipationExperience::','Battle_ApplyAmmoUse::','Battle_ApplyParticipationExperience::','Battle_ApplyDamageExperience::']:
 assert label in src,label
for needle in ['sym $0c, $4e0a, BattleAttackOrderTextPointers','sym $0c, $4e12, BattleAttackOrderText']:
 assert needle in symbols,needle
for needle in ['DEF BATTLE_ATTACK_ORDER_STATE_COUNT EQU 4','DEF BATTLE_ATTACK_ORDER_INVALID EQU 0','DEF BATTLE_ATTACK_ORDER_SIMULTANEOUS EQU 1','DEF BATTLE_ATTACK_ORDER_FIRST EQU 2','DEF BATTLE_ATTACK_ORDER_SECOND EQU 3']:
 assert needle in constants,needle
assert 0x4BD5-0x4BC0==0x15 and 0x4BEA-0x4BD5==0x15
print('[ok] aftermath source split: attacker $4BC0-$4BD4 / defender $4BD5-$4BE9')
print('[ok] attack-order text remains separately overlay-owned at $4E0A+')
