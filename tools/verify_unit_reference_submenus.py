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
    (0x25, 0x6AEC, 0x6B7D, "Unit Reference description submenu controller", "f7a12506758a65df0737fb2e07634b2e255a1d8b"),
    (0x25, 0x6B7D, 0x6F34, "Unit Reference movement page renderer/data", "1e6cb338f753d4c4025a27e39a14795e19901c36"),
    (0x25, 0x6F3A, 0x6F83, "Unit Reference movement selection helpers", "12adb34b5c42e5cc265877ad62d2f4dcec1e6832"),
    (0x25, 0x6F83, 0x7061, "Unit Reference movement submenu controller", "09aeb8edd8d8e607505d1cb87f82778afaa4da69"),
    (0x25, 0x733B, 0x73C6, "Unit Reference upkeep submenu controller", "8ccd0beb0c95eaa3827a0f51dba4f40217a05d75"),
    (0x25, 0x7509, 0x752D, "Unit Reference weapon submenu controller", "9c7e4ef9be90e03c192a2940f2b78f06f9b20e53"),
    (0x25, 0x759A, 0x7625, "Unit Reference initiative submenu controller", "c7c6c6f68a8a0070363daf9386727cb5b27eba23"),
    (0x25, 0x779E, 0x781C, "Unit Reference load submenu controller", "bd464f6a4e1e84f59a5edcfa340cf5d92721ecea"),
    (0x25, 0x7879, 0x7917, "Unit Reference promotion submenu controller", "02201a7635c044ab9f74d0e41e182e0d61122aba"),
    (0x25, 0x79F8, 0x7A19, "Unit Reference defense submenu controller", "c7f5778e57a8b0d3bc2fdb552305b9ebbe011b74"),
    (0x25, 0x7F7A, 0x7FF1, "Unit Reference resupply/repair submenu controller", "0ca7ea389fe0116f6cf42b874c4095b4f676a07d"),
]

PUBLIC_SYMBOLS = {
    "UnitReference_RunDescriptionSubmenu": (0x25, 0x6AEC),
    "UnitReference_LoadMovementTerrainGraphics": (0x25, 0x6B7D),
    "UnitReference_LoadMovementCellDescriptor": (0x25, 0x6C83),
    "UnitReference_DrawMovementCellValue": (0x25, 0x6CA1),
    "UnitReference_DrawMovementTerrainGrid": (0x25, 0x6D2E),
    "UnitReference_MovementLossLowNibbleDisplayTable": (0x25, 0x6D7F),
    "UnitReference_MovementCellDescriptorPointers": (0x25, 0x6D8F),
    "UnitReference_UpdateMovementCursorPosition": (0x25, 0x6E2B),
    "UnitReference_UpdateMovementPageArrows": (0x25, 0x6E4D),
    "UnitReference_DrawMovementSubmenu": (0x25, 0x6E64),
    "UnitStatus_Submenu_Move": (0x25, 0x6F34),
    "UnitReference_UpdateMovementTerrainSelection": (0x25, 0x6F3A),
    "UnitReference_UpdateMovementGridSelection": (0x25, 0x6F64),
    "UnitReference_RunMovementSubmenu": (0x25, 0x6F83),
    "UnitReference_RunUpkeepSubmenu": (0x25, 0x733B),
    "UnitReference_RunWeaponSubmenu": (0x25, 0x7509),
    "UnitReference_RunInitiativeSubmenu": (0x25, 0x759A),
    "UnitReference_RunLoadSubmenu": (0x25, 0x779E),
    "UnitReference_RunPromotionSubmenu": (0x25, 0x7879),
    "UnitReference_RunDefenseSubmenu": (0x25, 0x79F8),
    "UnitReference_RunResupplyRepairSubmenu": (0x25, 0x7F7A),
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
    targets = [
        0x6AEC, 0x6B7D, 0x6C83, 0x6CA1, 0x6D2E, 0x6E2B, 0x6E4D,
        0x6E64, 0x6F3A, 0x6F64, 0x6F83, 0x733B, 0x7509, 0x759A,
        0x779E, 0x7879, 0x79F8, 0x7F7A,
    ]
    addr_alt = "|".join(f"{x:04x}" for x in targets)
    rx = re.compile(rf"\b(?:call|jp)\s+\$?(?:{addr_alt})\b", re.I)
    offenders: list[str] = []
    for p in ROOT.joinpath("engine").rglob("*.asm"):
        for lineno, line in enumerate(p.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
            code = line.split(";", 1)[0]
            if rx.search(code):
                offenders.append(f"{p.relative_to(ROOT)}:{lineno}: {line.strip()}")
    must(not offenders, "raw references remain to newly named Unit Reference entries:\n" + "\n".join(offenders))


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
        must(got == ref, f"{label} built bytes differ at {bank:02X}:{start:04X}-{end - 1:04X}")
        total += size
        print(f"PASS {bank:02X}:{start:04X}-{end - 1:04X} {size} bytes SHA-1 {sha1}")
    must(total == 2141, f"unexpected newly owned-byte total {total}")
    print(f"PASS {total} newly source-owned bytes")

    custom_sha = hashlib.sha256(built).hexdigest()
    must(custom_sha == CANONICAL_CUSTOM_SHA256, f"custom-English ROM hash drift: {custom_sha}")
    print(f"PASS custom-English SHA-256 {custom_sha}")

    syms = parse_sym()
    for name, expected in PUBLIC_SYMBOLS.items():
        must(syms.get(name) == expected, f"{name} expected {expected[0]:02X}:{expected[1]:04X}, got {syms.get(name)}")
    print(f"PASS {len(PUBLIC_SYMBOLS)} public symbol addresses")

    detail = (ROOT / "engine/unit/unit_reference_detail_runtime_6707.asm").read_text(encoding="utf-8")
    controllers = (ROOT / "engine/unit/unit_reference_submenu_controllers.asm").read_text(encoding="utf-8")
    movement = (ROOT / "engine/unit/unit_reference_movement_submenu_runtime.asm").read_text(encoding="utf-8")
    status = (ROOT / "engine/unit/unit_status.asm").read_text(encoding="utf-8")

    for needle in [
        "call UnitReference_RunDescriptionSubmenu",
        "call UnitReference_RunMovementSubmenu",
        "call UnitReference_RunUpkeepSubmenu",
        "call UnitReference_RunWeaponSubmenu",
        "call UnitReference_RunInitiativeSubmenu",
        "call UnitReference_RunLoadSubmenu",
        "call UnitReference_RunPromotionSubmenu",
        "call UnitReference_RunDefenseSubmenu",
        "call UnitReference_RunResupplyRepairSubmenu",
    ]:
        must(needle in detail, f"dispatcher integration missing: {needle}")

    for needle in [
        "call UnitReference_DrawMovementSubmenu",
        "call UnitReference_UpdateMovementTerrainSelection",
        "call UnitReference_UpdateMovementGridSelection",
        "call UnitReference_DrawMovementTerrainGrid",
        "call UnitReference_UpdateMovementPageArrows",
        "call UnitReference_UpdateMovementCursorPosition",
        "assert @ == $6b7d",
        "assert @ == $7061",
    ]:
        must(needle in controllers, f"controller integration/boundary guard missing: {needle}")

    for needle in [
        "assert @ == $6c83",
        "assert @ == $6ca1",
        "assert @ == $6d2e",
        "assert @ == $6e2b",
        "assert @ == $6e64",
        "assert @ == $6f34",
        "assert @ == $6f83",
        "dw .cell00, .cell01, .cell02, .cell03, .cell04, .cell05",
        "wMovementCostByMapTile",
    ]:
        must(needle in movement, f"movement runtime guard missing: {needle}")

    pointer_block = movement.split("UnitReference_MovementCellDescriptorPointers::", 1)[1].split("assert @ == $6e2b", 1)[0]
    must(len(re.findall(r"\.cell\d\d", pointer_block.split(".cell00:", 1)[0])) == 26,
         "movement descriptor pointer table must contain 26 entries")
    must(len(re.findall(r"(?m)^\.cell\d\d:\s+db\s+", pointer_block)) == 26,
         "movement descriptor data must contain 26 records")
    must("UnitStatus_Submenu_Move::" in status, "movement submenu custom-English text must stay separately exported")

    scan_raw_refs()
    print("PASS symbolic submenu dispatcher/movement integration")
    print("Unit Reference submenu/movement verification: PASS")


if __name__ == "__main__":
    main()
