# Unit Reference submenu controllers and page renderers

Bank `$25` contains the interactive pages opened by the Unit Reference detail
screen. The main detail controller stores a submenu index at `$D9C0` and the
dispatcher at `$68A1` routes its ten menu choices into nine controller loops;
weapon slots 1 and 2 share the same weapon controller and pass the slot in `A`.
The connected renderer/provider chain is now source-backed through every retail
submenu page.

## Controller layer

The following controller entries are source-owned and retain their retail
addresses:

| Address | Entry | Role |
| --- | --- | --- |
| `$6AEC` | `UnitReference_RunDescriptionSubmenu` | Scrollable description/cost page |
| `$6F83` | `UnitReference_RunMovementSubmenu` | Movement-loss terrain grid |
| `$733B` | `UnitReference_RunUpkeepSubmenu` | Upkeep/fuel page |
| `$7509` | `UnitReference_RunWeaponSubmenu` | Shared weapon-slot page controller |
| `$759A` | `UnitReference_RunInitiativeSubmenu` | Initiative page |
| `$779E` | `UnitReference_RunLoadSubmenu` | Load/carry page |
| `$7879` | `UnitReference_RunPromotionSubmenu` | Promotion page |
| `$79F8` | `UnitReference_RunDefenseSubmenu` | Defense page |
| `$7F7A` | `UnitReference_RunResupplyRepairSubmenu` | Resupply/repair page |

Every controller preserves the established Unit Reference transition contract:
it enters after the outer detail screen has faded out, fades its page in,
services input through `UnitReference_PollInputAndUpdateSprites`, and returns
through a fade-to-white and sprite cleanup. The main `$68A1` dispatcher refers
to every controller symbolically.

## Movement page

The movement page is source-owned across `$6B7D-$6F33` and `$6F3A-$6F82`.
The custom-English `UnitStatus_Submenu_Move` string at `$6F34-$6F39` remains a
separate resource owner between those two code ranges.

`UnitReference_LoadMovementTerrainGraphics` stages the terrain metatiles used by
the grid. `UnitReference_MovementCellDescriptorPointers` at `$6D8F` indexes 26
four-byte records of the form `{x, y, first tile, map tile}`. The renderer shows
18 cells at once as a 3-by-6 grid and selects the remaining terrain entries on
the second page. Movement values come directly from `wMovementCostByMapTile`.

## Selected-terrain detail and upkeep

The previously structural `$7061-$731C` provider is now mnemonic source, split
around the custom-English terrain-defense string at `$7139-$7141`.

`UnitReference_LoadTerrainDetailDescriptor` indexes
`UnitReference_TerrainDetailDescriptors` at `$716F`. The table contains 46
three-byte records:

`{movement terrain graphics index, description/list index, side selector}`

`UnitReference_OpenSelectedTerrainDetail` at `$71F9` owns the scrollable detail
controller, and `UnitReference_DrawUpkeepSubmenu` at `$728A` owns upkeep/fuel
presentation. The custom-English upkeep resources beginning at `$731D` remain
separate owners.

## Later page providers

The remaining page-specific renderer families are mnemonic and byte-exact:

| Range | Public role |
| --- | --- |
| `$73C6-$74EF` | weapon page provider |
| `$752D-$758B` | initiative page provider |
| `$7625-$7782` | load/carry page provider |
| `$781C-$7874` | promotion page provider |
| `$7917-$79F7` | defense page provider |
| `$7A19-$7F4C` | resupply/repair page provider |

The controller-called internal entries within these families are symbolic. The
large resupply/repair body is executable mnemonic RGBDS; some internal labels
remain deliberately structural until their exact gameplay meaning is proven.

## Resource ownership boundaries

Custom-English Unit Status resources remain independent source owners rather
than being absorbed into neighboring retail code. Important boundaries include
`$6F34`, `$7139-$7141`, `$731D-$733A`, `$74F0-$7508`, `$758C-$7599`,
`$7783-$779D`, `$7875-$7878`, and `$7F4D-$7F79`. The custom tail at
`$7FF1-$7FFF` is occupied by the relocated English `INITIATIVE` resource; it is
not retail free padding in the custom build.

The unexplained two bytes at `$6388-$6389` remain deliberately unclaimed. They
should only be assigned once a real consumer or data relationship proves their
role.
