#!/usr/bin/env python3
"""Verify mnemonic conversion of the Bank $18 Unit List tail."""
from __future__ import annotations

import hashlib
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "baserom.gbc"
SOURCE = ROOT / "engine/unit/unit_list_tail_runtime_7e78.asm"
BANK = 0x18
RANGES = (
    (0x7E78, 0x7F5C, "83fca09295808c69e8ade2676ab5d92fa2c4f798"),
    (0x7F62, 0x8000, "80a4175542b0178d4c2dbe0c023c7355c65450a9"),
)
EXPECTED_INSTRUCTIONS = 178

OP_RE = re.compile(
    r"^\s*(?:adc|add|and|bit|call|ccf|cp|cpl|daa|dec|di|ei|farcall|halt|inc|"
    r"jp|jr|ld|ldh|nop|or|pop|push|res|ret|reti|rl|rla|rlc|rlca|rr|rra|rrc|"
    r"rrca|rst|sbc|scf|set|sla|sra|srl|stop|sub|swap|xor)\b",
    re.IGNORECASE,
)


def tool(name: str) -> Path:
    suffix = ".exe" if os.name == "nt" else ""
    local = ROOT / "tools/rgbds/bin" / (name + suffix)
    if local.exists():
        return local
    found = shutil.which(name + suffix) or shutil.which(name)
    if found:
        return Path(found)
    raise SystemExit(f"missing {name}; run make rgbds first")


def main() -> int:
    rom = ROM.read_bytes()
    for start, end, expected in RANGES:
        off = BANK * 0x4000 + (start - 0x4000)
        data = rom[off : off + (end - start)]
        assert hashlib.sha1(data).hexdigest() == expected

    src = SOURCE.read_text(encoding="utf-8")
    assert 'section "Unit List Tail Data Runtime", romx[$7e78], bank[$18]' in src
    assert 'section "Unit List Tail Runtime End", romx[$7f62], bank[$18]' in src
    assert 'assert @ == $7f5c' in src.lower()
    assert 'assert @ == $8000' in src.lower()
    for label in (
        "UnitList_EncodeDisplayValue::",
        "UnitList_RebuildFilteredDisplayBuffer::",
        "UnitList_AppendFilteredRecordFields::",
        "UnitList_UpdateCountAndFilteredRows::",
        "UnitList_ProcessFilteredEntries::",
        "UnitList_GetFilteredEntryValue::",
        "UnitList_FindMatchingFilteredEntry::",
    ):
        assert label in src

    instructions = sum(bool(OP_RE.match(line)) for line in src.splitlines())
    assert instructions == EXPECTED_INSTRUCTIONS, instructions

    # Only the proven lookup table and final four padding bytes remain raw DB.
    db_values = []
    for line in src.splitlines():
        code = line.split(";", 1)[0]
        if re.match(r"^\s*db\b", code, re.IGNORECASE):
            db_values.extend(int(x, 16) for x in re.findall(r"\$([0-9a-fA-F]{2})", code))
    assert len(db_values) == 68, len(db_values)
    table_off = BANK * 0x4000 + (0x7E78 - 0x4000)
    assert bytes(db_values[:64]) == rom[table_off : table_off + 64]
    assert bytes(db_values[64:]) == b"\xff\xff\xff\xff"

    rgbasm = tool("rgbasm")
    rgblink = tool("rgblink")
    with tempfile.TemporaryDirectory(prefix="gbwars3-unit-list-tail-") as td:
        temp = Path(td)
        stubs_asm = temp / "stubs.asm"
        stubs_o = temp / "stubs.o"
        runtime_o = temp / "runtime.o"
        linked = temp / "linked.gbc"
        stubs_asm.write_text(
            "DEF hWRAMBank EQU $ff82\nEXPORT hWRAMBank\n"
            "SECTION \"Stub UnitList Filtered Ptr\", ROMX[$7346], BANK[$17]\n"
            "UnitList_GetFilteredRecordPointer::\n",
            encoding="ascii",
        )
        subprocess.run([str(rgbasm), "-o", str(stubs_o), str(stubs_asm)], check=True)
        subprocess.run(
            [str(rgbasm), "-p", "0xff", "-o", str(runtime_o), str(SOURCE)],
            check=True,
            cwd=ROOT,
        )
        subprocess.run(
            [str(rgblink), "-O", str(ROM), "-o", str(linked), str(runtime_o), str(stubs_o)],
            check=True,
            cwd=ROOT,
        )
        assert linked.read_bytes() == rom, "isolated RGBDS overlay does not reproduce retail ROM"

    print(
        "Unit List tail mnemonic verification: OK "
        f"({EXPECTED_INSTRUCTIONS} instructions; lookup/padding data preserved; overlay byte-exact)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
