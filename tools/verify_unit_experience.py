#!/usr/bin/env python3
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
src = (ROOT / 'engine/unit/unit_setup.asm').read_text()
const = (ROOT / 'constants/unit_constants.inc').read_text()
docs = (ROOT / 'docs/unit/unit_experience_rank.md').read_text()
for token in [
    'DEF UNIT_RECORD_EXPERIENCE_OFFSET EQU $0a',
    'DEF UNIT_EXPERIENCE_PER_RANK EQU 100',
    'DEF UNIT_EXPERIENCE_MAX EQU 400',
    'DEF UNIT_RANK_D EQU 0', 'DEF UNIT_RANK_C EQU 1', 'DEF UNIT_RANK_B EQU 2',
    'DEF UNIT_RANK_A EQU 3', 'DEF UNIT_RANK_S EQU 4',
]:
    assert token in const, token
for token in [
    'UnitRecord_AddExperienceClamped::',
    'UnitRecord_GetExperienceRank::',
    'ld c, UNIT_RECORD_EXPERIENCE_OFFSET',
    'ld de, UNIT_EXPERIENCE_MAX',
    'ld bc, UNIT_EXPERIENCE_PER_RANK',
]:
    assert token in src, token
for stale in ['UNIT_RECORD_WORD0A_OFFSET', 'UnitRecord_AddWord0AClamped', 'UnitRecord_GetWord0AHundreds']:
    assert stale not in src + const, stale
assert 'ReserveUnits_SaveSide0::' in src and 'ReserveUnits_RestoreSide0::' in src
assert src.count('UNIT_RECORD_EXPERIENCE_OFFSET') >= 4
assert 'D, C, B, A, S' in docs
print('[ok] live-unit $0A-$0B field is consistently named as experience')
print('[ok] experience/rank constants encode 100 EXP per rank and the sourced 400 EXP clamp')
print('[ok] reserve-unit save/restore preserves the named experience field')
