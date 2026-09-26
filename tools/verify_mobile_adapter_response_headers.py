#!/usr/bin/env python3
from pathlib import Path
import csv, hashlib, re, sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_response_headers.asm').read_text()
start,end=0x6e56,0x743e
off=0x30*0x4000+(start-0x4000); retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='7571cd3b6f98379ae87728e770e2101c62cdd910'
if sha!=expected: raise SystemExit(f'Bank $30 response-header/runtime hash mismatch: {sha}')
out=bytearray(); pc=start; seen={}
def split_args(s): return next(csv.reader([s], skipinitialspace=True, quotechar='"'))
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
        elif re.fullmatch(r'[A-Za-z0-9 <>:/._=-]+',rawtok): out.extend(rawtok.encode('latin1'))
        else: raise SystemExit(f'unparsed db token: {rawtok!r}')
    pc=start+len(out)
if pc!=end: raise SystemExit(f'source end mismatch ${pc:04X}')
if bytes(out)!=retail:
    for i,(a,b) in enumerate(zip(out,retail)):
        if a!=b: raise SystemExit(f'source differs at ${start+i:04X}: source ${a:02X} retail ${b:02X}')
    raise SystemExit('source reconstruction differs from retail')
required={
'MobileAdapter_NetworkProtocolState_6E56':0x6e56,
'MobileAdapter_ParseNetworkResponseHeaders':0x6f71,
'MobileAdapter_TryParseDateHeader':0x7007,
'MobileAdapter_TryParseGbStatusHeader':0x703a,
'MobileAdapter_TryParseGbAuthIDHeader':0x7058,
'MobileAdapter_TryParseWWWAuthenticateHeader':0x7086,
'MobileAdapter_TryParseURIHeader':0x7199,
'MobileAdapter_TryParseLocationHeader':0x71b2,
'MobileAdapter_MatchHeaderPrefix':0x72a5,
'MobileAdapter_MatchHeaderPrefixCaseInsensitive':0x72b3,
'MobileAdapter_ASCIIToLowerIfUppercase':0x72cf,
'MobileAdapter_HTTPResponseHeaderStrings':0x72d8,
'MobileAdapter_NetworkProtocolState_7349':0x7349,
'MobileAdapter_HTTP_ContentLengthZeroHeader':0x73a4,
'MobileAdapter_NetworkProtocolState_73B8':0x73b8,
'MobileAdapter_ResetNetworkTransferState':0x7410,
'MobileAdapter_CopyStagedNetworkPayload':0x7430,
}
for k,v in required.items():
    if seen.get(k)!=v: raise SystemExit(f'boundary mismatch {k}: {seen.get(k)} != ${v:04X}')
for text in [b'date: \0',b'Gb-Status: \0',b'Gb-Auth-ID: \0',b'WWW-Authenticate: GB00 name="\0',b'Content-Type: application/x-cgb\r\n\0',b'URI-header: \0',b'Location: \0',b'Content-Length: 0\r\n\0']:
    if text not in retail: raise SystemExit(f'missing response-header string {text!r}')
# Prove the header parser calls the bounded numeric parser from the current source and both
# packet-staging states emit response-form Transfer Data ($95).
for anchor in [bytes.fromhex('cd216b'),bytes.fromhex('3e952153d3c3055f')]:
    if anchor not in retail: raise SystemExit(f'missing semantic anchor {anchor.hex()}')
if retail.count(bytes([0x3e,0x95])) < 2: raise SystemExit('expected two Transfer Data response-form staging paths')
print(f'[ok] the current source Mobile Adapter response-header/runtime: {end-start} retail bytes exact, SHA-1 {sha}; HTTP/mail header parsing and transfer staging locked')
