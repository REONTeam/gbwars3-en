#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "baserom.gbc"
BUILT = ROOT / "GBWARS3.gbc"
SYM = ROOT / "GBWARS3.sym"
SOURCE = ROOT / "engine/map/property_state_presentation_571b.asm"
RUNTIME = ROOT / "engine/map/property_state_runtime_5883.asm"
GFX = ROOT / "gfx/ui/property_state_meter.2bpp"
BANK = 0x0C
EXPECTED_ROM_SHA256 = "e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059"

RANGES = {
    "setup": (0x571B, 0x57FA, "d34d7acca8493f1dcfc545a9a1686e81d1dcffa5"),
    "frame template": (0x57FC, 0x580E, "61f271265f39872f01363a28575ab7527aa0b190"),
    "renderer/helpers": (0x580E, 0x5883, "dff2413d3d5f9e5e8e618a26d1ad1bb46871c638"),
    "graphics": (0x59FB, 0x5B2B, "e5a7072d92f67b1081f100f70846c825458b7dac"),
    "palettes": (0x5B2B, 0x5B43, "dc72062be370ab413edd6b63a7c1d05156c23e20"),
}


def fail(msg: str) -> None:
    raise SystemExit(f"FAIL: {msg}")


def rom_slice(blob: bytes, start: int, end: int) -> bytes:
    off = BANK * 0x4000 + (start - 0x4000)
    return blob[off:off + end - start]


for p in (BASE, BUILT, SYM, SOURCE, RUNTIME, GFX):
    if not p.exists():
        fail(f"missing required file: {p.relative_to(ROOT)}")

base = BASE.read_bytes()
built = BUILT.read_bytes()
for name, (start, end, expected_sha1) in RANGES.items():
    ref = rom_slice(base, start, end)
    out = rom_slice(built, start, end)
    if hashlib.sha1(ref).hexdigest() != expected_sha1:
        fail(f"retail {name} SHA-1 mismatch")
    if out != ref:
        first = next(i for i, (a, b) in enumerate(zip(ref, out)) if a != b)
        fail(f"linked {name} bytes drift at $0C:${start + first:04X}")

if hashlib.sha256(built).hexdigest() != EXPECTED_ROM_SHA256:
    fail("custom-English ROM SHA-256 drifted")

# The editable PNG regenerates this exact 19-tile retail payload via the legacy
# rgbgfx path; compare the generated payload against the source-owned ROM range.
gfx = GFX.read_bytes()
if len(gfx) != 0x130:
    fail(f"meter graphics size changed: {len(gfx)}")
if gfx != rom_slice(base, 0x59FB, 0x5B2B):
    fail("meter 2bpp no longer matches the retail graphics block")

src = SOURCE.read_text(encoding="utf-8")
for label in [
    "PropertyStateMeter_Setup::",
    "PropertyStateMeterFrameTileTemplate::",
    "PropertyStateMeter_DrawValue::",
    "SegmentedMeter_LoadGraphics::",
    "SegmentedMeter_Draw::",
    "SegmentedMeterFillTilePairs::",
    "PropertyStateMeterGraphics::",
    "PropertyStateMeterOwnershipPalettes::",
]:
    if label not in src:
        fail(f"missing source contract: {label}")
for assertion in ("$57fa", "$580e", "$5883", "$5b2b", "$5b43"):
    if f"assert @ == {assertion}" not in src.lower():
        fail(f"missing hard boundary assertion at {assertion.upper()}")
if "$57FA-$57FB" not in src:
    fail("unclaimed $57FA-$57FB boundary is no longer documented")
if "INCBIN \"gfx/ui/property_state_meter.2bpp\"" not in src:
    fail("meter graphics are no longer sourced from the editable asset path")
if src.count("farcall $0b, Terrain_GetNameIndex") != 3:
    fail("terrain-name-index integration count changed")
if "cp MAP_TILE_SIDE1_PROPERTY_FIRST" not in src or "cp MAP_TILE_NEUTRAL_PROPERTY_FIRST" not in src:
    fail("ownership-palette selection is no longer expressed with map constants")

runtime = RUNTIME.read_text(encoding="utf-8")
if "call PropertyStateMeter_Setup" not in runtime:
    fail("property-state mutation wrapper no longer uses symbolic meter setup")
if "call PropertyStateMeter_DrawValue" not in runtime:
    fail("property-state mutation wrapper no longer uses symbolic meter renderer")
if "call $571b" in runtime.lower() or "call $580e" in runtime.lower():
    fail("raw property-state presentation calls returned to the runtime")

sym = SYM.read_text(encoding="utf-8", errors="replace")
public = {
    "PropertyStateMeter_Setup": 0x571B,
    "PropertyStateMeterFrameTileTemplate": 0x57FC,
    "PropertyStateMeter_DrawValue": 0x580E,
    "SegmentedMeter_LoadGraphics": 0x5828,
    "SegmentedMeter_Draw": 0x5836,
    "SegmentedMeterFillTilePairs": 0x5877,
    "PropertyStateMeterGraphics": 0x59FB,
    "PropertyStateMeterOwnershipPalettes": 0x5B2B,
}
for name, addr in public.items():
    if not re.search(rf"(?mi)^0c:{addr:04x}\s+{re.escape(name)}$", sym):
        fail(f"{name} is not linked at $0C:${addr:04X}")

print("Property-state presentation verification: PASS")
for name, (start, end, expected_sha1) in RANGES.items():
    print(f"  {name}: $0C:${start:04X}-${end-1:04X} ({end-start} bytes), SHA-1 {expected_sha1}")
print("  $0C:$57FA-$57FB intentionally remains unclaimed pending a proven consumer")
print(f"  linked ROM SHA-256: {EXPECTED_ROM_SHA256}")
