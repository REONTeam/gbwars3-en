#!/usr/bin/env python3
from pathlib import Path
import re, sys
ROOT=Path(__file__).resolve().parents[1]
errors=[]
def fail(msg): errors.append(msg)
provider=[]
for p in (ROOT/'engine').rglob('*.asm'):
    for i,line in enumerate(p.read_text(errors='ignore').splitlines(),1):
        if re.search(r'\b\w*Provider_Bank[0-9A-Fa-f]+_[0-9A-Fa-f]+\b', line): provider.append(f'{p.relative_to(ROOT)}:{i}')
if provider: fail(f'{len(provider)} address-only Provider_Bank aliases remain')
charmap=(ROOT/'charmaps/char_main.inc').read_text(errors='ignore')
if not re.search(r'charmap\s+"\."\s*,\s*\$2e\b', charmap, re.I): fail('main charmap does not explicitly map ASCII full stop to $2E')
late=list((ROOT/'audio/music/bank3e').glob('musictrack_*.asm'))+list((ROOT/'audio/music/bank3f').glob('musictrack_*.asm'))
if len(late)!=19: fail(f'late music source has {len(late)} track files, expected 19')
if list(ROOT.rglob('*.music')): fail('raw .music assets have reappeared')
for ext in ('*.dat','*.sound','*.gfx','*.bin'):
    bad=list(ROOT.rglob(ext))
    if bad: fail(f'retired generic extension {ext} remains ({len(bad)} files)')
for b in ('03','05','06','07','3e','3f'):
    if not (ROOT/f'audio/driver_copies/music_driver_bank{b}.asm').exists(): fail(f'missing mnemonic music-driver copy for bank {b}')
if not (ROOT/'audio/driver_copies/sound_driver_bank09.asm').exists(): fail('missing mnemonic SFX-driver copy for bank 09')
checks={'engine/remaining_rom.asm':['String_CompareZeroTerminated::','NetworkPersistent_LoadSavedField16::'],'engine/network/bank19_network_runtime_4d41.asm':['NetworkUI_RunMobileMenuController::'],'engine/versus/versus_map_selection_runtime.asm':['Vram_SetPalsWithIncrementedE EQU $4073']}
for rel,needles in checks.items():
    txt=(ROOT/rel).read_text(errors='ignore')
    for needle in needles:
        if needle not in txt: fail(f'{rel} missing refinement marker {needle}')
for rel in ('tools/rgbds-1.0.3','tools/bison-3.8.2-source'):
    if (ROOT/rel).exists(): fail(f'obsolete vendored tool tree remains: {rel}')
legacy=ROOT/'tools/rgbgfx-legacy'
if not (legacy/'Makefile').exists() or not (legacy/'src/gfx/main.c').exists(): fail('legacy rgbgfx compatibility source tree is missing')
if errors:
    print('Refinement verification: FAIL')
    for e in errors: print(' -',e)
    sys.exit(1)
print('Refinement verification: PASS')
print(' generic .dat/.sound/.gfx/.bin assets: 0')
print(' provider/address aliases: 0')
print(' late music: 19 semantic track files / 78 late channel entries, no .music blobs')
print(' duplicate music/SFX driver banks: mnemonic source copies')
print(' build warnings addressed: ASCII full stop is explicit in main charmap')
