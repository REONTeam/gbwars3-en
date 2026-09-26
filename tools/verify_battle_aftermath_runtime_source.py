#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
rom = Path(sys.argv[1]).read_bytes()
start, end = 0x4B67, 0x4C70
off = 0x0C * 0x4000 + (start - 0x4000)
data = rom[off:off + end - start]
expected = 'd322458ee36a8be3bb51531c66fcfeda46ee06db'
assert len(data) == 265
assert hashlib.sha1(data).hexdigest() == expected
src = Path('engine/battle/battle_combat_runtime.asm').read_text()
for label in ['Battle_ApplyAmmoAndParticipationExperience::','Battle_ApplyAttackerAmmoAndParticipationExperience::','Battle_ApplyDefenderAmmoAndParticipationExperience::','Battle_ApplyAmmoUse::','Battle_ApplyParticipationExperience::','Battle_ApplyDamageExperience::']:
    assert label in src, label
for needle in ['farcall UnitRecord_GetByte','farcall UnitRecord_SetByte','farcall UnitRecord_AddExperienceClamped','ld a, [wBattleAttackOrderState]','add UNIT_RECORD_WEAPON1_AMMO_OFFSET']:
    assert needle in src, needle
symbols = Path('symbols.asm').read_text()
for old in ['sym $0c, $4b67, Battle_ApplyAmmoAndParticipationExperience','sym $0c, $4bc0, Battle_ApplyAttackerAmmoAndParticipationExperience','sym $0c, $4bd5, Battle_ApplyDefenderAmmoAndParticipationExperience','sym $0c, $4bea, Battle_ApplyAmmoUse','sym $0c, $4bfc, Battle_ApplyParticipationExperience','sym $0c, $4c27, Battle_ApplyDamageExperience']:
    assert old not in symbols, old
assert 'wBattleAttackOrderState equ $dbf6' in symbols
print('[ok] Bank $0C:$4B67-$4C6F aftermath runtime source, 265 bytes')
print('[ok] SHA-1 ' + expected)
