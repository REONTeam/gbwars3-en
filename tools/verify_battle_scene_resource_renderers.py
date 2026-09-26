#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
rom = Path(sys.argv[1] if len(sys.argv) > 1 else 'baserom.gbc').read_bytes()
def off(bank, addr): return bank * 0x4000 + (addr - 0x4000)
start, end = 0x5183, 0x53d7
blob = rom[off(0x18,start):off(0x18,end)]
sha = hashlib.sha1(blob).hexdigest()
assert len(blob) == 596, len(blob)
assert sha == 'a92591cc4278717ae129803d5789102c5cbd6bfe', sha
src = Path('engine/battle/battle_scene_setup.asm').read_text()
for label in [
    'BattleScene_PrepareCommonResourceLookup::',
    'BattleScene_SelectResourceVariant0::', 'BattleScene_SelectResourceVariant1::',
    'BattleScene_SelectResourceVariant2::', 'BattleScene_SelectResourceVariant3::',
    'BattleScene_SelectCommonResource::',
    'BattleScene_RenderResourceVariant0::', 'BattleScene_RenderResourceVariant1::',
    'BattleScene_RenderResourceVariant2::', 'BattleScene_RenderResourceVariant3::',
]:
    assert label in src, f'missing {label}'
for evidence in [
    'section "Battle Scene Resource Selection Helpers", romx[$5183], bank[$18]',
    'farcall $16, $4845',
    'call BattleScene_SelectResourceSide0Facing',
    'call BattleScene_SelectResourceSide1Facing',
    'call BattleScene_SelectResourceFamily2Centered',
    'call BattleScene_SelectResourcePhase1Side0',
    'call BattleScene_SelectCommonResource',
    'add a, $08', 'sub $08',
    'ld a, [wBattleSceneResourceIndex]',
    'assert @ == $53d7',
]:
    assert evidence in src, f'missing source evidence: {evidence}'
print(f'PASS: Bank $18:$5183-$53D6 battle-scene resource/render layer: {len(blob)} bytes, SHA-1 {sha}')
print('PASS: four resource-specific renderer paths plus common fallback are explicit source')
