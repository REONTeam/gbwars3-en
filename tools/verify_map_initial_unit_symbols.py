#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re
import sys

EXPECTED_COUNT = 1013
EXPECTED_SHA1 = "5921ab80a341b42bf7d7f24bea5e0541fbbe4f62"
MAP_FILES = [
    Path("data/maps/map_records.asm"),
    Path("data/maps/map_records_beginner_bank2c.asm"),
    Path("data/maps/map_records_campaign_bank2d.asm"),
    Path("data/maps/map_records_campaign_bank2e.asm"),
    Path("data/maps/map_records_campaign_bank2f.asm"),
]

def fail(msg):
    print(f"[fail] {msg}", file=sys.stderr)
    raise SystemExit(1)

def require(cond, msg):
    if not cond:
        fail(msg)

unit = Path("engine/unit/unit.asm").read_text()
constants = Path("constants/unit_constants.inc").read_text()
macros = Path("macros/macros.inc").read_text()

ptr_block = unit[unit.index("UnitData:"):unit.index("    assert @ - UnitData == UNIT_DATA_COUNT * 2")]
labels = re.findall(r"^\s*dw\s+\.([A-Za-z0-9_]+)\s*$", ptr_block, re.M)
require(len(labels) == 53, f"expected 53 UnitData pointers, found {len(labels)}")

unit_ids = {}
for idx, label in enumerate(labels):
    name = "UNIT_TYPE_" + label.upper()
    m = re.search(rf"^DEF\s+{re.escape(name)}\s+EQU\s+(\d+)\s*$", constants, re.M)
    require(m is not None, f"missing {name}")
    value = int(m.group(1))
    require(value == idx, f"{name} is {value}, expected pointer index {idx}")
    unit_ids[name] = value

require(re.search(r"^DEF\s+UNIT_SIDE_0\s+EQU\s+0\s*$", constants, re.M), "UNIT_SIDE_0 missing or changed")
require(re.search(r"^DEF\s+UNIT_SIDE_1\s+EQU\s+1\s*$", constants, re.M), "UNIT_SIDE_1 missing or changed")
require("macro map_initial_unit" in macros, "map_initial_unit macro missing")
require("db \\1, \\2, (\\3 << 1) | \\4" in macros, "map_initial_unit encoding changed")

blob = bytearray()
count = 0
side_counts = [0, 0]
used_types = set()
pat = re.compile(r"^\s*map_initial_unit\s+\$([0-9a-fA-F]{2}),\s*\$([0-9a-fA-F]{2}),\s*(UNIT_TYPE_[A-Z0-9_]+),\s*(UNIT_SIDE_[01])(?:\s*;.*)?$")
raw_pat = re.compile(r"^\s*db\s+\$[0-9a-fA-F]{2},\s*\$[0-9a-fA-F]{2},\s*\$[0-9a-fA-F]{2}")

for path in MAP_FILES:
    text = path.read_text().splitlines()
    require('include "constants/unit_constants.inc"' in text[:6], f"{path}: unit constants include missing")
    in_units = False
    for line in text:
        if line.strip() == ".initial_units:":
            in_units = True
            continue
        if in_units and line.strip().lower() == "db $ff":
            in_units = False
            continue
        if not in_units:
            continue
        require(not raw_pat.match(line), f"{path}: raw encoded initial-unit tuple remains: {line.strip()}")
        m = pat.match(line)
        if not m:
            continue
        x, y, unit_name, side_name = m.groups()
        require(unit_name in unit_ids, f"{path}: unknown unit constant {unit_name}")
        side = int(side_name[-1])
        encoded = (unit_ids[unit_name] << 1) | side
        require(encoded <= 0xFF, f"{path}: encoded unit byte overflow for {unit_name}")
        blob.extend((int(x, 16), int(y, 16), encoded))
        count += 1
        side_counts[side] += 1
        used_types.add(unit_name)

require(count == EXPECTED_COUNT, f"expected {EXPECTED_COUNT} initial-unit tuples, found {count}")
sha1 = hashlib.sha1(blob).hexdigest()
require(sha1 == EXPECTED_SHA1, f"initial-unit byte stream changed: {sha1} != {EXPECTED_SHA1}")

print(f"[ok] {count} map initial-unit tuples use symbolic UnitData IDs + explicit side bits")
print(f"[ok] reconstructed placement bytes: {len(blob)} bytes, SHA-1 {sha1}")
print(f"[ok] side distribution: side 0 = {side_counts[0]}, side 1 = {side_counts[1]}; unit types used = {len(used_types)}")
print("[ok] encoded byte remains (UnitData pointer index << 1) | side")
