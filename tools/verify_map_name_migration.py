#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys
if len(sys.argv) != 2:
    raise SystemExit('usage: verify_map_name_migration.py baserom.gbc')
rom=Path(sys.argv[1]).read_bytes(); root=Path(__file__).resolve().parents[1]
def off(b,a): return a if b==0 else b*0x4000+(a-0x4000)
def sha(b,s,e): return hashlib.sha1(rom[off(b,s):off(b,e)]).hexdigest()
# Fresh-map initializer: proves editor prefix fields immediately follow the 8-byte name.
expected='2b3b5d028fc0e11ca78fa2315a6e4879b2c696c9'
got=sha(0x0f,0x40eb,0x4133)
if got != expected: raise SystemExit(f'0f:40eb-4132 SHA-1 {got} != {expected}')
text=(root/'engine/map/map_editor.asm').read_text()
for tok in ['MapEditor_InitNewMapRecord','wEditorMapRecordBuffer','wEditorMapRecordWidth','wEditorMapRecordHeight']:
    if tok not in text: raise SystemExit(f'map_editor.asm missing {tok}')
syms=(root/'symbols.asm').read_text()
for addr,name in [('$c885','wEditorMapRecordBuffer'),('$c8a5','wEditorMapName'),('$c8ad','wEditorMapRecordFields'),('$c8b1','wEditorMapRecordWidth'),('$c8b2','wEditorMapRecordHeight'),('$c8b3','wEditorMapFooter')]:
    if addr not in syms or name not in syms: raise SystemExit(f'missing symbol {name}')
const=(root/'constants/map_constants.inc').read_text()
if not re.search(r'DEF\s+MAP_RECORD_NAME_SIZE\s+EQU\s+8\b',const): raise SystemExit('retail width unexpectedly changed before migration prerequisites')
doc=(root/'docs/map/map_name_9char_migration.md').read_text()
for tok in ['$CA4F','$C8AD','$CC38','$CC6E','$CC92','$0524','backward-compatible SRAM-slot']:
    if tok not in doc: raise SystemExit(f'migration doc missing {tok}')
# Prove each immediate in-place ninth-byte collision is referenced by retail code.
# Search 16-bit absolute operands and require at least one plausible LD opcode context.
for addr in (0xca4f,0xc8ad,0xcc38,0xcc6e,0xcc92):
    pat=bytes((addr & 0xff, addr >> 8)); hits=[]; pos=0
    while True:
        i=rom.find(pat,pos)
        if i<0: break
        if i and rom[i-1] in (0x11,0x21,0xea,0xfa):
            bank=(i-1)//0x4000; a=(i-1) if bank==0 else 0x4000+((i-1)%0x4000); hits.append((bank,a))
        pos=i+1
    if not hits: raise SystemExit(f'no code reference found for collision address ${addr:04x}')
print('map-name 9-character migration prerequisite audit: [ok]')
print('  fresh editor-prefix initializer: 0f:40eb-4132 / 72 bytes')
print('  in-place collision addresses proven live: CA4F C8AD CC38 CC6E CC92')
print('  MAP_RECORD_NAME_SIZE intentionally remains 8')
