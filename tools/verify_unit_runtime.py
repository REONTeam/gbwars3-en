#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys, re

root = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'baserom.gbc'
rom = rom_path.read_bytes()
if len(rom) != 0x100000:
    raise SystemExit(f'[fail] unexpected ROM size: {len(rom):#x}')

def bank_slice(bank, start, end):
    off = bank * 0x4000 + (start - 0x4000)
    return rom[off:off + (end - start)]

start, end = 0x404f, 0x41e3
blob = bank_slice(0x12, start, end)
sha1 = hashlib.sha1(blob).hexdigest()
expected = 'bb2263ce0f2021240a273c82c6e23fded5db7fc5'
if sha1 != expected:
    raise SystemExit(f'[fail] Bank $12:${start:04X}-${end-1:04X} SHA-1 {sha1} != {expected}')

src = (root / 'engine/unit/unit_setup.asm').read_text()
const = (root / 'constants/unit_constants.inc').read_text()
editor = (root / 'engine/map/map_editor.asm').read_text()
syms = (root / 'symbols.asm').read_text()

labels = [
    'UnitData_CopyNameToBuffer::', 'UnitRecord_GetByte::', 'UnitRecord_GetWord::',
    'UnitRecord_SetByte::', 'UnitRecord_SetWord::', 'UnitRecord_AddExperienceClamped::',
    'UnitRecord_GetExperienceRank::', 'UnitRecord_CopyToScratch::',
    'UnitRecord_CopyFromScratch::', 'Unit_FindAtCoordinates::',
    'Unit_MoveCarriedChildrenToCoordinates::',
]
for label in labels:
    if label not in src:
        raise SystemExit(f'[fail] missing source label {label}')

required = {
    'UNIT_RECORD_STATUS_OFFSET': 3,
    'UNIT_RECORD_CARRIED_COUNT_OFFSET': 5,
    'UNIT_RECORD_CARRIER_INDEX_OFFSET': 6,
    'UNIT_RECORD_EXPERIENCE_OFFSET': 0x0a,
    'UNIT_RECORD_STATUS_CARRIED_F': 0,
}
for name, value in required.items():
    m = re.search(rf'^DEF\s+{name}\s+EQU\s+([^;\n]+)', const, re.M)
    if not m:
        raise SystemExit(f'[fail] missing constant {name}')
    expr = m.group(1).strip().lower().replace('$','0x')
    if int(expr, 0) != value:
        raise SystemExit(f'[fail] {name} changed: {expr}')

if 'farcall UnitData_CopyNameToBuffer' not in editor:
    raise SystemExit('[fail] Map Editor still uses raw Bank $12:$404F farcall')
if 'sym $00, $cd28, wUnitNameBuffer' not in syms:
    raise SystemExit('[fail] wUnitNameBuffer symbol missing')
if 'sym $00, $ccdd, wUnitRecordScratch' not in syms:
    raise SystemExit('[fail] wUnitRecordScratch symbol missing')

# Key byte anchors independently lock each functional subrange boundary in retail.
anchors = {
    0x404f: 'c5d5e5cd2040545d2128cd010a00cd503baf77e1d1c1c9',
    0x4066: 'c5e547f082f53e03e082e07078cd294006000946f1e082e07078e1c1c9',
    0x414e: 'c5d5e550590600780e00cd6640a7281c780e01cd6640ba2013780e02cd6640bb200a780e03cd6640cb47280a',
    0x4189: 'c5d5e557f082f53e03e082e0701e00',
}
for addr, hexbytes in anchors.items():
    expected_bytes = bytes.fromhex(hexbytes)
    got = bank_slice(0x12, addr, addr + len(expected_bytes))
    if got != expected_bytes:
        raise SystemExit(f'[fail] retail anchor mismatch at Bank $12:${addr:04X}')

print(f'[ok] Bank $12:${start:04X}-${end-1:04X}: {len(blob)} retail bytes, SHA-1 {sha1}')
print('[ok] 11 unit-runtime helper labels represented in source')
print('[ok] carried-unit semantics: status byte $03 bit 0, child count $05, carrier index $06')
print('[ok] Map Editor unit-name path uses UnitData_CopyNameToBuffer')
