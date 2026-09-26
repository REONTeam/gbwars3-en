#!/usr/bin/env python3
from pathlib import Path
root = Path(__file__).resolve().parents[1]
src = (root / 'engine/unit/unit_setup.asm').read_text()
const = (root / 'constants/unit_constants.inc').read_text()
sym = (root / 'symbols.asm').read_text()
required_src = [
    'UnitData_CheckLoadingCompatibility::',
    'UNIT_DATA_CARRYING_TYPE_OFFSET',
    'UNIT_DATA_CARRIED_TYPE1_OFFSET',
    'UNIT_DATA_CARRIED_TYPE2_OFFSET',
    'UNIT_DATA_CARRIED_TYPE3_OFFSET',
    'Unit_SetEndTurnFlag::',
    'Unit_ClearEndTurnFlagsForSide::',
    'Unit_ClearSupplyFlagsForSide::',
    'Unit_CountSuppliedForSide::',
    'UNIT_RECORD_STATUS_END_TURN_F',
    'UNIT_RECORD_STATUS_SUPPLIED_F',
    'wUnitLostCountSide0',
    'wUnitLostCountSide1',
]
for token in required_src:
    assert token in src, token
required_const = [
    'DEF UNIT_DATA_CARRYING_TYPE_OFFSET EQU $1a',
    'DEF UNIT_DATA_CARRIED_TYPE1_OFFSET EQU $1b',
    'DEF UNIT_DATA_CARRIED_TYPE2_OFFSET EQU $1c',
    'DEF UNIT_DATA_CARRIED_TYPE3_OFFSET EQU $1d',
    'DEF UNIT_RECORD_STATUS_SUPPLIED_F EQU 2',
    'DEF UNIT_RECORD_STATUS_END_TURN_F EQU 7',
]
for token in required_const:
    assert token in const, token
for token in ['sym $00, $c8b7, wUnitLostCountSide0', 'sym $00, $c8b9, wUnitLostCountSide1']:
    assert token in sym, token
stale = [
    'UnitData_CompareDefinitionRelation',
    'UNIT_DATA_RELATION_CLASS_OFFSET',
    'UNIT_DATA_RELATION_SLOT1_OFFSET',
    'UNIT_DATA_RELATION_SLOT2_OFFSET',
    'UNIT_DATA_RELATION_SLOT3_OFFSET',
    'Unit_SetStatusFlag7',
    'Unit_ClearStatusFlag7ForSide',
    'Unit_ClearStatusFlag2ForSide',
    'Unit_CountStatusFlag2ForSide',
    'UNIT_RECORD_STATUS_FLAG2_F',
    'UNIT_RECORD_STATUS_FLAG7_F',
    'wUnitDeletionCounterSide0',
    'wUnitDeletionCounterSide1',
]
active = '\n'.join([src, const, sym])
for token in stale:
    assert token not in active, token
print('[ok] Unit transport/status/loss semantic names are consistent')
