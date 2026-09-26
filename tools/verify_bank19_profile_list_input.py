#!/usr/bin/env python3
from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
retail = ROOT / 'baserom.gbc'
built = ROOT / 'GBWARS3.gbc'
start, end, bank = 0x6581, 0x661E, 0x19
off = bank * 0x4000 + (start - 0x4000)
if not retail.exists() or not built.exists():
    raise SystemExit('baserom.gbc and GBWARS3.gbc are required')
a = retail.read_bytes()[off:off + end - start]
b = built.read_bytes()[off:off + end - start]
assert a == b, 'Bank $19:$6581-$661D differs from retail'
sha = hashlib.sha256(built.read_bytes()).hexdigest()
assert sha == 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059', sha
src = (ROOT / 'engine/network/bank19_network_ui_continuation.asm').read_text()
for token in ['NetworkUI_RunProfileListInput::', 'NetworkProfile_TestIndexedRecord', 'Bank31_RuntimePositionHelper_58F1', 'MapMenuMessage_ServiceFrame']:
    assert token in src, token
print('PASS - Bank $19 profile-list input controller')
print(f'PASS - {end-start} bytes match retail exactly')
print(f'PASS - custom English SHA-256 {sha}')
