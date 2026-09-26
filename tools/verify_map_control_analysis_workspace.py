#!/usr/bin/env python3
from pathlib import Path
import hashlib, re
ROOT=Path(__file__).resolve().parents[1]
FORCE=ROOT/'engine/map/ai/map_control_force.asm'
HELP=ROOT/'engine/map/ai/map_control_resolution_helpers.asm'
SYMS=ROOT/'symbols.asm'
DOC=ROOT/'docs/map/map_control_analysis_workspace.md'
required={
'wMapControlRouteRiverX':0xDE9A,'wMapControlRouteRiverY':0xDE9B,
'wMapControlTransportPortX':0xDE9C,'wMapControlTransportPortY':0xDE9D,
'wMapControlTransportApproachX':0xDE9E,'wMapControlTransportApproachY':0xDE9F,
'wMapControlPhaseAnalysisFlags':0xDEA0,
}
compat={
'wMapControlReferenceCellX':'wMapControlRouteRiverX',
'wMapControlReferenceCellY':'wMapControlRouteRiverY',
'wMapControlPortCandidateX':'wMapControlTransportPortX',
'wMapControlPortCandidateY':'wMapControlTransportPortY',
'wMapControlPrimaryCandidateX':'wMapControlTransportPortX',
'wMapControlPrimaryCandidateY':'wMapControlTransportPortY',
'wMapControlOpposingHQRegionCandidateX':'wMapControlTransportApproachX',
'wMapControlOpposingHQRegionCandidateY':'wMapControlTransportApproachY',
'wMapControlSecondaryCandidateX':'wMapControlTransportApproachX',
'wMapControlSecondaryCandidateY':'wMapControlTransportApproachY',
}
symtxt=SYMS.read_text()
for k,v in required.items():
    pat=rf'^\s*{re.escape(k)}\s+equ\s+\${v:04x}\s*$'
    if not re.search(pat,symtxt,re.M|re.I): raise SystemExit(f'missing/wrong alias: {k}')
for k,target in compat.items():
    pat=rf'^\s*{re.escape(k)}\s+equ\s+{re.escape(target)}(?:\s*;.*)?$'
    if not re.search(pat,symtxt,re.M|re.I): raise SystemExit(f'missing compatibility alias: {k}')
ft=FORCE.read_text(); ht=HELP.read_text(); dt=DOC.read_text()
for raw in ('$9a, $de','$9b, $de','$9c, $de','$9d, $de','$9e, $de','$9f, $de','$a0, $de'):
    if raw in ft.lower()+ht.lower(): raise SystemExit(f'raw workspace address remains: {raw}')
if 'MapControl_GetCurrentPhaseSidePair::' not in ht: raise SystemExit('missing $5DA5 alternate entry')
if 'compatibility alias' not in ht: raise SystemExit('missing compatibility alias note')
for phrase in ('bit 0','bit 1','bit 2','lifetime-scoped'):
    if phrase not in dt: raise SystemExit(f'missing documentation phrase: {phrase}')
# the current source converts the refresh and route-river search to normal mnemonics, so
# byte identity is locked by the ROM-backed phase/resolution verifiers rather than
# by re-parsing only db rows here. Keep structural/semantic invariants local.
for token in (
    'MapControl_FindRouteRiverReference::',
    'wMapControlRouteRiverX',
    'wMapControlRouteRiverY',
    'MAP_CONTROL_ANALYSIS_INFANTRY_HQ_ROUTE_F',
    'MAP_CONTROL_ANALYSIS_READY_F',
    'MAP_CONTROL_ANALYSIS_PORT_AND_HQ_REGION_CANDIDATES_F',
):
    if token not in ft + ht + symtxt + (ROOT/'constants/map_constants.inc').read_text():
        raise SystemExit(f'missing current source semantic token: {token}')
print('[ok] map-control phase-analysis workspace aliases and current source flag semantics integrated')
