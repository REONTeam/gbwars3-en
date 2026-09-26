#!/usr/bin/env python3
from pathlib import Path
import hashlib
ROOT=Path(__file__).resolve().parents[1]; ROM=ROOT/'baserom.gbc'; SRC=ROOT/'engine/unit/unit_status_data.asm'
ranges=[(0x43B3,0x43BD,'5800d0be03c4d048a0876e41f5e86f2e4e6c7225'),(0x448C,0x44F3,'99e03b8953e250d579496215d1b3fb9a44c84cdd')]
text=SRC.read_text(); sections=[]; cur=None
for line in text.splitlines():
    code=line.split(';',1)[0].strip()
    if code.lower().startswith('section '):
        import re
        m=re.search(r'romx\[\$(....)\]',code,re.I)
        if cur: sections.append(cur)
        cur=[int(m.group(1),16),[]] if m else None
    elif cur and code.startswith('db '):
        cur[1].extend(int(x.strip()[1:],16) for x in code[3:].split(','))
if cur: sections.append(cur)
by={s:bytes(v) for s,v in sections}
for st,en,sha in ranges:
    got=by.get(st)
    if got is None or len(got)!=en-st: raise SystemExit(f'bad source range ${st:04X}')
    if ROM.exists():
        off=0x25*0x4000+(st-0x4000); d=ROM.read_bytes()[off:off+en-st]; h=hashlib.sha1(d).hexdigest()
        if h!=sha or got!=d: raise SystemExit(f'mismatch ${st:04X}')
        print(f'[ok] Unit Status data ${st:04X}-${en-1:04X}: {len(d)} bytes, SHA-1 {h}')
