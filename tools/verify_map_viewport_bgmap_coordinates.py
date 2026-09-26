#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys

ROOT = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'baserom.gbc'
rom = rom_path.read_bytes()
start, end, bank = 0x764A, 0x765D, 0x0B
off = bank * 0x4000 + (start - 0x4000)
data = rom[off:off + (end-start)]
expected = bytes.fromhex('f0950f0f0f80e61f47f0960f0f0f81e61f4fc9')
assert data == expected, f'retail bytes differ: {data.hex()}'
assert hashlib.sha1(data).hexdigest() == '1854015ce14a0114eac94097e3eeaa1d5d218049'
source = (ROOT / 'engine/map/map_viewport_to_bgmap_coordinates_764a.asm').read_text()
for token in [
    'MapPresentation_ConvertViewportTileToBGMapCoordinates::',
    'ldh a, [hSCX]', 'ldh a, [hSCY]', 'and $1f', 'assert @ == $765d'
]:
    assert token in source, f'missing source token: {token}'
wrapper = (ROOT / 'engine/map/map_ui_coordinate_presentation_763d.asm').read_text()
assert 'call MapPresentation_ConvertViewportTileToBGMapCoordinates' in wrapper
# Public entry inventory: eight direct Bank-$0B calls and seven Bank-$0C farcalls.
def positions(pat):
    out=[]; p=0
    while True:
        i=rom.find(pat,p)
        if i < 0: return out
        b=i//0x4000; a=(i%0x4000)+(0x4000 if b else 0)
        out.append((b,a)); p=i+1
expected_direct={(0x0B,a) for a in [0x50DB,0x50FC,0x5118,0x763D,0x7A56,0x7A69,0x7A78,0x7A81]}
expected_far={(0x0C,a) for a in [0x44D2,0x44EA,0x455D,0x457D,0x458D,0x45F0,0x4622]}
assert set(positions(bytes([0xCD,0x4A,0x76]))) == expected_direct
assert set(positions(bytes([0xEF,0x0B,0x4A,0x76]))) == expected_far
# $765D is independently reused, so it is the hard stop.
assert positions(bytes([0xEF,0x0B,0x5D,0x76])), '$765D has no independent farcall callers'
print('Map viewport/BG-map coordinate conversion verification: OK')
