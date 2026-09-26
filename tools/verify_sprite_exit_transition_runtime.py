#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "baserom.gbc"
BUILT = ROOT / "GBWARS3.gbc"
SYM = ROOT / "GBWARS3.sym"
CANONICAL_CUSTOM_SHA256 = "e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059"
BANK = 0x15
START = 0x5CD0
MID = 0x5D1E
END = 0x5D6F
EXPECTED_SHA1 = "1f687e307f6c440459683af576f5f5fca3cf20af"
PUBLIC_SYMBOLS = {
    "SpriteTransition_SlideRightOffscreen": (BANK, START),
    "SpriteTransition_SlideDownOffscreen": (BANK, MID),
}
MNEMONIC_CALLERS = [
    ROOT / "engine/unit/unit_list_runtime_6c72.asm",
    ROOT / "engine/unit/unit_list_action_runtime_70d9.asm",
    ROOT / "engine/unit/unit_list_post_promotion_runtime_734d.asm",
    ROOT / "engine/versus/versus_style_country_runtime.asm",
]


def bank_offset(bank: int, address: int) -> int:
    return bank * 0x4000 + (address - 0x4000)


def must(cond: bool, msg: str) -> None:
    if not cond:
        raise SystemExit(f"FAIL: {msg}")


def parse_sym() -> dict[str, tuple[int, int]]:
    out: dict[str, tuple[int, int]] = {}
    for line in SYM.read_text(encoding="utf-8", errors="replace").splitlines():
        m = re.match(r"^([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4})\s+(\S+)$", line.strip())
        if m:
            out[m.group(3)] = (int(m.group(1), 16), int(m.group(2), 16))
    return out


def main() -> None:
    must(BASE.is_file(), "baserom.gbc is required")
    must(BUILT.is_file(), "GBWARS3.gbc must be built before verification")
    must(SYM.is_file(), "GBWARS3.sym must exist")

    retail = BASE.read_bytes()
    built = BUILT.read_bytes()
    off = bank_offset(BANK, START)
    size = END - START
    retail_range = retail[off:off + size]
    built_range = built[off:off + size]
    must(hashlib.sha1(retail_range).hexdigest() == EXPECTED_SHA1,
         "retail fingerprint changed for Bank $15 sprite-transition family")
    must(built_range == retail_range,
         "built Bank $15:$5CD0-$5D6E bytes differ from retail")
    print(f"PASS 15:5CD0-5D6E {size} bytes SHA-1 {EXPECTED_SHA1}")

    custom_sha = hashlib.sha256(built).hexdigest()
    must(custom_sha == CANONICAL_CUSTOM_SHA256,
         f"custom-English ROM hash drift: {custom_sha}")
    print(f"PASS custom-English SHA-256 {custom_sha}")

    syms = parse_sym()
    for name, expected in PUBLIC_SYMBOLS.items():
        must(syms.get(name) == expected,
             f"{name} expected {expected[0]:02X}:{expected[1]:04X}, got {syms.get(name)}")
    print("PASS public entry addresses $5CD0/$5D1E")

    src = (ROOT / "engine/ui/sprite_exit_transition_runtime.asm").read_text(encoding="utf-8")
    for token in [
        'section "Sprite Exit Transition Runtime", romx[$5cd0], bank[$15]',
        'SpriteTransition_SlideRightOffscreen::',
        'SpriteTransition_SlideDownOffscreen::',
        'assert @ == $5d1e',
        'assert @ == $5d6f',
        'call SpriteObject_DisableAutoAnimation',
        'call SpriteObject_GetField',
        'call SpriteObject_SetPosition',
        'farcall Gfx_UpdateCommonAnimatedTile',
    ]:
        must(token in src, f"missing source contract token: {token}")

    call_count = 0
    offenders: list[str] = []
    for path in MNEMONIC_CALLERS:
        text = path.read_text(encoding="utf-8", errors="replace")
        call_count += text.count("farcall SpriteTransition_SlideRightOffscreen")
        for lineno, line in enumerate(text.splitlines(), 1):
            code = line.split(";", 1)[0]
            if re.search(r"farcall\s+\$15\s*,\s*\$5cd0\b", code, re.I):
                offenders.append(f"{path.relative_to(ROOT)}:{lineno}: {line.strip()}")
    must(call_count == 6, f"expected six symbolic readable callers, found {call_count}")
    must(not offenders, "raw $15:$5CD0 farcalls remain in mnemonic caller set:\n" + "\n".join(offenders))
    print("PASS six readable Unit List/Versus callers are symbolic")

    next_byte = retail[bank_offset(BANK, END)]
    must(next_byte == 0xCD, f"unexpected retail byte at separate $5D6F boundary: {next_byte:02X}")
    print("PASS $15:$5D6F remains outside the transition family")
    print("Sprite exit transition runtime verification: PASS")


if __name__ == "__main__":
    main()
