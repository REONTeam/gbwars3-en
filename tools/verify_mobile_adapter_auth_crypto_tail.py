#!/usr/bin/env python3
from pathlib import Path
import csv, hashlib, re, sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_auth_crypto_tail.asm').read_text()
start,end=0x743e,0x8000
bank=0x30; off=bank*0x4000+(start-0x4000); retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='2faac0cb03c3a903b39d78e92137a212912a7e6d'
if sha!=expected: raise SystemExit(f'Bank $30 auth/tail hash mismatch: {sha}')
out=bytearray(); pc=start; seen={}
def split_args(s): return next(csv.reader([s],skipinitialspace=True,quotechar='"'))
for raw in src.splitlines():
    line=raw.split(';',1)[0].strip()
    if not line: continue
    if '::' in line:
        before,after=line.split('::',1); seen[before.strip()]=pc; line=after.strip()
    if line.startswith('db '):
        for rawtok in split_args(line[3:]):
            tok=rawtok.strip()
            if tok.startswith('$'): out.append(int(tok[1:],16)&0xff)
            elif tok.isdigit(): out.append(int(tok)&0xff)
            elif re.fullmatch(r'[A-Za-z0-9 <>:/._=\-]+',rawtok): out.extend(rawtok.encode('latin1'))
            else: raise SystemExit(f'unparsed db token: {rawtok!r}')
    elif line.startswith('dw '):
        for tok in [x.strip() for x in line[3:].split(',')]:
            if not tok.startswith('$'): raise SystemExit(f'unparsed dw token {tok}')
            v=int(tok[1:],16); out += bytes((v&0xff,(v>>8)&0xff))
    elif line.startswith('ds '):
        a=[x.strip() for x in line[3:].split(',')]; n=int(a[0][1:],16) if a[0].startswith('$') else int(a[0]); v=int(a[1][1:],16) if a[1].startswith('$') else int(a[1]); out.extend([v&0xff]*n)
    pc=start+len(out)
if len(out)!=end-start: raise SystemExit(f'source size mismatch {len(out)} != {end-start}')
if bytes(out)!=retail:
    for i,(a,b) in enumerate(zip(out,retail)):
        if a!=b: raise SystemExit(f'source differs at ${start+i:04X}: source ${a:02X} retail ${b:02X}')
    raise SystemExit('source reconstruction differs')
required={
'MobileAdapter_StageTransferDataWindow':0x743e,
'MobileAdapter_NetworkProtocolState_1E_2C':0x7487,
'MobileAdapter_NetworkProtocolState_25_27':0x74d5,
'MobileAdapter_FormatPackedTelephoneDigits':0x75a7,
'MobileAdapter_NetworkProtocolState_2E':0x75e2,
'MobileAdapter_NetworkProtocolState_2D':0x762e,
'MobileAdapter_MD5PreparePaddedBlock':0x7677,
'MobileAdapter_MD5InitializeWorkingState':0x76f0,
'MobileAdapter_MD5TransformBlock':0x770d,
'MobileAdapter_MD5RoundOperation':0x78c5,
'MobileAdapter_MD5And32':0x79c7,
'MobileAdapter_MD5Or32':0x79d1,
'MobileAdapter_MD5Not32':0x79db,
'MobileAdapter_MD5Xor32':0x79e4,
'MobileAdapter_MD5Add32':0x79ee,
'MobileAdapter_MD5RotateLeft32':0x79fc,
'MobileAdapter_HTTPAuthorizationGB00Prefix':0x7a11,
'MobileAdapter_MD5RoundSchedule':0x7a2c,
'MobileAdapter_MD5InitialState':0x7b3a,
'MobileAdapter_MD5KConstants':0x7b4a,
'MobileAdapter_Base64Encode':0x7c4a,
'MobileAdapter_Base64ValueToChar':0x7d03,
'MobileAdapter_Base64Decode':0x7d22,
'MobileAdapter_Base64CharToValue':0x7db6,
'MobileAdapter_NetworkProtocolState_28':0x7dfe,
'MobileAdapter_NetworkProtocolState_29':0x7eae,
'MobileAdapter_NetworkProtocolState_2A':0x7ee9,
'MobileAdapter_Bank30Padding':0x7f40,
}
for k,v in required.items():
    if seen.get(k)!=v: raise SystemExit(f'boundary mismatch {k}: {seen.get(k)} != ${v:04X}')
# MD5 standard-state and constants are an independent semantic fingerprint.
if retail[0x7b3a-start:0x7b4a-start] != bytes.fromhex('0123456789abcdeffedcba9876543210'):
    raise SystemExit('MD5 IV mismatch')
md5_k_first=bytes.fromhex('78a46ad756b7c7e8db702024eecebdc1')
if retail[0x7b4a-start:0x7b5a-start] != md5_k_first: raise SystemExit('MD5 K-table prefix mismatch')
if retail[0x7b4a-start:0x7c4a-start][-4:] != bytes.fromhex('91d386eb'): raise SystemExit('MD5 K-table tail mismatch')
if b'Authorization: GB00 name="\0' not in retail: raise SystemExit('GB00 Authorization prefix missing')
# Base64 encoder alphabet branches: '/', +A, +a, digits via -4, '+'.
for anchor in [bytes.fromhex('3e2fc9'),bytes.fromhex('c641c9'),bytes.fromhex('c647c9'),bytes.fromhex('d604c9'),bytes.fromhex('3e2bc9')]:
    if anchor not in retail[0x7d03-start:0x7d22-start]: raise SystemExit(f'Base64 alphabet anchor missing {anchor.hex()}')
if retail[0x7f40-start:] != bytes([0xff])*0xc0: raise SystemExit('Bank tail is not expected $FF padding')
whole=rom[bank*0x4000:(bank+1)*0x4000]
whole_sha=hashlib.sha1(whole).hexdigest()
if whole_sha!='21dd297ef78a093dab18ce9f4da65ff42fc562c9': raise SystemExit(f'whole Bank $30 hash mismatch {whole_sha}')
print(f'[ok] the current source Mobile Adapter auth/crypto + Bank $30 tail: {end-start} bytes exact, SHA-1 {sha}; MD5/Base64/GB00 auth fingerprints and $FF bank padding locked')
