#!/usr/bin/env python3
from pathlib import Path
import hashlib
import sys

ROOT = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'baserom.gbc'
rom = rom_path.read_bytes()
assert len(rom) >= 0x13 * 0x4000

bank = 0x12
def chunk(start, end):
    off = bank * 0x4000 + (start - 0x4000)
    return rom[off:off + (end - start)]

checks = [
    (0x43F4, 0x4436, '30e5c9f50f70f2d4b03dea772e3a5899763510d7'),
    (0x4436, 0x4458, 'b53aba8f55a9226b84320905eb4ad17a6d4aa15f'),
    (0x4458, 0x4470, '5a8aeea22e07f121050242109930630b05fd9dff'),
    (0x4470, 0x447D, 'ed4b354a9d55c7a96d1c91a14c16c33d7c2fe811'),
    (0x447D, 0x448D, 'cf39e00bf5986473155530d0da01051b7943fa70'),
    (0x448D, 0x4498, 'b6bcead06a61f0ccf039b578d69389ae92929f48'),
    (0x4498, 0x44B8, 'bef8018db2babf703dbd09242a9653157ad59d9c'),
    (0x44B8, 0x44C0, 'd1caa4aaa921223c68e73ef5d225934535fde12e'),
    (0x44C0, 0x450A, '80953946a32f776acef721fc8ef29fda8c96d2c6'),
]
for start, end, sha1 in checks:
    data = chunk(start, end)
    assert hashlib.sha1(data).hexdigest() == sha1, (hex(start), hex(end))

whole = chunk(0x43F4, 0x450A)
assert len(whole) == 278
assert hashlib.sha1(whole).hexdigest() == '30c5948158903e9103bd937668a9964ff29284b2'

src = (ROOT / 'engine/unit/unit_setup.asm').read_text()
symbols = (ROOT / 'symbols.asm').read_text()
required = [
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
for token in required:
    assert token in src, token

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

print('[ok] Bank $12:$43F4-$4509 purchase/promotion runtime: 278 retail bytes')
print('[ok] SHA-1 30c5948158903e9103bd937668a9964ff29284b2')
print('[ok] all nine former symbol-only entry points are now explicit source')
