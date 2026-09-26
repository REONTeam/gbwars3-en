#!/usr/bin/env python3
from pathlib import Path
import hashlib
ROOT=Path(__file__).resolve().parents[1]
rom=(ROOT/'baserom.gbc').read_bytes(); base=0x12*0x4000
start,end=0x47ce,0x4837
data=rom[base+start-0x4000:base+end-0x4000]
assert len(data)==105
assert hashlib.sha1(data).hexdigest()=='44a86a9651bdc2e972f4fa190adf00faad8284ee'
src=(ROOT/'engine/unit/unit_setup.asm').read_text()
for t in ['assert @ == $47ce','section "Reserve Unit Storage", romx[$47ce], bank[$12]','ReserveUnits_SaveSide0::','ReserveUnits_RestoreSide0::','wReserveUnitList','assert @ == $4837']:
 assert t in src,t
sym=(ROOT/'symbols.asm').read_text(); assert 'wReserveUnitList equ $c6a8' in sym
print('[ok] Bank $12:$47CE-$4836 reserve-unit storage routines ROM range locked')
print('[ok] the current source movement-cost boundary corrected from $47CF to $47CE')
