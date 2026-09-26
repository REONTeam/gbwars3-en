#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'baserom.gbc'
rom = ROM.read_bytes()


def off(bank, addr):
    return bank * 0x4000 + (addr - 0x4000)


def check_range(bank, start, end, expected, label):
    data = rom[off(bank, start):off(bank, end)]
    assert len(data) == end - start, f'{label} retail length changed'
    got = sha1(data).hexdigest()
    assert got == expected, f'{label} retail fingerprint changed: {got}'


check_range(0x0B, 0x7226, 0x746D,
            '96298876a77f7b4299c6fafe68b0bef62e485f44',
            'selected-map command controller')
check_range(0x0B, 0x746D, 0x74FA,
            'd4efc78656d877b2afa9371b861b79ba7cd466ad',
            'map-phase/CALL command runtime')
check_range(0x0B, 0x5907, 0x59BD,
            '713226f25ab3a0efe816497377adb30bfbbe8498',
            'alternate Unit Creation/CALL selector tail')

controller = (ROOT / 'engine/map/ai/map_control_selected_map_command_controller_7226.asm').read_text()
for token in (
    'MapControl_RunSelectedMapCommandController::',
    'MapControl_ExecuteSelectedMapCommandUnit::',
    'MapControl_ExecuteSelectedMapCommandStatus::',
    'MapControl_ExecuteSelectedMapCommandOption::',
    'MapControl_ExecuteSelectedMapCommandYield::',
    'MapControl_ExecuteSelectedMapCommandInterrupt::',
    'MapControl_ExecuteSelectedMapCommandSave::',
    'MapControl_RunSelectedMapRetryPrompt::',
    'MapControl_DrawSelectedMapRetryChoice::',
    'MapControl_ExecuteSelectedMapCommandEnd::',
    'MapControl_ExecuteSelectedMapCommandReceive::',
    'MapControl_SelectedMapRetryPromptLine0::',
    'MapControl_SelectedMapRetryPromptLine1::',
    'MapControl_SelectedMapRetryPromptLine2::',
    'call MapControl_ExecuteSelectedMapCommandCall',
    'call MapControl_ExecuteSelectedMapCommandMap',
    'assert @ == $746d',
):
    assert token in controller, f'missing selected-map controller token: {token}'

# Only the two-choice coordinate table and three custom-encoded text records
# remain as data. Executable controller code must stay mnemonic.
db_lines = [ln.strip() for ln in controller.splitlines()
            if ln.split(';', 1)[0].strip().startswith('db ')]
assert len(db_lines) == 5, f'unexpected raw-data line count in selected-map controller: {len(db_lines)}'
assert all('$' in ln for ln in db_lines), 'retry prompt data encoding changed unexpectedly'

phase = (ROOT / 'engine/map/ai/map_control_phase_command07_746d.asm').read_text()
for token in (
    'MapControl_AdvanceMapPhase::',
    'MapControl_ExecuteSelectedMapCommandCall::',
    'cp UNITS_PER_SIDE',
    'call UnitCreation_RunAlternateSelectionController',
    'farcall $12, Unit_IncrementBuiltCountForEncodedSide',
    'farcall $12, MapUnit_CreateInitial',
    'farcall $12, Unit_SetEndTurnFlag',
    'farcall $11, CampaignStats_MarkProcuredUnit',
    'farcall $11, CampaignStats_SetProcuredFlag35',
    'farcall $0b, MapControl_ReinitializeAfterResolution',
    'MapControl_CommandErrorSFX74F4::',
    'assert @ == $74fa',
):
    assert token in phase, f'missing phase/CALL runtime token: {token}'
assert not re.search(r'^\s*db\s', phase, re.M), 'phase/CALL runtime still contains raw db code'

creation = (ROOT / 'engine/unit/unit_creation_selection_runtime_57d6.asm').read_text()
assert 'UnitCreation_RunAlternateSelectionController::' in creation
assert 'farcall $12, UnitPurchase_AppendMercenaryTypeRange' in creation
assert '$5909 is a closely related alternate' not in creation, 'stale incorrect $5909 entry documentation remains'
alternate = creation.split('UnitCreation_RunAlternateSelectionController::', 1)[1].split('assert @ == $59bd', 1)[0]
assert not re.search(r'^\s*db\s', alternate, re.M), 'CALL alternate selector still contains raw db code'
for token in (
    'call UnitCreation_DrawMenuLabels',
    'call UnitCreation_DrawSelectedUnitDetails',
    'call MapEconomy_CloseStatusPanel',
    'call MapControl_ReinitializeAfterResolution',
    'ld a, [wBuyableUnitCount]',
):
    assert token in alternate, f'missing CALL selector source token: {token}'

constants = (ROOT / 'constants/map_constants.inc').read_text()
expected_constants = {
    'MAP_COMMAND_UNIT': 0x01,
    'MAP_COMMAND_STATUS': 0x02,
    'MAP_COMMAND_OPTION': 0x03,
    'MAP_COMMAND_YIELD': 0x04,
    'MAP_COMMAND_SAVE': 0x05,
    'MAP_COMMAND_MAP': 0x06,
    'MAP_COMMAND_CALL': 0x07,
    'MAP_COMMAND_END': 0x08,
    'MAP_COMMAND_RECEIVE': 0x19,
    'MAP_COMMAND_RETRY': 0x1D,
    'MAP_COMMAND_INTERRUPT': 0x1E,
}
for name, value in expected_constants.items():
    pat = rf'DEF\s+{re.escape(name)}\s+EQU\s+\${value:02x}'
    assert re.search(pat, constants, re.I), f'missing/changed map-command constant: {name}'

menu = (ROOT / 'engine/map/ai/map_control_selected_map_command_menu_717d.asm').read_text()
for token in (
    'MapControl_TestEndCommandAvailability::',
    'MapControl_TestSaveCommandAvailability::',
    'ld a, MAP_COMMAND_UNIT',
    'ld a, MAP_COMMAND_CALL',
    'ld a, MAP_COMMAND_RETRY',
    'ld a, MAP_COMMAND_INTERRUPT',
):
    assert token in menu, f'missing symbolic selected-map menu token: {token}'

# Hard retail entry anchors for the newly named command family.
anchors = {
    0x7226: bytes.fromhex('cd7d71'),
    0x72C7: bytes.fromhex('cd6421'),
    0x730A: bytes.fromhex('cd6421'),
    0x7318: bytes.fromhex('cd6421'),
    0x7323: bytes.fromhex('cd6421'),
    0x733E: bytes.fromhex('cd6421'),
    0x7359: bytes.fromhex('fa2fc6'),
    0x737D: bytes.fromhex('cd0047'),
    0x7408: bytes.fromhex('f5fa21c0'),
    0x743C: bytes.fromhex('ef0cb472'),
    0x7462: bytes.fromhex('ef0cc469'),
    0x746D: bytes.fromhex('fa33c6'),
    0x7486: bytes.fromhex('fa33c6'),
    0x74F4: bytes.fromhex('3e03cd4438'),
}
for addr, expected in anchors.items():
    got = rom[off(0x0B, addr):off(0x0B, addr) + len(expected)]
    assert got == expected, f'retail anchor changed at $0B:{addr:04X}'

print('Selected-map command controller $7226-$746C retail fingerprint: [ok]')
print('Map-phase/CALL command runtime $746D-$74F9 retail fingerprint: [ok]')
print('CALL selector entry corrected to retail $5907 and symbolic mercenary-list setup: [ok]')
print('Action-menu command IDs promoted to stable player-facing constants: [ok]')
print('Selected-map command executable source is mnemonic; only retry prompt data remains raw: [ok]')
