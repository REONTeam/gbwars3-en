#!/usr/bin/env python3
from pathlib import Path
import hashlib
import sys

ROOT = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "baserom.gbc"
rom = rom_path.read_bytes()

# Generic metatile-definition lookup in ROM0.
lookup = rom[0x1607:0x1614]
expected_lookup = bytes.fromhex("d5 26 00 6f 29 29 29 11 6c 1c 19 d1 c9")
assert lookup == expected_lookup, (lookup.hex(), expected_lookup.hex())

# Bank $0B metatile graphics loader + tilemap presenter.
start, end = 0x7675, 0x775f
off = 0x0B * 0x4000 + (start - 0x4000)
data = rom[off:off + (end - start)]
assert len(data) == 0xEA
assert hashlib.sha1(data).hexdigest() == "9ec78aaac2d40c23e69b6b1f992bb573b84cd766"

loader = (ROOT / "engine/unit/unit_graphic_tiles_7675.asm").read_text()
for token in [
    "UnitGraphic_LoadTiles::",
    "MapMetatile_LoadTiles::",
    "MapMetatileDefinition_Get",
    "MapTerrainTiles",
    "Image_Unit_Map_Icons",
    "farcall $01, MemcpyWaitLCD",
    "assert @ == $76c9",
]:
    assert token in loader, token

presenter = (ROOT / "engine/map/map_metatile_presenter_76c9.asm").read_text()
for token in [
    "UnitGraphic_DrawMetatile::",
    "MapMetatile_DrawTilemap::",
    "wMetatileAttributeScratch",
    "call Vram_PutWaitBlank",
    ".advance_quadrant",
    ".build_attributes",
    "assert @ == $775f",
]:
    assert token in presenter, token

home_map = (ROOT / "engine/home/home_map.asm").read_text()
for token in [
    'section "Map Metatile Definition Lookup", rom0[$1607]',
    "MapMetatileDefinition_Get::",
    "ld de, MapMetatileDefinitions",
    "assert @ == $1614",
]:
    assert token in home_map, token

symbols = (ROOT / "symbols.asm").read_text()
assert "sym $00, $caa1, wMetatileAttributeScratch" in symbols

# Already-sourced callsites should use the symbolic entry names rather than raw
# addresses now that the contracts are established.
raw_targets = ("$7675", "$7677", "$76c9", "$76C9", "$76cf", "$76CF")
for path in list((ROOT / "engine").rglob("*.asm")) + list((ROOT / "data").rglob("*.asm")):
    text = path.read_text()
    for line in text.splitlines():
        code = line.split(";", 1)[0]
        if "call" in code or "farcall" in code:
            assert not any(target in code for target in raw_targets), (path, line)

print("metatile graphics runtime verification: OK (ROM0 $1607-$1613, Bank $0B $7675-$775E)")
