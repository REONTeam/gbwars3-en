#!/usr/bin/env python3
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
ASM_ROOTS = [ROOT / "engine", ROOT / "data", ROOT / "audio"]

# the current source promotes the current source campaign-statistics RAM contract into all
# already-sourced consumers. New source should use the shared symbols rather
# than direct $C770-$C7B0 literals.
raw = re.compile(r"\$c7(?:7[0-9a-f]|8[0-9a-f]|9[0-9a-f]|a[0-9a-f]|b0)\b", re.I)
hits = []
for base in ASM_ROOTS:
    for path in sorted(base.rglob("*.asm")):
        for lineno, line in enumerate(path.read_text().splitlines(), 1):
            if raw.search(line):
                hits.append(f"{path.relative_to(ROOT)}:{lineno}: {line.strip()}")
assert not hits, "raw campaign-statistics RAM literals remain:\n" + "\n".join(hits)

status = (ROOT / "engine/unit/unit_status.asm").read_text()
assert "ld hl, wCampaignMapClearCounts" in status
assert "ld hl, $c784" not in status.lower()

const = (ROOT / "constants/map_constants.inc").read_text()
for needle in [
    "DEF CAMPAIGN_PROCURED_UNIT_FLAGS_SIZE EQU 7",
    "DEF CAMPAIGN_MAP_CLEAR_COUNT EQU 45",
    "DEF CAMPAIGN_STATISTICS_START EQU $C770",
    "DEF CAMPAIGN_PROCURED_UNIT_FLAGS_START EQU $C77D",
    "DEF CAMPAIGN_MAP_CLEAR_COUNTS_START EQU $C784",
    "DEF CAMPAIGN_STATISTICS_END EQU $C7B0",
]:
    assert needle in const, f"missing campaign geometry constant: {needle}"

# Geometry: 7 procured-unit bytes directly precede 45 one-byte clear counters;
# the complete known workspace spans $C770-$C7B0 inclusive (65 bytes).
assert 0xC784 - 0xC77D == 7
assert 0xC7B0 - 0xC784 + 1 == 45
assert 0xC7B0 - 0xC770 + 1 == 65

symbols = (ROOT / "symbols.asm").read_text().lower()
for needle in [
    "wcampaignprocuredunitflags equ $c77d",
    "wcampaignmapclearcounts equ $c784",
    "wcampaignmapclearcountsend equ $c7b1",
    "wcampaignstatisticsend equ $c7b1",
]:
    assert needle in symbols, f"missing campaign statistics symbol: {needle}"

print("[ok] campaign statistics source integration: $C770-$C7B0 / 65 bytes; 7-byte procured flags + 45 clear counters")
