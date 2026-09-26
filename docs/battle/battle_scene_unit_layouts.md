# Battle-scene UnitData layout table (the project)

Bank `$31:$41EA-$4A49` is the complete UnitData-indexed layout family consumed by the active-slot battle-scene scheduler.

- `$41EA-$4251` is a 52-word pointer table indexed directly by UnitData type `0-51`.
- `UNIT_TYPE_EMPTY` and `UNIT_TYPE_INFANTRY` intentionally share the first physical record at `$4252`.
- The remaining types point to consecutive 40-byte records through `$4A49`, giving 51 unique physical records.
- Each record is two 20-byte halves: side 0, then side 1. Each half contains ten two-byte physical-slot entries.
- `wBattleSceneLayoutUnitType` (`$C4B0`) therefore carries the UnitData type whose ten-slot presentation layout is being scheduled. The older `wBattleSceneResourceClass` name remains only as a compatibility alias.
- `wBattleSceneResourceSide` chooses the 20-byte side half and `wBattleSceneSlotScanIndex` chooses the two-byte slot entry. `BattleScene_GetUnitTypeLayoutEntry` returns that pair in `BC`.

The exact semantic meaning of the two bytes returned for each slot is intentionally left structural in the project. The downstream Bank `$14` controller preserves the pair and later consumes it, but the project does not yet independently prove that the bytes are screen coordinates, tile coordinates, or another two-component layout value.

The UnitData layout family ends cleanly at `$4A49`. the project subsequently identifies `$4A4A-$50F9` as a structured 16x13 tilemap/attribute/81-tile graphics resource and sources the adjacent `$50FA-$5452` runtime.
