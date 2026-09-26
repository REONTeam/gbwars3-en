#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys

root = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'baserom.gbc'
rom = rom_path.read_bytes()

def chunk(bank, start, end):
    off = bank * 0x4000 + (start - 0x4000)
    return rom[off:off + (end - start)]

checks = [
    (0x0d, 0x4407, 0x44ee, 'cd7765c30aa76133d39a51047c7334b944d2160b', 'AI action dispatcher'),
    (0x0b, 0x5d84, 0x5e1e, '6e33814cd920070504dd6cd121555f0334cde724', 'transport load runtime'),
]
for bank, start, end, expected, name in checks:
    data = chunk(bank, start, end)
    got = hashlib.sha1(data).hexdigest()
    assert got == expected, f'{name}: {got} != {expected}'
    print(f'[ok] {name}: bank ${bank:02X}:${start:04X}-${end-1:04X}, {len(data)} bytes, sha1 {got}')

transport = (root / 'engine/unit/unit_transport_actions.asm').read_text()
for token in [
    'Unit_CanLoadIntoCarrierAtCoordinates::',
    'Unit_LoadIntoCarrierAtActionTarget::',
    'UnitData_CheckLoadingCompatibility',
    'UNIT_DATA_TRANSPORT_CAPACITY_OFFSET',
    'UNIT_RECORD_STATUS_CARRIED_F',
    'UNIT_RECORD_CARRIER_INDEX_OFFSET',
    'assert @ == $5e1e',
]:
    assert token in transport, f'missing transport source token: {token}'

dispatch = (root / 'engine/map/ai/map_ai_action_dispatch.asm').read_text()
for token in [
    'MapAI_DispatchAction::',
    'MapAI_ActionHandlerTable::',
    'MapAI_ActionLoadIntoCarrier::',
    'farcall $0b, Unit_LoadIntoCarrierAtActionTarget',
    'assert @ == $44ee',
]:
    assert token in dispatch, f'missing dispatcher source token: {token}'

actions = (root / 'engine/map/ai/map_ai_actions.asm').read_text()
for token in ['MapAI_EndTurnDamagedCarrierCargo::', 'MapAI_FindCompatibleCarrierTarget::']:
    assert token in actions, f'missing strengthened AI action label: {token}'


# the current source also removes the inherited duplicate fixed section at $0B:$7CF7.
terrain = (root / 'data/terrain.asm').read_text()
capture = (root / 'engine/map/ai/map_control_capture_targets.asm').read_text()
assert 'section "Map Tile Phase Ownership Classification", romx[$7cf7], bank[$0b]' in terrain
assert 'MapTile_GetPhaseOwnershipClass::' in terrain
assert 'romx[$7cf7]' not in capture

import re
starts = {}
for asm in [p for d in ('engine','data','audio') for p in (root/d).rglob('*.asm')]:
    for m in re.finditer(r'section\s+"[^"]+",\s*romx\[\$([0-9a-fA-F]+)\],\s*bank\[\$([0-9a-fA-F]+)\]', asm.read_text(), re.I):
        key = (int(m.group(2), 16), int(m.group(1), 16))
        assert key not in starts, f'duplicate fixed section start {key}: {starts[key]} / {asm.name}'
        starts[key] = asm.name
print('[ok] no duplicate fixed ROM section starts')

print('[ok] the current source transport/action semantic integration')
