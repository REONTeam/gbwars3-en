# Unit Status selection-controller scratch lifetime

Bank `$25:$4110-$42BD` is the Unit Status selection screen/controller. It owns a distinct lifetime view over two bytes also used by the infrared controller:

- `$C61A` = `wUnitStatusCursorSpriteID`. The screen stores the sprite index returned by sprite creation, then immediately reuses it to position and enable the Unit Status cursor.
- `$C622` = `wUnitStatusInitialLeftValue`. The screen snapshots `$C942` before entering its input loop. On A-button confirmation it compares current `$C942` with this snapshot and branches to different confirmation SFX/state handling depending on whether the value changed.

These are lifetime-scoped aliases only. They do not replace the infrared meanings of the same physical WRAM addresses.

The controller also initializes left/right Unit Status panes and calls `UnitStatus_LoadSelectedUnitPanel` at `$42BE`. The `$C941-$C944` values used by the selection loop remain separately lifetime-scoped and are not renamed in the project because their complete producer contract is not yet source-backed.

the project resolves the pair-adjustment scratch as a separate HP-transfer lifetime: `$C941/$C942/$C943/$C944` are target unit ID, source HP, target HP, and maximum HP respectively. See `docs/unit/unit_hp_transfer_runtime.md`.
