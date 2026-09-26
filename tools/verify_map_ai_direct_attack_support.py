#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/map/ai/map_ai_direct_attack_support.asm').read_text()
start,end=0x4BE1,0x4E53
vals=[]
for line in src.splitlines():
    code=line.split(';',1)[0]
    if re.match(r'\s*db\s',code,re.I):
        vals += [int(x,16) for x in re.findall(r'\$([0-9a-fA-F]{2})',code)]
got=bytes(vals); off=0x0D*0x4000+(start-0x4000); retail=rom[off:off+(end-start)]
if got != retail: raise SystemExit(f'byte mismatch: source {len(got)} retail {len(retail)}')
sha=hashlib.sha1(got).hexdigest(); expected=hashlib.sha1(retail).hexdigest()
if sha != expected: raise SystemExit('hash mismatch')
entries={
'MapAI_PrepareDirectAttackCandidate':0x4BE1,
'MapAI_PrepareDirectAttackCandidateCore':0x4BE5,
'MapAI_FindDirectAttackTargetFamily0':0x4C4F,
'MapAI_FindDirectAttackApproachFamily0':0x4CCA,
'MapAI_FindDirectAttackTargetFamily1':0x4D3A,
'MapAI_FindDirectAttackApproachFamily1':0x4D99,
}
for name in entries:
    if f'{name}::' not in src: raise SystemExit(f'missing {name}')
# Direct calls from the source-owned current source planner prove these public boundaries.
bank=rom[0x0D*0x4000:0x0E*0x4000]
for addr in [0x4BE1,0x4C4F,0x4CCA,0x4D3A,0x4D99]:
    pat=bytes([0xCD,addr&0xff,addr>>8])
    if bank.find(pat,0x6183-0x4000,0x6325-0x4000) < 0:
        raise SystemExit(f'no current source planner call to ${addr:04X}')
print(f'[ok] the current source direct-attack support: {len(got)} retail bytes exact, SHA-1 {sha}; planner-call boundaries locked')
