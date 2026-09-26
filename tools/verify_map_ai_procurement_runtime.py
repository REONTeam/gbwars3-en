#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'baserom.gbc'
SRC = ROOT / 'engine' / 'map' / 'ai' / 'map_ai_procurement.asm'
START, END, BANK = 0x4E53, 0x55C8, 0x0D
EXPECTED_SHA1 = '1fb29663cfefda378e1f7ca867f8d4d6a917aef4'

def parse_source_bytes(text):
    out = bytearray()
    for line in text.splitlines():
        line = line.split(';',1)[0]
        m = re.match(r'\s*db\s+(.+)$', line, re.I)
        if not m: continue
        for tok in m.group(1).split(','):
            tok=tok.strip()
            if re.fullmatch(r'\$[0-9a-fA-F]{1,2}',tok): out.append(int(tok[1:],16))
            else: raise SystemExit(f'non-literal db token: {tok}')
    return bytes(out)

rom=ROM.read_bytes(); src=SRC.read_text()
off=BANK*0x4000+(START-0x4000)
expected=rom[off:off+(END-START)]
actual=parse_source_bytes(src)
assert len(actual)==END-START, (len(actual),END-START)
assert actual==expected, 'source bytes do not match retail ROM'
sha=hashlib.sha1(expected).hexdigest()
assert sha==EXPECTED_SHA1, (sha,EXPECTED_SHA1)
for label in ['MapAI_BuildProcurementState','MapAI_InitializeDesiredUnitPlan','MapAI_AppendDesiredUnit','MapAI_CountActiveUnitsByType','MapAI_AddTransportRouteNeeds','MapAI_AddInfantryRouteNeeds','MapAI_CompositionData']:
    assert label+'::' in src, label
sym=(ROOT/'symbols.asm').read_text()
for name,addr in [('wMapAIActiveUnitCountsByType','$dd81'),('wMapAIDesiredUnitCountsByType','$ddb5'),('wMapAIProcurementEntryCount','$dded'),('wMapAIProcurementEntries','$ddee'),('wMapAICompositionFlags','$de56'),('wMapAISecondaryUnitCountsByType','$de57')]:
    assert re.search(rf'^{name}\s+equ\s+{re.escape(addr)}$',sym,re.M|re.I), name
print(f'Map AI procurement runtime: {len(expected)} bytes, SHA-1 {sha} [ok]')
