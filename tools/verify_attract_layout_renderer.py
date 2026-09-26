#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import sys
ROOT=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else ROOT/'baserom.gbc').read_bytes()
def require(c,m):
    if not c: raise AssertionError(m)
data=rom[0x35fe:0x36c4]
require(len(data)==198 and sha1(data).hexdigest()=='79d20d581c1832c3544e6957be430c5e1127ee80','ROM0 attract layout renderer changed')
src=(ROOT/'engine/home/home_attract_layout.asm').read_text()
for token in ('section "Attract Scene Layout Renderer", rom0[$35fe]','AttractScene_RenderLayout::','set 3, a','add $03','assert @ == $36c4'):
    require(token in src,f'missing attract layout token: {token}')
scene=(ROOT/'engine/ui/attract_scene_runtime.asm').read_text()
require('call AttractScene_RenderLayout' in scene,'attract scene does not use symbolic layout renderer')
require('call $35fe' not in scene,'raw $35FE call remains in attract scene source')
print('attract layout renderer: ROM0 $35FE-$36C3 bytes and symbolic consumer [ok]')
