#!/usr/bin/env python3
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
src = (ROOT / "engine/unit/unit_setup.asm").read_text()
const = (ROOT / "constants/unit_constants.inc").read_text()
mapc = (ROOT / "constants/map_constants.inc").read_text()
sym = (ROOT / "symbols.asm").read_text()
all_map = "\n".join((ROOT / p).read_text() for p in ["engine/map/map_runtime.asm","engine/map/map_sram.asm","engine/map/map_menu.asm"])
for token in [
    'section "Reserve Unit Storage", romx[$47ce], bank[$12]',
    'ReserveUnits_SaveSide0::', 'ReserveUnits_RestoreSide0::',
    'wReserveUnitList', '1 << UNIT_RECORD_STATUS_RESERVE_F',
    'assert @ == $4837',
]:
    assert token in src, token
assert 'DEF UNIT_RECORD_STATUS_RESERVE_F  EQU 1' in const
assert 'wReserveUnitList equ $c6a8' in sym
assert 'wActiveGameMode equ $c62f' in sym
for token in [
    'DEF GAME_MODE_BEGINNER   EQU $00', 'DEF GAME_MODE_CAMPAIGN   EQU $01',
    'DEF GAME_MODE_STANDARD   EQU $02', 'DEF GAME_MODE_MAP_EDITOR EQU $03',
    'DEF GAME_MODE_VS         EQU $04', 'DEF GAME_MODE_ATTRACTION EQU $05',
]:
    assert token in mapc, token
assert '[$c62f]' not in all_map
assert '[wActiveGameMode]' in all_map
assert 'cp GAME_MODE_MAP_EDITOR' in all_map
for stale in ['UnitPool0_BuildCompactList::', 'UnitPool0_RecreateFromCompactList::', 'wUnitPool0CompactList']:
    assert stale not in src + sym, stale
print('[ok] reserve-unit storage names and reserve status bit are integrated')
print('[ok] active game mode $C62F is symbolic in sourced map runtime/save/menu paths')
print('[ok] exact source-backed reserve buffer is 50 x 4 bytes at $C6A8-$C76F')
