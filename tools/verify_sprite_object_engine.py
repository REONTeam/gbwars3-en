#!/usr/bin/env python3
from pathlib import Path
import sys

ROM = Path(sys.argv[1] if len(sys.argv) > 1 else 'baserom.gbc')
rom = ROM.read_bytes()
source = Path('engine/home/home_sprite_object.asm').read_text()

def require(cond, msg):
    if not cond:
        raise AssertionError(msg)

def sig(addr, hexbytes):
    b = bytes.fromhex(hexbytes)
    require(rom[addr:addr+len(b)] == b, f'ROM signature mismatch at ${addr:04X}')

# Stable public entry anchors from the retail ROM.
sig(0x2D7C, 'f082f5c5e53e04e082e070')
sig(0x2DE8, 'e5e0baf082f53e04e082e070')
sig(0x2E1F, 'c5d5e5fe28303d06004f')
sig(0x2E67, 'c5e5060078cd1f2e')
sig(0x2EAE, 'e5c50601cd4830c1')
sig(0x2EC9, 'd5e5480603cd9a2e')
sig(0x2EE8, 'c5e54fc50605cd4830c1')
sig(0x3056, 'f080f5f082f53e04e082e070')
sig(0x30CA, 'c5cb3767e6f06f')
sig(0x314A, 'c5f0b9cb3767e6f0')
sig(0x3177, 'd5e5cb3767e6f0c605')
sig(0x31BA, 'e5626b4f0600090909')
sig(0x31CA, 'e5d52146cccde231cdd40e')

# Field 0 bit 0 suppresses OAM. $2F45 clears it (show); $2F5F sets it (hide).
require(rom[0x2F45 + 0x10:0x2F45 + 0x12] == bytes.fromhex('cb86'), '$2F45 is not RES 0,[HL]')
require(rom[0x2F5F + 0x10:0x2F5F + 0x12] == bytes.fromhex('cbc6'), '$2F5F is not SET 0,[HL]')

for token in (
    'section "Sprite Engine", rom0[$2d7c]',
    'SpriteObject_Create::',
    'SpriteObject_Destroy::',
    'SpriteObject_DestroyAll::',
    'SpriteObject_SetPosition::',
    'SpriteObject_SetPalette::',
    'SpriteObject_SetAnimation::',
    'SpriteObject_DisableAutoAnimation::',
    'SpriteObject_EnableAutoAnimation::',
    'SpriteObject_Show::',
    'SpriteObject_Hide::',
    'Sprite_Update::',
    'SpriteObject_AppendOAM::',
    'SpriteObject_UpdateAnimation::',
    'SpriteObject_LoadAnimationFrame::',
    'Text_QueueHexByte::',
    'assert @ == $31f5',
):
    require(token in source, f'missing source token: {token}')

# The corrected map-cursor wrappers must follow the engine semantics.
cursor = Path('engine/map/map_cursor_presentation_runtime_4551.asm').read_text()
require('MapCursor_Show::\n    ld a, [wMapCursorSpriteObjectId]\n    call SpriteObject_Show' in cursor,
        'MapCursor_Show does not call SpriteObject_Show')
require('MapCursor_Hide::\n    ld a, [wMapCursorSpriteObjectId]\n    call SpriteObject_Hide' in cursor,
        'MapCursor_Hide does not call SpriteObject_Hide')

# No project engine source should keep raw calls to the restored public entries.
raw = ('$2de8','$2e1f','$2e67','$2e87','$2e9a','$2eae','$2ec9','$2ee8',
       '$2f11','$2f2b','$2f45','$2f5f','$2f79','$2f9f','$3048','$3056','$31ca')
for p in Path('engine').rglob('*.asm'):
    if p.name == 'home_sprite_object.asm':
        continue
    text = p.read_text()
    for addr in raw:
        require(f'call {addr}' not in text.lower(), f'raw restored-sprite call remains in {p}: {addr}')

print('sprite object engine: ROM anchors and source integration verified ($2D7C-$31F4)')
print('show/hide semantics: $2F45 = show, $2F5F = hide')
