# Map AI action dispatcher contract (the project)

the project closes the remaining semantic gap in the seven-entry Bank $0D map-AI action dispatcher at `$4407-$44ED`. The action IDs are now backed by producer conditions and/or source-owned executors rather than positional naming.

| ID | Action | Behavior proof |
|---:|---|---|
| 0 | Move | Used by bridge, repair/resupply, and attack planners when the staged destination must be approached without executing a special action. |
| 1 | Capture property | Bank `$0B:$648C-$6523` changes property ownership and increments captured-property Campaign statistics. |
| 2 | Develop terrain | Bank `$0B:$489C-$4941` consumes Construction Truck charge, develops/rebuilds terrain, and increments developed-property statistics. |
| 3 | Direct attack | Producer stages acting/target live-unit IDs and coordinates; Bank `$0C:$43CF-$4487` builds and executes the unit-vs-unit battle pipeline. |
| 4 | Build bridge | Planner selects a Construction Truck with at least two first-weapon charges and requires adjacency to the project River reference. Bank `$0B:$4BF2-$4C17` subtracts two charges, writes `MAP_TERRAIN_BRIDGE_1` (`$22`), and increments developed-property statistics. |
| 5 | Area attack | Bank `$0C:$504F-$5137` attacks center + six adjacent hexes and returns total HP removed. |
| 6 | Load into carrier | Bank `$0B:$5D84-$5E1D` validates carrier compatibility/capacity and commits carried-unit state. |

## New source ownership

the project adds five exact ROM tranches totaling 708 bytes:

- Bank `$0D:$6183-$6324` — bridge and direct-attack producer/planner family, 418 bytes, SHA-1 `44b3b5a151a5f74d884d623ae3d7a0ddf16f17e9`.
- Bank `$0D:$469F-$46B6` — bridge-action staging, 24 bytes, SHA-1 `4eaed8b50ad3d2939787a583f8feb4fe8c30c777`.
- Bank `$0D:$471D-$4748` — direct-attack staging, 44 bytes, SHA-1 `3e5887adf16bfb7b599359d270ab7decf1c6728b`.
- Bank `$0B:$4BF2-$4C17` — bridge-construction executor, 38 bytes, SHA-1 `2d8dc123de5e1736ba436b85f35d2df877c36833`.
- Bank `$0C:$43CF-$4487` — direct unit-attack executor, 185 bytes, SHA-1 `07f1e438ac02855c23475a824cfa6079f8c7e6f5`.

The planner and battle executor retain byte-row bodies where lower-level ranking/presentation helpers are still unsourced. The bridge executor and the two short Bank `$0D` staging helpers use normal RGBDS mnemonics where the contracts are straightforward.

## Preservation notes

No customized English text, graphics, map records, Campaign briefing relocation anchors, or prior-disassembly reference material is changed. `OtherDissassemblyROMInfo` remains reference-only and is not added to the build.
