from pathlib import Path
import hashlib
import re

EXPECTED = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
retail = Path('baserom.gbc').read_bytes()
built = Path('GBWARS3.gbc').read_bytes()


def chk(bank, start, end, name):
    off = bank * 0x4000 + start - 0x4000
    assert built[off:off + end - start] == retail[off:off + end - start], name
    print(f'PASS {name} {bank:02X}:{start:04X}-{end - 1:04X} ({end - start} bytes)')


chk(0x12, 0x4000, 0x4020, 'UnitRecords_ClearAllAndCounts')
chk(0x1A, 0x4000, 0x405B, 'MapCall_RunPresentationSequence8')
chk(0x13, 0x5CFE, 0x5D37, 'MapEditor_SaveCurrentMapToSRAM')
chk(0x15, 0x6637, 0x6691, 'two-choice highlight renderers')
chk(0x27, 0x7997, 0x7A63, 'MapYieldPrompt')
chk(0x27, 0x7F17, 0x8000, 'MapSaveContinuePrompt + Bank27 tail')
chk(0x31, 0x7E9A, 0x8000, 'MapInterruptPrompt + Bank31 tail')
chk(0x27, 0x5F13, 0x65A0, 'MapStatus presentation runtime')
chk(0x15, 0x4000, 0x43C3, 'Configuration/options runtime')
chk(0x14, 0x4B39, 0x4B50, 'MapSave gameplay presentation')
chk(0x15, 0x5EDE, 0x5F63, 'MapSave editor presentation')
chk(0x26, 0x6A26, 0x6A42, 'Attract text graphics loader')
chk(0x13, 0x4000, 0x402F, 'Map demo state reset')

sym = Path('GBWARS3.sym').read_text().lower()
for marker in (
    '12:4000 unitrecords_clearallandcounts',
    '1a:4000 mapcall_runpresentationsequence8',
    '13:5cfe mapeditor_savecurrentmaptosram',
    '13:5ee8 mapsram_serializeatbase',
    '13:6090 mapsram_deserializeatbase',
    '15:6637 gfx_drawtwochoicehighlightsecond',
    '15:6664 gfx_drawtwochoicehighlightfirst',
    '27:7997 mapyieldprompt_setup',
    '27:79eb mapyieldprompt_run',
    '27:7f17 mapsavecontinueprompt_setup',
    '27:7f6e mapsavecontinueprompt_run',
    '31:7e9a mapinterruptprompt_setup',
    '31:7eee mapinterruptprompt_run',
    '27:62ab mapstatus_run',
    '15:412b options_run',
    '14:4b39 mapsave_rungameplaypresentation',
    '15:5ede mapsave_runeditorpresentation',
    '26:6a26 attracttext_loadgraphics',
    '13:4000 mapruntime_resetdemostate',
):
    assert marker in sym, marker
print('PASS public symbol addresses')

controller = Path('engine/map/ai/map_control_selected_map_command_controller_7226.asm').read_text().lower()
for symbolic in (
    'farcall $27, mapyieldprompt_run',
    'farcall $31, mapinterruptprompt_run',
    'farcall $27, mapsavecontinueprompt_run',
    'farcall mapstatus_run',
    'farcall options_run',
    'farcall mapsave_runeditorpresentation',
    'farcall mapsave_rungameplaypresentation',
):
    assert symbolic in controller, symbolic
for raw in ('$79eb', '$7eee', '$7f6e'):
    assert raw not in controller, raw

setup = Path('engine/map/bank0b_map_setup_runtime_4000.asm').read_text().lower()
assert 'farcall $12, unitrecords_clearallandcounts' in setup
assert 'farcall $12, $4000' not in setup

phase = Path('engine/map/ai/map_control_phase_command07_746d.asm').read_text().lower()
assert 'farcall $1a, mapcall_runpresentationsequence8' in phase
assert 'farcall $1a, $4000' not in phase

editor = Path('engine/map/map_editor_menu_handlers_460f.asm').read_text().lower()
assert 'farcall $13, mapeditor_savecurrentmaptosram' in editor
assert 'farcall $13, $5cfe' not in editor

infrared = Path('engine/infrared/map_infrared_exchange_runtime_6983.asm').read_text().lower()
assert 'mapsram_serializeatbase' in infrared
assert 'mapsram_deserializeatbase' in infrared
assert '$5ee8' not in infrared and '$6090' not in infrared
print('PASS symbolic caller integration')

# The selected-map command frontends and their SAVE/file-select dependencies are
# now symbolic; no raw bank/address farcalls remain in active assembly source.
pat = re.compile(r'\bfarcall\s+\$([0-9a-f]+)\s*,\s*\$([0-9a-f]+)', re.I)
raw = []
for path in Path('.').rglob('*.asm'):
    for line in path.read_text(errors='ignore').splitlines():
        m = pat.search(line)
        if m:
            raw.append((int(m.group(1), 16), int(m.group(2), 16), str(path)))
assert not raw, raw
print('PASS raw-farcall audit: 0 numeric farcalls remain')

# Verify the Makefile's active object list has one matching source for each object.
makefile = Path('Makefile').read_text()
block = makefile.split('objects := \\')[-1].split('\n\ngraphics :=', 1)[0]
objects = re.findall(r'[A-Za-z0-9_./-]+\.o', block)
assert len(objects) >= 358 and len(objects) == len(set(objects)), (len(objects), len(set(objects)))
missing = [o for o in objects if not Path(o[:-2] + '.asm').exists()]
assert not missing, missing
print(f'PASS Makefile object/source audit: {len(objects)} / {len(objects)}')

map_name_ui = Path('engine/map/map_name_ui.asm').read_text().lower()
assert 'romx[$5f97]' not in map_name_ui
assert 'mapeditor_drawcurrentname' not in map_name_ui
print('PASS obsolete $27:$5F97 map-name stub removed; STATUS bytes restored')

h = hashlib.sha256(built).hexdigest()
assert h == EXPECTED, h
print('PASS custom-English SHA-256', h)
