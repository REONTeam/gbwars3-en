#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
root = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1] if len(sys.argv) > 1 else root / 'baserom.gbc')
rom = rom_path.read_bytes()
source = (root / 'engine/battle/battle_combat_runtime.asm').read_text()
symbols = (root / 'symbols.asm').read_text()
constants = (root / 'constants/unit_constants.inc').read_text()
base = 0x0c * 0x4000 - 0x4000
start, end = 0x40c1, 0x418f
expected_sha1 = 'ceb6030b51d4e39ad55cecff48149e777dab11ad'
chunk = rom[base + start:base + end]
assert len(chunk) == 206, len(chunk)
assert hashlib.sha1(chunk).hexdigest() == expected_sha1
for label in ['Battle_SelectUsableWeaponAttack::','Battle_SelectWeaponAttackIgnoringAmmo::']:
    assert label in source, label
for required in [
    'section "Battle Weapon Selectors", romx[$40c1], bank[$0c]',
    'ld a, [wUnitWeaponSummary0CurrentAmmo]',
    'ld a, [wUnitWeaponSummary1CurrentAmmo]',
    'ld a, [wUnitWeaponSummary0MinRange]',
    'ld a, [wUnitWeaponSummary0MaxRange]',
    'ld a, [wUnitWeaponSummary1MinRange]',
    'ld a, [wUnitWeaponSummary1MaxRange]',
    'farcall UnitWeapon_GetAttackValue',
    'cp e',
    'jr z, .chooseSlot0',
    'assert @ == $412e',
    'assert @ == $418f',
]: assert required in source, required
# The second selector must be ammo-agnostic: both live-ammo reads belong to the first body.
second = source.split('Battle_SelectWeaponAttackIgnoringAmmo::',1)[1].split('assert @ == $418f',1)[0]
assert 'CurrentAmmo' not in second
assert 'sym $0c, $40c1, Battle_SelectUsableWeaponAttack' not in symbols
for required in ['DEF BATTLE_WEAPON_SLOT_0 EQU 0','DEF BATTLE_WEAPON_SLOT_1 EQU 1']:
    assert required in constants, required
print('[ok] Bank $0C weapon selectors: $40C1-$418E (206 bytes)')
print('[ok] retail SHA-1:', expected_sha1)
print('[ok] live-ammo selector + ammo-agnostic selector; range/target checks shared; slot-0 wins ties')
