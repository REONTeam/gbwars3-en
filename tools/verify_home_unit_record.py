#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=rom_path.read_bytes(); src=(ROOT/'engine/home/home_unit_record.asm').read_text()
start,end=0x090B,0x0985
retail=rom[start:end]
sha=hashlib.sha1(retail).hexdigest(); exp='d5f2dd802fc2140b17e16ea9b70de2805a7c5ff1'
if sha!=exp: raise SystemExit(f'ROM0 helper hash mismatch {sha}')
labels={
'UnitRecord_GetByteROM0':0x090B,
'UnitRecord_GetWordROM0':0x0927,
'UnitRecord_SetByteROM0':0x0942,
'UnitRecord_GetCoordinatesROM0':0x095E,
'UnitRecord_GetAddressROM0':0x097A,
}
for name in labels:
    if f'{name}::' not in src: raise SystemExit(f'missing {name}')
# Lock the exact retail routine bytes independently of source formatting.
parts=[
(0x090B,bytes.fromhex('c5d56ff082f53e03e082e070cd7a0906000946f1e082e07078d1c1c9')),
(0x0927,bytes.fromhex('c56ff082f53e03e082e070cd7a090600095e2356f1e082e070c1c9')),
(0x0942,bytes.fromhex('c5d56ff082f53e03e082e070cd7a095806000973f1e082e070d1c1c9')),
(0x095E,bytes.fromhex('d56ff082f53e03e082e070cd7a090101000946234ef1e082e070d1c9')),
(0x097A,bytes.fromhex('2600292929291100d019c9')),
]
for addr,data in parts:
    if rom[addr:addr+len(data)]!=data: raise SystemExit(f'retail bytes changed at ${addr:04X}')
force=(ROOT/'engine/map/ai/map_control_force.asm').read_text()
if 'call UnitRecord_GetByteROM0' not in force or 'call $090b' in force.lower():
    raise SystemExit('map_control_force did not adopt ROM0 unit byte accessor symbolically')
print(f'[ok] the current source ROM0 live-unit accessors: {end-start} retail bytes exact, SHA-1 {sha}; byte/word/set/coordinates/address contracts locked')
