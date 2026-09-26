#!/usr/bin/env python3
from pathlib import Path
import hashlib,re
ROOT=Path(__file__).resolve().parents[1]
rom=(ROOT/'baserom.gbc').read_bytes(); out=(ROOT/'GBWARS3.gbc').read_bytes()
def off(bank,addr): return bank*0x4000+(addr-0x4000)
for a,b in [(0x661e,0x6758),(0x6759,0x67e1)]:
 s=off(0x19,a); e=off(0x19,b)+1
 assert rom[s:e]==out[s:e], f'Bank19 {a:04X}-{b:04X} mismatch'
print('PASS Bank19 $661E-$6758 profile/character-entry setup: 315 bytes')
print('PASS Bank19 $6759-$67E1 text/character-grid resources: 137 bytes')
src=(ROOT/'engine/network/bank19_network_ui_continuation.asm').read_text()
for tok in ['NetworkUI_SetupProfileCharacterEntry::','NetworkUI_CharacterEntryHeader_Mode0::','NetworkUI_CharacterRow5::','assert @ == $6759']:
 assert tok in src, tok
raw=re.compile(r'\bfarcall\s+\$[0-9a-f]+\s*,\s*\$[0-9a-f]+',re.I)
offenders=[]
for p in ROOT.rglob('*.asm'):
 for n,line in enumerate(p.read_text(errors='ignore').splitlines(),1):
  if raw.search(line): offenders.append(f'{p.relative_to(ROOT)}:{n}: {line.strip()}')
assert not offenders, '\n'.join(offenders)
print('PASS project-wide raw numeric farcall audit: 0')
h=hashlib.sha256(out).hexdigest(); exp='e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
assert h==exp,(h,exp)
print('PASS corrected custom-English SHA-256',h)
