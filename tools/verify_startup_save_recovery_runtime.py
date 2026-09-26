from pathlib import Path
import hashlib
import re
import struct

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
    (0x00, 0x156D, 0x15DD, 'main startup/save-validation dispatcher and CGB speed helpers'),
    (0x14, 0x4B50, 0x4C70, 'corrupt-save recovery notice and 17-domain message data'),
    (0x14, 0x4C70, 0x4C8A, 'startup display preparation'),
    (0x14, 0x4C92, 0x4C96, 'pre-dispatch LCD disable wrapper'),
    (0x13, 0x5D54, 0x5DCC, 'ten-slot Editor map validation/checksum runtime'),
]

total = sum(check_retail_span(*span) for span in spans)
assert total == 550, total
print(f'PASS exact startup/recovery tranche: {total} retail bytes')

# $14:$4C8A-$4C91 is explicitly owned as a separate neutral data record.
off = rom_offset(0x14, 0x4C8A)
assert built[off:off + 8] == retail[off:off + 8]
boot_display = Path('engine/map/map_save_boot_display.asm').read_text()
assert 'Main_StartupAdjacentDataRecord' in boot_display
assert 'romx[$4c8a]' in boot_display.lower()
print('PASS $14:$4C8A-$4C91 is explicitly owned as a separate neutral data record')

sym_text = Path('GBWARS3.sym').read_text()
sym_lower = sym_text.lower()
for marker in (
    '00:156d main_init',
    '00:15b3 cgb_enabledoublespeedifneeded',
    '00:15c8 cgb_disabledoublespeedifneeded',
    '13:5d54 mapsram_validateeditorsaveslots',
    '13:5d92 mapsram_verifyeditormapslotchecksum',
    '14:4b50 mapsave_showslotrecoverynotice',
    '14:4c70 main_preparestartupdisplay',
    '14:4c92 main_disablelcdbeforedispatch',
):
    assert marker in sym_lower, marker
print('PASS startup/recovery public symbol addresses')

# Parse the 17-domain pointer table and lock both its geometry and ordering.
labels = [
    'MapSave_RecoveryData1',
    'MapSave_RecoveryData2',
    'MapSave_RecoveryData3',
    'MapSave_RecoveryAutosave',
    'MapSave_RecoveryEditPlay',
    'MapSave_RecoveryVersusPlay',
    'MapSave_RecoveryMessageBox',
    'MapSave_RecoveryEditData1',
    'MapSave_RecoveryEditData2',
    'MapSave_RecoveryEditData3',
    'MapSave_RecoveryEditData4',
    'MapSave_RecoveryEditData5',
    'MapSave_RecoveryEditData6',
    'MapSave_RecoveryEditData7',
    'MapSave_RecoveryEditData8',
    'MapSave_RecoveryEditData9',
    'MapSave_RecoveryEditData10',
]
addresses = {}
for line in sym_text.splitlines():
    m = re.match(r'^([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4})\s+(\S+)$', line)
    if m:
        addresses[m.group(3)] = (int(m.group(1), 16), int(m.group(2), 16))
expected_ptrs = []
for label in labels:
    bank, addr = addresses[label]
    assert bank == 0x14, (label, bank)
    expected_ptrs.append(addr)
table_off = rom_offset(0x14, 0x4B92)
actual_ptrs = list(struct.unpack('<17H', built[table_off:table_off + 34]))
assert actual_ptrs == expected_ptrs, (actual_ptrs, expected_ptrs)
print('PASS recovery-domain pointer table: 17 ordered entries')

recovery = Path('engine/map/map_save_recovery_notice.asm').read_text()
for text in (
    'DATA1が', 'DATA2が', 'DATA3が',
    'オートセーブデータが', 'エディットプレイのデータが', 'VSプレイのデータが',
    'メッセージBOXが', 'エディットデータ1が', 'エディットデータ10が',
    'きえてしまいました',
):
    assert text in recovery, text
assert recovery.count('dw MapSave_Recovery') == 17
print('PASS all 17 recovery domains and common erased suffix are readable source data')

main = Path('engine/home/home_main_init.asm').read_text().lower()
for text in (
    'farcall mapsram_validatestoredslots',
    'farcall mapsram_validateeditorsaveslots',
    'farcall bank31_bootsavevalidation',
    'farcall mapsave_showslotrecoverynotice',
    'farcall main_preparestartupdisplay',
    'farcall main_disablelcdbeforedispatch',
):
    assert text in main, text
assert 'ld a, $06' in main
assert 'jp main_bank2startupbridge' in main

editor = Path('engine/map/map_sram_editor_slot_validation.asm').read_text().lower()
for text in (
    'call mapsram_verifyeditormapslotchecksum',
    'farcall mapsave_showslotrecoverynotice',
    'ld hl, $a00f',
    'add $07',
    'cp $0a',
):
    assert text in editor, text
print('PASS boot validation dispatch and Editor-slot recovery integration')

# No assembly source should use a raw bank/address farcall anymore.
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
