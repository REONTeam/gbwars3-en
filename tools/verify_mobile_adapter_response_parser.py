#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_response_parser.asm').read_text()
start,end=0x6b21,0x6e56
off=0x30*0x4000+(start-0x4000); retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='b9f3f527c2b36e4b27860ed1a88b9fb08bc061bb'
if sha!=expected: raise SystemExit(f'Bank $30 response-parser hash mismatch: {sha}')
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
'MobileAdapter_ParseNumericResponseField':0x6b21,
'MobileAdapter_ReadDecimalDigit':0x6b70,
'MobileAdapter_NetworkTransferBufferState_6C05':0x6c05,
'MobileAdapter_ReturnNetworkResultCode4':0x6d30,
'MobileAdapter_NetworkProtocolStateDispatcher':0x6d43,
'MobileAdapter_NetworkProtocolStateGate':0x6d5d,
'MobileAdapter_StartTransferDataTemplateTransaction':0x6d97,
'MobileAdapter_StageNetworkCommand24':0x6e48,
}
for k,v in required.items():
    if seen.get(k)!=v: raise SystemExit(f'boundary mismatch {k}: {seen.get(k)} != ${v:04X}')
anchors=[
bytes.fromhex('2afe30380afe3a3006e60f121305c937c9'), # ASCII decimal digit helper
bytes.fromhex('cd216b'),                         # parser is consumed by network response states
bytes.fromhex('2143' ),                           # lightweight dispatcher-area sanity anchor
bytes.fromhex('1172' ),                           # transfer template address low-byte vicinity
]
# Use stronger exact snippets for the semantic claims.
strong=[bytes.fromhex('0100031172d0cd706bd4706bd4706b'),
        bytes.fromhex('3d28513d28663dca566e'),
        bytes.fromhex('cd3e741147d32172600606cd0040'),
        bytes.fromhex('2121d0cbcecb86118bd13e24184f')]
for a in strong:
    if a not in retail: raise SystemExit(f'missing semantic anchor {a.hex()}')
print(f'[ok] the current source Mobile Adapter response parser/state support: {end-start} retail bytes exact, SHA-1 {sha}')
