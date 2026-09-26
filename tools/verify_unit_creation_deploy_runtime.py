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


check_range(0x0B, 0x57D6, 0x5907,
            '865581cc5ee40de3e565c55a398e9da621e05a32',
            'standard Unit Creation/DEPLOY selector')
check_range(0x0B, 0x5907, 0x59BD,
            '713226f25ab3a0efe816497377adb30bfbbe8498',
            'alternate Unit Creation/CALL selector')
check_range(0x0B, 0x5A9C, 0x5C1F,
            'ec0f93c63e9def1b3bdea99eb2668f8555508c1e',
            'Unit Creation selected-unit detail runtime')
check_range(0x0B, 0x5CCF, 0x5D6C,
            '22cb7acdb09d9f844b9c1d56bb9c1ea84bfe7b34',
            'carried-child selection controller')

selection = (ROOT / 'engine/unit/unit_creation_selection_runtime_57d6.asm').read_text()
standard = selection.split('UnitCreation_RunSelectionController::', 1)[1].split(
    'assert @ == $5907', 1)[0]
alternate = selection.split('UnitCreation_RunAlternateSelectionController::', 1)[1].split(
    'assert @ == $59bd', 1)[0]

assert not re.search(r'^\s*db\s', standard, re.M), 'DEPLOY selector still contains raw db code'
assert not re.search(r'^\s*db\s', alternate, re.M), 'CALL selector still contains raw db code'

for token in (
    'farcall $12, UnitPurchase_BuildPropertyUnitList',
    'call UnitCreation_DrawMenuLabels',
    'call UnitCreation_DrawSelectedUnitDetails',
    'call MapEconomy_DrawStatusPanel',
    'call UnitCreation_CheckPurchaseAffordability',
    'cp UNIT_CREATION_PURCHASE_NO_GOLD',
    'cp UNIT_CREATION_PURCHASE_NO_MATERIAL',
    'cp UNIT_CREATION_PURCHASE_UNIT_LIMIT',
    'call UnitCreation_ApplyPurchaseResourceCosts',
    'farcall $12, Unit_IncrementBuiltCountForEncodedSide',
    'farcall $12, MapUnit_CreateInitial',
    'farcall $12, Unit_SetEndTurnFlag',
    'farcall $11, CampaignStats_MarkProcuredUnit',
    'assert @ == $5907',
):
    assert token in selection, f'missing DEPLOY selector token: {token}'

for token in (
    'farcall $12, UnitPurchase_AppendMercenaryTypeRange',
    'assert @ == $59bd',
):
    assert token in selection, f'missing CALL selector token: {token}'

details = (ROOT / 'engine/unit/unit_creation_details_runtime_5a9c.asm').read_text()
for token in (
    'UnitCreation_DrawSelectedUnitDetails::',
    'ld hl, wBuyableUnitList',
    'ld [wUnitCreationSelectedEncodedTypeSide], a',
    'call UnitCreation_DrawSelectedUnitGraphic',
    'farcall $12, UnitData_CopyNameToBuffer',
    'ld c, UNIT_DATA_TRANSPORT_CAPACITY_OFFSET',
    'ld c, UNIT_DATA_GOLD_COST_OFFSET',
    'ld c, UNIT_DATA_MATERIAL_COST_OFFSET',
    'ld c, UNIT_DATA_MOVEMENT_POWER_OFFSET',
    'ld c, UNIT_DATA_MAX_FUEL_OFFSET',
    'ld c, UNIT_DATA_WEAPON1_OFFSET',
    'ld c, UNIT_DATA_WEAPON2_OFFSET',
    'ld c, WEAPON_DATA_MIN_RANGE_OFFSET',
    'ld c, WEAPON_DATA_MAX_RANGE_OFFSET',
    'call DrawNumber5Digits',
    'call DrawNumber3Digits',
    'UnitCreation_DrawResourceComparisonRow:',
    'UnitCreation_DetailBlankTileRow:',
    'assert @ == $5c1f',
):
    assert token in details, f'missing Unit Creation detail token: {token}'

# Only the one-byte retail padding and the eight-byte blank tile row remain raw.
db_lines = [ln.split(';', 1)[0].strip() for ln in details.splitlines()
            if ln.split(';', 1)[0].strip().startswith('db ')]
assert len(db_lines) == 2, f'unexpected raw-data line count in detail runtime: {len(db_lines)}'
assert db_lines[0].lower() == 'db $00', 'detail padding byte changed'
assert db_lines[1].lower() == 'db $80, $80, $80, $80, $80, $80, $80, $00', \
    'detail blank-row data changed'

anchors = {
    0x57D6: bytes.fromhex('ef12f443'),
    0x57E2: bytes.fromhex('cd0047'),
    0x5806: bytes.fromhex('f092cb4f'),
    0x581E: bytes.fromhex('cd6048'),
    0x583F: bytes.fromhex('3e09cd4438'),
    0x5858: bytes.fromhex('3e09cd4438'),
    0x5870: bytes.fromhex('3e0ccd4438'),
    0x5883: bytes.fromhex('fa41c9cd1f5c'),
    0x58A6: bytes.fromhex('ef124142'),
    0x58AA: bytes.fromhex('ef12e341'),
    0x58AE: bytes.fromhex('ef128545'),
    0x58E0: bytes.fromhex('3e03cd4438'),
    0x5907: bytes.fromhex('ef125844'),
    0x5A9D: bytes.fromhex('c5d5e5210ccd'),
    0x5AB3: bytes.fromhex('cd895c'),
    0x5BC3: bytes.fromhex('2128cdcd5333'),
    0x5C17: bytes.fromhex('8080808080808000'),
}
for addr, expected in anchors.items():
    got = rom[off(0x0B, addr):off(0x0B, addr) + len(expected)]
    assert got == expected, f'retail anchor changed at $0B:{addr:04X}'

print('Standard Unit Creation/DEPLOY selector $57D6-$5906 retail fingerprint: [ok]')
print('Alternate Unit Creation/CALL selector $5907-$59BC retail fingerprint: [ok]')
carried = (ROOT / 'engine/unit/unit_transport_carried_child_selection_5ccf.asm').read_text()
assert not re.search(r'^\s*db\s', carried, re.M), 'carried-child selector still contains raw db code'
for token in (
    'UnitTransport_RunCarriedChildSelection::',
    'call UnitTransport_ResolveSelectedCarriedChildAndRedraw',
    'ld hl, wCarriedUnitListCount',
    'bit UNIT_RECORD_STATUS_END_TURN_F, a',
    'ld a, [wUnitRecordScratch + UNIT_RECORD_CARRIER_INDEX_OFFSET]',
    'farcall $12, UnitRecord_CopyToScratch',
    'call UnitSelection_RefreshScratchUnitMapPresentation',
    'call UnitSelection_HideInteractionPresentation',
    'assert @ == $5d6c',
):
    assert token in carried, f'missing carried-child selector token: {token}'

print('Selected-unit detail runtime $5A9C-$5C1E retail fingerprint: [ok]')
print('Carried-child selection controller $5CCF-$5D6B retail fingerprint: [ok]')
print('DEPLOY/CALL executable selectors are mnemonic: [ok]')
print('Unit Creation detail renderer is mnemonic; only padding/blank-row data remains raw: [ok]')
print('Carried-child selection controller is mnemonic and uses the established unit-record status API: [ok]')
