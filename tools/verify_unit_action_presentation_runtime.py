#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "baserom.gbc"
BUILT = ROOT / "GBWARS3.gbc"
BANK = 0x0C
START = 0x66BB
END = 0x6867
EXPECTED_SHA1 = "230a6ce94d91e950e5da4cab25a91291f9a794df"
EXPECTED_ROM_SHA256 = "e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059"


def fail(msg: str) -> None:
    print(f"FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def rom_offset(bank: int, address: int) -> int:
    return bank * 0x4000 + (address - 0x4000)


def text(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def need(path: str, needle: str) -> None:
    if needle not in text(path):
        fail(f"{path} missing expected contract: {needle}")


def forbid(path: str, needle: str) -> None:
    if needle in text(path):
        fail(f"{path} still contains obsolete/raw contract: {needle}")


if not BASE.exists():
    fail("baserom.gbc is required")
if not BUILT.exists():
    fail("GBWARS3.gbc is required; run make first")

base = BASE.read_bytes()
built = BUILT.read_bytes()
a = rom_offset(BANK, START)
z = rom_offset(BANK, END)
reference = base[a:z]
output = built[a:z]
sha1 = hashlib.sha1(reference).hexdigest()
if len(reference) != 428:
    fail(f"unexpected range length: {len(reference)}")
if sha1 != EXPECTED_SHA1:
    fail(f"retail range SHA-1 {sha1} != expected {EXPECTED_SHA1}")
if output != reference:
    first = next(i for i, (x, y) in enumerate(zip(reference, output)) if x != y)
    fail(f"built range drift at $0C:${START + first:04X}")
if hashlib.sha256(built).hexdigest() != EXPECTED_ROM_SHA256:
    fail("full custom-English ROM SHA-256 drifted")
print(f"PASS Bank $0C:${START:04X}-${END-1:04X}: 428 bytes, SHA-1 {EXPECTED_SHA1}")

module = "engine/unit/unit_action_presentation_runtime_66bb.asm"
for needle in [
    "UnitAction_PresentActionEffect::",
    "UnitAction_PrepareCarriedChildMovePresentation::",
    "UnitAction_PresentationStagerTable:",
    "UnitAction_PropertyPresentationClassTable:",
    "UnitAction_StagePropertyPresentation:",
    "UnitAction_StageSupplyPresentation:",
    "UnitAction_StageLoadPresentation:",
    "UnitAction_StagePreparedMovementPresentation:",
    "farcall $1a, Presentation_RunSequenceByIndex",
    "farcall $0b, MapCursor_Hide",
    "farcall $0b, MapControl_ReinitializeAfterResolution",
    "ld [wPresentationParam0], a",
    "ld [wPresentationParam1], a",
    "assert @ == $6867",
]:
    need(module, needle)

# The selector table is exactly ten word entries and keeps selectors 8/9 in
# their retail physical ordering ($6864 and $685C respectively).
src = text(module)
block = src.split("UnitAction_PresentationStagerTable:", 1)[1].split("UnitAction_StagePropertyPresentation:", 1)[0]
entries = re.findall(r"^\s*dw\s+([A-Za-z0-9_]+)\s*$", block, flags=re.M)
expected_entries = [
    "UnitAction_StagePropertyPresentation",
    "UnitAction_StageDevelopmentPresentation",
    "UnitAction_StageSupplyPresentation",
    "UnitAction_StageLoadPresentation",
    "UnitAction_StagePreparedMovementPresentation",
    "UnitAction_StageBridgePresentation",
    "UnitAction_StageRunwayPresentation",
    "UnitAction_StageClearPresentation",
    "UnitAction_StageSelector8Presentation",
    "UnitAction_StageSelector9Presentation",
]
if entries != expected_entries:
    fail(f"presentation stager table mismatch: {entries}")

# The property-class table is a fixed 15-byte mapping.
prop = src.split("UnitAction_PropertyPresentationClassTable:", 1)[1].split("UnitAction_StageDevelopmentPresentation:", 1)[0]
vals = [int(x, 16) for x in re.findall(r"\$([0-9a-fA-F]{2})", prop)]
expected_vals = [0xFF,0x00,0x01,0x01,0x02,0x02,0x04,0x04,0x05,0x03,0x03,0x08,0xFF,0x07,0x06]
if vals != expected_vals:
    fail(f"property presentation class table mismatch: {vals}")
print("PASS 10-entry stager table and 15-byte property-class table")

# Neutral presentation scratch names must be centralized; presentation-owned
# code must no longer hard-code C4A1/C4A2.
need("constants/presentation_constants.inc", "DEF wPresentationParam0 EQU $c4a1")
need("constants/presentation_constants.inc", "DEF wPresentationParam1 EQU $c4a2")
for path in [
    "engine/ui/presentation_sequence_bodies.asm",
    "engine/ui/presentation_palette_wait_bank31.asm",
    "engine/map/map_result_presentation_bank1a.asm",
    module,
]:
    lower = text(path).lower()
    if "$c4a1" in lower or "$c4a2" in lower:
        fail(f"raw presentation scratch address remains in {path}")
print("PASS neutral presentation parameter integration")

# The producer now names all sequence indexes whose behavior is proven. Sequence
# 8 remains numeric by design, but its index still has a stable constant so the
# dispatcher/stager contract is explicit.
for needle in [
    "PRESENTATION_SEQUENCE_PROPERTY_CAPTURE_COMPLETE",
    "PRESENTATION_SEQUENCE_PROPERTY_CAPTURE_PROGRESS",
    "PRESENTATION_SEQUENCE_TERRAIN_TRANSFORMATION",
    "PRESENTATION_SEQUENCE_SUPPLY",
    "PRESENTATION_SEQUENCE_LOAD",
    "PRESENTATION_SEQUENCE_CARRIED_CHILD_MOVE",
    "PRESENTATION_SEQUENCE_CARRIED_CHILD_MOVE_SPECIAL_CARRIER",
    "PRESENTATION_SEQUENCE_LOAD_SPECIAL_CARRIER",
    "PRESENTATION_SEQUENCE_8",
]:
    need("constants/presentation_constants.inc", needle)
    need(module, needle)
print("PASS behavior-backed presentation sequence constants")

# Action-side source must use the new public entries instead of raw Bank-$0C
# addresses. Search engine source only so historical docs do not matter.
for p in (ROOT / "engine").rglob("*.asm"):
    s = p.read_text(encoding="utf-8").lower()
    if "farcall $0c, $66bb" in s or "farcall $0c, $6804" in s:
        fail(f"raw unit-action presentation farcall remains in {p.relative_to(ROOT)}")
print("PASS symbolic action-presentation callers")
