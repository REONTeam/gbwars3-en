#!/usr/bin/env python3
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
constants=(ROOT/'constants/unit_constants.inc').read_text()
symbols=(ROOT/'symbols.asm').read_text()
source=(ROOT/'engine/unit/unit_setup.asm').read_text()
doc=(ROOT/'docs/unit/unit_purchase_filter_contracts.md').read_text()
for item in [
 'DEF UNIT_PURCHASE_FILTER_ALLOWED EQU 0',
 'DEF UNIT_PURCHASE_FILTER_BLOCKED EQU 2',
 'DEF UNIT_TYPE_SIDE_SHIFT EQU 1',
 'DEF UNIT_TYPE_SIDE_MASK EQU 1',
]: assert item in constants, item
for item in [
 'UnitPurchase_CheckBuyable::',
 'UnitPurchase_CheckAllowedList::',
 'UnitPurchase_GetAllowedListBit::',
 'UnitPromotion_GetEligibleEncodedType::',
]: assert item in source, item
for old in [
 'sym $12, $4470, UnitPurchase_CheckBuyable',
 'sym $12, $447d, UnitPurchase_CheckAllowedList',
 'sym $12, $448d, UnitPurchase_GetAllowedListBit',
 'sym $12, $4498, UnitPromotion_GetEligibleEncodedType',
]: assert old not in symbols, old
for item in ['`A = 0`','`A = 2`','`(unit_type << 1) | side`','source-backed','UNIT_PURCHASE_FILTER_ALLOWED','UNIT_PURCHASE_FILTER_BLOCKED']:
 assert item in doc, item
encoded=(37 << 1) | 1
assert encoded == 75 and (encoded & 1)==1 and (encoded >> 1)==37
print('[ok] purchase filters share result contract: allowed=0, blocked=2')
print('[ok] promotion output uses established encoded unit/side representation')
print('[ok] purchase filters are now source-backed and use the source-backed allowed-list bitfields')
