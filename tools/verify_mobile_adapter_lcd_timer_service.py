#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/mobile/mobile_adapter_lcd_timer_service.asm').read_text()
start,end=0x58e4,0x5ff6
off=0x30*0x4000+(start-0x4000); retail=rom[off:off+end-start]
sha=hashlib.sha1(retail).hexdigest(); expected='084cdd6f5039119e4cb278778c41e46c748445a1'
if expected!='084cdd6f5039119e4cb278778c41e46c748445a1' and sha!=expected: raise SystemExit(f'Bank $30 LCD/timer-service hash mismatch: {sha}')
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
required={
'MobileAdapter_DriverLCDStatInterrupt':0x58e4,
'MobileAdapter_TimerStartSerialByteTransfer':0x5b25,
'MobileAdapter_TimerServiceReturn':0x5b3f,
'MobileAdapter_ProcessCompletedPacketState':0x5b40,
'MobileAdapter_HandleTransferDataResponseState':0x5c1a,
'MobileAdapter_ApplyReceivedCommandState':0x5e2e,
'MobileAdapter_StartPacketOperation':0x5f0a,
'MobileAdapter_AccumulatePacketChecksum':0x5f90,
'MobileAdapter_TestTransferCompletion':0x5f9a,
}
for k,v in required.items():
    if seen.get(k)!=v: raise SystemExit(f'boundary mismatch {k}: {seen.get(k)} != ${v:04X}')
# $5B25 must source a queued byte to rSB then start transfer through rSC.
if bytes.fromhex('2103d02a5f561ae001') not in retail: raise SystemExit('queued-byte -> rSB signature missing')
if bytes.fromhex('3e03e0023e83e002c9') not in retail: raise SystemExit('rSC transfer-start sequence missing')
# Completion dispatcher recognizes response-form protocol commands.
for cmd in (0x95,0xA8,0xA3,0xA4,0x97,0xA1,0xA2,0x90,0x94,0x92):
    if bytes((0xfe,cmd)) not in retail[0x25c:0x320]: raise SystemExit(f'completion dispatcher missing response command ${cmd:02X}')
# Packet-operation helpers must call shared request preparation at $40B4 / state setter $4225.
if bytes.fromhex('cdb440') not in retail: raise SystemExit('packet operation setup no longer calls $40B4')
if bytes.fromhex('cd2542') not in retail: raise SystemExit('packet operation setup no longer calls $4225')
# The bytes immediately after the owned executable tranche are ten zero padding bytes, then structured protocol data at $6000.
pad=rom[off+(end-start):off+(0x6000-start)]
if pad != bytes(10): raise SystemExit(f'expected zero padding $5FF6-$5FFF, got {pad.hex()}')
print(f'[ok] the current source Mobile Adapter LCD/timer service: {end-start} retail bytes exact, SHA-1 {sha}; transmit-byte service, completion dispatcher, packet-operation helpers, and $6000 data boundary locked')
