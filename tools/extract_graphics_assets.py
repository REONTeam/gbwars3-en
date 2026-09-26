#!/usr/bin/env python3
"""Organize proven map icons and extract conservative ROM-backed battle graphics references."""
from pathlib import Path
from PIL import Image
import re, sys, hashlib
ROOT=Path(__file__).resolve().parents[1]
ROM=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'

def render_2bpp(data: bytes, cols: int) -> Image.Image:
    tiles=(len(data)+15)//16; rows=(tiles+cols-1)//cols
    im=Image.new('P',(cols*8,rows*8),0)
    im.putpalette([255,255,255,170,170,170,85,85,85,0,0,0]+[0,0,0]*252)
    px=im.load()
    for n in range(tiles):
        tile=data[n*16:(n+1)*16].ljust(16,b'\0')
        ox=(n%cols)*8; oy=(n//cols)*8
        for y in range(8):
            lo,hi=tile[y*2:y*2+2]
            for x in range(8):
                bit=7-x; px[ox+x,oy+y]=(((hi>>bit)&1)<<1)|((lo>>bit)&1)
    return im

# Unit map icons are ordered by UnitData pointer-table order; 53 records are proven.
unit_src=(ROOT/'engine/unit/unit.asm').read_text()
block=unit_src.split('UnitData:',1)[1].split('assert @ - UnitData',1)[0]
unit_labels=re.findall(r'^\s*dw \.([a-zA-Z0-9_]+)\s*$', block, re.M)
if len(unit_labels)!=53:
    raise SystemExit(f'expected 53 UnitData pointers, found {len(unit_labels)}')
master=Image.open(ROOT/'gfx/units/source_tiles/map_icons.png').convert('RGBA')
# The physical sheet has 53 16x16 groups. Groups 0-51 map to UnitData
# entries 1-52; group 52 is the extra special overlay graphic. UnitData 0
# (EMPTY) has no dedicated physical sheet group.
raw_entries=[(i-1, i, unit_labels[i]) for i in range(1,53)] + [(52, None, 'special_overlay_9e')]
for sheet_index,unit_index,name in raw_entries:
    x=(sheet_index%8)*16; y=(sheet_index//8)*16
    icon=master.crop((x,y,x+16,y+16))
    if unit_index is None: cat='special'
    elif unit_index<=28: cat='ground'
    elif unit_index<=43: cat='air'
    elif unit_index<=52: cat='sea'
    else: cat='special'
    out=ROOT/'gfx/units/map_icons/raw_sheet_crops'/cat
    out.mkdir(parents=True,exist_ok=True)
    prefix=f'{unit_index:02d}' if unit_index is not None else 'special'
    icon.save(out/f'{prefix}_{name}.png')

if ROM.exists():
    rom=ROM.read_bytes()
    if len(rom) < 0x100000: raise SystemExit('ROM is unexpectedly small')
    def bank_slice(bank,start,end):
        off=bank*0x4000+(start-0x4000)
        return rom[off:off+(end-start)]
    # Bank $16 is no longer extracted as a broad pseudo-image: the current source sources its
    # UnitData-indexed layout/descriptor layer and owns exact pixel groups separately.
    # Bank $17 remains conservative until its corresponding loader is sourced.
    b17=bank_slice(0x17,0x4A00,0x73E0)
print('unit map icon sheet groups',len(raw_entries))
