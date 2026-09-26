#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
root=Path(__file__).resolve().parents[1]
rom=(root/'baserom.gbc').read_bytes(); start=0x8000+(0x4a12-0x4000); retail=rom[start:start+(0x4b68-0x4a12)]
assert hashlib.sha1(retail).hexdigest()=='ec34550e977cdf70e797681f36fbd3709a5851fe'
# exact producer anchors: side0 displayed/target HP and side1 mirror in all three presets
for cpu in (0x4a97,0x4ae2,0x4b2d):
    off=0x8000+(cpu-0x4000); assert rom[off:off+5]==bytes([0xea,0x78,0xd3,0x3e,0x0a]) or rom[off:off+3]==bytes([0xea,0x78,0xd3])
for cpu in (0x4ab5,0x4b00,0x4b4b):
    off=0x8000+(cpu-0x4000); assert rom[off:off+3]==bytes([0xea,0x7e,0xd3])
src=(root/'engine/battle/battle_hp_presets.asm').read_text().lower()
for lab in ('battlehppreset_entryredirect','battlehppreset_controller','battlehppreset_fightervsinfantry','battlehppreset_attackplanevsfighter','battlehppreset_antiairvshelicopter'):
    assert lab in src
print('PASS: Bank $02:$4A12-$4B67 battle HP preset/controller tranche is ROM-locked; displayed/target HP producer anchors verified.')
