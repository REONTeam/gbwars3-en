#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys
ROOT = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'baserom.gbc'
rom = rom_path.read_bytes()
if len(rom) != 0x100000:
    raise SystemExit(f'[fail] unexpected ROM size: {len(rom):#x}')
start, end = 0x4714, 0x4822
off = 0x0B * 0x4000 + (start - 0x4000)
blob = rom[off:off + end - start]
expected = '6384fc290afd30f9a13daa4fa0df6939c2b615a7'
sha = hashlib.sha1(blob).hexdigest()
if sha != expected:
    raise SystemExit(f'[fail] Bank $0B:$4714-$4821 SHA-1 {sha} != {expected}')
terrain = (ROOT/'data/terrain.asm').read_text()
symbols = (ROOT/'symbols.asm').read_text()
editor = (ROOT/'engine/map/map_editor.asm').read_text()
units = (ROOT/'engine/unit/unit_setup.asm').read_text()
doc = (ROOT/'docs/map/map_tile_runtime_contract.md').read_text()
required = [
    'section "Map Tile Runtime Helpers", romx[$4714], bank[$0b]',
    'MapTile_ReadBank1AtCoordinates::', 'MapTile_ReadBank2AtCoordinates::',
    'MapTile_WriteBank1AtCoordinates::', 'MapTile_WriteBank2AtCoordinates::',
    'MapTile_GetBaseIdAtCoordinates::', 'MapTile_SetBaseIdAtCoordinates::',
    'MapTile_GetOverlayIdAtCoordinates::', 'MapTile_SetOverlayByteAtCoordinates::',
    'MapTile_SetFlagAtCoordinates::', 'MapTile_ClearFlagsAtCoordinates::',
    'MapTile_ClearAllFlagsAtCoordinates::',
    'MapTile_SetBank2Flag7AtCoordinates::', 'MapTile_ClearBank2Flag7AtCoordinates::',
    'assert @ == $4822',
]
for x in required:
    if x not in terrain:
        raise SystemExit(f'[fail] missing sourced map-tile form: {x}')
for raw in [r'sym\s+\$0b,\s*\$4770', r'sym\s+\$0b,\s*\$47bf']:
    if re.search(raw, symbols, re.I):
        raise SystemExit('[fail] obsolete symbol-only map-tile anchor remains')
if 'farcall $0b, MapTile_GetBaseIdAtCoordinates' not in editor:
    raise SystemExit('[fail] Map Editor does not use sourced base-ID helper')
if 'farcall $0b, MapTile_ClearFlagsAtCoordinates' not in units:
    raise SystemExit('[fail] unit runtime does not use sourced flag-clear helper')
for text in [editor, units]:
    if re.search(r'farcall\s+\$0b,\s*\$(?:4770|47bf)\b', text, re.I):
        raise SystemExit('[fail] raw map-tile farcall remains')
for phrase in ['selector 0 -> WRAM bank 2 bit 7', 'selector 1 -> WRAM bank 1 bit 6', 'selector 2 -> WRAM bank 1 bit 7']:
    if phrase not in doc:
        raise SystemExit(f'[fail] missing selector documentation: {phrase}')
print(f'[ok] Bank $0B:$4714-$4821: {len(blob)} retail bytes, SHA-1 {sha}')
print('[ok] map-cell bank1/bank2 access, base/overlay IDs, and 3-way status selectors are source-backed')
