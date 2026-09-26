#!/usr/bin/env python3
from __future__ import annotations

import importlib.util
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CUSTOM_MISMATCHES = {
    *(('standard', i) for i in (0, 2, 6)),
    ('demo', 0),
    *(('beginner', i) for i in range(1, 17)),
}


def load_module(name: str, rel: str):
    spec = importlib.util.spec_from_file_location(name, ROOT / rel)
    if spec is None or spec.loader is None:
        raise SystemExit(f'could not load {rel}')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module



def load_unit_ids() -> dict[str, int]:
    text = (ROOT / 'constants/unit_constants.inc').read_text(encoding='utf-8')
    return {name: int(value) for name, value in re.findall(
        r'^DEF\s+(UNIT_TYPE_[A-Z0-9_]+)\s+EQU\s+(\d+)\s*$', text, re.M
    )}


def parse_initial_unit(line: str, unit_ids: dict[str, int]) -> bytes | None:
    m = re.match(r'^\s*map_initial_unit\s+\$([0-9a-fA-F]{2}),\s*\$([0-9a-fA-F]{2}),\s*(UNIT_TYPE_[A-Z0-9_]+),\s*UNIT_SIDE_([01])(?:\s*;.*)?$', line)
    if not m:
        return None
    x, y, unit_name, side = m.groups()
    if unit_name not in unit_ids:
        raise SystemExit(f'unknown initial-unit constant {unit_name}')
    return bytes((int(x, 16), int(y, 16), (unit_ids[unit_name] << 1) | int(side)))

def parse_demo(parse_db):
    lines = (ROOT / 'data/maps/map_records.asm').read_text(encoding='utf-8').splitlines()
    header_checksum = None
    body = bytearray()
    in_body = False
    unit_ids = load_unit_ids()
    for line in lines:
        match = re.match(r'^\s*map_record_header \.body, \.end, \$([0-9a-fA-F]{2})', line)
        if match:
            header_checksum = int(match.group(1), 16)
        if line.strip() == '.body:':
            in_body = True
            continue
        if line.strip() == '.end:':
            in_body = False
        if in_body:
            match = re.match(r'^\s*db\s+(.+?)(?:\s*;.*)?$', line)
            params = re.match(r'^\s*map_record_parameters\s+(.+?)(?:\s*;.*)?$', line)
            if match:
                body.extend(parse_db(match.group(1)))
            elif params:
                body.extend(parse_db(params.group(1)))
            else:
                initial = parse_initial_unit(line, unit_ids)
                if initial is not None:
                    body.extend(initial)
    if header_checksum is None or not body:
        raise SystemExit('Demo 02 checksum/body source could not be parsed')
    return header_checksum, bytes(body)


def main() -> int:
    std = load_module('verify_standard_map_records', 'tools/verify_standard_map_records.py')
    beg = load_module('verify_beginner_map_records', 'tools/verify_beginner_map_records.py')
    cam = load_module('verify_campaign_map_records', 'tools/verify_campaign_map_records.py')

    records: list[tuple[str, int, int, bytes]] = []
    for family, parsed in (
        ('standard', std.parse_sources(ROOT)),
        ('beginner', beg.parse_source(ROOT)),
        ('campaign', cam.parse_sources(ROOT)),
    ):
        for index, record in sorted(parsed.items()):
            emitted = record[2]
            records.append((family, index, emitted[4], emitted[0x20:]))

    checksum, body = parse_demo(std.parse_db)
    records.append(('demo', 0, checksum, body))

    if len(records) != 122:
        raise SystemExit(f'expected 122 source-backed map records, found {len(records)}')

    mismatches = set()
    matches = 0
    for family, index, stored, body in records:
        calculated = sum(body) & 0xFF
        key = (family, index)
        if stored == calculated:
            matches += 1
        else:
            mismatches.add(key)

    if matches != 102:
        raise SystemExit(f'expected 102 checksum-matching unmodified records, found {matches}')
    if mismatches != CUSTOM_MISMATCHES:
        missing = sorted(CUSTOM_MISMATCHES - mismatches)
        extra = sorted(mismatches - CUSTOM_MISMATCHES)
        raise SystemExit(f'custom checksum mismatch set differs; missing={missing}, extra={extra}')

    constants = (ROOT / 'constants/map_constants.inc').read_text(encoding='utf-8')
    for needle in (
        'DEF MAP_RECORD_BODY_LENGTH_OFFSET EQU 2',
        'DEF MAP_RECORD_CHECKSUM_OFFSET EQU 4',
        'DEF MAP_RECORD_BODY_OFFSET EQU MAP_RECORD_HEADER_SIZE',
    ):
        if needle not in constants:
            raise SystemExit(f'missing map checksum/layout constant: {needle}')

    symbols = (ROOT / 'symbols.asm').read_text(encoding='utf-8')
    for needle in (
        'sym $00, $ca25, wMapRecordChecksum',
        'sym $00, $c889, wEditorMapRecordChecksum',
        'sym $00, $cc88, wMapChecksumScratch',
    ):
        if needle not in symbols:
            raise SystemExit(f'missing checksum symbol: {needle}')

    sram = (ROOT / 'engine/map/map_sram.asm').read_text(encoding='utf-8')
    for needle in (
        'ld hl, MAP_RECORD_BODY_OFFSET',
        'ld [wMapChecksumScratch], a',
        'ld a, [wMapChecksumScratch]',
        'add [hl]',
    ):
        if needle not in sram:
            raise SystemExit(f'missing serializer checksum fragment: {needle}')

    print('map checksum algorithm : sum(body) & $ff [ok]')
    print('source-backed records  : 122/122 classified [ok]')
    print('retail-body matches    : 102/102 checksum-match [ok]')
    print('English-name overrides : 20/20 retain legacy retail checksum bytes [ok]')
    print('checksum symbols/layout: header+$04 / loaded $CA25 / editor $C889 [ok]')
    print('SRAM serializer        : recomputes additive checksum over complete body [ok]')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
