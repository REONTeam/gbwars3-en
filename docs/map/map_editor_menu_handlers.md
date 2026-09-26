# Map Editor main-menu handlers

Bank `$0F` contains the eight handlers selected by `MapEditor_MenuHandlerPointers`.
They are source-owned as separate fixed sections because the executable paths are
interleaved with existing editor message resources.

## Public handlers

| Menu item | Entry | Role |
| --- | --- | --- |
| ARRANGE | `$460F` | Select terrain-edit or unit-placement arrange mode. |
| MAPSIZE | `$4661` | Edit width/height in the retail 20..50 range, confirm, clear the out-of-bounds strips, then rebuild map counts/state. |
| FUNDS | `$46FF` | Edit the two initial-funds fields in the editor map record. |
| MATERIAL | `$4744` | Edit the two initial-material fields in the editor map record. |
| NAME | `$4789` | Custom-English bridge to the nine-character editor at `$5400`. |
| FILL | `$4986` | Validate fill eligibility and enter rectangular fill selection. |
| SAVE | `$47B3` | Confirm, require exactly one HQ for each side, then commit the current editor map record. |
| END | `$4866` | Run the save-and-end / end-without-saving / return prompt. |

The pointer table at `$4280` references all eight entries symbolically.

## Shared handler support

`MapEditor_RunYesNoConfirmation` at `$4879` is shared by MAPSIZE and SAVE.
`MapEditor_CommitSaveIfHQCountsValid` at `$47C5` checks
`wMapSide0HQTileCount` and `wMapSide1HQTileCount` before calling the existing
Bank `$13` editor-record writer. Invalid HQ geometry opens the existing HQ
warning resource at `$4837-$4865`.

`MapEditor_RunFillRectangleSelection` at `$4A07` owns the two-corner fill
controller. The first confirmation stores an anchor coordinate; the second
uses the selected terrain ID with the existing rectangle fill primitive.
Directional input reuses the normal map-control movement services, while the
preview helpers at `$4B39-$4BB3` blink/restore the anchor cell without
committing it prematurely.

`MapEditor_RunTwoValueSubmenuInput` at `$4BB4` is the shared bounded two-field
input loop used by MAPSIZE, FUNDS, and MATERIAL. It wraps each selected value
between the caller-provided minimum/maximum and toggles between the two fields
on vertical input.

## Resource boundaries

The handler source deliberately does not absorb the existing message/text
owners between executable spans:

- `$4837-$4865` — HQ-count warning;
- `$4954-$4985` — END/save-choice prompt;
- `$49ED-$4A06` — fill restriction message;
- `$4B08-$4B38` — fill-range instructions;
- `$4C3A+` — existing submenu drawing/text source.

The custom nine-character NAME entry at `$4789-$478B` jumps to `$5400`.
`$478C-$47B2` is retained as the now-unreachable retail eight-character body so
its original program bytes remain explicitly represented rather than inherited
from the base ROM.

## Remaining connected editor services

The next contiguous caller-backed area is `$4D65-$4EE9`. The newly readable
handlers prove entries at `$4D65`, `$4DCF`, and `$4DE2` as shared submenu
value/cursor presentation services, while `$4E04` is the arrange-selection
controller already called by the main editor loop. These services remain
structural until their complete internal/data boundaries are sourced.
