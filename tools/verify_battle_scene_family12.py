#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
rom=Path(sys.argv[1] if len(sys.argv)>1 else 'baserom.gbc').read_bytes()
def off(bank,addr): return bank*0x4000+(addr-0x4000)
start,end=0x4c1a,0x4fc5
blob=rom[off(0x18,start):off(0x18,end)]
sha=hashlib.sha1(blob).hexdigest()
assert len(blob)==939,len(blob)
assert sha=='4f3794ef80ff6c10a7c5cde5abe84a55b2e35c33',sha
src=Path('engine/battle/battle_scene_setup.asm').read_text()
labels=[
'BattleScene_SetupPhase1Side0::','BattleScene_SetupPhase1Side0_Continue::',
'BattleScene_SetupFamily1Side0::','BattleScene_SetupFamily1Side0_Continue::',
'BattleScene_SetupFamily2Side0::','BattleScene_SetupFamily2Side0_Continue::',
'BattleScene_SetupFamily1Side1::','BattleScene_SetupFamily1Side1_Continue::',
'BattleScene_SetupFamily2Side1::','BattleScene_SetupFamily2Side1_Continue::',
'BattleScene_SetVerticalPosition::','BattleScene_SetVerticalPositionFamily1::',
'BattleScene_SetHorizontalPositionSide0::','BattleScene_SetHorizontalPositionSide1::',
]
for x in labels: assert x in src, f'missing {x}'
for x in [
'farcall BattleScene_SetupPhase1Side0','farcall BattleScene_SetupFamily1Side0',
'farcall BattleScene_SetupFamily1Side1','farcall BattleScene_SetupFamily2Side0',
'farcall BattleScene_SetupFamily2Side1','farcall $17, BattlePlace_GetAnimationPointer',
'BattleScene_VerticalPositionsClass0:','BattleScene_VerticalPositionsClass1:',
'BattleScene_VerticalPositionsClass2:','BattleScene_HorizontalPositionOffsets:',
'assert @ == $4fc5']:
    assert x in src, f'missing source evidence: {x}'
print(f'PASS: Bank $18:$4C1A-$4FC4 phase/family setup layer: {len(blob)} bytes, SHA-1 {sha}')
print('PASS: phase-1/family-1/family-2 side mirrors and shared X/Y placement helpers are represented')
