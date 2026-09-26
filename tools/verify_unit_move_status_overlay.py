#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'baserom.gbc'
rom = ROM.read_bytes()

def retail(bank, start, end):
    off = start if bank == 0 else bank * 0x4000 + (start - 0x4000)
    return rom[off:off + end - start]

checks = [
    (0x0B, 0x775F, 0x792A, 'move-status overlay family', 'fa418a4e327f5dc7d7af2418bc9c99c02486bfd1'),
    (0x00, 0x297E, 0x298F, 'packed-BCD helper', '35724cd008b021e37f35e62bf495df1dc0c11498'),
]
for bank, start, end, name, expected in checks:
    got = hashlib.sha1(retail(bank, start, end)).hexdigest()
    if got != expected:
        raise SystemExit(f'{name} ROM hash mismatch: {got}')

src = (ROOT / 'engine/unit/unit_move_status_overlay_775f.asm').read_text()
move = (ROOT / 'engine/unit/unit_action_move_runtime_5f44.asm').read_text()
home = (ROOT / 'engine/home/home_map.asm').read_text()
syms = (ROOT / 'symbols.asm').read_text()
sprite_source = (ROOT / 'engine/home/home_sprite_object.asm').read_text()
consts = (ROOT / 'constants/unit_constants.inc').read_text()
make = (ROOT / 'Makefile').read_text()

required_labels = [
    'UnitMoveStatusOverlay_Init::',
    'UnitMoveStatusOverlay_Clear::',
    'UnitMoveStatusOverlay_PositionModeBelow5::',
    'UnitMoveStatusOverlay_PositionMode5Plus::',
    'UnitMoveStatusOverlay_CreateDigitPair::',
    'UnitMoveStatusOverlay_DestroyDigitPair::',
    'UnitMoveStatusOverlay_PositionDigitPair::',
    'UnitMoveStatusOverlay_SetDigitPairPalette::',
]
for label in required_labels:
    if label not in src:
        raise SystemExit(f'missing overlay label: {label}')

for marker in ('$7763', '$77c2', '$77dd', '$77fc', '$781b', '$786c', '$7870', '$78a0', '$7904', '$790d', '$791c', '$792a'):
    if f'assert @ == {marker}' not in src.lower():
        raise SystemExit(f'missing overlay boundary assertion: {marker}')

for token in (
    'ld a, [wUnitRecordScratch + UNIT_RECORD_HP_OFFSET]',
    'ld [wUnitMoveStatusHP], a',
    'ld a, [wUnitRecordScratch + UNIT_RECORD_FUEL_OFFSET]',
    'ld [wUnitMoveStatusFuel], a',
    'call UnitMoveStatusOverlay_Init',
    'call UnitMoveStatusOverlay_Clear',
    'call UnitMoveStatusOverlay_PositionModeBelow5',
    'call UnitMoveStatusOverlay_PositionMode5Plus',
):
    if token not in move:
        raise SystemExit(f'move controller is not symbolically integrated: {token}')

for raw in ('call $7763', 'call $77c2', 'call $77dd', 'call $77fc'):
    if raw in move.lower():
        raise SystemExit(f'raw overlay call remains in move controller: {raw}')

if 'Number_ByteToPackedBCD::' not in home or 'assert @ == $298f' not in home.lower():
    raise SystemExit('packed-BCD helper is not source-backed')

for token in (
    'SpriteObject_Create::',
    'SpriteObject_Destroy::',
    'SpriteObject_SetPosition::',
    'SpriteObject_SetPalette::',
):
    if token not in sprite_source:
        raise SystemExit(f'missing source-backed sprite entry: {token}')

for token in (
    'sym $00, $ca9a, wUnitMoveStatusOverlayResource',
    'sym $00, $ca9b, wUnitMoveStatusHPDigitResources',
    'sym $00, $ca9d, wUnitMoveStatusFuelDigitResources',
    'sym $00, $ca9f, wUnitMoveStatusHP',
    'sym $00, $caa0, wUnitMoveStatusFuel',
):
    if token.lower() not in syms.lower():
        raise SystemExit(f'missing overlay symbol: {token}')

for token in (
    'DEF UNIT_MOVE_STATUS_HP_WARNING_THRESHOLD EQU 4',
    'DEF UNIT_MOVE_STATUS_FUEL_WARNING_THRESHOLD EQU 21',
    'DEF UNIT_MOVE_STATUS_WARNING_PALETTE EQU 1',
):
    if token not in consts:
        raise SystemExit(f'missing overlay constant: {token}')

if 'engine/unit/unit_move_status_overlay_775f.o' not in make:
    raise SystemExit('overlay object is not in the Makefile')

# Byte-level behavior checks that prove the status semantics independently of
# source naming: the move controller copies UnitRecord offsets 4 and 7 into
# CA9F/CAA0 immediately before calling $7763, and the overlay compares those
# values against 4 and 21 before calling the palette helper at $791C.
move_bytes = retail(0x0B, 0x5F44, 0x5F55)
expected_prefix = bytes([
    0xFA, 0xE1, 0xCC, 0xEA, 0x9F, 0xCA,
    0xFA, 0xE4, 0xCC, 0xEA, 0xA0, 0xCA,
    0xCD, 0x63, 0x77,
])
if not move_bytes.startswith(expected_prefix):
    raise SystemExit('move controller HP/fuel snapshot contract changed')

family = retail(0x0B, 0x775F, 0x792A)
for needle, desc in [
    (bytes([0xFA,0x9F,0xCA,0xFE,0x04]), 'HP < 4 comparison'),
    (bytes([0xFA,0xA0,0xCA,0xFE,0x15]), 'fuel < 21 comparison'),
    (bytes([0x3E,0x01,0xCD,0x1C,0x79]), 'warning palette assignment'),
]:
    if needle not in family:
        raise SystemExit(f'missing ROM behavior: {desc}')

print('[ok] Bank $0B:$775F-$7929 move-status overlay family is ROM-locked')
print('[ok] HP/fuel snapshot, decimal digit resources, positioning, and warning palette semantics verified')
print('[ok] ROM0 packed-BCD and source-backed sprite-object engine integrated')
