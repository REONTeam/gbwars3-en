#!/usr/bin/env python3
"""Verify the mnemonic Bank $0B cursor/coordinate-analysis family."""
from pathlib import Path
import hashlib, re, sys

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "baserom.gbc"
BUILT = ROOT / "GBWARS3.gbc"
RANGES = [
    (0x52BC, 0x54E0, "220f0445f5dd9702a28fd8ca77acca63d7aecab8", "selected-map cursor controller"),
    (0x54E0, 0x569B, "2209013586a8fc56cef062892fb492e27def01ab", "coordinate-analysis workspace"),
    (0x569B, 0x5709, "33e659b394048313c876258ce50603692b4b033f", "connected-analysis extent"),
    (0x5709, 0x573C, "d4e65ee25017ef53fb8a4a240cd012d79fbd2bb2", "analysis fuel-cost consumer"),
    (0x573C, 0x57AE, "c1a3144061363eaa4b2508bdd47c542d36d22976", "side occupancy/adjacency grid"),
]
SOURCES = [
    ROOT / "engine/map/bank0b_map_cursor_runtime_52bc.asm",
    ROOT / "engine/map/bank0b_coordinate_analysis_54e0.asm",
    ROOT / "engine/map/bank0b_connected_analysis_569b.asm",
    ROOT / "engine/map/bank0b_analysis_fuel_cost_5709.asm",
    ROOT / "engine/map/bank0b_side_unit_grid_573c.asm",
]

def rom_offset(cpu_addr: int) -> int:
    return 0x0B * 0x4000 + (cpu_addr - 0x4000)

def fail(msg: str) -> None:
    print(f"FAIL: {msg}")
    raise SystemExit(1)

for src in SOURCES:
    text = src.read_text(encoding="utf-8")
    if re.search(r"(?mi)^\s*db\s+\$[0-9a-f]{2}(?:\s*,\s*\$[0-9a-f]{2}){2,}", text):
        fail(f"executable-style raw db remains in {src.relative_to(ROOT)}")

if not BASE.exists():
    fail("baserom.gbc is required as external verification input")
base = BASE.read_bytes()
built = BUILT.read_bytes() if BUILT.exists() else None

for start, end, expected_sha1, label in RANGES:
    a, b = rom_offset(start), rom_offset(end)
    retail = base[a:b]
    got_sha1 = hashlib.sha1(retail).hexdigest()
    if got_sha1 != expected_sha1:
        fail(f"{label}: retail fingerprint {got_sha1} != {expected_sha1}")
    if built is not None and built[a:b] != retail:
        fail(f"{label}: built ROM differs from retail in ${start:04X}-${end-1:04X}")
    print(f"PASS ${start:04X}-${end-1:04X}: {len(retail)} bytes SHA-1 {got_sha1}")

print("PASS: Bank $0B cursor/coordinate-analysis mnemonic family")
