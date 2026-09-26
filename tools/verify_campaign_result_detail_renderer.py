#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys

ROOT = Path(__file__).resolve().parents[1]
retail = ROOT / 'baserom.gbc'
out = ROOT / 'GBWARS3.gbc'
src = ROOT / 'engine/campaign/campaign_result_detail_renderer.asm'
EXPECTED_ROM = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
SPANS = [
    (0x27, 0x7A63, 0x7AA8, 'Campaign result statistic-band helper'),
    (0x27, 0x7AA8, 0x7C84, 'Campaign result detail renderer and labels'),
]

def off(bank, addr):
    return bank * 0x4000 + (addr - 0x4000)

if not retail.exists() or not out.exists():
    print('ERROR: baserom.gbc and GBWARS3.gbc are required for this verifier', file=sys.stderr)
    sys.exit(1)
a = retail.read_bytes(); b = out.read_bytes()
for bank, start, end, label in SPANS:
    o = off(bank, start)
    if a[o:o+end-start] != b[o:o+end-start]:
        print(f'FAIL {label}: {bank:02X}:{start:04X}-{end-1:04X}', file=sys.stderr)
        sys.exit(1)
    print(f'PASS {label}: {bank:02X}:{start:04X}-{end-1:04X} ({end-start} bytes)')

text = src.read_text()
required = [
    'CampaignResult_DrawStatisticBand::',
    'CampaignResult_DrawSummaryScreen::',
    'wUnitBuiltCountSide0', 'wUnitBuiltCountSide1',
    'wUnitLostCountSide0', 'wUnitLostCountSide1',
    'wMapSide0Gold', 'wMapSide1Gold',
    'wMapSide0Materials', 'wMapSide1Materials',
    'CampaignResult_SummaryTitle::',
]
for token in required:
    if token not in text:
        print(f'FAIL source contract missing {token}', file=sys.stderr); sys.exit(1)
print('PASS campaign result semantic source contracts')

sha = hashlib.sha256(b).hexdigest()
if sha != EXPECTED_ROM:
    print(f'FAIL custom-English SHA-256 {sha}', file=sys.stderr); sys.exit(1)
print(f'PASS corrected custom-English SHA-256 {sha}')
