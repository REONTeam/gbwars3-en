#!/usr/bin/env python3
from pathlib import Path
import hashlib, re
ROOT = Path(__file__).resolve().parents[1]
base = (ROOT / 'baserom.gbc').read_bytes()
out_path = ROOT / 'GBWARS3.gbc'
out = out_path.read_bytes() if out_path.exists() else None
bank = 0x18

def span(lo, hi):
    off = bank * 0x4000 + (lo - 0x4000)
    return off, base[off:off + hi - lo]

checks = [
    (0x60C6, 0x632F, 'alternate-country/map-choice family', '89c9a8b406d8a1f2fee8b291b5530bc55a0274f0'),
    (0x6389, 0x6504, 'map-type presentation family', '226a53c66e69844f51a988245fe4a48140a3acbc'),
    (0x6547, 0x65CC, 'map-type selection controller', 'a078c74c7110c8c90be029f6f8422826f9c47538'),
]
for lo, hi, name, want in checks:
    off, blob = span(lo, hi)
    got = hashlib.sha1(blob).hexdigest()
    assert got == want, (name, got, want)
    if out is not None:
        assert out[off:off + hi - lo] == blob, f'{name}: linked bytes differ from retail'
    print(f'PASS {name}: $18:${lo:04X}-${hi-1:04X} ({hi-lo} bytes)')

source = (ROOT / 'engine/versus/versus_country_maptype_runtime.asm').read_text()
raw = [line for line in source.splitlines() if re.match(r'^\s*db\s+\$[0-9a-f]{2}', line, re.I)]
assert not raw, raw[:5]
print('PASS no executable raw db stream remains in versus_country_maptype_runtime.asm')

for label in [
    'Versus_RunAlternateCountrySelection::',
    'Versus_DrawAlternateCountrySelectionScreen::',
    'Versus_UpdateAlternateCountryCursor::',
    'Versus_RunTransferMapChoiceController::',
    'Versus_UpdateMapTypeCursor::',
    'Versus_DrawMapTypeSelectionScreen::',
    'Versus_ShowMapTypeDescription::',
    'Versus_RunMapTypeSelectionController::',
]:
    assert label in source, label
print('PASS all eight public runtime entries remain explicit')

combined = span(0x60C6, 0x632F)[1] + span(0x6389, 0x6504)[1] + span(0x6547, 0x65CC)[1]
assert hashlib.sha1(combined).hexdigest() == 'cf9a3827c915254df12ee7b149832a84f56ceac5'
print('PASS combined mnemonic conversion: 1,129 retail bytes')

raw_far = re.compile(r'\bfarcall\s+\$[0-9a-f]{1,2}\s*,\s*\$[0-9a-f]{4}\b', re.I)
hits=[]
for p in ROOT.rglob('*.asm'):
    for i,line in enumerate(p.read_text(errors='ignore').splitlines(),1):
        if raw_far.search(line): hits.append((p.relative_to(ROOT),i,line.strip()))
assert not hits, hits[:5]
print('PASS project-wide raw numeric farcall audit: 0')

if out is not None:
    got = hashlib.sha256(out).hexdigest()
    want = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
    assert got == want, (got, want)
    print('PASS corrected custom-English SHA-256', got)
