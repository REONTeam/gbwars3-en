#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes()
src=(ROOT/'engine/map/ai/map_ai_tactical_helpers.asm').read_text()
RANGES=[
(0x44EE,0x469F,'ec745a7bd84ca38fa9632b5e52145866bd57901d'),
(0x46B7,0x471D,'fb2c53fd396516364d97fb85a7d3a81bfbce335a'),
]
# Parse db rows section by section. This file intentionally uses byte rows until
# lower-level ranking contracts justify mnemonic conversion.
for start,end,sha in RANGES:
    sec=re.search(rf'romx\[\${start:04x}\].*?\n(.*?)(?=\nsection |\Z)',src,re.S|re.I)
    if not sec: raise SystemExit(f'missing section ${start:04X}')
    vals=[]
    for line in sec.group(1).splitlines():
        code=line.split(';',1)[0]
        if re.match(r'\s*db\s',code,re.I):
            vals += [int(x,16) for x in re.findall(r'\$([0-9a-fA-F]{2})',code)]
    got=bytes(vals)
    off=0x0D*0x4000+(start-0x4000)
    retail=rom[off:off+(end-start)]
    if got != retail:
        raise SystemExit(f'byte mismatch ${start:04X}-${end-1:04X}: source {len(got)} vs retail {len(retail)}')
    if hashlib.sha1(got).hexdigest()!=sha:
        raise SystemExit(f'hash mismatch ${start:04X}-${end-1:04X}')
# Behavior-backed action staging entry points inside span A.
checks={
    'MapAI_StageAndExecuteDirectAttackAtCoordinates':0x44EE,
    'MapAI_DispatchCaptureAtCoordinates':0x4654,
    'MapAI_DispatchDevelopAtCoordinates':0x4665,
    'MapAI_DispatchAreaAttackAtCoordinates':0x468B,
}
for name,addr in checks.items():
    if f'{name}::' not in src: raise SystemExit(f'missing {name}')
# Exact action-code stores: LD A,id / LD [wMapAIActionCode],A is 3E id EA EC C5.
bank=rom[0x0D*0x4000:0x0E*0x4000]
for addr,action in [(0x4507,3),(0x4654,1),(0x4665,2),(0x468B,5)]:
    i=addr-0x4000
    # 44EE path has target stores before the action store at 4507; others start with it.
    if bank[i:i+5] != bytes([0x3E,action,0xEA,0xEC,0xC5]):
        raise SystemExit(f'action staging mismatch at ${addr:04X}')
print('[ok] the current source tactical helper split: A/B action-staging ranges remain retail-exact; scorer moved to map_ai_attack_scoring.asm')
