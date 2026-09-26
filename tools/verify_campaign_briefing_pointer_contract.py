#!/usr/bin/env python3
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
src = (ROOT / 'data/campaign/campaign_briefing_pointers.asm').read_text()
viewer = (ROOT / 'engine/map/map_briefing_runtime.asm').read_text()
mk = (ROOT / 'Makefile').read_text()
doc = (ROOT / 'docs/campaign/campaign_briefing_pointer_contract.md').read_text()
expected = {
    'CampaignBriefing_ResultBPointerTable': ('$4000', '$25'),
    'CampaignBriefing_PreMapPointerTable': ('$405a', '$25'),
    'CampaignBriefing_ResultAPointerTable': ('$40b6', '$25'),
}
for label, (addr, bank) in expected.items():
    pat = rf'section\s+"[^"]+",\s*romx\[{re.escape(addr)}\],\s*bank\[{re.escape(bank)}\]\s*\n{label}::'
    if not re.search(pat, src, re.I):
        raise SystemExit(f'missing table {label} at {bank}:{addr}')
for label in expected:
    if f'dw {label}' not in viewer:
        raise SystemExit(f'viewer does not reference {label}')
if re.search(r'^\s*dw\s+\$', src, re.M):
    raise SystemExit('Campaign briefing pointer tables must use symbolic targets, not raw addresses')
if mk.count('engine/map/map_briefing_runtime.o') != 1:
    raise SystemExit('map_briefing_runtime.o must appear once')
if mk.count('data/campaign/campaign_briefing_pointers.o') != 1:
    raise SystemExit('campaign_briefing_pointers.o must appear once')
if mk.count('data/campaign/campaign_briefing_text_bank33.o') != 1:
    raise SystemExit('campaign_briefing_text_bank33.o must appear once')
for phrase in ('Bank `$25`', 'Bank `$33`', '$25:$405A -> $33:$4F3A', '45 / 46 / 45'):
    if phrase.lower() not in doc.lower():
        raise SystemExit(f'documentation missing {phrase}')
# Verify the three table geometries directly from the maintained source.
def table_entries(label, end_label=None):
    start = src.index(label + '::')
    if end_label:
        end = src.index(end_label + '::', start)
    else:
        end = len(src)
    return re.findall(r'^\s*dw\s+(CampaignBriefing_[A-Za-z0-9_]+)\s*$', src[start:end], re.M)

result_b = table_entries('CampaignBriefing_ResultBPointerTable', 'CampaignBriefing_PreMapPointerTable')
pre_map = table_entries('CampaignBriefing_PreMapPointerTable', 'CampaignBriefing_ResultAPointerTable')
result_a = table_entries('CampaignBriefing_ResultAPointerTable')
if (len(result_b), len(pre_map), len(result_a)) != (45, 46, 45):
    raise SystemExit(f'unexpected Campaign pointer-table geometry: {(len(result_b), len(pre_map), len(result_a))}')
if result_b != [f'CampaignBriefing_ResultB_{i:02d}' for i in range(45)]:
    raise SystemExit('Result-B pointer order mismatch')
if pre_map != [f'CampaignBriefing_PreMap_{i:02d}' for i in range(45)] + ['CampaignBriefing_PreMap_Extra45']:
    raise SystemExit('Pre-Map pointer order mismatch')
if result_a != [f'CampaignBriefing_ResultA_{i:02d}' for i in range(45)]:
    raise SystemExit('Result-A pointer order mismatch')
print('[ok] Campaign briefing pointer-table contract is fully symbolic in Bank $25 and targets source-backed Bank $33 streams')
