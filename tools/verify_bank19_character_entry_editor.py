#!/usr/bin/env python3
from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
retail = ROOT / 'baserom.gbc'
built = ROOT / 'GBWARS3.gbc'
bank = 0x19
spans = [
    (0x6B41, 0x6B4C, 'character-entry prompt resource'),
    (0x6B4C, 0x6C64, 'character-entry editor controller'),
]
if not retail.exists() or not built.exists():
    raise SystemExit('baserom.gbc and GBWARS3.gbc are required')
ra = retail.read_bytes(); rb = built.read_bytes()
for start, end, name in spans:
    off = bank * 0x4000 + (start - 0x4000)
    assert ra[off:off + end-start] == rb[off:off + end-start], f'Bank $19:${start:04X}-${end-1:04X} differs from retail ({name})'
sha = hashlib.sha256(rb).hexdigest()
assert sha == 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059', sha
src = (ROOT / 'engine/network/bank19_network_ui_continuation.asm').read_text()
for token in [
    'NetworkUI_CharacterEntryPromptLabel::',
    'NetworkUI_RunCharacterEntryEditor::',
    'NetworkUI_CancelCharacterEntryEditor::',
    'NetworkUI_SetupProfileCharacterEntry',
    'NetworkUI_AdvanceCharacterEntryCursor',
    'NetworkUI_InsertSelectedCharacter',
    'NetworkUI_DeletePreviousCharacter',
    'NetworkUI_RunProfileFieldConfirmation',
    'MapMenuMessage_ServiceFrame',
    'UIWindowStack_PopRestore',
    'assert @ == $6c64',
]:
    assert token in src, token
assert 'db $06, $09, $a7, $ac, $76, $62, $86, $78, $6a, $3f, $00, $4f' not in src, 'old raw controller prefix remains'
print('PASS - Bank $19 character-entry editor prompt/controller')
print('PASS - 11 resource bytes + 280 executable bytes match retail exactly')
print(f'PASS - custom English SHA-256 {sha}')
