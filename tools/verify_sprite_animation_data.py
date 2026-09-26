#!/usr/bin/env python3
"""Verify structured sprite animation/frame source against the Japanese baserom."""
from __future__ import annotations
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "engine" / "sprite" / "sprite_animation_data.asm"
POINTER_SOURCE = ROOT / "engine" / "sprite" / "sprite_data.asm"

SECTION_RE = re.compile(r'^section .*romx\[\$([0-9a-f]+)\], bank\[\$([0-9a-f]+)\]$', re.I)
FRAME_LABEL_RE = re.compile(r'^SpriteFrame_([0-9A-F]{2})_([0-9A-F]{4})::$')
ANIM_LABEL_RE = re.compile(r'^SpriteAnimation_(\d{3}):: ; \$([0-9A-F]{2}):\$([0-9A-F]{4})$')
ANIM_ALIAS_RE = re.compile(r'^SpriteAnimation_[A-Za-z][A-Za-z0-9_]*::$')
PIECE_RE = re.compile(r'^sprite_oam_piece \$([0-9a-f]{2}), \$([0-9a-f]{2}), \$([0-9a-f]{2}), \$([0-9a-f]{2})$', re.I)
ENTRY_RE = re.compile(r'^sprite_anim_entry SpriteFrame_([0-9A-F]{2})_([0-9A-F]{4}), \$([0-9a-f]{2})$', re.I)
DB_RE = re.compile(r'^db (\d+)$')
ASSERT_RE = re.compile(r'^assert @ == \$([0-9a-f]+)$', re.I)
PTR_RE = re.compile(r'^sprite_farptr SpriteAnimation_(\d{3})')


def rom_offset(bank: int, addr: int) -> int:
    if not 0x4000 <= addr < 0x8000:
        raise ValueError(f"ROMX address out of range: {bank:02X}:{addr:04X}")
    return bank * 0x4000 + addr - 0x4000


def fail(message: str) -> None:
    print(f"sprite-data audit failed: {message}", file=sys.stderr)
    raise SystemExit(1)


def main() -> None:
    if len(sys.argv) != 2:
        fail("usage: verify_sprite_animation_data.py baserom.gbc")
    rom = Path(sys.argv[1]).read_bytes()
    lines = SOURCE.read_text(encoding="utf-8").splitlines()

    bank = addr = None
    emitted: dict[tuple[int, int], int] = {}
    animations: dict[int, tuple[int, int]] = {}
    frame_labels: set[tuple[int, int]] = set()
    current_frame_expected = None
    current_frame_pieces = 0

    def emit(value: int) -> None:
        nonlocal addr
        if bank is None or addr is None:
            fail("data emitted outside a SECTION")
        key = (bank, addr)
        if key in emitted:
            fail(f"duplicate emitted byte at {bank:02X}:{addr:04X}")
        emitted[key] = value & 0xFF
        addr += 1

    for raw in lines:
        line = raw.strip()
        if not line or line.startswith(';') or line.startswith('macro ') or line == 'endm' or line.startswith('dw \\') or line.startswith('db \\') or (bank is None and line == 'dw 0'):
            continue
        m = SECTION_RE.match(line)
        if m:
            if current_frame_expected is not None and current_frame_pieces != current_frame_expected:
                fail("frame piece count mismatch before SECTION")
            addr, bank = int(m.group(1), 16), int(m.group(2), 16)
            current_frame_expected = None
            continue
        m = FRAME_LABEL_RE.match(line)
        if m:
            lb, la = int(m.group(1),16), int(m.group(2),16)
            if (lb, la) != (bank, addr):
                fail(f"frame label address mismatch: {lb:02X}:{la:04X} != {bank:02X}:{addr:04X}")
            if current_frame_expected is not None and current_frame_pieces != current_frame_expected:
                fail(f"previous frame expected {current_frame_expected} pieces, got {current_frame_pieces}")
            frame_labels.add((lb,la)); current_frame_expected = None; current_frame_pieces = 0
            continue
        if ANIM_ALIAS_RE.match(line):
            continue
        m = ANIM_LABEL_RE.match(line)
        if m:
            if current_frame_expected is not None and current_frame_pieces != current_frame_expected:
                fail(f"previous frame expected {current_frame_expected} pieces, got {current_frame_pieces}")
            i, lb, la = int(m.group(1)), int(m.group(2),16), int(m.group(3),16)
            if (lb, la) != (bank, addr):
                fail(f"animation {i} address mismatch")
            animations[i]=(lb,la); current_frame_expected=None
            continue
        m = DB_RE.match(line)
        if m:
            n=int(m.group(1)); emit(n); current_frame_expected=n; current_frame_pieces=0
            continue
        m = PIECE_RE.match(line)
        if m:
            for g in m.groups(): emit(int(g,16))
            current_frame_pieces += 1
            continue
        m = ENTRY_RE.match(line)
        if m:
            fb, fp, delay = int(m.group(1),16), int(m.group(2),16), int(m.group(3),16)
            if fb != bank:
                fail(f"cross-bank frame pointer in animation at {bank:02X}:{addr:04X}")
            emit(fp & 0xff); emit(fp >> 8); emit(delay)
            continue
        if line == 'sprite_anim_end':
            emit(0); emit(0); continue
        m = ASSERT_RE.match(line)
        if m:
            expected=int(m.group(1),16)
            if addr != expected: fail(f"assert mismatch in parser: got {addr:04X}, expected {expected:04X}")
            continue
        # Ignore prose/comments and macro definitions only; unexpected source syntax is suspicious.
        if line.startswith(('if ', 'else', 'endc')):
            continue
        fail(f"unrecognized source line: {line}")

    if current_frame_expected is not None and current_frame_pieces != current_frame_expected:
        fail(f"final frame expected {current_frame_expected} pieces, got {current_frame_pieces}")

    for (b,a), value in emitted.items():
        actual=rom[rom_offset(b,a)]
        if actual != value:
            fail(f"ROM mismatch at {b:02X}:{a:04X}: source {value:02X}, ROM {actual:02X}")

    if sorted(animations) != list(range(223)):
        fail(f"expected animation labels 000..222, got {len(animations)} labels")

    ptr_ids=[]
    for raw in POINTER_SOURCE.read_text(encoding='utf-8').splitlines():
        m=PTR_RE.match(raw.strip())
        if m: ptr_ids.append(int(m.group(1)))
    if ptr_ids != list(range(223)):
        fail("SpriteAnimationPointers is not a complete ordered 000..222 label table")

    table=rom_offset(0x1a,0x65d8)
    for i in range(223):
        ptr=int.from_bytes(rom[table+i*3:table+i*3+2],'little')
        b=rom[table+i*3+2]
        if animations[i] != (b,ptr):
            fail(f"animation pointer {i} mismatch: source {animations[i]}, ROM {(b,ptr)}")

    print(f"sprite-data audit: 223 animations, {len(frame_labels)} OAM frames, {len(emitted)} typed ROM bytes match baserom")

if __name__ == '__main__':
    main()
