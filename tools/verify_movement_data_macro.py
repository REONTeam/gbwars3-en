#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
UNIT = ROOT / "engine/unit/unit.asm"
CONSTANTS = ROOT / "constants/unit_constants.inc"
MACROS = ROOT / "macros/unit_macros.inc"

PROFILE_COUNT = 15
PROFILE_SIZE = 23
EXPECTED_SHA1 = "4f2a657c0be8d1aaf6e369e0cc5600e4f5a6651f"
EXPECTED_TERRAINS = [
    ("MOVEMENT_TERRAIN_HQ_0", "HQ variant 0"),
    ("MOVEMENT_TERRAIN_HQ_1", "HQ variant 1"),
    ("MOVEMENT_TERRAIN_CITY", "city"),
    ("MOVEMENT_TERRAIN_CITY_RUINS", "city ruins"),
    ("MOVEMENT_TERRAIN_BASE", "base / factory"),
    ("MOVEMENT_TERRAIN_BASE_RUINS", "base / factory ruins"),
    ("MOVEMENT_TERRAIN_AIRPORT", "airport"),
    ("MOVEMENT_TERRAIN_AIRPORT_RUINS", "airport ruins"),
    ("MOVEMENT_TERRAIN_RUNWAY", "runway / temporary airport"),
    ("MOVEMENT_TERRAIN_PORT", "port"),
    ("MOVEMENT_TERRAIN_PORT_RUINS", "port ruins"),
    ("MOVEMENT_TERRAIN_COM_TOWER", "COM tower"),
    ("MOVEMENT_TERRAIN_PLAIN", "plain"),
    ("MOVEMENT_TERRAIN_ROAD", "road"),
    ("MOVEMENT_TERRAIN_BRIDGE_1", "bridge 1"),
    ("MOVEMENT_TERRAIN_BRIDGE_2", "bridge 2"),
    ("MOVEMENT_TERRAIN_MOUNTAIN", "mountain"),
    ("MOVEMENT_TERRAIN_WOOD", "wood"),
    ("MOVEMENT_TERRAIN_WASTELAND", "wasteland"),
    ("MOVEMENT_TERRAIN_DESERT", "desert"),
    ("MOVEMENT_TERRAIN_RIVER", "river"),
    ("MOVEMENT_TERRAIN_SEA", "sea"),
    ("MOVEMENT_TERRAIN_SHOAL", "shoal"),
]


def require(cond, msg):
    if not cond:
        raise SystemExit(f"[fail] {msg}")


def parse_def(text, name):
    m = re.search(rf"^DEF\s+{re.escape(name)}\s+EQU\s+([^;\n]+)", text, re.M)
    require(m, f"missing constant {name}")
    value = m.group(1).strip()
    return int(value[1:], 16) if value.startswith("$") else int(value, 0)


const = CONSTANTS.read_text(encoding="utf-8")
require(parse_def(const, "MOVEMENT_DATA_PROFILE_COUNT") == PROFILE_COUNT, "movement profile count changed")
require(parse_def(const, "MOVEMENT_DATA_PROFILE_SIZE") == PROFILE_SIZE, "movement profile size changed")
for index, (name, _) in enumerate(EXPECTED_TERRAINS):
    require(parse_def(const, name) == index, f"{name} no longer maps to movement column {index}")

macro_text = MACROS.read_text(encoding="utf-8")
start = macro_text.index("macro movement_profile")
macro = macro_text[start:]
macro = macro[:macro.index("endm")]
require("rept" not in macro, "movement_profile still hides terrain columns behind rept")
require(macro.count("db \\1") == PROFILE_SIZE, f"movement_profile does not emit {PROFILE_SIZE} explicit fields")
require(macro.count("shift") == PROFILE_SIZE, f"movement_profile does not consume {PROFILE_SIZE} arguments")
comments = re.findall(r"^\s*db\s+\\1\s*;\s*(.+?)\s*$", macro, re.M)
require(len(comments) == PROFILE_SIZE, f"expected {PROFILE_SIZE} semantic field comments, found {len(comments)}")
for index, ((constant, expected_comment), actual_comment) in enumerate(zip(EXPECTED_TERRAINS, comments)):
    require(actual_comment == expected_comment,
            f"movement field {index} ({constant}) comment changed: {actual_comment!r} != {expected_comment!r}")

unit = UNIT.read_text(encoding="utf-8")
block = unit[unit.index("MovementDataProfiles::"):unit.index("section_end $8000")]
rows = re.findall(r"^(\.Profile\d\d):\s+movement_profile\s+([^\n]+)$", block, re.M)
require(len(rows) == PROFILE_COUNT, f"expected {PROFILE_COUNT} movement profiles, found {len(rows)}")
require([r[0] for r in rows] == [f".Profile{i:02d}" for i in range(PROFILE_COUNT)], "movement profile order changed")

blob = bytearray()
for label, numeric_text in rows:
    values = [v.strip() for v in numeric_text.split(",") if v.strip()]
    require(len(values) == PROFILE_SIZE, f"{label} has {len(values)} values; expected {PROFILE_SIZE}")
    for value in values:
        n = int(value[1:], 16) if value.startswith("$") else int(value, 0)
        require(0 <= n <= 0xFF, f"{label} value out of range: {value}")
        blob.append(n)

sha1 = hashlib.sha1(blob).hexdigest()
require(len(blob) == PROFILE_COUNT * PROFILE_SIZE, "MovementData reconstructed size changed")
require(sha1 == EXPECTED_SHA1, f"MovementData bytes changed: {sha1} != {EXPECTED_SHA1}")
require("assert @ - MovementDataProfiles == MOVEMENT_DATA_PROFILE_COUNT * MOVEMENT_DATA_PROFILE_SIZE" in unit,
        "MovementData fixed-width assertion missing")

print(f"[ok] movement_profile exposes all {PROFILE_SIZE} terrain/property columns explicitly")
print("[ok] MOVEMENT_TERRAIN_* constants remain a complete 0-22 ordered schema")
print(f"[ok] {PROFILE_COUNT} profiles reconstruct {len(blob)} bytes, SHA-1 {sha1}")
