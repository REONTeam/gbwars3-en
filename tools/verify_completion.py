#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys
ROOT=Path(__file__).resolve().parents[1]
EXPECTED='e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
errors=[]
rom=ROOT/'GBWARS3.gbc'
if not rom.exists(): errors.append('GBWARS3.gbc is missing')
else:
    data=rom.read_bytes()
    if len(data)!=1024*1024: errors.append(f'ROM size is {len(data)}, expected 1048576')
    h=hashlib.sha256(data).hexdigest()
    if h!=EXPECTED: errors.append(f'ROM SHA-256 {h} != {EXPECTED}')
mk=(ROOT/'Makefile').read_text(errors='ignore')
# Main linker must be standalone.
rule=re.search(r'^\$\(name\)\.gbc: \$\(objects\).*?\n\t([^\n]*RGBLINK[^\n]*)',mk,re.M)
if not rule: errors.append('main GBWARS3 link rule not found')
elif '-O baserom.gbc' in rule.group(1): errors.append('main link still inherits baserom.gbc with -O')
if 'engine/remaining_rom.o' not in mk: errors.append('engine/remaining_rom.o missing from object list')
# Map must report complete ROM placement.
mp=ROOT/'GBWARS3.map'
if not mp.exists(): errors.append('GBWARS3.map is missing')
else:
    txt=mp.read_text(errors='ignore')
    if 'ROM0: 16384 bytes used / 0 free' not in txt: errors.append('ROM0 is not fully owned')
    if 'ROMX: 1032192 bytes used / 0 free in 63 banks' not in txt: errors.append('ROMX is not fully owned')
# Source hygiene audits.
num_far=[]; pass_refs=[]
farpat=re.compile(r'farcall\s+\$[0-9A-Fa-f]+\s*,\s*\$[0-9A-Fa-f]+')
passpat=re.compile(r'\bpass\s+[0-9]+',re.I)
for rootname in ('engine','data','audio','constants','macros'):
    root=ROOT/rootname
    if not root.exists(): continue
    for p in root.rglob('*'):
        if p.suffix.lower() not in ('.asm','.inc'): continue
        for i,line in enumerate(p.read_text(errors='ignore').splitlines(),1):
            if farpat.search(line): num_far.append(f'{p.relative_to(ROOT)}:{i}')
            if passpat.search(line): pass_refs.append(f'{p.relative_to(ROOT)}:{i}')
if num_far: errors.append(f'{len(num_far)} raw numeric farcall sites remain')
if pass_refs: errors.append(f'{len(pass_refs)} development-pass references remain in ASM/INC')
# Every extracted remaining asset must be referenced and every INCBIN must exist.
remaining=(ROOT/'engine/remaining_rom.asm').read_text(errors='ignore')
refs=re.findall(r'INCBIN\s+"([^"]+)"',remaining,re.I)
for rel in refs:
    if not (ROOT/rel).exists(): errors.append(f'missing remaining asset {rel}')
if (ROOT/'data/remaining').exists():
    leftovers=list(ROOT.rglob('*.bin'))
    if leftovers: errors.append(f'{len(leftovers)} staged data/remaining assets still exist')
for rel in refs:
    if not (ROOT/rel).exists(): errors.append(f'missing INCBIN asset {rel}')
# Count explicit build objects.
objs=set(re.findall(r'[A-Za-z0-9_./-]+\.o',mk))
if len(objs)!=383: errors.append(f'build object count {len(objs)}, expected 383')
if errors:
    print('Completion verification: FAIL')
    for e in errors: print(' -',e)
    sys.exit(1)
print('Completion verification: PASS')
print(' ROM bytes owned: 1048576 / 1048576')
print(' ROM0 free: 0')
print(' ROMX free: 0')
print(' SHA-256:',EXPECTED)
print(' build objects:',len(objs))
print(' raw numeric farcalls: 0')
print(' ASM/INC development-pass references: 0')
print(' standalone INCBIN assets referenced:',len(refs))
