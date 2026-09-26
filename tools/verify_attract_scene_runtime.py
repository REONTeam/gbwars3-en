#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import sys

ROOT = Path(__file__).resolve().parents[1]
rom = Path(sys.argv[1] if len(sys.argv) > 1 else ROOT/'baserom.gbc').read_bytes()

def require(c,m):
    if not c: raise AssertionError(m)

def off(bank,addr): return bank*0x4000+(addr-0x4000)
def digest(start,end): return sha1(rom[off(0x23,start):off(0x23,end)]).hexdigest()

require(digest(0x4000,0x42be)=='d7a92e09e08d186b87381bc80293257e57157a31','attract scene controller range changed')
require(digest(0x4316,0x48ac)=='c44e060ba61a61988fd59808ce2e2608f66b6124','attract scene streams/transition range changed')

src=(ROOT/'engine/ui/attract_scene_runtime.asm').read_text()
for token in (
    'AttractScene_Run::','AttractScene_LoadPresentation::','AttractSceneDescriptorPointers::',
    'AttractScene_SetupTextLayer::','AttractScene_UpdateText::','AttractSceneScriptPointers::',
    'AttractScene_RunSequence4Transition::','AttractText_ShowPlayNextArea15::',
    'AttractScene0GraphicsWindow, AttractScene0Palettes, AttractScene0Tilemap, AttractScene0Attributes',
    'AttractScene1GraphicsWindow, AttractScene1Palettes, AttractScene1Tilemap, AttractScene1Attributes',
    'AttractScene2GraphicsWindow, AttractScene2Palettes, AttractScene2Tilemap, AttractScene2Attributes',
    'AttractScene5GraphicsWindow, AttractScene5Palettes, AttractScene5Tilemap, AttractScene5Attributes',
    'dw AttractSceneScript_0','dw AttractSceneScript_5',
    'jr AttractText_RunCurrentSequence','assert @ == $48ac'):
    require(token in src, f'missing attract-scene token: {token}')
for i in range(6):
    require(f'AttractSceneDescriptor_{i}::' in src, f'missing descriptor {i}')
    require(f'AttractSceneScript_{i}::' in src, f'missing script stream {i}')

intro=(ROOT/'engine/ui/attract_intro_runtime.asm').read_text()
require('AttractText_RunCurrentSequence::' in intro,'shared current-sequence text entry missing')

mk=(ROOT/'Makefile').read_text()
require('engine/ui/attract_scene_runtime.o' in mk,'Makefile missing attract scene runtime object')

# Stream boundaries are exact: each physical block terminates with 00 immediately
# before the next fixed section.
for start,end in ((0x4322,0x4405),(0x4405,0x44af),(0x44af,0x4582),(0x4582,0x4651),(0x4651,0x4726),(0x4726,0x4773)):
    data=rom[off(0x23,start):off(0x23,end)]
    require(data[-1]==0, f'stream {start:04x} does not end in 00')
    require(0 not in data[:-1], f'stream {start:04x} contains an early 00 terminator')

print('attract scenes: six-scene controller, descriptors, and script streams [ok]')
print('attract scene 4 transition and shared post-scene text handoff [ok]')
