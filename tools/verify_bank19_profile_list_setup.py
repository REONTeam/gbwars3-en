#!/usr/bin/env python3
from pathlib import Path
import hashlib, re
ROOT=Path(__file__).resolve().parents[1]
SRC=ROOT/'engine/network/bank19_network_ui_continuation.asm'
ROM=ROOT/'baserom.gbc'
OUT=ROOT/'GBWARS3.gbc'
BANK=0x19; START=0x64E8; END=0x6568
EXPECTED='e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
text=SRC.read_text(encoding='utf-8')
head=text.split('NetworkUI_ProfileListLabel0::',1)[0]
if re.search(r'(?mi)^\s*db\b', head):
    raise SystemExit('[fail] raw db remains in $64E8-$6567 profile-list setup')
for token in ['NetworkUI_ProfileListContinuation::','NetworkUI_ProfileListLabel0::','NetworkUI_ProfileListLabel1::']:
    if token not in text: raise SystemExit(f'[fail] missing {token}')
if not ROM.is_file() or not OUT.is_file(): raise SystemExit('[fail] build ROM inputs missing')
r=ROM.read_bytes(); o=OUT.read_bytes(); off=BANK*0x4000+(START-0x4000)
if r[off:off+END-START] != o[off:off+END-START]:
    raise SystemExit('[fail] Bank $19:$64E8-$6567 differs from retail')
sha=hashlib.sha256(o).hexdigest()
if sha != EXPECTED: raise SystemExit(f'[fail] custom ROM SHA-256 drift: {sha}')
print('[ok] Bank $19:$64E8-$6567 mnemonic profile-list setup matches retail')
print('[ok] following text records are explicitly labeled at $6568 and $6575')
print('[ok] custom English ROM SHA-256 unchanged:', sha)
