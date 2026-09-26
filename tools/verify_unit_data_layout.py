#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
UNIT = ROOT / "engine/unit/unit.asm"
CONSTANTS = ROOT / "constants/unit_constants.inc"
MACROS = ROOT / "macros/unit_macros.inc"
CHARMAP = ROOT / "charmaps/char_unit.inc"

EXPECTED_COUNT = 53
EXPECTED_RECORD_SIZE = 0x25
EXPECTED_NAME_LENGTH = 10
EXPECTED_DATA_SHA1 = "9597555ea017d416307d001dc14c5fa24abe4f57"
EXPECTED_SECTION_START = 0x4A43
EXPECTED_RECORDS_START = EXPECTED_SECTION_START + EXPECTED_COUNT * 2
EXPECTED_SECTION_END = 0x5256


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
require(parse_def(const, "UNIT_DATA_COUNT") == EXPECTED_COUNT, "UNIT_DATA_COUNT changed")
require(parse_def(const, "UNIT_DATA_RECORD_SIZE") == EXPECTED_RECORD_SIZE, "UNIT_DATA_RECORD_SIZE changed")
require(parse_def(const, "UNIT_DATA_NAME_LENGTH") == EXPECTED_NAME_LENGTH, "UNIT_DATA_NAME_LENGTH changed")
for name, off in {
    "UNIT_DATA_MAX_HP_OFFSET": 0x0A,
    "UNIT_DATA_MAX_FUEL_OFFSET": 0x0B,
    "UNIT_DATA_WEAPON1_OFFSET": 0x14,
    "UNIT_DATA_WEAPON1_AMMO_OFFSET": 0x15,
    "UNIT_DATA_WEAPON2_OFFSET": 0x16,
    "UNIT_DATA_WEAPON2_AMMO_OFFSET": 0x17,
    "UNIT_DATA_MOVEMENT_PROFILE_OFFSET": 0x19,
}.items():
    require(parse_def(const, name) == off, f"{name} changed")

macro_text = MACROS.read_text(encoding="utf-8")
require("macro unit_data" in macro_text, "unit_data macro missing")
require("dw \\1 ; gold cost / 100G" in macro_text, "unit_data macro does not emit gold cost as a word")
require("dw \\1 ; material cost" in macro_text, "unit_data macro does not emit material cost as a word")

unit = UNIT.read_text(encoding="utf-8")
require('include "constants/unit_constants.inc"' in unit, "unit.asm does not include unit constants")
require('include "macros/unit_macros.inc"' in unit, "unit.asm does not include unit macros")
require("assert @ - UnitData == UNIT_DATA_COUNT * 2" in unit, "UnitData pointer-table size assertion missing")
require("assert @ - UnitDataRecords == UNIT_DATA_COUNT * UNIT_DATA_RECORD_SIZE" in unit, "UnitData record-block size assertion missing")

# Verify the pointer layer still contains exactly one pointer per macro record.
ptr_block = unit[unit.index("UnitData:"):unit.index("UnitDataRecords::")]
pointers = re.findall(r"^\s*dw\s+(\.[A-Za-z0-9_]+)\s*$", ptr_block, re.M)
require(len(pointers) == EXPECTED_COUNT, f"expected {EXPECTED_COUNT} UnitData pointers, found {len(pointers)}")

record_block = unit[unit.index("UnitDataRecords::"):unit.index("section_end $5256")]
row_re = re.compile(r'^\s*(\.[A-Za-z0-9_]+):\s+unit_data\s+"([^"]*)",\s*([^;\n]+)', re.M)
rows = row_re.findall(record_block)
require(len(rows) == EXPECTED_COUNT, f"expected {EXPECTED_COUNT} unit_data rows, found {len(rows)}")
require([r[0] for r in rows] == pointers, "UnitData pointer order no longer matches record order")

# Parse the active unit charmap so the custom English name bytes are protected as
# bytes rather than merely as Unicode source text.
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

# Resolve symbolic cross-table IDs while preserving the exact byte reconstruction.
symbol_values = {}
for m in re.finditer(r"^DEF\s+([A-Z0-9_]+)\s+EQU\s+(\$[0-9a-fA-F]+|\d+)\s*$", const, re.M):
    raw = m.group(2)
    symbol_values[m.group(1)] = int(raw[1:], 16) if raw.startswith("$") else int(raw, 0)

blob = bytearray()
for label, display_name, numeric_text in rows:
    name_bytes = encode_name(display_name)
    require(len(name_bytes) == EXPECTED_NAME_LENGTH, f"{label} display name encodes to {len(name_bytes)} bytes")
    values = [v.strip() for v in numeric_text.split(",") if v.strip()]
    require(len(values) == 25, f"{label} has {len(values)} semantic attributes; expected 25")
    blob.extend(name_bytes)
    def resolve(value):
        if value in symbol_values: return symbol_values[value]
        try: return int(value[1:], 16) if value.startswith("$") else int(value, 0)
        except ValueError as exc: raise SystemExit(f"[fail] unknown unit_data expression {value!r} in {label}") from exc
    for value in values[:6]:
        n=resolve(value); require(0 <= n <= 0xff, f"{label} byte out of range: {value}"); blob.append(n)
    for value in values[6:8]:
        n=resolve(value); require(0 <= n <= 0xffff, f"{label} word out of range: {value}"); blob.extend((n & 0xff, n >> 8))
    for value in values[8:]:
        n=resolve(value); require(0 <= n <= 0xff, f"{label} byte out of range: {value}"); blob.append(n)

require(len(blob) == EXPECTED_COUNT * EXPECTED_RECORD_SIZE,
        f"reconstructed UnitData size is {len(blob)}, expected {EXPECTED_COUNT * EXPECTED_RECORD_SIZE}")
sha1 = hashlib.sha1(blob).hexdigest()
require(sha1 == EXPECTED_DATA_SHA1,
        f"custom UnitData bytes changed: {sha1} != {EXPECTED_DATA_SHA1}")
require(EXPECTED_RECORDS_START + len(blob) == EXPECTED_SECTION_END,
        "UnitData pointer/record geometry no longer reaches the established $5256 boundary")

print(f"[ok] {EXPECTED_COUNT} UnitData pointers / {EXPECTED_COUNT} fixed {EXPECTED_RECORD_SIZE}-byte records")
print(f"[ok] UnitData record bytes: {len(blob)} bytes, SHA-1 {sha1}")
print("[ok] custom English unit names protected through active unit charmap encoding")
print("[ok] known UnitData offsets include $14/$16 weapon IDs, $15/$17 ammo, and $19 movement profile")
print("[ok] UnitData block geometry remains $4A43-$5255; next section starts $5256")
