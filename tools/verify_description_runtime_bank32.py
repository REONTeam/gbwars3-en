from pathlib import Path
import hashlib
import re

BANK = 0x32
START = 0x577D
END = 0x58AA
EXPECTED_SHA256 = "e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059"

retail = Path('baserom.gbc').read_bytes()
built = Path('GBWARS3.gbc').read_bytes()
o = BANK * 0x4000 + (START - 0x4000)
expected = retail[o:o + END - START]
actual = built[o:o + END - START]
assert actual == expected, 'Bank $32 description runtime differs from retail'

src = Path('engine/ui/description_runtime_bank32.asm').read_text()
assert 'assert @ == $58aa' in src.lower()
assert '\n    db ' not in src.lower(), 'description runtime should be mnemonic executable source'

sym = Path('GBWARS3.sym').read_text().lower()
expected_symbols = {
    'Description_DrawVisibleLines': 0x577D,
    'Description_ApplyScrollOffset': 0x5819,
    'Description_AdvanceToNextLine': 0x582F,
    'Description_GetUnitText': 0x5839,
    'Description_GetTerrainText': 0x5847,
    'Description_CountLines': 0x5855,
    'Description_DrawUnitText': 0x5869,
    'Description_DrawTerrainText': 0x5876,
    'Description_DrawGasExplanation': 0x5883,
    'Description_DrawInitiativeExplanation': 0x5890,
    'Description_DrawPromotionExplanation': 0x589D,
    'Description_Strings': 0x58AA,
}
for name, addr in expected_symbols.items():
    assert f'32:{addr:04x} {name.lower()}' in sym, f'missing/moved {name}'

# The old pseudo-pointer sections were actually words embedded as LD HL immediates.
expl = Path('engine/ui/descriptions_explanations.asm').read_text()
for addr in ('$5884', '$5891', '$589e'):
    assert f'romx[{addr}]' not in expl.lower(), f'stale physical pointer section at {addr}'
assert 'DEF Gas_Explanation_Pointer EQU $5884' in expl
assert 'DEF Initiative_Explanation_Pointer EQU $5891' in expl
assert 'DEF Promotion_Explanation_Pointer EQU $589e' in expl

# Every previously raw Unit Reference call into this provider must now be symbolic.
files = [
    Path('engine/unit/unit_reference_detail_runtime_6707.asm'),
    Path('engine/unit/unit_reference_submenu_controllers.asm'),
    Path('engine/unit/unit_reference_terrain_upkeep_provider.asm'),
    Path('engine/unit/unit_reference_late_submenu_providers.asm'),
]
combined = '\n'.join(p.read_text() for p in files)
raw_targets = ['$5839','$5847','$5855','$5869','$5876','$5883','$5890','$589d']
for target in raw_targets:
    assert f'farcall $32, {target}' not in combined.lower(), f'raw call remains for {target}'
for label in [
    'Description_GetUnitText', 'Description_GetTerrainText', 'Description_CountLines',
    'Description_DrawUnitText', 'Description_DrawTerrainText',
    'Description_DrawGasExplanation', 'Description_DrawInitiativeExplanation',
    'Description_DrawPromotionExplanation',
]:
    assert label in combined, f'no symbolic Unit Reference use of {label}'

custom_hash = hashlib.sha256(built).hexdigest()
assert custom_hash == EXPECTED_SHA256, custom_hash
print(f'PASS Bank $32 description runtime ${START:04X}-${END-1:04X} ({END-START} bytes)')
print('PASS 12 public address locks')
print('PASS embedded explanation pointers modeled as instruction operands')
print('PASS Unit Reference callers symbolic')
print('PASS custom-English SHA-256', custom_hash)
