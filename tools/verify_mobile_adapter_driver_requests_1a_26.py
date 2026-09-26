#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_driver_requests_1a_26.asm').read_text(); frontend=(ROOT/'engine/mobile/mobile_adapter_driver.asm').read_text()
start,end=0x4898,0x4c9d
off=0x30*0x4000+(start-0x4000)
retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='d7f237361c090ba3bdfadc20d3ca7fe298c878a8'
if sha!=expected: raise SystemExit(f'Bank $30 request $1A-$26 hash mismatch: {sha}')
out=bytearray(); pc=start; seen={}
for raw in src.splitlines():
    line=raw.split(';',1)[0].strip()
    if line.endswith('::'): seen[line[:-2]]=pc
    elif line.startswith('db '):
        vals=[]
        for tok in line[3:].split(','):
            tok=tok.strip()
            if not re.fullmatch(r'\$[0-9A-Fa-f]+',tok): raise SystemExit(f'unparsed db token: {tok}')
            vals.append(int(tok[1:],16)&0xff)
        out.extend(vals); pc += len(vals)
if pc!=end: raise SystemExit(f'source end mismatch ${pc:04X}')
if bytes(out)!=retail: raise SystemExit(f'source reconstruction differs from retail ({len(out)} vs {len(retail)} bytes)')
required={
'MobileAdapter_RequestHandler1A':0x4898,
'MobileAdapter_RequestHandler1C':0x48a2,
'MobileAdapter_RequestHandler1E':0x4904,
'MobileAdapter_RequestHandler20':0x49a3,
'MobileAdapter_RequestHandler22':0x49f8,
'MobileAdapter_RequestHandler24':0x4a5a,
'MobileAdapter_RequestHandler26':0x4c3b,
}
for k,v in required.items():
    if seen.get(k)!=v: raise SystemExit(f'boundary mismatch {k}: {seen.get(k)} != ${v:04X}')
    if f'dw {k}' not in frontend: raise SystemExit(f'frontend table does not reference {k}')
# Request $1A is the short state-$03 wrapper that joins request $1C at $48AA.
if retail[:10] != bytes.fromhex('fa6ad0fe03c225421808'):
    raise SystemExit('request $1A wrapper bytes changed')
# $1C/$20/$22/$24/$26 each contain at least one $95 response-form Transfer Data packet command.
for a,b in ((0x48a2,0x4904),(0x49a3,0x49f8),(0x49f8,0x4a5a),(0x4a5a,0x4c3b),(0x4c3b,0x4c9d)):
    seg=retail[a-start:b-start]
    if bytes.fromhex('3e95ea1ed0') not in seg:
        raise SystemExit(f'request at ${a:04X} no longer emits $95 transfer-data response form')
# $1E still selects mode 1 of the current source shared mode packet builder.
r1e=retail[0x4904-start:0x49a3-start]
if not r1e.endswith(bytes.fromhex('3e01c31446')):
    raise SystemExit('request $1E no longer enters shared mode-1 packet builder')
# Internal states selected at successful ends.
for a,b,state in ((0x48a2,0x4904,0x17),(0x49a3,0x49f8,0x18),(0x49f8,0x4a5a,0x1d),(0x4c3b,0x4c9d,0x1b)):
    seg=retail[a-start:b-start]
    pat=bytes((0x3e,state,0xea,0x6a,0xd0))
    if pat not in seg: raise SystemExit(f'request at ${a:04X} missing state ${state:02X}')
print(f'[ok] the current source Mobile Adapter request $1A-$26 tranche: {end-start} retail bytes exact, SHA-1 {sha}; shared $95 transfer-response paths and fixed handler boundaries locked')
