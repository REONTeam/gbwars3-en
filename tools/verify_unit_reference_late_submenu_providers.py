from pathlib import Path
import hashlib, re

BASE = Path('baserom.gbc').read_bytes()
BUILT = Path('GBWARS3.gbc').read_bytes()
BANK = 0x25
RANGES = [
    (0x73C6, 0x74F0, 'weapon provider'),
    (0x752D, 0x758C, 'initiative provider'),
    (0x7625, 0x7783, 'load provider'),
    (0x781C, 0x7875, 'promotion provider'),
    (0x7917, 0x79F8, 'defense provider'),
    (0x7A19, 0x7F4D, 'resupply/repair provider'),
]

def bank_slice(blob, start, end):
    off = BANK * 0x4000 + (start - 0x4000)
    return blob[off:off + end - start]

for start, end, desc in RANGES:
    expected = bank_slice(BASE, start, end)
    actual = bank_slice(BUILT, start, end)
    assert actual == expected, f'{desc} differs from retail at ${start:04X}-${end-1:04X}'
    print(f'PASS ${start:04X}-${end-1:04X} {len(actual)} bytes SHA-1 {hashlib.sha1(actual).hexdigest()}')

ctl = Path('engine/unit/unit_reference_submenu_controllers.asm').read_text()
required = [
    'call UnitReference_DrawWeaponSubmenu',
    'call UnitReference_DrawInitiativeSubmenu',
    'call UnitReference_DrawLoadSubmenu',
    'call UnitReference_LoadProvider_7670',
    'call UnitReference_LoadProvider_7702',
    'call UnitReference_DrawPromotionSubmenu',
    'call UnitReference_DrawDefenseSubmenu',
    'call UnitReference_DrawResupplyRepairSubmenu',
    'call UnitReference_ResupplyRepairProvider_7C11',
    'call UnitReference_ResupplyRepairProvider_7DB4',
]
for item in required:
    assert item in ctl, item
for raw in ('$73c6', '$752d', '$7727', '$7670', '$7702', '$781c', '$7917', '$7dd9', '$7c11', '$7db4'):
    assert f'call {raw}' not in ctl, raw

provider_path = Path('engine/unit/unit_reference_late_submenu_providers.asm')
provider = provider_path.read_text().lower()
assert not re.search(r'^\s*db\s', provider, re.M), 'late provider still contains raw db lines'
for resource_addr in ('$74f0', '$758c', '$7783', '$7875', '$7f4d'):
    assert f'romx[{resource_addr}]' not in provider, resource_addr

sym = Path('GBWARS3.sym').read_text().lower()
labels = {
    'unitreference_drawweaponsubmenu': 0x73C6,
    'unitreference_drawinitiativesubmenu': 0x752D,
    'unitreference_loadprovider_7625': 0x7625,
    'unitreference_loadprovider_7670': 0x7670,
    'unitreference_loadprovider_7702': 0x7702,
    'unitreference_drawloadsubmenu': 0x7727,
    'unitreference_drawpromotionsubmenu': 0x781C,
    'unitreference_drawdefensesubmenu': 0x7917,
    'unitreference_resupplyrepairprovider_7a19': 0x7A19,
    'unitreference_resupplyrepairprovider_7c11': 0x7C11,
    'unitreference_resupplyrepairprovider_7db4': 0x7DB4,
    'unitreference_drawresupplyrepairsubmenu': 0x7DD9,
}
for name, addr in labels.items():
    marker = f'25:{addr:04x} {name}'
    assert marker in sym, marker

expected_hash = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
actual_hash = hashlib.sha256(BUILT).hexdigest()
assert actual_hash == expected_hash, actual_hash
print('PASS custom-English ROM SHA-256', actual_hash)
print('PASS Unit Reference late submenu providers')
