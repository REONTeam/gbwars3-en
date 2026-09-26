#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "baserom.gbc"
BUILT = ROOT / "GBWARS3.gbc"

RANGES = [
    ("Bank $17 shared battle-place presentation support", 0x17, 0x44A1, 0x45B0, "1831f01aefae3912f78d47e1ec435d236f146ecc"),
    ("Bank $18 Versus style / infrared-mode producer", 0x18, 0x5E65, 0x5F0B, "fca02a0190942678feb0088a02c6a4a861b51b89"),
    ("Bank $27 shared presentation helpers", 0x27, 0x4000, 0x40E6, "f9248bb744dc11fb82f580071e2f3dbe8fb29a0a"),
    ("Bank $1A background loader family", 0x1A, 0x405B, 0x43D7, "77fa1287297f946f1f26abce195d07c7ec3fb1ca"),
    ("Bank $1A background descriptor copy", 0x1A, 0x44C6, 0x44EB, "eed9bfd150e90aaa9dbe669163b2010d59d1ea82"),
    ("Bank $1A presentation sequence dispatcher", 0x1A, 0x4541, 0x457A, "d035e3cfcf8bbf26b0e19a11ecc044758450f06e"),
    ("Bank $1A background descriptors", 0x1A, 0x63E8, 0x65D8, "657c0cae5b6212a63f9341ca73c1f97c79f0587a"),
    ("Bank $31 alternating-palette wait", 0x31, 0x4113, 0x41BF, "8e5154b97441e848a3ded694014d33d5dbe09618"),
]

def rom_offset(bank: int, address: int) -> int:
    if bank == 0:
        return address
    return bank * 0x4000 + (address - 0x4000)

def fail(msg: str) -> None:
    print(f"FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)

def need(path: str, needle: str) -> None:
    text = (ROOT / path).read_text(encoding="utf-8")
    if needle not in text:
        fail(f"{path} is missing expected source contract: {needle}")

def forbid(path: str, needle: str) -> None:
    text = (ROOT / path).read_text(encoding="utf-8")
    if needle in text:
        fail(f"{path} still contains obsolete/raw contract: {needle}")

if not BASE.exists():
    fail("baserom.gbc is required")
if not BUILT.exists():
    fail("GBWARS3.gbc is required; run make first")
base = BASE.read_bytes()
built = BUILT.read_bytes()
if len(base) != len(built):
    fail("built ROM size differs from baserom")

print("Result-presentation provider byte verification")
for name, bank, start, end, sha in RANGES:
    a = rom_offset(bank, start)
    z = rom_offset(bank, end)
    reference = base[a:z]
    output = built[a:z]
    got = hashlib.sha1(reference).hexdigest()
    if got != sha:
        fail(f"{name} retail SHA-1 {got} != expected {sha}")
    if output != reference:
        first = next(i for i,(x,y) in enumerate(zip(reference,output)) if x != y)
        fail(f"{name} built bytes drift at ${bank:02X}:${start + first:04X}")
    print(f"PASS {name}: {len(reference)} bytes, SHA-1 {sha}")

# Symbolic caller/provider integration.
provider_checks = {
    "engine/battle/battle_place_graphics.asm": [
        "BattlePlace_LoadSharedGraphicsAndPalette::",
        "BattlePlace_UpdatePrimaryPaletteAnimation::",
        "BattlePlace_UpdateSecondaryPaletteAnimation::",
        "BattlePlace_UpdatePaletteAnimations::",
    ],
    "engine/versus/versus_style_country_runtime.asm": [
        "Versus_RunStyleCountryController::",
        "ld [wMapControlInfraredBattleMode], a",
        "ldh a, [hJoyRepeat]",
    ],
    "engine/ui/shared_presentation_runtime.asm": [
        "Presentation_ApplyBackgroundPalette::",
        "Presentation_WaitFramesOrCancel::",
        "Presentation_WaitFrames::",
        "Presentation_RunFrameServices::",
        "farcall $17, BattlePlace_UpdatePaletteAnimations",
        "Presentation_ResetDisplayState::",
        "call SpriteObject_ResetAll",
    ],
    "engine/ui/campaign_background_runtime.asm": [
        "CampaignBackground_LoadInset4::",
        "CampaignBackground_LoadInset4Duplicate::",
        "CampaignBackground_Load::",
        "CampaignBackground_CopyDescriptor::",
        "CampaignBackgroundDefinitions::",
    ],
    "engine/ui/presentation_sequence_dispatch.asm": [
        "Presentation_RunSequenceByIndex::",
        "PresentationSequencePointers::",
        "Presentation_AddScrollXFromC::",
    ],
    "engine/ui/presentation_palette_wait_bank31.asm": [
        "Presentation_WaitWithAlternatingPalette::",
        "Presentation_ApplyBackgroundPalette",
    ],
    "engine/map/map_result_presentation_bank1a.asm": [
        "call Presentation_RunSequenceByIndex",
        "farcall $27, Presentation_ResetDisplayState",
        "call CampaignBackground_LoadInset4",
        "farcall $27, Presentation_WaitFramesOrCancel",
        "farcall $31, Presentation_WaitWithAlternatingPalette",
    ],
    "constants/map_constants.inc": [
        "DEF wMapControlInfraredBattleMode EQU $C630",
        "DEF wSelectedMapCommandModeState EQU wMapControlInfraredBattleMode",
    ],
}
for path, needles in provider_checks.items():
    for needle in needles:
        need(path, needle)

# Guard the reset semantic error that was previously caught in the public result screen.
forbid("engine/ui/shared_presentation_runtime.asm", "call SpriteObject_DestroyAll")

# Raw C630 should exist only in its single central definition, never in engine source.
for p in (ROOT / "engine").rglob("*.asm"):
    text = p.read_text(encoding="utf-8")
    if re.search(r"\$[cC]630\b", text):
        fail(f"raw $C630 remains in {p.relative_to(ROOT)}")

# Result providers must not regress to raw calls that are now named.
for path in ["engine/map/map_result_presentation_bank1a.asm"]:
    for raw in ["call $4541", "call $405b", "farcall $27,$40d4", "farcall $27,$4047", "farcall $31,$4113"]:
        forbid(path, raw)

print("PASS symbolic provider/result integration")
print("PASS infrared-battle mode state is centralized")
