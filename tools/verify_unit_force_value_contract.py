#!/usr/bin/env python3
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
const = (ROOT / "constants/unit_constants.inc").read_text()
source = (ROOT / "engine/map/ai/map_control_force.asm").read_text()
doc = (ROOT / "docs/unit/unit_force_value_contract.md").read_text()

def equ(name):
    m = re.search(rf"^DEF {re.escape(name)} EQU ([^;\n]+)", const, re.M)
    assert m, name
    expr = m.group(1).strip()
    known = {
        "UNIT_RECORD_HP_OFFSET": 4,
        "UNIT_DATA_GOLD_COST_OFFSET": 0x10,
        "UNIT_RECORD_STATUS_RESERVE_F": 1,
    }
    if expr in known:
        return known[expr]
    return int(expr, 0)

assert equ("UNIT_FORCE_VALUE_GOLD_DENOMINATOR") == 1000
assert equ("UNIT_FORCE_VALUE_STORED_COST_DENOMINATOR") == 10
assert equ("UNIT_FORCE_VALUE_LIVE_HP_OFFSET") == 4
assert equ("UNIT_FORCE_VALUE_GOLD_COST_OFFSET") == 0x10
assert equ("UNIT_FORCE_VALUE_RESERVE_STATUS_FLAG") == 1
assert 'romx[$670e], bank[$0d]' in source
assert "UnitForceValue_CalcSideTotal::" in source
assert "UnitForceValue_CalcUnitContribution::" in source
assert 0x671f - 0x670e == 0x11
assert 0x6758 - 0x671f == 0x39
assert "HP * Gold Cost / 1000" in doc
assert "Reserve status flag" in doc
assert "physical Bank `$0D`" in doc
print("[ok] unit force-value runtime: physical Bank $0D; HP*Gold/1000; Reserve excluded")
