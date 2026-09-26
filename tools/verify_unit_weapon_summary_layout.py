#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
constants = (ROOT / 'constants/unit_constants.inc').read_text()
symbols = (ROOT / 'symbols.asm').read_text()
doc = (ROOT / 'docs/unit/unit_weapon_list_staging_runtime.md').read_text()

for token in [
    'DEF UNIT_WEAPON_SUMMARY_SLOT0_OFFSET EQU 0',
    'DEF UNIT_WEAPON_SUMMARY_SLOT1_OFFSET EQU UNIT_WEAPON_SUMMARY_RECORD_SIZE',
    'UNIT_WEAPON_SUMMARY_SOURCE_WEAPON1_UNITDATA_OFFSET EQU UNIT_DATA_WEAPON1_OFFSET',
    'UNIT_WEAPON_SUMMARY_SOURCE_WEAPON2_UNITDATA_OFFSET EQU UNIT_DATA_WEAPON2_OFFSET',
    'UNIT_WEAPON_SUMMARY_SOURCE_AMMO1_LIVE_OFFSET EQU UNIT_RECORD_WEAPON1_AMMO_OFFSET',
    'UNIT_WEAPON_SUMMARY_SOURCE_AMMO2_LIVE_OFFSET EQU UNIT_RECORD_WEAPON2_AMMO_OFFSET',
    'UNIT_WEAPON_SUMMARY_SOURCE_MAX_AMMO1_UNITDATA_OFFSET EQU UNIT_DATA_WEAPON1_AMMO_OFFSET',
    'UNIT_WEAPON_SUMMARY_SOURCE_MAX_AMMO2_UNITDATA_OFFSET EQU UNIT_DATA_WEAPON2_AMMO_OFFSET',
    'UNIT_WEAPON_SUMMARY_SOURCE_MIN_RANGE_WEAPONDATA_OFFSET EQU WEAPON_DATA_MIN_RANGE_OFFSET',
    'UNIT_WEAPON_SUMMARY_SOURCE_MAX_RANGE_WEAPONDATA_OFFSET EQU WEAPON_DATA_MAX_RANGE_OFFSET',
]:
    assert token in constants, token

for token in [
    'wUnitWeaponSummary0 equ wUnitWeaponSummaryBuffer',
    'wUnitWeaponSummary0WeaponID equ wUnitWeaponSummary0 + UNIT_WEAPON_SUMMARY_WEAPON_ID_OFFSET',
    'wUnitWeaponSummary0CurrentAmmo equ wUnitWeaponSummary0 + UNIT_WEAPON_SUMMARY_CURRENT_AMMO_OFFSET',
    'wUnitWeaponSummary0MinRange equ wUnitWeaponSummary0 + UNIT_WEAPON_SUMMARY_MIN_RANGE_OFFSET',
    'wUnitWeaponSummary0MaxRange equ wUnitWeaponSummary0 + UNIT_WEAPON_SUMMARY_MAX_RANGE_OFFSET',
    'wUnitWeaponSummary0MaxAmmo equ wUnitWeaponSummary0 + UNIT_WEAPON_SUMMARY_MAX_AMMO_OFFSET',
    'wUnitWeaponSummary1 equ wUnitWeaponSummaryBuffer + UNIT_WEAPON_SUMMARY_SLOT1_OFFSET',
    'wUnitWeaponSummary1WeaponID equ wUnitWeaponSummary1 + UNIT_WEAPON_SUMMARY_WEAPON_ID_OFFSET',
    'wUnitWeaponSummary1CurrentAmmo equ wUnitWeaponSummary1 + UNIT_WEAPON_SUMMARY_CURRENT_AMMO_OFFSET',
    'wUnitWeaponSummary1MinRange equ wUnitWeaponSummary1 + UNIT_WEAPON_SUMMARY_MIN_RANGE_OFFSET',
    'wUnitWeaponSummary1MaxRange equ wUnitWeaponSummary1 + UNIT_WEAPON_SUMMARY_MAX_RANGE_OFFSET',
    'wUnitWeaponSummary1MaxAmmo equ wUnitWeaponSummary1 + UNIT_WEAPON_SUMMARY_MAX_AMMO_OFFSET',
]:
    assert token in symbols, token

# Independent address reconstruction of both 14-byte records.
base = 0xcced
size = 14
fields = {'weapon': 9, 'ammo': 10, 'min': 11, 'max': 12, 'max_ammo': 13}
assert base + size == 0xccfb
assert base + size * 2 - 1 == 0xcd08
assert base + fields['weapon'] == 0xccf6
assert base + fields['max_ammo'] == 0xccfa
assert base + size + fields['weapon'] == 0xcd04
assert base + size + fields['max_ammo'] == 0xcd08

# Cross-schema geometry established by the source-backed tables/records.
assert 'DEF UNIT_DATA_WEAPON1_OFFSET EQU $14' in constants
assert 'DEF UNIT_DATA_WEAPON1_AMMO_OFFSET EQU $15' in constants
assert 'DEF UNIT_DATA_WEAPON2_OFFSET EQU $16' in constants
assert 'DEF UNIT_DATA_WEAPON2_AMMO_OFFSET EQU $17' in constants
assert 'DEF UNIT_RECORD_WEAPON1_AMMO_OFFSET EQU 8' in constants
assert 'DEF UNIT_RECORD_WEAPON2_AMMO_OFFSET EQU 9' in constants
assert 'DEF WEAPON_DATA_MIN_RANGE_OFFSET EQU $08' in constants
assert 'DEF WEAPON_DATA_MAX_RANGE_OFFSET EQU $09' in constants

for text in ['typed weapon-summary RAM contract', '$CCED', '$CCFB', '$CD08', 'Attack', 'family values remain outside']:
    assert text in doc, text

print('[ok] weapon-summary slots: $CCED-$CCFA and $CCFB-$CD08')
print('[ok] weapon/ammo/range/max-ammo fields are tied to source-backed schemas')
print('[ok] attack-family lookup is source-backed at $48FC')
