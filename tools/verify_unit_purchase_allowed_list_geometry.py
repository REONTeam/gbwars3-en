#!/usr/bin/env python3
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
constants=(ROOT/'constants/unit_constants.inc').read_text(); src=(ROOT/'engine/unit/unit_setup.asm').read_text()
req=[
'DEF UNIT_PURCHASE_ALLOWED_POINTER_COUNT EQU 16',
'DEF UNIT_PURCHASE_ALLOWED_LIST_COUNT EQU 15',
'DEF UNIT_PURCHASE_ALLOWED_LIST_RECORD_SIZE EQU 7',
'DEF UNIT_PURCHASE_ALLOWED_POINTER_REGION_SIZE EQU $49a6 - $4986',
'DEF UNIT_PURCHASE_ALLOWED_POINTER_BYTES EQU UNIT_PURCHASE_ALLOWED_POINTER_COUNT * 2',
'DEF UNIT_PURCHASE_ALLOWED_LIST_DATA_SIZE EQU $4a0f - $49a6']
for t in req: assert t in constants,t
assert 16*2==0x20 and 0x49a6-0x4986==0x20
assert 15*7==105 and 0x4a0f-0x49a6==105
assert src.count('dw UnitPurchase_AllowedList01')==2
for i in range(1,16): assert f'UnitPurchase_AllowedList{i:02d}::' in src
print('[ok] allowed-list pointer table: 16 words / 32 bytes at $4986-$49A5')
print('[ok] 15 distinct 7-byte lists at $49A6-$4A0E; pointer slots 0/1 share list 01')
