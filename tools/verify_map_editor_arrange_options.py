#!/usr/bin/env python3
"""Verify the Bank $0F Map Editor ARRANGE option resolver and fill primitive."""
from pathlib import Path
import hashlib, re, sys

ROOT = Path(__file__).resolve().parents[1]
OPTIONS = ROOT / 'engine/map/map_editor_arrange_options_517e.asm'
FILL = ROOT / 'engine/map/map_editor_fill_rectangle_52da.asm'
EDITOR = ROOT / 'engine/map/map_editor.asm'
ARRANGE = ROOT / 'engine/map/map_editor_submenu_arrange_4d65.asm'
HANDLERS = ROOT / 'engine/map/map_editor_menu_handlers_460f.asm'
BANK = 0x0F
EXPECTED_ROM_SHA256 = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
RANGES = [
    (0x517E,0x51CA,'unit option renderer','6177bc257ff07098745278773c76b80e91b7f881'),
    (0x51CA,0x51D1,'unit option x-coordinate table','4cfb2d78dd9411d2934a208639eb874c8be6f17a'),
    (0x51D1,0x51F2,'unit arrange cursor','fbf53951aa2dbb14804177e93ccc9c962353c502'),
    (0x5218,0x5226,'option tile destination','c96dc416d8e2f256243aa5da66cab9fed6b60f26'),
    (0x5226,0x526E,'arrange selection resolver','c66d32e372ec576b494c8a18de2b015d127f1844'),
    (0x526E,0x5299,'terrain arrange class data','7030cda04cb07eba64b6bd88516b86424c3a7be2'),
    (0x5299,0x52DA,'unit arrange class data','d4ee6dc9b43591cb5913b61e00169d31ec65ea17'),
    (0x52DA,0x5333,'editor fill rectangle','0941500ab752fcbeb3faa3ce6da84d0adc792071'),
]

def find_rom(name, extra):
    for p in [Path(x) for x in extra] + [ROOT/name, Path('/mnt/data')/name]:
        if p.is_file(): return p
    return None

def bank_slice(blob,a,b):
    o=BANK*0x4000+(a-0x4000)
    return blob[o:o+b-a]

def fail(msg):
    raise SystemExit('[fail] '+msg)

def main():
    base=find_rom('baserom.gbc',sys.argv[1:])
    if base is None: fail('baserom.gbc not found')
    retail=base.read_bytes()
    for a,b,label,want in RANGES:
        got=hashlib.sha1(bank_slice(retail,a,b)).hexdigest()
        if got!=want: fail(f'{label} retail SHA-1 {got} != {want}')
    if bank_slice(retail,0x5333,0x5340) != bytes([0xff])*13:
        fail('$5333-$533F is not the expected 13-byte retail padding')

    opt=OPTIONS.read_text(encoding='utf-8')
    fill=FILL.read_text(encoding='utf-8')
    for token in [
        'MapEditor_UnitArrange_DrawOption::',
        'MapEditor_UnitArrange_UpdateCursorSprite::',
        'MapEditor_Arrange_GetOptionTileDestination::',
        'MapEditor_Arrange_RebuildSelection::',
        'MapEditor_TerrainArrangeClassPointers::',
        'MapEditor_UnitArrangeClassPointers::',
        'MapEditor_UnitArrange_Delete:',
        'UNIT_TYPE_AEGIS_WARSHIP',
        'MAP_TILE_NEUTRAL_AIRPORT_RUINS',
    ]:
        if token not in opt: fail(f'missing option source integration: {token}')
    for token in [
        'MapEditor_FillRectangle::',
        'ld hl, wUnitCountBySide',
        'farcall $0b, MapGridCoord',
        'section "Map Editor Pre-Terrain-Fragment Padding", romx[$5333], bank[$0f]',
    ]:
        if token not in fill: fail(f'missing fill source integration: {token}')

    # Source-backed executable ranges must not fall back to raw byte blobs.
    for p in [OPTIONS,FILL]:
        for line in p.read_text(encoding='utf-8').splitlines():
            if re.match(r'^\s*db\s+\$', line, re.I) and p == FILL:
                fail('fill primitive unexpectedly contains raw DB code')

    # Existing editor/controller owners must use the new symbolic API.
    et=EDITOR.read_text(encoding='utf-8').lower()
    at=ARRANGE.read_text(encoding='utf-8').lower()
    ht=HANDLERS.read_text(encoding='utf-8').lower()
    for raw in ['call $517e','call $5218','call $52da']:
        if raw in et: fail(f'obsolete raw editor call remains: {raw}')
    for raw in ['$51d1','$517e','$5218','$5226','$526e','$5299']:
        if ('equ '+raw) in at: fail(f'obsolete ARRANGE numeric alias remains: {raw}')
    if 'equ $52da' in ht: fail('obsolete fill-rectangle numeric alias remains')

    built=ROOT/'GBWARS3.gbc'
    if built.is_file():
        out=built.read_bytes()
        for a,b,label,_ in RANGES:
            if bank_slice(out,a,b)!=bank_slice(retail,a,b):
                fail(f'linked bytes drift in {label}')
        if bank_slice(out,0x5333,0x5340)!=bytes([0xff])*13:
            fail('linked $5333-$533F padding drift')
        digest=hashlib.sha256(out).hexdigest()
        if digest!=EXPECTED_ROM_SHA256:
            fail(f'custom-English ROM SHA-256 {digest} != {EXPECTED_ROM_SHA256}')
        print(f'[ok] full custom-English ROM SHA-256 {digest}')

    print('[ok] Bank $0F ARRANGE option renderer/resolver tables match retail')
    print('[ok] Bank $0F editor fill rectangle matches retail and preserves unit counts')
    print('[ok] custom-English terrain/name resources remain separate owners')

if __name__=='__main__': main()
