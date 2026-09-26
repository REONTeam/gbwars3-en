#!/usr/bin/env python3
from pathlib import Path
import csv, hashlib, re, struct
ROOT=Path(__file__).resolve().parents[1]
rom=(ROOT/'baserom.gbc').read_bytes(); base=0x17*0x4000
src=(ROOT/'engine/battle/battle_place_graphics.asm').read_text()
# Exact ROM tranches.
meta_raw=rom[base+0x6f03-0x4000:base+0x7000-0x4000]
anim_raw=rom[base+0x7000-0x4000:base+0x70dd-0x4000]
ptr_raw=rom[base+0x70dd-0x4000:base+0x7133-0x4000]
assert len(meta_raw)==0xfd and hashlib.sha1(meta_raw).hexdigest()=='d03e427ab3bf817ff9f3ad196bab28d5d0dae018'
assert len(anim_raw)==0xdd and hashlib.sha1(anim_raw).hexdigest()=='6da22ffc92946e2cb9fe12bc430120574bdde884'
assert len(ptr_raw)==86 and hashlib.sha1(ptr_raw).hexdigest()=='5989a7735484ad5e274fc68b245070afc92749b8'
# Parse and reconstruct metasprites from source.
block=src.split('section "Battle Place Metasprites"',1)[1].split('BattlePlaceMetasprites_End::',1)[0]
records=[]
for m in re.finditer(r'BattlePlaceMetasprite_([0-9A-F]{4})::\n\s+db (\d+)\n((?:\s+battle_place_oam[^\n]+\n)+)',block,re.I):
    addr=int(m.group(1),16); count=int(m.group(2)); ents=[]
    for line in re.findall(r'battle_place_oam \$([0-9a-f]{2}), \$([0-9a-f]{2}), \$([0-9a-f]{2}), \$([0-9a-f]{2})',m.group(3),re.I):
        ents.extend(int(x,16) for x in line)
    assert len(ents)==count*4
    records.append((addr,bytes([count,*ents])))
assert len(records)==45
rebuilt=b''.join(d for _,d in records); assert rebuilt==meta_raw
for (addr,d),(naddr,_) in zip(records,records[1:]): assert addr+len(d)==naddr
assert records[0][0]==0x6f03 and records[-1][0]+len(records[-1][1])==0x7000
# CSV matches metasprite source/ROM.
with (ROOT/'gfx/environment/battle_places/metasprites.csv').open() as f: mr=list(csv.DictReader(f))
assert len(mr)==45
for rec,(addr,d) in zip(mr,records):
    assert int(rec['address'],16)==addr and int(rec['entry_count'])==d[0]
    assert int(rec['size_bytes'])==len(d) and rec['sha1']==hashlib.sha1(d).hexdigest()
# Parse animation scripts from ROM pointer table and compare source labels/macros.
ptrs=list(struct.unpack('<43H',ptr_raw)); assert len(set(ptrs))==43
scripts=[]
for p in ptrs:
    q=p; frames=[]
    while True:
        mp=rom[base+q-0x4000]|rom[base+q-0x4000+1]<<8; q+=2
        if mp==0: break
        dur=rom[base+q-0x4000]; q+=1; frames.append((mp,dur))
    scripts.append((p,q,frames))
assert sum(1 for _,_,f in scripts if len(f)>1)==1
special=[x for x in scripts if len(x[2])>1][0]
assert special[0]==0x70c8 and special[2]==[(0x6fe7,6),(0x6fec,5),(0x6ff1,4)]
for p,q,frames in scripts:
    pat=rf'BattlePlaceAnim_{p:04X}::\n(.*?)(?=BattlePlaceAnim_[0-9A-F]{{4}}::|BattlePlaceAnimationScripts_End::)'
    m=re.search(pat,src,re.S|re.I); assert m,p
    sf=[(int(a,16),int(d)) for a,d in re.findall(r'battle_place_anim_frame BattlePlaceMetasprite_([0-9A-F]{4}), (\d+)',m.group(1),re.I)]
    assert sf==frames,(hex(p),sf,frames)
    assert 'battle_place_anim_end' in m.group(1)
with (ROOT/'gfx/environment/battle_places/animation_scripts.csv').open() as f: ar=list(csv.DictReader(f))
assert len(ar)==43
for rec,(p,q,frames) in zip(ar,scripts):
    raw=rom[base+p-0x4000:base+q-0x4000]
    assert int(rec['address'],16)==p and int(rec['frame_count'])==len(frames)
    assert int(rec['size_bytes'])==len(raw) and rec['sha1']==hashlib.sha1(raw).hexdigest()
# Pointer table source order matches ROM.
sblock=src.split('BattlePlaceAnimationPointers::',1)[1].split('BattlePlaceAnimationPointers_End::',1)[0]
sptrs=[int(x,16) for x in re.findall(r'dw BattlePlaceAnim_([0-9A-F]{4})',sblock,re.I)]
assert sptrs==ptrs
# Corrected current source accessor boundary: a retail RET at $477D and callable CP 0 at $477E.
access=rom[base+0x477d-0x4000:base+0x47cb-0x4000]
assert access[0]==0xc9 and access[1:3]==b'\xfe\x00'
assert 'BattlePlaceAnimationPointerAccess_PreviousReturn::\n    ret\n\nBattlePlace_SelectAnimationPointer:: ; callable entry at $477E\n    cp 0' in src
print('[ok] Bank $17:$6F03-$6FFF: 45 count-prefixed metasprites / 253 bytes source-reconstructed')
print('[ok] Bank $17:$7000-$70DC: 43 animation scripts; $70C8 is the 3-frame 6/5/4-duration exception')
print('[ok] Bank $17:$70DD-$7132: 43-entry animation-script pointer table source-reconstructed')
print('[ok] the current source accessor boundary corrected: $477D RET, callable animation selector starts at $477E')
