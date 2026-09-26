#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "baserom.gbc"
BUILT = ROOT / "GBWARS3.gbc"
SYM = ROOT / "GBWARS3.sym"
CANONICAL_CUSTOM_SHA256 = "e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059"

RANGES = [
    (0x25, 0x5E7B, 0x5F36, "Unit Reference detail-field helpers", "cf177d1fa90de2361e89071b262defa55fcfaf21"),
    (0x25, 0x5F36, 0x60D8, "Unit Reference shared navigation/setup", "a948bc82570061f10d5a4705f223273c0755ae72"),
    (0x25, 0x60F9, 0x62D6, "Unit Reference type chooser", "92ba255512b43d88b4e775c60caa1a76da6c9622"),
    (0x25, 0x638A, 0x66FE, "Unit Reference detail-value renderer", "5c927e56c08119f22470b8d552a486f2a9c7f3de"),
    (0x25, 0x6707, 0x6AD0, "Unit Reference detail controller", "8ac90a999840d3fdc148be0a194670174327bd5c"),
]

PUBLIC_SYMBOLS = {
    "UnitReference_DrawMaxFuel": (0x25, 0x5E7B),
    "UnitReference_DrawSelectedWeaponSummary": (0x25, 0x5E9A),
    "UnitReference_DrawWeaponNameBySlot": (0x25, 0x5ED8),
    "UnitReference_DrawBaseFocus": (0x25, 0x5EFD),
    "UnitReference_DrawFocusLoss": (0x25, 0x5F10),
    "UnitReference_DrawMovementPower": (0x25, 0x5F23),
    "UnitReference_CreateScrollArrowsTop2C": (0x25, 0x5F36),
    "UnitReference_PollInputAndUpdateSprites": (0x25, 0x5FB7),
    "UnitReference_DrawScreenFrame": (0x25, 0x5FC0),
    "UnitReference_DrawDividerRow": (0x25, 0x5FCB),
    "UnitReference_SetupScreen": (0x25, 0x600E),
    "UnitStatus_Header": (0x25, 0x60D8),
    "UnitReference_UpdateScrollArrowVisibility": (0x25, 0x60F9),
    "UnitReference_InitTypeChooser": (0x25, 0x6164),
    "UnitReference_ChooseType": (0x25, 0x61B9),
    "UnitStatus_Menu": (0x25, 0x62D6),
    "UnitReference_DrawWeapon1ValuePair": (0x25, 0x638A),
    "UnitReference_DrawWeapon2ValuePair": (0x25, 0x63FF),
    "UnitReference_DrawWeapon1Details": (0x25, 0x648F),
    "UnitReference_DrawWeapon2Details": (0x25, 0x64D3),
    "UnitReference_String_ValueSeparator": (0x25, 0x64FC),
    "UnitReference_String_Slash": (0x25, 0x64FE),
    "UnitReference_String_DetailMarker": (0x25, 0x6500),
    "UnitReference_DrawDetailValues": (0x25, 0x6503),
    "UnitReference_UpdateDetailTypeArrowVisibility": (0x25, 0x66BF),
    "UnitReference_UpdateDetailCursorPosition": (0x25, 0x6707),
    "UnitReference_DrawUnitGraphic": (0x25, 0x675D),
    "UnitReference_DrawDetailScreen": (0x25, 0x6797),
    "UnitReference_SyncChooserToCurrentType": (0x25, 0x6806),
    "UnitReference_RunDetailController": (0x25, 0x6831),
    "UnitReference_OpenSelectedSubmenu": (0x25, 0x68A1),
    "UnitReference_UpdateSubmenuScrollArrows": (0x25, 0x69E7),
    "UnitReference_DrawSubmenuBaseAndCosts": (0x25, 0x6A1F),
    "UnitStatus_String_Costs": (0x25, 0x6AD0),
    "UnitStatus_String_MaterialCost": (0x25, 0x6ADE),
}


def bank_offset(bank: int, address: int) -> int:
    return bank * 0x4000 + (address - 0x4000)


def must(cond: bool, msg: str) -> None:
    if not cond:
        raise SystemExit(f"FAIL: {msg}")


def parse_sym() -> dict[str, tuple[int, int]]:
    out: dict[str, tuple[int, int]] = {}
    for line in SYM.read_text(encoding="utf-8", errors="replace").splitlines():
        m = re.match(r"^([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4})\s+(\S+)$", line.strip())
        if m:
            out[m.group(3)] = (int(m.group(1), 16), int(m.group(2), 16))
    return out


def scan_raw_refs() -> None:
    targets = ("61b9", "6831", "638a", "63ff", "6503", "66bf", "64fe", "6500")
    call_rx = re.compile(r"(?:call|jp)\s+\$?(?:" + "|".join(targets[:6]) + r")\b", re.I)
    load_rx = re.compile(r"ld\s+hl\s*,\s*\$?(?:64fe|6500)\b", re.I)
    offenders: list[str] = []
    for p in ROOT.joinpath("engine").rglob("*.asm"):
        for lineno, line in enumerate(p.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
            code = line.split(";", 1)[0]
            if call_rx.search(code) or load_rx.search(code):
                offenders.append(f"{p.relative_to(ROOT)}:{lineno}: {line.strip()}")
    must(not offenders, "raw Unit Reference references remain:\n" + "\n".join(offenders))


def main() -> None:
    must(BASE.exists(), "baserom.gbc is required")
    must(BUILT.exists(), "GBWARS3.gbc must be built before verification")
    must(SYM.exists(), "GBWARS3.sym must exist")

    base = BASE.read_bytes()
    built = BUILT.read_bytes()
    must(len(base) == 0x100000, f"unexpected baserom size {len(base):#x}")
    must(len(built) == 0x100000, f"unexpected built ROM size {len(built):#x}")

    total = 0
    for bank, start, end, label, expected_sha1 in RANGES:
        off = bank_offset(bank, start)
        size = end - start
        ref = base[off:off + size]
        got = built[off:off + size]
        sha1 = hashlib.sha1(ref).hexdigest()
        must(sha1 == expected_sha1, f"{label} retail SHA-1 changed: {sha1}")
        must(got == ref, f"{label} built bytes differ from retail at {bank:02X}:{start:04X}-{end-1:04X}")
        total += size
        print(f"PASS {bank:02X}:{start:04X}-{end-1:04X} {size} bytes SHA-1 {sha1}")
    must(total == 2935, f"unexpected owned-byte total {total}")
    print(f"PASS {total} newly source-owned bytes")

    custom_sha = hashlib.sha256(built).hexdigest()
    must(custom_sha == CANONICAL_CUSTOM_SHA256, f"custom-English ROM hash drift: {custom_sha}")
    print(f"PASS custom-English SHA-256 {custom_sha}")

    syms = parse_sym()
    for name, expected in PUBLIC_SYMBOLS.items():
        must(syms.get(name) == expected, f"{name} expected {expected[0]:02X}:{expected[1]:04X}, got {syms.get(name)}")
    print(f"PASS {len(PUBLIC_SYMBOLS)} public symbol addresses")

    frontend = (ROOT / "engine/unit/unit_reference_frontend_5da5.asm").read_text(encoding="utf-8")
    nav = (ROOT / "engine/unit/unit_reference_navigation_runtime_5f36.asm").read_text(encoding="utf-8")
    values = (ROOT / "engine/unit/unit_reference_detail_values_638a.asm").read_text(encoding="utf-8")
    detail = (ROOT / "engine/unit/unit_reference_detail_runtime_6707.asm").read_text(encoding="utf-8")
    status = (ROOT / "engine/unit/unit_status.asm").read_text(encoding="utf-8")

    for needle in ["call UnitReference_ChooseType", "call UnitReference_RunDetailController", "ld hl, UnitReference_String_DetailMarker"]:
        must(needle in frontend, f"frontend integration missing: {needle}")
    for needle in ["assert @ == $60d8", 'section "Unit Reference Type Chooser", romx[$60f9], bank[$25]', "assert @ == $62d6"]:
        must(needle in nav, f"navigation boundary guard missing: {needle}")
    for needle in ["assert @ == $64fc", "assert @ == $6503", "assert @ == $66bf", "assert @ == $66fe"]:
        must(needle in values, f"detail-value boundary guard missing: {needle}")
    for needle in ["assert @ == $6797", "assert @ == $6831", "assert @ == $68a1", "assert @ == $6a1f", "assert @ == $6ad0"]:
        must(needle in detail, f"detail-controller boundary guard missing: {needle}")
    for needle in ["UnitStatus_Header::", "UnitStatus_Menu::", "UnitStatus_String_None::", "UnitStatus_String_Costs::", "UnitStatus_String_MaterialCost::"]:
        must(needle in status, f"required exported Unit Status resource missing: {needle}")

    scan_raw_refs()
    print("PASS symbolic integration for chooser/detail renderer/controller")
    print("Unit Reference navigation/detail verification: PASS")


if __name__ == "__main__":
    main()
