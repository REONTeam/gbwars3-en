#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
root=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else root/'baserom.gbc').read_bytes()
source=(root/'engine/battle/battle_combat_runtime.asm').read_text()
symbols=(root/'symbols.asm').read_text()
base=0x0c*0x4000-0x4000
ranges=[(0x4861,0x4884,'082a6394d7e926f40846fe42f601d85d6f559afa'),(0x4991,0x4a26,'b1f58c2efdd03f669bfcf345f366ac5b5ec9eeda')]
for a,b,sha in ranges:
    got=hashlib.sha1(rom[base+a:base+b]).hexdigest()
    assert got==sha,(hex(a),got,sha)
for label in ['Battle_GetCoverValue::','Battle_CoverValueTable::','Battle_GetRankMultiplier::','Battle_RankMultiplierTable::','Battle_CalcAttackMultiplier::','Battle_CalcDefenseMultiplier::','Battle_CalcStatHPScaled::','Battle_CalcDoubleStatHPScaled::']:
    assert label in source,label
for label in ['Battle_GetCoverValue','Battle_CoverValueTable','Battle_GetRankMultiplier','Battle_RankMultiplierTable','Battle_CalcAttackMultiplier','Battle_CalcDefenseMultiplier','Battle_CalcStatHPScaled','Battle_CalcDoubleStatHPScaled']:
    assert not any(label in line and 'sym $0c' in line for line in symbols.splitlines()), label
assert 'db $00, $46, $1e, $14, $1e, $14, $0a, $14' in source
assert 'db BATTLE_RANK_VALUE_D' in source and 'db BATTLE_RANK_VALUE_S' in source
print('[ok] Bank $0C combat source: $4861-$4883 and $4991-$4A25')
