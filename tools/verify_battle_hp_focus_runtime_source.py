#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
rom=Path(sys.argv[1]).read_bytes()
start,end=0x4A26,0x4B67
off=0x0C*0x4000+(start-0x4000)
data=rom[off:off+end-start]
assert len(data)==0x141
assert hashlib.sha1(data).hexdigest()=='98fd61f120667704e533a63db98232091946ab05'
src=Path('engine/battle/battle_combat_runtime.asm').read_text()
for label in ['Battle_CalcAttackerNewHP::','Battle_CalcDefenderNewHP::','Battle_CalcNewHPByAttackOrder::','Battle_FocusOrderAttackerHigher::','Battle_FocusOrderDefenderHigher::','Battle_FocusOrderTied::']:
    assert label in src, label
sym=Path('symbols.asm').read_text()
for old in ['sym $0c, $4a26, Battle_CalcAttackerNewHP','sym $0c, $4a98, Battle_CalcDefenderNewHP','sym $0c, $4b0a, Battle_CalcNewHPByAttackOrder']:
    assert old not in sym, old
print('[ok] Bank $0C:$4A26-$4B66 HP/Focus runtime source, 321 bytes')
print('[ok] SHA-1 98fd61f120667704e533a63db98232091946ab05')
