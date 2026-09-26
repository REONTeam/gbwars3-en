#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_network_client.asm').read_text()
start,end=0x6430,0x6b21
off=0x30*0x4000+(start-0x4000); retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='54421670e9e7be6ff1690c261824e6103cef19fe'
if sha!=expected: raise SystemExit(f'Bank $30 network-client hash mismatch: {sha}')
out=bytearray(); pc=start; seen={}
for raw in src.splitlines():
    line=raw.split(';',1)[0].strip()
    if not line: continue
    if '::' in line:
        before,after=line.split('::',1); seen[before.strip()]=pc; line=after.strip()
    if not line.startswith('db '): continue
    for tok in line[3:].split(','):
        tok=tok.strip()
        if not re.fullmatch(r'\$[0-9a-fA-F]{2}',tok): raise SystemExit(f'unparsed db token: {tok!r}')
        out.append(int(tok[1:],16))
    pc=start+len(out)
if pc!=end: raise SystemExit(f'source end mismatch ${pc:04X}')
if bytes(out)!=retail:
    for i,(a,b) in enumerate(zip(out,retail)):
        if a!=b: raise SystemExit(f'source differs at ${start+i:04X}: source ${a:02X} retail ${b:02X}')
    raise SystemExit('source reconstruction differs from retail')
required={
'MobileAdapter_StartCloseTCPTransaction':0x6430,
'MobileAdapter_BuildTransferDataPacketFromWorkspace':0x6534,
'MobileAdapter_AppendHTTPRequestMethod':0x669b,
'MobileAdapter_AppendHTTPVersion':0x66b0,
'MobileAdapter_AppendHTTPUserAgent':0x66b6,
'MobileAdapter_AppendHTTPContentLength':0x66f6,
'MobileAdapter_ResetProtocolSubstate':0x6734,
'MobileAdapter_ShiftResponseWindowAndCheckCRLF':0x67f1,
'MobileAdapter_UpdateFiveByteResponseWindow':0x6817,
'MobileAdapter_AppendCRLF':0x696e,
'MobileAdapter_ParseDecimal24':0x6abc,
}
for k,v in required.items():
    if seen.get(k)!=v: raise SystemExit(f'boundary mismatch {k}: {seen.get(k)} != ${v:04X}')
# Behavior anchors used for the semantic labels above.
anchors=[bytes.fromhex('3e03ea07d01147d32183600606cd0040'), # $6430 copies close-TCP template
         bytes.fromhex('3ea42147d3c3055f'),                 # expects $A4 close-TCP response
         bytes.fromhex('211061'),                         # HTTP GET fragment pointer
         bytes.fromhex('213761'),                         # HTTP Content-Length fragment pointer
         bytes.fromhex('fe0dc0'),                         # CR test in response parser
         bytes.fromhex('e60f47')]                         # decimal digit extraction
for a in anchors:
    if a not in retail: raise SystemExit(f'missing semantic anchor {a.hex()}')
print(f'[ok] the current source Mobile Adapter network client: {end-start} retail bytes exact, SHA-1 {sha}')
