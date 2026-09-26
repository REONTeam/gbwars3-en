#!/usr/bin/env python3
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else ROOT/'baserom.gbc').read_bytes()
def off(bank,addr): return bank*0x4000+(addr-0x4000)
def chunk(a,b): return rom[off(0x24,a):off(0x24,b)]
def req(c,m):
    if not c: raise AssertionError(m)
d=ROOT/'gfx/attract/resources_bank24'
spec=[('scene2.tilemap',0x4000,0x40c8),('scene2.attrmap',0x40c8,0x4190),('scene2.2bpp',0x4190,0x4c40),('scene2_pal_0.pal',0x4c40,0x4c68),('scene2_pal_1.pal',0x4c68,0x4c80),('scene5.tilemap',0x4c80,0x4d48),('scene5.attrmap',0x4d48,0x4e10),('scene5.2bpp',0x4e10,0x5640),('scene5_pal_0.pal',0x5640,0x5668),('scene5_pal_1.pal',0x5668,0x5690),('campaign_map_select_page0.2bpp',0x5690,0x5e10)]
for n,a,b in spec:req((d/n).read_bytes()==chunk(a,b),f'{n} mismatch')
s=(ROOT/'engine/ui/attract_scene_resources_bank24.asm').read_text()
for t in ('AttractScene2Tilemap::','AttractScene5Tilemap::','CampaignMapSelectPage0Graphics::','assert @ == $5e10'):req(t in s,f'missing source token {t}')
print('attract Bank24 format-specific resources [ok]')
