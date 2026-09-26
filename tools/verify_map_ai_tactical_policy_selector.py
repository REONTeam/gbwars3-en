#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
rom=Path(sys.argv[1]).read_bytes(); src=Path('engine/map/ai/map_ai_tactical_policy_selector.asm').read_text(); units=Path('constants/unit_constants.inc').read_text()
const={m.group(1):int(m.group(2),0) for m in re.finditer(r'^DEF\s+(UNIT_TYPE_[A-Z0-9_]+)\s+EQU\s+([^;\s]+)',units,re.M)}
start,end=0x4106,0x4321; off=0x0d*0x4000+(start-0x4000); expected=rom[off:off+end-start]
vals=[]
for line in src.splitlines():
    code=line.split(';',1)[0]
    if 'db ' not in code: continue
    rhs=code.split('db ',1)[1]
    for t in rhs.split(','):
        t=t.strip()
        if re.fullmatch(r'\$[0-9a-fA-F]{2}',t): vals.append(int(t[1:],16))
        elif t in const: vals.append(const[t])
        elif t: raise SystemExit(f'unparsed db token: {t}')
got=bytes(vals)
assert got==expected,(len(got),len(expected))
sha=hashlib.sha1(got).hexdigest(); assert sha=='6eb430eedfdd1a00dec88516986006f2922e7cd6',sha
for marker in ('MapAI_TacticalPolicySelector::','MapAI_FindUnitTypeRankInPriorityList::','MapAI_SelectNonAirPriorityDomain::','MapAI_SelectAirPriorityDomain::','MapAI_FindBestNeighborByTacticalScore::','MapAI_NonAirUnitPriorityList::','MapAI_AirUnitPriorityList::'):
    assert marker in src,marker
bank=rom[0x0d*0x4000:0x0e*0x4000]
# True selector entry: load scratch encoded type, shift side bit, then call profile A.
assert bank[0x4106-0x4000:0x4110-0x4000]==bytes.fromhex('faddcccb3fcd354a7de0')
assert bank[0x404f-0x4000:0x4052-0x4000]==bytes.fromhex('cd0641')
# $410B is the call opcode, not a public routine entry.
assert bank[0x410b-0x4000:0x410e-0x4000]==bytes.fromhex('cd354a')
# Lower list index wins: candidate rank -> B, current best -> A, CP B; JR C skips worse candidate.
assert bytes.fromhex('f09b47faeac5b83812') in bank[0x4106-0x4000:0x41a6-0x4000]
# Natural-terrain ($20+) candidates receive a +$40 rank penalty.
assert bytes.fromhex('fe203806f09bc640e09b') in bank[0x4106-0x4000:0x41a6-0x4000]
# The two fixed domain lists are exact complements over real combat-domain types: 1-28/44-51 vs 29-43.
nonair=list(bank[0x42ec-0x4000:0x4311-0x4000]); air=list(bank[0x4311-0x4000:0x4321-0x4000])
assert nonair[-1]==0 and air[-1]==0
assert set(nonair[:-1])==set(range(1,29))|set(range(44,52))
assert set(air[:-1])==set(range(29,44))
print(f'[ok] the current source tactical policy selector: {len(got)} retail bytes exact, SHA-1 {sha}; profile-A rank direction and air/non-air lists proven')
