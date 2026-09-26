#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys

root = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1] if len(sys.argv) > 1 else root / 'baserom.gbc')
rom = rom_path.read_bytes()
source = (root / 'engine/battle/battle_combat_runtime.asm').read_text()
symbols = (root / 'symbols.asm').read_text()
unit_source = (root / 'engine/unit/unit_setup.asm').read_text()
constants = (root / 'constants/unit_constants.inc').read_text()

base = 0x0c * 0x4000 - 0x4000
start, end = 0x4884, 0x4991
expected_sha1 = '5a1337c0b123b4ce0177404ce2fd3d6be4fe39db'
chunk = rom[base + start:base + end]
assert len(chunk) == 269, len(chunk)
assert hashlib.sha1(chunk).hexdigest() == expected_sha1

for label in [
    'Battle_SelectUsableWeaponAttack::',
    'Battle_CalcFlankValue::',
    'Battle_FlankAdjacentDirectionPairs::',
    'Battle_FlankValueByCoveredDirections::',
    'Battle_CalcSupportValue::',
]:
    assert label in source, label

for required in [
    'farcall $0b, MapGridCoord',
    'farcall UnitRecord_FindPrimaryAtCoordinates',
    'farcall UnitWeapon_BuildSummary',
    'call Battle_SelectUsableWeaponAttack',
    'ld [wBattleFlankDirectionMask], a',
    'ld [wBattleSupportAccumulator], a',
    'ld a, [wBattleDistance]',
    'db 1, 2', 'db 0, 3', 'db 0, 4', 'db 1, 5', 'db 2, 5', 'db 3, 4',
    'db 0, 0, 0, 0, 25, 35, 50',
    'assert @ == $4919',
    'assert @ == $4991',
]:
    assert required in source, required

for required in [
    'wBattleSupportTargetUnitID equ $c941',
    'wBattleWeaponRangeScratch equ $c942',
    'wBattleContextUnitID equ $c943',
    'wBattleFlankDirectionMask equ $c944',
    'wBattleSupportAccumulator equ $c944',
    'wBattleDistance equ $dbf6',
]:
    assert required in symbols, required

assert 'UnitRecord_FindPrimaryAtCoordinates::' in unit_source
assert 'sym $12, $414e, UnitRecord_FindPrimaryAtCoordinates' not in symbols

for required in [
    'DEF BATTLE_HEX_DIRECTION_COUNT EQU 6',
    'DEF BATTLE_SUPPORT_ATTACK_DIVISOR_SHIFT EQU 3',
]:
    assert required in constants, required

print('[ok] Bank $0C flank/support runtime: $4884-$4990 (269 bytes)')
print('[ok] retail SHA-1:', expected_sha1)
print('[ok] flank ZOC table: 0/0/0/0/25/35/50; support contribution: usable ATK >> 3')
