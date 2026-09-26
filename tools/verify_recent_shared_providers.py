from pathlib import Path
import hashlib

EXPECTED = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
retail=Path('baserom.gbc').read_bytes(); built=Path('GBWARS3.gbc').read_bytes()

def chk(bank,s,e,name):
    o=bank*0x4000+s-0x4000
    assert built[o:o+e-s] == retail[o:o+e-s], name
    print(f'PASS {name} {bank:02X}:{s:04X}-{e-1:04X} ({e-s} bytes)')

chk(0x14,0x5f1b,0x5f29,'Math_DivideAByB')
chk(0x27,0x6ae6,0x6b1a,'Versus_DrawStyleDescription')

sym=Path('GBWARS3.sym').read_text().lower()
assert '14:5f1b math_divideabyb' in sym
assert '27:6ae6 versus_drawstyledescription' in sym
assert '27:6b1a versus_menu_type_description' in sym
assert '27:6b31 versus_menu_type_description_infrared' in sym

result=Path('engine/map/map_result_presentation_bank27.asm').read_text().lower()
assert result.count('farcall $14, math_divideabyb') == 2
assert 'farcall $14,$5f1b' not in result and 'farcall $14, $5f1b' not in result
style=Path('engine/versus/versus_style_country_runtime.asm').read_text().lower()
assert style.count('farcall $27, versus_drawstyledescription') == 2
assert 'farcall $27, $6ae6' not in style

h=hashlib.sha256(built).hexdigest(); assert h==EXPECTED,h
print('PASS symbolic callers')
print('PASS custom-English SHA-256',h)
