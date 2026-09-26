#!/usr/bin/env python3
"""Verify the Bank $0C reserve/CALL unit deployment runtime."""
from pathlib import Path
import hashlib, re

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'baserom.gbc'
BUILT = ROOT / 'GBWARS3.gbc'
SYM = ROOT / 'GBWARS3.sym'
SOURCE = ROOT / 'engine/unit/unit_deployment_runtime_7b89.asm'
SELECTED = ROOT / 'engine/map/ai/map_control_selected_map_command_controller_7226.asm'
CALL = ROOT / 'engine/map/ai/map_control_phase_command07_746d.asm'
POPUP = ROOT / 'engine/map/map_popup_presentation_runtime_5b43.asm'
BANK = 0x0c
START, END = 0x7b89, 0x7d68
SHA1 = 'fab00b8725d2e34b0ae8881844e83974c8ba7155'
ROM_SHA256 = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
PUBLIC = {
    'UnitDeployment_RunReservePlacementController': 0x7b89,
    'UnitDeployment_UpdateReserveCursorEligibility': 0x7bf2,
    'UnitDeployment_CommitAtCoordinates': 0x7c20,
    'UnitDeployment_CheckReservePlacementAvailable': 0x7c6a,
    'UnitDeployment_ClassifyUnitTypeDomain': 0x7c84,
    'UnitDeployment_RunCalledUnitPlacementController': 0x7cb4,
    'UnitDeployment_CheckCalledPlacementAvailable': 0x7d0c,
    'UnitDeployment_UpdateCalledCursorEligibility': 0x7d3a,
}

def fail(msg): raise SystemExit('FAIL: ' + msg)
def sl(blob):
    off = BANK * 0x4000 + (START - 0x4000)
    return blob[off:off + END - START]

for p in (BASE, BUILT, SYM, SOURCE, SELECTED, CALL, POPUP):
    if not p.is_file(): fail(f'missing {p.relative_to(ROOT)}')
retail, built = BASE.read_bytes(), BUILT.read_bytes()
if hashlib.sha1(sl(retail)).hexdigest() != SHA1: fail('retail deployment range SHA-1 mismatch')
if sl(built) != sl(retail): fail('linked deployment bytes drift')
if hashlib.sha256(built).hexdigest() != ROM_SHA256: fail('custom-English ROM hash drift')

src = SOURCE.read_text(encoding='utf-8')
for name in PUBLIC:
    if name + '::' not in src: fail(f'missing source entry {name}')
for token in ('MapUnitTransition_BeginDeployment', 'MapUnitTransition_EndDeployment',
              'UnitCreation_GetEligiblePropertyTypeNearHQ', 'MapAI_TestDomainCompatibility',
              'MovementData_GetCost', 'res UNIT_RECORD_STATUS_RESERVE_F, a', 'bit 1, a ; B button',
              'assert @ == $7d68'):
    if token not in src: fail(f'missing deployment contract {token}')
if 'bit UNIT_RECORD_STATUS_RESERVE_F, a' in src:
    fail('joypad B test is mislabeled as a unit-record status bit')

if 'farcall UnitDeployment_RunReservePlacementController' not in SELECTED.read_text(encoding='utf-8'):
    fail('selected-map reserve deployment caller not symbolic')
if 'farcall UnitDeployment_RunCalledUnitPlacementController' not in CALL.read_text(encoding='utf-8'):
    fail('CALL deployment caller not symbolic')
popup = POPUP.read_text(encoding='utf-8')
for token in ('MapUnitTransition_BeginDeployment::', 'MapUnitTransition_EndDeployment::',
              'MapUnitTransitionAnimationDeploymentBegin', 'MapUnitTransitionAnimationDeploymentEnd'):
    if token not in popup: fail(f'deployment transition identity missing: {token}')
if 'Variant0' in popup: fail('obsolete Variant0 transition identity remains')

sym = SYM.read_text(encoding='utf-8', errors='replace')
for name, addr in PUBLIC.items():
    if not re.search(rf'(?mi)^0c:{addr:04x}\s+{re.escape(name)}$', sym):
        fail(f'{name} is not linked at $0C:${addr:04X}')

print('Unit deployment runtime verification: PASS')
print(f'  $0C:$7B89-$7D67: {END-START} bytes, SHA-1 {SHA1}')
print('  reserve Unit List and selected-map CALL placement paths are source-owned')
print('  former map-transition Variant0 is behavior-backed as deployment')
print('  $7D68 custom-English resource boundary remains outside this module')
print(f'  linked ROM SHA-256: {ROM_SHA256}')
