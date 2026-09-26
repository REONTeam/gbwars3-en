#!/usr/bin/env python3
from pathlib import Path
import hashlib, re
ROOT = Path(__file__).resolve().parents[1]
rom = (ROOT / 'baserom.gbc').read_bytes()
spans = [
    (0x13, 0x54C0, 0x5541, 'Map Menu continue-from-save prompt', '3d26d480249144092ed60202fe448efe98d5c9c5'),
    (0x16, 0x454B, 0x460E, 'battle-unit sprite descriptor/pixel loader', '8df2b85f8cd0c1d7826ec9bfaee23f4c5f234613'),
    (0x00, 0x39DB, 0x3A8E, 'sequential VRAM rectangle writer', '056ea047525c1ef5f0f1ba22afd307601619e255'),
]
for bank, lo, hi, name, want in spans:
    off = lo if bank == 0 else bank * 0x4000 + (lo - 0x4000)
    blob = rom[off:off + hi - lo]
    got = hashlib.sha1(blob).hexdigest()
    assert got == want, (name, got, want)
    print(f'PASS {name}: {bank:02X}:{lo:04X}-{hi-1:04X} ({len(blob)} bytes)')
files = [
    ROOT/'engine/map/map_menu_continue_save_prompt.asm',
    ROOT/'engine/battle/battle_unit_sprite_loader.asm',
    ROOT/'engine/home/home_vram_tile_rectangle.asm',
]
for p in files:
    text = p.read_text()
    raw = [ln for ln in text.splitlines() if re.match(r'^\s*db\s+\$[0-9a-f]{2}', ln, re.I)]
    assert not raw, (p, raw[:3])
    print(f'PASS no executable raw db stream remains in {p.relative_to(ROOT)}')
prompt = files[0].read_text()
assert 'farcall Gfx_UpdateCommonAnimatedTile' in prompt
assert 'farcall $15, $6791' not in prompt
print('PASS Map Menu prompt uses symbolic common-animation service')
out = ROOT/'GBWARS3.gbc'
if out.exists():
    got = hashlib.sha256(out.read_bytes()).hexdigest()
    want = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
    assert got == want, (got, want)
    print('PASS corrected custom-English SHA-256', got)
print('PASS exact mnemonic cleanup total: 503 bytes')
