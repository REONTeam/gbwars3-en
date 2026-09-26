#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import sys

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'baserom.gbc'
rom = ROM.read_bytes()

ranges = [
    (0x0B, 0x648C, 0x6524, 'Property capture executor', '977529b837375ceefb08287f55fe65dbd913fb87'),
    (0x0C, 0x504F, 0x5138, 'Seven-hex area attack runtime', '09b88b3bc0e49d9af0f48486278a4d7305201c49'),
]
for bank, start, end, name, want in ranges:
    off = bank * 0x4000 + (start - 0x4000)
    data = rom[off:off + end - start]
    got = sha1(data).hexdigest()
    assert len(data) == end - start and got == want, (name, len(data), got)
    print(f'[ok] {name}: Bank ${bank:02X}:${start:04X}-${end-1:04X}, {len(data)} bytes, SHA-1 {got}')

capture = (ROOT / 'engine/unit/unit_capture_action.asm').read_text()
area = (ROOT / 'engine/map/ai/map_ai_area_attack.asm').read_text()
disp = (ROOT / 'engine/map/ai/map_ai_action_dispatch.asm').read_text()

assert 'Unit_CapturePropertyAtCurrentPosition::' in capture
assert 'CampaignStats_IncrementCapturedProperties' in capture
assert 'assert @ == $6524' in capture
assert not any(line.lstrip().startswith('db ') for line in capture.splitlines()), 'capture executor still contains raw db code'
assert 'MapAI_ApplyAreaAttackAroundTarget::' in area
assert 'MapAI_ApplyAreaAttackAtCoordinate::' in area
assert 'MapAI_GetAreaAttackDamage::' in area
assert 'MapAI_BomberAreaAttackDamageByTargetClass::' in area
assert 'db 1, 2, 3, 0, 1' in area
assert 'MapAI_OtherAreaAttackDamageByTargetClass::' in area
assert 'db 2, 3, 0, 1, 0' in area
assert 'cp UNIT_TYPE_BOMBER' in area and 'cp UNIT_TYPE_MERCENARY_BOMBER' in area
assert 'dw MapAI_ActionCaptureProperty' in disp
assert 'dw MapAI_ActionAreaAttack' in disp
assert 'MapAI_ActionCaptureProperty::' in disp and 'MapAI_ActionHandler1::' in disp
assert 'farcall $0b, Unit_CapturePropertyAtCurrentPosition' in disp
assert 'MapAI_ActionAreaAttack::' in disp and 'MapAI_ActionHandler5::' in disp
assert 'farcall $0c, MapAI_ApplyAreaAttackAroundTarget' in disp
assert 'add 10' in disp
assert 'farcall $12, UnitRecord_AddExperienceClamped' in disp
assert 'farcall $12, UnitRecord_CopyToScratch' in disp
print('[ok] action 1 capture and action 5 area-attack semantic integration')
