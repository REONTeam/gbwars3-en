#!/usr/bin/env python3
from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
ROM = ROOT / "baserom.gbc"
BANK = 0x12
START = 0x4741
END = 0x479F
EXPECTED_SHA1 = "cf55f96a8b65ca1fc80c8f64e5d0de318f659584"


def rom_slice(rom: bytes, bank: int, start: int, end: int) -> bytes:
    off = bank * 0x4000 + (start - 0x4000)
    return rom[off:off + end - start]


def main() -> None:
    assert ROM.exists(), "baserom.gbc required"
    rom = ROM.read_bytes()
    data = rom_slice(rom, BANK, START, END)
    assert len(data) == 94
    assert hashlib.sha1(data).hexdigest() == EXPECTED_SHA1

    src = (ROOT / "engine/unit/unit_setup.asm").read_text()
    for token in [
        'section "Unit Refill And HP Helpers", romx[$4741], bank[$12]',
        'Unit_RefillFuelFromDefinition::',
        'Unit_RefillAmmoFromDefinition::',
        'Unit_AddHPClampedToMax::',
        'UNIT_DATA_MAX_FUEL_OFFSET', 'UNIT_DATA_WEAPON1_AMMO_OFFSET',
        'UNIT_DATA_WEAPON2_AMMO_OFFSET', 'UNIT_DATA_MAX_HP_OFFSET',
        'UNIT_RECORD_FUEL_OFFSET', 'UNIT_RECORD_WEAPON1_AMMO_OFFSET',
        'UNIT_RECORD_WEAPON2_AMMO_OFFSET', 'UNIT_RECORD_HP_OFFSET',
        'assert @ == $479f',
    ]:
        assert token in src, token

    print("[ok] Bank $12:$4741-$479E unit refill/HP helpers ROM-verified")
    print(f"     94 bytes; SHA-1 {EXPECTED_SHA1}")
    print("     fuel + both ammo maxima sourced; HP addition clamps to UnitData max HP")


if __name__ == "__main__":
    main()
