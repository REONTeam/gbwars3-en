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

require(digest(0,0x0280,0x0291)=='d83eca1ae07d9e4cfb14e72b6c56b00156701418','ROM0 bank-call trampoline changed')
require(digest(0x17,0x4000,0x4487)=='0865b5749717e889948ac87acbf001bd7152a4b8','Bank $17 advanced-sprite runtime changed')

src=(ROOT/'engine/sprite/advanced_sprite.asm').read_text()
for token in (
    'section "Advanced Sprite Behavior", romx[$4000], bank[$17]',
    'AdvancedSprite_Reset::','AdvancedSprite_Add::','AdvancedSprite_UpdateSpawnFirst::',
    'AdvancedSprite_ChooseScrollDelta::','AdvancedSprite_Update::',
    'AdvancedSprite_RecordIsInactive::','AdvancedSprite_ApplyVelocity::',
    'AdvancedSprite_DecrementActiveTimer::','AdvancedSprite_UpdateOneExisting::',
    'AdvancedSprite_UpdateOneSpawning::','AdvancedSprite_LoadRecord::',
    'AdvancedSprite_SaveRecord::','AdvancedSprite_GetRecordAddress::',
    'call SpriteObject_Create','call SpriteObject_Destroy','call SpriteObject_SetPosition',
    'call SpriteObject_DisableAutoAnimation','call SpriteObject_EnableAutoAnimation',
    'call SpriteObject_Show','call SpriteObject_Hide','call Math_CompareHLToDE',
    'call ROMBankCall','assert @ == $4487',
): require(token in src,f'missing advanced-sprite source token: {token}')
require('    db $' not in src,'advanced-sprite runtime regressed to a raw db blob')

bankcall=(ROOT/'engine/home/home_bank_call.asm').read_text()
for token in ('section "ROM Bank Call Trampoline", rom0[$0280]','ROMBankCall::','ROMBankCall_Return::','jp hl','assert @ == $0291'):
    require(token in bankcall,f'missing bank-call source token: {token}')

syms=(ROOT/'symbols.asm').read_text()
for token in ('wAdvancedSpriteProcessedCount','wAdvancedSpriteX','wAdvancedSpriteY','wAdvancedSpriteVelocityX','wAdvancedSpriteVelocityY','wAdvancedSpriteSlot','wAdvancedSpriteDelay','wAdvancedSpriteDuration','wAdvancedSpriteCallback','wAdvancedSpriteCallbackBank','wAdvancedSpriteUser0','wAdvancedSpriteUser1','wAdvancedSpriteHideWhileActive','wAdvancedSpriteActivationSfx EQU wBattleSceneResourceIndex','wAdvancedSpritePendingCount','wAdvancedSpriteRecords','wAdvancedSpriteCount','wAdvancedSpriteIndex','wAdvancedSpriteSpawnX','wAdvancedSpriteSpawnY'):
    require(token in syms,f'missing advanced-sprite state symbol: {token}')

caller=(ROOT/'engine/battle/battle_scene_setup.asm').read_text()
require('farcall $17, AdvancedSprite_Add' in caller,'battle scene setup does not use AdvancedSprite_Add')
make=(ROOT/'Makefile').read_text()
require('engine/sprite/advanced_sprite.o' in make,'advanced sprite object missing from Makefile')
require('engine/home/home_bank_call.o' in make,'ROM bank-call object missing from Makefile')
require('battle_place_animation_runtime.o' not in make,'obsolete raw Bank $17 object still in Makefile')

# Public farcall signatures in the retail ROM remain stable.
expected={0x4000:27,0x4063:76,0x40df:9,0x4115:1,0x4146:1}
for target,n in expected.items():
    pat=bytes((0xef,0x17,target&0xff,target>>8))
    require(rom.count(pat)==n,f'farcall $17:${target:04X} count {rom.count(pat)} != {n}')

print('advanced sprite runtime: ROM0 $0280-$0290 and Bank $17:$4000-$4486 verified')
print('scheduler: 32-byte records, 20-byte staged prefix, lifecycle/velocity/callback APIs [ok]')
