# Unit Status shared-scratch lifetime

the project separates the Bank `$25` Unit Status use of `$C61B-$C621` from the
ROM0 infrared-controller lifetime documented in `infrared_controller_workspace.md`.
These are aliases over shared WRAM, not permanent ownership names.

The source-backed helper at Bank `$25:$42BE-$43B2` establishes:

- `$C61B` `wUnitStatusTypeSide`: encoded live unit type/side byte (record offset 0).
- `$C61C` `wUnitStatusHP`: current live HP (record offset 4).
- `$C61D` `wUnitStatusFuel`: current live fuel (record offset 7).
- `$C61E` `wUnitStatusRank`: rank index derived from the selected unit's experience.
- `$C61F` `wUnitStatusPaneSide`: pane selector, used as 0/1 when choosing pane-local graphics.
- `$C620` `wUnitStatusPaneXOffset`: pane horizontal offset; callers initialize it to `0` for the left pane and `10` for the right pane, then add it to tile X coordinates.
- `$C621` `wUnitStatusSelectedUnitIndex`: selected live-unit record index.

`$C61A` is intentionally not assigned a stable Unit Status meaning here. Bank `$25`
reuses it within the larger UI flow, including a sprite handle and later arithmetic
scratch/result roles. Future caller-focused analysis should split those lifetimes rather
than forcing one global alias.

The `$42BE-$43B2` helper also proves the display relationship: it stages the selected
unit's two weapon summaries at `$CCED-$CD08` and renders current ammo from those
summaries alongside the selected unit's name, HP, fuel, and rank.
