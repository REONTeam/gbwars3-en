#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, subprocess, sys

ROOT = Path(__file__).resolve().parents[1]
retail = ROOT / 'baserom.gbc'
out = ROOT / 'GBWARS3.gbc'
prompt_src = ROOT / 'engine/map/map_surrender_resolution_prompt_bank27.asm'
controller_src = ROOT / 'engine/map/ai/map_control_resolution_helpers.asm'
EXPECTED_ROM = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
SPANS = [
    (0x27, 0x7CB7, 0x7E5F, 'surrender prompt/outcome family'),
    (0x27, 0x7E5F, 0x7F17, 'surrender prompt controller'),
]

def off(bank, addr):
    return bank * 0x4000 + (addr - 0x4000)

if not retail.exists() or not out.exists():
    print('ERROR: baserom.gbc and GBWARS3.gbc are required', file=sys.stderr)
    sys.exit(1)

a = retail.read_bytes(); b = out.read_bytes()
for bank, start, end, label in SPANS:
    o = off(bank, start)
    got = b[o:o + end - start]
    exp = a[o:o + end - start]
    if got != exp:
        print(f'FAIL {label}: {bank:02X}:{start:04X}-{end-1:04X}', file=sys.stderr)
        sys.exit(1)
    print(f'PASS {label}: {bank:02X}:{start:04X}-{end-1:04X} ({end-start} bytes), sha1={hashlib.sha1(exp).hexdigest()}')

pt = prompt_src.read_text()
ct = controller_src.read_text()
required_prompt = [
    'MapSurrenderPrompt_Setup::',
    'MapSurrenderPrompt_DrawOutcome::',
    'wMapSurrenderingSide',
    'wMapSurrenderPromptChoice',
    'レッドスターぐんが',
    'ホワイトムーンぐんが',
    'こうふくしました。',
    'こうふくをむししました。',
    'しょうりになります。',
]
for token in required_prompt:
    if token not in pt:
        print(f'FAIL prompt source contract missing {token}', file=sys.stderr)
        sys.exit(1)
required_controller = [
    'MapSurrenderPrompt_Run::',
    'MapControl_PhaseResultDispatch::',
    'call MapSurrenderPrompt_Setup',
    'call MapSurrenderPrompt_DrawOutcome',
    'farcall Gfx_DrawTwoChoiceHighlightFirst',
    'farcall Gfx_DrawTwoChoiceHighlightSecond',
]
for token in required_controller:
    if token not in ct:
        print(f'FAIL controller source contract missing {token}', file=sys.stderr)
        sys.exit(1)
print('PASS surrender semantic/source contracts')

# This controller used to be an opaque byte blob; ensure it stays mnemonic.
section = ct.split('section "Map Control Phase Result Dispatch"', 1)[1].split('section "Campaign Resolution Counter Increment"', 1)[0]
if re.search(r'^\s*db\s+\$', section, re.M):
    print('FAIL surrender controller regressed to raw db bytes', file=sys.stderr)
    sys.exit(1)
print('PASS surrender controller is mnemonic source')

sha = hashlib.sha256(b).hexdigest()
if sha != EXPECTED_ROM:
    print(f'FAIL custom-English SHA-256 {sha}', file=sys.stderr)
    sys.exit(1)
print(f'PASS corrected custom-English SHA-256 {sha}')
