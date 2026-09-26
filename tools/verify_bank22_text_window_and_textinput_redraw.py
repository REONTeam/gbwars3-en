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

RANGES = [
    (0x22, 0x6247, 0x626D, "Bank $22 window frame/attribute helper", "93e52f0796a980a129452a2d464a4c029bbe24e2"),
    (0x22, 0x626D, 0x6362, "Bank $22 game-code/Shift-JIS runtime", "9c67207837929a4786e4848094e2f8cf953eac3d"),
    (0x22, 0x7514, 0x7714, "Bank $22 game-code/Shift-JIS table", "8f0337696e7eec6036cd1192da6c4ca37990648e"),
    (0x14, 0x5245, 0x52B6, "Bank $14 text-input redraw runtime", "ee48ed2c0eafc5e8a5a78b5907964404031d165d"),
    (0x14, 0x531E, 0x531F, "Bank $14 text-input redraw return", "964992fde30239af2636655e58d714e73d8b5050"),
]

PUBLIC_SYMBOLS = {
    "UIWindow_DrawFrameAndClearInteriorAttributes": (0x22, 0x6247),
    "Text_GetShiftJISForGameCode": (0x22, 0x626D),
    "Text_FindGameCodeForShiftJIS": (0x22, 0x627F),
    "Text_ConvertGameCodeToShiftJISStream": (0x22, 0x62AA),
    "Text_AppendShiftJISCode": (0x22, 0x62EA),
    "Text_GameCodeToShiftJISTable": (0x22, 0x7514),
    "TextInput_RedrawCurrentValue": (0x14, 0x5245),
    "TextInput_RedrawReturn": (0x14, 0x531E),
}

WINDOW_CALLERS = [
    ROOT / "engine/battle/battle_combat_runtime.asm",
    ROOT / "engine/map/map_menu.asm",
    ROOT / "engine/map/ai/map_control_opponent_cancel_prompt_6f1e.asm",
]


def must(cond: bool, msg: str) -> None:
    if not cond:
        raise SystemExit(f"FAIL: {msg}")


def bank_offset(bank: int, address: int) -> int:
    return bank * 0x4000 + (address - 0x4000)


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

    for bank, start, end, desc, expected_sha1 in RANGES:
        off = bank_offset(bank, start)
        source = retail[off:off + end - start]
        output = built[off:off + end - start]
        got = hashlib.sha1(source).hexdigest()
        must(got == expected_sha1, f"retail fingerprint changed for {desc}: {got}")
        must(output == source, f"built bytes differ from retail for {desc}")
        print(f"PASS {bank:02X}:{start:04X}-{end - 1:04X} {end-start} bytes SHA-1 {got}")

    custom_sha = hashlib.sha256(built).hexdigest()
    must(custom_sha == CANONICAL_CUSTOM_SHA256,
         f"custom-English ROM hash drift: {custom_sha}")
    print(f"PASS custom-English SHA-256 {custom_sha}")

    syms = parse_sym()
    for name, expected in PUBLIC_SYMBOLS.items():
        must(syms.get(name) == expected,
             f"{name} expected {expected[0]:02X}:{expected[1]:04X}, got {syms.get(name)}")
    print("PASS public Bank $22/$14 entry addresses")

    window_src = (ROOT / "engine/ui/window_frame_attribute_helper_bank22.asm").read_text(encoding="utf-8")
    for token in [
        "UIWindow_DrawFrameAndClearInteriorAttributes::",
        "farcall UIWindow_DrawFrame",
        "farcall Gfx_TilemapFill",
        "assert @ == $626d",
    ]:
        must(token in window_src, f"missing Bank $22 window-helper source token: {token}")

    text_src = (ROOT / "engine/network/bank22_game_code_shift_jis.asm").read_text(encoding="utf-8")
    for token in [
        "Text_GetShiftJISForGameCode::",
        "Text_FindGameCodeForShiftJIS::",
        "Text_ConvertGameCodeToShiftJISStream::",
        "Text_AppendShiftJISCode:",
        "Text_GameCodeToShiftJISTable::",
        "assert @ == $6362",
        "assert @ == $7714",
    ]:
        must(token in text_src, f"missing Bank $22 text-conversion source token: {token}")

    # The 256 source words must exactly reconstruct the retail lookup table.
    words = [int(x, 16) for x in re.findall(r"\$([0-9a-fA-F]{4})", text_src.split("Text_GameCodeToShiftJISTable::", 1)[1])]
    words = words[:256]
    must(len(words) == 256, f"expected 256 Shift-JIS table words, found {len(words)}")
    encoded = b"".join(w.to_bytes(2, "little") for w in words)
    off = bank_offset(0x22, 0x7514)
    must(encoded == retail[off:off + 512], "source Shift-JIS table words differ from retail")
    print("PASS 256-entry game-code/Shift-JIS table reconstruction")

    window_calls = 0
    offenders: list[str] = []
    for path in WINDOW_CALLERS:
        text = path.read_text(encoding="utf-8", errors="replace")
        window_calls += text.count("farcall UIWindow_DrawFrameAndClearInteriorAttributes")
        for lineno, line in enumerate(text.splitlines(), 1):
            code = line.split(";", 1)[0]
            if re.search(r"farcall\s+\$22\s*,\s*\$6247\b", code, re.I):
                offenders.append(f"{path.relative_to(ROOT)}:{lineno}: {line.strip()}")
    must(window_calls == 4, f"expected four symbolic readable $22:$6247 callers, found {window_calls}")
    must(not offenders, "raw $22:$6247 farcalls remain in readable caller set:\n" + "\n".join(offenders))
    print("PASS four readable Bank $22 window-helper callers are symbolic")

    map_name = (ROOT / "engine/map/map_name_9char.asm").read_text(encoding="utf-8", errors="replace")
    must(map_name.count("farcall TextInput_RedrawCurrentValue") == 4,
         "expected four symbolic map-name redraw calls")
    must(not re.search(r"farcall\s+\$14\s*,\s*\$5245\b", map_name, re.I),
         "raw $14:$5245 call remains in map_name_9char.asm")
    print("PASS four map-name redraw callers are symbolic")

    redraw_src = (ROOT / "engine/ui/text_input_redraw_runtime_5245.asm").read_text(encoding="utf-8")
    for token in [
        "TextInput_RedrawCurrentValue::",
        "jr z, TextInput_MapNameRedrawHook",
        "call VBlankFIFO_Queue",
        "call TextPut",
        "TextInput_RedrawReturn::",
    ]:
        must(token in redraw_src, f"missing Bank $14 redraw source token: {token}")

    # The forward boundary remains the custom mode-2 hook, not absorbed retail bytes.
    must(syms.get("TextInput_MapNameRedrawHook") == (0x14, 0x52B6),
         "TextInput_MapNameRedrawHook moved from $14:$52B6")
    print("PASS Bank $14 mode-2 hook boundary remains $52B6")
    print("Bank $22 text/window + Bank $14 text-input redraw verification: PASS")


if __name__ == "__main__":
    main()
