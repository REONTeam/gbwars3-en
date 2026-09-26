#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import sys

ROOT = Path(__file__).resolve().parents[1]
rom = Path(sys.argv[1] if len(sys.argv) > 1 else ROOT / 'baserom.gbc').read_bytes()

def require(cond, msg):
    if not cond:
        raise AssertionError(msg)

def off(bank, addr):
    return bank * 0x4000 + (addr - 0x4000)

def chunk(start, end):
    return rom[off(0x15, start):off(0x15, end)]

code = chunk(0x6691, 0x6bba)
require(len(code) == 1321, 'Bank15 common screen runtime length changed')
require(sha1(code).hexdigest() == 'dfc4166c2df87ee7739a4b94ae4f2392e6b30cfb', 'Bank15 common screen runtime fingerprint changed')

asset_root = ROOT / 'gfx/ui/common_screen'
assets = [
    ('common_tiles.2bpp', 0x6bba, 0x6c8a, '8be83ad918fcf8c6bbeb2803e98a68aff315ef26'),
    ('common_palettes.pal', 0x6c8a, 0x6cca, 'b716fe7e4fa60486a1732d834343438f727a7af5'),
    ('icon_tiles.2bpp', 0x7024, 0x7104, '14cdffd45f4008ea63c6c4ff96d4332b2183eb2f'),
    ('icon_palettes.pal', 0x7104, 0x7124, '1d7885e3e0b97f3a45177bc3975e696f36f5e4a3'),
]
for name, start, end, digest in assets:
    data = (asset_root / name).read_bytes()
    require(data == chunk(start, end), f'{name} differs from retail Bank15 bytes')
    require(sha1(data).hexdigest() == digest, f'{name} fingerprint changed')

src = (ROOT / 'engine/ui/common_screen_tilemap_runtime.asm').read_text()
for token in (
    'section "Common Screen And Tilemap Runtime", romx[$6691], bank[$15]',
    'Gfx_LoadCommonScreenAssets::',
    'Gfx_LoadCommonScreenAssetsAt8800::',
    'Gfx_UpdateCommonAnimatedTile::',
    'Gfx_DrawSequentialTileRectWithAttributes::',
    'Gfx_DrawSequentialTileRect::',
    'Gfx_DrawSequentialTileRectDirectionalWithAttributes::',
    'Gfx_DrawSequentialTileRectDirectional::',
    'Gfx_ClearTileRect::',
    'Gfx_TilemapFill::',
    'Gfx_SetTileRectPriority::',
    'CommonScreenAnimatedTileFrames::',
    'CommonScreenAlternatePalette::',
    'assert @ == $6bba',
    'assert @ == $7124',
):
    require(token in src, f'missing common-screen source token: {token}')

# The animation frames and alternate palette are deliberately aliases inside
# larger physical resources; lock those exact offsets.
require((asset_root / 'common_tiles.2bpp').read_bytes()[0x40:0x80] == chunk(0x6bfa, 0x6c3a), 'animated-tile alias no longer matches common tile payload')
require((asset_root / 'common_palettes.pal').read_bytes()[0x10:0x18] == chunk(0x6c9a, 0x6ca2), 'alternate palette alias moved')

# Already-source-backed consumers should no longer call the two historically
# exposed entry points by raw Bank15 addresses.
for p in (ROOT / 'engine').rglob('*.asm'):
    if p.name == 'common_screen_tilemap_runtime.asm':
        continue
    text = p.read_text(errors='ignore')
    for raw in ('farcall $15, $6691', 'farcall $15, $6791', 'farcall $15, $67fd', 'farcall $15, $6ad3'):
        require(raw not in text, f'raw common-screen call remains in {p.relative_to(ROOT)}: {raw}')

print('Bank15 common screen/tilemap runtime $6691-$6BB9: retail fingerprint [ok]')
print('Common UI tiles/palettes and overlapping animation/palette aliases: [ok]')
print('Source-backed consumers use symbolic Bank15 presentation APIs: [ok]')
