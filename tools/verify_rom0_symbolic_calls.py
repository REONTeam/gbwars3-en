#!/usr/bin/env python3
from pathlib import Path
import re, sys
ROOT = Path(__file__).resolve().parents[1]
checks = {
    'data/medals.asm': [('AddAtoHL', 2)],
    'engine/map/map_menu.asm': [('MultiplyAByB', 2)],
    'engine/map/map_sram.asm': [('Math_SubtractDEFromHL', 2)],
    'engine/unit/unit_setup.asm': [('Math_CompareHLToDE', 1), ('Math_DivideDEByBC', 1)],
    'engine/ui/text_input.asm': [('Sprite_Update', 1), ('VBlankFIFO_Queue', 3), ('VBlankFIFO_Clear', 1), ('Vram_ResetPals', 1), ('Joypad_Update', 1)],
}
raw = ['$29bc','$2995','$29c3','$29ca','$2a21','$3056','$350f','$34ce','$0618','$05a2']
errors=[]
for rel, expected in checks.items():
    text=(ROOT/rel).read_text()
    for name,count in expected:
        got=len(re.findall(r'(?m)^\s*call\s+'+re.escape(name)+r'\b', text))
        if got != count:
            errors.append(f'{rel}: expected {count} call(s) to {name}, got {got}')
    code='\n'.join(line.split(';',1)[0] for line in text.splitlines())
    for addr in raw:
        if re.search(r'(?i)\bcall\s+'+re.escape(addr)+r'\b', code):
            errors.append(f'{rel}: raw call target remains: {addr}')
# Lock source-backed/global target labels.
label_sources = {
    'MultiplyAByB': 'engine/home/home_map.asm',
    'AddAtoHL': 'engine/home/home_map.asm',
    'VBlankFIFO_Clear': 'engine/home/home_system.asm',
    'Joypad_Update': 'engine/home/home.asm',
    'Vram_ResetPals': 'engine/home/home.asm',
}
for label, rel in label_sources.items():
    if not re.search(r'(?m)^'+re.escape(label)+r'::', (ROOT/rel).read_text()):
        errors.append(f'{rel}: missing global label {label}')
# Lock symbol-only anchors that intentionally remain overlay-owned.
symbols=(ROOT/'symbols.asm').read_text().lower()
for bank,addr,name in [(0,0x29c3,'Math_SubtractDEFromHL'),(0,0x29ca,'Math_CompareHLToDE'),(0,0x2a21,'Math_DivideDEByBC'),(0,0x3056,'Sprite_Update'),(0,0x350f,'VBlankFIFO_Queue')]:
    needle=f'sym ${bank:02x}, ${addr:04x}, {name}'.lower()
    if needle not in symbols:
        errors.append(f'symbols.asm: missing {needle}')
if errors:
    print('\n'.join('[fail] '+e for e in errors)); sys.exit(1)
print('[ok] ROM0 helper calls use established symbolic targets')
print('[ok] 15 raw-address call sites converted without changing target addresses')
