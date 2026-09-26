#!/usr/bin/env python3
from pathlib import Path
import hashlib, re

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'baserom.gbc'
BUILT = ROOT / 'GBWARS3.gbc'
SYM = ROOT / 'GBWARS3.sym'
SOURCE = ROOT / 'engine/map/map_editor_interaction_runtime_4170.asm'
EXPECTED_ROM_SHA256 = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
RANGES = [
    (0x4170, 0x4464, 'bb93a4bf00bc2e0b5fa4d246738f33f36ecb9acb'),
    (0x4490, 0x459A, 'c08da555e2205e3c0d2be6e9d167bdb53ac205f4'),
    (0x45AA, 0x45BD, '6de85d7c2378dad48b2f93d93758cf8533d03b67'),
]

def fail(msg):
    raise SystemExit('[fail] ' + msg)

def bank_slice(data, bank, start, end):
    off = bank * 0x4000 + (start - 0x4000)
    return data[off:off + end - start]

if not BASE.exists() or not BUILT.exists() or not SYM.exists():
    fail('baserom.gbc, GBWARS3.gbc and GBWARS3.sym are required')
retail = BASE.read_bytes(); built = BUILT.read_bytes()
for start, end, expected_sha1 in RANGES:
    rr = bank_slice(retail, 0x0F, start, end)
    br = bank_slice(built, 0x0F, start, end)
    if hashlib.sha1(rr).hexdigest() != expected_sha1:
        fail(f'retail fingerprint changed at Bank $0F:${start:04X}-${end-1:04X}')
    if br != rr:
        fail(f'built bytes differ from retail at Bank $0F:${start:04X}-${end-1:04X}')
if hashlib.sha256(built).hexdigest() != EXPECTED_ROM_SHA256:
    fail('custom-English ROM hash drifted')

src = SOURCE.read_text(encoding='utf-8')
for needle in [
    'MapEditor_RunInteractionController::',
    'MapEditor_MenuHandlerPointers::',
    'MapEditor_ApplyCurrentPlacement::',
    'MapEditor_PrepareTerrainPlacement::',
    'MapEditor_CheckUniqueHQPlacement::',
    'MapEditor_PrepareUnitPlacement::',
    'MapEditor_DecrementExistingUnitCount::',
    'MapEditor_ShowPropertyLimitWarning::',
    'MapEditor_ShowUnitLimitWarning::',
    'MapEditor_UpdatePlacementPreviewBlink::',
    'MapEditor_RestoreCellAtCursor::',
    'MapEditor_SelectMainMenuItem::',
    'MapEditor_DrawMainMenuLabels::',
    'farcall $0c, MapGrid_CountPropertyTiles',
    'cp 100',
    'cp 50',
    'ld hl, wUnitCountBySide',
    'ld hl, wMapTileCountsById',
    'assert @ == $4464',
    'assert @ == $459a',
    'assert @ == $45bd',
]:
    if needle not in src:
        fail('source missing contract: ' + needle)
if re.search(r'(?m)^\s*db\s+', src):
    fail('raw db executable bytes remain in Map Editor interaction source')

sym = SYM.read_text(encoding='utf-8', errors='replace')
public = {
    'MapEditor_RunInteractionController': 0x4170,
    'MapEditor_MenuHandlerPointers': 0x4280,
    'MapEditor_ApplyCurrentPlacement': 0x4290,
    'MapEditor_PrepareTerrainPlacement': 0x42D5,
    'MapEditor_CheckUniqueHQPlacement': 0x4341,
    'MapEditor_PrepareUnitPlacement': 0x435A,
    'MapEditor_DecrementExistingUnitCount': 0x43E6,
    'MapEditor_ShowPropertyLimitWarning': 0x4400,
    'MapEditor_ShowUnitLimitWarning': 0x4404,
    'MapEditor_UpdatePlacementPreviewBlink': 0x4490,
    'MapEditor_RestoreCellAtCursor': 0x44CE,
    'MapEditor_SelectMainMenuItem': 0x44EE,
    'MapEditor_DrawMainMenuLabels': 0x45AA,
}
for name, addr in public.items():
    if not re.search(rf'(?mi)^0f:{addr:04x}\s+{re.escape(name)}$', sym):
        fail(f'{name} is not linked at $0F:${addr:04X}')

frontend = (ROOT / 'engine/map/map_editor_frontend_4000.asm').read_text(encoding='utf-8')
if 'call MapEditor_RunInteractionController' not in frontend and 'call $4170' in frontend:
    fail('Map Editor frontend still calls raw $4170')

print('Map Editor interaction/runtime verification: PASS')
print('  Bank $0F:$4170-$4463: 756 byte-exact source-owned bytes')
print('  Bank $0F:$4490-$4599: 266 byte-exact source-owned bytes')
print('  Bank $0F:$45AA-$45BC: 19 byte-exact source-owned bytes')
print('  total new source ownership: 1,041 bytes')
print('  property/building cap: 100; unit cap: 50 per side')
print('  linked ROM SHA-256:', EXPECTED_ROM_SHA256)
