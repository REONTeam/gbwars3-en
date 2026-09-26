#!/usr/bin/env python3
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else ROOT/'baserom.gbc').read_bytes()
def off(bank,addr): return bank*0x4000+(addr-0x4000)
def chunk(a,b): return rom[off(0x24,a):off(0x24,b)]
def req(c,m):
    if not c: raise AssertionError(m)
d=ROOT/'gfx/campaign/map_select/resources'
spec=[('campaign_map_select_page0_graphics_tail.2bpp',0x5e10,0x5e60),('campaign_map_select_page0_palettes.pal',0x5e60,0x5ea0)]
for n,start in enumerate([0x5ea0,0x66b0,0x6ec0,0x76d0],1):spec += [(f'campaign_map_select_page{n}_graphics.2bpp',start,start+0x7d0),(f'campaign_map_select_page{n}_palettes.pal',start+0x7d0,start+0x810)]
for n,a,b in spec:req((d/n).read_bytes()==chunk(a,b),f'{n} mismatch')
req(all(x==0xff for x in chunk(0x7ee0,0x8000)),'Bank24 end padding mismatch')
s=(ROOT/'engine/campaign/campaign_map_select_resources_bank24.asm').read_text()
for t in ('CampaignMapSelectPage0GraphicsTail::','CampaignMapSelectPage4Palettes::','assert @ == $7ee0'):req(t in s,f'missing source token {t}')
print('Campaign map-selector format-specific resources [ok]')
