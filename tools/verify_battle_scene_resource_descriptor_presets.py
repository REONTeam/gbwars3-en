#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys

rom_path = Path(sys.argv[1] if len(sys.argv) > 1 else 'baserom.gbc')
built_path = Path(sys.argv[2] if len(sys.argv) > 2 else 'GBWARS3.gbc')
rom = rom_path.read_bytes()
built = built_path.read_bytes() if built_path.exists() else None

def off(bank, addr):
    return bank * 0x4000 + (addr - 0x4000)

start, end = 0x4000, 0x41fc
blob = rom[off(0x18, start):off(0x18, end)]
assert len(blob) == 508, len(blob)
sha = hashlib.sha1(blob).hexdigest()
assert sha == 'f11467444794522150c737bb0f1a5114d3c0714c', sha
if built is not None:
    rebuilt = built[off(0x18, start):off(0x18, end)]
    assert rebuilt == blob, 'rebuilt Bank $18 descriptor preset range differs from retail'

src = Path('engine/battle/battle_scene_resource_descriptor_presets.asm').read_text()
controller = Path('engine/battle/battle_scene_resource_controller.asm').read_text()
labels = [
    'BattleScene_StageFamily0Side0Descriptor::',
    'BattleScene_StageFamily0Side1Descriptor::',
    'BattleScene_StagePhase1Side0Descriptor::',
    'BattleScene_StageFamily1Side0Descriptor::',
    'BattleScene_StageFamily1Side1Descriptor::',
    'BattleScene_StageFamily2Side0Descriptor::',
    'BattleScene_StageFamily2Side1Descriptor::',
    'BattleScene_StagePhase2Side0Descriptor::',
    'BattleScene_StagePhase1Side1Descriptor::',
    'BattleScene_StagePhase2Side1Descriptor::',
]
for label in labels:
    assert label in src, f'missing {label}'
    assert label[:-2] in controller, f'Bank $14 controller does not call {label[:-2]}'

for addr in ('$4000','$402e','$405c','$4090','$40c4','$40f8','$412c','$4160','$4194','$41c8'):
    assert f'farcall $18, {addr}' not in controller.lower(), f'raw Bank $18 target remains: {addr}'

assert 'assert @ == $41fc' in src
print(f'PASS: Bank $18:$4000-$41FB descriptor preset family: {len(blob)} bytes, SHA-1 {sha}')
print('PASS: all ten Bank $14 callers use exported symbolic preset labels')
if built is not None:
    print('PASS: rebuilt descriptor preset range matches Japanese retail bytes exactly')
