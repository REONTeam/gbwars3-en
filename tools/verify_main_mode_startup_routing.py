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
    (0x02, 0x4B68, 0x4B9B, 'shared startup/bootstrap bridge'),
    (0x14, 0x4805, 0x4B39, 'main mode dispatcher and file-selection routing'),
    (0x14, 0x59A8, 0x5A5B, 'file-slot confirmation controller/resources'),
    (0x15, 0x54BB, 0x55D2, 'main-menu controller/runtime'),
    (0x15, 0x5FE5, 0x6025, 'suspend/resume setup'),
    (0x15, 0x6096, 0x6159, 'suspend/resume controller and preview helpers'),
    (0x15, 0x64D1, 0x64F6, 'main-mode subsystem reset'),
    (0x15, 0x7137, 0x7158, 'post-overwrite map-save flow'),
    (0x26, 0x549A, 0x54C8, 'Bank 26 mode-state reset'),
    (0x13, 0x40FB, 0x415D, 'Map Menu runtime-state reset'),
    (0x11, 0x48AF, 0x4A12, 'Beginner/Campaign result-entry and map progression runtime'),
    (0x27, 0x7C84, 0x7CB7, 'Campaign result summary controller'),
]

total = sum(check_retail_span(*span) for span in spans)
assert total == 2208, total
print(f'PASS exact startup/mode-routing tranche: {total} retail bytes')

sym_text = Path('GBWARS3.sym').read_text()
sym_lower = sym_text.lower()
required_symbols = (
    '02:4b68 main_bank2startupbridge',
    '14:4805 main_modedispatcher',
    '14:48a6 main_runbeginnermode',
    '14:48fb main_runcampaignmode',
    '14:491a main_runstandardmode',
    '14:494b main_runmapmenumode',
    '14:4957 main_runversusmode',
    '14:59a8 fileslotconfirm_open',
    '15:54bb mainmenu_runtime',
    '15:5fe5 suspendresume_setupscreen',
    '15:6096 suspendresume_runtime',
    '15:64d1 main_resetmodesubsystemstate',
    '15:7137 mapsave_postoverwriteflow',
    '26:549a bank26_resetruntimestate',
    '13:40fb mapmenu_resetruntimestate',
    '11:48af beginnermode_runresultflow',
    '11:490c campaignmode_runresultflow',
    '27:7c84 campaignresult_showsummary',
)
for marker in required_symbols:
    assert marker in sym_lower, marker
print('PASS startup/mode-routing public symbol addresses')

# Lock the five-way main-mode jump table to the actual public route entries.
addresses = {}
for line in sym_text.splitlines():
    m = re.match(r'^([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4})\s+(\S+)$', line)
    if m:
        addresses[m.group(3)] = (int(m.group(1), 16), int(m.group(2), 16))
labels = [
    'Main_RunBeginnerMode',
    'Main_RunCampaignMode',
    'Main_RunStandardMode',
    'Main_RunMapMenuMode',
    'Main_RunVersusMode',
]
expected = [addresses[label][1] for label in labels]
for label in labels:
    assert addresses[label][0] == 0x14
actual = list(struct.unpack('<5H', built[rom_offset(0x14, 0x4935):rom_offset(0x14, 0x4935) + 10]))
assert actual == expected, (actual, expected)
print('PASS five-entry main-mode jump table ordering')

# Main_Init should now use the source-owned Bank 02 bridge, not a raw jump.
main_init = Path('engine/home/home_main_init.asm').read_text().lower()
assert 'jp main_bank2startupbridge' in main_init
assert 'jp $4b68' not in main_init
bridge = Path('engine/home/home_bank2_startup_bridge.asm').read_text().lower()
assert 'farcall main_modedispatcher' in bridge
print('PASS Main_Init -> Bank 02 bootstrap -> Bank 14 mode-dispatch integration')

# The last 0x90 bytes of the retail battle UI copy window are dual-use code.
# The asset file retains those bytes for edit/reference, but source ownership
# ends at $4805 and the loader deliberately copies onward through dispatcher code.
gfx_source = Path('data/gfx/graphics.asm').read_text()
assert 'incbin "gfx/battle/common/battle_ui_common.2bpp", 0, $0420' in gfx_source
assert 'assert @ == $4805' in gfx_source
asset = Path('gfx/battle/common/battle_ui_common.2bpp').read_bytes()
assert len(asset) >= 0x4B0
suffix = asset[0x420:0x4B0]
retail_dual = retail[rom_offset(0x14, 0x4805):rom_offset(0x14, 0x4895)]
assert suffix == retail_dual
assert len(suffix) == 0x90
print('PASS battle common-UI source split: 0x420-byte asset prefix + 0x90 dual-use dispatcher bytes')

# Lock the two subtle suspend-controller behaviors that are easy to mistranscribe.
suspend = Path('engine/ui/suspend_resume_runtime.asm').read_text().lower()
assert 'ldh a, [hjoyrepeat]' in suspend
assert 'bit 5, a\n    jr z, .continue' in suspend
assert 'jr .loop\n.finish' in suspend
print('PASS suspend/resume input contract and retail forward-loop trampoline')

campaign = Path('engine/campaign/campaign_mode_entry_runtime.asm').read_text().lower()
assert 'farcall campaignresult_showsummary' in campaign
summary = Path('engine/campaign/campaign_result_summary_runtime.asm').read_text().lower()
assert 'call campaignresult_drawsummaryscreen' in summary
assert 'ldh a, [hjoyrepeat]' in summary
print('PASS Campaign result entry uses source-owned summary controller')

# Numeric bank/address farcalls are no longer acceptable in assembly source.
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
assert len(objects) == len(set(objects)), 'duplicate Makefile objects'
missing = [obj for obj in objects if not Path(obj[:-2] + '.asm').exists()]
assert not missing, missing
assert len(objects) >= 368, len(objects)
print(f'PASS Makefile object/source audit: {len(objects)} / {len(objects)}')

h = hashlib.sha256(built).hexdigest()
assert h == EXPECTED_SHA256, h
print('PASS corrected custom-English SHA-256', h)
