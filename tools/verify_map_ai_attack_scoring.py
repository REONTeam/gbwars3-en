#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); bank=rom[0x0d*0x4000:0x0e*0x4000]
src=(ROOT/'engine/map/ai/map_ai_attack_scoring.asm').read_text()
start,end=0x4749,0x4A43
# Reconstruct all db payload and derive label addresses from emitted byte count.
pc=start; out=bytearray(); labels={}
for raw in src.splitlines():
    code=raw.split(';',1)[0].strip()
    if not code or code.startswith('include ') or code.startswith('section ') or code.startswith('assert '):
        continue
    if code.endswith('::'):
        labels[code[:-2]]=pc; continue
    if code.lower().startswith('db '):
        vals=[int(x,16) for x in re.findall(r'\$([0-9a-fA-F]{2})',code)]
        out.extend(vals); pc+=len(vals); continue
    raise SystemExit(f'unparsed source line: {raw}')
if pc!=end: raise SystemExit(f'source ends ${pc:04X}, expected ${end:04X}')
retail=bank[start-0x4000:end-0x4000]
if bytes(out)!=retail: raise SystemExit('attack-scoring source bytes differ from retail')
sha=hashlib.sha1(retail).hexdigest(); exp='a2fbeea445c3282f1771ab3356f24b66d6805946'
if sha!=exp: raise SystemExit(f'hash mismatch {sha}')
expected={
'MapAI_SelectAdjacentAttackTargetByScore':0x4749,
'MapAI_TestPackedTacticalScoreOrdering':0x47B0,
'MapAI_BuildAttackableEnemyMask':0x47D1,
'MapAI_BuildWeaponCapabilityScratch':0x481F,
'MapAI_GetWeaponTargetMaskAndRange':0x489E,
'MapAI_BuildWeaponTargetClassMask':0x48C6,
'MapAI_BuildReachableAttackTargetMask':0x48E5,
'MapAI_AccumulateTargetsFromCandidateCell':0x492E,
'MapAI_TestEnemySearchMaskBit':0x4965,
'MapAI_SetEnemySearchMaskBit':0x4970,
'MapAI_GetDistanceIfWithinWeaponRange':0x497B,
'MapAI_FindBestRangedAttackPosition':0x499D,
'MapAI_GetAttackPositionTerrainScore':0x4A07,
'MapAI_GetTargetPriorityListForUnitType':0x4A35,
'MapAI_GetUnitTypeListProfileB':0x4A3C,
}
for name,addr in expected.items():
    if labels.get(name)!=addr: raise SystemExit(f'{name} at {labels.get(name)}, expected ${addr:04X}')
# Five target classes: loop count 5, WeaponData offsets $0A-$0E, set bit for nonzero attack value.
assert bytes.fromhex('16050600cb207a3dc60a4f7bef125548a72802cbc01520ec') in retail
# Packed min/max range test calls HexGrid_GetDistance and returns $FF outside the low/high nibble interval.
assert bytes.fromhex('cd1d2957fa05c6e60f6f7abd380d') in retail
assert bytes.fromhex('fa05c6e6f0cb37ba38037a18023eff') in retail
# Candidate terrain score: non-air cover lookup plus +100 when Unit_CanRepairOnMapTile succeeds.
assert bytes.fromhex('ef0c61485f') in retail
assert bytes.fromhex('ef12e046a720047bc6645f') in retail
print(f'[ok] the current source attack scoring: {len(retail)} retail bytes exact, SHA-1 {sha}; 15 routine boundaries and weapon/range/terrain contracts locked')
