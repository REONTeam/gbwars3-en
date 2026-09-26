#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "baserom.gbc"
BUILT = ROOT / "GBWARS3.gbc"
SYM = ROOT / "GBWARS3.sym"
SOURCE = ROOT / "engine/map/property_state_runtime_5883.asm"
BANK = 0x0C
START = 0x5883
END = 0x599C
TABLE_START = 0x5984
EXPECTED_SHA1 = "d10432f8038a20bb1512a332215046ead28f5869"
EXPECTED_TABLE_SHA1 = "d97e92053beff0cdb15f749911fec4add6a5fd9c"
EXPECTED_ROM_SHA256 = "e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059"


def fail(msg: str) -> None:
    raise SystemExit(f"FAIL: {msg}")


def rom_slice(blob: bytes, start: int, end: int) -> bytes:
    off = BANK * 0x4000 + (start - 0x4000)
    return blob[off:off + end - start]


for p in (BASE, BUILT, SYM, SOURCE):
    if not p.exists():
        fail(f"missing required file: {p.relative_to(ROOT)}")

base = BASE.read_bytes()
built = BUILT.read_bytes()
ref = rom_slice(base, START, END)
out = rom_slice(built, START, END)
if len(ref) != 281:
    fail(f"unexpected range length: {len(ref)}")
if hashlib.sha1(ref).hexdigest() != EXPECTED_SHA1:
    fail("retail property-state runtime SHA-1 mismatch")
if ref != out:
    first = next(i for i, (a, b) in enumerate(zip(ref, out)) if a != b)
    fail(f"linked bytes drift at $0C:${START + first:04X}")
if hashlib.sha256(built).hexdigest() != EXPECTED_ROM_SHA256:
    fail("custom-English ROM SHA-256 drifted")

table = rom_slice(base, TABLE_START, END)
if hashlib.sha1(table).hexdigest() != EXPECTED_TABLE_SHA1:
    fail("property-state base/maximum table SHA-1 mismatch")

src = SOURCE.read_text(encoding="utf-8")
for label in [
    "PropertyState_GetAtCoordinates::",
    "PropertyState_SetAtCoordinates::",
    "PropertyState_GetMaximumForTerrainClass::",
    "PropertyState_GetBaseForTerrainClass::",
    "PropertyState_CompareCurrentToTerrainMaximum::",
    "PropertyState_ApplyDeltaWithPresentation::",
    "PropertyState_FindRecordIndexAtCoordinates::",
    "PropertyState_BaseAndMaximumByTerrainClass::",
]:
    if label not in src:
        fail(f"missing source contract: {label}")
if "assert @ == $599c" not in src:
    fail("missing hard end assertion at $599C")
if "ld hl, wMapPropertyStateRecords" not in src:
    fail("property-state record block is not symbolic")
if src.count("cp PROPERTY_STATE_RECORD_CAPACITY") != 2:
    fail("record scans no longer use the 100-entry capacity twice")
if "call Joypad_Update\n    call Joypad_Update" not in src:
    fail("retail two-input-update presentation cadence changed")

# 12 two-byte base/maximum pairs are the only literal db data in this range.
block = src.split("PropertyState_BaseAndMaximumByTerrainClass::", 1)[1].split("assert @ == $599c", 1)[0]
vals = [int(x, 16) for x in re.findall(r"\$([0-9a-fA-F]{2})", block)]
expected = [
    0x00,0x00, 0x14,0x28, 0x0A,0x1E, 0x00,0x0A,
    0x0A,0x1E, 0x00,0x0A, 0x0A,0x1E, 0x00,0x0A,
    0x0A,0x14, 0x0A,0x1E, 0x00,0x0A, 0x0A,0x1E,
]
if vals != expected:
    fail(f"property-state limit table changed: {vals}")

sym = SYM.read_text(encoding="utf-8", errors="replace")
public = {
    "PropertyState_GetAtCoordinates": 0x5883,
    "PropertyState_SetAtCoordinates": 0x5887,
    "PropertyState_GetMaximumForTerrainClass": 0x58A3,
    "PropertyState_GetBaseForTerrainClass": 0x58AF,
    "PropertyState_CompareCurrentToTerrainMaximum": 0x58BA,
    "PropertyState_ApplyDeltaWithPresentation": 0x58F2,
    "PropertyState_FindRecordIndexAtCoordinates": 0x595A,
    "PropertyState_BaseAndMaximumByTerrainClass": 0x5984,
}
for name, addr in public.items():
    if not re.search(rf"(?mi)^0c:{addr:04x}\s+{re.escape(name)}$", sym):
        fail(f"{name} is not linked at $0C:${addr:04X}")
if not re.search(r"(?mi)^dd80\s+wMapPropertyStateRecordCount$", sym):
    fail("wMapPropertyStateRecordCount is not linked at WRAM $DD80")
if not re.search(r"(?mi)^dd81\s+wMapPropertyStateRecords$", sym):
    fail("wMapPropertyStateRecords is not linked at WRAM $DD81")

# All source-owned action callers should use public names, not old raw addresses.
raw_targets = ("$5883", "$5887", "$58af", "$58ba", "$58f2")
for p in (ROOT / "engine").rglob("*.asm"):
    if p == SOURCE:
        continue
    lower = p.read_text(encoding="utf-8").lower()
    for target in raw_targets:
        if f"farcall $0c, {target}" in lower:
            fail(f"raw Bank-$0C property-state call remains in {p.relative_to(ROOT)}: {target}")

print("Property-state runtime verification: PASS")
print(f"  Bank $0C:${START:04X}-${END-1:04X}: {END-START} byte-exact bytes")
print("  WRAM1 records: 100 x {state, X, Y}, count at $DD80")
print(f"  12-pair base/maximum table: ${TABLE_START:04X}-${END-1:04X}")
print(f"  Retail range SHA-1: {EXPECTED_SHA1}")
print(f"  Linked ROM SHA-256: {EXPECTED_ROM_SHA256}")
