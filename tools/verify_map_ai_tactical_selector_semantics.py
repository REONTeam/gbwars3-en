#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); bank=rom[0x0d*0x4000:0x0e*0x4000]
src=(ROOT/'engine/map/ai/map_ai_tactical_selector_continuation.asm').read_text()
start,end=0x6325,0x6618
# the current source: collect labels and sizes.
pc=start; labels={'MapAI_PlanDirectAttackFamily0':0x6240,'MapAI_PlanDirectAttackFamily1':0x62B6}
lines=[]
for raw in src.splitlines():
    code=raw.split(';',1)[0].strip()
    if not code or code.startswith('include ') or code.startswith('section ') or code.startswith('assert '):
        continue
    if code.endswith('::'):
        labels[code[:-2]]=pc; lines.append(('label',code[:-2],raw)); continue
    if code.lower().startswith('db '):
        args=[x.strip() for x in code[3:].split(',')]
        pc += len(args); lines.append(('db',args,raw)); continue
    if code.lower().startswith('dw '):
        args=[x.strip() for x in code[3:].split(',')]
        pc += 2*len(args); lines.append(('dw',args,raw)); continue
    raise SystemExit(f'unparsed source line: {raw}')
if pc!=end: raise SystemExit(f'source ends ${pc:04X}, expected ${end:04X}')
# the current source: emit limited expressions used here.
consts={'UNIT_TYPE_BOMBER':35}
out=bytearray()
def val(tok):
    tok=tok.strip()
    if tok in consts: return consts[tok]
    if tok in labels: return labels[tok]
    if tok.startswith('$'): return int(tok[1:],16)
    return int(tok,0)
for kind,args,raw in lines:
    if kind=='label': continue
    if kind=='db':
        for a in args: out.append(val(a)&0xff)
    elif kind=='dw':
        for a in args:
            v=val(a); out += bytes((v&0xff,(v>>8)&0xff))
retail=bank[start-0x4000:end-0x4000]
if bytes(out)!=retail:
    for i,(a,b) in enumerate(zip(out,retail)):
        if a!=b: raise SystemExit(f'byte mismatch at ${start+i:04X}: source {a:02X} retail {b:02X}')
    raise SystemExit('source length/bytes differ from retail')
sha=hashlib.sha1(retail).hexdigest(); exp='7883df41e40c6fc736b23eac8270ec01c8b1cb7e'
if sha!=exp: raise SystemExit(f'hash mismatch {sha}')
expected={
'MapAI_RunBomberAreaAttackPlanner':0x6325,'MapAI_BomberPlannerOrder':0x632C,
'MapAI_PlanBomberAreaAttack':0x632E,'MapAI_FindBestBomberAreaTargetInSearchBounds':0x638F,
'MapAI_FindBestBomberAreaTargetFromAnalysisRecords':0x63E5,'MapAI_CountOpposingPropertiesInArea':0x6443,
'MapAI_RunOrderedUnitPlannerList':0x6472,'MapAI_UnitTypeIsInPlannerOrder':0x64AF,
'MapAI_DispatchPlannerForUnitType':0x64BD,'MapAI_UnitPlannerDispatchTable':0x64C4,
'MapAI_NoUnitPlanner':0x652C,'MapAI_GetEligiblePlannerUnitEncodedType':0x652D,
'MapAI_SelectUnitAndEnsureTacticalContext':0x6563,'MapAI_SelectUnitAndLoadTacticalContext':0x656D,
'MapAI_LoadSelectedUnitTacticalContext':0x6574,'MapAI_EnsureSelectedUnitMapContext':0x65A9,
'MapAI_CommitSelectedUnitTacticalPosition':0x65BE,'MapAI_ResolveSelectedUnitCarriedState':0x65DC,
'MapAI_ResetPlannerScratchAndInitializePlayers':0x6610,
}
for n,a in expected.items():
    if labels.get(n)!=a: raise SystemExit(f'{n} at {labels.get(n)}, expected ${a:04X}')
# Behavior locks: standard Bomber wrapper; area action dispatch; seven-cell opposing-property counter.
assert retail[0x632C-start:0x632E-start] == bytes([35,0])
assert bytes.fromhex('3e05eaecc5') in retail[0x632E-start:0x638F-start] or bytes.fromhex('cd8b46') in retail[0x632E-start:0x638F-start]
# $6443 counts current cell plus 6 neighbors when MapTile_GetPhaseOwnershipClass returns 1 (opposing property).
area=retail[0x6443-start:0x6472-start]
assert area.count(bytes.fromhex('fe01200114'))==2
assert bytes.fromhex('7bfe0620e7') in area
# 52-entry table excludes DUMMY and maps only types 1-4,35-36 to non-noop planners.
table=retail[0x64C4-start:0x652C-start]
assert len(table)==104
words=[table[i]|table[i+1]<<8 for i in range(0,104,2)]
assert words[:5]==[0,0x6240,0x6240,0x6240,0x62B6]
assert words[35:37]==[0x632E,0x632E]
assert all(words[i]==0x652C for i in list(range(5,35))+list(range(37,52)))
print(f'[ok] the current source final Bank $0D tactical semantics: {len(retail)} retail bytes exact, SHA-1 {sha}; 19 boundaries, Bomber area planning, ordered dispatch, and 52-entry planner table locked')
