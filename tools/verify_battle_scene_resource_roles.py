#!/usr/bin/env python3
from pathlib import Path
import re

src = Path("engine/battle/battle_scene_setup.asm").read_text()
unit = Path("engine/unit/unit_setup.asm").read_text()
symbols = Path("symbols.asm").read_text()

# the current source: the already-source-backed setup callers establish renderer roles.
roles = {
    "BattleScene_RenderResourceSide0Facing": 4,
    "BattleScene_RenderResourceSide1Facing": 3,
    "BattleScene_RenderResourceFamily2Centered": 2,
    "BattleScene_RenderResourcePhase1Side0": 1,
}
for label, count in roles.items():
    assert f"{label}::" in src, f"missing semantic renderer label {label}"
    assert src.count(f"HIGH({label})") == count, (label, "HIGH", src.count(f"HIGH({label})"), count)
    assert src.count(f"LOW({label})") == count, (label, "LOW", src.count(f"LOW({label})"), count)
    assert src.count(f"BANK({label})") == count, (label, "BANK", src.count(f"BANK({label})"), count)

# Semantic resource scripts/selectors stay paired with their renderer roles.
for label in [
    "BattleSceneResourceAnimSide0Facing", "BattleSceneResourceAnimSide1Facing",
    "BattleSceneResourceAnimFamily2Centered", "BattleSceneResourceAnimPhase1Side0",
    "BattleScene_SelectResourceSide0Facing", "BattleScene_SelectResourceSide1Facing",
    "BattleScene_SelectResourceFamily2Centered", "BattleScene_SelectResourcePhase1Side0",
]:
    assert f"{label}::" in src, f"missing {label}"

# The ten dynamic continuation writes cover the exact proven caller split:
# side-0 facing x4, side-1 facing x3, centered family-2 x2, phase-1 side-0 x1.
assert sum(roles.values()) == 10

assert "UnitRecord_FindPrimaryAtCoordinates::" in unit
assert "sym $12, $414e, UnitRecord_FindPrimaryAtCoordinates" not in symbols

# No raw continuation-address triples for the four renderer entries may return
# to the setup layer; callers should follow labels when ranges move/refactor.
setup = src.split('section "Battle Scene Resource Selection Helpers"', 1)[0]
for hi, lo in [(0x51,0xE3),(0x52,0x65),(0x52,0xE7),(0x53,0x5F)]:
    raw = f"ld a, ${hi:02x}\n    ld [$c4d5], a\n    ld a, ${lo:02x}\n    ld [$c4d6], a\n    ld a, $18\n    ld [$c4d7], a"
    assert raw not in setup, f"raw renderer continuation ${hi:02X}{lo:02X} reintroduced"

print("PASS: battle-scene renderer caller roles are symbolic and source-backed")
print("PASS: caller split = side0-facing 4, side1-facing 3, family2-centered 2, phase1-side0 1")
