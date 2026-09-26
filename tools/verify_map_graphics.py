#!/usr/bin/env python3
from __future__ import annotations
from pathlib import Path
import hashlib
import struct

ROOT = Path(__file__).resolve().parents[1]
ROM = ROOT / "baserom.gbc"
EXPECTED = [
    ("ROM0 map-screen coordinate", 0x00, 0x15DD, 0x15F8, "a36017d5d7b34cbb570fe400dfcbf8d2d7bee17a"),
    ("ROM0 map renderer", 0x00, 0x16B6, 0x1899, "9f36d3356d1626cc304f5fa0f2de2b8d3a8aac3e"),
    ("ROM0 terrain-name index", 0x00, 0x18AB, 0x18DF, "daa7fc8e12c99121fa1b53192cc242c1c232c442"),
    ("ROM0 base metatiles", 0x00, 0x1C6C, 0x1E0C, "c0f3d72a1a8757e92727e0c98e2f1acbd7887b0d"),
    ("ROM0 overlay metatiles", 0x00, 0x1E0C, 0x2164, "8c7010a9c21a99c6ca94c28e6f0234ca3e60f025"),
    ("ROM0 terrain animation runtime", 0x00, 0x2164, 0x2273, "f23c0d875667e006cc492360f9f59fa9176e1f15"),
    ("ROM0 sea animation", 0x00, 0x2273, 0x2333, "767740baa486a8cb28ff18153091854e0f294580"),
    ("ROM0 river animation", 0x00, 0x2333, 0x23F3, "97c54205d66dbc2d26a9e35135760f7979467e6a"),
    ("ROM0 bridge1 animation", 0x00, 0x23F3, 0x24B3, "9762cb004868eff167cab078ad1e45d36ccd9ae6"),
    ("ROM0 bridge2 animation", 0x00, 0x24B3, 0x2573, "9762cb004868eff167cab078ad1e45d36ccd9ae6"),
    ("ROM0 shoal animation", 0x00, 0x2573, 0x2633, "40423167471c93d8ef5a7091414d6cf14cb2d935"),
    ("Bank $0B terrain-name helper", 0x0B, 0x4707, 0x4714, "e38a27ad4dc87298f5f6d5b0fe451b7e28a754a5"),
    ("Bank $01 map-graphics loader", 0x01, 0x401C, 0x40CE, "523248bcb65f0325c9c5fa66ce3897a73067da19"),
    ("Bank $01 terrain graphics", 0x01, 0x5268, 0x5868, "a42f76a43daa629192a41a829a00e275650c032e"),
]

def rom_slice(rom: bytes, bank: int, start: int, end: int) -> bytes:
    off = start if bank == 0 else bank * 0x4000 + (start - 0x4000)
    return rom[off:off + end - start]

def png_info(path: Path) -> tuple[int, int, int, int]:
    b = path.read_bytes()
    assert b[:8] == b"\x89PNG\r\n\x1a\n"
    assert b[12:16] == b"IHDR"
    width, height, depth, color = struct.unpack(">IIBB", b[16:26])
    return width, height, depth, color

def main() -> None:
    assert ROM.exists(), "baserom.gbc required for ROM-backed map-graphics verification"
    rom = ROM.read_bytes()
    assert len(rom) >= 0x100000
    for name, bank, start, end, expected in EXPECTED:
        data = rom_slice(rom, bank, start, end)
        sha = hashlib.sha1(data).hexdigest()
        assert sha == expected, (name, sha, expected)
    raw = rom_slice(rom, 1, 0x5268, 0x5868)
    built = ROOT / "gfx/environment/map/terrain_tiles.2bpp"
    if built.exists():
        assert built.read_bytes() == raw
    assert png_info(ROOT / "gfx/environment/map/source_tiles/terrain_tiles.png")[:2] == (128, 48)
    assert png_info(ROOT / "gfx/environment/map/terrain_tiles.png")[:2] == (160, 140)
    previews = list((ROOT / "gfx/environment/map/metatiles").rglob("*.png"))
    assert len(previews) == 0x34, len(previews)
    assert all(png_info(p)[:2] == (16, 16) for p in previews)

    home = (ROOT / "engine/home/home_map.asm").read_text()
    for token in [
        "MapScreenTilemapCoord::", "BasicMapTileUpdate::", "MapTile_DrawCell::",
        "MapTile_WriteMetatile::", "TerrainNameIndexByMapTile::", "MapMetatileDefinitions::",
        "MapMetatile_Plain::", "MapMetatile_Sea::", "MapMetatile_Shoal::",
        "MapMetatileDefinitions_Overlay::", "MapMetatileDefinitions_OverlayEnd::",
        "assert @ == $1899", "assert @ == $18df", "assert @ == $1e0c", "assert @ == $2164",
    ]:
        assert token in home, token
    gfx = (ROOT / "engine/map/map_graphics.asm").read_text()
    for token in [
        "MapGraphics_LoadGameplayAssets::", "MapTerrainTiles::",
        'incbin "gfx/environment/map/terrain_tiles.2bpp"', "assert @ == $40ce", "assert @ == $5868",
    ]:
        assert token in gfx, token
    terrain = (ROOT / "data/terrain.asm").read_text()
    assert "Terrain_GetNameIndex::" in terrain and "assert @ == $4714" in terrain
    constants = (ROOT / "constants/map_constants.inc").read_text()
    for token in [
        "MAP_TERRAIN_PLAIN     EQU $20", "MAP_TERRAIN_ROAD      EQU $21",
        "MAP_TERRAIN_MOUNTAIN  EQU $24", "MAP_TERRAIN_WOOD      EQU $25",
        "MAP_TERRAIN_WASTELAND EQU $26", "MAP_TERRAIN_DESERT    EQU $27",
        "MAP_TERRAIN_RIVER     EQU $28", "MAP_TERRAIN_SEA       EQU $29",
        "MAP_TERRAIN_SHOAL     EQU $2A", "MAP_TERRAIN_GFX_TILE_COUNT EQU 96",
        "MAP_OVERLAY_METATILE_COUNT EQU $6b", "MAP_UNIT_OVERLAY_METATILE_COUNT EQU $6a",
        "MAP_METATILE_COUNT EQU $9f", "MAP_UNIT_OVERLAY_METATILE_FIRST EQU $34",
        "MAP_SPECIAL_OVERLAY_METATILE EQU $9e",
    ]:
        assert token in constants, token
    # Reconstruct the complete source-backed overlay table.
    overlay_source = home.split('MapMetatileDefinitions_Overlay::', 1)[1].split('MapMetatileDefinitions_OverlayEnd::', 1)[0]
    rows = []
    for line in overlay_source.splitlines():
        line = line.strip()
        if line.startswith('map_metatile '):
            rows.append(bytes(int(x.strip().replace('$', ''), 16) for x in line[len('map_metatile '):].split(',')))
    assert len(rows) == 0x6B, len(rows)
    assert b''.join(rows) == rom_slice(rom, 0, 0x1E0C, 0x2164)

    # IDs $34-$9D correspond to encoded UnitData type/side bytes $00-$69.
    mapping = ROOT / 'gfx/units/map_icons/runtime_metatiles.csv'
    lines = mapping.read_text().splitlines()
    assert len(lines) == 54
    for unit_type, line in enumerate(lines[1:]):
        parts = line.split(',')
        assert int(parts[0]) == unit_type
        assert parts[2] == f'0x{unit_type * 2:02X}'
        assert parts[3] == f'0x{0x34 + unit_type * 2:02X}'
        assert parts[4] == f'0x{unit_type * 2 + 1:02X}'
        assert parts[5] == f'0x{0x35 + unit_type * 2:02X}'
    composed = ROOT / 'gfx/units/map_icons/composed'
    assert len(list(composed.rglob('metatile.txt'))) == 53
    assert len(list(composed.rglob('icon.png'))) == 53
    assert not list(composed.rglob('side0.png'))
    assert not list(composed.rglob('side1.png'))
    assert (ROOT / 'gfx/units/map_icons/README.md').exists()

    # Five animated map families are editable three-phase build assets.
    anim = ROOT / 'gfx/environment/map/animations'
    for name in ['sea', 'river', 'bridge1', 'bridge2', 'shoal']:
        assert png_info(anim / f'{name}.png')[:2] == (32, 24)
        phases = [anim / name / f'phase{i}.png' for i in range(3)]
        assert all(p.exists() and png_info(p)[:2] == (32, 8) for p in phases)
    for token in ['MapTerrainAnimation_Reset::', 'MapTerrainAnimation_Update::',
                  'MapTerrainAnimation_Sea::', 'MapTerrainAnimation_River::',
                  'MapTerrainAnimation_Bridge1::', 'MapTerrainAnimation_Bridge2::',
                  'MapTerrainAnimation_Shoal::', 'assert @ == $2633']:
        assert token in home, token

    makefile = (ROOT / "Makefile").read_text()
    assert "engine/map/map_graphics.o" in makefile
    assert "gfx/environment/map/terrain_tiles.2bpp" in makefile
    print("[ok] gameplay map graphics: terrain, 159 metatiles, unit overlays, and animations ROM-verified")
    print("     terrain graphics SHA-1 a42f76a43daa629192a41a829a00e275650c032e")
    print("     overlay metatiles SHA-1 8c7010a9c21a99c6ca94c28e6f0234ca3e60f025")
    print("     53 neutral UnitData map-icon compositions + side metadata + 5 three-phase terrain animations organized")

if __name__ == "__main__":
    main()
