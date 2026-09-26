#!/usr/bin/env python3
from pathlib import Path
import hashlib,sys,re
root=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else root/'baserom.gbc').read_bytes()
src=(root/'engine/map/ai/map_control_resolution_helpers.asm').read_text()
force=(root/'engine/map/ai/map_control_force.asm').read_text()
def retail(bank,a,b):
    o=bank*0x4000+a-0x4000
    return rom[o:o+b-a]
checks=[
    (0x0b,0x51b5,0x51cc,'MapControl_ResolutionSceneRefresh','77f2c504c845015b9816a4dd7324874b775c4c9e'),
    (0x27,0x7e5f,0x7f17,'MapControl_PhaseResultDispatch','9530fe3b068a15474a6b242e0dc52187f697aa08'),
    (0x11,0x4d74,0x4d7b,'CampaignStats_IncrementResolutionCounter','fe2d0bae55e6e54cff6ab0c91536fbef6a52bdca'),
    (0x0b,0x69e6,0x6a23,'MapControl_ReinitializeAfterResolution','3e5c1444a2589a759aa90fd0f48515dadf34f610'),
    (0x0d,0x58a2,0x58f2,'MapControl_BuildPhaseAnalysisWorkspace','1797d3cef67b30e2d3324fc9e6ff76ba8f148bdc'),
    (0x0d,0x59d4,0x5a86,'MapControl_FindPhaseReferenceCell','8368231dda6caee6173cdcf59a61b63d2855bcb2'),
    (0x0d,0x5d9c,0x5db5,'MapControl_GetPhaseSidePair','268810a8dd5e6efb35005e2cddaaf72f3639c74d'),
    (0x0d,0x5a86,0x5ac2,'MapControl_FindBestPhaseUnit','1b420e635d36991b73898b17f821e03bc2823bcb'),
]
for bank,a,b,name,h in checks:
    data=retail(bank,a,b)
    assert hashlib.sha1(data).hexdigest()==h,(name,hex(a),hex(b))
    marker=name+'::'
    assert marker in src,name
    body=src.split(marker,1)[1].split('assert @ ==',1)[0]
    emitted=[]
    values={
        'wMapControlPrimaryCandidateX':0xDE9C,
        'wMapControlPrimaryCandidateY':0xDE9D,
        'wMapControlSecondaryCandidateX':0xDE9E,
        'wMapControlSecondaryCandidateY':0xDE9F,
        'wMapControlTransportPortX':0xDE9C,
        'wMapControlTransportPortY':0xDE9D,
        'wMapControlTransportApproachX':0xDE9E,
        'wMapControlTransportApproachY':0xDE9F,
        'wMapControlPortCandidateX':0xDE9C,
        'wMapControlPortCandidateY':0xDE9D,
        'wMapControlOpposingHQRegionCandidateX':0xDE9E,
        'wMapControlOpposingHQRegionCandidateY':0xDE9F,
        'wMapControlPhaseAnalysisFlags':0xDEA0,
        'MapControl_ClearPhaseCellReference':0x58F2,
        'MapControl_SeedMovementCostField':0x58F2,
        'MapControl_LoadPhaseCellReference':0x590F,
        'MapControl_LoadMovementCostFieldCell':0x590F,
        'MapControl_StorePhaseCellReference':0x5928,
        'MapControl_StoreMovementCostFieldCell':0x5928,
        'MapControl_TestPhaseCellCandidate':0x593D,
        'MapControl_TestMovementCostFieldCandidate':0x593D,
        'MapControl_BuildMovementCostField':0x58A2,
        'MapControl_FindNearestPortRecordToCurrentHQ':0x5AC2,
        'MapControl_FindNearestOpposingHQRegionCell':0x5B1A,
    }
    def eval_token(token):
        token=token.strip()
        if re.fullmatch(r'\$[0-9a-fA-F]{2}',token):
            return int(token[1:],16)
        m=re.fullmatch(r'(LOW|HIGH)\(([^)]+)\)',token)
        if m and m.group(2) in values:
            v=values[m.group(2)]
            return (v & 0xff) if m.group(1)=='LOW' else ((v>>8)&0xff)
        raise AssertionError(f'unhandled db token in {name}: {token}')
    for line in body.splitlines():
        code=line.split(';',1)[0].strip()
        if code.startswith('db '):
            emitted.extend(eval_token(x) for x in code[3:].split(','))
    if emitted:
        assert bytes(emitted)==data,(name,len(emitted),len(data))
for token in ['MapControl_TriggerLatePhaseResolution::','MapControl_RefreshPhaseState::']:
    assert token in force,token
print('[ok] the current source map-control resolution/refresh helper ranges exact; late-phase destinations source-owned')
