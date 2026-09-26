#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re
import subprocess
import sys
import tempfile

root = Path(__file__).resolve().parents[1]
reader = (root / 'engine/home/home_campaign_briefing.asm').read_text()
payload = (root / 'data/campaign/campaign_intro_extension.asm').read_text()
runtime = (root / 'engine/map/map_briefing_runtime.asm').read_text()
symbols = (root / 'symbols.asm').read_text()
recover = root / 'tools/recover_campaign_intro_bank34.py'

EXPECTED_PTR = 0x4F3A
EXPECTED_LEN = 129
EXPECTED_SHA1 = '4fc4e5a0161d0b4fbc019ea9b8d8e19a555fa2e1'
CUSTOM_SHA1 = '2fd5074878763dbd00e6514f3856a6a466b999e9'

assert 'CampaignBriefing_PreMapRelocationTable' in reader
assert 'ld a, $34' in reader and 'ld a, $33' in reader
assert 'wMapBriefingTextBankState' in reader
assert 'cp $47' not in reader and 'db "NONE"' not in payload
assert 'section "Campaign Introduction Bank 34", romx[$4000], bank[$34]' in payload
assert 'CampaignIntroductionBank34::\nCampaignIntroductionBank34Payload::' in payload
assert 'assert CampaignIntroductionBank34End <= $7ef0' in payload
assert 'wMapBriefingTextBankState' in runtime
assert 'wMapBriefingTextBankState equ $c61c' in symbols

# the current source intentionally replaces the relocated Japanese bytes with English
# source, so the current source no longer requires active-payload byte identity. The
# authoritative custom ROM may still be supplied to prove the historical
# source pointer/stream that was relocated in the current source.
if len(sys.argv)>1:
    rom=Path(sys.argv[1]).read_bytes()
    if hashlib.sha1(rom).hexdigest()==CUSTOM_SHA1:
        table=0x25*0x4000+(0x405a-0x4000)
        ptr=int.from_bytes(rom[table:table+2],'little')
        assert ptr==EXPECTED_PTR, hex(ptr)
        start=0x33*0x4000+(ptr-0x4000)
        original=rom[start:start+EXPECTED_LEN]
        assert hashlib.sha1(original).hexdigest()==EXPECTED_SHA1

# Synthetic recovery test proves the tool reads the table from Bank $25 and
# the text from Bank $33, rather than the incorrect old Bank-$33 table model.
rom=bytearray([0xff])*0x100000
table=0x25*0x4000+(0x405a-0x4000)
rom[table:table+2]=(0x5000).to_bytes(2,'little')
start=0x33*0x4000+(0x5000-0x4000)
rom[start:start+6]=bytes([0xc1,0x01,0xd2,0xe3,0xf4,0x00])
with tempfile.TemporaryDirectory() as td:
    td=Path(td); fake=td/'custom.gbc'; out=td/'intro.asm'; fake.write_bytes(rom)
    p=subprocess.run([sys.executable,str(recover),str(fake),'--output',str(out)],cwd=root,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    assert p.returncode==0,p.stdout
    gen=out.read_text()
    assert '$c1' in gen and '$d2' in gen and '$e3' in gen and '$f4' in gen and 'done' in gen

print('[ok] the current source Bank $34 relocation architecture preserved (the current source text may differ intentionally)')
