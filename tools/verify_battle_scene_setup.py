#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
rom = Path(sys.argv[1] if len(sys.argv)>1 else 'baserom.gbc').read_bytes()
def off(bank, addr): return bank*0x4000 + (addr-0x4000)
start,end=0x48fb,0x4948
blob=rom[off(0x18,start):off(0x18,end)]
expected=bytes.fromhex('c5 d5 e5 fa ad c4 fe 00 20 05 fa b3 c4 18 03 fa b4 c4 4f 06 00 21 28 49 09 fa ad c4 fe 01 20 05 7e c6 4a 18 01 7e ea db c4 e1 d1 c1 c9 1e 1e 1e 1e 1e 1e 1e 1e 1f 20 20 20 20 20 21 21 22 22 23 23 23 22 22 22 22 22 22 22 24 24 1e 1e')
assert len(expected)==0x4d
assert blob==expected, 'Bank $18:$48FB-$4947 differs from expected retail bytes'
source=Path('engine/battle/battle_scene_setup.asm').read_text()
for label in ['BattleScene_SelectResourceIndex::','BattleSceneResourceIndexTable::','wBattlePlaceRowSide0','wBattlePlaceRowSide1','wBattleSceneResourceIndex']:
    assert label in source or label in Path('symbols.asm').read_text(), f'missing {label}'
print(f'PASS: Bank $18:$48FB-$4947 battle-scene selector: {len(blob)} bytes, SHA-1 {hashlib.sha1(blob).hexdigest()}')
print('PASS: 32-entry used-weapon-to-resource table (IDs $00-$1F); side 1 applies +$4A namespace offset')
