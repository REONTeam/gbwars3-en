#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
rom=Path(sys.argv[1] if len(sys.argv)>1 else 'baserom.gbc').read_bytes()
def off(bank,addr): return bank*0x4000+(addr-0x4000)
start,end=0x4fc5,0x5183
blob=rom[off(0x18,start):off(0x18,end)]
sha=hashlib.sha1(blob).hexdigest()
assert len(blob)==446,len(blob)
assert sha=='f008ac5f9e6b40c08d9b41257c488c2d1de4e537',sha
src=Path('engine/battle/battle_scene_setup.asm').read_text()
labels=[
'BattleScene_SetupPhase1Side1::','BattleScene_SetupPhase1Side1_Continue::',
'BattleScene_SetupPhase2Side0::','BattleScene_SetupPhase2Side0_Continue::',
'BattleScene_SetupPhase2Side1::','BattleScene_SetupPhase2Side1_Continue::',
]
for x in labels: assert x in src, f'missing {x}'
for x in [
'farcall BattleScene_SetupPhase1Side0','farcall BattleScene_SetupPhase1Side1',
'farcall BattleScene_SetupPhase2Side0','farcall BattleScene_SetupPhase2Side1',
'call BattleScene_SetHorizontalPositionSide0','call BattleScene_SetHorizontalPositionSide1',
'call BattleScene_SetVerticalPosition','farcall $17, BattlePlace_GetAnimationPointer',
'assert @ == $5183']:
    assert x in src, f'missing source evidence: {x}'
for raw in ['farcall $18, $4fc5','farcall $18, $505f','farcall $18, $50f1']:
    assert raw not in src, f'raw dispatcher target remains: {raw}'
print(f'PASS: Bank $18:$4FC5-$5182 remaining phase setup: {len(blob)} bytes, SHA-1 {sha}')
print('PASS: phase 1 side 1 and phase 2 both sides are symbolic in the dispatcher')
