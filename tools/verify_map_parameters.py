#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_COUNT = 122
EXPECTED_BYTES = 488
EXPECTED_SHA1 = '384c72724754e8f1dd0dd00ab9a646edd4defeb2'
FILES = sorted((ROOT / 'data' / 'maps').glob('map_records*.asm'))
PARAM_RE = re.compile(
    r'^\s*map_record_parameters\s+(.+?)(?:\s*;.*)?$', re.M
)


def parse_value(token: str) -> int:
    token = token.strip()
    if token.startswith('$'):
        return int(token[1:], 16)
    return int(token, 10)


def main() -> int:
    rows: list[tuple[int, int, int, int]] = []
    for path in FILES:
        text = path.read_text(encoding='utf-8')
        for match in PARAM_RE.finditer(text):
            values = tuple(parse_value(tok) for tok in match.group(1).split(','))
            if len(values) != 4:
                raise SystemExit(f'{path.name}: map_record_parameters does not have four values: {values}')
            if any(not 0 <= value <= 0xff for value in values):
                raise SystemExit(f'{path.name}: parameter outside byte range: {values}')
            rows.append(values)  # type: ignore[arg-type]

    if len(rows) != EXPECTED_COUNT:
        raise SystemExit(f'expected {EXPECTED_COUNT} map parameter rows, found {len(rows)}')
    payload = bytes(value for row in rows for value in row)
    if len(payload) != EXPECTED_BYTES:
        raise SystemExit(f'expected {EXPECTED_BYTES} parameter bytes, found {len(payload)}')
    sha1 = hashlib.sha1(payload).hexdigest()
    if sha1 != EXPECTED_SHA1:
        raise SystemExit(f'map parameter payload changed: {sha1} != {EXPECTED_SHA1}')

    macros = (ROOT / 'macros/macros.inc').read_text(encoding='utf-8')
    for needle in (
        'macro map_record_parameters',
        'assert _NARG == MAP_RECORD_FIELD_COUNT',
        'db \\1, \\2, \\3, \\4',
    ):
        if needle not in macros:
            raise SystemExit(f'missing map parameter macro fragment: {needle}')

    constants = (ROOT / 'constants/map_constants.inc').read_text(encoding='utf-8')
    for needle in (
        'DEF MAP_RECORD_PARAMETERS_OFFSET EQU MAP_RECORD_HEADER_SIZE + MAP_RECORD_NAME_SIZE',
        'DEF MAP_RECORD_PARAMETER_0_OFFSET EQU MAP_RECORD_PARAMETERS_OFFSET + 0',
        'DEF MAP_RECORD_PARAMETER_3_OFFSET EQU MAP_RECORD_PARAMETERS_OFFSET + 3',
    ):
        if needle not in constants:
            raise SystemExit(f'missing map parameter layout constant: {needle}')

    symbols = (ROOT / 'symbols.asm').read_text(encoding='utf-8')
    for needle in (
        'sym $00, $ca49, wMapRecordParameter0',
        'sym $00, $ca4c, wMapRecordParameter3',
        'sym $00, $c8ad, wEditorMapRecordParameter0',
        'sym $00, $c8b0, wEditorMapRecordParameter3',
    ):
        if needle not in symbols:
            raise SystemExit(f'missing positional map parameter symbol: {needle}')

    editor = (ROOT / 'engine/map/map_editor.asm').read_text(encoding='utf-8')
    for i in range(4):
        if f'ld [wEditorMapRecordParameter{i}], a' not in editor:
            raise SystemExit(f'editor parameter {i} initialization is not symbolic')

    print(f'map parameter rows      : {len(rows)}/{EXPECTED_COUNT} [ok]')
    print(f'map parameter payload   : {len(payload)} bytes, SHA-1 {sha1} [ok]')
    print('runtime positional map  : $CA49-$CA4C [ok]')
    print('editor positional map   : $C8AD-$C8B0 [ok]')
    print('semantic field names    : intentionally deferred [ok]')
    for index in range(4):
        values = Counter(row[index] for row in rows)
        print(f'parameter {index} range      : {min(values)}-{max(values)} ({len(values)} distinct)')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
