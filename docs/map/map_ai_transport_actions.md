# Map AI transport actions

the project follows the project's neutral post-procurement action families into the first externally owned action path and proves the transport-loading contract directly from retail code.

## Action dispatcher

Physical Bank `$0D:$4407-$44ED` is now source-owned as the common map-AI action dispatcher. `wMapAIActionCode` at `$C5EC` selects one of seven handlers through `MapAI_ActionHandlerTable`; `$C5ED/$C5EE` are the staged target coordinate pair. the project subsequently resolves action ID 1 as property capture and action ID 5 as a seven-hex area attack; action ID 2 is terrain development from the project. IDs 0, 3, and 4 remain positional. **Action ID 6 is behavior-proven as load/embark into a carrier.**

The action-6 handler calls `Unit_LoadIntoCarrierAtActionTarget` and then refreshes the active unit's 16-byte scratch record from its committed live record.

## Carrier capacity predicate

Bank `$0B:$5D84-$5DC6` is `Unit_CanLoadIntoCarrierAtCoordinates`. It finds the primary live unit at the requested coordinates, compares the selected unit's UnitData carrying class with the target unit's three accepted carried classes, reads the target carrier's UnitData transport capacity, and rejects a carrier whose live carried-child count has reached that capacity. Return value is `0` for a compatible carrier with room and `1` otherwise.

This directly strengthens the project's `$5842` scan to `MapAI_FindCompatibleCarrierTarget`: the routine is not searching arbitrary compatible units; it specifically searches Large/Small Carrier records and retains only carriers that pass the loading-capacity predicate.

## Load executor

Bank `$0B:$5DC7-$5E1D` is `Unit_LoadIntoCarrierAtActionTarget`. It:

1. sets the selected child's live carried flag;
2. commits that scratch record;
3. finds the primary carrier at the staged target coordinates;
4. increments the carrier's live carried-child count;
5. stores the carrier live-unit index in the child's carrier-index field;
6. commits the child again with that relationship recorded;
7. runs the existing presentation/state-update tail.

The first current source action family is also strengthened to `MapAI_EndTurnDamagedCarrierCargo`: it only succeeds for a unit already carried by a Large or Small Carrier whose HP is below 7, and sets that carried unit's end-turn flag. This is intentionally described by behavior rather than guessing whether the higher-level strategy should be called repair, recovery, or retreat.

## Preservation discipline

No English/custom text, graphics, map records, SRAM structures, or Campaign briefing payloads are changed. The Japanese retail ROM remains verification-only. Action IDs 0-5 retain positional names until their own callees are sourced strongly enough to prove gameplay identities.
