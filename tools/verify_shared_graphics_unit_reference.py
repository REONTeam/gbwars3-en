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
    (0x01, 0x4000, 0x4118, "Shared graphics frontend", "e6af36b0317434f059cd377b4fd61e8e7411701b"),
    (0x25, 0x5DA5, 0x5E49, "Unit Reference frontend", "922dbabf0e3acc3687fc55afd72063021634ceff"),
]

PUBLIC_SYMBOLS = {
    "SharedGraphics_LoadMainFontBG": (0x01, 0x4000),
    "MapGraphics_LoadGameplayAssets": (0x01, 0x401C),
    "MapGraphics_LoadGameplayAssetsAndFontBG": (0x01, 0x40CE),
    "SharedGraphics_LoadMenuFontTiles": (0x01, 0x40FC),
    "UnitReference_Open": (0x25, 0x5DA5),
    "UnitReference_ResetWorkState": (0x25, 0x5DD9),
    "UnitReference_DrawText6500": (0x25, 0x5E01),
    "UnitReference_DrawUnitName": (0x25, 0x5E08),
    "UnitReference_DrawUnitClassName": (0x25, 0x5E1E),
    "UnitReference_ClassStringPointers": (0x25, 0x5E3F),
    "UnitStatus_Type_Armored": (0x25, 0x5E49),
    "UnitStatus_Type_Unarmored": (0x25, 0x5E53),
    "UnitStatus_Type_Air": (0x25, 0x5E5D),
    "UnitStatus_Type_Sea": (0x25, 0x5E67),
    "UnitStatus_Type_Submarine": (0x25, 0x5E71),
}


def bank_offset(bank: int, address: int) -> int:
    if bank == 0:
        return address
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


def scan_raw_calls() -> None:
    patterns = [
        re.compile(r"farcall\s+\$0*1\s*,\s*\$?4000\b", re.I),
        re.compile(r"farcall\s+\$0*1\s*,\s*\$?40fc\b", re.I),
        re.compile(r"farcall\s+\$25\s*,\s*\$?5da5\b", re.I),
    ]
    offenders: list[str] = []
    for p in ROOT.joinpath("engine").rglob("*.asm"):
        text = p.read_text(encoding="utf-8", errors="replace")
        for lineno, line in enumerate(text.splitlines(), 1):
            code = line.split(";", 1)[0]
            if any(rx.search(code) for rx in patterns):
                offenders.append(f"{p.relative_to(ROOT)}:{lineno}: {line.strip()}")
    must(not offenders, "raw farcalls remain:\n" + "\n".join(offenders))


def main() -> None:
    must(BASE.exists(), "baserom.gbc is required")
    must(BUILT.exists(), "GBWARS3.gbc must be built before verification")
    must(SYM.exists(), "GBWARS3.sym must exist")

    base = BASE.read_bytes()
    built = BUILT.read_bytes()
    must(len(base) == 0x100000, f"unexpected baserom size {len(base):#x}")
    must(len(built) == 0x100000, f"unexpected built ROM size {len(built):#x}")

    for bank, start, end, label, expected_sha1 in RANGES:
        off = bank_offset(bank, start)
        size = end - start
        ref = base[off:off + size]
        got = built[off:off + size]
        sha1 = hashlib.sha1(ref).hexdigest()
        must(sha1 == expected_sha1, f"{label} retail SHA-1 changed: {sha1}")
        must(got == ref, f"{label} built bytes differ from retail at {bank:02X}:{start:04X}-{end-1:04X}")
        print(f"PASS {bank:02X}:{start:04X}-{end-1:04X} {size} bytes SHA-1 {sha1}")

    custom_sha = hashlib.sha256(built).hexdigest()
    must(custom_sha == CANONICAL_CUSTOM_SHA256, f"custom-English ROM hash drift: {custom_sha}")
    print(f"PASS custom-English SHA-256 {custom_sha}")

    syms = parse_sym()
    for name, expected in PUBLIC_SYMBOLS.items():
        must(syms.get(name) == expected, f"{name} expected {expected[0]:02X}:{expected[1]:04X}, got {syms.get(name)}")
    print(f"PASS {len(PUBLIC_SYMBOLS)} public symbol addresses")

    map_src = (ROOT / "engine/map/map_graphics.asm").read_text(encoding="utf-8")
    unit_src = (ROOT / "engine/unit/unit_reference_frontend_5da5.asm").read_text(encoding="utf-8")
    status_src = (ROOT / "engine/unit/unit_status.asm").read_text(encoding="utf-8")

    for needle in [
        'section "Shared Gameplay Graphics Frontend", romx[$4000], bank[$01]',
        'assert @ == $401c', 'assert @ == $40ce', 'assert @ == $40fc', 'assert @ == $4118',
    ]:
        must(needle in map_src, f"missing Bank 1 source guard: {needle}")

    for needle in [
        'section "Unit Reference Frontend", romx[$5da5], bank[$25]',
        'assert @ == $5dd9', 'assert @ == $5e01', 'assert @ == $5e08',
        'assert @ == $5e1e', 'assert @ == $5e3f', 'assert @ == $5e49',
        'farcall UnitData_CopyNameToBuffer', 'farcall UnitList_EncodeDisplayValue',
        'farcall UnitData_GetByte',
    ]:
        must(needle in unit_src, f"missing Unit Reference source contract: {needle}")

    class_order = [
        'dw UnitStatus_Type_Armored', 'dw UnitStatus_Type_Unarmored',
        'dw UnitStatus_Type_Air', 'dw UnitStatus_Type_Sea', 'dw UnitStatus_Type_Submarine',
    ]
    pos = -1
    for needle in class_order:
        nxt = unit_src.find(needle)
        must(nxt > pos, f"Unit Reference class table missing/out of order: {needle}")
        pos = nxt

    for needle in [
        'UnitStatus_Type_Armored::', 'UnitStatus_Type_Unarmored::', 'UnitStatus_Type_Air::',
        'UnitStatus_Type_Sea::', 'UnitStatus_Type_Submarine::',
    ]:
        must(needle in status_src, f"missing exported Unit Status class label: {needle}")

    scan_raw_calls()
    print("PASS raw caller integration for $01:$4000/$40FC and $25:$5DA5")
    print("Shared graphics + Unit Reference verification: PASS")


if __name__ == "__main__":
    main()
