#!/usr/bin/env python3
from hashlib import sha1
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "baserom.gbc"
rom = rom_path.read_bytes()
assert len(rom) >= 0x100000, f"unexpected ROM size: {len(rom)}"


def bank_slice(bank, start, end):
    off = start if bank == 0 else bank * 0x4000 + (start - 0x4000)
    return rom[off:off + (end - start)]

# Fingerprint the exact retail ranges represented by these two source files.
ranges = {
    (0x0B, 0x4822, 0x489C): None,
    (0x00, 0x1899, 0x18AB): None,
}
for key in list(ranges):
    ranges[key] = sha1(bank_slice(*key)).hexdigest()
expected = {
    (0x0B, 0x4822, 0x489C): "9e0a4f762f57ba95d69f19a06af417d156298a43",
    (0x00, 0x1899, 0x18AB): "b7e4ef6d9c08a4684a8072a2b1bfbac765a91d90",
}
for key, digest in ranges.items():
    assert digest == expected[key], f"retail fingerprint changed for {key}: {digest} != {expected[key]}"

scan_path = ROOT / "engine/map/bank0b_scanline_transition_4822.asm"
scan = scan_path.read_text()
stat_path = ROOT / "engine/home/home_scanline_transition_stat.asm"
stat = stat_path.read_text()
symbols = (ROOT / "symbols.asm").read_text()

required_scan = (
    'section "Bank $0B scanline transition runtime", romx[$4822], bank[$0b]',
    'LCDScanlineTransition_RunToTarget::',
    'ldh [hLCDScanlineTarget], a',
    'ld hl, LCDScanlineTransition_STATHandler',
    'call SetLCDStatInterrupt',
    'set STAT_LYC_INT_F, [hl]',
    'call Interrupt_EnableLCDStat',
    'call LCD_EnableWindow',
    'ldh a, [hLCDScanlineTarget]',
    'jr nz, .loop',
    'assert @ == $4860',
    'LCDScanlineTransition_Reset::',
    'call LCD_DisableWindow',
    'call Interrupt_DisableLCDStat',
    'res STAT_LYC_INT_F, [hl]',
    'call DisableLCDStatInterrupt',
    'assert @ == $4871',
    'UnitFortify_IsAvailableAtCoordinates::',
    'call MapTile_IsNeutralPropertyRuins',
    'call MapTile_GetPhaseOwnershipClass',
    'farcall $0c, PropertyState_CompareCurrentToTerrainMaximum',
    'assert @ == $489c',
)
for token in required_scan:
    assert token in scan, f"missing scanline source token: {token}"

required_stat = (
    'section "LCD scanline transition STAT handler", rom0[$1899]',
    'LCDScanlineTransition_STATHandler::',
    'ld hl, rSTAT',
    'ldh a, [rLCDC]',
    'set LCDC_TILE_DATA_F, a',
    'bit STAT_BUSY_F, [hl]',
    'jr nz, .wait_stat_mode',
    'ldh [rLCDC], a',
    'reti',
    'assert @ == $18ab',
)
for token in required_stat:
    assert token in stat, f"missing STAT-handler source token: {token}"

assert re.search(r'sym\s+\$00,\s*\$ffb0,\s*hLCDScanlineTarget', symbols), "missing hLCDScanlineTarget symbol"
home = (ROOT / "engine/home/home.asm").read_text()
hardware = (ROOT / "constants/hardware.inc").read_text()
assert 'LCD_EnableWindow::' in home and 'set LCDC_WINDOW_ENABLE_F, a' in home, "window-enable helper not semantically named"
assert 'LCD_DisableWindow::' in home and 'res LCDC_WINDOW_ENABLE_F, a' in home, "window-disable helper not semantically named"
for token in ('DEF LCDC_WINDOW_ENABLE_F EQU 5', 'DEF LCDC_TILE_DATA_F EQU 4', 'DEF STAT_LYC_INT_F EQU 6', 'DEF STAT_BUSY_F EQU 1'):
    assert token in hardware, f"missing hardware bit constant: {token}"

# The two now-decoded routines must no longer contain anonymous byte streams.
run_to_reset = scan.split('LCDScanlineTransition_RunToTarget::', 1)[1].split('UnitFortify_IsAvailableAtCoordinates::', 1)[0]
assert not re.search(r'^\s*db\s+', run_to_reset, re.M | re.I), "decoded scanline routines still contain db statements"
handler = stat.split('LCDScanlineTransition_STATHandler::', 1)[1].split('assert @ == $18ab', 1)[0]
assert not re.search(r'^\s*db\s+', handler, re.M | re.I), "decoded STAT handler still contains db statements"

# The adjacent FORTIFY predicate is now behavior-backed and must remain mnemonic source.
predicate = scan.split('UnitFortify_IsAvailableAtCoordinates::', 1)[1].split('assert @ == $489c', 1)[0]
assert not re.search(r'^\s*db\s+', predicate, re.M | re.I), "FORTIFY predicate regressed to anonymous bytes"
fortify_avail = (ROOT / 'engine/unit/unit_action_0a_availability_6128.asm').read_text()
assert 'call UnitFortify_IsAvailableAtCoordinates' in fortify_avail
assert 'ld a, UNIT_ACTION_FORTIFY' in fortify_avail

print("[ok] Bank $0B $4822-$4870 scanline transition routines are mnemonic source")
print("[ok] Bank $0B $4871-$489B FORTIFY availability predicate is mnemonic and symbolically integrated")
print("[ok] ROM0 $1899-$18AA STAT handler is mnemonic source")
print("[ok] retail fingerprints and hLCDScanlineTarget contract verified")
