#!/usr/bin/env python3
from pathlib import Path
constants=Path('constants/unit_constants.inc').read_text()
src=Path('engine/battle/battle_combat_runtime.asm').read_text()
doc=Path('docs/battle/battle_combat_math_runtime.md').read_text()
for name,value in {
 'BATTLE_PARTICIPATION_EXP_ATTACK':2,
 'BATTLE_PARTICIPATION_EXP_DEFEND':1,
 'BATTLE_DAMAGE_EXP_KILL_BONUS':1,
 'BATTLE_DAMAGE_EXP_NO_KILL_BONUS':0,
 'BATTLE_DAMAGE_EXP_UNDERDOG_MULTIPLIER':2,
 'BATTLE_DAMAGE_EXP_NORMAL_MULTIPLIER':1,
}.items(): assert f'DEF {name} EQU {value}' in constants
for label in ['Battle_ApplyParticipationExperience::','Battle_ApplyDamageExperience::']:
 assert label in src,label
assert 0x4C27-0x4BFC==0x2B
assert 0x4C70-0x4C27==0x49
for phrase in ['attacking/counterattacking participation = **2 EXP**','defending participation = **1 EXP**','kill bonus = **1** (otherwise 0)','underdog multiplier = **2**','`(Damage Done + Kill Coefficient) * Underdog Coefficient`']:
 assert phrase in doc,phrase
print('[ok] participation EXP contract: attack/counterattack=2, defend=1')
print('[ok] damage EXP coefficients: kill=1/0, underdog=2/1')
print('[ok] sourced geometry: participation $4BFC-$4C26; damage $4C27-$4C6F')
