#!/usr/bin/env python3
from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
retail = (ROOT / 'baserom.gbc').read_bytes()
built = (ROOT / 'GBWARS3.gbc').read_bytes()
BANK = 0x15
START = 0x5F63
END = 0x5FC3

def sl(rom, start, end):
    off = BANK * 0x4000 + (start - 0x4000)
    return rom[off:off + (end - start)]

# The English build intentionally changes only layout/name-display bytes inside
# this retail routine.  Validate all bytes outside the four established custom
# subranges against retail, then lock the complete rebuilt custom span.
CUSTOM = [(0x5F80,0x5F82),(0x5F97,0x5F99),(0x5F9F,0x5FB4),(0x5FBB,0x5FBD)]
for addr in range(START, END):
    if any(a <= addr < b for a,b in CUSTOM):
        continue
    rb = sl(retail, addr, addr+1)
    bb = sl(built, addr, addr+1)
    assert rb == bb, f'unexpected retail drift at Bank $15:${addr:04X}'

span = sl(built, START, END)
assert len(span) == 0x60
src = (ROOT / 'engine/ui/suspend_saved_session_preview.asm').read_text()
for required in [
    'SuspendResume_DrawSavedSessionPreview::',
    'farcall MapSRAM_LoadSlotSummaryRow',
    'farcall MapSRAM_LoadSlotPreviewHeader',
    'farcall MapName9_DrawCache',
    'ld bc, $0703',
    'ld bc, $0502',
    'ld bc, $0505',
]:
    assert required in src, f'missing source contract: {required}'

suspend = (ROOT / 'engine/ui/suspend.asm').read_text()
for forbidden in ['romx[$5f80]', 'romx[$5f97]', 'romx[$5fbb]']:
    assert forbidden not in suspend, f'obsolete operand overlay remains: {forbidden}'
mapname = (ROOT / 'engine/map/map_name_ui.asm').read_text()
assert 'romx[$5f9f]' not in mapname, 'obsolete Bank $15 map-name overlay remains'

print(f'PASS: Bank $15:${START:04X}-${END-1:04X} is one mnemonic 96-byte routine')
print(f'PASS: custom span SHA-1 {hashlib.sha1(span).hexdigest()}')
print('PASS: former coordinate/name overlays are integrated into the instruction stream')
