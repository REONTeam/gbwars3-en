#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys
root=Path(__file__).resolve().parents[1]
rom=root/'baserom.gbc'
src=root/'engine/campaign/campaign_medal_statistics_runtime.asm'
if not rom.exists():
    print('[skip] baserom.gbc not present'); sys.exit(0)
b=rom.read_bytes(); text=src.read_text()
RANGES=[(0x4A12,0x4A58),(0x4A59,0x4D59)]
# Parse literal db bytes only; this module intentionally remains byte-authoritative.
vals=[]
for line in text.splitlines():
    line=line.split(';',1)[0].strip()
    if line.startswith('db '):
        for tok in line[3:].split(','):
            vals.append(int(tok.strip().replace('$','0x'),0))
# Expected module bytes are concatenated because fixed sections skip no bytes after the current source.
start,end=0x4A12,0x4D59
off=0x11*0x4000+(start-0x4000)
exp=b[off:off+end-start+1]
if bytes(vals)!=exp:
    raise SystemExit(f'[fail] campaign medal/statistics bytes differ: source {len(vals)}, expected {len(exp)}')
print(f'[ok] Campaign medal/statistics contiguous range $11:${start:04X}-${end:04X}: {len(exp)} bytes, sha1={hashlib.sha1(exp).hexdigest()}')
