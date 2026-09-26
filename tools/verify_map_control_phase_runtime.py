#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
root=Path(__file__).resolve().parents[1]
rom=(Path(sys.argv[1]) if len(sys.argv)>1 else root/'baserom.gbc').read_bytes()
src=(root/'engine/map/ai/map_control_force.asm').read_text()
def retail(bank,s,e):
    o=bank*0x4000+s-0x4000
    return rom[o:o+e-s]
checks=[
 (0x0d,0x4b91,0x4be1,'2de42d0a5873a93814d51889c3b377ba0aa5df90'),
 (0x0d,0x5c42,0x5cbc,'53a677d7a489420bb0bedfd1ef8bb6fc99811fae'),
 (0x0d,0x6758,0x6870,'e6ab4c51bd2743355f82eb777363d3bf1bd4322b'),
 (0x0d,0x6870,0x68c2,'e2b427885bb831b120514cc08f37916948c91f76'),
 (0x0d,0x6618,0x68c2,'f8a97a0e9fb7389e905bae5d0f5e69c6fcf8317e'),
]
for bank,a,b,h in checks:
    assert hashlib.sha1(retail(bank,a,b)).hexdigest()==h,(hex(a),hex(b))
for token in [
 'MapControl_RebuildCaptureTargetMask::','MapControl_RebuildUnitEligibilityMask::','MapControl_BuildMapAnalysisBuffer::',
 'MapControl_GetPhaseForceRelation::','MapControl_UpdateForceStateIndicator::',
 'MapControl_CheckLatePhaseResolution::','MapControl_RefreshPhaseState::',
 'call MapControl_BuildMapAnalysisBuffer','call MapControl_RebuildCaptureTargetMask',
 'call MapControl_RefreshPhaseState','farcall $0b, MapControl_IsCaptureTargetRejected','call Bitfield_Set',
 'assert @ == $4be1','assert @ == $5cbc','assert @ == $68c2']:
    assert token in src,token
for raw in ['call $4b91','call $5c42','call $6870']:
    assert raw not in src,raw
assert retail(0x0d,0x68c2,0x68ca)==b'\xff'*8
print('[ok] map-control phase runtime/dependencies: $4B91-$4BE0, $5C42-$5CBB, $6758-$68C1 exact')
