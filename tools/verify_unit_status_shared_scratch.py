#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom=ROOT/'baserom.gbc'
if not rom.exists():
    print('missing baserom.gbc', file=sys.stderr); sys.exit(1)
data=rom.read_bytes(); bank=0x25; start=0x42BE; end=0x43B3
off=bank*0x4000+(start-0x4000); chunk=data[off:off+end-start]
want='18e09bd027c12d613f0b2b15907c228f88e4a30f'
assert len(chunk)==245 and hashlib.sha1(chunk).hexdigest()==want
sym=(ROOT/'symbols.asm').read_text().lower()
expected={
'wunitstatustypeside':0xc61b,'wunitstatushp':0xc61c,'wunitstatusfuel':0xc61d,
'wunitstatusrank':0xc61e,'wunitstatuspaneside':0xc61f,'wunitstatuspanexoffset':0xc620,
'wunitstatusselectedunitindex':0xc621}
for n,a in expected.items():
    assert re.search(rf'^(?:export\s+def\s+)?{n}\s+equ\s+\${a:04x}\s*$',sym,re.M), (n,a)
src=(ROOT/'engine/unit/unit_status_runtime.asm').read_text()
assert 'romx[$42be], bank[$25]' in src.lower()
assert 'assert @ == $43b3' in src.lower()
body='\n'.join(line for line in src.lower().splitlines() if line.lstrip().startswith('db '))
for raw in ('$c61b','$c61c','$c61d','$c61e','$c61f','$c620','$c621'):
    assert raw not in body, raw
for n in ('wUnitStatusTypeSide','wUnitStatusHP','wUnitStatusFuel','wUnitStatusRank','wUnitStatusPaneSide','wUnitStatusPaneXOffset','wUnitStatusSelectedUnitIndex'):
    assert n in src

# Reconstruct the emitted db stream, including LOW/HIGH shared-scratch aliases.
vals={
'wUnitStatusTypeSide':0xC61B,'wUnitStatusHP':0xC61C,'wUnitStatusFuel':0xC61D,
'wUnitStatusRank':0xC61E,'wUnitStatusPaneSide':0xC61F,'wUnitStatusPaneXOffset':0xC620,
'wUnitStatusSelectedUnitIndex':0xC621}
out=bytearray()
for line in src.splitlines():
    line=line.split(';',1)[0].strip()
    if not line.startswith('db '): continue
    for tok in line[3:].split(','):
        tok=tok.strip()
        if tok.startswith('$'): out.append(int(tok[1:],16))
        elif tok.startswith('LOW('): out.append(vals[tok[4:-1]] & 0xff)
        elif tok.startswith('HIGH('): out.append(vals[tok[5:-1]] >> 8)
        else: raise AssertionError(tok)
assert bytes(out)==chunk, (len(out), len(chunk))

notes=(ROOT/'docs/unit/unit_status_shared_scratch.md').read_text()
assert '$C61A' in notes and 'intentionally not assigned' in notes
print(f'[ok] Bank $25:$42BE-$43B2 Unit Status staging: 245 bytes sha1={want}')
print('[ok] shared $C61B-$C621 lifetime aliases typed without claiming $C61A')
