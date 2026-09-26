# Unit Status controller runtime

the project separates another Bank $25 lifetime of the shared WRAM window used by the infrared controller.

The Unit Status controller at Bank $25:$4110-$42BD owns the screen setup/input loop around the already-sourced selected-unit renderer. During this lifetime, `$C61A` is the cursor sprite ID returned by the sprite allocator. `$C622` snapshots the initial left-side displayed value immediately before the input loop; pressing A while the live left-side value still equals the snapshot is rejected, while a changed value can be accepted.

These meanings are lifetime-scoped aliases only. They do not replace the infrared-controller meanings of the same physical addresses. `$C941-$C944` are intentionally left under their existing neutral/raw ownership in the project because their exact Unit Status gameplay identities require tracing the producer path before `$4110`.

The adjacent Bank $25:$43BD-$448B panel graphics/counter renderer is also source-owned. It uses `wUnitStatusPaneXOffset` with values 0 and 10 to place mirrored left/right panel graphics and displays the paired live values used by the controller.

the project resolves the pair-adjustment scratch as a separate HP-transfer lifetime: `$C941/$C942/$C943/$C944` are target unit ID, source HP, target HP, and maximum HP respectively. See `docs/unit/unit_hp_transfer_runtime.md`.
