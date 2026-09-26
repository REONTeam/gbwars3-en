#!/usr/bin/env python3
"""Verify the mnemonic Unit List post-promotion runtime against retail."""
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
SOURCE = ROOT / "engine/unit/unit_list_post_promotion_runtime_734d.asm"
START = 0x734D
END = 0x7A74
BANK = 0x18
EXPECTED_SHA1 = "5fb312e0f6c7cd0b61d883012bf54084a9a74d4a"
EXPECTED_INSTRUCTIONS = 815

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
    offset = BANK * 0x4000 + (START - 0x4000)
    retail = rom[offset : offset + (END - START)]
    assert len(retail) == 0x727
    assert hashlib.sha1(retail).hexdigest() == EXPECTED_SHA1

    src = SOURCE.read_text(encoding="utf-8")
    assert 'section "Unit List Post Promotion Runtime", romx[$734d], bank[$18]' in src
    assert 'assert @ == $7a74' in src.lower()
    assert re.search(r"^UnitList_PostPromotionEntry::", src, re.MULTILINE)
    assert re.search(r"^UnitList_Runtime_78FE::", src, re.MULTILINE)
    assert re.search(r"^UnitList_Runtime_79E7::", src, re.MULTILINE)
    assert not re.search(r"^\s*db\b", src, re.MULTILINE | re.IGNORECASE), "runtime still contains raw db"
    instruction_count = sum(bool(OP_RE.match(line)) for line in src.splitlines())
    assert instruction_count == EXPECTED_INSTRUCTIONS, instruction_count

    # Assemble/link this one fixed section against explicit addresses of its
    # already-source-backed external dependencies. The overlay must reproduce
    # the complete retail ROM byte-for-byte.
    externals = {
        "UnitList_RunDeleteAction": 0x6EED,
        "Joypad_Update": 0x05A2,
        "Sprite_Update": 0x3056,
        "Audio_PlaySFX": 0x3844,
        "hJoyRepeat": 0xFF92,
        "UnitList_RunSelectedRecordAction": 0x7153,
        "SpriteObject_Destroy": 0x2E1F,
        "UnitList_GetSelectionDisplayValue": 0x6C72,
        "UnitList_RedrawSelectionScreen": 0x6FC3,
        "hVRAMBank": 0xFF83,
        "CoordTextPut": 0x336E,
        "SpriteObject_ClearStruct": 0x2DE8,
        "Versus_DrawSetupFooter": 0x6C4C,
        "hWRAMBank": 0xFF82,
        "Bitfield_Test": 0x3AC7,
        "Versus_DrawSelectedUnitName": 0x6C1E,
        "Versus_DrawSetupUnitEntries": 0x6A84,
    }

    rgbasm = tool("rgbasm")
    rgblink = tool("rgblink")
    with tempfile.TemporaryDirectory(prefix="gbwars3-unit-list-postpromo-") as td:
        temp = Path(td)
        stubs_asm = temp / "stubs.asm"
        stubs_o = temp / "stubs.o"
        runtime_o = temp / "runtime.o"
        linked = temp / "linked.gbc"
        stubs_text = "\n".join(
            f"DEF {name} EQU ${addr:04x}\nEXPORT {name}"
            for name, addr in externals.items()
        ) + "\n"
        stubs_text += (
            'SECTION "Stub Window Animated", ROMX[$6901], BANK[$10]\n'
            'UIWindowStack_PushAndDrawAnimated::\n'
            'SECTION "Stub Window Pop", ROMX[$6908], BANK[$10]\n'
            'UIWindowStack_PopRestore::\n'
            'SECTION "Stub UnitList Filtered Ptr", ROMX[$7346], BANK[$17]\n'
            'UnitList_GetFilteredRecordPointer::\n'
            'SECTION "Stub UnitList Staging Ptr", ROMX[$7352], BANK[$17]\n'
            'UnitList_GetStagingRecordPointer::\n'
            'SECTION "Stub UnitList Scroll Arrows", ROMX[$73a3], BANK[$17]\n'
            'UnitList_UpdateScrollArrowVisibility::\n'
        )
        stubs_text += (
            'SECTION "Stub Sprite Exit Right", ROMX[$5cd0], BANK[$15]\n'
            'SpriteTransition_SlideRightOffscreen::\n'
        )
        stubs_asm.write_text(stubs_text, encoding="ascii")
        subprocess.run([str(rgbasm), "-o", str(stubs_o), str(stubs_asm)], check=True)
        subprocess.run(
            [str(rgbasm), "-p", "0xff", "-E", "-o", str(runtime_o), str(SOURCE)],
            check=True,
            cwd=ROOT,
        )
        subprocess.run(
            [str(rgblink), "-O", str(ROM), "-o", str(linked), str(runtime_o), str(stubs_o)],
            check=True,
            cwd=ROOT,
        )
        rebuilt = linked.read_bytes()
        assert rebuilt == rom, "isolated RGBDS overlay does not reproduce retail ROM"

    print(
        "Unit List post-promotion mnemonic verification: OK "
        f"({EXPECTED_INSTRUCTIONS} instructions, {len(retail)} bytes, SHA-1 {EXPECTED_SHA1})"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
