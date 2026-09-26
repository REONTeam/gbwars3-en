#!/usr/bin/env python3
from pathlib import Path
from PIL import Image
import sys
ROOT=Path(__file__).resolve().parents[1]
ROM=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
assert Image.open(ROOT/'gfx/units/source_tiles/map_icons.png').size==(128,112)
assert Image.open(ROOT/'gfx/units/map_icons.png').size==(160,140)
composed=list((ROOT/'gfx/units/map_icons/composed').rglob('*.png')); assert composed
for rel in ['ground','sea','air','special']:
    assert (ROOT/f'gfx/units/battle/{rel}.png').exists()
    assert (ROOT/f'gfx/units/battle/source_tiles/{rel}.png').exists()
runtime=ROOT/'gfx/environment/battle_places/runtime_windows'
assert (runtime/'map_tile_records.csv').exists(); assert len(list(runtime.glob('[0-9a-f][0-9a-f]_*.png')))==52
assert not (ROOT/'gfx/environment/battle_places/bank17_tiles.2bpp').exists()
if ROM.exists():
    rom=ROM.read_bytes(); built=ROOT/'gfx/units/map_icons.2bpp'
    if built.exists():
        data=built.read_bytes(); off=1*0x4000+(0x5898-0x4000); assert data==rom[off:off+len(data)]
print('[ok] graphics layout: recognizable atlases separated from technical ROM-order tile sources')
