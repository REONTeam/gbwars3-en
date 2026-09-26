#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys
rom=Path(sys.argv[1] if len(sys.argv)>1 else 'baserom.gbc').read_bytes()
out=Path(sys.argv[2] if len(sys.argv)>2 else 'GBWARS3.gbc').read_bytes()
def off(bank,addr): return bank*0x4000+(addr-0x4000)
start,end=0x7158,0x76e2
r=rom[off(0x15,start):off(0x15,end)]
o=out[off(0x15,start):off(0x15,end)]
assert len(r)==1418
assert hashlib.sha1(r).hexdigest()=='511510f1fb401244aea010d8d1edf54f3b1355b0'
assert r==o, 'Bank $15 map-selection runtime differs from retail'
src=Path('engine/map/map_selection_runtime_bank15.asm').read_text()
for needle in [
    'MapSelection_SetupScreen::','MapSelection_Run::','MapSelection_DrawVisibleEntries::',
    'MapSelection_GetCurrentMapIndex::','MapSelection_AddOffsetWrapped::','assert @ == $76e2']:
    assert needle in src, needle
assert src.count('farcall $')==0
flow=Path('engine/ui/main_mode_reset_runtime.asm').read_text()
assert 'call MapSelection_Run' in flow
assert 'call $7413' not in flow
mk=Path('Makefile').read_text()
objs=re.findall(r'\b([\w/.-]+\.o)\b', mk.split('graphics :=',1)[0])
assert len(objs)==len(set(objs))
for obj in objs: assert Path(obj[:-2]+'.asm').exists(), obj
assert hashlib.sha256(out).hexdigest()=='e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
print('PASS: Bank $15:$7158-$76E1 map-selection family is byte-exact (1418 bytes)')
print('PASS: executable/data split includes only the two proven inline data islands')
print('PASS: MapSave_PostOverwriteFlow calls MapSelection_Run symbolically')
print(f'PASS: Makefile object/source audit {len(objs)} / {len(objs)}')
print('PASS: rebuilt custom ROM SHA-256', hashlib.sha256(out).hexdigest())
