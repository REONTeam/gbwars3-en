#!/usr/bin/env python3
"""Verify SRAM map-slot runtime/source against the Japanese ROM."""
from __future__ import annotations
import hashlib
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1] if len(sys.argv) > 1 else ROOT / "baserom.gbc")

RANGES = [
    ("SRAM_Enable/Disable", 0x00, 0x0593, 0x05A2, "496a7cd903a145d4445766ba2befe1b61957b7ce"),
    ("MapSRAMSlotLocations", 0x00, 0x391C, 0x3930, "852286df04cf8d88a15449704f32e4c7894fa794"),
    ("SRAM signature check/write", 0x00, 0x3930, 0x3988, "86bc8d08dbe26372b26ec3cdabb635c5b3ff16ce"),
    ("Bitfield set/clear", 0x00, 0x3AD1, 0x3AE9, "0659bd167ea9675d96a8b14746e3299504ceb1f2"),
    ("MapRecord_LoadSRAMSlotPrefix", 0x13, 0x5DCC, 0x5E1E, "67b7675b9a2f5db4fcb9c9c5e47721793f8c9344"),
    ("Map SRAM slot management", 0x13, 0x5E1E, 0x5EC2, "eef88fbdb1eae6b245cead887ec00bb459fb9572"),
]

EXPECTED_SLOT_BYTES = bytes.fromhex("07a007b008a008b009a009b00aa00ab00ba00bb0")
EXPECTED_LOADER_BYTES = bytes.fromhex(
    "f587211c39cdbc29cd93052acd8d05ea1acaafea1bca5f2aea1cca57"
    "2121ca012000cd503b2141ca010800cd503b2149ca010600cd503b"
    "3e00cd8d05f1210fa0cdc73a2805afcbcf1801afea1dcacd9b05c9"
)
EXPECTED_SRAM_HELPERS = bytes.fromhex("f53e0aea0000f1c9f5afea0000f1c9")
EXPECTED_BITFIELD_MUTATORS = bytes.fromhex(
    "c5e5cde93a7eb177e1c1c9"
    "c5e5cde93a792f46a077e1c1c9"
)
EXPECTED_SLOT_MANAGEMENT = bytes.fromhex(
    "c5d5e5f082f53e05e082e070780605cd555e790605cd835ef1e082e070e1d1c1c9"
    "c547cd93053e00cd8d05210fa078cddc3acd9b05c1c9"
    "c5d54ff082f5cd930578e082e0707987211c39cdbc292acd8d05561e002100d0010010cd503bf1e082e070d1c1c9"
    "c5d54ff082f5cd930578e082e070c57987211c39cdbc292acd8d05662e001100d0010010cd503bc13e00cd8d05210fa079cdd13acd9b05f1e082e070d1c1c9"
)


def rom_slice(data: bytes, bank: int, start: int, end: int) -> bytes:
    off = start if bank == 0 else bank * 0x4000 + (start - 0x4000)
    return data[off: off + end - start]


def fail(msg: str) -> None:
    raise SystemExit(f"map SRAM verification: [FAIL] {msg}")


def main() -> None:
    if not ROM.is_file():
        fail(f"ROM not found: {ROM}")
    rom = ROM.read_bytes()

    for name, bank, start, end, sha in RANGES:
        block = rom_slice(rom, bank, start, end)
        got = hashlib.sha1(block).hexdigest()
        if got != sha:
            fail(f"{name} SHA-1 {got} != {sha}")
        print(f"{name:34s}: {end-start:3d} bytes / SHA-1 {got} [ok]")

    if rom_slice(rom, 0, 0x0593, 0x05A2) != EXPECTED_SRAM_HELPERS:
        fail("SRAM helper byte reconstruction mismatch")
    if rom_slice(rom, 0, 0x391C, 0x3930) != EXPECTED_SLOT_BYTES:
        fail("slot-table byte reconstruction mismatch")
    if rom_slice(rom, 0, 0x3AD1, 0x3AE9) != EXPECTED_BITFIELD_MUTATORS:
        fail("bitfield set/clear byte reconstruction mismatch")
    if rom_slice(rom, 0x13, 0x5DCC, 0x5E1E) != EXPECTED_LOADER_BYTES:
        fail("Bank $13 prefix-loader byte reconstruction mismatch")
    if rom_slice(rom, 0x13, 0x5E1E, 0x5EC2) != EXPECTED_SLOT_MANAGEMENT:
        fail("Bank $13 slot-management byte reconstruction mismatch")

    home = (ROOT / "engine/home/home.asm").read_text()
    home_map = (ROOT / "engine/home/home_map.asm").read_text()
    sram = (ROOT / "engine/map/map_sram.asm").read_text()
    runtime = (ROOT / "engine/map/map_runtime.asm").read_text()
    menu = (ROOT / "engine/map/map_menu.asm").read_text()
    consts = (ROOT / "constants/map_constants.inc").read_text()
    hw = (ROOT / "constants/hardware.inc").read_text()

    for token in (
        "SRAM_Enable::", "SRAM_Disable::", "DEF rRAMG  EQU $0000",
        'section "Map SRAM Slot Locations", rom0[$391c]',
        "MapSRAMSlotLocations::", "SRAM_CheckSignature::", "SRAM_WriteSignature::",
        "assert @ == $3988",
        "Bitfield_Set::", "Bitfield_Clear::",
        'section "Map SRAM Record Loader", romx[$5dcc], bank[$13]',
        "MapRecord_LoadSRAMSlotPrefix::",
        "ld hl, wMapRecordBuffer", "ld bc, $0020",
        "ld hl, wMapRecordName", "ld bc, MAP_RECORD_NAME_SIZE",
        "ld hl, wMapRecordFields", "ld bc, $0006",
        "assert @ == $5e1e",
        "MapSRAM_CopySlot::", "MapSRAM_ClearSlotPresent::",
        "MapSRAM_LoadSlotToWRAMBank::", "MapSRAM_SaveSlotFromWRAMBank::",
        "MAP_SRAM_SLOT_SIZE", "MAP_SRAM_SLOT_PRESENT_BITS",
        "MAP_SRAM_STAGING_WRAM_BANK", "MAP_SRAM_STAGING_ADDR",
        "assert @ == $5ec2",
    ):
        if token not in home + home_map + sram + consts + hw:
            fail(f"missing source invariant: {token}")

    if "farcall MapRecord_LoadSRAMSlotPrefix" not in runtime:
        fail("Bank $28 runtime does not call SRAM loader symbolically")
    if "farcall $13, $5dcc" in runtime.lower():
        fail("raw Bank $13:$5DCC farcall remains")
    if "call $059b" in menu.lower():
        fail("raw SRAM_Disable call remains in map_menu.asm")
    if "call SRAM_Disable" not in menu:
        fail("map_menu.asm does not use SRAM_Disable symbol")

    print("10-entry SRAM slot location table    : [ok]")
    print("GBW3 SRAM signature check/write      : [ok]")
    print("46-byte SRAM map-prefix copy layout  : [ok]")
    print("4 KiB slot copy/load/save path       : [ok]")
    print("SRAM slot-presence set/clear path    : [ok]")
    print("Bank $28 symbolic SRAM-loader call   : [ok]")
    print("Map Menu symbolic SRAM-disable call  : [ok]")


if __name__ == "__main__":
    main()
