#!/usr/bin/env python3
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
macro=(ROOT/'macros/unit_macros.inc').read_text(); unit=(ROOT/'engine/unit/unit.asm').read_text()
for needle in ['db \\1 ; movement power','db \\1 ; transport capacity','db \\1 ; unresolved $0E','db \\1 ; fuel upkeep','dw \\1 ; gold cost / 100G','dw \\1 ; material cost','db \\1 ; target class','db \\1 ; movement profile','db \\1 ; DEF: armored','db \\1 ; DEF: submarine','db \\1 ; base Focus','db \\1 ; Focus loss']:
    assert needle in macro, needle
rows=[]
for line in unit.splitlines():
    if 'unit_data ' not in line or line.lstrip().startswith(';'): continue
    body=line.split('unit_data ',1)[1].split(' ;',1)[0]
    args=[]; cur=''; q=False
    for ch in body:
        if ch=='"': q=not q; cur+=ch
        elif ch==',' and not q: args.append(cur.strip()); cur=''
        else: cur+=ch
    args.append(cur.strip()); assert len(args)==26,(len(args),line)
    assert 0 <= int(args[7],0) <= 0xffff and 0 <= int(args[8],0) <= 0xffff
    rows.append(args)
assert len(rows)==53
assert any(int(r[7],0)>0xff for r in rows)
print('[ok] 53 UnitData records use the 25-field semantic attribute form')
print('[ok] gold/material costs are single 16-bit macro arguments emitted with dw')
print('[ok] unresolved $0E remains an explicit independent byte field')
