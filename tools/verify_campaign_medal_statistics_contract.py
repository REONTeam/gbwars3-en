#!/usr/bin/env python3
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
s = (ROOT / 'symbols.asm').read_text().lower()
d = (ROOT / 'docs/campaign/campaign_medal_statistics_contract.md').read_text()
for text in [
    'wcampaignprocuredunitflags equ $c77d',
    'wcampaignmapclearcounts equ $c784',
]:
    assert text in s, text
for stale in [
    'sym $18, $4a12, campaignmedals_checkmasterandsuperprize',
    'sym $18, $4a59, campaignmedals_checkcategorymedals',
    'sym $18, $4b28, campaignmedals_checkallunitmedal',
    'sym $18, $4bd3, campaignmedals_setjustobtainedflag',
    'sym $18, $4d3f, campaignstats_markprocuredunit',
]:
    assert stale not in s, stale
assert 0xc77d - 0xc770 == 13
assert 0xc784 - 0xc77d == 7
assert 0xc7b1 - 0xc784 == 45
assert '$C770-$C771' in d and 'seven-byte procured-unit bitfield' in d
assert '55 or more' in d
assert 'physical Bank `$11`' in d and 'not Bank `$18`' in d
print('[ok] campaign medal/statistics contract: $C770-$C7B0 geometry + corrected physical Bank $11 ownership')
