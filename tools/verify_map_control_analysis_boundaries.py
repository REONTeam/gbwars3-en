#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'engine/map/ai/map_control_analysis_runtime.asm'
FORCE = ROOT / 'engine/map/ai/map_control_force.asm'
DOC = ROOT / 'docs/map/map_control_analysis_boundaries.md'
ROM_CANDIDATES = [ROOT/'baserom.gbc', Path('/mnt/data/baserom(4).gbc')]

ranges = [
    ('MapControl_ClearPhaseCellReference', 0x58F2, 0x590F, '26617e5d2d2c9c6748d5c5f5df77c0843936ab3f'),
    ('MapControl_LoadPhaseCellReference', 0x590F, 0x5928, '29d948549877f507bee700a3b811a19954718b0b'),
    ('MapControl_TestPhaseCellCandidate', 0x593D, 0x599B, 'b5a6438ca4d3d322e9a8875ce39cfd7247e72e4a'),
    ('MapControl_ClearNeighborPhaseReferences', 0x599B, 0x59D4, 'a85db063254b79f56d337c43509c686f5f43cc86'),
    ('MapControl_StageAnalysisCoordinates', 0x5B8A, 0x5BB5, 'a1c818310fadd148137e94791a39a43111556875'),
    ('MapControl_FindNearestEligibleCell', 0x5BB5, 0x5C42, 'b675fd55cd34fb6d14cac17ce4519ac7fc9429f8'),
    ('MapControl_UpdateDerivedCellState', 0x5CBC, 0x5CC0, 'e4f064d43cd1caa2907126c3139a2d7fd186994a'),
    ('MapControl_ClassifyDerivedCell', 0x5CC0, 0x5D06, '40efc864f60893e13d7f038c9c03c8add9142c16'),
    ('MapControl_RemoveDerivedBufferValue', 0x5D06, 0x5D2B, '7e08e69b9b314c60e3898b80b7854ae75051a46a'),
    ('MapControl_TestDerivedCellMatch', 0x5D2B, 0x5D56, 'd70ec0d9c14fe5ba599ccb1da5edf8f309759dbd'),
]

txt = SRC.read_text()
force = FORCE.read_text()
doc = DOC.read_text()
for label,start,end,sha in ranges:
    if not re.search(rf'^section\s+"[^"]+",\s*romx\[\${start:04x}\],\s*bank\[\$0d\]', txt, re.M|re.I):
        raise SystemExit(f'missing corrected section start for {label}: ${start:04X}')
    if not re.search(rf'^{re.escape(label)}::', txt, re.M):
        raise SystemExit(f'missing label {label}')
    if f'assert @ == ${end:04x}' not in txt.lower():
        raise SystemExit(f'missing corrected end assertion ${end:04X}')
    if sha not in txt:
        raise SystemExit(f'missing corrected SHA-1 for {label}')

for bad in ('romx[$590d]', 'romx[$599a]', 'romx[$5bb7]', 'romx[$5cc1]', 'romx[$5d2c]'):
    if bad in txt.lower():
        raise SystemExit(f'stale split-instruction boundary remains: {bad}')

for raw in ('ld de, $5cbc', 'ld de, $5cc0', 'call $5cc0', 'call $5d06'):
    if raw in force.lower():
        raise SystemExit(f'raw map-analysis dependency remains: {raw}')
for name in ('MapControl_UpdateDerivedCellState','MapControl_ClassifyDerivedCell','MapControl_RemoveDerivedBufferValue'):
    if name not in force:
        raise SystemExit(f'missing symbolic map-analysis dependency: {name}')
for phrase in ('inside instructions', '$590F', '$599B', '$5BB5', '$5CC0', '$5D2B', 'source-structure corrections only'):
    if phrase not in doc:
        raise SystemExit(f'missing boundary documentation: {phrase}')

rom = next((p for p in ROM_CANDIDATES if p.exists()), None)
if rom:
    data = rom.read_bytes()
    for label,start,end,sha in ranges:
        off = 0x0D * 0x4000 + (start - 0x4000)
        chunk = data[off:off+(end-start)]
        got = hashlib.sha1(chunk).hexdigest()
        if got != sha:
            raise SystemExit(f'{label} ROM hash mismatch: {got}')
    print('[ok] corrected map-control analysis boundaries match retail ROM')
else:
    print('[warn] retail ROM unavailable; structural boundary checks only')
print('[ok] map-analysis callers use corrected semantic labels')
