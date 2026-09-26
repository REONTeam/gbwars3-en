#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
RANGES=[
 ('Versus setup-state/screen',0x18,0x65E0,0x6873,'2df98cec9def9e414f46e4c135446437bd53ec7d','engine/versus/versus_setup_runtime.asm'),
 ('Versus rows/unit-entry',0x18,0x6873,0x6C6C,'cc2c85ea8ea9a06473c68830b8bcddf1ddb02a11','engine/versus/versus_setup_runtime.asm'),
 ('Versus map/style frontend',0x18,0x5BC8,0x5E5B,'f21271da91be1cb998c327acc0cde75e07fa17ed','engine/versus/versus_map_selection_runtime.asm'),
 ('MapMenu 47E3',0x13,0x47E3,0x4A75,'61d48dd61845a8288dac3a103153d35ed005ff1f','engine/map/map_menu_runtime_47e3.asm'),
 ('MapMenu 4B86',0x13,0x4B86,0x4D4F,'a3494cab17b258b15a6ac4c9b6ef964c3d9c8ab0','engine/map/map_menu_runtime_4b86.asm'),
 ('MapMenu 4F40',0x13,0x4F40,0x51F3,'1d3e3a2723b35ab383a77cd2d96989267e820640','engine/map/map_menu_runtime_4f40.asm'),
]
rom=None
for p in [ROOT/'baserom.gbc',Path('/mnt/data/baserom.gbc')]:
 if p.is_file(): rom=p.read_bytes(); break
if rom is None: raise SystemExit('[fail] baserom.gbc not found')
for name,b,s,e,want,path in RANGES:
 off=b*0x4000+(s-0x4000); data=rom[off:off+e-s]; got=hashlib.sha1(data).hexdigest()
 if got!=want: raise SystemExit(f'[fail] {name} SHA-1 {got} != {want}')
 text=(ROOT/path).read_text().lower()
 # setup file alone retains the intentional four-space data record at $6C6C.
 db=[ln for ln in text.splitlines() if re.match(r'^\s*db\b',ln)]
 if path.endswith('versus_setup_runtime.asm'):
  if db != ['    db $20, $20, $20, $20']:
   raise SystemExit('[fail] unexpected raw db remains in Versus setup runtime')
 elif db:
  raise SystemExit(f'[fail] raw db remains in mnemonic runtime {path}')
 print(f'[ok] {name}: {e-s} bytes, SHA-1 {got}')
# project-wide farcall audit
pat=re.compile(r'farcall\s+\$[0-9a-f]{1,2}\s*,\s*\$[0-9a-f]{4}',re.I)
hits=[]
for p in ROOT.rglob('*.asm'):
 for n,l in enumerate(p.read_text(errors='ignore').splitlines(),1):
  if pat.search(l): hits.append(f'{p.relative_to(ROOT)}:{n}')
if hits: raise SystemExit('[fail] raw numeric farcall remains: '+', '.join(hits[:8]))
print('[ok] project-wide raw numeric farcall audit: 0')
# source/object inventory
mods=[p for d in [ROOT/n for n in ('engine','data','audio','source')] if d.exists() for p in d.rglob('*.asm')]
mk=(ROOT/'Makefile').read_text()
objs=set(re.findall(r'\b(?:engine|data|audio|source)/[A-Za-z0-9_./-]+\.o\b',mk))
sc=len(mods)+(1 if (ROOT/'symbols.asm').exists() else 0); oc=len(objs)+(1 if re.search(r'\bsymbols\.o\b',mk) else 0)
if sc!=oc: raise SystemExit(f'[fail] object/source inventory {oc}/{sc}')
print(f'[ok] Makefile object/source inventory: {oc}/{sc}')
built=ROOT/'GBWARS3.gbc'
if built.is_file():
 digest=hashlib.sha256(built.read_bytes()).hexdigest(); want='e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
 if digest!=want: raise SystemExit('[fail] custom-English ROM changed: '+digest)
 print('[ok] custom-English SHA-256: '+digest)
print('[ok] total newly mnemonic executable bytes: 4141')
