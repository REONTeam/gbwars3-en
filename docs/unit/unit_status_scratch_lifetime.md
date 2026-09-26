# Unit Status shared WRAM scratch lifetime

Bank $25 Unit Status reuses part of the physical `$C61A-$C622` scratch window that the ROM0 infrared controller uses earlier. These are **lifetime-scoped aliases**, not global RAM ownership.

The source-backed detail staging helper at `$25:$42BE-$43B2` proves this Unit Status view:

- `$C61B` `wUnitStatusTypeSide`: encoded live unit type/side byte (record offset 0).
- `$C61C` `wUnitStatusHP`: live HP (record offset 4).
- `$C61D` `wUnitStatusFuel`: live fuel (record offset 7).
- `$C61E` `wUnitStatusRank`: experience-derived D/C/B/A/S rank index.
- `$C61F` `wUnitStatusPaneSide`: caller-supplied pane-side/index used for graphics placement.
- `$C620` `wUnitStatusPaneXOffset`: caller-supplied horizontal pane offset used for the detail columns.
- `$C621` `wUnitStatusSelectedUnitIndex`: selected live unit-record index.

The helper builds the already-typed two-slot weapon summary at `$CCED-$CD08` and renders each weapon name/ammo line. `$C61A` is deliberately not named for this particular lifetime because this helper does not read or write it.

Later Bank $25 code reuses the same bytes again for other Unit Status/map-selection controller state, so these names should be used only in the detail-staging path unless a caller proves the same meaning.
