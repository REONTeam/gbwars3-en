#!/usr/bin/env python3
from pathlib import Path
import hashlib
import sys

ROM = Path(sys.argv[1]) if len(sys.argv) > 1 and sys.argv[1] else Path("baserom.gbc")
BANK = 0x0B
START = 0x4551
END = 0x4707
EXPECTED_SHA1 = "52faeb35911b3ae75ba11f68e20393e9cef382e2"
SOURCE = Path("engine/map/map_cursor_presentation_runtime_4551.asm")


def rom_offset(bank, addr):
    return bank * 0x4000 + (addr - 0x4000)


def hits(data, pat):
    out = []
    pos = 0
    while True:
        pos = data.find(pat, pos)
        if pos < 0:
            return out
        bank = pos // 0x4000
        addr = (pos % 0x4000) + (0 if bank == 0 else 0x4000)
        out.append((bank, addr))
        pos += 1


rom = ROM.read_bytes()
chunk = rom[rom_offset(BANK, START):rom_offset(BANK, END)]
assert len(chunk) == END - START
assert hashlib.sha1(chunk).hexdigest() == EXPECTED_SHA1, "Bank $0B:$4551-$4706 retail range changed"

# Proven public entries remain independently called/reused.
assert hits(rom, bytes([0xCD, 0x51, 0x45])) == [(0x0B, 0x75BF), (0x0B, 0x75F8)]
assert hits(rom, bytes([0xCD, 0x5D, 0x45])) == [(0x0B, 0x7548), (0x0B, 0x7581)]
assert hits(rom, bytes([0xCD, 0x71, 0x45])) == [(0x0B, 0x7503), (0x0B, 0x7B64)]
assert hits(rom, bytes([0xCD, 0xC1, 0x45])) == [(0x0B, 0x69EF), (0x0B, 0x6A55), (0x0B, 0x7506), (0x0B, 0x7B67)]
assert hits(rom, bytes([0xCD, 0xD9, 0x45]))[-1] == (0x0B, 0x7AFD)
assert hits(rom, bytes([0xEF, 0x0B, 0xD9, 0x45])) == [(0x0C, 0x41AB), (0x0C, 0x432F)]
assert (0x0B, 0x7B6A) in hits(rom, bytes([0xCD, 0x54, 0x46]))
assert hits(rom, bytes([0xCD, 0xF9, 0x46])), "$46F9 show entry must remain reused"
assert hits(rom, bytes([0xCD, 0x00, 0x47])), "$4700 hide entry must remain reused"

src = SOURCE.read_text()
for label in (
    "MapTileUpdate_QueueHorizontalStrip::",
    "MapTileUpdate_QueueVerticalStrip::",
    "MapTileUpdate_CommitCompletedScroll::",
    "MapCursor_UpdateAbsoluteCoordinates::",
    "MapCursor_SetMapCoordinates::",
    "MapCursor_UpdateSpritePosition::",
    "MapCursor_LoadGraphics::",
    "MapCursor_Create::",
    "MapCursor_Destroy::",
    "MapCursor_UpdatePropertyEligibilityAppearance::",
    "MapCursor_Hide::",
    "MapCursor_Show::",
):
    assert label in src, f"missing source label: {label}"
assert "    db " not in src, "new map cursor runtime should be readable source, not raw db"
assert "assert @ == $4707" in src

symbols = Path("symbols.asm").read_text()
sprite_source = Path("engine/home/home_sprite_object.asm").read_text()
for name in (
    "wMapCursorSpriteObjectId",
    "wMapCursorSpriteVariant",
    "wMapCursorOffsetX",
    "wMapCursorOffsetY",
):
    assert name in symbols, f"missing promoted symbol: {name}"
for name in ("SpriteObject_SetAnimation::", "SpriteObject_Hide::", "SpriteObject_Show::"):
    assert name in sprite_source, f"missing source-backed sprite entry: {name}"

# Already-source-backed consumers should no longer use the old raw entry addresses.
for path in Path("engine").rglob("*.asm"):
    if path == SOURCE:
        continue
    text = path.read_text()
    for old in ("call $4551", "call $455d", "call $4571", "call $45c1", "call $45d9", "call $464d", "call $4654", "call $46f9", "call $4700", "call $2ee8"):
        assert old not in text, f"{path}: stale raw call {old}"

print("map cursor/presentation runtime: OK")
