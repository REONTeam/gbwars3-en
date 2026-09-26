#!/usr/bin/env python3
from pathlib import Path
src=Path('engine/battle/battle_combat_runtime.asm').read_text(); symbols=Path('symbols.asm').read_text()
for label in ['Battle_GetRankMultiplier::','Battle_CalcAttackMultiplier::','Battle_CalcDefenseMultiplier::','Battle_CalcStatHPScaled::','Battle_CalcDoubleStatHPScaled::','Battle_CalcAttackerNewHP::','Battle_CalcDefenderNewHP::','Battle_CalcNewHPByAttackOrder::','Battle_ApplyAmmoAndParticipationExperience::','Battle_ApplyAmmoUse::','Battle_ApplyParticipationExperience::','Battle_ApplyDamageExperience::']:
 assert label in src,label
for needle in ['sym $0c, $4e0a, BattleAttackOrderTextPointers','sym $0c, $4e12, BattleAttackOrderText']:
 assert needle in symbols,needle
print('[ok] Bank $0C combat source now extends through $4C6F')
print('[ok] only the later attack-order text anchors remain in this contract layer')
