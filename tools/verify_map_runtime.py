#!/usr/bin/env python3
"""Verify the the current source map-selection/runtime source against the Japanese ROM."""
from __future__ import annotations
import hashlib
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1] if len(sys.argv) > 1 else ROOT / "baserom.gbc")

RANGES = [
    ("MapRecord_LoadPrefix", 0x00, 0x28A0, 0x28D9, "e94e7dab2270f1807f47c84b48bae38ca54021c3"),
    ("AddAtoHL", 0x00, 0x29BC, 0x29C3, "edad6838287c8435fb04c2d77e9f38671113f429"),
    ("Bitfield_Test", 0x00, 0x3AC7, 0x3AD1, "595ae342d3212ef1dd68418047dc9a94df8fc9a0"),
    ("Bitfield_GetAddressAndMask", 0x00, 0x3AE9, 0x3B06, "37a462666a05ffec74a54de7334f1cf50351c506"),
    ("Bank28_MapRuntime", 0x28, 0x4000, 0x41DC, "e16e41f0969b159ba63ab6bdf10966d5c67e976c"),
]

EXPECTED_LABELS = {
    "MapRecord_SelectBeginner": 0x4000,
    "MapRecord_SelectCampaign": 0x4024,
    "MapRecord_SelectStandard": 0x405A,
    "MapRecord_SelectPointer": 0x407E,
    "MapRecord_ClearState": 0x409D,
    "MapRuntime_LoadCurrentModeRecord": 0x40AE,
    "MapRuntime_PrepareSelectedMap": 0x40C1,
    "MapRuntime_HandleStandardIndex30Plus": 0x40D7,
    "MapRuntime_GetStandardFlagTier": 0x40EE,
    "MapRuntime_AreBeginnerFlags0To14Set": 0x4135,
    "MapRuntime_AreFlagRangeSet": 0x4149,
    "MapRuntime_GetCampaignTableByte0": 0x4157,
    "MapRuntime_GetCampaignTableByte1": 0x4160,
    "MapRuntime_CampaignTable": 0x416A,
    "MapRuntime_GetBeginnerTableValue": 0x41C4,
    "MapRuntime_BeginnerTable": 0x41CC,
}

CAMPAIGN_TABLE = bytes.fromhex(
    "1e1e1e1e1e0d1e0f1e101e0f1e0f1e1e1e1e2020200e20202011201020102012"
    "2013201422122222221322162222221322162216222224162413241124142413241124172418"
    "2411261426262611261426262611261428132811"
)
BEGINNER_TABLE = bytes.fromhex("04020403040102030404020101010101")


def rom_slice(data: bytes, bank: int, start: int, end: int) -> bytes:
    offset = start if bank == 0 else bank * 0x4000 + (start - 0x4000)
    return data[offset : offset + end - start]


def fail(msg: str) -> None:
    raise SystemExit(f"map runtime verification: [FAIL] {msg}")


def main() -> None:
    if not ROM.is_file():
        fail(f"ROM not found: {ROM}")
    rom = ROM.read_bytes()
    if len(rom) < 0x29 * 0x4000:
        fail("ROM is too small")

    for name, bank, start, end, expected_sha1 in RANGES:
        block = rom_slice(rom, bank, start, end)
        sha1 = hashlib.sha1(block).hexdigest()
        if sha1 != expected_sha1:
            fail(f"{name} SHA-1 {sha1} != {expected_sha1}")
        print(f"{name:32s}: {end-start:3d} bytes / SHA-1 {sha1} [ok]")

    runtime = (ROOT / "engine/map/map_runtime.asm").read_text()
    home = (ROOT / "engine/home/home_map.asm").read_text()
    symbols = (ROOT / "symbols.asm").read_text()
    menu = (ROOT / "engine/map/map_menu.asm").read_text()

    # Static placement checks: these labels are the instruction/data boundaries
    # independently decoded from the retail byte stream.
    order = list(EXPECTED_LABELS)
    positions = [runtime.find(label + "::") if label + "::" in runtime else runtime.find(label + ":") for label in order]
    if any(p < 0 for p in positions) or positions != sorted(positions):
        fail("Bank $28 labels are missing or out of physical order")

    for token in (
        "ld bc, MAP_RECORD_PREFIX_SIZE",
        "ld hl, wMapRecordName",
        "ld c, MAP_RECORD_NAME_SIZE",
        "ld hl, MapRecordPointers_Beginner",
        "ld hl, MapRecordPointers_Campaign",
        "ld hl, MapRecordPointers_Standard",
        "assert @ == $41dc",
    ):
        if token not in home + runtime:
            fail(f"missing source invariant: {token}")

    if CAMPAIGN_TABLE != rom_slice(rom, 0x28, 0x416A, 0x41C4):
        fail("Campaign runtime lookup table mismatch")
    if BEGINNER_TABLE != rom_slice(rom, 0x28, 0x41CC, 0x41DC):
        fail("Beginner runtime lookup table mismatch")

    for sym in (
        "wBeginnerMapFlags", "wCampaignMapFlags", "wStandardMapFlags",
        "wCampaignMapSecondaryFlags", "wMapRecordFarPointer", "wMapRecordFlags",
        "wMapRecordCategory", "wMapRecordIndex", "wMapRecordBuffer",
        "wMapRecordName", "wMapRecordFields", "wMapRecordWidth", "wMapRecordHeight",
    ):
        if sym not in symbols:
            fail(f"missing WRAM symbol {sym}")

    if "$ca1f" in menu.lower() or "$ca41" in menu.lower():
        fail("map_menu.asm still contains raw selected-map index/name addresses")

    print("Bank $28 runtime boundaries/tables : [ok]")
    print("ROM0 46-byte map-prefix loader     : [ok]")
    print("map WRAM family/state symbols      : [ok]")
    print("map-menu symbolic cross-references : [ok]")


if __name__ == "__main__":
    main()
