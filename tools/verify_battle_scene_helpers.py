#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
rom = Path(sys.argv[1] if len(sys.argv) > 1 else 'baserom.gbc').read_bytes()
def off(bank, addr): return bank * 0x4000 + (addr - 0x4000)
start, end = 0x4a49, 0x4af2
blob = rom[off(0x18, start):off(0x18, end)]
sha = hashlib.sha1(blob).hexdigest()
assert len(blob) == 169, len(blob)
assert sha == '5ffc8ce14a0d2aaf5625ec1e17ad40f6e6d0f615', sha
src = Path('engine/battle/battle_scene_setup.asm').read_text()
for label in [
    'BattleScene_NoopHook::',
    'BattleScene_BuildScratchTable::',
    'BattleScene_ResetScratchTable::',
    'BattleScene_ResetRuntimeState::',
    'BattleScene_ClassifyMapTile3Way::',
    'BattleScene_ClassifyMapTile4Way::',
    'BattleScene_ClassifyMapTileBinary::',
]:
    assert label in src, f'missing {label}'
for needle in [
    'db $00, $04, $08, $10, $20, $35, $46, $57, $68, $79',
    'ld de, BattlePlaceAnim_70C8',
    'farcall $17, $4063',
    'cp $1d', 'cp $2c', 'cp $34', 'cp $32', 'cp $33', 'cp $23', 'cp $27',
    'assert @ == $4af2',
]:
    assert needle in src, f'missing source evidence: {needle}'
print(f'PASS: Bank $18:$4A49-$4AF1 pre-family helper layer: {len(blob)} bytes, SHA-1 {sha}')
print('PASS: scratch-table setup, battle-scene reset, and 3-way/4-way/binary raw-map-tile classifiers represented')
