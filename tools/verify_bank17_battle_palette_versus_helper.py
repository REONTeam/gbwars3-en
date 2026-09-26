#!/usr/bin/env python3
from pathlib import Path
import hashlib, re

ROOT = Path(__file__).resolve().parents[1]
BANK = 0x17
ROM_HASH = "e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059"
RANGES = [
    (0x72DB, 0x731B, "ce7eec01ad480739eafd7bbb1d84f74ff9edb94d", "battle-place animated palette rows"),
    (0x731B, 0x7346, "ff7516ad0959d890ac89086eaa4ed6a2d02d8d6c", "Versus setup divider-row helper"),
]
GAP_START, GAP_END = 0x72D3, 0x72DB
GAP_SHA1 = "f72a0a994a7d5b2fb0d024e865cd30708739ddb0"


def bank_slice(blob: bytes, start: int, end: int) -> bytes:
    off = BANK * 0x4000 + (start - 0x4000)
    return blob[off:off + (end - start)]


def main() -> None:
    base_path = ROOT / "baserom.gbc"
    out_path = ROOT / "GBWARS3.gbc"
    if not base_path.is_file() or not out_path.is_file():
        raise SystemExit("[fail] baserom.gbc and GBWARS3.gbc are required")
    retail = base_path.read_bytes()
    built = out_path.read_bytes()

    for start, end, expected, name in RANGES:
        r = bank_slice(retail, start, end)
        b = bank_slice(built, start, end)
        if hashlib.sha1(r).hexdigest() != expected:
            raise SystemExit(f"[fail] retail fingerprint mismatch for {name}")
        if b != r:
            raise SystemExit(f"[fail] built bytes differ from retail for {name}")

    if hashlib.sha256(built).hexdigest() != ROM_HASH:
        raise SystemExit("[fail] custom-English ROM hash drift")

    gap = bank_slice(retail, GAP_START, GAP_END)
    if hashlib.sha1(gap).hexdigest() != GAP_SHA1:
        raise SystemExit("[fail] $72D3-$72DA boundary bytes changed in retail reference")

    battle = (ROOT / "engine/battle/battle_place_graphics.asm").read_text()
    versus_helper = (ROOT / "engine/versus/versus_bank17_ui_helpers.asm").read_text()
    versus = (ROOT / "engine/versus/versus_setup_runtime.asm").read_text()

    required_battle = [
        'section "Battle Place Palette Animation Rows", romx[$72db], bank[$17]',
        'BattlePlacePaletteAnimationRows::',
        'assert @ == $731b',
        'ld bc, BattlePlacePaletteAnimationRows',
    ]
    for token in required_battle:
        if token not in battle:
            raise SystemExit(f"[fail] missing battle-place source token: {token}")
    if battle.count('ld bc, BattlePlacePaletteAnimationRows') != 2:
        raise SystemExit("[fail] both battle-place palette animators must use the named table")

    required_helper = [
        'section "Versus Setup Bank17 UI Helper", romx[$731b], bank[$17]',
        'VersusSetup_DrawDividerRow::',
        'ld bc, $000e',
        'ld a, $10',
        'ld a, $08',
        'assert @ == $7346',
    ]
    for token in required_helper:
        if token not in versus_helper:
            raise SystemExit(f"[fail] missing Versus helper token: {token}")

    if versus.count('farcall VersusSetup_DrawDividerRow') != 6:
        raise SystemExit("[fail] expected six symbolic Versus divider-row calls")
    if re.search(r'\$17\s*,\s*\$731b|\$17\s*,\s*\$1b73', versus, re.I):
        raise SystemExit("[fail] raw $17:$731B caller remains in Versus setup source")

    # The preceding eight bytes are intentionally outside any new fixed section.
    combined = battle + "\n" + versus_helper
    if re.search(r'romx\[\$72d3\]', combined, re.I):
        raise SystemExit("[fail] unproven $72D3-$72DA bytes were accidentally claimed")

    print('[ok] Bank $17:$72DB-$731A eight-row battle-place palette-animation table matches retail')
    print('[ok] Bank $17:$731B-$7345 Versus setup divider-row helper matches retail')
    print('[ok] six Bank $18 Versus setup calls use VersusSetup_DrawDividerRow symbolically')
    print('[ok] Bank $17:$72D3-$72DA remains deliberately unclaimed')
    print('[ok] custom-English ROM SHA-256 unchanged')


if __name__ == '__main__':
    main()
