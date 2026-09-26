# Bank $17 battle-place palette rows and Versus divider helper

Bank `$17:$72DB-$7345` contains two independently proven resources immediately before the Unit List helper layer.

`$72DB-$731A` is an eight-row table of four-color BGR555 palettes. Both `BattlePlace_UpdatePrimaryPaletteAnimation` and `BattlePlace_UpdateSecondaryPaletteAnimation` index the table in eight-byte rows. Each animation uses color 1 from the selected row and color 1 from the following row to stage the paired highlight colors, while the non-highlight phase restores the renderer-captured base palettes.

`$731B-$7345` is `VersusSetup_DrawDividerRow`. Bank `$18`'s Versus setup screen calls it six times at coordinates `(5,4)`, `(7,4)`, `(9,4)`, `(11,4)`, `(13,4)`, and `(15,4)`. Given the coordinate in `BC`, it selects VRAM bank 0 and fills fourteen tilemap bytes with tile `$10`, then selects VRAM bank 1 and fills the same fourteen attribute bytes with `$08`; it restores VRAM bank 0 before returning.

The six callers are now represented symbolically in `Versus_DrawSetupSelectionDetails` rather than as embedded `farcall $17,$731B` bytes.

The eight bytes at `$72D3-$72DA` remain intentionally unclaimed. They form a plausible four-color BGR555 palette by shape, but no direct pointer or source-backed consumer currently proves its role. Physical adjacency to the common battle-scene tiles and animated palette rows is not sufficient provenance.
