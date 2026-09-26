#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,csv
ROOT=Path(__file__).resolve().parents[1]
rom=(ROOT/'baserom.gbc').read_bytes(); base=0x16*0x4000
src=(ROOT/'engine/battle/battle_unit_graphics.asm').read_text()
assert 'assert @ == $5561' in src
# 52 pointers
pt=rom[base+0x4a48-0x4000:base+0x4ab0-0x4000]
ptrs=[pt[i]|pt[i+1]<<8 for i in range(0,len(pt),2)]
assert len(ptrs)==52 and ptrs[0]==0x4ab0 and ptrs[-1]==0x5414
assert all(0x4ab0<=x<0x5444 for x in ptrs)
# exact pixel groups
cases=[('ground',0x5561,0x5f81,162),('sea',0x5fc1,0x6e51,233),('air',0x6e91,0x7b21,201),('special',0x7b61,0x7d21,28)]
for name,s,e,tiles in cases:
 d=(ROOT/f'gfx/units/battle/{name}.2bpp').read_bytes(); retail=rom[base+s-0x4000:base+e-0x4000]
 assert d==retail,(name,len(d),len(retail)); assert len(d)==tiles*16
# descriptors exactly bound unit pixel groups
raw=rom[base+0x5444-0x4000:base+0x5561-0x4000]
assert len(raw)==57*5
bases=[raw[i]|raw[i+1]<<8 for i in range(0,len(raw),5)]
assert bases[:29]==[0x5561]*29
assert bases[29:44]==[0x6e91]*15
assert bases[44:52]==[0x5fc1]*8
assert bases[52:]==[0x7b61]*5
print('[ok] Bank $16 battle-unit layout: 52 UnitData pointers + 57 sprite descriptors')
print('[ok] pixel groups: ground 162, air 201, sea 233, special 28 tiles; all byte-exact retail')
