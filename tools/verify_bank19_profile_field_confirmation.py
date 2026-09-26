#!/usr/bin/env python3
from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
retail = ROOT / 'baserom.gbc'
built = ROOT / 'GBWARS3.gbc'
bank = 0x19
spans = [
    (0x6990, 0x6B2D, 'profile-field confirmation controller'),
    (0x6B2D, 0x6B41, 'confirmation prompt resources'),
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
    'NetworkUI_RunProfileFieldConfirmation::',
    'NetworkUI_ProfileFieldPromptLabel0::',
    'NetworkUI_ProfileFieldPromptLabel1::',
    'MapMenuMessage_ServiceFrame',
    'Gfx_DrawTwoChoiceHighlightFirst',
    'Gfx_DrawTwoChoiceHighlightSecond',
    'assert @ == $6b41',
]:
    assert token in src, token
assert 'db $f5, $c5, $d5, $fa, $96, $da' not in src, 'old raw controller bytes remain'
print('PASS - Bank $19 profile-field confirmation controller/resources')
print('PASS - 413 executable bytes + 20 resource bytes match retail exactly')
print(f'PASS - custom English SHA-256 {sha}')
