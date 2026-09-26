#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys

if len(sys.argv) != 2:
    raise SystemExit('usage: verify_map_unit_placements.py baserom.gbc')
rom = Path(sys.argv[1]).read_bytes()

def fileoff(bank, addr):
    return addr if bank == 0 else bank * 0x4000 + (addr - 0x4000)

ranges = [
    ('WordTable_Get', 0x00, 0x3a93, 0x3a9e, '64c574f4c5578304fb1e004d2bd229a5dbaf0185'),
    ('Unit record access helpers', 0x12, 0x4020, 0x4046, '10d3335d7f60bb0d3c682b9285459eefe2181583'),
    ('Map initial-unit creator', 0x12, 0x41e3, 0x423e, '6481af3555bf3404719f005d3598e258c7639dcf'),
    ('Unit free-slot search', 0x12, 0x42f6, 0x432a, '19ff893d3b5a961cc2cbbc6e26a182d27e960015'),
]
for name, bank, start, end, expected in ranges:
    data = rom[fileoff(bank, start):fileoff(bank, end)]
    got = hashlib.sha1(data).hexdigest()
    if got != expected:
        raise SystemExit(f'{name}: SHA-1 mismatch {got} != {expected}')
    print(f'{name:29s}: {len(data):3d} bytes / SHA-1 {got} [ok]')

src = Path('engine/unit/unit_setup.asm').read_text()
for token in ['UnitData_GetDefinitionPointer::', 'UnitRecord_GetAddress::', 'UnitData_GetByte::',
              'MapUnit_CreateInitial::', 'Unit_InitRecordFromDefinition::', 'Unit_FindFreeSlotForSide::']:
    if token not in src:
        raise SystemExit(f'missing source label: {token}')
if 'farcall MapUnit_CreateInitial' not in Path('engine/home/home_map.asm').read_text():
    raise SystemExit('MapData_LoadBody does not use symbolic MapUnit_CreateInitial farcall')
if 'farcall $12, $41e3' in Path('engine/home/home_map.asm').read_text().lower():
    raise SystemExit('raw $12:$41E3 farcall remains')
if 'wUnitCountBySide' not in Path('symbols.asm').read_text():
    raise SystemExit('wUnitCountBySide symbol missing')

# Re-prove tuple semantics across every map record directly from retail data.
families = [('standard',0x41dc,60),('demo',0x4290,1),('beginner',0x4293,16),('campaign',0x42c3,45)]
count = side = [0,0]
total = 0
for family, table_addr, nrec in families:
    table = fileoff(0x28, table_addr)
    for i in range(nrec):
        p = table + i*3
        bank = rom[p]
        addr = rom[p+1] | rom[p+2] << 8
        rec = fileoff(bank, addr)
        body_len = rom[rec+2] | rom[rec+3] << 8
        w, h = rom[rec+44], rom[rec+45]
        pos = rec + 46 + w*h
        end = rec + 32 + body_len
        while pos < end - 1:
            x,y,u = rom[pos:pos+3]
            if x >= w or y >= h:
                raise SystemExit(f'{family}[{i}] out-of-bounds initial unit {x},{y} for {w}x{h}')
            if (u >> 1) >= 53:
                raise SystemExit(f'{family}[{i}] invalid UnitData index from encoded ${u:02x}')
            side[u & 1] += 1
            total += 1
            pos += 3
        if pos != end-1 or rom[pos] != 0xff:
            raise SystemExit(f'{family}[{i}] malformed initial-unit tail')
if total != 1013:
    raise SystemExit(f'expected 1013 initial units, got {total}')
print(f'initial-unit tuple semantics    : {total} placements; side0={side[0]}, side1={side[1]} [ok]')
print('map unit placement source      : symbolic consumer/access helpers [ok]')
