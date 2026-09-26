#!/usr/bin/env python3
from pathlib import Path
import hashlib,re
ROOT=Path(__file__).resolve().parents[1]
ROM=ROOT/'baserom.gbc'; SRC=ROOT/'engine/campaign/campaign_map_select.asm'; SYM=ROOT/'symbols.asm'
SECTIONS=[(0x44fd,0x476e),(0x476e,0x47bc),(0x4819,0x48ad)]
FULL_RANGES=[(0x44fd,0x47bc,'255c2145839278258c7c63421927ff65b1adfd93'),(0x4819,0x48ad,'03bdec5fc20d9a6a3cbfee6fca39ebd9ccf5784f')]
expected={
'wCampaignMapSelectPage':0xc61a,'wCampaignMapSelectMapIndexScratch':0xc61b,'wCampaignMapSelectCellScratch':0xc61c,
'wCampaignMapSelectCursorSpriteID':0xc61d,'wCampaignMapSelectConfirmEnabled':0xc61e,'wCampaignMapSelectRow':0xc61f,
'wCampaignMapSelectColumn':0xc620,'wCampaignMapSelectEntryMapIndex':0xc621,'wMapRecordIndex':0xca1f,'wCampaignMapClearCounts':0xc784,
}
resource_labels={
    'CampaignMapSelectPage0Graphics':0x5690,
    'CampaignMapSelectPage0Palettes':0x5e60,
    'CampaignMapSelectPage1Graphics':0x5ea0,
    'CampaignMapSelectPage2Graphics':0x66b0,
    'CampaignMapSelectPage3Graphics':0x6ec0,
    'CampaignMapSelectPage4Graphics':0x76d0,
}
text=SRC.read_text(); syms=SYM.read_text()
for n,a in expected.items():
    if n.startswith('wCampaignMapSelect') and not re.search(rf'^{n}\s+equ\s+\${a:04x}\s*$',syms,re.M|re.I):
        raise SystemExit(f'missing alias {n}')
    if n not in text: raise SystemExit(f'source does not use {n}')
for n in ['CampaignMapSelect_OpenViewOnly','CampaignMapSelect_OpenSelectable','CampaignMapSelect_Run','CampaignMapSelect_GetSelectedMapIndex','CampaignMapSelect_DrawPageAvailability']:
    if n not in text: raise SystemExit(f'missing label {n}')

for t in ('dw CampaignMapSelectPage0Palettes','dw CampaignMapSelectPage0Graphics','dw CampaignMapSelectPage1Graphics','dw CampaignMapSelectPage2Graphics','dw CampaignMapSelectPage3Graphics','dw CampaignMapSelectPage4Graphics'):
    if t not in text: raise SystemExit(f'missing symbolic Campaign map resource reference: {t}')
# Parse source bytes section-by-section.
sections=[]; current=None
for line in text.splitlines():
    code=line.split(';',1)[0].strip()
    m=re.search(r'romx\[\$(....)\]',code,re.I)
    if code.lower().startswith('section ') and m:
        if current: sections.append(current)
        current=[int(m.group(1),16),bytearray()]; continue
    if current and code.startswith('db '):
        for tok in [x.strip() for x in code[3:].split(',')]:
            if tok.startswith('$'): current[1].append(int(tok[1:],16)); continue
            m2=re.fullmatch(r'(LOW|HIGH)\((w\w+)\)',tok)
            if not m2 or m2.group(2) not in expected: raise SystemExit(f'unsupported db token {tok}')
            v=expected[m2.group(2)]; current[1].append(v&0xff if m2.group(1)=='LOW' else v>>8)
    if current and code.startswith('dw '):
        for tok in [x.strip() for x in code[3:].split(',')]:
            if tok.startswith('$'):
                v=int(tok[1:],16)
            elif tok in resource_labels:
                v=resource_labels[tok]
            else:
                raise SystemExit(f'unsupported dw token {tok}')
            current[1]+=bytes((v&0xff,v>>8))
if current: sections.append(current)
by_start={s:bytes(v) for s,v in sections}
for start,end in SECTIONS:
    got=by_start.get(start)
    if got is None: raise SystemExit(f'missing section ${start:04X}')
    if len(got)!=end-start: raise SystemExit(f'${start:04X} reconstructed {len(got)}, expected {end-start}')
if ROM.exists():
    rb=ROM.read_bytes(); bankoff=0x25*0x4000
    for start,end in SECTIONS:
        retail=rb[bankoff+start-0x4000:bankoff+end-0x4000]
        if by_start[start]!=retail: raise SystemExit(f'source mismatch ${start:04X}-${end-1:04X}')
    for start,end,sha in FULL_RANGES:
        retail=rb[bankoff+start-0x4000:bankoff+end-0x4000]
        h=hashlib.sha1(retail).hexdigest()
        if h!=sha: raise SystemExit(f'ROM hash mismatch ${start:04X}: {h}')
        print(f'[ok] Campaign map selector ${start:04X}-${end-1:04X}: {len(retail)} bytes, SHA-1 {h}')
else:
    print('[skip] baserom.gbc absent; Campaign map selector structural reconstruction passed')
# Cross-feature gap must remain owned by engine/unit/unit_status.asm.
unit=(ROOT/'engine/unit/unit_status.asm').read_text()
if 'romx[$47bc]' not in unit.lower() or 'UnitStatus_DrawMapSelectionSummary' not in unit:
    raise SystemExit('custom $47BC map-selection summary ownership missing')
print('[ok] custom $47BC-$4818 map-selection summary remains separately owned')
