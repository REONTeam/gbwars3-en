#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import re, sys
ROOT=Path(__file__).resolve().parents[1]
ROM=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
rom=ROM.read_bytes()
ranges=[
 (0x0B,0x489C,0x4941,'Unit terrain development executor','96594120b685b3b779676db73c57bead03729c45'),
 (0x0B,0x7D54,0x7D83,'Terrain development predicates','0b91f0add1cb896c57443f96d1471d0b36ed94c8'),
 (0x11,0x4D5A,0x4D74,'Campaign property counters','11b6d3abe94ae241c315e203fb769fa857ef0ad6'),
 (0x0C,0x6F70,0x7078,'AI service target builders','2c9dc637ccf6185d4bd91a737b2c9b784d0bfcaa'),
]
for bank,start,end,name,want in ranges:
    off=bank*0x4000+(start-0x4000)
    data=rom[off:off+end-start]
    got=sha1(data).hexdigest()
    assert len(data)==end-start and got==want,(name,len(data),got)
    print(f'[ok] {name}: Bank ${bank:02X}:${start:04X}-${end-1:04X}, {len(data)} bytes, SHA-1 {got}')

dev=(ROOT/'engine/unit/unit_development_action.asm').read_text()
svc=(ROOT/'engine/map/ai/map_ai_service_targets.asm').read_text()
disp=(ROOT/'engine/map/ai/map_ai_action_dispatch.asm').read_text()
actions=(ROOT/'engine/map/ai/map_ai_actions.asm').read_text()
stats=(ROOT/'engine/campaign/campaign_medal_statistics_runtime.asm').read_text()
consts=(ROOT/'constants/map_constants.inc').read_text()
for label in ['Unit_DevelopTerrainAtCurrentPosition','MapTile_IsDevelopableNaturalTerrain','MapTile_IsNeutralPropertyRuins']:
    assert label+'::' in dev,label
for label in ['MapAI_ClearServiceTargetList','MapAI_BuildCompatibleCarrierTypeList','MapAI_BuildRepairPropertyOffsets','MapAI_BuildResupplyProviderTypeList','MapAI_BuildResupplyPropertyOffsets']:
    assert label+'::' in svc,label
for label in ['CampaignStats_IncrementCapturedProperties','CampaignStats_IncrementDevelopedProperties']:
    assert label+'::' in stats,label
assert 'dw MapAI_ActionDevelopTerrain' in disp
assert 'MapAI_ActionDevelopTerrain::' in disp and 'MapAI_ActionHandler2::' in disp
assert 'Unit_DevelopTerrainAtCurrentPosition' in disp
assert 'MapAI_TryRepairRecoveryAction::' in actions
assert 'MapAI_TryResupplyRecoveryAction::' in actions
assert 'farcall $0c, MapAI_BuildRepairPropertyOffsets' in actions
assert 'farcall $0c, MapAI_BuildResupplyPropertyOffsets' in actions
for name,val in [('MAP_PROPERTY_OFFSET_HQ','$01'),('MAP_PROPERTY_OFFSET_CITY','$02'),('MAP_PROPERTY_OFFSET_BASE','$04'),('MAP_PROPERTY_OFFSET_AIRPORT','$06'),('MAP_PROPERTY_OFFSET_RUNWAY','$08'),('MAP_PROPERTY_OFFSET_PORT','$09')]:
    assert re.search(rf'DEF\s+{name}\s+EQU\s+{re.escape(val)}',consts,re.I),name
# The two service builders must encode the behavior-proven aircraft difference.
repair=svc[svc.index('MapAI_BuildRepairPropertyOffsets::'):svc.index('MapAI_BuildResupplyProviderTypeList::')]
resupply=svc[svc.index('MapAI_BuildResupplyPropertyOffsets::'):]
assert 'MAP_PROPERTY_OFFSET_AIRPORT' in repair and 'MAP_PROPERTY_OFFSET_RUNWAY' not in repair
assert 'MAP_PROPERTY_OFFSET_AIRPORT' in resupply and 'MAP_PROPERTY_OFFSET_RUNWAY' in resupply
print('[ok] the current source development + repair/resupply semantic integration')
