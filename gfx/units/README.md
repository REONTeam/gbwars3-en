# Unit graphics

The unit graphics are split by their proven runtime role.

- `map_icons.png` / `map_icons.orig.png` — active 2bpp build sheet at Bank `$01:$5898`. This is the 219-tile source loaded into VRAM bank 1 for the gameplay map.
- `map_icons/composed/` — authoritative 16x16 compositions generated from ROM0's overlay-metatile definitions. Every one of the 53 UnitData entries has one neutral `icon.png` plus `metatile.txt`; both side definitions, including CGB X/Y flip and palette attributes, remain in metadata/source.
- `map_icons/composed/special_overlays/9e_special.png` — the extra overlay definition after the complete 53 x 2 encoded UnitData range.
- `map_icons/raw_sheet_crops/` — retained the project sheet-order crops. These are useful low-level references but are **not** authoritative sprite compositions.
- `battle/bank16_tiles.png` — active build-owned Bank `$16:$4A00-$7D9F` battle-unit graphics window (13,216 bytes). `bank16_tiles.orig.png` is the retail-view reference. The broad window is byte-reproducible through `rgbgfx`; future loader tracing should split it into individual battle sprite/frame assets without changing the proven outer boundary.

`MapTile_DrawCell` adds `$34` to a nonzero WRAM-bank-2 overlay byte. Overlay values `$00-$69` match the already-proven live-unit encoding `(UnitData index << 1) | side`; therefore the metatile table provides the authoritative UnitData-to-map-sprite mapping. The final `$9E` definition is a separate special overlay.

## Battle-unit organization

The former Bank `$16:$4A00-$7D9F` broad sheet was not pure graphics. the project sources the runtime layout layer and narrows actual pixel data to `battle/ground.png`, `battle/air.png`, `battle/sea.png`, and `battle/special.png`. See `battle/README.md`, `battle/unit_layout_records.csv`, and `battle/sprite_descriptors.csv`.
