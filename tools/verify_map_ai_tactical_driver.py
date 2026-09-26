#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROM=Path(sys.argv[1]); SRC=Path('engine/map/ai/map_ai_tactical_driver.asm')
rom=ROM.read_bytes(); src=SRC.read_text(); start,end=0x4000,0x4106
vals=[]
for line in src.splitlines():
    code=line.split(';',1)[0]
    if 'db ' not in code: continue
    for tok in code.split('db ',1)[1].split(','):
        tok=tok.strip()
        if re.fullmatch(r'\$[0-9a-fA-F]{2}',tok): vals.append(int(tok[1:],16))
got=bytes(vals); off=0x0d*0x4000+(start-0x4000); exp=rom[off:off+end-start]
assert got==exp,(len(got),len(exp))
sha=hashlib.sha1(got).hexdigest(); assert sha=='c6d7de81166ae03a004eda5f63eddaebbd079d78',sha
for marker in ('MapAI_TacticalPlanningSweepA::','MapAI_TacticalPlanningWorkerA::','MapAI_TacticalPlanningSweepB::','MapAI_TacticalPlanningWorkerB::'):
    assert marker in src,marker
# Boundary proof: sweep B starts with the same ld a,[$C9A2] pattern as sweep A.
bank=rom[0x0d*0x4000:0x0e*0x4000]
assert bank[0:3]==bytes.fromhex('faa2c9')
assert bank[0x4097-0x4000:0x409a-0x4000]==bytes.fromhex('faa2c9')
# Direct worker call sites.
assert bank[0x4022-0x4000:0x4025-0x4000]==bytes.fromhex('cd3340')
assert bank[0x40b5-0x4000:0x40b8-0x4000]==bytes.fromhex('cdc640')
# Worker A directly calls the corrected selector entry at $4106.
assert bank[0x404f-0x4000:0x4052-0x4000]==bytes.fromhex('cd0641')
print(f'[ok] the current source tactical driver: {len(got)} retail bytes exact, SHA-1 {sha}; $4097/$4106 boundaries locked')
