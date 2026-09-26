#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys
rom=Path(sys.argv[1] if len(sys.argv)>1 else 'baserom.gbc').read_bytes()
out=Path(sys.argv[2] if len(sys.argv)>2 else 'GBWARS3.gbc').read_bytes()
def off(bank,addr): return bank*0x4000+(addr-0x4000)
checks=[(0x41fc,0x487c,1664,'a8aff89611d0f2da505f408ab2947e2e27c2ff4d'),(0x487c,0x48fb,127,'a2cef38c56c4fa1e9e81980955cf37dcf6f362b8')]
for start,end,size,sha1 in checks:
    r=rom[off(0x18,start):off(0x18,end)]
    o=out[off(0x18,start):off(0x18,end)]
    assert len(r)==size
    assert hashlib.sha1(r).hexdigest()==sha1
    assert r==o, f'ROM mismatch ${start:04X}-${end-1:04X}'
src=Path('engine/battle/battle_scene_weapon_target_sfx.asm').read_text()
for needle in ['BattleSceneWeaponTargetSFXMatrix::','assert BattleSceneWeaponTargetSFXMatrix_End - BattleSceneWeaponTargetSFXMatrix == 32 * 52','BattleScene_GetWeaponTargetSFX::','BattleScene_ConfigureWeaponEffectState::','BattleScene_PrepareWeaponTargetSFX::','assert @ == $48fb']:
    assert needle in src, needle
setup=Path('engine/battle/battle_scene_setup.asm').read_text()
assert setup.count('call BattleScene_PrepareWeaponTargetSFX')==8
assert 'call $48cf' not in setup
mk=Path('Makefile').read_text()
objs=re.findall(r'\b([\w/.-]+\.o)\b', mk.split('graphics :=',1)[0])
assert len(objs)==len(set(objs))
for obj in objs:
    assert Path(obj[:-2]+'.asm').exists(), obj
print('PASS: Bank $18:$41FC-$487B 32 x 52 weapon/target SFX matrix is byte-exact')
print('PASS: Bank $18:$487C-$48FA lookup/effect/preparation helpers are byte-exact')
print('PASS: 8 battle-scene renderer callers use BattleScene_PrepareWeaponTargetSFX symbolically')
print(f'PASS: Makefile object/source audit {len(objs)} / {len(objs)}')
print('PASS: rebuilt custom ROM SHA-256', hashlib.sha256(out).hexdigest())
