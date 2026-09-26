#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import re, sys

ROOT = Path(__file__).resolve().parents[1]
rom = Path(sys.argv[1] if len(sys.argv) > 1 else ROOT / 'baserom.gbc').read_bytes()

def require(cond, msg):
    if not cond:
        raise AssertionError(msg)

def off(bank, addr):
    return bank * 0x4000 + (addr - 0x4000)

def digest(bank, start, end):
    o = off(bank, start)
    return sha1(rom[o:o + end - start]).hexdigest()

require(digest(0x23, 0x42be, 0x4316) == '5b9f85bb620289943bbcebe880872314f3e7a6fc',
        'attract text-control helper range changed')
require(digest(0x23, 0x48ac, 0x4fc7) == '09ff5e63d5b4bbff2e1fe400d9f311e189254f4c',
        'attract introduction/runtime/script range changed')

src = (ROOT / 'engine/ui/attract_intro_runtime.asm').read_text()
for token in (
    'AttractSequence_CheckSkipEnabled::',
    'AttractText_WaitFramesOrConfirmAndHideCursor::',
    'AttractIntro_Run::',
    'AttractText_SetupScreen::',
    'AttractText_Update::',
    'AttractText_UpdateCursorSprite::',
    'AttractScriptPointerTable::',
    'AttractScript_ToBeContinued::',
    'AttractScript_PlayNextArea15::',
    'AttractScript_GameIntroduction::',
    'AttractScript_StaffCredits::',
    'db "WELCOME TO", $ff',
    'db "GOOD LUCK ON", $ff',
    'db "PROGRAMERS", $ff',
    'db "     THE END", $00',
    'assert @ == $4316',
    'assert @ == $4a6e',
    'assert @ == $4fc7',
):
    require(token in src, f'missing attract-runtime token: {token}')

startup = (ROOT / 'engine/ui/startup_title_controller.asm').read_text()
require('farcall $23, AttractIntro_Run' in startup, 'startup controller does not use symbolic attract entry')
require('farcall $23, $48ac' not in startup, 'legacy raw attract entry remains')

mk = (ROOT / 'Makefile').read_text()
require('engine/ui/attract_intro_runtime.o' in mk, 'Makefile missing attract runtime object')

# Verify the four plaintext script streams encode exactly to the retail bytes.
enc = {}
for line in (ROOT / 'charmaps/char_news.inc').read_text().splitlines():
    m = re.match(r'charmap\s+"(.*)",\s*\$([0-9a-fA-F]+)', line)
    if m:
        enc[m.group(1).replace('\\"', '"').replace('\\\\', '\\')] = int(m.group(2), 16)

lines = src.splitlines()
script_ranges = {
    'AttractScript_ToBeContinued': (0x4a7e, 0x4a98),
    'AttractScript_PlayNextArea15': (0x4a98, 0x4aba),
    'AttractScript_GameIntroduction': (0x4aba, 0x4c59),
    'AttractScript_StaffCredits': (0x4c59, 0x4fc7),
}

def split_db(expr):
    parts, cur, quoted = [], '', False
    for ch in expr:
        if ch == '"':
            quoted = not quoted
            cur += ch
        elif ch == ',' and not quoted:
            parts.append(cur.strip())
            cur = ''
        else:
            cur += ch
    if cur.strip():
        parts.append(cur.strip())
    return parts

for label, (start, end) in script_ranges.items():
    i = next(i for i, line in enumerate(lines) if line.strip() == label + '::') + 1
    data = bytearray()
    while i < len(lines):
        line = lines[i].strip(); i += 1
        if line.startswith('assert @') or (line.endswith('::') and data):
            break
        if not line.startswith('db '):
            continue
        for part in split_db(line[3:]):
            if part.startswith('"') and part.endswith('"'):
                for ch in part[1:-1]:
                    require(ch in enc, f'unmapped attract-script character {ch!r}')
                    data.append(enc[ch])
            elif part.startswith('$'):
                data.append(int(part[1:], 16))
            else:
                raise AssertionError(f'unsupported attract-script db token: {part}')
    expected = rom[off(0x23, start):off(0x23, end)]
    require(data == expected, f'{label} source bytes differ from retail')

print('attract introduction: text-control helpers and runtime bytes locked [ok]')
print('attract scripts: intro, continuation, area prompt, and staff credits plaintext locked [ok]')
