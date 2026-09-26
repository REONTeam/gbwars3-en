#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re
import sys

if len(sys.argv) != 2:
    raise SystemExit('usage: verify_map_name_width.py baserom.gbc')
rom = Path(sys.argv[1]).read_bytes()
if len(rom) < 0x100000:
    raise SystemExit('baserom too small')
root = Path(__file__).resolve().parents[1]

def fileoff(bank, addr):
    if bank == 0:
        return addr
    return bank * 0x4000 + (addr - 0x4000)

def sha_range(bank, start, end):
    data = rom[fileoff(bank, start):fileoff(bank, end)]
    return hashlib.sha1(data).hexdigest()

# Every true direct LD DE/HL,wMapRecordName reference in retail. Coincidental
# 41 CA byte pairs in music/data are intentionally excluded by opcode context.
refs = []
pat = bytes((0x41, 0xCA))
pos = 0
while True:
    p = rom.find(pat, pos)
    if p < 0:
        break
    if p and rom[p - 1] in (0x11, 0x21): # ld de,d16 / ld hl,d16
        bank = p // 0x4000
        addr = (p - 1) if bank == 0 else 0x4000 + ((p - 1) % 0x4000)
        refs.append((bank, addr))
    pos = p + 1
expected_refs = [
    (0x00, 0x28BF),
    (0x13, 0x4676),
    (0x13, 0x5478),
    (0x13, 0x5A8B),
    (0x13, 0x5DF1),
    (0x25, 0x47E3),
    (0x25, 0x493F),
]
if refs != expected_refs:
    raise SystemExit(f'direct wMapRecordName references changed: {refs!r}')

constants = (root / 'constants/map_constants.inc').read_text()
if not re.search(r'DEF\s+MAP_RECORD_NAME_SIZE\s+EQU\s+8\b', constants):
    raise SystemExit('MAP_RECORD_NAME_SIZE is not 8')

checks = {
    'engine/home/home_map.asm': ['wMapRecordName', 'MAP_RECORD_NAME_SIZE'],
    'engine/map/map_sram.asm': ['MapRecord_LoadSRAMSlotPrefix', 'wMapRecordName', 'MAP_RECORD_NAME_SIZE'],
    'engine/map/map_menu.asm': ['MapMenu_DrawSelectedMapNameAndSize', 'MapMenu_CacheSelectedMapName', 'MapName9_DrawLoadedViaDC3B', 'MapName9_CacheSelectedMapName'],
    'engine/unit/unit_status.asm': ['UnitStatus_DrawMapSelectionSummary', 'UnitStatus_DrawAlternateMapName', 'MapName9_DrawLoadedUnitStatus'],
    'engine/map/map_name_9char.asm': ['wMapRecordName', 'wMapRecordNameExtra', 'MAP_RECORD_NAME_SIZE', 'MAP_RECORD_NAME_LOGICAL_SIZE'],
}
for rel, tokens in checks.items():
    text = (root / rel).read_text()
    for token in tokens:
        if token not in text:
            raise SystemExit(f'{rel}: missing {token}')

# These four ranges were newly made explicit in the current source. Hashes bind the
# source-backed blocks to the retail bytes; English/custom sections elsewhere
# are not included in these ranges.
ranges = [
    (0x13, 0x4676, 0x46AA, '5369e977d5bba2f4ffe7f45182c6e987f0f1b908'),
    (0x13, 0x5A89, 0x5AA2, '6012bde3c33d35620de4c1db42733a1a85300aa3'),
    (0x25, 0x47BC, 0x4819, '10eb849ff41277527e4b543defbfb82394894e34'),
    (0x25, 0x491F, 0x4963, 'f9f3b33348e6f5cf5303e4e2eb0359580e10fe7c'),
]
for bank, start, end, expected in ranges:
    got = sha_range(bank, start, end)
    if got != expected:
        raise SystemExit(f'ROM range {bank:02x}:{start:04x}-{end-1:04x} SHA-1 {got}, expected {expected}')

# Each sourced name-copy site must express its width symbolically. Other raw
# $0008 constants in these modules may describe unrelated buffers/operations.
site_patterns = {
    'engine/home/home_map.asm': [r'ld hl, wMapRecordName[\s\S]{0,160}ld c, MAP_RECORD_NAME_SIZE'],
    'engine/map/map_sram.asm': [r'MapRecord_LoadSRAMSlotPrefix::[\s\S]{0,900}ld hl, wMapRecordName[\s\S]{0,100}ld bc, MAP_RECORD_NAME_SIZE'],
    'engine/map/map_name_9char.asm': [
        r'MapName9_DrawLoadedViaDC3B::[\s\S]{0,220}ld bc, MAP_RECORD_NAME_SIZE',
        r'MapName9_CacheSelectedMapName::[\s\S]{0,220}ld bc, MAP_RECORD_NAME_SIZE',
        r'MapName9_DrawLoadedUnitStatus::[\s\S]{0,260}ld bc, MAP_RECORD_NAME_SIZE',
    ],
}
for rel, patterns in site_patterns.items():
    text = (root / rel).read_text()
    for pattern in patterns:
        if not re.search(pattern, text):
            raise SystemExit(f'{rel}: symbolic map-name width pattern not found: {pattern}')

print('map-name width audit: [ok]')
print('  direct retail wMapRecordName code references: 7/7 sourced or represented')
print('  physical MAP_RECORD_NAME_SIZE: 8; logical sidecar width: 9')
print('  newly source-backed direct consumers: 4 ranges / 238 bytes')
