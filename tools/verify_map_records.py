#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

TABLES = (
    ("standard", 0x41DC, 60),
    ("demo", 0x4290, 1),
    ("beginner", 0x4293, 16),
    ("campaign", 0x42C3, 45),
)
BANK28 = 0x28
BANK_SIZE = 0x4000


def file_offset(bank: int, address: int) -> int:
    if bank == 0:
        return address
    if not 0x4000 <= address <= 0x7FFF:
        raise ValueError(f"invalid ROMX address ${address:04X}")
    return bank * BANK_SIZE + (address - 0x4000)


def main() -> int:
    parser = argparse.ArgumentParser(description="Verify GBWars3 Bank $28 map pointers and record framing")
    parser.add_argument("rom", nargs="?", default="baserom.gbc")
    args = parser.parse_args()

    rom = Path(args.rom).read_bytes()
    if len(rom) < 0x30 * BANK_SIZE:
        raise SystemExit("ROM is too small to contain Banks $28-$2F")

    total = 0
    for table_name, table_addr, count in TABLES:
        table_off = file_offset(BANK28, table_addr)
        setup_records = 0
        for index in range(count):
            p = table_off + index * 3
            bank = rom[p]
            address = rom[p + 1] | (rom[p + 2] << 8)
            if not 0x29 <= bank <= 0x2F:
                raise SystemExit(f"{table_name}[{index}]: invalid bank ${bank:02X}")
            record_off = file_offset(bank, address)
            header = rom[record_off:record_off + 0x20]
            if len(header) != 0x20 or header[:2] != b"\x20\x00" or any(header[5:]):
                raise SystemExit(f"{table_name}[{index}] ${bank:02X}:${address:04X}: invalid 32-byte header")
            body_len = header[2] | (header[3] << 8)
            body = rom[record_off + 0x20:record_off + 0x20 + body_len]
            if len(body) != body_len or body[-1:] != b"\xFF":
                raise SystemExit(f"{table_name}[{index}] ${bank:02X}:${address:04X}: invalid body length/terminator")
            if body_len < 15:
                raise SystemExit(f"{table_name}[{index}] ${bank:02X}:${address:04X}: body too short")
            width, height = body[12], body[13]
            terrain_len = width * height
            extra = body_len - (8 + 4 + 2 + terrain_len + 1)
            if extra < 0 or extra % 3:
                raise SystemExit(
                    f"{table_name}[{index}] ${bank:02X}:${address:04X}: "
                    f"body does not fit name+fields+dimensions+terrain+3-byte initial-unit records+terminator"
                )
            setup_records += extra // 3
        total += count
        print(f"{table_name:8s}: {count:3d} pointers [ok], initial-unit records: {setup_records}")

    end = 0x42C3 + 45 * 3
    if end != 0x434A:
        raise AssertionError("table boundary constant mismatch")
    tail_off = file_offset(BANK28, 0x434A)
    if rom[tail_off] != 0xFF:
        raise SystemExit("Bank $28 byte after Campaign table is not $FF")

    print(f"total    : {total:3d} map-record pointers [ok]")
    print("record framing: 32-byte header (one per-map field + zero tail) + body-length word + $FF-terminated body [ok]")
    print("initial-unit tail: zero or more 3-byte records after terrain [ok]")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
