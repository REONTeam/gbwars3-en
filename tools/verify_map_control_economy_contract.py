#!/usr/bin/env python3
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
mapc = (ROOT / "constants/map_constants.inc").read_text()
sym = (ROOT / "symbols.asm").read_text()
source = (ROOT / "engine/map/ai/map_control_force.asm").read_text()
doc = (ROOT / "docs/map/map_control_economy_contract.md").read_text()

required_constants = {
    "MAP_PLAYER_CONTROL_HUMAN": 0,
    "MAP_PLAYER_CONTROL_CPU": 1,
    "MAP_PHASES_PER_DAY": 2,
    "MAP_PHASE_ACTIVE_SIDE_MASK": 1,
    "MAP_GOLD_SIZE": 3,
    "MAP_MATERIALS_SIZE": 2,
    "MAP_GOLD_INCOME_SIZE": 2,
    "MAP_MATERIALS_INCOME_SIZE": 2,
    "MAP_HQ_COORD_SIZE": 2,
}
for name, value in required_constants.items():
    assert re.search(rf"DEF\s+{name}\s+EQU\s+(?:\$0*{value:x}|{value})\b", mapc, re.I), name

addresses = {
    "wMapSide0Control": 0xC631,
    "wMapSide1Control": 0xC632,
    "wMapPhaseNumber": 0xC633,
    "wMapSide0Gold": 0xC634,
    "wMapSide1Gold": 0xC637,
    "wMapSide0Materials": 0xC63A,
    "wMapSide1Materials": 0xC63C,
    "wMapSide0GoldIncomeDiv10": 0xC63E,
    "wMapSide1GoldIncomeDiv10": 0xC640,
    "wMapSide0MaterialsIncome": 0xC642,
    "wMapSide1MaterialsIncome": 0xC644,
    "wMapSide0HQCoordinates": 0xC646,
    "wMapSide1HQCoordinates": 0xC648,
    "wMapControlEconomyEnd": 0xC64A,
}
for name, addr in addresses.items():
    assert re.search(rf"^{name}\s+equ\s+\${addr:04x}\s*$", sym, re.I | re.M), name

# Exact side-pair geometry and exclusive end.
assert addresses["wMapSide1Gold"] - addresses["wMapSide0Gold"] == 3
assert addresses["wMapSide0Materials"] - addresses["wMapSide1Gold"] == 3
assert addresses["wMapSide1Materials"] - addresses["wMapSide0Materials"] == 2
assert addresses["wMapSide0GoldIncomeDiv10"] - addresses["wMapSide1Materials"] == 2
assert addresses["wMapSide1GoldIncomeDiv10"] - addresses["wMapSide0GoldIncomeDiv10"] == 2
assert addresses["wMapSide0MaterialsIncome"] - addresses["wMapSide1GoldIncomeDiv10"] == 2
assert addresses["wMapSide1MaterialsIncome"] - addresses["wMapSide0MaterialsIncome"] == 2
assert addresses["wMapSide0HQCoordinates"] - addresses["wMapSide1MaterialsIncome"] == 2
assert addresses["wMapSide1HQCoordinates"] - addresses["wMapSide0HQCoordinates"] == 2
assert addresses["wMapControlEconomyEnd"] - addresses["wMapSide0Control"] == 25

anchors = [
    (0x12, 0x411B, "MapEconomy_InitializeStartingResources"),
    (0x12, 0x415F, "MapEconomy_StoreStartingGold"),
    (0x12, 0x416D, "MapEconomy_StoreStartingMaterials"),
]
for bank, addr, label in anchors:
    assert re.search(rf"sym\s+\${bank:02x},\s+\${addr:04x},\s+{label}\b", sym, re.I), label
assert 'romx[$6618], bank[$0d]' in source
assert 'MapControl_InitializePlayers::' in source

for phrase in ["25 bytes", "phase / 2 + 1", "phase & 1", "x1000", "x10", "side 0", "side 1"]:
    assert phrase in doc, phrase

print("[ok] map control/economy contract: $C631-$C649 / 25 bytes; paired control/resources/income/HQ state")
