#!/usr/bin/env python3
"""Verify Bank $0C FIRE/BOMB and map-infrared ownership/integration."""
from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'baserom.gbc'
BUILT = ROOT / 'GBWARS3.gbc'
SYM = ROOT / 'GBWARS3.sym'
FIRE_SRC = ROOT / 'engine/battle/battle_fire_bomb_runtime_418f.asm'
IR_SRC = ROOT / 'engine/infrared/map_infrared_exchange_runtime_6983.asm'
EXEC_SRC = ROOT / 'engine/unit/unit_action_executor_6283.asm'
BOMB_AVAIL = ROOT / 'engine/unit/unit_action_bomb_availability_6176.asm'
MENU_SRC = ROOT / 'engine/unit/unit_action_context_menu_601e.asm'
CMD_SRC = ROOT / 'engine/map/ai/map_control_selected_map_command_controller_7226.asm'
EXPECTED_ROM_SHA256 = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
RANGES = (
    (0x0C, 0x418F, 0x43CF, 'd77050f6b58e5f318241f394d9bb57b90d1cafec'),
    (0x0C, 0x6983, 0x6B44, '6c7adec2e98de5992a43d56738944ac550a3fd20'),
)
PUBLIC = {
    'UnitAction_RunFireTargetSelection': (0x0C, 0x418F),
    'BattleTargetSelection_RunController': (0x0C, 0x41C1),
    'BattleTargetSelection_CheckCurrentTarget': (0x0C, 0x42E2),
    'BattleTargetSelection_LoadCurrentTargetPresentation': (0x0C, 0x430F),
    'BattleTargetSelection_StagePreviewState': (0x0C, 0x4354),
    'UnitAction_CheckBombAvailable': (0x0C, 0x43A8),
    'MapInfrared_InitializeBattleState': (0x0C, 0x6983),
    'MapInfrared_RunInitialStateExchange': (0x0C, 0x699E),
    'MapInfrared_ExchangeTurnState': (0x0C, 0x69C4),
    'MapInfrared_SendInitialState': (0x0C, 0x69F1),
    'MapInfrared_ReceiveInitialState': (0x0C, 0x6A06),
    'MapInfrared_SendTurnState': (0x0C, 0x6A33),
    'MapInfrared_ReceiveTurnState': (0x0C, 0x6A48),
    'MapInfrared_Prepare4KiBTransfer': (0x0C, 0x6A62),
    'MapInfrared_SerializeActiveMapToTransferBuffer': (0x0C, 0x6A7C),
    'MapInfrared_DeserializeTransferBufferToActiveMap': (0x0C, 0x6AB0),
    'MapInfrared_SendSelectedMap': (0x0C, 0x6B00),
    'MapInfrared_ReceiveSelectedMap': (0x0C, 0x6B20),
}

def fail(msg):
    raise SystemExit('FAIL: ' + msg)

def bank_slice(blob, bank, start, end):
    off = bank * 0x4000 + (start - 0x4000)
    return blob[off:off + end - start]

for p in (BASE, BUILT, SYM, FIRE_SRC, IR_SRC, EXEC_SRC, BOMB_AVAIL, MENU_SRC, CMD_SRC):
    if not p.is_file():
        fail(f'missing {p.relative_to(ROOT)}')
retail = BASE.read_bytes()
built = BUILT.read_bytes()
for bank, start, end, sha1 in RANGES:
    expected = bank_slice(retail, bank, start, end)
    actual = bank_slice(built, bank, start, end)
    if hashlib.sha1(expected).hexdigest() != sha1:
        fail(f'retail fingerprint mismatch ${bank:02X}:${start:04X}-${end-1:04X}')
    if actual != expected:
        fail(f'linked bytes drift ${bank:02X}:${start:04X}-${end-1:04X}')
if hashlib.sha256(built).hexdigest() != EXPECTED_ROM_SHA256:
    fail('custom-English ROM hash drift')

fire = FIRE_SRC.read_text(encoding='utf-8')
ir = IR_SRC.read_text(encoding='utf-8')
for token in ('UnitAction_RunFireTargetSelection::', 'UnitAction_CheckBombAvailable::',
              'UNIT_TYPE_BOMBER', 'UNIT_TYPE_MERCENARY_BOMBER',
              'UNIT_TYPE_MERCENARY_MISSILE_FRIGATE', 'UNIT_TYPE_SUBMARINE_S',
              'assert @ == $43a8'):
    if token not in fire:
        fail(f'missing FIRE/BOMB contract {token}')
for token in ('MapInfrared_ExchangeTurnState::', 'MapInfrared_Prepare4KiBTransfer::',
              'MapInfrared_SendSelectedMap::', 'MapInfrared_ReceiveSelectedMap::',
              'wInfraredTransferBufferAddress', 'wInfraredTransferBufferBank',
              'MapGrid_RebuildTileCountsAndHQCoordinates', 'MapEconomy_RecalculateIncome',
              'assert @ == $6b44'):
    if token not in ir:
        fail(f'missing infrared contract {token}')

if 'farcall $0c, UnitAction_RunFireTargetSelection' not in EXEC_SRC.read_text(encoding='utf-8'):
    fail('FIRE executor is not symbolic')
if 'farcall $0c, UnitAction_CheckBombAvailable' not in BOMB_AVAIL.read_text(encoding='utf-8'):
    fail('BOMB availability is not symbolic')
if 'UnitActionMenu_AppendBombIfAvailable' not in MENU_SRC.read_text(encoding='utf-8'):
    fail('BOMB menu append is not symbolic')
cmd = CMD_SRC.read_text(encoding='utf-8')
if cmd.count('farcall $0c, MapInfrared_ExchangeTurnState') != 2:
    fail('END/RECV do not both use MapInfrared_ExchangeTurnState')
for obsolete in ('$418f', '$43a8', '$69c4'):
    for p in (EXEC_SRC, BOMB_AVAIL, CMD_SRC):
        if obsolete in p.read_text(encoding='utf-8').lower():
            fail(f'obsolete raw call {obsolete} remains in {p.name}')

sym = SYM.read_text(encoding='utf-8', errors='replace')
for name, (bank, addr) in PUBLIC.items():
    if not re.search(rf'(?mi)^{bank:02x}:{addr:04x}\s+{re.escape(name)}$', sym):
        fail(f'{name} is not linked at ${bank:02X}:${addr:04X}')

print('FIRE/BOMB + map infrared runtime verification: PASS')
print('  $0C:$418F-$43CE: 576 bytes FIRE targeting + BOMB availability')
print('  $0C:$6983-$6B43: 449 bytes infrared map-state exchange')
print('  former Unit Action $1A is behavior-backed as BOMB')
print(f'  linked ROM SHA-256: {EXPECTED_ROM_SHA256}')
