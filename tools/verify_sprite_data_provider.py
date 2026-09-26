#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import re, sys

rom = Path(sys.argv[1] if len(sys.argv) > 1 else 'baserom.gbc').read_bytes()
src = Path('engine/sprite/sprite_data.asm').read_text()
const_text = Path('constants/sprite_constants.inc').read_text()
anim_text = Path('engine/sprite/sprite_animation_data.asm').read_text()


def require(cond, msg):
    if not cond:
        raise AssertionError(msg)

def off(bank, addr):
    return addr if bank == 0 else bank * 0x4000 + (addr - 0x4000)

def rom_chunk(bank, start, end):
    return rom[off(bank,start):off(bank,start)+(end-start)]

def check_sha(bank, start, end, expected):
    got=sha1(rom_chunk(bank,start,end)).hexdigest()
    require(got==expected, f'ROM range {bank:02X}:{start:04X}-{end-1:04X} changed: {got}')

# Callable provider ranges and table ownership anchors.
check_sha(0x00,0x0150,0x0166,'be8ed32bdf922db1e32d4634a8a9d4ebaeff615b')
check_sha(0x1A,0x43D7,0x4437,'853a188c756f0bb26c52275c867e23da2c24aab2')
check_sha(0x1A,0x44EB,0x4510,'c775f9a715f9658e3b6012b9abaae6e2e6b070fa')
check_sha(0x1A,0x4510,0x4541,'8db0fa899b4d0a77cdc1a04de3621bc53cdefd79')
check_sha(0x1A,0x457A,0x45A5,'96effadf7c8699b77a77d5e8f08d377bc5d5e75b')

for token in (
    'section "Sprite Group Loader", romx[$43d7], bank[$1a]',
    'SpriteGroup_LoadGraphicsAndPalettes::',
    'assert @ == $4437',
    'section "Sprite Group Descriptor Copy", romx[$44eb], bank[$1a]',
    'SpriteGroup_CopyDescriptor::',
    'assert @ == $4510',
    'section "Sprite Animation Lookup", romx[$4510], bank[$1a]',
    'SpriteAnimation_GetFarPointer::',
    'assert @ == $4541',
    'section "Unit Sprite Lookup", romx[$457a], bank[$1a]',
    'UnitSprite_LoadDefinition::',
    'assert @ == $45a5',
    'call FarCopy_ToVRAM',
):
    require(token in src, f'missing source token: {token}')
far = Path('engine/home/home_far_copy.asm').read_text()
for token in ('section "Banked ROM Copy", rom0[$0150]','FarCopy_ToVRAM::','call MemcpyWaitLCD','assert @ == $0166'):
    require(token in far, f'missing far-copy source token: {token}')

# Resolve numeric constants used by the structured unit table.
constants={m.group(1):int(m.group(2),16) for m in re.finditer(r'^DEF\s+(\w+)\s+EQU\s+\$([0-9a-fA-F]+)', const_text, re.M)}
def value(tok):
    tok=tok.strip()
    if tok.startswith('$'): return int(tok[1:],16)
    if tok.isdigit(): return int(tok)
    require(tok in constants, f'unknown table constant: {tok}')
    return constants[tok]

# 223 animation far pointers, symbolically connected to the typed animation streams.
anim_labels={}
for m in re.finditer(r'^SpriteAnimation_(\d{3}):: ; \$([0-9A-Fa-f]{2}):\$([0-9A-Fa-f]{4})$', anim_text, re.M):
    anim_labels[int(m.group(1))]=(int(m.group(2),16), int(m.group(3),16))
require(len(anim_labels)==223, f'expected 223 animation labels, got {len(anim_labels)}')
ptr_ids=[int(m.group(1)) for m in re.finditer(r'^\s*sprite_farptr\s+SpriteAnimation_(\d{3})(?:\s*;.*)?$', src, re.M)]
require(ptr_ids==list(range(223)), 'animation pointer table is not the ordered SpriteAnimation_000..222 sequence')
ptr_bytes=bytearray()
for i in ptr_ids:
    bank, ptr=anim_labels[i]
    ptr_bytes += bytes((ptr & 0xff, ptr >> 8, bank))
require(bytes(ptr_bytes)==rom_chunk(0x1A,0x65D8,0x6875),'animation far-pointer table differs from retail ROM')

# 30 graphics group descriptors.
grp_bytes=bytearray()
for m in re.finditer(r'^\s*sprite_group\s+([^,]+),\s*([^,]+),\s*([^,]+),\s*([^,]+),\s*([^;\s]+)', src, re.M):
    vals=[value(m.group(i)) for i in range(1,6)]
    for v in vals[:4]: grp_bytes += bytes((v & 0xff, (v>>8)&0xff))
    grp_bytes.append(vals[4])
require(len(grp_bytes)==30*9, f'expected 30 sprite groups, got {len(grp_bytes)//9}')
require(bytes(grp_bytes)==rom_chunk(0x1A,0x6875,0x6983),'sprite group table differs from retail ROM')

# 52 unit-to-(group, animation) mappings.
unit_bytes=bytearray()
for m in re.finditer(r'^\s*unit_sprite\s+([^,]+),\s*([^;\s]+)', src, re.M):
    unit_bytes += bytes((value(m.group(1)), value(m.group(2))))
require(len(unit_bytes)==52*2, f'expected 52 unit sprite mappings, got {len(unit_bytes)//2}')
require(bytes(unit_bytes)==rom_chunk(0x1A,0x6983,0x69EB),'unit sprite table differs from retail ROM')

# Eight fallback OBJ palettes (64 bytes).
pal_start=src.index('SpriteGroup_FallbackPalettes::')
pal_text=src[pal_start:]
pal=bytearray()
for line in pal_text.splitlines()[1:]:
    if line.strip().startswith('assert '): break
    code=line.split(';',1)[0].strip()
    if code.startswith('db '):
        for x in code[3:].split(','): pal.append(value(x))
require(len(pal)==64, f'expected 64 fallback palette bytes, got {len(pal)}')
require(bytes(pal)==rom_chunk(0x1A,0x69EB,0x6A2B),'fallback palettes differ from retail ROM')

print('sprite data provider: ROM0 $0150 and Bank $1A provider routines verified')
print('tables: 223 animation pointers, 30 graphics groups, 52 unit mappings, 8 fallback palettes [ok]')
