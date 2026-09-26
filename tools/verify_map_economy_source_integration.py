#!/usr/bin/env python3
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
ASM_ROOTS = [ROOT / "engine", ROOT / "data", ROOT / "audio"]

# the current source promotes the current source map control/economy RAM contract into all
# already-sourced consumers. No direct literal in $C631-$C649 should remain in
# source modules; future code should use the shared symbols instead.
raw = re.compile(r"\$c6(?:3[1-9a-f]|4[0-9])\b", re.I)
hits = []
for base in ASM_ROOTS:
    for path in sorted(base.rglob("*.asm")):
        for lineno, line in enumerate(path.read_text().splitlines(), 1):
            if raw.search(line):
                hits.append(f"{path.relative_to(ROOT)}:{lineno}: {line.strip()}")
assert not hits, "raw map control/economy RAM literals remain:\n" + "\n".join(hits)

checks = {
    "engine/map/map_menu.asm": ["[wMapPhaseNumber]"],
    "engine/home/home_map.asm": ["[wMapPhaseNumber]"],
    "engine/map/map_runtime.asm": ["ld hl, wMapSide1HQCoordinates"],
    "engine/map/map_sram.asm": [
        "[wMapPhaseNumber]",
        "[wMapSide0Gold]", "[wMapSide0Gold + 1]", "[wMapSide0Gold + 2]",
        "[wMapSide1Gold]", "[wMapSide1Gold + 1]", "[wMapSide1Gold + 2]",
        "[wMapSide0Materials]", "[wMapSide0Materials + 1]",
        "[wMapSide1Materials]", "[wMapSide1Materials + 1]",
    ],
}
for rel, needles in checks.items():
    text = (ROOT / rel).read_text()
    for needle in needles:
        assert needle in text, f"missing {needle!r} from {rel}"

# Save and load must both use each multi-byte resource field symbolically.
sram = (ROOT / "engine/map/map_sram.asm").read_text()
for needle in [
    "wMapSide0Gold", "wMapSide1Gold",
    "wMapSide0Materials", "wMapSide1Materials",
]:
    assert sram.count(needle) >= 2, f"{needle} is not represented in both serializer/deserializer paths"

print("[ok] map economy source integration: all sourced $C631-$C649 consumers are symbolic")
