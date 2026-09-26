#!/usr/bin/env python3
"""Extract the ROM-backed gameplay-map terrain tiles and metatile compositions.

This tool intentionally writes the retail reference PNG and derived compositions.
It will only create the active terrain_tiles.png when it does not already exist,
so later customized artwork is not silently overwritten.
"""
from __future__ import annotations
import argparse
import struct
import zlib
from pathlib import Path

TILE_ADDR = 0x5268
TILE_SIZE = 0x600
METATILE_ADDR = 0x1C6C
METATILE_COUNT = 0x34

NAMES = {
    0x00: "special/hq_blank",
    0x01: "properties/side0/hq",
    0x02: "properties/side0/city",
    0x03: "properties/side0/city_ruins",
    0x04: "properties/side0/factory",
    0x05: "properties/side0/factory_ruins",
    0x06: "properties/side0/airport",
    0x07: "properties/side0/airport_ruins",
    0x08: "properties/side0/runway",
    0x09: "properties/side0/port",
    0x0A: "properties/side0/port_ruins",
    0x0B: "properties/side0/com_tower",
    0x0C: "properties/side1/hq",
    0x0D: "properties/side1/city",
    0x0E: "properties/side1/city_ruins",
    0x0F: "properties/side1/factory",
    0x10: "properties/side1/factory_ruins",
    0x11: "properties/side1/airport",
    0x12: "properties/side1/airport_ruins",
    0x13: "properties/side1/runway",
    0x14: "properties/side1/port",
    0x15: "properties/side1/port_ruins",
    0x16: "properties/side1/com_tower",
    0x17: "properties/neutral/city",
    0x18: "properties/neutral/city_ruins",
    0x19: "properties/neutral/factory",
    0x1A: "properties/neutral/factory_ruins",
    0x1B: "properties/neutral/airport",
    0x1C: "properties/neutral/airport_ruins",
    0x1D: "properties/neutral/port",
    0x1E: "properties/neutral/port_ruins",
    0x1F: "properties/neutral/com_tower",
    0x20: "natural/plain",
    0x21: "natural/road",
    0x22: "natural/bridge_1",
    0x23: "natural/bridge_2",
    0x24: "natural/mountain",
    0x25: "natural/wood",
    0x26: "natural/wasteland",
    0x27: "natural/desert",
    0x28: "natural/river",
    0x29: "natural/sea",
    0x2A: "natural/shoal",
    0x2B: "sea_variants/sea_variant_2b",
    0x2C: "sea_variants/sea_variant_2c",
    0x2D: "sea_variants/sea_variant_2d",
    0x2E: "sea_variants/sea_variant_2e",
    0x2F: "sea_variants/sea_variant_2f",
    0x30: "sea_variants/sea_variant_30",
    0x31: "sea_variants/sea_variant_31",
    0x32: "special/factory_name_blank",
    0x33: "special/city_name_blank",
}


def png_gray2(path: Path, width: int, height: int, pixels: list[int]) -> None:
    """Write a 2-bit grayscale PNG from pixel values 0..3."""
    assert len(pixels) == width * height
    assert width % 4 == 0
    rows = []
    for y in range(height):
        row = bytearray([0])
        for x in range(0, width, 4):
            vals = pixels[y * width + x:y * width + x + 4]
            row.append((vals[0] << 6) | (vals[1] << 4) | (vals[2] << 2) | vals[3])
        rows.append(bytes(row))
    raw = b"".join(rows)
    def chunk(kind: bytes, payload: bytes) -> bytes:
        return struct.pack(">I", len(payload)) + kind + payload + struct.pack(">I", zlib.crc32(kind + payload) & 0xFFFFFFFF)
    data = b"\x89PNG\r\n\x1a\n"
    data += chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 2, 0, 0, 0, 0))
    data += chunk(b"IDAT", zlib.compress(raw, 9))
    data += chunk(b"IEND", b"")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)


def decode_tiles(blob: bytes) -> list[list[int]]:
    assert len(blob) % 16 == 0
    tiles = []
    for off in range(0, len(blob), 16):
        pix = []
        for y in range(8):
            lo = blob[off + y * 2]
            hi = blob[off + y * 2 + 1]
            for bit in range(7, -1, -1):
                pix.append(((hi >> bit) & 1) * 2 + ((lo >> bit) & 1))
        tiles.append(pix)
    return tiles


def tile_sheet(tiles: list[list[int]], cols: int = 16) -> tuple[int, int, list[int]]:
    rows = (len(tiles) + cols - 1) // cols
    width, height = cols * 8, rows * 8
    out = [0] * (width * height)
    for i, tile in enumerate(tiles):
        tx, ty = (i % cols) * 8, (i // cols) * 8
        for y in range(8):
            out[(ty+y)*width+tx:(ty+y)*width+tx+8] = tile[y*8:y*8+8]
    return width, height, out


def metatile_preview(tiles: list[list[int]], record: bytes) -> list[int]:
    out = [0] * (16 * 16)
    for q in range(4):
        tile_id, attr = record[q*2:q*2+2]
        tile = tiles[tile_id]
        xflip, yflip = bool(attr & 0x20), bool(attr & 0x40)
        ox, oy = (q & 1) * 8, (q >> 1) * 8
        for y in range(8):
            sy = 7-y if yflip else y
            for x in range(8):
                sx = 7-x if xflip else x
                out[(oy+y)*16 + ox+x] = tile[sy*8+sx]
    return out


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("rom", type=Path)
    ap.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    args = ap.parse_args()
    rom = args.rom.read_bytes()
    if len(rom) < 0x100000:
        raise SystemExit("ROM is too small to be the expected 1 MiB GBWars3 image")
    outdir = args.root / "gfx/environment/map"
    blob = rom[TILE_ADDR:TILE_ADDR+TILE_SIZE]
    tiles = decode_tiles(blob)
    w,h,pix = tile_sheet(tiles)
    png_gray2(outdir/"terrain_tiles.orig.png", w,h,pix)
    active = outdir/"source_tiles/terrain_tiles.png"
    if not active.exists():
        png_gray2(active,w,h,pix)
    table = rom[METATILE_ADDR:METATILE_ADDR+METATILE_COUNT*8]
    preview_root = outdir/"metatiles"
    for i in range(METATILE_COUNT):
        rel = NAMES[i]
        png_gray2(preview_root/f"{i:02x}_{Path(rel).name}.png" if "/" not in rel else preview_root/Path(rel).parent/f"{i:02x}_{Path(rel).name}.png", 16,16,metatile_preview(tiles, table[i*8:(i+1)*8]))
    print(f"extracted {len(tiles)} terrain tiles and {METATILE_COUNT} metatile compositions")

if __name__ == "__main__":
    main()
