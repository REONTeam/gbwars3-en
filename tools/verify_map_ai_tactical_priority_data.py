#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); bank=rom[0x0d*0x4000:0x0e*0x4000]
src=(ROOT/'engine/map/ai/map_ai_tactical_priority_data.asm').read_text()
const_text=(ROOT/'constants/unit_constants.inc').read_text()
consts={m.group(1):int(m.group(2),0) for m in re.finditer(r'^DEF\s+(UNIT_TYPE_[A-Z0-9_]+)\s+EQU\s+([0-9]+)\s*$', const_text, re.M)}
start,end=0x4A43,0x4B91
# First pass: derive label addresses from emitted item widths.
pc=start; labels={}; items=[]
for raw in src.splitlines():
    line=raw.split(';',1)[0].strip()
    if not line or line.startswith('include ') or line.startswith('section ') or line.startswith('assert '): continue
    if line.endswith('::'):
        labels[line[:-2]]=pc; continue
    if line.lower().startswith('dw '):
        args=[x.strip() for x in line[3:].split(',')]; items.append((pc,'dw',args)); pc+=2*len(args); continue
    if line.lower().startswith('db '):
        args=[x.strip() for x in line[3:].split(',')]; items.append((pc,'db',args)); pc+=len(args); continue
    raise SystemExit(f'unparsed source line: {raw}')
if pc!=end: raise SystemExit(f'source geometry ends ${pc:04X}, expected ${end:04X}')
# Second pass: resolve emitted source bytes.
out=bytearray()
for addr,kind,args in items:
    for arg in args:
        if kind=='dw':
            if arg not in labels: raise SystemExit(f'unknown dw label {arg}')
            v=labels[arg]; out += bytes([v&0xff,v>>8])
        else:
            if arg in consts: v=consts[arg]
            elif re.fullmatch(r'\$[0-9A-Fa-f]+',arg): v=int(arg[1:],16)
            elif arg.isdigit(): v=int(arg)
            else: raise SystemExit(f'unknown db token {arg}')
            out.append(v&0xff)
retail=bank[start-0x4000:end-0x4000]
if bytes(out)!=retail:
    for i,(a,b) in enumerate(zip(out,retail)):
        if a!=b: raise SystemExit(f'byte mismatch at ${start+i:04X}: source {a:02X} retail {b:02X}')
    raise SystemExit(f'length mismatch source {len(out)} retail {len(retail)}')
sha=hashlib.sha1(retail).hexdigest(); expected='f051cda3c8248425e23ce7fc3fb6712e616d1764'
if sha!=expected: raise SystemExit(f'retail hash mismatch {sha}')
for table_addr,marker in [(0x4A43,'MapAI_UnitTypeListProfileTableA'),(0x4AF9,'MapAI_UnitTypeListProfileTableB')]:
    if labels.get(marker)!=table_addr: raise SystemExit(f'{marker} address mismatch')
if len(re.findall(r'^\s*dw\s+MapAI_UnitTypeList',src,re.M)) != 104:
    raise SystemExit('expected 104 symbolic dw entries')
if 'UNIT_TYPE_DUMMY' in '\n'.join(l for l in src.splitlines() if re.match(r'\s*dw\s',l)):
    raise SystemExit('DUMMY must not index the 52-entry tables')
print(f'[ok] the current source tactical priority data: {len(out)} retail bytes exact, SHA-1 {sha}; two 52-entry symbolic unit-type tables')
