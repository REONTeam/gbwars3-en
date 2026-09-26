#!/usr/bin/env python3
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
rom=(ROOT/'baserom.gbc').read_bytes()
cases16=[
('ground',0x5561,0x5f81,'gfx/units/battle/ground.2bpp'),
('sea',0x5fc1,0x6e51,'gfx/units/battle/sea.2bpp'),
('air',0x6e91,0x7b21,'gfx/units/battle/air.2bpp'),
('special',0x7b61,0x7d21,'gfx/units/battle/special.2bpp'),]
base=0x16*0x4000
for name,start,end,rel in cases16:
 data=(ROOT/rel).read_bytes(); retail=rom[base+start-0x4000:base+end-0x4000]
 assert data==retail,(name,len(data),len(retail))
g=(ROOT/'data/gfx/graphics.asm').read_text()
for t in ['Image_Battle_Unit_Ground_Tiles::','Image_Battle_Unit_Sea_Tiles::','Image_Battle_Unit_Air_Tiles::','Image_Battle_Unit_Special_Tiles::']:
 assert t in g,t
assert 'Image_Battle_Place_Tiles::' not in g
print('[ok] Bank $16 battle-unit pixels split into runtime-proven ground/sea/air/special groups')
print('[ok] Bank $17 monolithic pseudo-image retired; structured battle-place verification is separate')
