#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
UNIT = ROOT / "engine/unit/unit.asm"
CONSTANTS = ROOT / "constants/unit_constants.inc"
MACROS = ROOT / "macros/unit_macros.inc"
CHARMAP = ROOT / "charmaps/char_unit.inc"

WEAPON_COUNT = 33
WEAPON_RECORD_SIZE = 0x10
WEAPON_NAME_LENGTH = 8
WEAPON_SHA1 = "b68642066c77923ca6895eb595c35c99ed1aa42e"
WEAPON_START = 0x5256
WEAPON_RECORDS_START = 0x5298
WEAPON_END = 0x54A8

MOVE_COUNT = 15
MOVE_RECORD_SIZE = 23
MOVE_SHA1 = "4f2a657c0be8d1aaf6e369e0cc5600e4f5a6651f"
MOVE_START = 0x54A8
MOVE_RECORDS_START = 0x54C6
MOVE_END = 0x561F


def require(cond, msg):
    if not cond:
        raise SystemExit(f"[fail] {msg}")


def parse_def(text, name):
    m = re.search(rf"^DEF\s+{re.escape(name)}\s+EQU\s+([^;\n]+)", text, re.M)
    require(m, f"missing constant {name}")
    expr = m.group(1).strip()
    if expr.startswith("$"):
        return int(expr[1:], 16)
    return int(expr, 0)


const = CONSTANTS.read_text(encoding="utf-8")
for name, expected in {
    "WEAPON_DATA_COUNT": WEAPON_COUNT,
    "WEAPON_DATA_RECORD_SIZE": WEAPON_RECORD_SIZE,
    "WEAPON_DATA_NAME_LENGTH": WEAPON_NAME_LENGTH,
    "WEAPON_DATA_MIN_RANGE_OFFSET": 0x08,
    "WEAPON_DATA_MAX_RANGE_OFFSET": 0x09,
    "WEAPON_DATA_TARGET_VALUES_OFFSET": 0x0A,
    "WEAPON_DATA_TARGET_VALUES_COUNT": 5,
    "WEAPON_DATA_COST_OFFSET": 0x0F,
    "MOVEMENT_DATA_PROFILE_COUNT": MOVE_COUNT,
    "MOVEMENT_DATA_PROFILE_SIZE": MOVE_RECORD_SIZE,
}.items():
    require(parse_def(const, name) == expected, f"{name} changed")

macro_text = MACROS.read_text(encoding="utf-8")
require("macro weapon_data" in macro_text, "weapon_data macro missing")
require("macro movement_profile" in macro_text, "movement_profile macro missing")
weapon_macro = macro_text[macro_text.index("macro weapon_data"):]
weapon_macro = weapon_macro[:weapon_macro.index("endm")]
require(weapon_macro.count("shift") == WEAPON_RECORD_SIZE - WEAPON_NAME_LENGTH,
        "weapon_data does not consume the fixed eight numeric fields")
for phrase in ("minimum range", "maximum range", "attack: armored", "attack: unarmored",
               "attack: air", "attack: sea", "attack: submarine", "cost per shot"):
    require(phrase in weapon_macro, f"weapon_data missing semantic field comment: {phrase}")
movement_macro = macro_text[macro_text.index("macro movement_profile"):]
movement_macro = movement_macro[:movement_macro.index("endm")]
require("rept" not in movement_macro, "movement_profile unexpectedly uses an opaque rept body")
require(movement_macro.count("db \\1") == MOVE_RECORD_SIZE,
        "movement_profile does not expose all 23 terrain columns explicitly")
require(movement_macro.count("shift") == MOVE_RECORD_SIZE,
        "movement_profile does not consume all 23 terrain arguments")

unit = UNIT.read_text(encoding="utf-8")
for assertion in (
    "assert @ - WeaponData == WEAPON_DATA_COUNT * 2",
    "assert @ - WeaponDataRecords == WEAPON_DATA_COUNT * WEAPON_DATA_RECORD_SIZE",
    "assert @ - MovementData == MOVEMENT_DATA_PROFILE_COUNT * 2",
    "assert @ - MovementDataProfiles == MOVEMENT_DATA_PROFILE_COUNT * MOVEMENT_DATA_PROFILE_SIZE",
):
    require(assertion in unit, f"missing geometry assertion: {assertion}")

# Encode source strings through the active unit charmap so existing English/custom
# names are byte-protected rather than merely text-protected.
charmap = {}
for line in CHARMAP.read_text(encoding="utf-8").splitlines():
    m = re.match(r'charmap\s+"([^"]+)",\s*\$([0-9a-fA-F]{2})', line)
    if m:
        charmap[m.group(1)] = int(m.group(2), 16)
keys = sorted(charmap, key=len, reverse=True)


def encode_name(text):
    out = []
    i = 0
    while i < len(text):
        for key in keys:
            if text.startswith(key, i):
                out.append(charmap[key])
                i += len(key)
                break
        else:
            raise SystemExit(f"[fail] no unit charmap token for {text[i:]!r}")
    return out


def parse_number(value):
    value = value.strip()
    return int(value[1:], 16) if value.startswith("$") else int(value, 0)

# WeaponData pointer order and fixed records.
ptr_block = unit[unit.index("WeaponData:"):unit.index("WeaponDataRecords::")]
weapon_ptrs = re.findall(r"^\s*dw\s+(\.[A-Za-z0-9_]+)\s*$", ptr_block, re.M)
require(len(weapon_ptrs) == WEAPON_COUNT, f"expected {WEAPON_COUNT} WeaponData pointers, found {len(weapon_ptrs)}")

record_block = unit[unit.index("WeaponDataRecords::"):unit.index("section_end $54a8")]
weapon_rows = re.findall(r'^\s*(\.[A-Za-z0-9_]+):\s+weapon_data\s+"([^"]*)",\s*([^;\n]+)', record_block, re.M)
require(len(weapon_rows) == WEAPON_COUNT, f"expected {WEAPON_COUNT} weapon_data rows, found {len(weapon_rows)}")
require([row[0] for row in weapon_rows] == weapon_ptrs, "WeaponData pointer order no longer matches record order")

weapon_blob = bytearray()
for label, display_name, numeric_text in weapon_rows:
    name_bytes = encode_name(display_name)
    require(len(name_bytes) == WEAPON_NAME_LENGTH, f"{label} name encodes to {len(name_bytes)} bytes")
    values = [v.strip() for v in numeric_text.split(",") if v.strip()]
    require(len(values) == WEAPON_RECORD_SIZE - WEAPON_NAME_LENGTH,
            f"{label} has {len(values)} numeric bytes; expected {WEAPON_RECORD_SIZE - WEAPON_NAME_LENGTH}")
    weapon_blob.extend(name_bytes)
    for value in values:
        n = parse_number(value)
        require(0 <= n <= 0xFF, f"{label} byte out of range: {value}")
        weapon_blob.append(n)

require(len(weapon_blob) == WEAPON_COUNT * WEAPON_RECORD_SIZE, "WeaponData reconstructed size changed")
weapon_sha1 = hashlib.sha1(weapon_blob).hexdigest()
require(weapon_sha1 == WEAPON_SHA1, f"custom WeaponData bytes changed: {weapon_sha1} != {WEAPON_SHA1}")
require(WEAPON_START + WEAPON_COUNT * 2 == WEAPON_RECORDS_START, "WeaponData pointer geometry changed")
require(WEAPON_RECORDS_START + len(weapon_blob) == WEAPON_END, "WeaponData record geometry changed")

# MovementData pointer order and fixed profiles.
move_ptr_block = unit[unit.index("MovementData:"):unit.index("MovementDataProfiles::")]
move_ptrs = re.findall(r"^\s*dw\s+(\.Profile\d\d)\s*$", move_ptr_block, re.M)
require(len(move_ptrs) == MOVE_COUNT, f"expected {MOVE_COUNT} MovementData pointers, found {len(move_ptrs)}")
expected_labels = [f".Profile{i:02d}" for i in range(MOVE_COUNT)]
require(move_ptrs == expected_labels, "MovementData pointer labels/order changed")

move_block = unit[unit.index("MovementDataProfiles::"):unit.index("section_end $8000")]
move_rows = re.findall(r"^(\.Profile\d\d):\s+movement_profile\s+([^\n]+)$", move_block, re.M)
require(len(move_rows) == MOVE_COUNT, f"expected {MOVE_COUNT} movement profiles, found {len(move_rows)}")
require([row[0] for row in move_rows] == expected_labels, "MovementData profile order changed")

move_blob = bytearray()
for label, numeric_text in move_rows:
    values = [v.strip() for v in numeric_text.split(",") if v.strip()]
    require(len(values) == MOVE_RECORD_SIZE, f"{label} has {len(values)} bytes; expected {MOVE_RECORD_SIZE}")
    for value in values:
        n = parse_number(value)
        require(0 <= n <= 0xFF, f"{label} byte out of range: {value}")
        move_blob.append(n)

require(len(move_blob) == MOVE_COUNT * MOVE_RECORD_SIZE, "MovementData reconstructed size changed")
move_sha1 = hashlib.sha1(move_blob).hexdigest()
require(move_sha1 == MOVE_SHA1, f"MovementData bytes changed: {move_sha1} != {MOVE_SHA1}")
require(MOVE_START + MOVE_COUNT * 2 == MOVE_RECORDS_START, "MovementData pointer geometry changed")
require(MOVE_RECORDS_START + len(move_blob) == MOVE_END, "MovementData profile geometry changed")

print(f"[ok] {WEAPON_COUNT} WeaponData pointers / {WEAPON_COUNT} fixed {WEAPON_RECORD_SIZE}-byte records")
print(f"[ok] WeaponData record bytes: {len(weapon_blob)} bytes, SHA-1 {weapon_sha1}")
print("[ok] custom English weapon names protected through active unit charmap encoding")
print(f"[ok] {MOVE_COUNT} MovementData pointers / {MOVE_COUNT} fixed {MOVE_RECORD_SIZE}-byte profiles")
print(f"[ok] MovementData profile bytes: {len(move_blob)} bytes, SHA-1 {move_sha1}")
print("[ok] geometry remains WeaponData $5256-$54A7; MovementData typed payload $54A8-$561E")
