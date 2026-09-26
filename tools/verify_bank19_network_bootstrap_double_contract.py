#!/usr/bin/env python3
from pathlib import Path
import hashlib, sys
ROM = Path('baserom.gbc')
if not ROM.exists():
    raise SystemExit('baserom.gbc is required')
rom = ROM.read_bytes()
def bank_slice(bank,start,end):
    off=(bank-1)*0x4000+start
    return rom[off:off+end-start+1]
checks=[
    ('Network persistent reset/init',0x19,0x7059,0x7141,'cc4c8ab53ffe77deba6abf5a9b29524e9cdd3baa'),
    ('Network bootstrap/mobile menu',0x19,0x7142,0x720b,'fe6a86be0c5f28d658fbbabb268a26bfdda98bd0'),
]
for name,b,a,z,want in checks:
    data=bank_slice(b,a,z); got=hashlib.sha1(data).hexdigest()
    if got != want:
        raise SystemExit(f'FAIL {name}: {got} != {want}')
    print(f'PASS {name}: {len(data)} bytes SHA-1 {got}')
src=Path('engine/network/bank19_network_persistent_init.asm').read_text()
for token in ['NetworkPersistent_ResetAndInitialize::','NetworkUI_CopyBootstrapResource::','NetworkUI_InitializeMobileMenu::','NetworkUI_DrawMobileMenuPanels::','Image_Mobile_Menu_LeadingTile::','assert @ == $720c']:
    if token not in src: raise SystemExit(f'FAIL missing source token {token}')
print('PASS source boundary/symbol audit')
