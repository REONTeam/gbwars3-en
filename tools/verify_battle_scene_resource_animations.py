#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
rom = Path(sys.argv[1] if len(sys.argv) > 1 else 'baserom.gbc').read_bytes()
def off(bank, addr): return bank * 0x4000 + (addr - 0x4000)
start, end = 0x4245, 0x43e5
blob = rom[off(0x14,start):off(0x14,end)]
sha = hashlib.sha1(blob).hexdigest()
assert len(blob) == 416, len(blob)
assert sha == '449f31f3090d0da3a9071f9ea521576d1eed93d5', sha
# Independently walk the 16 count-prefixed metasprites to the first script.
pos = 0
counts=[]
while pos < 0x43a1-start:
    n=blob[pos]; counts.append(n); pos += 1 + n*4
assert pos == 0x43a1-start, hex(start+pos)
assert counts == [6,6,6,6,6,5,6,6,6,6,6,6,4,4,2,2], counts
# Independently decode five pointer/duration scripts.
pos=0x43a1-start
scripts=[]
for _ in range(5):
    frames=[]
    while True:
        ptr=blob[pos] | (blob[pos+1]<<8); pos += 2
        if ptr == 0: break
        dur=blob[pos]; pos += 1
        frames.append((ptr,dur))
    scripts.append(frames)
assert pos == 0x43db-start, hex(start+pos)
assert [[d for _,d in s] for s in scripts] == [[6,7,6],[6,7,6],[6,7,6],[6,7,6],[5,6,6,5]]
ptrtab=[blob[pos+i] | (blob[pos+i+1]<<8) for i in range(0,10,2)]
assert ptrtab == [0x43a1,0x43ac,0x43b7,0x43c2,0x43cd], ptrtab
assert pos+10 == len(blob)
src=Path('engine/battle/battle_scene_setup.asm').read_text()
for evidence in [
    'section "Battle Scene Resource Metasprites", romx[$4245], bank[$14]',
    'BattleSceneResourceAnimVariant0::','BattleSceneResourceAnimVariant1::',
    'BattleSceneResourceAnimVariant2::','BattleSceneResourceAnimVariant3::',
    'BattleSceneResourceAnimCommon::','BattleSceneResourceAnimationPointers::',
    'ld de, BattleSceneResourceAnimSide0Facing','ld de, BattleSceneResourceAnimSide1Facing',
    'ld de, BattleSceneResourceAnimFamily2Centered','ld de, BattleSceneResourceAnimPhase1Side0',
    'ld de, BattleSceneResourceAnimCommon','assert @ == $43e5',
]:
    assert evidence in src, f'missing source evidence: {evidence}'
for raw in ['ld de, $43a1','ld de, $43ac','ld de, $43b7','ld de, $43c2','ld de, $43cd']:
    assert raw not in src, f'stale raw descriptor address: {raw}'
print(f'PASS: Bank $14:$4245-$43E4 battle-scene metasprite/animation resource layer: {len(blob)} bytes, SHA-1 {sha}')
print('PASS: 16 metasprites, five animation scripts, five-pointer table, and all Bank $18 selector references are symbolic')
