#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_driver_requests_00_04.asm').read_text(); frontend=(ROOT/'engine/mobile/mobile_adapter_driver.asm').read_text()
start,end=0x4115,0x43ab
off=0x30*0x4000+(start-0x4000)
retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='8f4a21b609c4458310a1095d631d67182afbb9df'
if sha!=expected: raise SystemExit(f'Bank $30 request cluster hash mismatch: {sha}')
out=bytearray()
for raw in src.splitlines():
    line=raw.split(';',1)[0].strip()
    if line.startswith('db '):
        for tok in line[3:].split(','):
            tok=tok.strip()
            if not re.fullmatch(r'\$[0-9A-Fa-f]+',tok): raise SystemExit(f'unparsed db token: {tok}')
            out.append(int(tok[1:],16)&0xff)
if bytes(out)!=retail: raise SystemExit(f'source reconstruction differs from retail ({len(out)} vs {len(retail)} bytes)')
required={
'MobileAdapter_RequestHandler00::':0x4115,
'MobileAdapter_SetEvent21::':0x4225,
'MobileAdapter_SetEvent20::':0x4230,
'MobileAdapter_InternalHandler40::':0x4234,
'MobileAdapter_RequestHandler02::':0x4235,
'MobileAdapter_RequestHandler04::':0x4290,
'MobileAdapter_RequestHandler38::':0x432b,
'MobileAdapter_EnableTimerSerialInterrupts::':0x4392,
'MobileAdapter_ValidateZeroTerminatedLength::':0x4399,
}
pc=start
seen={}
for raw in src.splitlines():
    line=raw.split(';',1)[0].strip()
    if line.endswith('::'): seen[line]=pc
    elif line.startswith('db '): pc += len([x for x in line[3:].split(',') if x.strip()])
if pc!=end: raise SystemExit(f'source end mismatch ${pc:04X}')
for k,v in required.items():
    if seen.get(k)!=v: raise SystemExit(f'boundary mismatch {k}: {seen.get(k)} != ${v:04X}')
for label in ('MobileAdapter_RequestHandler00','MobileAdapter_RequestHandler02','MobileAdapter_RequestHandler04','MobileAdapter_RequestHandler38','MobileAdapter_InternalHandler40'):
    if f'dw {label}' not in frontend: raise SystemExit(f'frontend table does not reference {label}')
# Lock key mechanically proven effects.
if retail[0x4235-start+0x12:0x4235-start+0x18] != bytes.fromhex('0152042100d0'):
    raise SystemExit('request $02 workspace-clear geometry changed')
if retail[0x4392-start:0x4399-start] != bytes.fromhex('0efff2f60ce2c9'):
    raise SystemExit('timer/serial IE helper changed')
print(f'[ok] the current source Mobile Adapter request cluster: {end-start} retail bytes exact, SHA-1 {sha}; request $00/$02/$04/$38 and internal $40 boundaries locked')
