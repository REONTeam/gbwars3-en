#!/usr/bin/env python3
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
src=(ROOT/'engine/unit/unit_setup.asm').read_text()
symbols=(ROOT/'symbols.asm').read_text()
constants=(ROOT/'constants/unit_constants.inc').read_text()
for label in ['UnitWeapon_CopyNameToBuffer::','WeaponData_GetByte::','UnitWeapon_BuildSummary::','UnitWeapon_GetAttackValue::','UnitListScratch_Clear::','UnitListScratch_CopyUnit::','UnitListScratch_GetRecordPointer::','UnitListScratch_CopySide::','UnitPurchase_BuyableTypeData::','UnitPurchase_AllowedListPointers::','UnitPromotionTypeTable::']:
    assert label in src,label
for anchor in ['$4837','$490b','$497f','$49a6','$4a0f','$4a43']:
    assert f'assert @ == {anchor}' in src,anchor
for old in ['sym $12, $4837, UnitWeapon_CopyNameToBuffer','sym $12, $490b, UnitListScratch_Clear','sym $12, $497f, UnitPurchase_BuyableTypeData','sym $12, $4a0f, UnitPromotionTypeTable']:
    assert old not in symbols,old
assert 'DEF UNIT_LIST_SCRATCH_SIZE EQU UNIT_LIST_SCRATCH_RECORD_COUNT * UNIT_LIST_SCRATCH_RECORD_SIZE' in constants
print('[ok] Bank $12:$4837-$4A42 weapon/unit-list/purchase layer is explicit source')
print('[ok] former symbol-only anchors were retired')
