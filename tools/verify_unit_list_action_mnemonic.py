#!/usr/bin/env python3
"""Verify the mnemonic Bank $18 Unit List action/promotion runtime against retail."""
from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "engine/unit/unit_list_action_runtime_70d9.asm"
BANK = 0x18
START = 0x70D9
END = 0x7343
EXPECTED_SHA1 = "e3645ff20011c083a3d016a2d2150d1e726459db"

R = ["b", "c", "d", "e", "h", "l", "[hl]", "a"]
RP = ["bc", "de", "hl", "sp"]
ALU = ["add a,", "adc a,", "sub", "sbc a,", "and", "xor", "or", "cp"]
ROT = ["rlc", "rrc", "rl", "rr", "sla", "sra", "swap", "srl"]

KNOWN = {
    0x04D2: "DelayFrame",
    0x058D: "SwitchSRAMBank",
    0x0593: "SRAM_Enable",
    0x059B: "SRAM_Disable",
    0x05A2: "Joypad_Update",
    0x0ED4: "Vram_TilemapCoord",
    0x2E1F: "SpriteObject_Destroy",
    0x3056: "Sprite_Update",
    0x3843: "Audio_StopSFX",
    0x3844: "Audio_PlaySFX",
    0x6794: "Versus_SetupRuntime_6794",
    0x68D8: "Versus_GetSetupSelectionRelativeIndex",
    0x6C1E: "Versus_DrawSelectedUnitName",
    0x6C39: "Versus_DrawSetupText_6C39",
    0x6C4C: "Versus_DrawSetupFooter",
    0x6C72: "UnitList_GetSelectionDisplayValue",
    0x6C84: "UnitList_GetSelectedRecordField04",
    0x6FC3: "UnitList_RedrawSelectionScreen",
    0x7030: "UnitList_RunDeleteConfirmation",
    0x70D9: "UnitList_RenderSelectedRecordField04",
    0x70EE: "UnitList_RenderSelectedRecordStatusField",
    0x7116: "UnitList_RenderActionState",
    0x7153: "UnitList_RunSelectedRecordAction",
    0x7238: "UnitList_RunPromotionPresentation",
    0x7446: "UnitList_Runtime_7446",
    0x7470: "UnitList_Runtime_7470",
    0x766C: "UnitGraphic_LoadFromRecordIndex",
    0x7675: "UnitGraphic_LoadTiles",
    0x76C9: "UnitGraphic_DrawMetatile",
}


def s8(value: int) -> int:
    return value - 256 if value >= 128 else value


def h8(value: int) -> str:
    return f"${value:02x}"


def h16(value: int) -> str:
    return f"${value:04x}"


def normalize(text: str) -> str:
    aliases = {
        "farcall SpriteTransition_SlideRightOffscreen": "farcall $15, $5cd0",
        "farcall UIWindowStack_PushAndDrawAnimated": "farcall $10, $6901",
        "farcall UIWindowStack_PushAndDraw": "farcall $10, $68fa",
        "farcall UIWindowStack_PopRestore": "farcall $10, $6908",
        "farcall UnitList_GetFilteredRecordPointer": "farcall $17, $7346",
        "farcall UnitList_GetStagingRecordPointer": "farcall $17, $7352",
        "farcall UnitList_UpdateScrollArrowVisibility": "farcall $17, $73a3",
        "hVRAMBank": "$83",
        "rVBK": "$4f",
        "hJoyRepeat": "$92",
        "UnitList_Promoted": "$7343",
    }
    for name, value in aliases.items():
        text = text.replace(name, value)
    text = re.sub(r"UnitList_Local_([0-9a-fA-F]{4})", lambda m: f".loc_{m.group(1).lower()}", text)
    text = re.sub(r"\s+", " ", text.strip())
    return text.lower()


def source_instructions() -> list[str]:
    text = SOURCE.read_text(encoding="utf-8")
    if re.search(r"(?mi)^\s*db\b", text):
        raise SystemExit("[fail] raw db remains in Unit List action runtime")
    if 'romx[$70d9], bank[$18]' not in text.lower():
        raise SystemExit("[fail] fixed Bank $18/$70D9 section placement missing")
    if 'assert @ == $7343' not in text.lower():
        raise SystemExit("[fail] $7343 exclusive-end assertion missing")

    result: list[str] = []
    for raw in text.splitlines():
        line = raw.split(";", 1)[0].strip()
        if not line or line.startswith(("include ", "section ", "assert ")):
            continue
        if line.endswith(":"):
            continue
        result.append(normalize(line))
    return result


def decode_range(chunk: bytes) -> list[str]:
    known = dict(KNOWN)

    def target(value: int) -> str:
        return known.get(value, h16(value))

    def decode_one(i: int, addr: int) -> tuple[int, str]:
        op = chunk[i]
        def word() -> int:
            return chunk[i + 1] | (chunk[i + 2] << 8)
        def imm() -> int:
            return chunk[i + 1]

        # GBWars3's project macro encodes farcall as RST $28 followed by bank/address.
        if op == 0xEF and i + 3 < len(chunk):
            bank = chunk[i + 1]
            dest = chunk[i + 2] | (chunk[i + 3] << 8)
            return 4, f"farcall ${bank:02x}, {target(dest)}"
        if op == 0xCB:
            cb = chunk[i + 1]
            x, y, z = cb >> 6, (cb >> 3) & 7, cb & 7
            if x == 0:
                text = f"{ROT[y]} {R[z]}"
            elif x == 1:
                text = f"bit {y}, {R[z]}"
            elif x == 2:
                text = f"res {y}, {R[z]}"
            else:
                text = f"set {y}, {R[z]}"
            return 2, text

        table = {
            0x00:(1,"nop"),0x01:(3,lambda:f"ld bc, {h16(word())}"),0x02:(1,"ld [bc], a"),0x03:(1,"inc bc"),0x04:(1,"inc b"),0x05:(1,"dec b"),0x06:(2,lambda:f"ld b, {h8(imm())}"),0x07:(1,"rlca"),
            0x08:(3,lambda:f"ld [{h16(word())}], sp"),0x09:(1,"add hl, bc"),0x0A:(1,"ld a, [bc]"),0x0B:(1,"dec bc"),0x0C:(1,"inc c"),0x0D:(1,"dec c"),0x0E:(2,lambda:f"ld c, {h8(imm())}"),0x0F:(1,"rrca"),
            0x10:(2,"stop"),0x11:(3,lambda:f"ld de, {h16(word())}"),0x12:(1,"ld [de], a"),0x13:(1,"inc de"),0x14:(1,"inc d"),0x15:(1,"dec d"),0x16:(2,lambda:f"ld d, {h8(imm())}"),0x17:(1,"rla"),
            0x18:(2,lambda:f"jr {target((addr+2+s8(imm()))&0xffff)}"),0x19:(1,"add hl, de"),0x1A:(1,"ld a, [de]"),0x1B:(1,"dec de"),0x1C:(1,"inc e"),0x1D:(1,"dec e"),0x1E:(2,lambda:f"ld e, {h8(imm())}"),0x1F:(1,"rra"),
            0x20:(2,lambda:f"jr nz, {target((addr+2+s8(imm()))&0xffff)}"),0x21:(3,lambda:f"ld hl, {h16(word())}"),0x22:(1,"ld [hli], a"),0x23:(1,"inc hl"),0x24:(1,"inc h"),0x25:(1,"dec h"),0x26:(2,lambda:f"ld h, {h8(imm())}"),0x27:(1,"daa"),
            0x28:(2,lambda:f"jr z, {target((addr+2+s8(imm()))&0xffff)}"),0x29:(1,"add hl, hl"),0x2A:(1,"ld a, [hli]"),0x2B:(1,"dec hl"),0x2C:(1,"inc l"),0x2D:(1,"dec l"),0x2E:(2,lambda:f"ld l, {h8(imm())}"),0x2F:(1,"cpl"),
            0x30:(2,lambda:f"jr nc, {target((addr+2+s8(imm()))&0xffff)}"),0x31:(3,lambda:f"ld sp, {h16(word())}"),0x32:(1,"ld [hld], a"),0x33:(1,"inc sp"),0x34:(1,"inc [hl]"),0x35:(1,"dec [hl]"),0x36:(2,lambda:f"ld [hl], {h8(imm())}"),0x37:(1,"scf"),
            0x38:(2,lambda:f"jr c, {target((addr+2+s8(imm()))&0xffff)}"),0x39:(1,"add hl, sp"),0x3A:(1,"ld a, [hld]"),0x3B:(1,"dec sp"),0x3C:(1,"inc a"),0x3D:(1,"dec a"),0x3E:(2,lambda:f"ld a, {h8(imm())}"),0x3F:(1,"ccf"),
        }
        if op in table:
            size, value = table[op]
            return size, value() if callable(value) else value
        if 0x40 <= op <= 0x7F:
            if op == 0x76:
                return 1, "halt"
            return 1, f"ld {R[(op>>3)&7]}, {R[op&7]}"
        if 0x80 <= op <= 0xBF:
            return 1, f"{ALU[(op>>3)&7]} {R[op&7]}"

        table = {
            0xC0:(1,"ret nz"),0xC1:(1,"pop bc"),0xC2:(3,lambda:f"jp nz, {target(word())}"),0xC3:(3,lambda:f"jp {target(word())}"),0xC4:(3,lambda:f"call nz, {target(word())}"),0xC5:(1,"push bc"),0xC6:(2,lambda:f"add a, {h8(imm())}"),0xC7:(1,"rst $00"),
            0xC8:(1,"ret z"),0xC9:(1,"ret"),0xCA:(3,lambda:f"jp z, {target(word())}"),0xCC:(3,lambda:f"call z, {target(word())}"),0xCD:(3,lambda:f"call {target(word())}"),0xCE:(2,lambda:f"adc a, {h8(imm())}"),0xCF:(1,"rst $08"),
            0xD0:(1,"ret nc"),0xD1:(1,"pop de"),0xD2:(3,lambda:f"jp nc, {target(word())}"),0xD4:(3,lambda:f"call nc, {target(word())}"),0xD5:(1,"push de"),0xD6:(2,lambda:f"sub {h8(imm())}"),0xD7:(1,"rst $10"),
            0xD8:(1,"ret c"),0xD9:(1,"reti"),0xDA:(3,lambda:f"jp c, {target(word())}"),0xDC:(3,lambda:f"call c, {target(word())}"),0xDE:(2,lambda:f"sbc a, {h8(imm())}"),0xDF:(1,"rst $18"),
            0xE0:(2,lambda:f"ldh [{h8(imm())}], a"),0xE1:(1,"pop hl"),0xE2:(1,"ldh [c], a"),0xE5:(1,"push hl"),0xE6:(2,lambda:f"and {h8(imm())}"),0xE7:(1,"rst $20"),0xE8:(2,lambda:f"add sp, {s8(imm())}"),0xE9:(1,"jp hl"),0xEA:(3,lambda:f"ld [{h16(word())}], a"),0xEE:(2,lambda:f"xor {h8(imm())}"),
            0xF0:(2,lambda:f"ldh a, [{h8(imm())}]"),0xF1:(1,"pop af"),0xF2:(1,"ldh a, [c]"),0xF3:(1,"di"),0xF5:(1,"push af"),0xF6:(2,lambda:f"or {h8(imm())}"),0xF7:(1,"rst $30"),0xF8:(2,lambda:f"ld hl, sp + {s8(imm())}"),0xF9:(1,"ld sp, hl"),0xFA:(3,lambda:f"ld a, [{h16(word())}]"),0xFB:(1,"ei"),0xFE:(2,lambda:f"cp {h8(imm())}"),0xFF:(1,"rst $38"),
        }
        if op not in table:
            raise SystemExit(f"[fail] unsupported retail opcode ${op:02X} at ${addr:04X}")
        size, value = table[op]
        return size, value() if callable(value) else value

    # First pass discovers all branch destinations that need file-local labels.
    first: list[tuple[int,int,str]] = []
    i = 0
    addr = START
    while i < len(chunk):
        size, text = decode_one(i, addr)
        first.append((addr, size, text))
        i += size
        addr += size
    for _, _, text in first:
        if text.startswith(("jr ", "jp ", "call ")):
            for match in re.finditer(r"\$([0-9a-f]{4})", text):
                dest = int(match.group(1), 16)
                if START <= dest < END and dest not in known:
                    known[dest] = f".loc_{dest:04x}"

    result: list[str] = []
    i = 0
    addr = START
    while i < len(chunk):
        size, text = decode_one(i, addr)
        result.append(normalize(text))
        i += size
        addr += size
    if addr != END:
        raise SystemExit(f"[fail] retail decoder ended at ${addr:04X}, expected ${END:04X}")
    return result


def find_rom() -> Path:
    candidates = [Path(arg) for arg in sys.argv[1:]] + [ROOT / "baserom.gbc", Path("/mnt/data/baserom.gbc")]
    for path in candidates:
        if path.is_file():
            return path
    raise SystemExit("[fail] retail ROM not found; pass baserom.gbc as an argument")


def main() -> None:
    rom_path = find_rom()
    rom = rom_path.read_bytes()
    offset = BANK * 0x4000 + (START - 0x4000)
    chunk = rom[offset:offset + (END - START)]
    if len(chunk) != END - START:
        raise SystemExit("[fail] retail ROM is too short for Bank $18 Unit List action range")
    digest = hashlib.sha1(chunk).hexdigest()
    if digest != EXPECTED_SHA1:
        raise SystemExit(f"[fail] retail range SHA-1 {digest} != {EXPECTED_SHA1}")

    expected = decode_range(chunk)
    actual = source_instructions()
    if actual != expected:
        for i, (got, want) in enumerate(zip(actual, expected)):
            if got != want:
                raise SystemExit(f"[fail] instruction {i}: source '{got}' != retail '{want}'")
        raise SystemExit(f"[fail] instruction count source={len(actual)} retail={len(expected)}")

    print(f"[ok] Bank $18:${START:04X}-${END-1:04X} retail SHA-1 {digest}")
    print(f"[ok] mnemonic source matches all {len(expected)} decoded retail instructions")
    print("[ok] no raw db executable bytes remain in the action/promotion range")
    print(f"[ok] exact source geometry: end=${END:04X}, size={END-START} bytes")

if __name__ == "__main__":
    main()
