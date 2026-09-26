#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'baserom.gbc'
rom = ROM.read_bytes()

def retail(bank, start, end):
    off = start if bank == 0 else bank * 0x4000 + (start - 0x4000)
    return rom[off:off + end - start]

checks = [
    (0x0B, 0x792A, 0x7A53, 'decimal number renderers', 'c6e964ef3476679507415fdfae8f81387eea2509'),
    (0x0B, 0x7A53, 0x7A9D, 'map economy status panel', '1c4210cbfd2bf4a1742a73f35b5037c6a567c15e'),
    (0x0B, 0x7A9D, 0x7ACB, 'dual-VRAM panel row clearer', '1b34e6d602657d7646de6cbfc54d5a5bc3adb64f'),
    (0x0B, 0x7ACB, 0x7B01, 'viewport centering helper', '048b22b9360fcdd96951f8fe8b32a175c7893de5'),
]
for bank, start, end, name, expected in checks:
    got = hashlib.sha1(retail(bank, start, end)).hexdigest()
    if got != expected:
        raise SystemExit(f'{name} ROM hash mismatch: {got}')

number = (ROOT/'engine/ui/number_renderers_792a.asm').read_text()
econ = (ROOT/'engine/map/map_economy_panel_7a53.asm').read_text()
clear = (ROOT/'engine/home/home_vram_clear_rows_7a9d.asm').read_text()
center = (ROOT/'engine/map/map_viewport_center_7acb.asm').read_text()
syms = (ROOT/'symbols.asm').read_text()
make = (ROOT/'Makefile').read_text()

for token in (
    'DrawNumber3Digits::', 'DrawNumber5Digits::',
    'MapEconomy_DrawCurrentSideGold::',
    'NumberRenderer_AppendDigit::', 'NumberRenderer_AppendDigitFromA::',
    'assert @ == $7a53',
):
    if token not in number:
        raise SystemExit(f'missing number-renderer source token: {token}')

for token in (
    'ld hl, wMapSide0Gold',
    'ld bc, $15a0 ; 65536 - 60000',
    'ld a, $86     ; pre-account for six ten-thousands',
    'call Vram_DrawZeroTerminatedRow',
):
    if token not in number:
        raise SystemExit(f'missing current-side Gold behavior: {token}')

for token in (
    'MapEconomy_DrawStatusPanel::',
    'call MapEconomy_DrawCurrentSideGold',
    'call MapEconomy_GetCurrentSideMaterials',
    'call DrawNumber5Digits',
    'MapEconomy_CloseStatusPanel::',
    'assert @ == $7a9d',
):
    if token not in econ:
        raise SystemExit(f'missing economy-panel behavior: {token}')

for token in (
    'Vram_ClearPanelRowsBothBanks::',
    'ld hl, $9c00',
    'ld bc, $0014',
    'call Memset',
    'assert @ == $7acb',
):
    if token not in clear:
        raise SystemExit(f'missing VRAM-row clearer behavior: {token}')

for token in (
    'MapViewport_CenterOnCoordinates::',
    'ld a, [wMapGridWidth]', 'sub $09',
    'ld [wMapViewportOriginX], a',
    'ld a, [wMapGridHeight]',
    'ld [wMapViewportOriginY], a',
    'call MapCursor_SetMapCoordinates',
    'assert @ == $7b01',
):
    if token not in center:
        raise SystemExit(f'missing viewport-centering behavior: {token}')

for token in (
    'sym $00, $c98b, wMapViewportOriginX',
    'sym $00, $c98c, wMapViewportOriginY',
    'sym $00, $cc45, wNumberRenderLeadingState',
    'sym $00, $cc46, wNumberRenderBuffer',
):
    if token.lower() not in syms.lower():
        raise SystemExit(f'missing display-helper symbol: {token}')

for obj in (
    'engine/ui/number_renderers_792a.o',
    'engine/map/map_economy_panel_7a53.o',
    'engine/home/home_vram_clear_rows_7a9d.o',
    'engine/map/map_viewport_center_7acb.o',
):
    if obj not in make:
        raise SystemExit(f'missing Makefile object: {obj}')

# Direct ROM behavior anchors.
number_bytes = retail(0x0B, 0x792A, 0x7A53)
if bytes([0xFA,0x33,0xC6,0xE6,0x01,0x5F,0x87,0x83,0xC6,0x02,0x21,0x34,0xC6]) not in number_bytes:
    raise SystemExit('current-side 3-byte Gold selector contract changed')
if bytes([0x01,0xA0,0x15,0x09,0x3E,0x86,0x01,0xF0,0xD8]) not in number_bytes:
    raise SystemExit('24-bit Gold 65536 decomposition contract changed')

center_bytes = retail(0x0B, 0x7ACB, 0x7B01)
for needle, desc in [
    (bytes([0xFA,0x89,0xC9,0xD6,0x05]), 'width-5 clamp'),
    (bytes([0xFA,0x89,0xC9,0xD6,0x09,0xEA,0x8B,0xC9]), 'width-9 right edge'),
    (bytes([0xFA,0x8A,0xC9,0xD6,0x09]), 'height-9 bottom edge'),
    (bytes([0xEA,0x8C,0xC9,0xCD,0xD9,0x45,0xC9]), 'origin store and stage call'),
]:
    if needle not in center_bytes:
        raise SystemExit(f'missing viewport behavior: {desc}')

print('[ok] Bank $0B:$792A-$7B00 display/economy/viewport families are ROM-locked')
print('[ok] three/five-digit and 24-bit Gold rendering semantics verified')
print('[ok] 9x9 viewport origin clamping and sourced callers integrated')
