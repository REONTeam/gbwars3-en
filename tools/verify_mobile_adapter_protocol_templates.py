#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys, csv
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_protocol_templates.asm').read_text()
start,end=0x6000,0x6430
off=0x30*0x4000+(start-0x4000); retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='a39ba4ae68250d2849a4c95f1a6e39de031e8a24'
if sha!=expected: raise SystemExit(f'Bank $30 protocol-template/core hash mismatch: {sha}')
const={}
for line in (ROOT/'constants/mobile_adapter_constants.inc').read_text().splitlines():
 m=re.match(r'DEF\s+(\w+)\s+EQU\s+\$([0-9a-fA-F]+)',line.strip())
 if m: const[m.group(1)]=int(m.group(2),16)
out=bytearray(); pc=start; seen={}
def split_args(s):
    return next(csv.reader([s], skipinitialspace=True, quotechar='"'))
for raw in src.splitlines():
    line=raw.split(';',1)[0].strip()
    if not line: continue
    if '::' in line:
        before,after=line.split('::',1); seen[before.strip()]=pc; line=after.strip()
    if not line.startswith('db '): continue
    for rawtok in split_args(line[3:]):
        tok=rawtok.strip()
        if tok.startswith('$'): out.append(int(tok[1:],16)&0xff)
        elif tok.isdigit(): out.append(int(tok)&0xff)
        elif tok in const: out.append(const[tok]&0xff)
        else:
            # csv removes quotes but preserves spaces inside quoted strings.
            if re.fullmatch(r'[A-Za-z0-9 <>:/._-]+',rawtok): out.extend(rawtok.encode('latin1'))
            else: raise SystemExit(f'unparsed db token: {rawtok!r}')
    pc=start+len(out)
if pc!=end: raise SystemExit(f'source end mismatch ${pc:04X}')
if bytes(out)!=retail:
 for i,(a,b) in enumerate(zip(out,retail)):
  if a!=b: raise SystemExit(f'source differs at ${start+i:04X}: source ${a:02X} retail ${b:02X}')
 raise SystemExit('source reconstruction differs from retail')
required={'MobileAdapter_ProtocolIdleByte':0x6000,'MobileAdapter_BeginSessionPacketTemplate':0x6001,'MobileAdapter_BeginSessionSignatureBlock':0x6006,'MobileAdapter_TransferDataPacketTemplate':0x6072,'MobileAdapter_SMTP_HELO':0x609e,'MobileAdapter_POP3_USER':0x60c8,'MobileAdapter_HTTP_GET':0x6110,'MobileAdapter_HTTP_POST':0x6137,'MobileAdapter_ServiceProtocolState':0x614e,'MobileAdapter_SetCommandState05':0x625d,'MobileAdapter_ProtocolCore_6269':0x6269,'MobileAdapter_ProtocolCore_636B':0x636b}
for k,v in required.items():
 if seen.get(k)!=v: raise SystemExit(f'boundary mismatch {k}: {seen.get(k)} != ${v:04X}')
for text in (b'HELO \x00',b'MAIL FROM:<\x00',b'USER \x00',b'RETR 00000\r\n\x00',b'GET \x00',b'User-Agent: CGB-\x00',b'Content-Length: \x00'):
 if text not in retail: raise SystemExit(f'missing protocol string {text!r}')
print(f'[ok] the current source Mobile Adapter protocol templates/core: {end-start} retail bytes exact, SHA-1 {sha}; packet templates, SMTP/POP3/HTTP strings, and $614E-$642F state core locked')
