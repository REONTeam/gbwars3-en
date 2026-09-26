#!/usr/bin/env python3
"""Verify the source-backed Bank $0F editor submenu/ARRANGE runtime."""
from pathlib import Path
import hashlib, re, sys

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'engine/map/map_editor_submenu_arrange_4d65.asm'
HANDLERS = ROOT / 'engine/map/map_editor_menu_handlers_460f.asm'
INTERACTION = ROOT / 'engine/map/map_editor_interaction_runtime_4170.asm'
EDITOR = ROOT / 'engine/map/map_editor.asm'
TERRAIN = ROOT / 'data/terrain.asm'
BANK = 0x0F
RANGES = [
    (0x4D65,0x4EEA,'submenu value/cursor + terrain arrange controller','040a4ae2864da298a0cd5bff34f60922820f777b'),
    (0x4EF1,0x4F90,'terrain arrange presentation','5391880058817c2885887ff8a91331d73ae415ec'),
    (0x502B,0x50EC,'unit arrange controller','18c6f5aba2a28bb8a4cf87e64299b2e7e6cd5648'),
]
EXPECTED_ROM_SHA256='e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'

def find_rom(name, extra):
    for p in [Path(x) for x in extra] + [ROOT/name, Path('/mnt/data')/name]:
        if p.is_file(): return p
    return None

def bank_slice(blob,a,b):
    o=BANK*0x4000+(a-0x4000)
    return blob[o:o+b-a]

def main():
    base = find_rom('baserom.gbc', sys.argv[1:])
    if base is None: raise SystemExit('[fail] baserom.gbc not found')
    retail=base.read_bytes()
    for a,b,label,want in RANGES:
        got=hashlib.sha1(bank_slice(retail,a,b)).hexdigest()
        if got!=want: raise SystemExit(f'[fail] {label} retail SHA-1 {got} != {want}')

    text=SRC.read_text(encoding='utf-8')
    for token in [
        'MapEditor_DrawSubmenuValues::','MapEditor_UpdateSubmenuSelection::',
        'MapEditor_InitializeSubmenuSelection::','MapEditor_RunArrangeSelectionController::',
        'MapEditor_Arrange_DrawOption::','MapEditor_Arrange_UpdateCursorSprite::',
        'MapEditor_Arrange_RedrawSelection::','MapEditor_RunUnitArrangeController::',
        'ld hl, Terrain_Name_Strings',
    ]:
        if token not in text: raise SystemExit(f'[fail] missing source integration: {token}')
    # Raw DB is allowed only for the two proven inline tables in this module.
    db_lines=[ln.strip() for ln in text.splitlines() if re.match(r'^\s*db\b',ln,re.I)]
    if db_lines != [
        'db $ff, $0a, $0c, $0c',
        'db $80, $80, $80, $80, $00',
        'db $81, $81, $00',
        'db $80, $80, $00',
        'db $05, $06, $03, $03, $ff, $ff, $ff, $ff, $08, $03',
    ]:
        raise SystemExit(f'[fail] unexpected raw DB declarations in editor runtime: {db_lines}')

    for p, raw in [(HANDLERS,'$4d65'),(HANDLERS,'$4dcf'),(HANDLERS,'$4de2'),(INTERACTION,'$4e04')]:
        if raw in p.read_text(encoding='utf-8').lower():
            raise SystemExit(f'[fail] obsolete raw editor service address remains in {p.name}: {raw}')
    if 'Terrain_Name_Strings::' not in TERRAIN.read_text(encoding='utf-8'):
        raise SystemExit('[fail] authoritative custom-English Terrain_Name_Strings is not exported')
    if 'EditorSubmenu_Map_Label::' not in EDITOR.read_text(encoding='utf-8'):
        raise SystemExit('[fail] editor MAP label is not exported for arrange panel')

    built=ROOT/'GBWARS3.gbc'
    if built.is_file():
        out=built.read_bytes()
        for a,b,label,_ in RANGES:
            if bank_slice(out,a,b)!=bank_slice(retail,a,b):
                raise SystemExit(f'[fail] linked bytes drift in {label}')
        digest=hashlib.sha256(out).hexdigest()
        if digest!=EXPECTED_ROM_SHA256:
            raise SystemExit(f'[fail] custom-English ROM SHA-256 {digest} != {EXPECTED_ROM_SHA256}')
        print(f'[ok] full custom-English ROM SHA-256 {digest}')

    print('[ok] Bank $0F submenu/ARRANGE source ranges match retail fingerprints')
    print('[ok] custom-English Terrain_Name_Strings remains the authoritative name resource')
    print('[ok] raw $4D65/$4DCF/$4DE2/$4E04 service aliases are eliminated')

if __name__=='__main__': main()
