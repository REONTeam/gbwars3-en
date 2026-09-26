#!/usr/bin/env python3
from pathlib import Path
import hashlib

root = Path(__file__).resolve().parents[1]
retail = (root / 'baserom.gbc').read_bytes()
built = (root / 'GBWARS3.gbc').read_bytes()

def off(bank, addr):
    return bank * 0x4000 + (addr - 0x4000)

def check(start, end, name):
    a = off(0x19, start)
    b = off(0x19, end)
    assert built[a:b] == retail[a:b], f'{name}: built bytes differ from Japanese retail at ${start:04X}-${end-1:04X}'
    print(f'PASS {name}: Bank $19:${start:04X}-${end-1:04X} ({end-start} bytes)')

check(0x6C64, 0x6E79, 'profile-review setup/resources/helpers')
check(0x6E79, 0x7059, 'profile-review interactive controller')
sha = hashlib.sha256(built).hexdigest()
expected = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
assert sha == expected, f'custom-English SHA-256 mismatch: {sha}'
print('PASS custom-English SHA-256:', sha)
