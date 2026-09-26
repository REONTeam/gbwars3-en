#!/usr/bin/env python3
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
for ext in ('*.dat','*.sound','*.gfx','*.bin'):
    bad=list(ROOT.rglob(ext))
    if bad:
        raise SystemExit(f'[fail] generic/retired asset extension remains ({ext}): {bad[0].relative_to(ROOT)}')
if (ROOT/'data/remaining').exists():
    raise SystemExit('[fail] retired data/remaining staging directory exists')
asm=(ROOT/'engine/remaining_rom.asm').read_text(errors='replace')
if 'data/remaining/' in asm:
    raise SystemExit('[fail] engine/remaining_rom.asm still references data/remaining')
for marker in ['MobileDebug_RunHarness::','MobileDebug_UpdateState::','SECTION "Bank 02 Padding"']:
    if marker not in asm: raise SystemExit(f'[fail] missing Bank 02 diagnostic source marker: {marker}')
# Duplicated executable driver images must be source-generated, not binary assets.
copy_dir=ROOT/'audio/driver_copies'
expected=[f'music_driver_bank{x}.asm' for x in ('03','05','06','07','3e','3f')]+['sound_driver_bank09.asm']
for name in expected:
    if not (copy_dir/name).is_file(): raise SystemExit(f'[fail] missing source-generated driver copy: {name}')
# Key graphics families must use format-specific assets.
need=[
 'gfx/environment/battle_places/resources/layout_4d53.tilemap',
 'gfx/environment/battle_places/resources/attributes_4d6e.attrmap',
 'gfx/environment/battle_places/resources/graphics_4d89.2bpp',
 'gfx/environment/battle_places/resources/palette_4e59.pal',
 'gfx/attract/resources_bank23/scene1.tilemap',
 'gfx/attract/resources_bank23/scene1.attrmap',
 'gfx/attract/resources_bank23/scene1.2bpp',
 'gfx/attract/resources_bank23/scene1_pal_0.pal',
 'gfx/campaign/map_select/resources/campaign_map_select_page1_graphics.2bpp',
 'gfx/campaign/map_select/resources/campaign_map_select_page1_palettes.pal',
]
for rel in need:
    if not (ROOT/rel).is_file(): raise SystemExit(f'[fail] missing format-specific asset: {rel}')
print('Asset migration verification: PASS')
print(' generic .dat/.sound/.gfx/.bin assets: 0')
print(' duplicate audio drivers: source-generated ASM')
print(' battle/attract/campaign graphics: format-specific assets')
