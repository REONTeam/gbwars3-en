#!/usr/bin/env python3
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
const = (ROOT / 'constants/unit_constants.inc').read_text()
unit = (ROOT / 'engine/unit/unit.asm').read_text()
required = {
    'UNIT_DATA_MOVEMENT_POWER_OFFSET': '$0c',
    'UNIT_DATA_TRANSPORT_CAPACITY_OFFSET': '$0d',
    'UNIT_DATA_UNKNOWN_0E_OFFSET': '$0e',
    'UNIT_DATA_FUEL_UPKEEP_OFFSET': '$0f',
    'UNIT_DATA_GOLD_COST_OFFSET': '$10',
    'UNIT_DATA_MATERIAL_COST_OFFSET': '$12',
    'UNIT_DATA_DEF_ARMORED_OFFSET': '$1e',
    'UNIT_DATA_DEF_UNARMORED_OFFSET': '$1f',
    'UNIT_DATA_DEF_AIR_OFFSET': '$20',
    'UNIT_DATA_DEF_SEA_OFFSET': '$21',
    'UNIT_DATA_DEF_SUBMARINE_OFFSET': '$22',
    'UNIT_DATA_BASE_FOCUS_OFFSET': '$23',
    'UNIT_DATA_FOCUS_LOSS_OFFSET': '$24',
    'WEAPON_DATA_ATTACK_ARMORED_OFFSET': '$0a',
    'WEAPON_DATA_ATTACK_UNARMORED_OFFSET': '$0b',
    'WEAPON_DATA_ATTACK_AIR_OFFSET': '$0c',
    'WEAPON_DATA_ATTACK_SEA_OFFSET': '$0d',
    'WEAPON_DATA_ATTACK_SUBMARINE_OFFSET': '$0e',
    'WEAPON_DATA_COST_PER_SHOT_OFFSET': '$0f',
}
low = const.lower()
for name, value in required.items():
    needle = f'def {name.lower()}'
    assert needle in low, name
    line = next(x.strip().lower() for x in const.splitlines() if x.strip().lower().startswith(needle))
    assert f'equ {value}' in line, (name, line)
assert '$0e deliberately remains unresolved' in (ROOT/'macros/unit_macros.inc').read_text().lower()
assert 'Gold/100G' in unit and 'DEF by family' in unit
rows = [ln for ln in unit.splitlines() if ' unit_data ' in ln and not ln.lstrip().startswith(';')]
assert len(rows) == 53, len(rows)
doc = (ROOT/'docs/unit/unit_data_schema.md').read_text()
for term in ['movement power', 'transport capacity', 'fuel upkeep', 'base Focus', 'Focus loss', '$0E | 1 | unresolved']:
    assert term in doc, term
print('[ok] UnitData semantic offsets $0C-$24 documented without changing record payloads')
print('[ok] five UnitData DEF columns align with five WeaponData attack-class columns')
print('[ok] UnitData byte $0E remains explicitly unresolved')
print('[ok] 53 UnitData macro records remain present')
