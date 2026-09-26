# MovementData terrain columns

the project resolves the 23-byte `MovementData` profile width against the normal map terrain-name index.
`MovementData_GetCost` indexes one profile byte with the value returned by Bank `$0B` `Terrain_GetNameIndex`; `MovementData_BuildMapTileCosts` repeats that conversion for all 52 raw map-tile IDs and caches the resulting costs at `wMovementCostByMapTile`.

The columns therefore follow this exact order:

| Index | Constant | Terrain/property class |
| ---: | --- | --- |
| 0 | `MOVEMENT_TERRAIN_HQ_0` | HQ variant 0 |
| 1 | `MOVEMENT_TERRAIN_HQ_1` | HQ variant 1 |
| 2 | `MOVEMENT_TERRAIN_CITY` | City |
| 3 | `MOVEMENT_TERRAIN_CITY_RUINS` | City ruins |
| 4 | `MOVEMENT_TERRAIN_BASE` | Base/factory |
| 5 | `MOVEMENT_TERRAIN_BASE_RUINS` | Base/factory ruins |
| 6 | `MOVEMENT_TERRAIN_AIRPORT` | Airport |
| 7 | `MOVEMENT_TERRAIN_AIRPORT_RUINS` | Airport ruins |
| 8 | `MOVEMENT_TERRAIN_RUNWAY` | Temporary airport/runway |
| 9 | `MOVEMENT_TERRAIN_PORT` | Port |
| 10 | `MOVEMENT_TERRAIN_PORT_RUINS` | Port ruins |
| 11 | `MOVEMENT_TERRAIN_COM_TOWER` | COM tower |
| 12 | `MOVEMENT_TERRAIN_PLAIN` | Plain |
| 13 | `MOVEMENT_TERRAIN_ROAD` | Road |
| 14 | `MOVEMENT_TERRAIN_BRIDGE_1` | Bridge 1 |
| 15 | `MOVEMENT_TERRAIN_BRIDGE_2` | Bridge 2 |
| 16 | `MOVEMENT_TERRAIN_MOUNTAIN` | Mountain |
| 17 | `MOVEMENT_TERRAIN_WOOD` | Wood |
| 18 | `MOVEMENT_TERRAIN_WASTELAND` | Wasteland |
| 19 | `MOVEMENT_TERRAIN_DESERT` | Desert |
| 20 | `MOVEMENT_TERRAIN_RIVER` | River |
| 21 | `MOVEMENT_TERRAIN_SEA` | Sea |
| 22 | `MOVEMENT_TERRAIN_SHOAL` | Shoal |

The raw profile values are stored in sixteenths. Zero is used by multiple profiles for terrain they cannot traverse. Higher-level profile names should remain conservative until the UnitData movement-profile users are correlated with gameplay behavior.

## Source representation (the project)

`movement_profile` now emits the same 23 columns explicitly, one `db` per
terrain/property class, instead of hiding the record width behind a `rept`.
This is a source-clarity change only: profile labels remain `Profile00` through
`Profile14` because their higher-level movement-type identities are not yet all
proven by callers, and the complete 345-byte payload remains unchanged.

`tools/verify_movement_data_macro.py` locks the macro field order to the
`MOVEMENT_TERRAIN_*` constants and independently reconstructs all 15 profiles.
