from pathlib import Path
import hashlib
import re

EXPECTED_SHA256 = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
retail = Path('baserom.gbc').read_bytes()
built = Path('GBWARS3.gbc').read_bytes()


def rom_offset(bank, address):
    return bank * 0x4000 + address - 0x4000


def check_retail_span(bank, start, end, name):
    off = rom_offset(bank, start)
    expected = retail[off:off + end - start]
    actual = built[off:off + end - start]
    assert actual == expected, f'{name}: built bytes differ from retail'
    print(f'PASS {name}: {bank:02X}:{start:04X}-{end - 1:04X} ({end - start} bytes)')
    return end - start


spans = [
    (0x27, 0x6B46, 0x6C2E, 'file-select frontend'),
    (0x27, 0x6C7E, 0x6CA8, 'saved-confirmation presentation'),
    (0x27, 0x6CB2, 0x6EEA, 'file-select controller and slot helpers'),
    (0x27, 0x6EEA, 0x731A, 'file-select presentation A'),
    (0x27, 0x732F, 0x73A7, 'file-select presentation B'),
    (0x27, 0x73BC, 0x7460, 'file-select presentation C'),
    (0x27, 0x7475, 0x7577, 'file-select presentation D'),
    (0x13, 0x58DC, 0x5A89, 'SRAM slot metadata runtime A'),
    (0x13, 0x5A8C, 0x5CFE, 'SRAM slot metadata runtime B'),
    (0x14, 0x5A5B, 0x5B13, 'selected-slot view'),
    (0x14, 0x5B6D, 0x5B79, 'file-select display preparation'),
    (0x14, 0x5D30, 0x5D6D, 'preview graphics loader'),
    (0x14, 0x5D6D, 0x5D8C, 'preview renderer source A'),
    (0x14, 0x5D8C, 0x5DAB, 'preview renderer source B'),
    (0x14, 0x5DAB, 0x5DE0, 'preview rectangle renderer 6'),
    (0x14, 0x5E15, 0x5E3F, 'preview rectangle renderer 12'),
    (0x15, 0x712C, 0x7137, 'overwrite-prompt state reset'),
]

total = sum(check_retail_span(*span) for span in spans)
assert total == 3936, total
print(f'PASS exact retail-byte coverage: {total} newly explicit bytes')

# The live nine-character-name patches deliberately interrupt the retail save
# presentation/runtime. Keep them as separate owners and make sure they remain
# at their established addresses.
sym_text = Path('GBWARS3.sym').read_text().lower()
for marker in (
    '13:5a89 mapmenu_cacheselectedmapname',
    '13:6438 mapname9_cacheselectedmapname',
    '27:731a mapnamecache_drawrow8',
    '27:73a7 mapnamecache_drawrow11',
    '27:7460 mapnamecache_drawrow14',
):
    assert marker in sym_text, marker

patch_specs = [
    (0x13, 0x5A89, 0x5A8C, 'selected-map-name cache jump'),
    (0x27, 0x731A, 0x732F, 'slot row 8 nine-character name patch'),
    (0x27, 0x73A7, 0x73BC, 'slot row 11 nine-character name patch'),
    (0x27, 0x7460, 0x7475, 'slot row 14 nine-character name patch'),
]
for bank, start, end, name in patch_specs:
    off = rom_offset(bank, start)
    assert built[off:off + end - start] != retail[off:off + end - start], name
print('PASS live nine-character map-name owners remain distinct from retail SAVE source')

# Lock the public API addresses used across the SAVE/file-select subsystem.
for marker in (
    '27:6b46 mapsave_openfileselect',
    '27:6b95 mapsave_resetcategoryselection',
    '27:6b9a mapsave_rebuildfileselect',
    '27:6bc8 mapsave_closefileselect',
    '27:6bd7 mapsave_canconfirmcurrentslot',
    '27:6c00 mapsave_drawprompt',
    '27:6c7e mapsave_drawsavedconfirmation',
    '27:6cb2 mapsave_waitsavedconfirmation',
    '27:6ce3 mapsave_applycategorytoslot',
    '27:6d04 mapsave_runfileselectcontroller',
    '27:6eea mapsave_drawslotframes',
    '27:6f59 mapsave_hidepreviewpane',
    '27:6fa6 mapsave_loadselectedslotpreview',
    '27:6fde mapsave_drawselectedslotpreview',
    '27:704f mapsave_drawselectedslotpreview_finalize',
    '27:711b mapsave_setupfileselectscreen',
    '27:7311 mapsave_drawslot0details',
    '27:739e mapsave_drawslot1details',
    '27:7431 mapsave_drawslot2details',
    '27:74e8 mapsave_createcursorsprites',
    '13:58dc mapsram_getslotstatusbyte',
    '13:5962 mapsram_readslotmetadatabyte',
    '13:597c mapsram_loadslotpreviewheader',
    '13:59b0 mapsram_readslotmodebyte',
    '13:5a24 mapsram_loadslotsummaryrow',
    '13:5b8e mapsram_savegameplaytoslot',
    '13:5c7b mapsram_loadslotstateblock',
    '14:5a5b mapsave_openselectedslotview',
    '14:5b6d mapsave_preparefileselectdisplay',
    '14:5d30 mapsave_loadpreviewgraphics',
    '14:5d6d mapsave_setpreviewrenderersourcea',
    '14:5d8c mapsave_setpreviewrenderersourceb',
    '14:5dab mapsave_drawpreviewrect6',
    '14:5e15 mapsave_drawpreviewrect12',
    '15:712c mapsave_resetoverwritepromptstate',
):
    assert marker in sym_text, marker
print('PASS SAVE/file-select public symbol addresses')

controller = Path('engine/map/map_save_file_select_controller.asm').read_text().lower()
for text in (
    'farcall $13, mapsram_getslotstatusbyte',
    'farcall $13, mapsram_loadslotsummaryrow',
    'farcall $13, mapsram_savegameplaytoslot',
    'farcall $13, mapsram_loadslotstateblock',
    'farcall $14, mapsave_openselectedslotview',
    'farcall $14, mapsave_preparefileselectdisplay',
    'farcall $15, mapsave_resetoverwritepromptstate',
):
    assert text in controller, text

presentation = Path('engine/map/map_save_file_select_presentation.asm').read_text().lower()
for text in (
    'farcall $13, mapsram_loadslotpreviewheader',
    'farcall $13, mapsram_readslotmodebyte',
    'farcall $13, mapsram_readslotmetadatabyte',
    'farcall $14, mapsave_loadpreviewgraphics',
    'farcall $14, mapsave_setpreviewrenderersourcea',
    'farcall $14, mapsave_setpreviewrenderersourceb',
    'farcall $14, mapsave_drawpreviewrect6',
    'farcall $14, mapsave_drawpreviewrect12',
):
    assert text in presentation, text

provider = Path('engine/map/map_save_presentation_providers.asm').read_text().lower()
for text in (
    'farcall $27, mapsave_openfileselect',
    'farcall $27, mapsave_runfileselectcontroller',
    'farcall $27, mapsave_closefileselect',
):
    assert text in provider, text
print('PASS symbolic SAVE/file-select integration')

# The input dispatcher has eight button handlers plus the default controller.
jump_block = controller.split('mapsave_inputjumptable::', 1)[1].split('assert @ == $6ecc', 1)[0]
jump_entries = re.findall(r'^\s*dw\s+([a-z0-9_]+)', jump_block, re.M | re.I)
assert len(jump_entries) == 9, jump_entries
assert jump_entries[-1].lower() == 'mapsave_runfileselectcontroller', jump_entries
print('PASS file-select input jump table: 9 typed entries')

# No assembly source should need a raw bank/address farcall anymore.
raw_farcall = re.compile(r'\bfarcall\s+\$[0-9a-f]+\s*,\s*\$[0-9a-f]+', re.I)
raw = []
for path in Path('.').rglob('*.asm'):
    for lineno, line in enumerate(path.read_text(errors='ignore').splitlines(), 1):
        if raw_farcall.search(line):
            raw.append((str(path), lineno, line.strip()))
assert not raw, raw
print('PASS project-wide raw numeric farcall audit: 0')

# Every active Makefile object must have one source file.
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
