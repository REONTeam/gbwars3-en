# Battle-helicopter HP overlay staging (the project)

the project closes the producer/consumer chain behind the ten-entry WRAM-bank-4 staging layout used by `BattleHelicopterHPGraphicsUpdate`.

Bank `$16` clears `$D398-$D3AB` to zero and initializes `$D384-$D397` as two ten-byte active-slot arrays. It then marks one slot in `$D384` from the side-0 selector at `$D378` and one slot in `$D38E` from the side-1 selector at `$D37E`. The fixed-bank VBlank updater visits `phase` and `phase + 5`, where `phase` cycles 0-4, proving that these arrays are one ten-slot geometry split into two five-slot phase groups.

`BattleHelicopterHPGraphics_UpdateEntry` switches to Bank `$02` and calls `$4000` with the selected unit type in A and battle side in B. the project sources this as `BattleUnitHPLayout_GetPointer`: a 52-entry UnitData-indexed pointer table covers types 0-51. Every non-empty record is `$30` bytes, split into two `$18`-byte side halves. The VBlank worker chooses the half for the current side, indexes it by the ten-slot entry index, and consumes the selected coordinate pair.

The two ten-byte arrays at `$D398/$D3A2` are per-slot tile-state toggles. The side-0 helper alternates tile starts `$01/$EC`; the side-1 helper alternates `$2B/$F2`. An active slot is redrawn through the newly source-owned `Vram_DrawSequentialTileRectangle` with `D=3`, `E=1`, so each update is a three-tile-wide strip at the unit-type-specific coordinate.

This proves the ten-entry staging layout and redraw geometry, but it still does not demonstrate a ROM consumer for the four Bank `$16` helicopter interstitial three-tile slices. Those remain neutrally named until a source-selection path is found.
