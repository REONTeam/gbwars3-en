#!/usr/bin/env python3
from pathlib import Path
import csv, hashlib, re
ROOT=Path(__file__).resolve().parents[1]
rom=(ROOT/'baserom.gbc').read_bytes()
base=0x17*0x4000
start=0x47cb
raw=rom[base+start-0x4000:base+start-0x4000+0x208]
assert hashlib.sha1(raw).hexdigest()=='909187ff98168b0d58847136645687d9032d0eda'
rows=[]
for i in range(52):
 q=raw[i*10:(i+1)*10]
 rows.append([q[j]|q[j+1]<<8 for j in range(0,10,2)])
assert len(set(r[0] for r in rows))==24
assert set(r[4] for r in rows)=={0,2,4}
src=(ROOT/'engine/battle/battle_place_graphics.asm').read_text()
records=re.findall(r'battle_place_record BattlePlaceGraphics_([0-9A-F]{4}), BattlePlaceLayout_([0-9A-F]{4}), BattlePlaceAttributes_([0-9A-F]{4}), BattlePlacePalette_([0-9A-F]{4}), ([A-Za-z0-9_$]+)',src,re.I)
assert len(records)==52
variant_values={'BATTLE_PLACE_PALETTE_VARIANT_PRIMARY':0,'BATTLE_PLACE_PALETTE_VARIANT_SIDE0':0,'BATTLE_PLACE_PALETTE_VARIANT_SIDE1':2,'BATTLE_PLACE_PALETTE_VARIANT_NEUTRAL':4}
parsed=[]
for row in records:
 vals=[int(x,16) for x in row[:4]]
 tok=row[4]; vals.append(int(tok[1:],16) if tok.startswith('$') else variant_values[tok])
 parsed.append(vals)
assert parsed==rows
csvp=ROOT/'gfx/environment/battle_places/runtime_windows/map_tile_records.csv'
with csvp.open() as f: cr=list(csv.DictReader(f))
assert len(cr)==52
assert list(cr[0])==['map_tile_id','terrain_class','graphics_window_ptr','tilemap_ptr','attributes_ptr','palette_ptr','palette_variant','graphics_window_sha1']
windows=list((csvp.parent).glob('[0-9a-f][0-9a-f]_*.png'))
assert len(windows)==52,len(windows)
# The first pointer is consumed as a $160-byte battle-place graphics copy window.
for i,row in enumerate(rows):
 ptr=row[0]; data=rom[base+ptr-0x4000:base+ptr-0x4000+0x160]
 assert hashlib.sha1(data).hexdigest()==cr[i]['graphics_window_sha1']
assert 'bank17_tiles.2bpp' not in (ROOT/'data/gfx/graphics.asm').read_text()
print('[ok] Bank $17:$47CB-$49D2: 52 x 10-byte battle-place map-tile records ROM-verified')
print('[ok] first-pointer $160-byte runtime windows: 52 runtime-window images / 24 unique sources; monolithic Bank $17 pseudo-image removed')

# the current source terminology: animation-pointer accessor and 33 x 24-byte pointer matrix.
access=rom[base+0x477d-0x4000:base+0x47cb-0x4000]
assert len(access)==0x4e
assert hashlib.sha1(access).hexdigest()=='8a043c83f63fde24266a011ea520f89ba6c84d46'
matrix=rom[base+0x49d3-0x4000:base+0x4ceb-0x4000]
assert len(matrix)==33*24
assert hashlib.sha1(matrix).hexdigest()=='e89de1174c31d2657a3bf8bd753a163fff8709c4'
mrows=[]
for i in range(33):
 q=matrix[i*24:(i+1)*24]
 mrows.append([q[j]|q[j+1]<<8 for j in range(0,24,2)])
# Parse the two six-word side lines emitted for every matrix row.
mlines=re.findall(r'battle_place_animation_side (.+)',src,re.I)
assert len(mlines)==66,len(mlines)
parsed_sides=[]
for line in mlines:
 vals=[]
 for tok in [x.strip() for x in line.split(';',1)[0].split(',')]:
  m=re.fullmatch(r'\$([0-9a-f]{4})',tok,re.I)
  if m: vals.append(int(m.group(1),16)); continue
  m=re.fullmatch(r'BattlePlaceAnim_([0-9A-F]{4})',tok,re.I)
  assert m,tok
  vals.append(int(m.group(1),16))
 assert len(vals)==6
 parsed_sides.append(vals)
for i,row in enumerate(mrows):
 assert parsed_sides[i*2]+parsed_sides[i*2+1]==row
csvm=ROOT/'gfx/environment/battle_places/animation_pointer_matrix.csv'
with csvm.open() as f: mr=list(csv.DictReader(f))
assert len(mr)==33*2*3
for rec in mr:
 row=int(rec['row'],16); side=int(rec['side']); sub=int(rec['subvariant'])
 vals=mrows[row][side*6:(side+1)*6]
 assert int(rec['slot0_animation_ptr'],16)==vals[sub*2]
 assert int(rec['slot1_animation_ptr'],16)==vals[sub*2+1]
assert 'BattlePlace_GetAnimationPointer::' in src
assert 'wBattlePlacePointerVariant' in (ROOT/'symbols.asm').read_text()
print('[ok] Bank $17:$477D return + $477E-$47CA animation-pointer accessor ROM-locked (78 bytes)')
print('[ok] Bank $17:$49D3-$4CEA animation-pointer matrix: 33 rows x 2 sides x 3 subvariants x 2 slots (396 pointers)')

# the current source: direct record renderer consumers prove the four record roles.
for start,end,sha,label in [
    (0x4487,0x44a1,'750114a01ade10fc87f969ea7d3c274290d876f4','graphics-window loader'),
    (0x45b0,0x4640,'0ac7b7475d89caa890626f157a977b2d6975c305','record renderer'),
    (0x4640,0x4755,'f42af5de4ce09acfa56d5f22853f28fcd8852785','9x3 tilemap/attribute renderer'),
    (0x4755,0x4768,'381592cb3f7867dc94b17f22f93df877f3225622','palette-pair loader'),
]:
    d=rom[base+start-0x4000:base+end-0x4000]
    assert hashlib.sha1(d).hexdigest()==sha,(label,hashlib.sha1(d).hexdigest())
for label in ['BattlePlace_LoadGraphicsWindow::','BattlePlace_RenderRecord::','BattlePlace_RenderTilemapAttributes::','BattlePlace_LoadPalettePair::']:
    assert label in src
home=(ROOT/'engine/home/home_map.asm').read_text()
assert 'MultiplyAByB::' in home
mul=rom[0x2995:0x29ad]
assert hashlib.sha1(mul).hexdigest()=='957f236a83c2748b3c6f97a606eead89fb8b187b'
print('[ok] Bank $17 record consumers source-backed: graphics window, 9x3 tilemap/attributes, two-palette variant loader')
print('[ok] ROM0:$2995-$29AC unsigned A*B helper source-backed for table indexing')
