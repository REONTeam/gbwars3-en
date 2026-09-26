#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
ROOT=Path(__file__).resolve().parents[1]
rom=ROOT/'GBWARS3.gbc'
if not rom.exists(): raise SystemExit('[fail] GBWARS3.gbc missing')
data=rom.read_bytes()
expected='e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
checks=[
    (len(data)==0x100000, f'ROM size {len(data):#x}'),
    (hashlib.sha256(data).hexdigest()==expected, 'canonical custom-English SHA-256'),
    (data[0x143]==0xC0, f'CGB flag {data[0x143]:#04x}'),
    (data[0x147]==0x1B, f'cartridge type {data[0x147]:#04x}'),
    (data[0x148]==0x05, f'ROM size code {data[0x148]:#04x}'),
    (data[0x149]==0x04, f'RAM size code {data[0x149]:#04x}'),
]
failed=[desc for ok,desc in checks if not ok]
if failed:
    print('Static release regression: FAIL')
    for x in failed: print(' -',x)
    sys.exit(1)
print('Static release regression: PASS')
print(' ROM/header geometry: CGB-only, MBC5+RAM+battery, 1 MiB ROM, 128 KiB SRAM')
print(' canonical SHA-256:',expected)
