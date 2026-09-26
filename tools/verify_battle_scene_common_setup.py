#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
rom = Path(sys.argv[1] if len(sys.argv)>1 else 'baserom.gbc').read_bytes()
def off(bank, addr): return bank*0x4000 + (addr-0x4000)
start,end=0x4948,0x4a1d
blob=rom[off(0x18,start):off(0x18,end)]
sha=hashlib.sha1(blob).hexdigest()
assert len(blob)==213
assert sha=='a0bb2a602d42fb54c02a265a4793d29717f6dd33', sha
src=Path('engine/battle/battle_scene_setup.asm').read_text()
for label in [
    'BattleScene_LoadCommonGraphics::',
    'BattleScene_RequestPalettes::',
    'BattleScene_DispatchSetupPhase::',
    'BattleScene_DispatchTerrainRow::',
]:
    assert label in src, f'missing {label}'
for needle in [
    'ld de, $7133', 'ld bc, $01a0', 'farcall $17, Memcpy',
    'ld de, $43e5', 'ld bc, $04b0', 'farcall $14, Memcpy',
    'farcall BattleScene_SetupFamily0Side0', 'farcall BattleScene_SetupFamily0Side1',
    'farcall BattleScene_SetupFamily1Side0', 'farcall BattleScene_SetupFamily1Side1',
    'farcall BattleScene_SetupFamily2Side0', 'farcall BattleScene_SetupFamily2Side1',
    'assert @ == $4a1d',
]:
    assert needle in src, f'missing source evidence: {needle}'
print(f'PASS: Bank $18:$4948-$4A1C common battle-scene setup: {len(blob)} bytes, SHA-1 {sha}')
print('PASS: common VRAM copies, palette request, setup-phase dispatch and side/terrain-row family dispatch represented')
