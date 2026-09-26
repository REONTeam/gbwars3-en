#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys
ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'baserom.gbc'
SRC = ROOT/'engine'/'map'/'ai'/'map_ai_actions.asm'
START, END, BANK = 0x55C8, 0x58A2, 0x0D
EXPECTED_SHA1 = '26e376a09b83149c2ac6d8c14202aaee3095549a'
FARCALL_TARGETS = {
    'UnitRecord_CopyToScratch': (0x12, 0x412B),
    'Unit_CanRepairAtCurrentTerrain': (0x12, 0x46C8),
    'UnitData_CheckLoadingCompatibility': (0x12, 0x4329),
    'MapAI_BuildRepairPropertyOffsets': (0x0C, 0x6F9A),
    'MapAI_BuildResupplyPropertyOffsets': (0x0C, 0x7022),
}
def parse(text):
    out=bytearray()
    for line in text.splitlines():
        line=line.split(';',1)[0]
        m=re.match(r'\s*db\s+(.+)$',line,re.I)
        if m:
            for tok in m.group(1).split(','):
                tok=tok.strip()
                if re.fullmatch(r'\$[0-9a-fA-F]{1,2}',tok): out.append(int(tok[1:],16))
                else: raise SystemExit(f'non-literal db token: {tok}')
            continue
        m=re.match(r'\s*farcall\s+\$([0-9a-fA-F]{1,2})\s*,\s*([A-Za-z0-9_]+)\s*$', line, re.I)
        if m:
            bank=int(m.group(1),16); label=m.group(2)
            if label not in FARCALL_TARGETS: raise SystemExit(f'unknown farcall target: {label}')
            expected_bank, addr=FARCALL_TARGETS[label]
            assert bank == expected_bank, (label, bank, expected_bank)
            out += bytes((0xEF, bank, addr & 0xFF, addr >> 8))
    return bytes(out)
rom=ROM.read_bytes(); src=SRC.read_text(); off=BANK*0x4000+(START-0x4000)
expected=rom[off:off+END-START]; actual=parse(src)
assert len(actual)==END-START,(len(actual),END-START)
assert actual==expected,'source bytes do not match retail ROM'
sha=hashlib.sha1(expected).hexdigest(); assert sha==EXPECTED_SHA1,(sha,EXPECTED_SHA1)
for label in ['MapAI_ProcessActiveUnitActions', 'MapAI_TryUnitActionPrimary', 'MapAI_TryUnitActionSecondary', 'MapAI_TryUnitActionTertiary', 'MapAI_TestPrimaryActionEligibility', 'MapAI_TestSecondaryActionEligibility', 'MapAI_TestUnitActionState', 'MapAI_FindActionCoordinate', 'MapAI_FindCompatibleUnitTarget', 'MapAI_TestMapClassForAction']: assert label+'::' in src,label
assert 'assert @ == $58a2' in src.lower()
print(f'Map AI action runtime: {len(expected)} bytes, SHA-1 {sha} [ok]')
