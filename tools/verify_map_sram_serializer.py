#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
rom = Path(sys.argv[1] if len(sys.argv)>1 else 'baserom.gbc').read_bytes()
start = 0x13*0x4000 + (0x5ec2-0x4000)
end = 0x13*0x4000 + (0x6072-0x4000)
data = rom[start:end]
assert len(data) == 0x1b0, len(data)
print(f'Map SRAM serializer retail range: $13:$5EC2-$6071 ({len(data)} bytes)')
print('SHA-1:', hashlib.sha1(data).hexdigest())
print('Boundary bytes:', data[:8].hex(), data[-8:].hex())
