#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
from pathlib import Path

BANK_SIZE = 0x4000
CUSTOM_NAMES = {
    0: b"BALL ISL",
    2: b"TROPICS ",
    6: b"SEA MAZE",
}
CUSTOM_NAME_SIDECARS = {
    0: ord("E"),  # BALL ISLE
}
FILES = (
    "data/maps/map_records_standard_bank29.asm",
    "data/maps/map_records_standard_bank2a.asm",
    "data/maps/map_records_standard_bank2b.asm",
    "data/maps/map_records_standard_bank2c.asm",
)
SECTION_RE = re.compile(
    r'^section "Map Record - Standard (\d{2})", romx\[\$([0-9a-fA-F]{4})\], bank\[\$([0-9a-fA-F]{2})\]$'
)
HEADER_RE = re.compile(r'^\s*map_record_header \.body, (?:\.end|MapRecord_Standard[0-9]{2}_End), \$([0-9a-fA-F]{2})(?:, \"(.)\")?$')
DB_RE = re.compile(r'^\s*db\s+(.+?)(?:\s*;.*)?$')
MAP_PARAMETERS_RE = re.compile(r'^\s*map_record_parameters\s+(.+?)(?:\s*;.*)?$')
ASSERT_RE = re.compile(r'^\s*assert @ == \$([0-9a-fA-F]{4})$')


def file_offset(bank: int, address: int) -> int:
    return bank * BANK_SIZE + (address - 0x4000)


def parse_db(expr: str) -> bytes:
    out = bytearray()
    # All Standard-map strings introduced by the English project use the
    # ASCII-compatible A-Z/space portion of char_main.inc.
    parts = re.findall(r'"(?:[^"\\]|\\.)*"|[^,]+', expr)
    for raw in parts:
        token = raw.strip()
        if not token:
            continue
        if token.startswith('"') and token.endswith('"'):
            text = bytes(token[1:-1], 'utf-8').decode('unicode_escape')
            out.extend(text.encode('ascii'))
        elif token.startswith('$'):
            out.append(int(token[1:], 16) & 0xFF)
        else:
            out.append(int(token, 10) & 0xFF)
    return bytes(out)


def parse_sources(root: Path) -> dict[int, tuple[int, int, bytes, int]]:
    records: dict[int, tuple[int, int, bytes, int]] = {}
    for rel in FILES:
        lines = (root / rel).read_text(encoding='utf-8').splitlines()
        i = 0
        while i < len(lines):
            m = SECTION_RE.match(lines[i])
            if not m:
                i += 1
                continue
            index = int(m.group(1))
            address = int(m.group(2), 16)
            bank = int(m.group(3), 16)
            header_field = None
            header_sidecar = 0
            body = bytearray()
            in_body = False
            end_assert = None
            i += 1
            while i < len(lines) and not SECTION_RE.match(lines[i]):
                hm = HEADER_RE.match(lines[i])
                if hm:
                    header_field = int(hm.group(1), 16)
                    if hm.group(2):
                        header_sidecar = ord(hm.group(2))
                if lines[i].strip() == '.body:':
                    in_body = True
                    i += 1
                    continue
                if lines[i].strip() == '.end:' or re.match(r'^MapRecord_[A-Za-z0-9_]+_End::$', lines[i].strip()):
                    in_body = False
                if in_body:
                    dm = DB_RE.match(lines[i])
                    pm = MAP_PARAMETERS_RE.match(lines[i])
                    if dm:
                        body.extend(parse_db(dm.group(1)))
                    elif pm:
                        body.extend(parse_db(pm.group(1)))
                am = ASSERT_RE.match(lines[i])
                if am:
                    end_assert = int(am.group(1), 16)
                i += 1
            if header_field is None or end_assert is None:
                raise SystemExit(f"Standard {index:02d}: missing header/assert metadata")
            header = (bytes((0x20, 0x00)) + len(body).to_bytes(2, 'little') +
                      bytes((header_field,)) + bytes(26) + bytes((header_sidecar,)))
            records[index] = (bank, address, header + bytes(body), end_assert)
    return records


def main() -> int:
    parser = argparse.ArgumentParser(description='Verify source-backed GBWars3 Standard map records')
    parser.add_argument('rom', nargs='?', default='baserom.gbc')
    parser.add_argument('--root', default='.')
    args = parser.parse_args()

    root = Path(args.root)
    rom = Path(args.rom).read_bytes()
    records = parse_sources(root)
    if sorted(records) != list(range(60)):
        missing = sorted(set(range(60)) - set(records))
        extra = sorted(set(records) - set(range(60)))
        raise SystemExit(f"Standard record inventory mismatch; missing={missing}, extra={extra}")

    total = 0
    changed_name_bytes = 0
    for index in range(60):
        bank, address, emitted, end_assert = records[index]
        ro = file_offset(bank, address)
        retail_header = rom[ro:ro + 0x20]
        retail_body_len = int.from_bytes(retail_header[2:4], 'little')
        retail = bytearray(rom[ro:ro + 0x20 + retail_body_len])
        if index in CUSTOM_NAMES:
            retail[0x20:0x28] = CUSTOM_NAMES[index]
            changed_name_bytes += 8
        if index in CUSTOM_NAME_SIDECARS:
            retail[0x1f] = CUSTOM_NAME_SIDECARS[index]
        if emitted != retail:
            for pos, (a, b) in enumerate(zip(emitted, retail)):
                if a != b:
                    raise SystemExit(
                        f"Standard {index:02d} ${bank:02X}:${address:04X}: mismatch at +${pos:04X}: source=${a:02X}, expected=${b:02X}"
                    )
            raise SystemExit(f"Standard {index:02d}: size mismatch source={len(emitted)} expected={len(retail)}")
        if end_assert != address + len(emitted):
            raise SystemExit(
                f"Standard {index:02d}: end assert ${end_assert:04X} != computed ${address + len(emitted):04X}"
            )
        body = emitted[0x20:]
        width, height = body[12], body[13]
        if len(body) != 8 + 4 + 2 + width * height + 1 or body[-1] != 0xFF:
            raise SystemExit(f"Standard {index:02d}: unexpected body framing")
        total += len(emitted)

    pointer_text = (root / 'data/maps/map_pointer_tables.asm').read_text(encoding='utf-8')
    for index in range(60):
        label = f'MapRecord_Standard{index:02d}'
        if f'map_record_pointer bank({label}), {label}' not in pointer_text:
            raise SystemExit(f"Standard {index:02d}: pointer table is not symbolic")

    print('standard records: 60/60 source-backed and byte-verified [ok]')
    print(f'standard bytes  : {total} controlled bytes [ok]')
    print('setup tails     : 0 across all Standard records [ok]')
    print(f'English names   : {len(CUSTOM_NAMES)} overrides / {changed_name_bytes} base-name bytes [ok]')
    print('9-char sidecar  : Standard 00 = BALL ISLE via header+$1F [ok]')
    print('pointer targets : 60/60 symbolic MapRecord_StandardXX labels [ok]')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
