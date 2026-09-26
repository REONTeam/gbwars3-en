#!/usr/bin/env python3
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
src = (root / 'data/campaign/campaign_briefing_text_bank33.asm').read_text(encoding='utf-8')
copy = (root / 'data/campaign/campaign_intro_extension.asm').read_text(encoding='utf-8')
rel = (root / 'data/campaign/campaign_briefing_relocations.asm').read_text(encoding='utf-8')
charmap_text = (root / 'charmaps/char_main.inc').read_text(encoding='utf-8')

# Build the source-text encoder used by the Campaign extension. The campaign
# strings do not use the duplicate ASCII/special-X or quote mappings in the
# main charmap, so every character present here maps unambiguously.
char_to_byte = {}
for line in charmap_text.splitlines():
    m = re.match(r'\s*charmap\s+"((?:\\.|[^"])*)",\s*\$([0-9a-fA-F]{2})', line)
    if not m:
        continue
    token = m.group(1).replace('\\"', '"').replace('\\\\', '\\')
    char_to_byte[token] = int(m.group(2), 16)

def historical_payloads(text):
    matches = list(re.finditer(r'^(CampaignBriefing_(?:ResultB|PreMap|ResultA)_[A-Za-z0-9]+)::\s*$', text, re.M))
    out = {}
    for i, m in enumerate(matches):
        end = matches[i + 1].start() if i + 1 < len(matches) else len(text)
        block = text[m.end():end]
        vals = []
        for line in re.findall(r'^\s*db\s+(.+)$', block, re.M):
            vals.extend(int(x, 16) for x in re.findall(r'\$([0-9a-fA-F]{2})', line))
        out[m.group(1)] = bytes(vals)
    return out

def relocated_plaintext_payloads(text):
    matches = list(re.finditer(r'^(CampaignBriefing_(?:ResultB|PreMap|ResultA)_[A-Za-z0-9]+)_Bank34::\s*$', text, re.M))
    out = {}
    for i, m in enumerate(matches):
        end = matches[i + 1].start() if i + 1 < len(matches) else text.index('CampaignBriefing_Bank34JapaneseEnd::', m.end())
        block = text[m.end():end]
        vals = []
        for line in block.splitlines():
            mm = re.match(r'\s*(text|line)\s+"((?:\\.|[^"])*)"\s*$', line)
            if mm:
                kind, raw = mm.groups()
                raw = raw.replace('\\"', '"').replace('\\\\', '\\')
                if kind == 'line':
                    vals.append(0x01)
                for ch in raw:
                    if ch not in char_to_byte:
                        raise AssertionError(f'unmapped character {ch!r} in {m.group(1)}')
                    vals.append(char_to_byte[ch])
                continue
            if re.match(r'\s*done\s*$', line):
                vals.append(0x00)
        out[m.group(1)] = bytes(vals)
    return out

historical = historical_payloads(src)
relocated = relocated_plaintext_payloads(copy)
assert len(historical) == 136, len(historical)
english = {
    'CampaignBriefing_PreMap_00': 'CampaignIntroductionBank34Payload',
    'CampaignBriefing_PreMap_01': 'CampaignBriefing_PreMap_01_English',
    'CampaignBriefing_PreMap_02': 'CampaignBriefing_PreMap_02_English',
    'CampaignBriefing_ResultA_00': 'CampaignBriefing_ResultA_00_English',
    'CampaignBriefing_ResultA_01': 'CampaignBriefing_ResultA_01_English',
    'CampaignBriefing_ResultA_02': 'CampaignBriefing_ResultA_02_English',
    'CampaignBriefing_ResultB_02': 'CampaignBriefing_ResultB_02_English',
}
for label, data in historical.items():
    target = english.get(label, label + '_Bank34')
    assert re.search(r'^\s*dw\s+' + re.escape(target) + r'(?:\s|;|$)', rel, re.M), (label, target)
    if label not in english:
        assert label in relocated, label
        assert relocated[label] == data, label
assert len(relocated) == 129, len(relocated)
assert not re.search(r'^\s*dw\s+0\b', rel, re.M)
assert 'CampaignBriefing_Bank34JapaneseEnd <= $7ef0' in copy
assert copy.count('_Bank34::') == 129
japanese_section = copy[copy.index('section "Campaign Briefing Japanese Bank 34"'):copy.index('CampaignBriefing_Bank34JapaneseEnd::')]
assert not re.search(r'^\s*db\s+\$', japanese_section, re.M), 'Japanese extension still contains raw hex byte streams'
assert japanese_section.count('done') == 129
print('[ok] all 136 Campaign entries resolve through Bank $34; 129 Japanese plaintext sources re-encode byte-identically')
