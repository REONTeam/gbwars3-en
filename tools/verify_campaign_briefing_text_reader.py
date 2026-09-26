#!/usr/bin/env python3
import sys, hashlib
from pathlib import Path
rom=Path(sys.argv[1]).read_bytes()
start,end=0x26b7,0x26cb
want=bytes.fromhex('fa25c06ffa26c0672a477dea25c07cea26c078c9')
got=rom[start:end]
assert got == want, (got.hex(), want.hex())
src=Path('engine/home/home_banked_text.asm').read_text()
for token in ['BankedText_ReadByteAndAdvance::','rom0[$26b7]','assert @ == $26cb']:
    assert token in src, token
viewer=Path('engine/map/map_briefing_runtime.asm').read_text()
assert 'call CampaignBriefing_ReadByte' in viewer
assert 'call BankedText_ReadByteAndAdvance' in Path('engine/home/home_campaign_briefing.asm').read_text()
assert 'call BankedText_ReadByteAndAdvance' in viewer
anchors=Path('data/campaign/campaign_briefing_pointers.asm').read_text()
# preservation: anchors must still emit no db/dw/ds payload
for line in anchors.splitlines():
    t=line.strip().lower()
    assert not t.startswith(('db ','dw ','ds ')), 'Campaign anchor unexpectedly emits bytes: '+line
print(f'PASS: ROM0 $26B7-$26CA banked text reader ({len(got)} bytes), SHA-1 {hashlib.sha1(got).hexdigest()}')
