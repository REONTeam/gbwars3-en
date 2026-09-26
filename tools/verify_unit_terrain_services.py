#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "baserom.gbc"
UNIT_SRC = (ROOT / "engine" / "unit" / "unit_setup.asm").read_text()
TERRAIN_SRC = (ROOT / "data" / "terrain.asm").read_text()
MAP_CONST = (ROOT / "constants" / "map_constants.inc").read_text()
rom = ROM.read_bytes()
def bank_slice(bank, start, end):
    off = bank * 0x4000 + (start - 0x4000)
    return rom[off:off + end - start]
unit = bank_slice(0x12, 0x4656, 0x4741)
terrain = bank_slice(0x0B, 0x7CF7, 0x7D24)
unit_sha = hashlib.sha1(unit).hexdigest()
terrain_sha = hashlib.sha1(terrain).hexdigest()
assert unit_sha == "ccbe13a1a6219e3247aa3f525f7179f00882d9b2", unit_sha
assert terrain_sha == "7fdae632ba3adbf62593cfe0cf68237cd4b66596", terrain_sha
for label in ["Unit_CanResupplyAtCurrentTerrain", "Unit_CanRepairAtCurrentTerrain", "Unit_CanRepairOnMapTile"]:
    assert label + "::" in UNIT_SRC, label
for token in ["MOVEMENT_TERRAIN_RUNWAY", "MOVEMENT_TERRAIN_AIRPORT", "MOVEMENT_TERRAIN_PORT", "MAP_TILE_PHASE_CLASS_CURRENT_PROPERTY"]:
    assert token in UNIT_SRC, token
assert "MapTile_ClassifyOwnershipForCurrentPhase::" in TERRAIN_SRC
for token in ["MAP_TILE_PHASE_CLASS_CURRENT_PROPERTY", "MAP_TILE_PHASE_CLASS_OPPOSING_PROPERTY", "MAP_TILE_PHASE_CLASS_NEUTRAL_PROPERTY", "MAP_TILE_PHASE_CLASS_NON_PROPERTY"]:
    assert token in MAP_CONST, token
assert "assert @ == $4741" in UNIT_SRC.lower()
assert "assert @ == $7d24" in TERRAIN_SRC.lower()
print(f"Unit terrain service runtime: {len(unit)} bytes, SHA-1 {unit_sha} [ok]")
print(f"Map-tile phase ownership classifier: {len(terrain)} bytes, SHA-1 {terrain_sha} [ok]")
