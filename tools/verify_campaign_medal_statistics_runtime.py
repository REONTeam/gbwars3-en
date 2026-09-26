#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1]).read_bytes()
src=(ROOT/'engine/campaign/campaign_medal_statistics_runtime.asm').read_text()
ranges=[
(0x4A12,0x4A43,'CampaignMedals_CheckMasterAndSuperPrize','957f1d05498a25a3e298ad632d8dc9fa222dfb40'),
(0x4A59,0x4B27,'CampaignMedals_CheckCategoryMedals','5a1b8ebcc629d34d4a38bfb0c32e51b18ddce29c'),
(0x4B28,0x4B40,'CampaignMedals_CheckAllUnitMedal','5f8c498473f1a18279be65b815541aebf9f3389e'),
(0x4BD3,0x4BD9,'CampaignMedals_SetJustObtainedFlag','eec59d5f8fca2f6ba68fac2a1298f5461f7df4f6'),
(0x4D3F,0x4D59,'CampaignStats_MarkProcuredUnit','563382b08fed6fa40c53cf6c4c053314d20b230d'),
]
# reconstruct source byte rows by section
for a,b,label,sha in ranges:
    off=0x11*0x4000+(a-0x4000); retail=rom[off:off+b-a+1]
    assert hashlib.sha1(retail).hexdigest()==sha
    m=re.search(rf'{label}::(.*?)(?=\nsection |\Z)',src,re.S); assert m,label
    vals=[]
    for line in m.group(1).splitlines():
        body=line.split(';',1)[0]
        if 'db ' in body:
            vals += [int(x[1:],16) for x in re.findall(r'\$[0-9a-fA-F]{2}',body)]
    assert bytes(vals)==retail,(label,len(vals),len(retail))
# retail caller proves physical bank: UnitPromotion_Apply farcall = EF 11 3F 4D
assert bytes.fromhex('ef113f4d') in rom[0x12*0x4000+(0x43f4-0x4000):0x12*0x4000+(0x450a-0x4000)]
symbols=(ROOT/'symbols.asm').read_text().lower()
assert 'sym $18, $4d3f, campaignstats_markprocuredunit' not in symbols
print('[ok] campaign medal/statistics runtime: physical Bank $11, five ROM-locked ranges')
for a,b,label,sha in ranges: print(f'[ok] ${a:04X}-${b:04X} {label}: {b-a+1} bytes {sha}')
