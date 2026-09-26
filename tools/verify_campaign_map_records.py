#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
from pathlib import Path

BANK_SIZE = 0x4000
SOURCES = (
    'data/maps/map_records_campaign_bank2d.asm',
    'data/maps/map_records_campaign_bank2e.asm',
    'data/maps/map_records_campaign_bank2f.asm',
)
SECTION_RE = re.compile(r'^section "Map Record - Campaign (\d+)", romx\[\$([0-9a-fA-F]{4})\], bank\[\$([0-9a-fA-F]{2})\]$')
HEADER_RE = re.compile(r'^\s*map_record_header \.body, (?:\.end|MapRecord_Campaign[0-9]{2}_End), \$([0-9a-fA-F]{2})$')
DB_RE = re.compile(r'^\s*db\s+(.+?)(?:\s*;.*)?$')
MAP_PARAMETERS_RE = re.compile(r'^\s*map_record_parameters\s+(.+?)(?:\s*;.*)?$')
ASSERT_RE = re.compile(r'^\s*assert @ == \$([0-9a-fA-F]{4})$')
INITIAL_UNIT_RE = re.compile(r'^\s*map_initial_unit\s+\$([0-9a-fA-F]{2}),\s*\$([0-9a-fA-F]{2}),\s*(UNIT_TYPE_[A-Z0-9_]+),\s*UNIT_SIDE_([01])(?:\s*;.*)?$')


def file_offset(bank: int, address: int) -> int:
    return bank * BANK_SIZE + (address - 0x4000)


def load_unit_ids(root: Path) -> dict[str, int]:
    text = (root / 'constants/unit_constants.inc').read_text(encoding='utf-8')
    return {name: int(value) for name, value in re.findall(
        r'^DEF\s+(UNIT_TYPE_[A-Z0-9_]+)\s+EQU\s+(\d+)\s*$', text, re.M
    )}

def parse_initial_unit(line: str, unit_ids: dict[str, int]) -> bytes | None:
    m = INITIAL_UNIT_RE.match(line)
    if not m:
        return None
    x, y, unit_name, side = m.groups()
    if unit_name not in unit_ids:
        raise SystemExit(f'unknown initial-unit constant {unit_name}')
    encoded = (unit_ids[unit_name] << 1) | int(side)
    return bytes((int(x, 16), int(y, 16), encoded))


def parse_db(expr: str) -> bytes:
    out = bytearray()
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


def parse_sources(root: Path):
    unit_ids = load_unit_ids(root)
    records = {}
    for source in SOURCES:
        lines = (root / source).read_text(encoding='utf-8').splitlines()
        i = 0
        while i < len(lines):
            sm = SECTION_RE.match(lines[i])
            if not sm:
                i += 1
                continue
            index = int(sm.group(1))
            address = int(sm.group(2), 16)
            bank = int(sm.group(3), 16)
            header_field = None
            body = bytearray()
            in_body = False
            end_assert = None
            i += 1
            while i < len(lines) and not SECTION_RE.match(lines[i]):
                hm = HEADER_RE.match(lines[i])
                if hm:
                    header_field = int(hm.group(1), 16)
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
                    else:
                        initial = parse_initial_unit(lines[i], unit_ids)
                        if initial is not None:
                            body.extend(initial)
                am = ASSERT_RE.match(lines[i])
                if am:
                    end_assert = int(am.group(1), 16)
                i += 1
            if header_field is None or end_assert is None:
                raise SystemExit(f'Campaign {index:02d}: missing header/assert metadata')
            header = bytes((0x20, 0x00)) + len(body).to_bytes(2, 'little') + bytes((header_field,)) + bytes(27)
            if index in records:
                raise SystemExit(f'Campaign {index:02d}: duplicate source record')
            records[index] = (bank, address, header + bytes(body), end_assert)
    return records


def main() -> int:
    ap = argparse.ArgumentParser(description='Verify source-backed GBWars3 Campaign map records')
    ap.add_argument('rom', nargs='?', default='baserom.gbc')
    ap.add_argument('--root', default='.')
    args = ap.parse_args()
    root = Path(args.root)
    rom = Path(args.rom).read_bytes()
    records = parse_sources(root)
    if sorted(records) != list(range(45)):
        raise SystemExit(f'Campaign record inventory mismatch: {sorted(records)}')

    table_off = file_offset(0x28, 0x42C3)
    total = 0
    setup_total = 0
    bank_stats: dict[int, list[int]] = {}
    dimensions = set()

    for index in range(45):
        bank, address, emitted, end_assert = records[index]
        p = table_off + index * 3
        ptr_bank = rom[p]
        ptr_address = int.from_bytes(rom[p+1:p+3], 'little')
        if (bank, address) != (ptr_bank, ptr_address):
            raise SystemExit(
                f'Campaign {index:02d}: source starts ${bank:02X}:${address:04X}, '
                f'pointer table targets ${ptr_bank:02X}:${ptr_address:04X}'
            )

        ro = file_offset(bank, address)
        body_len = int.from_bytes(rom[ro+2:ro+4], 'little')
        retail = rom[ro:ro + 0x20 + body_len]
        if emitted != retail:
            lim = min(len(emitted), len(retail))
            for pos in range(lim):
                if emitted[pos] != retail[pos]:
                    raise SystemExit(
                        f'Campaign {index:02d} ${bank:02X}:${address:04X}: '
                        f'mismatch at +${pos:04X}: source=${emitted[pos]:02X}, retail=${retail[pos]:02X}'
                    )
            raise SystemExit(f'Campaign {index:02d}: size mismatch source={len(emitted)} retail={len(retail)}')
        if end_assert != address + len(emitted):
            raise SystemExit(
                f'Campaign {index:02d}: end assert ${end_assert:04X} '
                f'!= computed ${address + len(emitted):04X}'
            )

        body = emitted[0x20:]
        width, height = body[12], body[13]
        dimensions.add((width, height))
        extra = len(body) - (8 + 4 + 2 + width * height + 1)
        if extra < 0 or extra % 3 or body[-1] != 0xFF:
            raise SystemExit(f'Campaign {index:02d}: invalid setup/terminator framing')
        setup_count = extra // 3
        setup_total += setup_count
        total += len(emitted)
        stat = bank_stats.setdefault(bank, [0, 0, 0])
        stat[0] += 1
        stat[1] += len(emitted)
        stat[2] += setup_count

    ptr = (root / 'data/maps/map_pointer_tables.asm').read_text(encoding='utf-8')
    for index in range(45):
        label = f'MapRecord_Campaign{index:02d}'
        if f'map_record_pointer bank({label}), {label}' not in ptr:
            raise SystemExit(f'Campaign {index:02d}: pointer table is not symbolic')

    print('campaign records: 45/45 source-backed and byte-verified [ok]')
    print(f'campaign bytes  : {total} controlled bytes [ok]')
    print(f'initial-unit records   : {setup_total} symbolic 3-byte records preserved [ok]')
    for bank in sorted(bank_stats):
        count, byte_count, setups = bank_stats[bank]
        print(f'bank ${bank:02X}        : {count:2d} records, {byte_count:5d} bytes, {setups:3d} initial-unit records [ok]')
    print('dimensions      : ' + ', '.join(f'{w}x{h}' for w, h in sorted(dimensions)) + ' [ok]')
    print('name fields     : 45/45 retail 8-byte fields preserved exactly [ok]')
    print('pointer targets : 45/45 symbolic MapRecord_CampaignXX labels [ok]')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
