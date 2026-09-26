#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_driver_requests_28_2e.asm').read_text(); frontend=(ROOT/'engine/mobile/mobile_adapter_driver.asm').read_text()
start,end=0x4c9d,0x548f
off=0x30*0x4000+(start-0x4000)
retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='8c5fa164c9e008cd527b9bd1fa11f8a48030f1af'
if sha!=expected: raise SystemExit(f'Bank $30 request $28-$2E hash mismatch: {sha}')
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
required={'MobileAdapter_RequestHandler28':0x4c9d,'MobileAdapter_RequestHandler2A':0x4ddc,'MobileAdapter_RequestHandler2C':0x51fd,'MobileAdapter_RequestHandler2E':0x5405}
for k,v in required.items():
    if seen.get(k)!=v: raise SystemExit(f'boundary mismatch {k}: {seen.get(k)} != ${v:04X}')
    if f'dw {k}' not in frontend: raise SystemExit(f'frontend table does not reference {k}')
# Request $28 mirrors the large transfer continuation family and emits $95, selecting state $1C.
r28=retail[:0x4ddc-start]
for pat,desc in [(bytes.fromhex('3e95ea1ed0'),'$95 Transfer Data response-form'),(bytes.fromhex('3e1cea6ad0'),'internal state $1C')]:
    if pat not in r28: raise SystemExit(f'request $28 missing {desc}')
# Request $2A contains the four retail datacenter service endpoints and both TCP-open and transfer response forms.
r2a=retail[0x4ddc-start:0x51fd-start]
for text in (b'http://gameboy.datacenter.ne.jp/cgb/download',b'gameboy.datacenter.ne.jp/cgb/upload',b'gameboy.datacenter.ne.jp/cgb/utility',b'gameboy.datacenter.ne.jp/cgb/ranking'):
    if text not in r2a: raise SystemExit(f'request $2A missing endpoint {text!r}')
for pat,desc in [(bytes.fromhex('3ea3ea1ed0'),'$A3 Open TCP Connection response-form'),(bytes.fromhex('3e95ea1ed0'),'$95 Transfer Data response-form')]:
    if pat not in r2a: raise SystemExit(f'request $2A missing {desc}')
print(f'[ok] the current source Mobile Adapter request $28-$2E tranche: {end-start} retail bytes exact, SHA-1 {sha}; fixed dispatcher boundaries, transfer path, TCP-open response, and retail web endpoints locked')
