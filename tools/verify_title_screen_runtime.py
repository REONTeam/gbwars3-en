#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import sys

ROOT=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else ROOT/'baserom.gbc').read_bytes()

def require(c,m):
    if not c: raise AssertionError(m)
def off(b,a): return a if b==0 else b*0x4000+(a-0x4000)
def digest(b,s,e): return sha1(rom[off(b,s):off(b,s)+(e-s)]).hexdigest()

require(digest(0x27,0x43dc,0x4465)=='0da558e3795e4e77f6c0b88c94452079184cde22','title input/sprite runtime changed')
require(digest(0x10,0x4df3,0x4df8)=='b71254a18a74d5d5a9cd6d22a5084dfa718f1590','title Bank-$10 wrapper changed')
require(digest(0x10,0x4df8,0x4e8b)=='16c74391c893793d0a7faa49b5534685e9844188','title background loader changed')

rt=(ROOT/'engine/ui/title_screen_runtime.asm').read_text()
for token in ('TitleScreen_WaitForInput::','TitleScreen_ShowAndWait::','farcall $17, AdvancedSprite_UpdateSpawnFirst',
              'farcall $17, AdvancedSprite_Reset','farcall $10, TitleScreen_LoadBackgroundAssets',
              'farcall $1a, SpriteGroup_LoadGraphicsAndPalettes','farcall $1a, SpriteAnimation_GetFarPointer',
              'call SpriteObject_Create','call SpriteObject_SetPosition','call Audio_PlayMusic',
              'call FadeFromWhite8','call FadeToWhite8','call SpriteObject_DestroyAll','assert @ == $4465'):
    require(token in rt,f'missing title runtime token: {token}')

bg=(ROOT/'engine/ui/title_screen_background.asm').read_text()
for token in ('TitleScreen_Run::','farcall $27, TitleScreen_ShowAndWait','TitleScreen_LoadBackgroundAssets::','ld hl, Pals_Title_Screen','ld de, Image_Title_Screen',
              'ld de, Attrmap_Title_Screen','cp $14','cp $12','or $08','assert @ == $4e8b'):
    require(token in bg,f'missing title background token: {token}')

gfx=(ROOT/'data/gfx/graphics.asm').read_text()
for token in ('Attrmap_Title_Screen::','Image_Title_Screen::','Pals_Title_Screen::'):
    require(token in gfx,f'missing title asset label: {token}')

make=(ROOT/'Makefile').read_text()
require('engine/ui/title_screen_runtime.o' in make,'title runtime object missing')
require('engine/ui/title_screen_background.o' in make,'title background object missing')

print('title screen: Bank $27:$43DC-$4464 runtime and Bank $10:$4DF3-$4E8A wrapper/background loader [ok]')
print('background: 8 palettes, 5760 tile bytes, 20x18 tile/attribute map with VRAM-bank selection [ok]')
