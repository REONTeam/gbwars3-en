# Graphics layout notes (the project)

## Proven build asset

- Unit map icons: Bank $01:$5898, active source `gfx/units/map_icons.png` -> `gfx/units/map_icons.2bpp`.
- Generated size: 3,504 bytes with the retained `--trim-end 5` rule.
- Retail comparison SHA-1: `c228815ad4d9f97d66ae19603488c963487b0204`.


## Gameplay map terrain (the project)

- Bank $01:$5268-$5867: **96 actual map-screen terrain/property tiles**, active build source `gfx/environment/map/terrain_tiles.png` -> `terrain_tiles.2bpp`. Retail SHA-1 `a42f76a43daa629192a41a829a00e275650c032e`.
- Bank $01:$401C-$40CD: sourced gameplay-map graphics loader. It copies the terrain sheet to VRAM bank 0 `$9000` and the map-unit icon sheet from `$5898` into VRAM bank 1.
- ROM0:$1C6C-$1E0B: 52 base 16x16 metatile definitions, four `(tile ID, CGB attribute)` pairs each.
- ROM0:$18AB-$18DE + Bank $0B:$4707-$4713: raw map tile -> terrain-name index path, proving natural IDs `$20-$2A` and property family ranges.
- `gfx/environment/map/metatiles/` contains 52 derived organization previews. They are not independent build inputs; palette/attribute behavior remains source-backed in `MapMetatileDefinitions`.

This closes the project's "actual map-screen terrain still unfound" item. Bank $17 remains correctly classified as battle-place/environment artwork, not the normal map terrain sheet.

## ROM-backed reference windows

- Bank $16:$4A00-$7D9F: large battle-unit graphics. Extraction SHA-1 `9246398bd093974f193c426a2f9fb03278af68d4`.
- Bank $17:$4A00-$73DF: large environment/property battle-scene graphics. Extraction SHA-1 `7cc37ca34441026a1781fe961525b806ebc097bd`.

These windows are deliberately reference-only until their internal pointer/loader ownership is source-backed. This avoids replacing unknown code/data boundaries with guessed `INCBIN`s.

## Organization rule

Keep build-owned edited/custom graphics authoritative. ROM/reference extractions live in descriptive subfolders and must not silently replace active English assets.
