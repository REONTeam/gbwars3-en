#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
rom = Path(sys.argv[1] if len(sys.argv) > 1 else 'baserom.gbc').read_bytes()
def off(bank, addr): return bank * 0x4000 + (addr - 0x4000)
start, end = 0x4af2, 0x4c1a
blob = rom[off(0x18, start):off(0x18, end)]
sha = hashlib.sha1(blob).hexdigest()
assert len(blob) == 296, len(blob)
assert sha == '07046dd2098fafb6f34150b8355a234e5fd897b6', sha
src = Path('engine/battle/battle_scene_setup.asm').read_text()
for label in [
    'BattleScene_SetupFamily0Side0::',
    'BattleScene_SetupFamily0Side0_Continue::',
    'BattleScene_SetupFamily0Side1::',
    'BattleScene_SetupFamily0Side1_Continue::',
]:
    assert label in src, f'missing {label}'
for needle in [
    'farcall BattleScene_SetupFamily0Side0',
    'farcall BattleScene_SetupFamily0Side1',
    'ld a, [wBattlePlaceRowSide0]',
    'ld a, [wBattlePlaceRowSide1]',
    'ld [wBattlePlacePointerVariant], a',
    'farcall $17, BattlePlace_GetAnimationPointer',
    'assert @ == $4b86',
    'assert @ == $4c1a',
]:
    assert needle in src, f'missing source evidence: {needle}'
print(f'PASS: Bank $18:$4AF2-$4C19 family-0 mirrored setup: {len(blob)} bytes, SHA-1 {sha}')
print('PASS: side-0/side-1 dispatch now resolves to labels and both continuation paths are represented')
