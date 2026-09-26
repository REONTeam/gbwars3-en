#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_driver_requests_12_18.asm').read_text(); frontend=(ROOT/'engine/mobile/mobile_adapter_driver.asm').read_text(); consts=(ROOT/'constants/mobile_adapter_constants.inc').read_text()
start,end=0x45dc,0x4898
off=0x30*0x4000+(start-0x4000)
retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='b134a6cc287cd8b3109ed28637f06e10ff8f2009'
if sha!=expected: raise SystemExit(f'Bank $30 request $12-$18 hash mismatch: {sha}')
out=bytearray(); pc=start; seen={}
for raw in src.splitlines():
    line=raw.split(';',1)[0].strip()
    if line.endswith('::'): seen[line]=pc
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
'MobileAdapter_RequestHandler12::':0x45dc,
'MobileAdapter_BuildModeSelectedControlPacket::':0x4614,
'MobileAdapter_PrepareConfigurationBuffer::':0x46c0,
'MobileAdapter_RequestHandler14_ReadConfigurationData::':0x46ee,
'MobileAdapter_RequestHandler16::':0x4756,
'MobileAdapter_RequestHandler18::':0x47fe,
}
for k,v in required.items():
    if seen.get(k)!=v: raise SystemExit(f'boundary mismatch {k}: {seen.get(k)} != ${v:04X}')
for label in ('MobileAdapter_RequestHandler12','MobileAdapter_RequestHandler14_ReadConfigurationData','MobileAdapter_RequestHandler16','MobileAdapter_RequestHandler18'):
    if f'dw {label}' not in frontend: raise SystemExit(f'frontend table does not reference {label}')
# Request $14 reaches the shared mode builder with A=0; mode 0 emits command $19.
r14=retail[0x46ee-start:0x4756-start]
if bytes.fromhex('3e00c31446') not in r14: raise SystemExit('request $14 no longer selects mode 0 control-packet builder')
shared=retail[0x4614-start:0x46c0-start]
if bytes.fromhex('3e19213ed0') not in shared: raise SystemExit('mode 0 no longer selects protocol command $19')
# Requests $16/$18 both emit response-form Transfer Data command $95.
for a,b in ((0x4756,0x47fe),(0x47fe,0x4898)):
    seg=retail[a-start:b-start]
    if bytes.fromhex('3e95ea1ed0') not in seg: raise SystemExit(f'request at ${a:04X} no longer emits $95 transfer-data response form')
if 'DEF MOBILE_COMMAND_READ_CONFIGURATION_DATA' not in consts or 'EQU $19' not in consts: raise SystemExit('missing Read Configuration Data protocol constant')
print(f'[ok] the current source Mobile Adapter request $12-$18 tranche: {end-start} retail bytes exact, SHA-1 {sha}; request $14 config-read and request $16/$18 transfer-data response forms locked')
