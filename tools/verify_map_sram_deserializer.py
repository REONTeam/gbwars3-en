#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
rom = Path(sys.argv[1] if len(sys.argv) > 1 else 'baserom.gbc').read_bytes()
ranges = [
    ('MapGridCoord', 0x00, 0x15f8, 0x1607, '324129553e18873f738aad834d83c8fcc64e887f'),
    ('MapData_LoadBody', 0x00, 0x1614, 0x16b6, '6e9ed9e81ebbb396754f134084ecbc8eb3f33968'),
    ('MapSRAM_DeserializeSlot', 0x13, 0x6072, 0x6165, 'eea8821efa7428d8d35f979cde1651871b7922b7'),
]
for name, bank, start, end, expected in ranges:
    offset = start if bank == 0 else bank * 0x4000 + (start - 0x4000)
    data = rom[offset:offset + end - start]
    actual = hashlib.sha1(data).hexdigest()
    assert actual == expected, (name, actual, expected)
    print(f'{name}: bank ${bank:02X}:${start:04X}-${end-1:04X} ({len(data)} bytes) SHA-1 {actual} [ok]')
print('Map SRAM deserializer/common body-loader retail ranges: [ok]')
