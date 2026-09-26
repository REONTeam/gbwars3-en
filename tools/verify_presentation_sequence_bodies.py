#!/usr/bin/env python3
from __future__ import annotations
from pathlib import Path
import hashlib
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'engine/ui/presentation_sequence_bodies.asm'
DISPATCH = ROOT / 'engine/ui/presentation_sequence_dispatch.asm'
UNIT_LOADER = ROOT / 'engine/ui/presentation_unit_sprite_loader.asm'
PALETTE_WAIT = ROOT / 'engine/ui/presentation_palette_wait_bank31.asm'
BASEROM = ROOT / 'baserom.gbc'
BUILT = ROOT / 'GBWARS3.gbc'
SYM = ROOT / 'GBWARS3.sym'

BANK = 0x1A
START = 0x45D0
END = 0x6089
TABLE_START = 0x46C8
TABLE_END = 0x46F5
EXPECTED_RANGE_SHA1 = '97fbde9a70355f67af32699d0cf7a793c76caf2d'
EXPECTED_TABLE_SHA1 = 'da250183bc3d5aa85e947ca78a15fc33ac68dca4'
EXPECTED_ROM_SHA256 = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
EXPECTED_INSTRUCTIONS = 2758
PUBLIC = {
    'PresentationSequence_PropertyCaptureComplete': 0x45D0,
    'PresentationSequence_PropertyCaptureProgress': 0x46F5,
    'PresentationSequence_TerrainTransformation': 0x486F,
    'PresentationSequence_Supply': 0x5063,
    'PresentationSequence_Load': 0x555A,
    'PresentationSequence_CarriedChildMove': 0x589E,
    'PresentationSequence_CarriedChildMoveSpecialCarrier': 0x5913,
    'PresentationSequence_LoadSpecialCarrier': 0x5DE8,
    'PresentationSequence_8': 0x5E96,
}


def fail(msg: str) -> None:
    raise SystemExit(f'FAIL: {msg}')


def bank_slice(blob: bytes, start: int, end: int) -> bytes:
    off = BANK * 0x4000 + (start - 0x4000)
    return blob[off:off + end - start]


def sha1(data: bytes) -> str:
    return hashlib.sha1(data).hexdigest()


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


for path in (SOURCE, DISPATCH, UNIT_LOADER, PALETTE_WAIT, BASEROM, BUILT, SYM):
    if not path.exists():
        fail(f'missing required file: {path.relative_to(ROOT)}')

base = BASEROM.read_bytes()
built = BUILT.read_bytes()
base_range = bank_slice(base, START, END)
built_range = bank_slice(built, START, END)
if len(base_range) != END - START:
    fail('retail range length is wrong')
if sha1(base_range) != EXPECTED_RANGE_SHA1:
    fail(f'retail $1A:${START:04X}-${END-1:04X} SHA-1 mismatch: {sha1(base_range)}')
if base_range != built_range:
    fail('linked ROM differs from retail inside presentation-sequence range')

# Connected provider ranges newly made explicit alongside the bodies.
provider_ranges = [
    (0x1A, 0x45A5, 0x45D0, 'cfc2e21c725d3fa44d26acab9bdb01e25e6ae3ed', 'presentation unit sprite loader'),
    (0x1A, 0x6380, 0x63E8, '9f2da330ba0d1b6913683f8ba7f4e1310513c592', 'presentation unit sprite definition table'),
    (0x31, 0x4067, 0x4113, '73f8f2502c2717584089a4916c04bc02be3cbe01', 'slow alternating-palette wait'),
]
for bank, start, end, expected_sha1, desc in provider_ranges:
    off = bank * 0x4000 + (start - 0x4000)
    base_part = base[off:off + end - start]
    built_part = built[off:off + end - start]
    if sha1(base_part) != expected_sha1:
        fail(f'{desc} retail SHA-1 mismatch: {sha1(base_part)}')
    if base_part != built_part:
        fail(f'linked ROM differs from retail in {desc}')
if sha256(built) != EXPECTED_ROM_SHA256:
    fail(f'custom-English ROM SHA-256 drifted: {sha256(built)}')

table = bank_slice(base, TABLE_START, TABLE_END)
if sha1(table) != EXPECTED_TABLE_SHA1:
    fail('presentation lookup table SHA-1 mismatch')

src = SOURCE.read_text(encoding='utf-8')
dispatch = DISPATCH.read_text(encoding='utf-8')

# Count actual mnemonic/macro instruction lines; table declarations are excluded.
instruction_count = 0
for raw in src.splitlines():
    line = raw.strip()
    if not line or line.startswith(';') or line.endswith(':') or line.endswith('::'):
        continue
    if line.startswith(('include ', 'section ', 'assert ', 'db ', 'dw ')):
        continue
    instruction_count += 1
if instruction_count != EXPECTED_INSTRUCTIONS:
    fail(f'instruction count {instruction_count}, expected {EXPECTED_INSTRUCTIONS}')

# The only literal data in this otherwise-executable range is the 45-byte table.
data_lines = [ln.strip() for ln in src.splitlines() if ln.strip().startswith(('db ', 'dw '))]
expected_data_lines = [
    'db $5a, $69, $5a, $41, $64, $64, $5a, $5a, $5a',
    'dw $b070, $b068, $b068, $a868, $b068, $b068, $b068, $b068, $b068',
    'dw $5870, $4868, $5868, $6068, $4868, $4868, $5868, $5868, $5868',
]
if data_lines != expected_data_lines:
    fail('unexpected db/dw ownership inside presentation sequence source')

if 'assert @ == $6089' not in src:
    fail('missing hard end assertion at $6089')
if 'farcall $31, $4067' in src or 'call $45a5' in src.lower():
    fail('raw connected provider address remains in presentation sequence source')
if 'Presentation_WaitWithAlternatingPaletteSlow' not in src:
    fail('slow alternating-palette wait is not called symbolically')
if 'PresentationUnitSprite_LoadDefinition' not in src:
    fail('alternate presentation unit-sprite loader is not called symbolically')
if src.count('HIGH(PresentationCallback_') < 50:
    fail('same-bank callback pointers are no longer symbolically staged')
if 'PropertyPresentation_TimingTable' not in src or 'PropertyPresentation_PointerTableA' not in src or 'PropertyPresentation_PointerTableB' not in src:
    fail('property-presentation lookup table labels are missing')
if '$d33d' in src.lower() or 'wPresentationUnitAnimationIDScratch' not in src:
    fail('presentation animation-ID scratch is not symbolic')

# Dispatcher must use symbols rather than the old raw pointer list.
for raw in ('$45d0', '$46f5', '$486f', '$5063', '$555a', '$589e', '$5913', '$5de8', '$5e96'):
    if raw in dispatch.lower():
        fail(f'raw dispatcher target remains: {raw}')
for name in PUBLIC:
    if name not in dispatch:
        fail(f'dispatcher does not reference {name}')

# Check the linker placed each public entry exactly where retail dispatch expects it.
sym_text = SYM.read_text(encoding='utf-8', errors='replace')
for name, addr in PUBLIC.items():
    pat = rf'(?mi)^1a:{addr:04x}\s+{re.escape(name)}$'
    if not re.search(pat, sym_text):
        fail(f'{name} is not linked at $1A:${addr:04X}')
if not re.search(r'(?mi)^1a:45d0\s+PresentationSequence_HQLoss$', sym_text):
    fail('PresentationSequence_HQLoss compatibility identity is not linked at $1A:$45D0')

extra_symbols = {
    ('1a', '45a5', 'PresentationUnitSprite_LoadDefinition'),
    ('1a', '6380', 'PresentationUnitSpriteDefinitions'),
    ('31', '4067', 'Presentation_WaitWithAlternatingPaletteSlow'),
}
for bank, addr, name in extra_symbols:
    if not re.search(rf'(?mi)^{bank}:{addr}\s+{re.escape(name)}$', sym_text):
        fail(f'{name} is not linked at ${bank.upper()}:${addr.upper()}')

print('Presentation sequence bodies verification: PASS')
print(f'  Bank $1A:${START:04X}-${END-1:04X}: {END-START:,} bytes')
print(f'  Executable source: {EXPECTED_INSTRUCTIONS:,} instructions / {END-START-(TABLE_END-TABLE_START):,} bytes')
print(f'  Embedded lookup data: {TABLE_END-TABLE_START} bytes at ${TABLE_START:04X}-${TABLE_END-1:04X}')
print(f'  Retail range SHA-1: {EXPECTED_RANGE_SHA1}')
print('  Connected providers: 319 additional byte-exact bytes')
print(f'  Linked ROM SHA-256: {EXPECTED_ROM_SHA256}')
