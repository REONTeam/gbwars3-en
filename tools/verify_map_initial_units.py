#!/usr/bin/env python3
from pathlib import Path
import sys

if len(sys.argv) != 2:
    raise SystemExit('usage: verify_map_initial_units.py baserom.gbc')
rom = Path(sys.argv[1]).read_bytes()
if len(rom) < 0x100000:
    raise SystemExit('baserom too small')

def fileoff(bank, addr):
    if bank == 0:
        return addr
    return bank * 0x4000 + (addr - 0x4000)

families = [
    ('standard', 0x41dc, 60),
    ('demo',     0x4290, 1),
    ('beginner', 0x4293, 16),
    ('campaign', 0x42c3, 45),
]
ptr_bank = 0x28
units = []
family_counts = {}
for family, table_addr, count in families:
    table = fileoff(ptr_bank, table_addr)
    n = 0
    for i in range(count):
        p = table + i * 3
        bank = rom[p]
        addr = rom[p + 1] | (rom[p + 2] << 8)
        rec = fileoff(bank, addr)
        body_len = rom[rec + 2] | (rom[rec + 3] << 8)
        width = rom[rec + 44]
        height = rom[rec + 45]
        pos = rec + 46 + width * height
        end = rec + 32 + body_len
        while pos < end - 1:
            x, y, encoded = rom[pos:pos + 3]
            if not (x < width and y < height):
                raise SystemExit(f'{family}[{i}] placement coordinate out of bounds: {x},{y} for {width}x{height}')
            unit_type = encoded >> 1
            side = encoded & 1
            if unit_type >= 53: # UnitData has entries 0..52.
                raise SystemExit(f'{family}[{i}] invalid encoded unit ${encoded:02x}')
            units.append((family, i, x, y, encoded, unit_type, side))
            n += 1
            pos += 3
        if pos != end - 1 or rom[pos] != 0xff:
            raise SystemExit(f'{family}[{i}] initial-unit stream does not end at record terminator')
    family_counts[family] = n

expected = {'standard': 0, 'demo': 17, 'beginner': 55, 'campaign': 941}
if family_counts != expected:
    raise SystemExit(f'placement counts differ: {family_counts!r}')
if len(units) != 1013:
    raise SystemExit(f'expected 1013 placements, got {len(units)}')

side0 = sum(u[6] == 0 for u in units)
side1 = sum(u[6] == 1 for u in units)
print('map initial-unit placements: [ok]')
print(f'  total: 1013 (side 0: {side0}, side 1: {side1})')
print('  every X/Y lies inside its record width/height')
print('  every encoded unit decodes to UnitData index 0..52')
