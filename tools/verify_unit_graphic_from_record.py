#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
rom_path=Path(sys.argv[1]) if len(sys.argv)>1 else Path('baserom.gbc')
rom=rom_path.read_bytes()
a,b=0x766c,0x7675
o=0x0b*0x4000+(a-0x4000)
data=rom[o:o+b-a]
expected=bytes.fromhex('e5 57 0e 00 ef 12 66 40 e1')
assert data == expected, (data.hex(), expected.hex())
assert hashlib.sha1(data).hexdigest() == '0e927996145a39bfa4d4350c92106cd4d63166c3'
src=Path('engine/unit/unit_graphic_from_record_766c.asm').read_text()
for token in ['UnitGraphic_LoadFromRecordIndex::','UNIT_RECORD_TYPE_SIDE_OFFSET','farcall $12, UnitRecord_GetByte','assert @ == $7675']:
    assert token in src, token
print('unit graphic live-record entry: OK (9 bytes)')
