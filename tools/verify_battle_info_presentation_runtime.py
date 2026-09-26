#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys

root = Path('.')
rom = Path(sys.argv[1] if len(sys.argv) > 1 else 'baserom.gbc').read_bytes()
start, end = 0x4C70, 0x4D9F
file_start = 0x0C * 0x4000 + (start - 0x4000)
payload = rom[file_start:file_start + (end-start)]
expected = 'bd2d0f65aff1f2abd7eb8b41e5e3baeb749876a1'
assert len(payload) == 303
assert hashlib.sha1(payload).hexdigest() == expected

src = (root/'engine/battle/battle_combat_runtime.asm').read_text()
for label in [
    'BattleInfo_ShowScreen::',
    'BattleInfo_DrawAttackOrder::',
    'BattleInfo_DrawOrderLabel::',
    'BattleInfo_DrawParticipantStats::',
]:
    assert label in src, label
for addr in ['$4c70', '$4d24', '$4d51', '$4d5d', '$4d9f']:
    assert addr in src.lower(), addr
assert 'ld hl, BattleInfo_Strings' in src
assert 'ld hl, BattleInfo_Order_Strings' in src
assert 'ld hl, wBattleAttackerStats' in src
assert 'ld hl, wBattleDefenderStats' in src
assert 'ld a, [wBattleAttackerFocus]' in src
assert 'ld a, [wBattleDefenderFocus]' in src

info = (root/'engine/battle/battle_info.asm').read_text()
assert 'section "BattleInfo_Strings", romx[$4d9f], bank[$0c]' in info
assert 'section "BattleInfo_Order_Strings", romx[$4e0a], bank[$0c]' in info
assert 'text " 1ST"' in info and 'text " 2ND"' in info and 'text "SAME"' in info

symbols = (root/'symbols.asm').read_text()
assert 'sym $0c, $4e0a, BattleAttackOrderTextPointers' not in symbols
assert 'sym $0c, $4e12, BattleAttackOrderText' not in symbols

print(f'Battle-info presentation runtime OK: {len(payload)} bytes, SHA-1 {expected}')
