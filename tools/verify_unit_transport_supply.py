#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
root=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else root/'baserom.gbc'
rom=rom_path.read_bytes()
if len(rom)!=0x100000: raise SystemExit(f'[fail] unexpected ROM size: {len(rom):#x}')
def cut(bank,a,b):
    o=bank*0x4000+(a-0x4000 if bank else a)
    return rom[o:o+b-a]
ranges=[
    (0x12,0x4329,0x43b9,'4cf9e36dfe6b695c7560789d1b5c76d5734c011c'),
    (0x12,0x43b9,0x43f4,'b4f1f0cf8aa1ccd715627d458817ce879a5d6ccb'),
    (0x12,0x450a,0x4585,'5779c2e5cc39a611128d89e8acadb21eb4208c3c'),
    (0x00,0x28d9,0x291d,'895616976efa8eeed4fb45c3a59fbc2b5178b3cf'),
]
for bank,a,b,exp in ranges:
    got=hashlib.sha1(cut(bank,a,b)).hexdigest()
    if got!=exp: raise SystemExit(f'[fail] ${bank:02X}:${a:04X}-${b-1:04X} SHA-1 {got} != {exp}')
src=(root/'engine/unit/unit_setup.asm').read_text()
home=(root/'engine/home/home_map.asm').read_text()
const=(root/'constants/unit_constants.inc').read_text()
syms=(root/'symbols.asm').read_text()
for x in [
    'UnitData_CheckLoadingCompatibility::','Unit_CanReceiveSupplyFrom::',
    'Unit_BuildCarriedChildList::','Unit_BuildAdjacentSupplyList::',
    'assert @ == $43b9','assert @ == $43f4','assert @ == $4585',
    'UNIT_DATA_TARGET_CLASS_OFFSET','UNIT_DATA_CARRYING_TYPE_OFFSET',
    'wCarriedUnitListCount','wAdjacentSupplyUnitCount','wAdjacentSupplyUnitList',
]:
    if x not in src and x not in const and x not in syms:
        raise SystemExit(f'[fail] missing source form: {x}')
for x in ['HexGrid_GetNeighborCoord::','assert @ == $291d','wMapGridWidth','wMapGridHeight']:
    if x not in home and x not in syms: raise SystemExit(f'[fail] missing hex-grid form: {x}')
for x in [
    'DEF UNIT_TARGET_CLASS_ARMORED     EQU 0','DEF UNIT_TARGET_CLASS_UNARMORED   EQU 1',
    'DEF UNIT_TARGET_CLASS_AIR         EQU 2','DEF UNIT_TARGET_CLASS_SEA         EQU 3',
    'DEF UNIT_TARGET_CLASS_SUBMARINE   EQU 4',
]:
    if x not in const: raise SystemExit(f'[fail] missing target-class constant: {x}')
print('[ok] Bank $12:$4329-$43B8 pair-filter tranche: 144 retail bytes')
print('[ok] Bank $12:$43B9-$43F3 carried-child list: 59 retail bytes')
print('[ok] Bank $12:$450A-$4584 adjacent supply-source list: 123 retail bytes')
print('[ok] ROM0:$28D9-$291C hex-neighbor helper/table: 68 retail bytes')
print('[ok] target-class, carried-child, and adjacent-supply source forms represented')
