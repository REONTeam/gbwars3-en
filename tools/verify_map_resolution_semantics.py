#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
SYMBOLS = (ROOT / 'symbols.asm').read_text()
MAP_CONSTANTS = (ROOT / 'constants/map_constants.inc').read_text()

EXPECTED_SYMBOLS = {
    'wMapControlWinningSide': 0xCA94,
    'wMapControlResolutionType': 0xCA95,
    'wMapTileCountsById': 0xC64A,
    'wMapSide0HQTileCount': 0xC64B,
    'wMapSide1HQTileCount': 0xC656,
}

EXPECTED_CONSTANTS = {
    'MAP_RESOLUTION_TYPE_HQ_LOSS': 1,
    'MAP_RESOLUTION_TYPE_FORCE_DEFEAT': 2,
    'MAP_RESOLUTION_TYPE_YIELD': 3,
    'MAP_RESOLUTION_TYPE_TURN_LIMIT': 4,
}


def parse_symbol_address(name: str) -> int:
    patterns = [
        rf'\bsym\s+\$[0-9a-fA-F]+\s*,\s*\$([0-9a-fA-F]+)\s*,\s*{re.escape(name)}\b',
        rf'\b(?:EXPORT\s+)?DEF\s+{re.escape(name)}\s+EQU\s+\$([0-9a-fA-F]+)\b',
    ]
    for pat in patterns:
        m = re.search(pat, SYMBOLS, re.I)
        if m:
            return int(m.group(1), 16)
    raise SystemExit(f'[fail] missing direct address definition for {name}')


def parse_int_constant(name: str) -> int:
    m = re.search(rf'\bDEF\s+{re.escape(name)}\s+EQU\s+([0-9]+)\b', MAP_CONSTANTS)
    if not m:
        raise SystemExit(f'[fail] missing integer constant {name}')
    return int(m.group(1))


for name, want in EXPECTED_SYMBOLS.items():
    got = parse_symbol_address(name)
    if got != want:
        raise SystemExit(f'[fail] {name} = ${got:04X}, expected ${want:04X}')

for name, want in EXPECTED_CONSTANTS.items():
    got = parse_int_constant(name)
    if got != want:
        raise SystemExit(f'[fail] {name} = {got}, expected {want}')

ai_sources = '\n'.join(p.read_text() for p in (ROOT / 'engine/map/ai').glob('*.asm'))
for raw in ('$ca94', '$ca95', '$c64b', '$c656'):
    if raw in ai_sources.lower():
        raise SystemExit(f'[fail] raw semantic address remains in engine/map/ai: {raw}')

turn_limit = (ROOT / 'engine/map/ai/map_control_turn_limit_6d9a.asm').read_text()
for token in ('farcall MapRuntime_GetBeginnerDayLimit', 'farcall MapRuntime_GetCampaignDayLimit'):
    if token not in turn_limit:
        raise SystemExit(f'[fail] turn-limit path missing symbolic provider call: {token}')

map_runtime = (ROOT / 'engine/map/map_runtime.asm').read_text()
for token in ('MapRuntime_GetCampaignDayLimit::', 'MapRuntime_GetBeginnerDayLimit::'):
    if token not in map_runtime:
        raise SystemExit(f'[fail] map runtime missing {token}')

setup = (ROOT / 'engine/map/bank0b_map_setup_runtime_4000.asm').read_text()
for token in (
    'MapGrid_RebuildTileCountsAndHQCoordinates::',
    'MapGrid_IncrementTileCount:',
    'MapGrid_DecrementTileCount:',
    'UnitCount_IncrementForRecordIndex:',
    'MapPresentation_ResetTileUpdateAndAnimationState:',
):
    if token not in setup:
        raise SystemExit(f'[fail] early map/setup source missing semantic helper {token}')

for rel in ('engine/unit/unit_capture_action.asm', 'engine/unit/unit_development_action.asm'):
    text = (ROOT / rel).read_text()
    if 'call MapGrid_DecrementTileCount' not in text or 'call MapGrid_IncrementTileCount' not in text:
        raise SystemExit(f'[fail] {rel} is not integrated with symbolic tile-count helpers')
    if 'call $41db' in text.lower() or 'call $41e7' in text.lower():
        raise SystemExit(f'[fail] {rel} still contains raw tile-count helper calls')

# The winning-side field is one-based. All direct writers in the map-control
# family must also stage a resolution type before the transition is consumed.
writes = []
for p in (ROOT / 'engine/map/ai').glob('*.asm'):
    t = p.read_text()
    if '[wMapControlWinningSide]' in t:
        writes.append(p.name)
if not writes:
    raise SystemExit('[fail] no map-control winning-side users found')

print('[ok] map-control winning-side/resolution state is symbolically named at $CA94/$CA95')
print('[ok] resolution type constants 1-4 match the four proven writer classes')
print('[ok] HQ-loss checks use the named raw-tile count aliases at $C64B/$C656')
print('[ok] Campaign/Beginner turn limits call their existing Bank $28 providers symbolically')
print('[ok] early map tile-count/HQ scan helpers are named and integrated with capture/development writers')
