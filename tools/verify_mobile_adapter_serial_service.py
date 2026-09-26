#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_serial_service.asm').read_text()
start,end=0x56cc,0x58e4
off=0x30*0x4000+(start-0x4000); retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='15b8d1e1b119b30b48ebb47cd7822ce18b7f704f'
if sha!=expected: raise SystemExit(f'Bank $30 serial-service hash mismatch: {sha}')
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
required={'MobileAdapter_DriverSerialInterrupt':0x56cc,'MobileAdapter_SerialReceiveStateMachine':0x57ee,'MobileAdapter_SerialServiceReturn':0x58c2,'MobileAdapter_SerialStoreByteAndAdvance':0x58c8}
for k,v in required.items():
    if seen.get(k)!=v: raise SystemExit(f'boundary mismatch {k}: {seen.get(k)} != ${v:04X}')
# The service reads rSB ($FF01) repeatedly and uses the local receive-buffer writer at $566B.
if retail.count(bytes.fromhex('f001')) < 4: raise SystemExit('serial core does not contain expected rSB reads')
if retail.count(bytes.fromhex('cd6b56')) < 2: raise SystemExit('serial core missing expected calls to $566B receive-buffer helper')
# $D00B is the explicit receive-phase state used by the state-machine entry.
if bytes.fromhex('fa0bd0b7280a3d287d3dca8a58c39858') not in retail: raise SystemExit('serial receive-phase dispatcher signature missing')
# End boundary must be exactly the exported LCD/timer service entry.
if end != 0x58e4: raise SystemExit('unexpected serial-service end boundary')
print(f'[ok] the current source Mobile Adapter serial core: {end-start} retail bytes exact, SHA-1 {sha}; $56CC per-byte serial service, receive-phase state machine, buffer advance helper, and $58E4 boundary locked')
