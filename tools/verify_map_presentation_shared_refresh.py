#!/usr/bin/env python3
from pathlib import Path
import hashlib
import sys

ROM = Path(sys.argv[1]) if len(sys.argv) > 1 and sys.argv[1] else Path("baserom.gbc")
START = 0x7645
END = 0x764A
BANK = 0x0B
EXPECTED = bytes.fromhex("ef 10 8e 69 c9")
EXPECTED_SHA1 = "7f2bb68a4bbc97c63ffd75aa1eb0bdb007465498"

def rom_offset(bank, addr):
    return bank * 0x4000 + (addr - 0x4000)

def hits(data, pat):
    out=[]
    pos=0
    while True:
        pos=data.find(pat,pos)
        if pos < 0:
            return out
        bank=pos//0x4000
        addr=(pos%0x4000)+(0 if bank==0 else 0x4000)
        out.append((bank,addr))
        pos+=1

rom=ROM.read_bytes()
chunk=rom[rom_offset(BANK,START):rom_offset(BANK,END)]
assert chunk == EXPECTED, f"retail bytes differ: {chunk.hex(' ')}"
assert hashlib.sha1(chunk).hexdigest() == EXPECTED_SHA1
# Two same-bank direct callers and two cross-bank farcalls target the public entry.
assert hits(rom, bytes([0xCD,0x45,0x76])) == [(0x0B,0x5086),(0x0B,0x526A)]
assert hits(rom, bytes([0xEF,0x0B,0x45,0x76])) == [(0x0C,0x4548),(0x0C,0x74E8)]
# The next primitive at $764A is independently reused and must not be absorbed.
assert hits(rom, bytes([0xCD,0x4A,0x76])), "$764A must have direct callers"
assert hits(rom, bytes([0xEF,0x0B,0x4A,0x76])), "$764A must have cross-bank callers"
print("map presentation shared refresh: OK")
