#!/usr/bin/env python3
"""Recover the first Campaign pre-map briefing into Bank $34.

The Bank $25 map-briefing viewer indexes its group-0 pointer table at
$25:$405A.  Entry 0 is a 16-bit ROMX address whose text payload lives in
Bank $33.  This tool copies that exact zero-terminated byte stream into
editable RGBDS source in Bank $34.

Usage:
    python3 tools/recover_campaign_intro_bank34.py path/to/GBWARS3.gbc

The known Japanese retail ROM is accepted only with --allow-japanese.  This
makes accidental replacement of custom work impossible while still allowing
byte-comparison/verifier use.  The authoritative custom build currently known
for this project has SHA-1 2fd5074878763dbd00e6514f3856a6a466b999e9.
"""
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path

JAPANESE_RETAIL_SHA1 = "61e08f96261b5f85c65c70db5464b4298f9f2cf8"
KNOWN_CUSTOM_EN_SHA1 = "2fd5074878763dbd00e6514f3856a6a466b999e9"
TABLE_BANK = 0x25
TABLE_ADDR = 0x405A
TEXT_BANK = 0x33
BANK_SIZE = 0x4000
ROMX_BASE = 0x4000
OUT = Path("data/campaign/campaign_intro_extension.asm")


def rom_offset(bank: int, addr: int) -> int:
    if not ROMX_BASE <= addr < 0x8000:
        raise ValueError(f"ROMX pointer ${addr:04X} is outside $4000-$7FFF")
    return bank * BANK_SIZE + (addr - ROMX_BASE)


def extract_intro(rom: bytes) -> tuple[int, bytes]:
    table = rom_offset(TABLE_BANK, TABLE_ADDR)
    ptr = int.from_bytes(rom[table:table + 2], "little")
    start = rom_offset(TEXT_BANK, ptr)
    end_of_bank = (TEXT_BANK + 1) * BANK_SIZE
    out = bytearray()
    for pos in range(start, min(end_of_bank, len(rom))):
        value = rom[pos]
        out.append(value)
        if value == 0:
            break
    else:
        raise ValueError("Campaign introduction has no $00 terminator before Bank $33 ends")
    if not out or out[-1] != 0:
        raise ValueError("Campaign introduction is not terminated")
    return ptr, bytes(out)


def emit_payload(stream: bytes, source_sha1: str, source_ptr: int) -> str:
    lines = [
        'include "macros/macros.inc"',
        '',
        '; Complete first Campaign pre-map briefing relocated from Bank $33.',
        f'; Source ROM SHA-1: {source_sha1}',
        f'; Original pointer-table entry: $25:$405A -> $33:${source_ptr:04X}.',
        f'; Original stream length: {len(stream)} bytes including terminator.',
        ';',
        '; This payload is deliberately byte-exact because the original English',
        '; project translated many screens by altering glyph graphics while leaving',
        '; the underlying briefing byte stream unchanged.  Keeping raw bytes here',
        '; preserves exactly what GBWARS3.gbc displayed while freeing the message',
        '; from Bank $33.  It may now be edited/expanded up to the end of Bank $34.',
        'section "Campaign Introduction Bank 34", romx[$4000], bank[$34]',
        'CampaignIntroductionBank34::',
        'CampaignIntroductionBank34Payload::',
    ]

    body = stream[:-1]
    run: list[int] = []

    def flush() -> None:
        nonlocal run
        while run:
            chunk, run = run[:16], run[16:]
            lines.append('    db ' + ', '.join(f'${v:02x}' for v in chunk))

    for value in body:
        if value == 0x01:
            flush()
            lines.append('    db $01 ; [LF]')
        else:
            run.append(value)
    flush()
    lines.append('    done')
    lines += [
        '',
        'CampaignIntroductionBank34End::',
        '    assert CampaignIntroductionBank34End <= $8000',
        '',
        '; current source/337 compatibility aliases.',
        'CampaignIntroductionExtension equ CampaignIntroductionBank34Payload',
        'CampaignIntroductionExtensionEnd equ CampaignIntroductionBank34End',
        '',
    ]
    return "\n".join(lines)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("rom", type=Path, help="built Game Boy Wars 3 .gbc ROM")
    ap.add_argument("--output", type=Path, default=OUT)
    ap.add_argument("--allow-japanese", action="store_true")
    args = ap.parse_args()

    rom = args.rom.read_bytes()
    sha1 = hashlib.sha1(rom).hexdigest()
    if sha1 == JAPANESE_RETAIL_SHA1 and not args.allow_japanese:
        raise SystemExit("refusing Japanese retail ROM without --allow-japanese")
    if len(rom) < (TEXT_BANK + 1) * BANK_SIZE:
        raise SystemExit("ROM is too small to contain Bank $33")

    ptr, stream = extract_intro(rom)
    args.output.write_text(emit_payload(stream, sha1, ptr), encoding="utf-8")
    print(f"ROM SHA-1: {sha1}")
    if sha1 == KNOWN_CUSTOM_EN_SHA1:
        print("Recognized authoritative custom-English GBWARS3.gbc")
    print(f"Recovered {len(stream)} bytes: $25:$405A -> $33:${ptr:04X}")
    print(f"Wrote full Bank $34 payload to {args.output}")


if __name__ == "__main__":
    main()
