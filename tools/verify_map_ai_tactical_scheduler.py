#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes()
src=(ROOT/'engine/map/ai/map_ai_tactical_scheduler.asm').read_text()
start,end=0x4321,0x4407
vals=[]
for line in src.splitlines():
    code=line.split(';',1)[0]
    if re.match(r'\s*db\s',code,re.I):
        vals += [int(x,16) for x in re.findall(r'\$([0-9a-fA-F]{2})',code)]
got=bytes(vals)
off=0x0d*0x4000+(start-0x4000)
retail=rom[off:off+(end-start)]
if got!=retail:
    raise SystemExit(f'byte mismatch: source {len(got)} retail {len(retail)}')
sha=hashlib.sha1(got).hexdigest()
expected='d459d3c9177f2aa1c129dd941df031fc807ddf0a'
if sha!=expected: raise SystemExit(f'hash mismatch {sha}')
# Boundary proof: $4320 is zero and direct calls target $4321, not $4320.
bank=rom[0x0d*0x4000:0x0e*0x4000]
if bank[0x4320-0x4000] != 0: raise SystemExit('$4320 is not terminating zero data')
pat=bytes([0xcd,0x21,0x43])
callers=[]; i=0
while True:
    i=bank.find(pat,i)
    if i<0: break
    callers.append(0x4000+i); i+=1
if callers != [0x4056,0x40e3]:
    raise SystemExit(f'unexpected $4321 direct callers {callers}')
for name in ['MapAI_TacticalSchedulerLeadIn::','MapAI_FindBestTacticalUnitCandidate::']:
    if name not in src: raise SystemExit(f'missing {name}')
print(f'[ok] the current source tactical scheduler: {len(got)} retail bytes exact, SHA-1 {sha}; $4321 boundary/callers locked')
