#!/usr/bin/env python3
import csv, sys, hashlib
from pathlib import Path
from PIL import Image
rom=Path(sys.argv[1]).read_bytes(); root=Path('gfx/environment/battle_places')
rows=list(csv.DictReader((root/'runtime_windows/map_tile_records.csv').open()))
by={}
for r in rows: by.setdefault(r['graphics_window_ptr'].upper(),[]).append(r)
man=list(csv.DictReader((root/'unique_windows/manifest.csv').open()))
assert len(by)==24, len(by); assert len(man)==24, len(man)
mm={r['graphics_window_ptr']:r for r in man}
for ptr,rs in by.items():
    assert ptr in mm
    cpu=int(ptr,16); off=0x17*0x4000+(cpu-0x4000); data=rom[off:off+0x160]
    assert len(data)==0x160
    assert hashlib.sha1(data).hexdigest()==mm[ptr]['sha1']
    im=Image.open(root/'unique_windows'/mm[ptr]['filename'])
    assert im.size==(88,16)
print('PASS: 24 unique Bank $17 battle-place loader windows, each $160 bytes / 22 tiles')
