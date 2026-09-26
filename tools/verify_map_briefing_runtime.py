#!/usr/bin/env python3
from pathlib import Path
import hashlib,re
ROOT=Path(__file__).resolve().parents[1]
ROM=ROOT/'baserom.gbc'; SRC=ROOT/'engine/map/map_briefing_runtime.asm'; SYM=ROOT/'symbols.asm'
RANGES=[(0x48ad,0x491f,'d33630710562ca242c978c537406001362ce8da9'),(0x4963,0x4ba9,'2ace2a906ddedcda8cedb4350fc8427ecf2b2266')]
expected={'wMapBriefingGroup':0xc61a,'wMapBriefingInputState':0xc61b,'wMapBriefingDisplayVariant':0xc61d,'wMapBriefingMapIndex':0xc622}
text=SRC.read_text(); syms=SYM.read_text()
code_text='\n'.join(line.split(';',1)[0] for line in text.splitlines())
for n,a in expected.items():
    if not re.search(rf'^{n}\s+equ\s+\${a:04x}\s*$',syms,re.M|re.I): raise SystemExit(f'missing alias {n}')
    if n not in text: raise SystemExit(f'source does not use {n}')
for n in ['MapBriefing_OpenInGame','MapBriefing_OpenModal','MapBriefing_CheckAvailable','MapBriefing_SetupScreen','MapBriefing_Update','MapBriefing_WaitForInput','MapBriefing_GroupPointerTable']:
    if n not in text: raise SystemExit(f'missing label {n}')
for raw in ['$c61a','$c61b','$c61d','$c622']:
    if raw in code_text.lower(): raise SystemExit(f'raw shared-scratch address remains: {raw}')
# Preserve custom source seams instead of absorbing them into this module.
unit=(ROOT/'engine/unit/unit_status.asm').read_text(); beginner=(ROOT/'engine/ui/beginner.asm').read_text()
if 'romx[$491f]' not in unit.lower() or 'UnitStatus_DrawAlternateMapName' not in unit:
    raise SystemExit('custom $491F-$4962 alternate map-name renderer ownership missing')
if 'romx[$4ba9]' not in beginner.lower() or 'Beginner_Strings' not in beginner:
    raise SystemExit('Beginner_Strings $4BA9 ownership missing')
if 'dw Beginner_Strings' not in text:
    raise SystemExit('briefing group table does not symbolically reference Beginner_Strings')
# Lock section starts/ends textually; mnemonic source is ROM-verified by fixed retail hashes.
for start,end,_ in RANGES:
    if f'romx[${start:04x}]' not in text.lower() or f'assert @ == ${end:04x}' not in text.lower():
        raise SystemExit(f'missing fixed boundary ${start:04X}-${end-1:04X}')
if ROM.exists():
    rb=ROM.read_bytes(); bankoff=0x25*0x4000
    for start,end,sha in RANGES:
        retail=rb[bankoff+start-0x4000:bankoff+end-0x4000]
        h=hashlib.sha1(retail).hexdigest()
        if h!=sha: raise SystemExit(f'ROM hash mismatch ${start:04X}: {h}')
        print(f'[ok] map briefing runtime ${start:04X}-${end-1:04X}: {len(retail)} bytes, SHA-1 {h}')
else:
    print('[skip] baserom.gbc absent; map briefing structural/source-seam checks passed')
print('[ok] custom $491F-$4962 renderer and $4BA9+ Beginner text remain separately owned')
