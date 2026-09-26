#!/usr/bin/env python3
from pathlib import Path
import re, hashlib
ROOT=Path(__file__).resolve().parents[1]
const=(ROOT/'constants/unit_constants.inc').read_text()
unit=(ROOT/'engine/unit/unit.asm').read_text()

def defs(prefix):
    return {m.group(1):int(m.group(2).replace('$','0x'),0) for m in re.finditer(rf'^DEF ({prefix}[A-Z0-9_]+) EQU (\$[0-9a-fA-F]+|\d+)$', const, re.M)}
weapons=defs('WEAPON_')
profiles=defs('MOVEMENT_PROFILE_')
# Filter geometry constants from WEAPON_* namespace.
weapon_ids={k:v for k,v in weapons.items() if not k.startswith('WEAPON_DATA_')}
assert len(weapon_ids)==33, len(weapon_ids)
assert sorted(weapon_ids.values())==list(range(33))
assert len(profiles)==15 and sorted(profiles.values())==list(range(15))
for name,val in [('UNIT_DATA_WEAPON1_OFFSET',0x14),('UNIT_DATA_WEAPON1_AMMO_OFFSET',0x15),('UNIT_DATA_WEAPON2_OFFSET',0x16),('UNIT_DATA_WEAPON2_AMMO_OFFSET',0x17),('UNIT_DATA_MOVEMENT_PROFILE_OFFSET',0x19)]:
    m=re.search(rf'^DEF {name} EQU (\$[0-9a-fA-F]+|\d+)$', const, re.M); assert m
    assert int(m.group(1).replace('$','0x'),0)==val
# Pointer table order -> constants.
block=unit.split('WeaponData::',1)[1].split('assert @ - WeaponData',1)[0]
labels=re.findall(r'^\s*dw WeaponDataRecords\.([a-z0-9_]+)', block, re.M)
expected=['WEAPON_'+x.upper() for x in labels]
assert len(expected)==33
for i,k in enumerate(expected): assert weapon_ids[k]==i,(k,weapon_ids.get(k),i)
mb=unit.split('MovementData::',1)[1].split('assert @ - MovementData',1)[0]
mlabels=re.findall(r'^\s*dw MovementDataProfiles\.Profile(\d\d)', mb, re.M)
assert mlabels==[f'{i:02d}' for i in range(15)]
# Every UnitData row must use symbolic crossrefs at the known positions.
rows=[]
for line in unit.splitlines():
    if 'unit_data ' not in line: continue
    s=line.split('unit_data ',1)[1].split(' ;',1)[0]
    args=[]; cur=''; q=False
    for ch in s:
        if ch=='"': q=not q; cur+=ch
        elif ch==',' and not q: args.append(cur.strip()); cur=''
        else: cur+=ch
    args.append(cur.strip())
    assert len(args)==26
    assert args[9] in weapon_ids, args[9]
    assert args[11] in weapon_ids, args[11]
    assert args[14] in profiles, args[14]
    vals=[]
    for i,a in enumerate(args[1:]):
        if i in (8,10): n=weapon_ids[a]
        elif i==13: n=profiles[a]
        else: n=int(a,0)
        if i in (6,7): vals.extend((n & 0xff, n >> 8))
        else: vals.append(n)
    rows.extend(vals)
assert len(rows)==53*27
# This numeric attribute payload is a source-only byte-preservation lock.
digest=hashlib.sha1(bytes(rows)).hexdigest()
assert digest=='1236af033a558eb05004639f519dd5ac8c344e7c',digest
print(f'[ok] 53 UnitData rows use symbolic WeaponData/MovementData cross-references; attribute SHA-1 {digest}')
