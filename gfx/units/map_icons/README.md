# Map unit icons

The physical icon tile pool is `../source_tiles/map_icons.png`. `../map_icons.png` is a neutral atlas of recognizable 16x16 units, and `composed/` contains one neutral `icon.png` per UnitData entry.

## Runtime metatile mapping

`MapTile_DrawCell` adds `$34` to a nonzero WRAM-bank-2 overlay byte. The 106 metatile entries `$34-$9D` use the live-unit encoding `unit_type * 2 + side`, so each of the 53 UnitData entries still has separate side-0 and side-1 runtime definitions. Those definitions, including palette numbers and X/Y flips, remain recorded in `runtime_metatiles.csv` and each unit's `metatile.txt`.

The repository deliberately does **not** keep side/palette PNG variants. `icon.png` uses the side-0 geometry as the canonical neutral view; the side-1 mirroring/palette behavior belongs to metadata and runtime source rather than another picture. `$9E` remains the extra special overlay.
