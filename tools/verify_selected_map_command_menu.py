#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import sys

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'baserom.gbc'
rom = ROM.read_bytes()
START, END, BANK = 0x717D, 0x7226, 0x0B
EXPECTED_SHA1 = 'e80063bb90a8c909d6286a3ba96181b99eae5ccc'


def off(bank, addr):
    return bank * 0x4000 + (addr - 0x4000)

chunk = rom[off(BANK, START):off(BANK, END)]
assert len(chunk) == END - START
assert sha1(chunk).hexdigest() == EXPECTED_SHA1, 'selected-map command-menu retail range changed'

src_path = ROOT / 'engine/map/ai/map_control_selected_map_command_menu_717d.asm'
src = src_path.read_text()
for token in (
    'section "Bank $0B Selected Map Command Menu", romx[$717d], bank[$0b]',
    'MapControl_BuildSelectedMapCommandMenu::',
    'MapControl_TestEndCommandAvailability::',
    'MapControl_TestSaveCommandAvailability::',
    'call UnitActionMenu_Reset',
    'call UnitActionMenu_AddEntry',
    'ld hl, wUnitCountBySide',
    'farcall $11, CampaignStats_TestProcuredFlag35',
    'assert @ == $7226',
):
    assert token in src, f'missing selected-map command-menu source token: {token}'
assert '    db ' not in src, 'selected-map command-menu builder still contains raw db code'

lines = []
for raw in src.splitlines():
    line = raw.split(';', 1)[0].strip()
    if not line or line.startswith(('include ', 'DEF ', 'section ', 'assert ')):
        continue
    if line.endswith(':') or (line.startswith('.') and ' ' not in line and '\t' not in line):
        continue
    lines.append(line)
assert len(lines) == 77, f'selected-map command-menu instruction/macro count changed: {len(lines)} != 77'

# The builder is a heavy consumer of the shared Action Menu API; keep those
# edges symbolic so later Action Menu cleanup cannot silently strand raw calls.
for raw in ('call $4f82', 'call $4fa6'):
    assert raw not in src.lower(), f'stale raw Action Menu call remains: {raw}'

print('Selected-map command menu $717D-$7225 retail fingerprint: [ok]')
print('Selected-map command menu mnemonic source / 77-instruction geometry: [ok]')
