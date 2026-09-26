#!/usr/bin/env python3
"""Verify the Bank $0C SUPPLY action service runtime."""
from pathlib import Path
import hashlib, re

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'baserom.gbc'
BUILT = ROOT / 'GBWARS3.gbc'
SYM = ROOT / 'GBWARS3.sym'
SOURCE = ROOT / 'engine/unit/unit_supply_service_runtime_6b44.asm'
AVAIL = ROOT / 'engine/unit/unit_action_1b_availability_60c0.asm'
EXEC = ROOT / 'engine/unit/unit_action_executor_6283.asm'
BANK = 0x0c
START, END = 0x6b44, 0x6f70
SHA1 = '0a06de56513859518ab55155e7293e27c1bdd273'
ROM_SHA256 = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
PUBLIC = {
    'UnitSupply_CheckAvailable': 0x6b44,
    'UnitSupply_Execute': 0x6b77,
    'UnitSupply_CheckTerrainResupplyAvailable': 0x6bda,
    'UnitSupply_CheckTerrainRepairAvailable': 0x6c1b,
    'UnitSupply_CheckAdjacentOrCarriedAirResupplyAvailable': 0x6c5c,
    'UnitSupply_CheckCarriedAirRepairAvailable': 0x6cc0,
    'UnitSupply_CheckRefillCostAffordable': 0x6d07,
    'UnitSupply_CalculateRefillCosts': 0x6d3a,
    'UnitSupply_CheckRepairCostAffordable': 0x6da3,
    'UnitSupply_CalculateRepairCosts': 0x6dd6,
    'UnitSupply_GetRepairHPAmount': 0x6e2b,
    'UnitSupply_ApplyTerrainServices': 0x6e58,
    'UnitSupply_ApplyAdjacentOrCarriedAirServices': 0x6eb7,
    'UnitSupply_CommitStagedCosts': 0x6f57,
}

def fail(msg): raise SystemExit('FAIL: ' + msg)
def sl(blob):
    off = BANK * 0x4000 + (START - 0x4000)
    return blob[off:off + END - START]

for p in (BASE, BUILT, SYM, SOURCE, AVAIL, EXEC):
    if not p.is_file(): fail(f'missing {p.relative_to(ROOT)}')
retail, built = BASE.read_bytes(), BUILT.read_bytes()
if hashlib.sha1(sl(retail)).hexdigest() != SHA1: fail('retail SUPPLY range SHA-1 mismatch')
if sl(built) != sl(retail): fail('linked SUPPLY bytes drift')
if hashlib.sha256(built).hexdigest() != ROM_SHA256: fail('custom-English ROM hash drift')

src = SOURCE.read_text(encoding='utf-8')
for name in PUBLIC:
    if name + '::' not in src: fail(f'missing source entry {name}')
for token in ('wUnitSupplyGoldCost', 'wUnitSupplyMaterialCost', 'MapHPChange_PresentSignedDelta',
              'UnitAction_PresentActionEffect', 'UnitRecord_AddExperienceClamped', 'assert @ == $6f70'):
    if token not in src: fail(f'missing SUPPLY contract {token}')

if 'farcall UnitSupply_CheckAvailable' not in AVAIL.read_text(encoding='utf-8'):
    fail('action availability does not use UnitSupply_CheckAvailable')
if 'farcall UnitSupply_Execute' not in EXEC.read_text(encoding='utf-8'):
    fail('action executor does not use UnitSupply_Execute')
for path in (AVAIL, EXEC):
    low = path.read_text(encoding='utf-8').lower()
    if '$6b44' in low or '$6b77' in low: fail(f'obsolete raw SUPPLY address remains in {path.name}')

sym = SYM.read_text(encoding='utf-8', errors='replace')
for name, addr in PUBLIC.items():
    if not re.search(rf'(?mi)^0c:{addr:04x}\s+{re.escape(name)}$', sym):
        fail(f'{name} is not linked at $0C:${addr:04X}')

print('Unit SUPPLY service runtime verification: PASS')
print(f'  $0C:$6B44-$6F6F: {END-START} bytes, SHA-1 {SHA1}')
print('  terrain, adjacent-supplier, carried-air refill/repair paths are source-owned')
print('  Gold/Materials costing and signed HP presentation are symbolic')
print(f'  linked ROM SHA-256: {ROM_SHA256}')
