#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys

retail = Path(sys.argv[1] if len(sys.argv) > 1 else 'baserom.gbc').read_bytes()
out = Path(sys.argv[2] if len(sys.argv) > 2 else 'GBWARS3.gbc').read_bytes()

def off(bank, addr):
    return bank * 0x4000 + (addr - 0x4000)

# $76E2-$76F1: one blank 2bpp tile, source-backed now.
blank = retail[off(0x15, 0x76e2):off(0x15, 0x76f2)]
assert blank == bytes(16), 'retail map-selection blank tile is not zero-filled'
assert out[off(0x15, 0x76e2):off(0x15, 0x76f2)] == blank

# $76F2-$7941: existing custom-English graphic remains authoritative.
img = Path('gfx/ui/vs_menu_type.2bpp').read_bytes()
assert len(img) == 0x250
assert out[off(0x15, 0x76f2):off(0x15, 0x7942)] == img, 'custom VS/map-selection image drifted'

# $7942-$7981: eight 4-color CGB palettes, identical to retail.
pals_r = retail[off(0x15, 0x7942):off(0x15, 0x7982)]
pals_o = out[off(0x15, 0x7942):off(0x15, 0x7982)]
assert len(pals_r) == 0x40
assert pals_r == pals_o, 'Bank $15 map-selection palettes differ from retail'
assert hashlib.sha1(pals_r).hexdigest() == 'b716fe7e4fa60486a1732d834343438f727a7af5'

# Retail $7982-$79FF is padding. $7A00+ is intentionally custom relocation space.
pad = retail[off(0x15, 0x7982):off(0x15, 0x7a00)]
assert pad == bytes([0xff]) * 0x7e
assert out[off(0x15, 0x7982):off(0x15, 0x7a00)] == pad

src = Path('data/gfx/graphics.asm').read_text()
for needle in [
    'Image_MapSelection_BlankTile::',
    'Image_VS_Menu_Type::',
    'Pals_MapSelection::',
    'section "Bank 15 Retail Padding Before Custom Text", romx[$7982], bank[$15]',
    'ds $7a00 - @, $ff',
]:
    assert needle in src, needle

runtime = Path('engine/map/map_selection_runtime_bank15.asm').read_text()
assert 'ld de, Image_MapSelection_BlankTile' in runtime
assert 'ld hl, Pals_MapSelection' in runtime
assert 'ld de, $76e2' not in runtime
assert 'ld hl, $7942' not in runtime
versus = Path('engine/versus/versus_style_country_runtime.asm').read_text()
assert 'ld hl, Pals_MapSelection' in versus

main_menu = Path('engine/ui/main_menu.asm').read_text()
assert 'section fragment "bank15_end", romx[bank15_end_addr], bank[$15]' in main_menu
assert 'MainMenu_Desc_Network:' in main_menu

mk = Path('Makefile').read_text()
objs = re.findall(r'\b([\w/.-]+\.o)\b', mk.split('graphics :=', 1)[0])
assert len(objs) == len(set(objs))
for obj in objs:
    assert Path(obj[:-2] + '.asm').exists(), obj

expected = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
actual = hashlib.sha256(out).hexdigest()
assert actual == expected, (actual, expected)

print('PASS: Bank $15:$76E2-$76F1 blank map-selection tile is source-backed')
print('PASS: Bank $15:$76F2-$7941 custom English VS/map-selection image is preserved')
print('PASS: Bank $15:$7942-$7981 eight-palette block is byte-exact to retail')
print('PASS: Bank $15:$7982-$79FF retail padding is explicit; $7A00+ remains custom relocation/free space')
print(f'PASS: Makefile object/source audit {len(objs)} / {len(objs)}')
print('PASS: rebuilt custom ROM SHA-256', actual)
