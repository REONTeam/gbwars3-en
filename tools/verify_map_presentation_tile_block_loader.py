#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
ROOT=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else ROOT/'baserom.gbc').read_bytes()
bank,start,end=0x0b,0x765d,0x766c
off=bank*0x4000+(start-0x4000); data=rom[off:off+end-start]
expected=bytes.fromhex('c5e521785806030e01cdd906e1c1c9')
assert data==expected
assert hashlib.sha1(data).hexdigest()=='4407ab6fbb9f6606372b6a6f9ecfe1952baa2c39'
src=(ROOT/'engine/map/map_presentation_tile_block_loader_765d.asm').read_text()
for x in ['MapPresentation_LoadThreeTileBlock::','ld hl, $5878','ld b, $03','ld c, $01','call $06d9','assert @ == $766c']: assert x in src
# Exact whole-ROM farcall entry inventory.
pat=bytes([0xef,0x0b,0x5d,0x76]); got=[]; p=0
while True:
 i=rom.find(pat,p)
 if i<0: break
 b=i//0x4000; a=(i%0x4000)+(0x4000 if b else 0); got.append((b,a)); p=i+1
assert set(got)=={(0x0c,0x4c9a),(0x18,0x671e),(0x25,0x413a),(0x25,0x6763),(0x25,0x772f),(0x25,0x7821),(0x27,0x5f7d)}
# Next entry is independently farcalled.
assert bytes([0xef,0x0b,0x6c,0x76]) in rom
assert 'farcall MapPresentation_LoadThreeTileBlock' in (ROOT/'engine/battle/battle_combat_runtime.asm').read_text()
print('Map presentation 3-tile block loader verification: OK')
