#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
ROOT=Path(__file__).resolve().parents[1]
if len(sys.argv)!=2: raise SystemExit('usage: verify_map_control_runtime_gap.py baserom.gbc')
rom=Path(sys.argv[1]).read_bytes(); src=(ROOT/'engine/map/ai/map_control_force.asm').read_text()
def sl(bank,s,e):
 o=bank*0x4000+(s-0x4000); return rom[o:o+e-s]
checks=[
 (0x0d,0x6650,0x670e,'f62632ca7668c8c2bb86df05daeecf6ce7ec47a6'),
 (0x0d,0x6618,0x6758,'5171d604129ab9450a6aee58d7ab4bb6686d660a'),
]
for b,s,e,h in checks:
 d=sl(b,s,e); assert hashlib.sha1(d).hexdigest()==h,(b,s,e)
required=['MapControl_InitializeRuntimeOnce::','MapControl_InitializePhaseRuntime::','MapControl_PhaseParamsSide0:','MapControl_PhaseParamsSide1:','MapControl_ClassifyForceBalance::','db 0, 0, 50, 0','db 1, 50, 0, 11','ld [wMapControlForceClass], a','assert @ == $670e']
for t in required: assert t in src,t
# ROM0 controller farcalls prove the first two entry points are public map-runtime phases.
for caller,target in [(0x2633,0x6650),(0x2637,0x6679)]:
 assert rom[caller:caller+4]==bytes([0xef,0x0d,target&0xff,target>>8]),(caller,target)
# Exact phase parameter bytes embedded in the gap.
assert sl(0x0d,0x66a9,0x66b1)==bytes([0,0,50,0,1,50,0,11])
print('[ok] Bank $0D:$6650-$670D map-control runtime gap is classified and ROM-locked')
