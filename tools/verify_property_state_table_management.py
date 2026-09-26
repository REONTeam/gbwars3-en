#!/usr/bin/env python3
from pathlib import Path
import hashlib, re

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'baserom.gbc'
BUILT = ROOT / 'GBWARS3.gbc'
SYM = ROOT / 'GBWARS3.sym'
SOURCE = ROOT / 'engine/map/property_state_table_management_5626.asm'
START, END = 0x5626, 0x571B
EXPECTED_SHA1 = '430763431d0191769e1f433d72d6df830fbede04'
EXPECTED_ROM_SHA256 = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'

def fail(msg):
    raise SystemExit('[fail] ' + msg)

def bank_slice(data, bank, start, end):
    off = bank * 0x4000 + (start - 0x4000)
    return data[off:off + end - start]

if not BASE.exists() or not BUILT.exists() or not SYM.exists():
    fail('baserom.gbc, GBWARS3.gbc and GBWARS3.sym are required')
retail = BASE.read_bytes()
built = BUILT.read_bytes()
rr = bank_slice(retail, 0x0C, START, END)
br = bank_slice(built, 0x0C, START, END)
if hashlib.sha1(rr).hexdigest() != EXPECTED_SHA1:
    fail('retail property-state table-management fingerprint changed')
if br != rr:
    fail('built Bank $0C:$5626-$571A differs from retail')
if hashlib.sha256(built).hexdigest() != EXPECTED_ROM_SHA256:
    fail('custom-English ROM hash drifted')

src = SOURCE.read_text(encoding='utf-8')
for needle in [
    'PropertyState_RebuildRecordsFromMap::',
    'PropertyState_InitializeRecordFromTerrainClass::',
    'PropertyState_AddRecordAtCoordinates::',
    'PropertyState_RemoveRecordAtCoordinates::',
    'MapGrid_CountPropertyTiles::',
    'ld hl, wMapPropertyStateRecords',
    'ld [wMapPropertyStateRecordCount], a',
    'farcall $0b, Terrain_GetNameIndex',
    'farcall $0b, MapGrid_IncrementTileCount',
    'farcall $0b, MapGrid_DecrementTileCount',
    'farcall $0b, MapEconomy_RecalculateIncome',
    'call PropertyState_FindRecordAtCoordinates',
    'cp MAP_TERRAIN_PLAIN',
    'assert @ == $571b',
]:
    if needle not in src:
        fail('source missing contract: ' + needle)
if re.search(r'(?m)^\s*db\s+', src):
    fail('raw db executable bytes remain in $5626-$571A source')

sym = SYM.read_text(encoding='utf-8', errors='replace')
public = {
    'PropertyState_RebuildRecordsFromMap': 0x5626,
    'PropertyState_InitializeRecordFromTerrainClass': 0x567C,
    'PropertyState_AddRecordAtCoordinates': 0x5697,
    'PropertyState_RemoveRecordAtCoordinates': 0x56D5,
    'MapGrid_CountPropertyTiles': 0x5705,
}
for name, addr in public.items():
    if not re.search(rf'(?mi)^0c:{addr:04x}\s+{re.escape(name)}$', sym):
        fail(f'{name} is not linked at $0C:${addr:04X}')

setup = (ROOT / 'engine/map/bank0b_map_setup_runtime_4000.asm').read_text(encoding='utf-8')
construction = (ROOT / 'engine/map/bank0b_construction_actions_4941.asm').read_text(encoding='utf-8')
if 'farcall $0c, PropertyState_RebuildRecordsFromMap' not in setup:
    fail('selected-map setup does not use PropertyState_RebuildRecordsFromMap')
if 'farcall $0c, PropertyState_AddRecordAtCoordinates' not in construction:
    fail('RUNWAY construction does not use PropertyState_AddRecordAtCoordinates')
for raw in ('$5626', '$5697'):
    for p in (ROOT / 'engine').rglob('*.asm'):
        if f'farcall $0c, {raw}' in p.read_text(encoding='utf-8', errors='ignore').lower():
            fail(f'raw source-owned Bank-$0C call remains in {p.relative_to(ROOT)}: {raw}')

# The formerly opaque editor count caller is now mnemonic/source-owned.
editor_runtime = (ROOT / 'engine/map/map_editor_interaction_runtime_4170.asm').read_text(encoding='utf-8')
if 'farcall $0c, MapGrid_CountPropertyTiles' not in editor_runtime:
    fail('Map Editor property/building limit does not call MapGrid_CountPropertyTiles symbolically')

print('Property-state table-management verification: PASS')
print('  Bank $0C:$5626-$571A: 245 byte-exact source-owned bytes')
print('  rebuild / initialize / add / remove / property-count helpers linked at retail addresses')
print('  selected-map setup, RUNWAY construction, and Map Editor property-limit callers are symbolic')
print('  linked ROM SHA-256:', EXPECTED_ROM_SHA256)
