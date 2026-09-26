#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_driver_requests_32_42.asm').read_text(); frontend=(ROOT/'engine/mobile/mobile_adapter_driver.asm').read_text()
start,end=0x548f,0x56cc
off=0x30*0x4000+(start-0x4000); retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='064abe5a93944ec1a41f3642f73ddb429b964069'
if sha!=expected: raise SystemExit(f'Bank $30 request-tail hash mismatch: {sha}')
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
'MobileAdapter_RequestHandler3A':0x548f,
'MobileAdapter_InternalHandler42':0x5543,
'MobileAdapter_RequestHandler32_TelephoneStatus':0x5544,
'MobileAdapter_RequestHandler34':0x5599,
'MobileAdapter_RequestHandler3C':0x5617,
'MobileAdapter_RequestHandler36':0x5634,
'MobileAdapter_ResetStatusWords':0x5656,
'MobileAdapter_ResetDriverFlags':0x568d,
}
for k,v in required.items():
    if seen.get(k)!=v: raise SystemExit(f'boundary mismatch {k}: {seen.get(k)} != ${v:04X}')
for k in ('MobileAdapter_RequestHandler3A','MobileAdapter_InternalHandler42','MobileAdapter_RequestHandler32_TelephoneStatus','MobileAdapter_RequestHandler34','MobileAdapter_RequestHandler3C','MobileAdapter_RequestHandler36'):
    if f'dw {k}' not in frontend: raise SystemExit(f'frontend table does not reference {k}')
# Internal $42 is exactly a NOP before request $32.
if retail[0x5543-start] != 0x00: raise SystemExit('internal request $42 is not the expected NOP alias')
# Request $32 emits response-form Telephone Status ($17|$80=$97).
r32=retail[0x5544-start:0x5599-start]
if bytes.fromhex('3e97212d60cd025f') not in r32: raise SystemExit('request $32 missing $97 Telephone Status response packet setup')
# Request $36 clears exactly $0452 bytes starting at $D000 after local reset setup.
r36=retail[0x5634-start:0x5656-start]
if bytes.fromhex('0152042100d0af220b79b020f9') not in r36: raise SystemExit('request $36 missing $0452-byte $D000 workspace clear loop')
print(f'[ok] the current source Mobile Adapter request-tail tranche: {end-start} retail bytes exact, SHA-1 {sha}; dispatcher tail, Telephone Status response, reset helpers, and $56CC boundary locked')
