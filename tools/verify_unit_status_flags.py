#!/usr/bin/env python3
from pathlib import Path
import hashlib
root=Path(__file__).resolve().parents[1]
rom=(root/'baserom.gbc').read_bytes()
start,end=0x4585,0x4656
off=0x12*0x4000+(start-0x4000)
data=rom[off:off+end-start]
expected="2978c08db93f415f93a9518245532329d7b402f5"
sha=hashlib.sha1(data).hexdigest()
assert sha==expected,(sha,expected)
src=(root/'engine/unit/unit_setup.asm').read_text()
for token in ['Unit_SetEndTurnFlag::','Unit_ClearEndTurnFlagsForSide::','Unit_ClearSupplyFlagsForSide::','Unit_CountSuppliedForSide::','assert @ == $4656']:
    assert token in src,token
const=(root/'constants/unit_constants.inc').read_text()
for token in ['UNIT_RECORD_STATUS_SUPPLIED_F EQU 2','UNIT_RECORD_STATUS_END_TURN_F EQU 7']:
    assert token in const,token
print('[ok] Bank $12:$4585-$4655 status-flag maintenance: 209 retail bytes')
print('     SHA-1',sha)
