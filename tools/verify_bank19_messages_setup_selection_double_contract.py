#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys

ROOT = Path(__file__).resolve().parents[1]
RETAIL = ROOT / "baserom.gbc"
BUILT = ROOT / "GBWARS3.gbc"
SOURCE = ROOT / "engine/network/bank19_network_messages_tail.asm"
BANK = 0x19
CONTRACTS = [
    (0x7938, 0x7A32, "0af893e213abb7ccfcd913d36f94a22c5b713885", "Messages setup/presentation"),
    (0x7A32, 0x7AB2, "64d5bd6b1d83b5d524879bbea82774eed12626ba", "Messages selection/helper"),
]
REQUIRED = [
    "NetworkMessages_SetupScreen::",
    "NetworkMessages_UpdateSelectionDisplay::",
    "NetworkMessages_ShowPrimarySelectionCursor::",
    "NetworkMessages_HidePrimarySelectionCursor::",
    "NetworkMessages_ShowSecondarySelectionCursor::",
    "NetworkMessages_HideSecondarySelectionCursor::",
    "NetworkMessages_PrepareInteractiveController::",
    "assert @ == $7a32",
    "assert @ == $7ab2",
]

def rom_offset(addr: int) -> int:
    return BANK * 0x4000 + (addr - 0x4000)

def fail(msg: str) -> None:
    print(f"FAIL - {msg}")
    raise SystemExit(1)

def main() -> None:
    if not RETAIL.exists(): fail("baserom.gbc is required")
    if not BUILT.exists(): fail("GBWARS3.gbc is required")
    retail = RETAIL.read_bytes()
    built = BUILT.read_bytes()
    for start, end, expected, name in CONTRACTS:
        s, e = rom_offset(start), rom_offset(end)
        blob = retail[s:e]
        digest = hashlib.sha1(blob).hexdigest()
        if digest != expected:
            fail(f"{name}: retail SHA-1 {digest} != {expected}")
        if built[s:e] != blob:
            fail(f"{name}: built bytes differ from retail")
        print(f"PASS - {name}: {end-start} bytes, SHA-1 {digest}")

    src = SOURCE.read_text(encoding="utf-8")
    for needle in REQUIRED:
        if needle not in src: fail(f"missing source marker: {needle}")
    owned = src.split("NetworkMessages_Runtime::",1)[1].split("NetworkMessages_StateCommonReturn::",1)[0]
    if re.search(r"(?m)^\s*db\s+", owned):
        fail("raw db remains inside the newly mnemonic $7938-$7AB1 ownership")
    print("PASS - $7938-$7AB1 contains no raw db executable block")

    numeric = re.compile(r"\bfarcall\s+\$[0-9A-Fa-f]{1,2}\s*,\s*\$[0-9A-Fa-f]{4}\b")
    hits = []
    for path in ROOT.rglob("*.asm"):
        for lineno, line in enumerate(path.read_text(errors="replace").splitlines(), 1):
            if numeric.search(line): hits.append(f"{path.relative_to(ROOT)}:{lineno}")
    if hits: fail("raw numeric farcall remains: " + ", ".join(hits[:5]))
    print("PASS - project-wide raw numeric farcall audit: 0")

    source_dirs = [ROOT / name for name in ("engine", "data", "audio", "source")]
    modules = [p for d in source_dirs if d.exists() for p in d.rglob("*.asm")]
    makefile = (ROOT / "Makefile").read_text(encoding="utf-8")
    objs = set(re.findall(r"\b(?:engine|data|audio|source)/[A-Za-z0-9_./-]+\.o\b", makefile))
    source_count = len(modules) + (1 if (ROOT / "symbols.asm").exists() else 0)
    object_count = len(objs) + (1 if re.search(r"\bsymbols\.o\b", makefile) else 0)
    if object_count != source_count:
        fail(f"Makefile object/source inventory {object_count} / {source_count}")
    print(f"PASS - Makefile object/source inventory: {object_count} / {source_count}")

    digest = hashlib.sha256(built).hexdigest()
    expected_custom = "e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059"
    if digest != expected_custom: fail(f"custom-English ROM SHA-256 changed: {digest}")
    print(f"PASS - corrected custom-English ROM SHA-256: {digest}")

if __name__ == "__main__":
    main()
