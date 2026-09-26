#!/usr/bin/env python3
from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
retail = (ROOT / 'baserom.gbc').read_bytes()
built = (ROOT / 'GBWARS3.gbc').read_bytes()
BANK = 0x15
RANGES = [
    (0x5D6F, 0x5DB7, 'save prompt screen setup'),
    (0x5DC2, 0x5EBF, 'main-menu save prompt/confirmation runtime'),
    (0x5ECA, 0x5EDE, 'mode-dependent SRAM slot writer'),
]

def sl(rom, start, end):
    off = BANK * 0x4000 + (start - 0x4000)
    return rom[off:off + (end - start)]

total = 0
for start, end, name in RANGES:
    rb = sl(retail, start, end)
    bb = sl(built, start, end)
    assert rb == bb, f'{name} differs from retail at Bank $15:${start:04X}-${end-1:04X}'
    total += len(rb)
    print(f'PASS: {name}: {len(rb)} bytes, SHA-1 {hashlib.sha1(rb).hexdigest()}')

src = (ROOT / 'engine/map/map_save_prompt_runtime_bank15.asm').read_text()
for required in [
    'MapSave_SetupPromptScreen::',
    'MainMenu_RunSavePrompt::',
    'MapSave_ShowSavedConfirmation::',
    'MapSave_WriteModeSlot::',
    'MapSave_ConfirmationVBlankZeros::',
    'farcall MapSRAM_SaveActiveMapToSlot',
]:
    assert required in src, f'missing source contract: {required}'

provider = (ROOT / 'engine/map/map_save_presentation_providers.asm').read_text()
for forbidden in ['call $5d6f', 'call $5e38', 'call $5eca']:
    assert forbidden not in provider, f'raw Bank $15 dependency remains: {forbidden}'
for required in ['MapSave_SetupPromptScreen', 'MapSave_ShowSavedConfirmation', 'MapSave_WriteModeSlot']:
    assert required in provider, f'symbolic provider call missing: {required}'

print(f'PASS: Bank $15 save-prompt tranche: {total} exact retail bytes')
print('PASS: Map Editor SAVE flow uses symbolic Bank $15 helpers')
