#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1] if len(sys.argv) > 1 else ROOT / 'baserom.gbc')
rom = rom_path.read_bytes()

def require(cond, msg):
    if not cond:
        raise AssertionError(msg)

def off(bank, addr):
    return bank * 0x4000 + (addr - 0x4000)

start, end = 0x68a8, 0x6b45
data = rom[off(0x10, start):off(0x10, end)]
require(len(data) == 669, 'Bank10 window-stack runtime length changed')
require(sha1(data).hexdigest() == 'c10875034da49306d30ab4255ce377abf7ff4181', 'Bank10 window-stack runtime fingerprint changed')

src_path = ROOT / 'engine/ui/window_stack_runtime.asm'
src = src_path.read_text()
for token in (
    'section "Shared UI Window Stack", romx[$68a8], bank[$10]',
    'UIWindowStack_Init::',
    'UIWindowStack_SetBorderTile::',
    'UIWindowStack_SetAttributes::',
    'UIWindowStack_PushAndDraw::',
    'UIWindowStack_PushAndDrawAnimated::',
    'UIWindowStack_PopRestore::',
    'UIWindowStack_PushBacking::',
    'UIWindowStack_PopBacking::',
    'UIWindow_DrawFrame::',
    'UIWindow_DrawFrameAnimated::',
    'UIWindow_PlaceTile::',
    'UIWindow_FillInterior::',
    'assert @ == $6b45',
):
    require(token in src, f'missing window-stack source token: {token}')

# The reconstructed source has one instruction for every instruction in the
# retail decode over the closed range. This catches accidental statement loss
# even when the full RGBDS assembler is unavailable in the environment.
instructions = []
for raw in src.splitlines():
    line = raw.split(';', 1)[0].strip()
    if not line or line.endswith(':'):
        continue
    if line.startswith(('include ', 'DEF ', 'section ', 'assert ')):
        continue
    instructions.append(line)
require(len(instructions) == 412, f'window-stack instruction count changed: {len(instructions)} != 412')

raw_targets = (
    'farcall $10, $68a8',
    'farcall $10, $68ce',
    'farcall $10, $68e4',
    'farcall $10, $68fa',
    'farcall $10, $6901',
    'farcall $10, $6908',
    'farcall $10, $690c',
    'farcall $10, $698e',
    'farcall $10, $6a09',
    'farcall $10, $6afd',
)
for p in (ROOT / 'engine').rglob('*.asm'):
    if p == src_path:
        continue
    text = p.read_text(errors='ignore')
    for raw in raw_targets:
        require(raw not in text, f'raw window-stack call remains in {p.relative_to(ROOT)}: {raw}')

symbols = (ROOT / 'symbols.asm').read_text()
require('NameInput_PlaceTile' not in symbols, 'obsolete NameInput_PlaceTile symbol overlay remains')
require('NameInput_ConfirmDialog_Horiz' not in symbols, 'obsolete NameInput_ConfirmDialog_Horiz symbol overlay remains')

print('Bank10 shared UI window stack $68A8-$6B44: retail fingerprint [ok]')
print('Shared-window source boundaries / 412-instruction decode geometry: [ok]')
print('Source-backed consumers use symbolic Bank10 window APIs: [ok]')
