# Map Editor submenu and ARRANGE runtime

Bank `$0F` now owns the shared submenu value/cursor presentation and both halves
of the ARRANGE selector as mnemonic source.

## Owned ranges

- `$4D65-$4DBF`: `MapEditor_DrawSubmenuValues`
- `$4DC0-$4DCE`: submenu value-column / zero-value / suffix tile data
- `$4DCF-$4DF9`: submenu cursor update and drawing
- `$4DFA-$4E03`: submenu-ID to cursor-X lookup table
- `$4E04-$4EE9`: terrain ARRANGE selection controller and panel setup
- `$4EF1-$4F8F`: terrain option graphics/cursor/name presentation
- `$502B-$50EB`: unit ARRANGE selection controller

The code totals 716 executable bytes / 340 decoded instructions. The two inline
submenu tables contribute another 25 source-owned data bytes, for 741 newly
source-owned bytes in this checkpoint.

## Localization boundary

`$4F90-$502A` is not duplicated in the new runtime module. It is already the
project's authoritative custom-English `Terrain_Name_Strings` resource in
`data/terrain.asm`. The terrain arrange renderer now consumes that table by
symbol, preserving the English names and the relocated natural-terrain fragment.

`$4EEA` remains the separately owned `EditorSubmenu_Map_Label` resource, and
`$50EC` begins the previously source-backed unit-selection panel.

## Behavior

The shared submenu helpers draw SIZE/FUNDS/MATERIAL values and manage their
cursor tile positions. The terrain and unit ARRANGE controllers both provide
wraparound class/value selection, cursor presentation, SFX, and Select-button
switching between terrain and unit placement modes. Terrain name display is
resolved through `Terrain_GetNameIndex` and the existing English terrain-name
pointer table.

## Next connected boundary

The strongest remaining editor seam is `$50EC-$52D9`: the already-partially
sourced unit-selection panel is followed by still-structural option renderers,
selection rebuild helpers, class/value tables, and the rectangle-fill primitive
at `$52DA`.
