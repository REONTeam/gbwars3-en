#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import sys

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'baserom.gbc'
rom = ROM.read_bytes()

def check(bank,start,end,name,want):
    off=bank*0x4000+(start-0x4000)
    data=rom[off:off+end-start]
    got=sha1(data).hexdigest()
    assert len(data)==end-start and got==want,(name,len(data),got)
    print(f'[ok] {name}: Bank ${bank:02X}:${start:04X}-${end-1:04X}, {len(data)} bytes, SHA-1 {got}')

check(0x0B,0x63CF,0x6474,'carried-child action controller/menu/context gate','a5e659130b0f1876bd5bd8d62a8d6a62ec379c80')
check(0x0B,0x6474,0x648C,'capture availability predicate','a9ce590163dbfca965221b3d3f9ff9845f7069c3')

src=(ROOT/'engine/unit/unit_transport_carried_child_action_63cf.asm').read_text()
for token in (
    'UnitTransport_RunCarriedChildActionController::',
    'UnitTransport_BuildSelectedChildActionMenu::',
    'UnitAction_IsContextTargetUnavailable::',
    'UnitAction_IsCaptureUnavailableAtCoordinates::',
    'call UnitTransport_RunCarriedChildSelection',
    'call UnitActionMenu_RunSelection',
    'cp UNIT_ACTION_MOVE',
    'cp UNIT_ACTION_SUPPLY',
    'call MapTile_ReadBank2AtCoordinates',
    'assert @ == $648c',
):
    assert token in src, f'missing source token: {token}'
assert not any(line.lstrip().startswith('db ') for line in src.splitlines()), 'carried-child action family still contains raw db code'
print('[ok] carried-child FLY/DROP controller is mnemonic and context-target gate is source-backed')
