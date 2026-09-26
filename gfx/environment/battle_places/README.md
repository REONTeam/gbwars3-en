# Battle-place graphics

Bank `$17` battle-place presentation is organized around 52 ten-byte records (`$00-$33`) in `BattlePlaceMapTileRecords`. Each record references graphics, a 9x3 tilemap, matching CGB attributes, a palette table, and a small variant selector.

The source in `engine/battle/battle_place_graphics.asm` owns the packed ROM resources directly with typed records and format-specific assets. The reference directories under this folder are derived views only:

- `runtime_windows/` — one 352-byte (`$160`) graphics-window preview per raw map tile ID;
- `unique_windows/` — the 24 unique graphics windows selected by those records;
- `composites/` — neutral 72x24 rendered battle-place arrangements;
- `logical_resources/` — manifests describing proven tilemap/attribute/palette roles;
- `window_backing_segments/` — manifest of non-overlapping physical backing segments.

Many logical views overlap the same ROM bytes, so they are intentionally not independent build inputs. `animation_pointer_matrix.csv`, `animation_scripts.csv`, and `metasprites.csv` document the associated animation/layout structures.
