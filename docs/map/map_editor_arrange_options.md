# Map Editor ARRANGE option resolution

Bank `$0F` now exposes the remaining option-presentation and selection-resolution
layer used by both Map Editor ARRANGE modes.

## Unit option panel

`MapEditor_UnitArrange_DrawOption` at `$517E` resolves the current one-based
selection for one of the six visible unit classes, converts the selected unit
type to the packed `type << 1 | side` graphic ID, uploads its four-tile graphic
slot, and draws the 2x2 unit metatile. The seven X coordinates at `$51CA` cover
those six visible classes plus the DELETE class. `$51D1` positions the shared
cursor sprite over the current class.

The class identities are behavior-backed by the shared resolver:

- 0: side 0 ground
- 1: side 0 air
- 2: side 0 sea
- 3: side 1 ground
- 4: side 1 air
- 5: side 1 sea
- 6: DELETE

The three unit-type lists are shared by both sides; classes 3-5 set the packed
side bit after resolving the type. DELETE resolves to `UNIT_TYPE_EMPTY`.
Mercenary-only unit variants are intentionally absent from the editor lists,
matching retail.

## Terrain option classes

`MapEditor_TerrainArrangeClassPointers` at `$526E` owns five one-based lists:
side-0 properties, side-1 properties, neutral property/ruin pairs, land terrain,
and water/bridge terrain. The existing custom-English `Terrain_Name_Strings`
resource remains the presentation owner for their names.

## Shared resolution

`MapEditor_Arrange_RebuildSelection` at `$5226` resolves the current terrain
class/value into `wMapEditorSelectedTerrainId` and the current unit class/value
into `wMapEditorSelectedUnitId`. Terrain and unit ARRANGE controllers now call
this API symbolically rather than using `$5226/$526E/$5299` address aliases.

`MapEditor_Arrange_GetOptionTileDestination` at `$5218` allocates four 2bpp
VRAM tiles per option slot beginning at `$8C00`.

## Rectangle fill

`MapEditor_FillRectangle` at `$52DA` accepts two map corners in `B/C` and `D/E`
and the terrain ID in `A`. It normalizes the corner order, fills the inclusive
rectangle in WRAM bank 1, clears any unit overlay bytes in WRAM bank 2, and
decrements `wUnitCountBySide` for every removed unit. This is used both for the
initial blank editor map and the FILL command.

The routine ends at `$5332`; `$5333-$533F` is verified `$FF` padding. Bank
`$0F:$5340+` is deliberately not absorbed because it is already occupied by the
custom-English relocated `Terrain_Name_Strings_Fragment`, followed later by the
custom nine-character map-name editor at `$5400`.
