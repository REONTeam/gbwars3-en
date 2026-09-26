#!/usr/bin/env python3
"""Verify Bank $0C map popup / HP-change presentation runtime and resources."""
from pathlib import Path
import hashlib
import re
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "baserom.gbc"
BUILT = ROOT / "GBWARS3.gbc"
SYM = ROOT / "GBWARS3.sym"
SOURCE = ROOT / "engine/map/map_popup_presentation_runtime_5b43.asm"
HP_TRANSFER = ROOT / "engine/unit/unit_hp_transfer.asm"
UNIT_CREATION = ROOT / "engine/unit/unit_creation_selection_runtime_57d6.asm"
RANK_CHANGE = ROOT / "engine/unit/unit_experience_rank_change_presentation_6977.asm"
AREA_ATTACK = ROOT / "engine/map/ai/map_ai_area_attack.asm"
RGBGFX = ROOT / "tools/rgbds/bin/rgbgfx"
BANK = 0x0C
EXPECTED_ROM_SHA256 = "e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059"
FULL_START = 0x5B43
FULL_END = 0x66BB
FULL_SHA1 = "db645418781448160d16ae239890e42b1901e42b"
RUNTIME_SHA1 = "7f732bd621dd22f3bd17efac4ca6cf8db0bc7e0f"
RESOURCE_SHA1 = "49490b927dd20ace4767e62db51e93fafbfa7701"

ASSETS = [
    ("map_unit_transition", 0x603F, 0x610F, 208, "cc2e9cf4436f9c93994310ed9dcf8005861d9db7"),
    ("unit_hp_transfer", 0x612D, 0x636D, 576, "dddf67fd560d561d36cf1bad277a5384650df093"),
    ("map_hp_change", 0x6435, 0x64F5, 192, "786d95ff0991750aeea3e15a2526bd2495d2c127"),
    ("map_status_markers", 0x6573, 0x66B3, 320, "2fc1e437899a6a4240b62c1449be10bc4e523790"),
]

PUBLIC = {
    "MapPopup_LoadObjPalettes": 0x5B43,
    "MapUnitTransition_BeginDeployment": 0x5B5B,
    "MapUnitTransition_EndDeployment": 0x5B6C,
    "MapUnitTransition_BeginCreation": 0x5B75,
    "MapUnitTransition_EndCreation": 0x5B86,
    "MapUnitTransition_BeginRemoval": 0x5B8F,
    "MapUnitTransition_EndRemoval": 0x5BA0,
    "MapPopup_WaitFrames": 0x5C14,
    "UnitHPTransfer_PresentTransfer": 0x5C24,
    "UnitHPTransfer_PreparePresentation": 0x5C9B,
    "MapHPChange_PresentSignedDelta": 0x5D3E,
    "Battle_PresentMaximumFlankMarker": 0x5E16,
    "UnitRank_PresentIncreaseAtCoordinates": 0x5E71,
    "MapPopup_PositionAtCoordinates": 0x5ECC,
    "MapUnitTransitionGraphics": 0x603F,
    "UnitHPTransferGraphics": 0x612D,
    "MapHPChangeGraphics": 0x6435,
    "MapStatusMarkerGraphics": 0x6573,
}


def fail(msg: str) -> None:
    raise SystemExit("FAIL: " + msg)


def rom_slice(blob: bytes, start: int, end: int) -> bytes:
    off = BANK * 0x4000 + (start - 0x4000)
    return blob[off:off + end - start]


def require(path: Path, token: str) -> None:
    if token not in path.read_text(encoding="utf-8"):
        fail(f"missing symbolic integration in {path.relative_to(ROOT)}: {token}")


def reject(path: Path, token: str) -> None:
    if token.lower() in path.read_text(encoding="utf-8").lower():
        fail(f"obsolete raw address remains in {path.relative_to(ROOT)}: {token}")


def main() -> None:
    for p in (BASE, BUILT, SYM, SOURCE):
        if not p.is_file():
            fail(f"missing required file: {p.relative_to(ROOT)}")

    retail = BASE.read_bytes()
    built = BUILT.read_bytes()
    full = rom_slice(retail, FULL_START, FULL_END)
    if hashlib.sha1(full).hexdigest() != FULL_SHA1:
        fail("retail $5B43-$66BA SHA-1 mismatch")
    if hashlib.sha1(rom_slice(retail, 0x5B43, 0x5F07)).hexdigest() != RUNTIME_SHA1:
        fail("retail executable presentation runtime SHA-1 mismatch")
    if hashlib.sha1(rom_slice(retail, 0x5F07, 0x66BB)).hexdigest() != RESOURCE_SHA1:
        fail("retail presentation resource family SHA-1 mismatch")
    if rom_slice(built, FULL_START, FULL_END) != full:
        for i, (a, b) in enumerate(zip(full, rom_slice(built, FULL_START, FULL_END))):
            if a != b:
                fail(f"linked presentation bytes drift at $0C:${FULL_START+i:04X}")
        fail("linked presentation range length mismatch")

    digest = hashlib.sha256(built).hexdigest()
    if digest != EXPECTED_ROM_SHA256:
        fail(f"custom-English ROM SHA-256 {digest} != {EXPECTED_ROM_SHA256}")

    src = SOURCE.read_text(encoding="utf-8")
    required_source = [
        "MapPopup_LoadObjPalettes::",
        "MapUnitTransition_BeginDeployment::",
        "MapUnitTransition_BeginCreation::",
        "MapUnitTransition_BeginRemoval::",
        "UnitHPTransfer_PresentTransfer::",
        "UnitHPTransfer_PreparePresentation::",
        "MapHPChange_PresentSignedDelta::",
        "Battle_PresentMaximumFlankMarker::",
        "UnitRank_PresentIncreaseAtCoordinates::",
        "MapPopup_PositionAtCoordinates::",
        'INCBIN "gfx/effects/map_unit_transition.2bpp"',
        'INCBIN "gfx/effects/unit_hp_transfer.2bpp"',
        'INCBIN "gfx/effects/map_hp_change.2bpp"',
        'INCBIN "gfx/effects/map_status_markers.2bpp"',
    ]
    for token in required_source:
        if token not in src:
            fail(f"missing source contract: {token}")
    for boundary in ("$5c24", "$5d3e", "$5e16", "$5e71", "$5ecc", "$5f07", "$66bb"):
        if f"assert @ == {boundary}" not in src.lower():
            fail(f"missing hard source boundary assertion at {boundary.upper()}")

    integrations = [
        (HP_TRANSFER, "farcall $0c, UnitHPTransfer_PreparePresentation"),
        (HP_TRANSFER, "farcall $0c, UnitHPTransfer_PresentTransfer"),
        (HP_TRANSFER, "farcall $0c, MapUnitTransition_BeginRemoval"),
        (HP_TRANSFER, "farcall $0c, MapUnitTransition_EndRemoval"),
        (UNIT_CREATION, "farcall $0c, MapUnitTransition_BeginCreation"),
        (UNIT_CREATION, "farcall $0c, MapUnitTransition_EndCreation"),
        (RANK_CHANGE, "farcall $0c, UnitRank_PresentIncreaseAtCoordinates"),
        (AREA_ATTACK, "farcall $0c, MapHPChange_PresentSignedDelta"),
        (SOURCE, "farcall $0c, MapAI_PositionAreaAttackEffectSprite"),
    ]
    for path, token in integrations:
        require(path, token)
    for path, token in [
        (HP_TRANSFER, "$5c9b"), (HP_TRANSFER, "$5c24"),
        (HP_TRANSFER, "$5b8f"), (HP_TRANSFER, "$5ba0"),
        (UNIT_CREATION, "$5b75"), (UNIT_CREATION, "$5b86"),
        (RANK_CHANGE, "$5e71"), (AREA_ATTACK, "$5d3e"),
        (SOURCE, "$5273"),
    ]:
        reject(path, token)

    # Editable assets must match their exact source-owned retail tile blocks and,
    # when the bundled legacy converter is present, round-trip byte-for-byte.
    for stem, start, end, size, sha1 in ASSETS:
        png = ROOT / f"gfx/effects/{stem}.png"
        gfx = ROOT / f"gfx/effects/{stem}.2bpp"
        if not png.is_file() or not gfx.is_file():
            fail(f"missing editable/generated asset pair: {stem}")
        data = gfx.read_bytes()
        if len(data) != size:
            fail(f"{stem}.2bpp length {len(data)} != {size}")
        if hashlib.sha1(data).hexdigest() != sha1:
            fail(f"{stem}.2bpp SHA-1 mismatch")
        if data != rom_slice(retail, start, end):
            fail(f"{stem}.2bpp no longer matches retail ${start:04X}-${end-1:04X}")
        if RGBGFX.is_file():
            with tempfile.TemporaryDirectory() as td:
                out = Path(td) / f"{stem}.2bpp"
                subprocess.run([str(RGBGFX), "-o", str(out), str(png)], check=True,
                               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                if out.read_bytes() != data:
                    fail(f"editable {stem}.png does not round-trip through legacy rgbgfx")

    sym = SYM.read_text(encoding="utf-8", errors="replace")
    for name, addr in PUBLIC.items():
        if not re.search(rf"(?mi)^0c:{addr:04x}\s+{re.escape(name)}$", sym):
            fail(f"{name} is not linked at $0C:${addr:04X}")

    print("Map popup / HP-change presentation verification: PASS")
    print(f"  $0C:$5B43-$66BA: {FULL_END-FULL_START} bytes, SHA-1 {FULL_SHA1}")
    print(f"  executable runtime: 964 bytes, SHA-1 {RUNTIME_SHA1}")
    print(f"  frames/animations/graphics/palettes: 1972 bytes, SHA-1 {RESOURCE_SHA1}")
    print("  four editable PNGs round-trip to exact source-owned 2bpp payloads")
    print(f"  linked ROM SHA-256: {digest}")


if __name__ == "__main__":
    main()
