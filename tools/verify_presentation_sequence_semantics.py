#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_ROM_SHA256 = "e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059"


def fail(msg: str) -> None:
    raise SystemExit(f"FAIL: {msg}")


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


for req in ["GBWARS3.gbc", "GBWARS3.sym", "constants/presentation_constants.inc",
            "engine/ui/presentation_sequence_dispatch.asm",
            "engine/ui/presentation_sequence_bodies.asm",
            "engine/unit/unit_action_presentation_runtime_66bb.asm", "symbols.asm"]:
    if not (ROOT / req).exists():
        fail(f"missing required file: {req}")

rom_hash = hashlib.sha256((ROOT / "GBWARS3.gbc").read_bytes()).hexdigest()
if rom_hash != EXPECTED_ROM_SHA256:
    fail(f"custom-English ROM SHA-256 drifted: {rom_hash}")

constants = read("constants/presentation_constants.inc")
expected_constants = {
    "PRESENTATION_SEQUENCE_PROPERTY_CAPTURE_COMPLETE": "$00",
    "PRESENTATION_SEQUENCE_PROPERTY_CAPTURE_PROGRESS": "$01",
    "PRESENTATION_SEQUENCE_TERRAIN_TRANSFORMATION": "$02",
    "PRESENTATION_SEQUENCE_SUPPLY": "$03",
    "PRESENTATION_SEQUENCE_LOAD": "$04",
    "PRESENTATION_SEQUENCE_CARRIED_CHILD_MOVE": "$05",
    "PRESENTATION_SEQUENCE_CARRIED_CHILD_MOVE_SPECIAL_CARRIER": "$06",
    "PRESENTATION_SEQUENCE_LOAD_SPECIAL_CARRIER": "$07",
    "PRESENTATION_SEQUENCE_8": "$08",
}
for name, value in expected_constants.items():
    if not re.search(rf"(?m)^DEF\s+{re.escape(name)}\s+EQU\s+{re.escape(value)}$", constants):
        fail(f"missing or changed sequence constant {name}={value}")
if "DEF PRESENTATION_SEQUENCE_HQ_LOSS                  EQU PRESENTATION_SEQUENCE_PROPERTY_CAPTURE_COMPLETE" not in constants:
    fail("HQ-loss alias no longer shares sequence 0")

dispatch = read("engine/ui/presentation_sequence_dispatch.asm")
block = dispatch.split("PresentationSequencePointers::", 1)[1].split("Presentation_AddScrollXFromC::", 1)[0]
entries = re.findall(r"PresentationSequence_[A-Za-z0-9_]+", block)
expected_entries = [
    "PresentationSequence_PropertyCaptureComplete",
    "PresentationSequence_PropertyCaptureProgress",
    "PresentationSequence_TerrainTransformation",
    "PresentationSequence_Supply",
    "PresentationSequence_Load",
    "PresentationSequence_CarriedChildMove",
    "PresentationSequence_CarriedChildMoveSpecialCarrier",
    "PresentationSequence_LoadSpecialCarrier",
    "PresentationSequence_8",
]
if entries != expected_entries:
    fail(f"dispatcher semantic order mismatch: {entries}")

sym = (ROOT / "GBWARS3.sym").read_text(encoding="utf-8", errors="replace")
addresses = [0x45D0, 0x46F5, 0x486F, 0x5063, 0x555A, 0x589E, 0x5913, 0x5DE8, 0x5E96]
for name, address in zip(expected_entries, addresses):
    if not re.search(rf"(?mi)^1a:{address:04x}\s+{re.escape(name)}$", sym):
        fail(f"{name} is not linked at $1A:${address:04X}")
if not re.search(r"(?mi)^1a:45d0\s+PresentationSequence_HQLoss$", sym):
    fail("HQ-loss alias is not linked at sequence 0")
if not re.search(r"(?mi)^04:d33d\s+wPresentationUnitAnimationIDScratch$", sym):
    fail("WRAM4 $D33D presentation animation scratch is not linked symbolically")

bodies = read("engine/ui/presentation_sequence_bodies.asm")
if "$d33d" in bodies.lower():
    fail("raw $D33D remains in presentation sequence bodies")
for name in ["PropertyPresentation_GetTimingByte", "PropertyPresentation_GetPointerA",
             "PropertyPresentation_GetPointerB", "PropertyPresentation_TimingTable",
             "PropertyPresentation_PointerTableA", "PropertyPresentation_PointerTableB"]:
    if name not in bodies:
        fail(f"missing shared property-presentation identity: {name}")

action = read("engine/unit/unit_action_presentation_runtime_66bb.asm")
for name in expected_constants:
    if name not in action:
        fail(f"action stager does not use {name}")

print("Presentation sequence semantics verification: PASS")
print("  Sequence indexes 0-7 behavior-backed; index 8 intentionally numeric")
print("  Sequence 0 shared by completed property capture and HQ-loss result")
print("  WRAM4 $D33D named as presentation-local unit animation-ID scratch")
print(f"  Linked ROM SHA-256: {EXPECTED_ROM_SHA256}")
