#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys

ROOT = Path(__file__).resolve().parents[1]
if len(sys.argv) != 2:
    raise SystemExit('usage: verify_map_control_force_runtime.py baserom.gbc')
rom = Path(sys.argv[1]).read_bytes()
source = (ROOT / 'engine/map/ai/map_control_force.asm').read_text()
unit_source = (ROOT / 'engine/unit/unit_setup.asm').read_text()
symbols = (ROOT / 'symbols.asm').read_text()

def bank_slice(bank, start, end):
    off = bank * 0x4000 + (start - 0x4000)
    return rom[off:off + end - start]

checks = [
    (0x0D, 0x6618, 0x6650, '0fc4b2a0ffc4f8293f372b4a639827614aca3211'),
    (0x0D, 0x6650, 0x670E, 'f62632ca7668c8c2bb86df05daeecf6ce7ec47a6'),
    (0x0D, 0x670E, 0x6758, '83e054841691226dd03ca8b17ea88e9424b52510'),
    (0x12, 0x4043, 0x404F, '7ce497527666976ba38300d6cc46bc0e373f7789'),
]
for bank, start, end, sha in checks:
    data = bank_slice(bank, start, end)
    assert hashlib.sha1(data).hexdigest() == sha, (bank, start)

required = [
    'section "Map Player Control Initialization", romx[$6618], bank[$0d]',
    'MapControl_InitializePlayers::',
    'cp GAME_MODE_ATTRACTION',
    'cp GAME_MODE_VS',
    'cp GAME_MODE_STANDARD',
    'MapControl_InitializeRuntimeOnce::',
    'MapControl_InitializePhaseRuntime::',
    'MapControl_ClassifyForceBalance::',
    'section "Active Unit Force Value", romx[$670e], bank[$0d]',
    'UnitForceValue_CalcSideTotal::',
    'UnitForceValue_CalcUnitContribution::',
    'farcall UnitData_GetWord',
    'ld bc, UNIT_FORCE_VALUE_STORED_COST_DENOMINATOR',
]
for token in required:
    assert token in source, token
assert 'UnitData_GetWord::' in unit_source
assert 'assert @ == $404f' in unit_source.lower()
assert not re.search(r'sym\s+\$14,\s+\$(?:6618|670e|671f)', symbols, re.I)

# ROM0 map-controller farcalls prove the two setup entry points in the newly
# source-backed gap. RST $28 operands are bank, address low, address high.
for caller, target in [(0x2633, 0x6650), (0x2637, 0x6679)]:
    assert rom[caller:caller+4] == bytes([0xEF, 0x0D, target & 0xff, target >> 8]), (caller, target)

# Direct-call proof of physical Bank $0D attribution.
for caller, target in [(0x6614, 0x6618), (0x66B5, 0x670E), (0x66C1, 0x670E), (0x6715, 0x671F)]:
    off = 0x0D * 0x4000 + (caller - 0x4000)
    assert rom[off:off+3] == bytes([0xCD, target & 0xff, target >> 8]), (caller, target)

print('[ok] physical Bank $0D $6618-$6757 map-control/force runtime and Bank $12 UnitData word helper are ROM-locked')
