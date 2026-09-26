#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'baserom.gbc'
BUILT = ROOT / 'GBWARS3.gbc'
SYM = ROOT / 'GBWARS3.sym'
SOURCE = ROOT / 'engine/map/ai/map_ai_area_attack.asm'
BANK = 0x0C
RUNTIME_START = 0x504F
RUNTIME_END = 0x52A6
EXECUTOR_START = 0x508B
EXECUTOR_END = 0x5106
TERRAIN_START = 0x5138
TERRAIN_END = 0x5259
SPRITE_START = 0x5259
EXPECTED_RUNTIME_RETAIL_SHA1 = '674067584a3f682c3d8e3f116dc8ff8743797ea2'
EXPECTED_EXECUTOR_SHA1 = '1161b7b8b0bb12a5c429248c1be6406f99b88a5f'
EXPECTED_TERRAIN_SHA1 = '1fe7944e983f85bd3125cfdd746c77e629e12778'
EXPECTED_SPRITE_SHA1 = '13acdbef36917c1baee82bf927512d61ea4083a1'
EXPECTED_ROM_SHA256 = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'


def fail(msg: str) -> None:
    raise SystemExit(f'FAIL: {msg}')


def rom_slice(blob: bytes, start: int, end: int) -> bytes:
    off = BANK * 0x4000 + (start - 0x4000)
    return blob[off:off + end - start]

for p in (BASE, BUILT, SYM, SOURCE):
    if not p.exists():
        fail(f'missing required file: {p.relative_to(ROOT)}')

base = BASE.read_bytes()
built = BUILT.read_bytes()
runtime_ref = rom_slice(base, RUNTIME_START, RUNTIME_END)
if hashlib.sha1(runtime_ref).hexdigest() != EXPECTED_RUNTIME_RETAIL_SHA1:
    fail('retail area-attack runtime SHA-1 mismatch')

# The older $504F-$5137 source intentionally contains pre-existing custom-English
# differences from retail at $5080 and in the established $5130-$5132 damage
# table. Verify only the executable db conversion and the newly source-owned
# terrain/sprite ranges byte-for-byte against retail; the full-ROM hash below
# guards preservation of those existing custom bytes.
for start, end, label in [
    (EXECUTOR_START, EXECUTOR_END, 'per-cell executor'),
    (TERRAIN_START, RUNTIME_END, 'terrain/sprite runtime'),
]:
    ref = rom_slice(base, start, end)
    out = rom_slice(built, start, end)
    if ref != out:
        i = next(i for i, (a, b) in enumerate(zip(ref, out)) if a != b)
        fail(f'{label} bytes drift at $0C:${start + i:04X}')
if hashlib.sha1(rom_slice(base, EXECUTOR_START, EXECUTOR_END)).hexdigest() != EXPECTED_EXECUTOR_SHA1:
    fail('per-cell executor SHA-1 mismatch')
if hashlib.sha1(rom_slice(base, TERRAIN_START, TERRAIN_END)).hexdigest() != EXPECTED_TERRAIN_SHA1:
    fail('terrain-effect family SHA-1 mismatch')
if hashlib.sha1(rom_slice(base, SPRITE_START, RUNTIME_END)).hexdigest() != EXPECTED_SPRITE_SHA1:
    fail('area-effect sprite helper SHA-1 mismatch')
if hashlib.sha256(built).hexdigest() != EXPECTED_ROM_SHA256:
    fail('custom-English ROM SHA-256 drifted')

src = SOURCE.read_text(encoding='utf-8')
required = [
    'MapAI_ApplyAreaAttackAtCoordinate::',
    'MapAI_ApplyAreaAttackTerrainEffect::',
    'MapAI_AreaAttackDamageProtectedProperty:',
    'MapAI_AreaAttackDamageDestructibleProperty:',
    'MapAI_AreaAttackDamageRunway:',
    'MapAI_AreaAttackClearWood:',
    'MapAI_AreaAttackDestroyBridge:',
    'MapAI_AreaAttackScarPlainOrRoad:',
    'MapAI_GetAreaAttackTerrainStateDelta:',
    'MapAI_AreaAttackRuinsTileByTerrainClass:',
    'MapAI_AreaAttackTerrainEffectHandlers:',
    'MapAI_CreateAreaAttackEffectSprite:',
    'MapAI_PositionAreaAttackEffectSprite:',
    'farcall $0c, PropertyState_RemoveRecordAtCoordinates',
    'farcall $0c, PropertyState_ApplyDeltaWithPresentation',
    'farcall $0b, MapGrid_DecrementTileCount',
    'farcall $0b, MapGrid_IncrementTileCount',
    'ld a, MAP_TERRAIN_WASTELAND',
    'ld a, MAP_TERRAIN_RIVER',
]
for token in required:
    if token not in src:
        fail(f'missing source contract: {token}')
if 'farcall $0c, $56d5' in src.lower():
    fail('raw PropertyState_RemoveRecordAtCoordinates farcall remains')
if 'assert @ == $52a6' not in src.lower():
    fail('missing hard end assertion at $52A6')
if 'db $c5, $d5, $e5' in src.lower():
    fail('per-cell area-attack executor is still raw executable db bytes')

# The two literal db blocks remaining in this runtime are semantic data tables:
# two five-byte unit-damage profiles plus the ruins map. The terrain dispatch is dw.
if src.count('db 1, 2, 3, 0, 1') != 1 or src.count('db 2, 3, 0, 1, 0') != 1:
    fail('unit-damage profile tables changed')

sym = SYM.read_text(encoding='utf-8', errors='replace')
public = {
    'MapAI_ApplyAreaAttackAroundTarget': 0x504F,
    'MapAI_ApplyAreaAttackAtCoordinate': 0x508B,
    'MapAI_GetAreaAttackDamage': 0x5106,
    'MapAI_ApplyAreaAttackTerrainEffect': 0x5138,
}
for name, addr in public.items():
    if not re.search(rf'(?mi)^0c:{addr:04x}\s+{re.escape(name)}$', sym):
        fail(f'{name} is not linked at $0C:${addr:04X}')

# Retail terrain-name dispatch geometry: 23 words at $522B-$5258.
ptr = rom_slice(base, 0x522B, 0x5259)
if len(ptr) != 46:
    fail('terrain handler table is not 23 words')
expected_ptrs = [
    0x51FB, 0x5147, 0x5163, 0x51FB, 0x5163, 0x51FB,
    0x5163, 0x51FB, 0x519E, 0x5163, 0x51FB, 0x5147,
    0x51EF, 0x51EF, 0x51C2, 0x51C2, 0x51FB, 0x51BE,
    0x51FB, 0x51FB, 0x51FB, 0x51FB, 0x51FB,
]
actual_ptrs = [ptr[i] | (ptr[i + 1] << 8) for i in range(0, len(ptr), 2)]
if actual_ptrs != expected_ptrs:
    fail(f'terrain dispatch table changed: {actual_ptrs}')

ruins = list(rom_slice(base, 0x521F, 0x522B))
expected_ruins = [0, 0, 0x18, 0, 0x1A, 0, 0x1C, 0, 0, 0x1E, 0, 0]
if ruins != expected_ruins:
    fail(f'ruins replacement table changed: {ruins}')

print('Map AI area-attack terrain/runtime verification: PASS')
print(f'  Continuous source runtime: $0C:${RUNTIME_START:04X}-${RUNTIME_END-1:04X} ({RUNTIME_END-RUNTIME_START} bytes)')
print(f'  Retail-exact mnemonic executor: ${EXECUTOR_START:04X}-${EXECUTOR_END-1:04X} ({EXECUTOR_END-EXECUTOR_START} bytes)')
print(f'  Terrain dispatch: ${TERRAIN_START:04X}-${TERRAIN_END-1:04X} ({TERRAIN_END-TERRAIN_START} bytes)')
print(f'  Sprite helper: ${SPRITE_START:04X}-${RUNTIME_END-1:04X} ({RUNTIME_END-SPRITE_START} bytes)')
print('  Terrain classes: 23; ruins replacements: CITY/BASE/AIRPORT/PORT')
print(f'  Retail continuous-runtime SHA-1: {EXPECTED_RUNTIME_RETAIL_SHA1}')
print(f'  Linked ROM SHA-256: {EXPECTED_ROM_SHA256}')
