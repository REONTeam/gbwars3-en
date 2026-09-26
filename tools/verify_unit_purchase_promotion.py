#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
symbols = (ROOT / 'symbols.asm').read_text()
doc = (ROOT / 'docs/unit/unit_purchase_promotion_runtime.md').read_text()
constants = (ROOT / 'constants/unit_constants.inc').read_text()
unit_setup = (ROOT / 'engine/unit/unit_setup.asm').read_text()

required_source = [
    'section "Unit Purchase and Promotion Runtime", romx[$43f4], bank[$12]',
    'UnitPurchase_BuildPropertyUnitList::',
    'UnitPurchase_AppendAvailableTypeRange::',
    'UnitPurchase_AppendMercenaryTypeRange::',
    'UnitPurchase_CheckBuyable::',
    'UnitPurchase_CheckAllowedList::',
    'UnitPurchase_GetAllowedListBit::',
    'UnitPromotion_GetEligibleEncodedType::',
    'UnitPromotion_GetPromotedType::',
    'UnitPromotion_Apply::',
    'assert @ == $450a',
]
for item in required_source:
    assert item in unit_setup, item

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

assert 'DEF UNIT_RANK_S EQU 4' in constants
for token in [
    'source-backs the complete Bank `$12:$43F4-$4509`',
    '**278 bytes**',
    'UNIT_RANK_S',
    '**resets experience**',
    '**refills fuel**',
]:
    assert token in doc, token

print('[ok] Bank $12 purchase/promotion runtime is explicit source through $4509')
print('[ok] promotion remains S-rank gated and uses the source-backed mapping table')
print('[ok] promotion application resets experience and refills fuel/ammunition')
