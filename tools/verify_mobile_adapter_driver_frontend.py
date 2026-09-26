#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_driver.asm').read_text(); api=(ROOT/'engine/home/home_mobile_api.asm').read_text(); syms=(ROOT/'symbols.asm').read_text()
start,end=0x4000,0x4115
off=0x30*0x4000+(start-0x4000)
retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='a98c76ccd5836e5e92e80dfd6f5bb1d68704dec5'
if sha!=expected: raise SystemExit(f'Bank $30 frontend hash mismatch: {sha}')

# Reconstruct the source-owned byte stream from db/dw directives. This is a
# small two-pass parser for this module only; it resolves the one symbolic dw
# entry that points back to RequestHandler30.
labels={'MobileAdapter_RequestHandler00':0x4115,'MobileAdapter_RequestHandler02':0x4235,'MobileAdapter_RequestHandler04':0x4290,'MobileAdapter_RequestHandler38':0x432b,'MobileAdapter_InternalHandler40':0x4234,'MobileAdapter_RequestHandler06_ISPLogin':0x43ab,'MobileAdapter_RequestHandler08_DialTelephone':0x4437,'MobileAdapter_RequestHandler0A_Disconnect':0x44c5,'MobileAdapter_RequestHandler0C':0x4577,'MobileAdapter_RequestHandler0E':0x4581,'MobileAdapter_RequestHandler10':0x458b,'MobileAdapter_RequestHandler12':0x45dc,'MobileAdapter_RequestHandler14_ReadConfigurationData':0x46ee,'MobileAdapter_RequestHandler16':0x4756,'MobileAdapter_RequestHandler18':0x47fe,'MobileAdapter_RequestHandler1A':0x4898,'MobileAdapter_RequestHandler1C':0x48a2,'MobileAdapter_RequestHandler1E':0x4904,'MobileAdapter_RequestHandler20':0x49a3,'MobileAdapter_RequestHandler22':0x49f8,'MobileAdapter_RequestHandler24':0x4a5a,'MobileAdapter_RequestHandler26':0x4c3b,'MobileAdapter_RequestHandler28':0x4c9d,'MobileAdapter_RequestHandler2A':0x4ddc,'MobileAdapter_RequestHandler2C':0x51fd,'MobileAdapter_RequestHandler2E':0x5405,'MobileAdapter_RequestHandler3A':0x548f,'MobileAdapter_InternalHandler42':0x5543,'MobileAdapter_RequestHandler32_TelephoneStatus':0x5544,'MobileAdapter_RequestHandler34':0x5599,'MobileAdapter_RequestHandler3C':0x5617,'MobileAdapter_RequestHandler36':0x5634}
pc=start
for raw in src.splitlines():
    line=raw.split(';',1)[0].strip()
    if not line: continue
    if line.endswith('::'):
        labels[line[:-2]]=pc; continue
    if line.startswith('db '):
        pc += len([x for x in line[3:].split(',') if x.strip()])
    elif line.startswith('dw '):
        pc += 2*len([x for x in line[3:].split(',') if x.strip()])
if pc != end: raise SystemExit(f'source length mismatch: ${pc:04X} != ${end:04X}')
out=bytearray()
for raw in src.splitlines():
    line=raw.split(';',1)[0].strip()
    if line.startswith('db '):
        for tok in line[3:].split(','):
            tok=tok.strip()
            if re.fullmatch(r'\$[0-9A-Fa-f]+',tok): out.append(int(tok[1:],16)&0xff)
            else: raise SystemExit(f'unparsed db token: {tok}')
    elif line.startswith('dw '):
        for tok in line[3:].split(','):
            tok=tok.strip()
            if re.fullmatch(r'\$[0-9A-Fa-f]+',tok): value=int(tok[1:],16)
            elif tok in labels: value=labels[tok]
            else: raise SystemExit(f'unparsed dw token: {tok}')
            out += bytes((value&0xff,(value>>8)&0xff))
if bytes(out) != retail: raise SystemExit(f'source reconstruction differs from retail ({len(out)} bytes)')
# Lock public dispatcher and indexed table bytes directly from retail.
if retail[0x30:0x34] != bytes.fromhex('d5fa88d1'):
    raise SystemExit('dispatcher entry bytes mismatch')
table=retail[0x70:0xb4]
words=[table[i]|(table[i+1]<<8) for i in range(0,len(table),2)]
expected_words=[0x4115,0x4235,0x4290,0x43ab,0x4437,0x44c5,0x4577,0x4581,0x458b,0x45dc,0x46ee,0x4756,0x47fe,0x4898,0x48a2,0x4904,0x49a3,0x49f8,0x4a5a,0x4c3b,0x4c9d,0x4ddc,0x51fd,0x5405,0x40dc,0x5544,0x5599,0x5634,0x432b,0x548f,0x5617,0x43ab,0x4234,0x5543]
if words != expected_words: raise SystemExit('request handler table mismatch')
for marker in ('MobileAdapter_DriverDispatch::','MobileAdapter_DriverRequestHandlers::','MobileAdapter_PrepareRequestChannel::','MobileAdapter_RequestHandler30::'):
    if marker not in src: raise SystemExit(f'missing {marker}')
if 'sym $30, $4030, MobileAdapter_DriverDispatch' in syms:
    raise SystemExit('obsolete dispatcher symbol-only anchor remains')
if 'include "constants/mobile_adapter_constants.inc"' not in api:
    raise SystemExit('ROM0 Mobile Adapter API does not share request constants')
if api.count('MOBILE_ADAPTER_REQUEST_') < 28:
    raise SystemExit('ROM0 command type table was not converted to symbolic request IDs')
print(f'[ok] the current source Mobile Adapter Bank $30 frontend: {end-start} retail bytes exact, SHA-1 {sha}; 34-entry even-request handler table locked')
