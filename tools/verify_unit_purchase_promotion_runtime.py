#!/usr/bin/env python3
from pathlib import Path
import hashlib
import sys

ROOT = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'baserom.gbc'
rom = rom_path.read_bytes()
source = (ROOT / 'engine/unit/unit_setup.asm').read_text()
symbols = (ROOT / 'symbols.asm').read_text()
constants = (ROOT / 'constants/unit_constants.inc').read_text()
doc = (ROOT / 'docs/unit/unit_purchase_promotion_runtime.md').read_text()

BANK = 0x12
START = 0x43F4
END = 0x450A
EXPECTED_SHA1 = '30c5948158903e9103bd937668a9964ff29284b2'
offset = BANK * 0x4000 + (START - 0x4000)
blob = rom[offset:offset + (END - START)]
assert len(blob) == 278
assert hashlib.sha1(blob).hexdigest() == EXPECTED_SHA1

required_labels = [
    'UnitPurchase_BuildPropertyUnitList::',
    'UnitPurchase_AppendAvailableTypeRange::',
    'UnitPurchase_AppendMercenaryTypeRange::',
    'UnitPurchase_CheckBuyable::',
    'UnitPurchase_CheckAllowedList::',
    'UnitPurchase_GetAllowedListBit::',
    'UnitPromotion_GetEligibleEncodedType::',
    'UnitPromotion_GetPromotedType::',
    'UnitPromotion_Apply::',
]
for label in required_labels:
    assert label in source, label

for old in [
    'sym $12, $43f4, UnitPurchase_BuildPropertyUnitList',
    'sym $12, $4436, UnitPurchase_AppendAvailableTypeRange',
    'sym $12, $4458, UnitPurchase_AppendMercenaryTypeRange',
    'sym $12, $4470, UnitPurchase_CheckBuyable',
    'sym $12, $447d, UnitPurchase_CheckAllowedList',
    'sym $12, $448d, UnitPurchase_GetAllowedListBit',
    'sym $12, $4498, UnitPromotion_GetEligibleEncodedType',
    'sym $12, $44b8, UnitPromotion_GetPromotedType',
    'sym $12, $44c0, UnitPromotion_Apply',
]:
    assert old not in symbols, old

for token in [
    'section "Unit Purchase and Promotion Runtime", romx[$43f4], bank[$12]',
    'assert @ == $450a',
    'call UnitPurchase_CheckBuyable',
    'call UnitPurchase_GetAllowedListBit',
    'call UnitRecord_GetExperienceRank',
    'cp UNIT_RANK_S',
    'call UnitPromotion_GetPromotedType',
    'farcall CampaignStats_MarkProcuredUnit',
    'ld c, UNIT_RECORD_EXPERIENCE_OFFSET',
    'ld de, 0',
    'ld c, UNIT_DATA_MAX_FUEL_OFFSET',
    'ld c, UNIT_DATA_WEAPON1_AMMO_OFFSET',
    'ld c, UNIT_DATA_WEAPON2_AMMO_OFFSET',
]:
    assert token in source, token

for token in [
    'DEF UNIT_PURCHASE_FILTER_ALLOWED EQU 0',
    'DEF UNIT_PURCHASE_FILTER_BLOCKED EQU 2',
    'DEF UNIT_RANK_S EQU 4',
]:
    assert token in constants, token

for phrase in [
    'source-backed',
    '278 bytes',
    EXPECTED_SHA1,
    'resets experience',
    'refills fuel',
]:
    assert phrase in doc, phrase

print(f'[ok] Bank $12:$43F4-$4509 retail range: 278 bytes / SHA-1 {EXPECTED_SHA1}')
print('[ok] purchase/property list builders and buyability/allowed-list filters are explicit source')
print('[ok] S-rank promotion lookup/application is explicit source; former symbol-only anchors are gone')
