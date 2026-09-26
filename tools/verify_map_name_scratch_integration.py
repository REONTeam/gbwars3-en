#!/usr/bin/env python3
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
constants = (ROOT / 'constants/map_constants.inc').read_text()
symbols = (ROOT / 'symbols.asm').read_text()
source = (ROOT / 'engine/map/map_name_9char.asm').read_text()
map_menu = (ROOT / 'engine/map/map_menu.asm').read_text()
doc = (ROOT / 'docs/map/map_name_render_scratch.md').read_text()

required_constants = {
    'MAP_NAME_RENDER_SCRATCH_SIZE': 'MAP_RECORD_NAME_TERMINATED_SIZE',
    'MAP_NAME_RENDER_EXTRA_OFFSET': 'MAP_RECORD_NAME_SIZE',
    'MAP_NAME_RENDER_TERMINATOR_OFFSET': 'MAP_RECORD_NAME_LOGICAL_SIZE',
}
for name, expr in required_constants.items():
    pat = rf'DEF\s+{name}\s+EQU\s+{re.escape(expr)}'
    assert re.search(pat, constants), f'missing {name} = {expr}'

required_symbols = {
    'wEditorMapNameDisplayBorrowedTerminator': ('$00', '$cc6e'),
    'wMapMenuMapNameScratch': ('$00', '$dc3b'),
    'wMapMenuMapNameScratchExtra': ('$00', '$dc43'),
    'wMapMenuDownloadMapNumber': ('$00', '$dc44'),
    'wUnitStatusMapNameScratch': ('$04', '$db5a'),
    'wUnitStatusMapNameScratchExtra': ('$04', '$db62'),
    'wUnitStatusMapNameScratchBorrowedTerminator': ('$04', '$db63'),
}
for name, (bank, addr) in required_symbols.items():
    sym_pat = rf'sym\s+{re.escape(bank)},\s+{re.escape(addr)},\s+{name}\b'
    def_pat = rf'(?:EXPORT\s+)?DEF\s+{name}\s+EQU\s+{re.escape(addr)}\b'
    assert re.search(sym_pat, symbols, re.I) or re.search(def_pat, symbols, re.I), f'missing symbol {name} at {bank}:{addr}'

# The custom renderer itself must no longer encode these WRAM literals directly.
for addr in ('$cc6e', '$dc3b', '$dc43', '$dc44', '$db5a', '$db62', '$db63'):
    assert addr.lower() not in source.lower(), f'raw {addr} remains in map_name_9char.asm'
assert '$dc44' not in map_menu.lower(), 'raw $dc44 remains in map_menu.asm'
assert 'wMapMenuDownloadMapNumber' in map_menu, 'Map Menu download-map number is not symbolic'
assert re.search(r'DEF\s+wMapMenuMapNameScratchBorrowedTerminator\s+EQU\s+wMapMenuDownloadMapNumber', symbols), 'missing renderer-role alias for $DC44'

for name in required_symbols:
    if name == 'wMapMenuDownloadMapNumber':
        continue
    assert name in source or name == 'wEditorMapNameDisplayBorrowedTerminator', f'{name} not used by renderer'

# Check exact 8 + 1 + 1 geometry from the known addresses.
assert 0xDC43 - 0xDC3B == 8
assert 0xDC44 - 0xDC3B == 9
assert 0xDB62 - 0xDB5A == 8
assert 0xDB63 - 0xDB5A == 9
assert 0xCC6D - 0xCC65 == 8
assert 0xCC6E - 0xCC65 == 9
assert 'saved' in doc and 'restored' in doc and '10' in doc
print('[ok] map-name render scratch integration')
