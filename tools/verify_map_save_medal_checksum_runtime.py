from pathlib import Path
import hashlib
import re

EXPECTED_SHA256 = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
retail = Path('baserom.gbc').read_bytes()
built = Path('GBWARS3.gbc').read_bytes()


def rom_offset(bank, address):
    if bank == 0:
        return address
    return bank * 0x4000 + address - 0x4000


def check_retail_span(bank, start, end, name):
    off = rom_offset(bank, start)
    expected = retail[off:off + end - start]
    actual = built[off:off + end - start]
    assert actual == expected, f'{name}: built bytes differ from retail'
    print(f'PASS {name}: {bank:02X}:{start:04X}-{end - 1:04X} ({end - start} bytes)')
    return end - start


spans = [
    (0x00, 0x34D8, 0x352E, 'VBlank FIFO enqueue runtime'),
    (0x00, 0x357B, 0x35FE, 'indexed BG rectangle renderer'),
    (0x00, 0x377C, 0x37C2, 'medal-detail LCD STAT/window service'),
    (0x00, 0x37C2, 0x37E9, 'two-plane VBlank tile/attribute wrapper'),
    (0x00, 0x39C7, 0x39DB, '16-bit additive checksum'),
    (0x10, 0x4C59, 0x4DC0, 'medal-detail background renderer/assets'),
    (0x14, 0x5B4C, 0x5B6D, 'medal-detail LCD setup'),
    (0x14, 0x5B79, 0x5D30, 'medal-detail controller/page runtime'),
    (0x14, 0x5E3F, 0x5F1B, 'medal-detail grid/cursor renderer'),
    (0x14, 0x5F29, 0x5F4A, 'selected-medal detail wrapper'),
    (0x13, 0x6165, 0x6256, 'Map SRAM checksum/validation runtime'),
]

total = sum(check_retail_span(*span) for span in spans)
assert total == 1671, total
print(f'PASS exact source/modeling tranche: {total} retail bytes')

# The two 160-byte assets are now independently named instead of being hidden
# inside the old Hudson-logo tilemap alias.
for path, bank, start, end in (
    ('gfx/file_select/medal_detail.tilemap', 0x10, 0x4C80, 0x4D20),
    ('gfx/file_select/medal_detail.attrmap', 0x10, 0x4D20, 0x4DC0),
):
    data = Path(path).read_bytes()
    off = rom_offset(bank, start)
    assert len(data) == end - start == 160, (path, len(data))
    assert data == retail[off:off + end - start], path
print('PASS medal-detail tile/attribute assets: 160 + 160 exact retail bytes')

sym_text = Path('GBWARS3.sym').read_text().lower()
for marker in (
    '00:34d8 vblankfifo_write',
    '00:34ed vram_drawtileatcoordinates',
    '00:350f vblankfifo_queue',
    '00:3529 vblankfifo_commit',
    '00:357b vram_drawbgrectindexed',
    '00:377c mapsave_medaldetaillcdstatinterrupt',
    '00:37b3 mapsave_updatemedaldetailwindowx',
    '00:37c2 vblankfifo_queuetileandattratcoordinates',
    '00:39c7 checksum16',
    '10:4c59 mapsave_drawmedaldetailbackground',
    '13:59fd mapsram_loadslotmedalflags',
    '13:6165 mapsram_validatestoredslots',
    '13:61d1 mapsram_writeslotchecksum',
    '13:621b mapsram_writecategorychecksum',
    '14:5bea mapsave_openmedaldetailview',
    '14:5cad mapsave_showlowermedalgridpage',
    '14:5ceb mapsave_showuppermedalgridpage',
    '14:5e88 mapsave_positionmedalcursor',
    '14:5f29 mapsave_drawselectedmedaldetails',
):
    assert marker in sym_text, marker
print('PASS medal/checksum public symbol addresses')

medal = Path('engine/map/map_save_medal_detail_runtime.asm').read_text().lower()
for text in (
    'ld hl, mapsave_medaldetaillcdstatinterrupt',
    'call mapsave_updatemedaldetailwindowx',
    'call vram_drawbgrectindexed',
    'farcall $13, mapsram_loadslotmedalflags',
    'farcall $10, mapsave_drawmedaldetailbackground',
):
    assert text in medal, text
for raw in ('$357b', '$377c', '$37b3'):
    assert raw not in medal, raw

preview = Path('engine/map/map_save_bank14_providers.asm').read_text().lower()
assert 'call vram_drawbgrectindexed' in preview
assert 'call $357b' not in preview

file_select = Path('engine/map/map_save_file_select_presentation.asm').read_text().lower()
assert 'call vblankfifo_queuetileandattratcoordinates' in file_select
assert 'call $37c2' not in file_select

slot = Path('engine/map/map_save_slot_metadata.asm').read_text().lower()
assert 'call mapsram_writeslotchecksum' in slot
assert 'call $61d1' not in slot

startup = Path('engine/ui/startup_hardware_presentation.asm').read_text().lower()
assert 'romx[$4c59]' not in startup
assert 'hudson logo tilemap suffix' not in startup
print('PASS symbolic integration and corrected Bank $10 physical ownership')

raw_farcall = re.compile(r'\bfarcall\s+\$[0-9a-f]+\s*,\s*\$[0-9a-f]+', re.I)
raw = []
for path in Path('.').rglob('*.asm'):
    for lineno, line in enumerate(path.read_text(errors='ignore').splitlines(), 1):
        if raw_farcall.search(line):
            raw.append((str(path), lineno, line.strip()))
assert not raw, raw
print('PASS project-wide raw numeric farcall audit: 0')

makefile = Path('Makefile').read_text()
block = makefile.split('objects := \\\n', 1)[1].split('\n\ngraphics :=', 1)[0]
objects = re.findall(r'[A-Za-z0-9_./-]+\.o', block)
assert len(objects) >= 358 and len(objects) == len(set(objects)), (len(objects), len(set(objects)))
missing = [obj for obj in objects if not Path(obj[:-2] + '.asm').exists()]
assert not missing, missing
print(f'PASS Makefile object/source audit: {len(objects)} / {len(objects)}')

h = hashlib.sha256(built).hexdigest()
assert h == EXPECTED_SHA256, h
print('PASS corrected custom-English SHA-256', h)
