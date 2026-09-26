#!/usr/bin/env python3
from pathlib import Path
import re, sys

ROOT = Path(__file__).resolve().parents[1]
errors=[]

def need(path, needle):
    text=(ROOT/path).read_text(errors='ignore')
    if needle not in text: errors.append(f'{path}: missing {needle}')

# Proven SFX vocabulary.
constants=(ROOT/'constants/audio_constants.inc').read_text()
for name in ['SFX_ERROR','SFX_CURSOR_MOVE','SFX_CONFIRM','SFX_CANCEL','SFX_UNIT_DELETE',
             'SFX_PROPERTY_CAPTURE','SFX_WAIT_ACTION','SFX_DEVELOP_PROPERTY',
             'SFX_TRANSPORT_LOAD','SFX_SUPPLY','SFX_TITLE_START','SFX_SPRITE_EXIT']:
    if not re.search(rf'^DEF {name}\s+EQU', constants, re.M):
        errors.append(f'missing {name}')

# Known common request IDs should not be reintroduced as magic values immediately
# before SFX calls.
common={'03','09','0a','0c'}
for p in (ROOT/'engine').rglob('*.asm'):
    lines=p.read_text(errors='ignore').splitlines()
    for i,line in enumerate(lines):
        if re.search(r'call\s+Audio_(?:Play|Request)SFX', line):
            for prev in lines[max(0,i-4):i]:
                m=re.search(r'ld\s+a,\s*\$([0-9a-fA-F]{2})\b', prev)
                if m and m.group(1).lower() in common:
                    errors.append(f'{p.relative_to(ROOT)}:{i+1}: magic common SFX ${m.group(1)}')

# ROM0 names already proven elsewhere must be real source labels, not RemainingCode aliases.
remaining=(ROOT/'engine/remaining_rom.asm').read_text()
for label in ['FarcallVector','VBlankInterruptVector','LCDStatInterruptVector','TimerInterruptVector',
              'SerialInterruptVector','JoypadInterrupt','CartridgeHeaderEntry','BankedReadByte',
              'MapControl_RunPhaseController','CallHLInBankB','TextPrint','DrawNumberFixedWidth',
              'TextPut','CoordTextPut','VBlankFIFO_Process','CallWordTableByIndex',
              'WordTable_GetFirstSetBitEntry','Farcall','Farcall_Jump','MapControl_PhaseHandlerTable']:
    if f'{label}::' not in remaining:
        errors.append(f'engine/remaining_rom.asm: missing semantic label {label}')

for old in ['RemainingCode_Bank00_2B38','RemainingCode_Bank00_3237','RemainingCode_Bank00_3353',
            'RemainingCode_Bank00_336E','RemainingCode_Bank00_3537','RemainingCode_Bank00_3B06',
            'RemainingCode_Bank00_3B46']:
    if old in remaining:
        errors.append(f'legacy known ROM0 label still present: {old}')

need(Path('macros/macros.inc'),'macro banked_callback')
need(Path('audio/sound_data_bank08.asm'),'SoundEffect_Error_Ch1::')
need(Path('audio/sound_data_bank08.asm'),'SoundEffect_Confirm_Ch1::')
need(Path('audio/sound_data_bank08.asm'),'SoundEffect_Cancel_Ch1::')
need(Path('docs/audio/sfx_semantics.md'),'# Sound-effect semantic IDs')

# remaining_rom internal-label hygiene.
remaining_code = re.findall(r'\bRemainingCode_Bank[0-9A-F]{2}_[0-9A-F]{4}\b', remaining)
if remaining_code:
    errors.append(f'legacy RemainingCode labels remain: {len(set(remaining_code))}')
local_count = len(re.findall(r'^\.loc_[0-9A-F]{4}:$', remaining, re.M))
entry_names = re.findall(r'^(RuntimeEntry_Bank[0-9A-F]{2}_[0-9A-F]{4})::$', remaining, re.M)
if local_count != 604:
    errors.append(f'engine/remaining_rom.asm: expected 604 local structural labels, found {local_count}')
if len(entry_names) != 257:
    errors.append(f'engine/remaining_rom.asm: expected 257 RuntimeEntry anchors, found {len(entry_names)}')
for q in (ROOT/'engine').rglob('*.asm'):
    if q == ROOT/'engine/remaining_rom.asm':
        continue
    t=q.read_text(errors='ignore')
    for name in entry_names:
        if name in t:
            errors.append(f'{q.relative_to(ROOT)}: cross-file use of neutral internal anchor {name}')
            break
need(Path('docs/architecture/runtime_label_cleanup.md'),'# Runtime label cleanup')

if errors:
    print('Semantic polish verification: FAILED')
    for e in errors: print(' -',e)
    sys.exit(1)
print('Semantic polish verification: PASS')
