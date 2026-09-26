#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
root=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else root/'baserom.gbc'
rom=rom_path.read_bytes()
if len(rom)!=0x100000: raise SystemExit(f'[fail] unexpected ROM size: {len(rom):#x}')
def cut(a,b):
 o=0x12*0x4000+(a-0x4000); return rom[o:o+b-a]
blob=cut(0x425c,0x42f6); sha=hashlib.sha1(blob).hexdigest(); exp='9ae693bef58ab42417a5046bb9c5e157036fb0f7'
if sha!=exp: raise SystemExit(f'[fail] deletion range SHA-1 {sha} != {exp}')
src=(root/'engine/unit/unit_setup.asm').read_text(); syms=(root/'symbols.asm').read_text()
for x in ['Unit_DeleteWithCarriedAtCoordinates::','Unit_DeleteRecord::','assert @ == $42f6','ld hl, wUnitCountBySide','ld hl, wUnitLostCountSide0','ld hl, wUnitLostCountSide1','bit UNIT_RECORD_STATUS_CARRIED_F, a','ld bc, UNIT_RECORD_SIZE','call Memset']:
 if x not in src: raise SystemExit(f'[fail] missing source form: {x}')
for x in ['sym $00, $c8b7, wUnitLostCountSide0','sym $00, $c8b9, wUnitLostCountSide1']:
 if x not in syms: raise SystemExit(f'[fail] missing symbol: {x}')
for a,b,h in [(0x425c,0x42b2,'a7eb438568baea8d30b23ca64b42ce22499d8f4c'),(0x42b2,0x42f6,'64006d007464de2c80b2f8569051af5c25fd1104')]:
 if hashlib.sha1(cut(a,b)).hexdigest()!=h: raise SystemExit(f'[fail] subrange ${a:04X}-${b-1:04X}')
print(f'[ok] Bank $12:$425C-$42F5: {len(blob)} retail bytes, SHA-1 {sha}')
print('[ok] delete-with-carried path and record-clear/count-maintenance path represented')
print('[ok] side live-count decrement and side deletion-counter increment are source-backed')
