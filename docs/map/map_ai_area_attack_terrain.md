# Area-attack terrain and property effects

Bank `$0C:$504F-$52A5` is the source-backed seven-hex area-attack runtime. The
per-cell executor applies its unit HP effect first and then dispatches a second
terrain/property effect through the 23-class `Terrain_GetNameIndex` namespace.

## Property-state behavior

`MapAI_GetAreaAttackTerrainStateDelta` derives the signed property-state change
from the acting unit in `wUnitRecordScratch`:

- Bomber / Mercenary Bomber: `-15`
- Mercenary Missile Frigate / Submarine-S: `-25`
- all other unit types: `0`

HQ and COM Tower records are protected from reaching zero; their state is
clamped to a minimum of one. CITY, BASE, AIRPORT, and PORT use normal state
damage. At zero they become the corresponding neutral ruins tile, the raw-tile
histogram is transferred to the ruins ID, and the existing state record is reset
to the ruins class base value.

RUNWAY is different: at zero, `PropertyState_RemoveRecordAtCoordinates` removes
its WRAM1 state record, the map tile becomes PLAIN, and the map cell is refreshed.
This is the previously opaque `$0C:$51AE` caller.

## Natural terrain behavior

The same dispatch table establishes the non-property transformations:

- PLAIN / ROAD -> WASTELAND
- WOOD -> PLAIN
- BRIDGE 1 / BRIDGE 2 -> RIVER
- MOUNTAIN, WASTELAND, DESERT, RIVER, SEA, and SHOAL -> no terrain change

After bridge collapse, an armored or unarmored occupant is sent through the
existing Bank `$0C:$4ECB` unit-removal/death path. Air, sea, and submarine target
classes are not removed by this bridge-specific check.

## Presentation helpers

`MapAI_CreateAreaAttackEffectSprite` and
`MapAI_PositionAreaAttackEffectSprite` at `$5259-$52A5` own the per-cell sprite
creation/positioning code. The shared map-effect layer is source-owned separately:
`MapActionEffect_LoadPalettes` supplies the effect palettes,
`MapActionEffect_AreaAttackAnimation` at `$53AE` is the typed area-attack stream,
and `Unit_DestroyWithMapAnimation` handles units removed by collapsed bridges.
The connected frames, animations, graphics, and palettes are documented in
`docs/map/map_action_effect_runtime.md`.

Verification is provided by `make check-map-ai-area-attack-terrain`, which checks
all `$504F-$52A5` linked bytes against retail, the 23-entry terrain dispatch,
the 12-byte ruins table, key public symbol addresses, and the unchanged custom
English ROM SHA-256.
