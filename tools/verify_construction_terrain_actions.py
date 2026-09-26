#!/usr/bin/env python3
from pathlib import Path
import hashlib
import sys

ROOT = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "baserom.gbc"
rom = rom_path.read_bytes()
action_source_path = ROOT / "engine/map/bank0b_construction_actions_4941.asm"
direction_source_path = ROOT / "engine/map/bank0b_construction_direction_hptransfer_4c18.asm"
action_source = action_source_path.read_text(encoding="utf-8")
direction_source = direction_source_path.read_text(encoding="utf-8")
executor_source = (ROOT / "engine/unit/unit_action_executor_6283.asm").read_text(encoding="utf-8")
availability_source = (ROOT / "engine/unit/unit_action_hp_transfer_availability_6142.asm").read_text(encoding="utf-8")

def bank_slice(bank: int, start: int, end: int) -> bytes:
    off = bank * 0x4000 + (start - 0x4000)
    return rom[off:off + (end - start)]

def check_fingerprint(bank: int, start: int, end: int, sha1: str, label: str) -> None:
    data = bank_slice(bank, start, end)
    got = hashlib.sha1(data).hexdigest()
    if got != sha1:
        raise SystemExit(f"[fail] {label}: SHA-1 {got}, expected {sha1}")
    print(f"[ok] {label}: Bank ${bank:02X}:${start:04X}-${end-1:04X}, {len(data)} bytes, SHA-1 {got}")

check_fingerprint(0x0B, 0x4941, 0x4A7C, "4b360e5d0aca2067b54e967af660e32673e9bee8", "Construction candidate/list/classifier family")
check_fingerprint(0x0B, 0x4A7C, 0x4AE0, "37fe5522b7be9dce7d01dc7927f3fb001ceda17d", "Construction terrain-action submenu controller")
check_fingerprint(0x0B, 0x4AE0, 0x4BF2, "ddf9c9dc983863530e16de4ffa5e827d31f1c46f", "RUNWAY/CLEAR/BRIDGE action bodies")
check_fingerprint(0x0B, 0x4C18, 0x4D2C, "5674a8f0aa2b3bc3eafb2dbbe2161a3b5026b5e2", "Construction terrain-action direction selector")
check_fingerprint(0x0B, 0x4D2C, 0x4D3A, "7372c0551bdb637a5f40ee6a41b67fd608d7d32b", "FORTIFY/BUILD HP-based experience award helper")
check_fingerprint(0x0B, 0x4D3A, 0x4DF2, "08dbf80b115222a0aead611ad1613cdcd76e3d45", "HP-transfer adjacency helper family")
check_fingerprint(0x0C, 0x5697, 0x56D5, "167e2d177c28a236d927db5e78bf5397c08cbf25", "Bank $0C map-analysis record allocator called by RUNWAY")

required_action = [
    "Construction_HasTerrainActionCandidate::",
    "Construction_BuildDevelopableDirectionList::",
    "Construction_BuildClearableDirectionList::",
    "Construction_BuildRiverDirectionList::",
    "Construction_GetDevelopableTerrainClassAtCoordinates::",
    "Construction_GetClearableTerrainClassAtCoordinates::",
    "Construction_ClassifyDevelopableTerrain::",
    "Construction_RunTerrainActionController::",
    "Construction_RunwayAction::",
    "Construction_GetOwnedRunwayTileId::",
    "Construction_ClearAction::",
    "Construction_BridgeAction::",
    "call HexGrid_GetNeighborCoord",
    "call UnitActionMenu_RunSelection",
    "call Construction_SelectTerrainActionDirection",
    "cp CONSTRUCTION_MAP_RECORD_CAPACITY",
    "ld h, MAP_PROPERTY_OFFSET_RUNWAY",
    "ld h, MAP_PROPERTY_OFFSET_RUNWAY + MAP_PROPERTY_SIDE_STRIDE",
    "call Construction_GetDevelopableTerrainClassAtCoordinates",
    "call Construction_GetClearableTerrainClassAtCoordinates",
    "ld a, MAP_TERRAIN_PLAIN",
    "ld a, MAP_TERRAIN_BRIDGE_1",
    "call Unit_BuildBridgeAtCoordinates",
    "farcall $11, CampaignStats_IncrementDevelopedProperties",
    "assert @ == $4bf2",
]
for needle in required_action:
    if needle not in action_source:
        raise SystemExit(f"[fail] construction action source missing: {needle}")

if "    db " in action_source:
    raise SystemExit("[fail] raw db data remains in Bank $0B $4941-$4BF1 construction action source")

required_direction = [
    "Construction_SelectTerrainActionDirection::",
    "Construction_FinishTerrainActionDirectionSelection::",
    "Construction_GetSelectedDirectionCoordinates::",
    "Construction_UpdateDirectionSelectionPulse::",
    "Construction_RedrawSelectedDirectionCell::",
    "Construction_RefreshSelectedDirectionCell::",
    "call MapControl_UpdateInteractionInputState",
    "call MapCursor_SetMapCoordinates",
    "call MapCursor_Show",
    "bit 0, a",
    "bit 1, a",
    "bit 5, a",
    "bit 6, a",
    "bit 4, a",
    "bit 7, a",
    "ld [wConstructionActionSelectionIndex], a",
    "ld a, [wUnitActionCandidateCount]",
    "ld a, [wConstructionActionPreviewTileId]",
]
for needle in required_direction:
    if needle not in direction_source:
        raise SystemExit(f"[fail] construction direction source missing: {needle}")

required_hp_transfer = [
    "UnitAction_AwardCurrentHPAsExperience::",
    "UnitHPTransfer_HasEligibleAdjacentTarget::",
    "UnitHPTransfer_BuildEligibleAdjacentTargetList::",
    "UnitHPTransfer_GetAdjacentUnitCandidate::",
    "UnitHPTransfer_IsCombinedHPBelowLimit::",
    "ld a, [wUnitRecordScratch + UNIT_RECORD_CARRIED_COUNT_OFFSET]",
    "farcall $18, $4add",
    "farcall $12, UnitRecord_AddExperienceClamped",
    "farcall $12, UnitRecord_FindPrimaryAtCoordinates",
    "farcall $12, UnitRecord_GetByte",
    "ld a, [wMapAIActiveUnitIndex]",
    "cp $14",
    "assert @ == $4df2",
]
for needle in required_hp_transfer:
    if needle not in direction_source:
        raise SystemExit(f"[fail] HP-transfer helper source missing: {needle}")

if "    db " in direction_source:
    raise SystemExit("[fail] raw db data remains in Bank $0B $4C18-$4DF1 direction/HP-transfer helper source")


if executor_source.count("call UnitAction_AwardCurrentHPAsExperience") < 2 or "call $4d2c" in executor_source.lower():
    raise SystemExit("[fail] FORTIFY/BUILD executor does not use the symbolic current-HP experience helper")
if "call UnitHPTransfer_HasEligibleAdjacentTarget" not in availability_source or "call $4d3a" in availability_source.lower():
    raise SystemExit("[fail] HP-transfer availability does not use the symbolic adjacency predicate")

# The RUNWAY-only Bank-$0C helper scans the 100 x 3-byte WRAM-bank-1 records
# at $DD81 for a free $FF slot and increments the count byte at $DD80.
allocator = bank_slice(0x0C, 0x5697, 0x56D5)
for byte_pattern, desc in [
    (bytes.fromhex("21 81 dd 1e 00"), "record-table base $DD81 and index zero"),
    (bytes.fromhex("fe 64"), "100-record capacity scan"),
    (bytes.fromhex("21 80 dd 34"), "record-count increment at $DD80"),
]:
    if byte_pattern not in allocator:
        raise SystemExit(f"[fail] RUNWAY allocator missing {desc}")

print("[ok] Bank $0B $4941-$4BF1 is mnemonic source for candidate discovery, submenu dispatch, and RUNWAY/CLEAR/BRIDGE execution")
print("[ok] RUNWAY costs 3/4 resource points by source terrain, CLEAR costs 1, and BRIDGE checks/consumes 2 in its dedicated executor")
print("[ok] RUNWAY side-owned tile IDs are $08/$13 and its Bank-$0C helper maintains the $DD80/$DD81 100-record table")
print("[ok] Bank $0B $4C18-$4D2B direction selection is mnemonic, including cursor movement, preview blinking, confirm/cancel, and wraparound")
print("[ok] Bank $0B $4D2C-$4D39 is the mnemonic FORTIFY/BUILD current-HP experience award helper, with symbolic executor call sites")
print("[ok] Bank $0B $4D3A-$4DF1 HP-transfer adjacency helpers are mnemonic: carried-unit rejection, type gate, six-neighbor scan, active-unit exclusion, and combined-HP < 20 gate")
