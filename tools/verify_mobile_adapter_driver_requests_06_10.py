#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_driver_requests_06_10.asm').read_text(); frontend=(ROOT/'engine/mobile/mobile_adapter_driver.asm').read_text(); consts=(ROOT/'constants/mobile_adapter_constants.inc').read_text()
start,end=0x43ab,0x45dc
off=0x30*0x4000+(start-0x4000)
retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='b36d1d1015f5d0ab0727747cba9eec8c904f453e'
if sha!=expected: raise SystemExit(f'Bank $30 request $06-$10 hash mismatch: {sha}')
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
'MobileAdapter_RequestHandler06_ISPLogin::':0x43ab,
'MobileAdapter_MarkRequestActive::':0x4431,
'MobileAdapter_RequestHandler08_DialTelephone::':0x4437,
'MobileAdapter_BuildDialTelephonePacket::':0x4484,
'MobileAdapter_StartIdlePacketTransfer::':0x44af,
'MobileAdapter_RequestHandler0A_Disconnect::':0x44c5,
'MobileAdapter_RequestHandler0C::':0x4577,
'MobileAdapter_RequestHandler0E::':0x4581,
'MobileAdapter_RequestHandler10::':0x458b,
'MobileAdapter_BeginStateRequest::':0x4595,
}
for k,v in required.items():
    if seen.get(k)!=v: raise SystemExit(f'boundary mismatch {k}: {seen.get(k)} != ${v:04X}')
for label in ('MobileAdapter_RequestHandler06_ISPLogin','MobileAdapter_RequestHandler08_DialTelephone','MobileAdapter_RequestHandler0A_Disconnect','MobileAdapter_RequestHandler0C','MobileAdapter_RequestHandler0E','MobileAdapter_RequestHandler10'):
    if f'dw {label}' not in frontend: raise SystemExit(f'frontend table does not reference {label}')
# Lock SDK/protocol evidence visible in the retail byte stream.
# Request $06 calls the dial-packet builder and then starts the common transfer path.
if bytes.fromhex('cd8444') not in retail[:0x86]: raise SystemExit('request $06 no longer calls Dial Telephone packet builder')
if bytes.fromhex('cdaf44') not in retail[:0x86]: raise SystemExit('request $06 no longer starts idle transfer path')
# Request $0A emits command byte $A2 = ISP Logout ($22 | $80) in one teardown path.
idx=0x44c5-start
if bytes.fromhex('3ea2ea1ed0') not in retail[idx:idx+0x80]: raise SystemExit('request $0A ISP Logout command path changed')
# The alternate teardown path emits $95 = Transfer Data ($15 | $80).
if bytes.fromhex('3e95ea1ed0') not in retail[idx:0x4577-start]: raise SystemExit('request $0A Transfer Data command path changed')
for name,val in [('MOBILE_COMMAND_DIAL_TELEPHONE','$12'),('MOBILE_COMMAND_TRANSFER_DATA','$15'),('MOBILE_COMMAND_ISP_LOGIN','$21'),('MOBILE_COMMAND_ISP_LOGOUT','$22')]:
    if f'DEF {name}' not in consts or val not in consts: raise SystemExit(f'missing protocol constant {name}')
print(f'[ok] the current source Mobile Adapter request $06-$10 cluster: {end-start} retail bytes exact, SHA-1 {sha}; ISP login/dial/disconnect and shared state-request boundaries locked')
