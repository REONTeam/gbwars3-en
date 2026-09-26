#!/usr/bin/env python3
from pathlib import Path
root=Path(__file__).resolve().parents[1]
reader=(root/'engine/home/home_campaign_briefing.asm').read_text()
payload=(root/'data/campaign/campaign_intro_extension.asm').read_text()
runtime=(root/'engine/map/map_briefing_runtime.asm').read_text()
symbols=(root/'symbols.asm').read_text()
assert 'CampaignBriefing_ReadByte::' in reader
assert 'CampaignBriefing_PreMapRelocationTable' in reader
assert 'ld a, $34' in reader and 'ld a, $33' in reader
assert 'wMapBriefingTextBankState' in reader and 'wMapBriefingTextBankState' in runtime
assert 'wMapBriefingIntroExtensionActive equ wMapBriefingTextBankState' in symbols
assert 'section "Campaign Introduction Bank 34", romx[$4000], bank[$34]' in payload
assert 'CampaignIntroductionExtension equ CampaignIntroductionBank34Payload' in payload
assert 'db "NONE"' not in payload
assert payload.count('_Bank34::') == 129
assert 'CampaignBriefing_ResultB_00_Bank34::' in payload
assert 'CampaignBriefing_PreMap_Extra45_Bank34::' in payload
assert 'CampaignBriefing_ResultA_44_Bank34::' in payload
print('[ok] campaign_intro_extension.asm contains the complete Bank $34 Campaign extension')
