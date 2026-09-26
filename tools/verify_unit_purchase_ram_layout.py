#!/usr/bin/env python3
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
constants=(ROOT/'constants/unit_constants.inc').read_text()
symbols=(ROOT/'symbols.asm').read_text()
doc=(ROOT/'docs/unit/unit_purchase_ram_layout.md').read_text()
for token in [
    'DEF UNIT_PURCHASE_LIST_FIRST_ENTRY_OFFSET EQU 1',
    'DEF UNIT_PURCHASE_LIST_CAPACITY EQU 15',
    'DEF UNIT_PURCHASE_LIST_SIZE EQU UNIT_PURCHASE_LIST_CAPACITY',
    'DEF UNIT_PURCHASE_LIST_END_OFFSET EQU UNIT_PURCHASE_LIST_FIRST_ENTRY_OFFSET + UNIT_PURCHASE_LIST_SIZE',
]: assert token in constants, token
for token in [
    'sym $00, $cd09, wUnitCountBySide',
    'sym $00, $cd0b, wBuyableUnitCount',
    'sym $00, $cd0c, wBuyableUnitList',
    'sym $00, $cd28, wUnitNameBuffer',
]: assert token in symbols, token
assert 0xCD0A-0xCD09 == 1
assert 0xCD1B-0xCD0C == 15
assert 0xCD28-0xCD1B == 13
for phrase in [
    '`$CD09-$CD0A`',
    '`$CD0B`',
    '`$CD0C-$CD1A`',
    '15 unit-type entries',
    '`$CD1B-$CD27` remains deliberately unclaimed',
]: assert phrase in doc, phrase
print('[ok] side unit-count array: $CD09-$CD0A = 2 bytes')
print('[ok] buyable count: $CD0B')
print('[ok] buyable unit list: $CD0C-$CD1A = 15 entries')
print('[ok] $CD1B-$CD27 remains unclaimed before $CD28')
