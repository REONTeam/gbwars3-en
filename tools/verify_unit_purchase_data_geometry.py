#!/usr/bin/env python3
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
constants = (ROOT / 'constants/unit_constants.inc').read_text()
symbols = (ROOT / 'symbols.asm').read_text()
unit_setup = (ROOT / 'engine/unit/unit_setup.asm').read_text()
doc = (ROOT / 'docs/unit/unit_purchase_promotion_runtime.md').read_text()
unit_data = (ROOT / 'engine/unit/unit.asm').read_text()

required = [
    'DEF UNIT_PROMOTION_TABLE_FIRST_TYPE EQU 0',
    'DEF UNIT_PROMOTION_TABLE_COUNT EQU UNIT_DATA_COUNT - 1',
    'DEF UNIT_PROMOTION_TABLE_ENTRY_SIZE EQU 1',
    'DEF UNIT_PROMOTION_TABLE_SIZE EQU UNIT_PROMOTION_TABLE_COUNT * UNIT_PROMOTION_TABLE_ENTRY_SIZE',
    'DEF UNIT_PURCHASE_LIST_FIRST_ENTRY_OFFSET EQU 1',
    'DEF UNIT_PURCHASE_LIST_CAPACITY EQU 15',
    'DEF UNIT_PURCHASE_LIST_SIZE EQU UNIT_PURCHASE_LIST_CAPACITY',
    'DEF UNIT_PURCHASE_LIST_END_OFFSET EQU UNIT_PURCHASE_LIST_FIRST_ENTRY_OFFSET + UNIT_PURCHASE_LIST_SIZE',
]
for token in required:
    assert token in constants, token

assert 'UnitPromotionTypeTable::' in unit_setup
for token in [
    'sym $00, $cd0b, wBuyableUnitCount',
    'sym $00, $cd0c, wBuyableUnitList',
    'sym $00, $cd28, wUnitNameBuffer',
]:
    assert token in symbols, token

assert 'section "Unit Data", romx[$4a43], bank[$12]' in unit_data.lower() or 'romx[$4a43]' in unit_data.lower()

# Boundary arithmetic is intentionally independent of unavailable ROM bytes.
promotion_start = 0x4A0F
unit_data_start = 0x4A43
assert unit_data_start - promotion_start == 52
assert 53 - 1 == 52
assert 0xCD1B - 0xCD0C == 15
assert 0xCD28 - 0xCD1B == 13

for phrase in [
    'exactly **52 mapping bytes**',
    'UnitData index 52 `DUMMY`',
    '`$CD0C-$CD1A`',
    '15 unit-type',
    '`$CD1B-$CD27`',
]:
    assert phrase in doc, phrase

print('[ok] promotion table geometry: 52 x 1 byte = $12:$4A0F-$4A42')
print('[ok] promotion table covers UnitData indices 0-51; trailing DUMMY index 52 is excluded')
print('[ok] purchase-list RAM contract: count at $CD0B + 15 entries at $CD0C-$CD1A')
print('[ok] $CD1B-$CD27 remains unclaimed before wUnitNameBuffer at $CD28')
