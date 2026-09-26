#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes()
if len(rom)!=0x100000: raise SystemExit(f'[fail] unexpected ROM size: {len(rom):#x}')
def cut(a,b):
    off=0x12*0x4000+(a-0x4000)
    return rom[off:off+b-a]
# Boundary correction: these three bytes are the tail of Unit_InitRecordFromDefinition.
tail=cut(0x423e,0x4241)
if tail != bytes.fromhex('34 f1 c9'):
    raise SystemExit('[fail] $423E-$4240 is not the expected initial-unit tail')
blob=cut(0x4241,0x425c)
expected='ca982a2d42af09b8a1230e1da6124f1cb2a839ff'
sha=hashlib.sha1(blob).hexdigest()
if sha!=expected: raise SystemExit(f'[fail] built-counter SHA-1 {sha} != {expected}')
src=(ROOT/'engine/unit/unit_setup.asm').read_text(); syms=(ROOT/'symbols.asm').read_text()
for x in ['assert @ == $4241','section "Unit Built Counter", romx[$4241], bank[$12]','Unit_IncrementBuiltCountForEncodedSide::','ld hl, wUnitBuiltCountSide0','cp $ff','assert @ == $425c']:
    if x not in src: raise SystemExit(f'[fail] missing source form: {x}')
for x in ['sym $00, $c8b3, wUnitBuiltCountSide0','sym $00, $c8b5, wUnitBuiltCountSide1']:
    if x not in syms: raise SystemExit(f'[fail] missing built-counter symbol: {x}')
if '$423E-$425B remains overlay-owned' in src:
    raise SystemExit('[fail] stale overlay-owned boundary comment remains')
print('[ok] corrected Unit_InitRecordFromDefinition end: $4241')
print(f'[ok] Bank $12:$4241-$425B: {len(blob)} retail bytes, SHA-1 {sha}')
print('[ok] side-specific built-unit counter increment/saturation is source-backed')
