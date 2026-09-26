# Raw executable cleanup tranche

Three source-owned routines that were still represented as raw `db` byte streams are now mnemonic RGBDS source without changing any ROM bytes:

- ROM0 `$39DB-$3A8D`: `Vram_DrawSequentialTileRectangle` (179 bytes), the shared sequential VRAM rectangle writer used by battle presentation.
- Bank `$13:$54C0-$5540`: `MapMenu_RunContinueFromSavePrompt` (129 bytes), the saved-data continuation prompt controller.
- Bank `$16:$454B-$460D`: `BattleUnit_LoadSpriteDescriptorAndPixels` (195 bytes), the shared battle-unit sprite descriptor/pixel loader.

The Map Menu prompt now calls `Gfx_UpdateCommonAnimatedTile` symbolically rather than retaining a raw Bank `$15:$6791` farcall. The project-wide raw numeric `farcall` audit therefore remains zero.

While auditing the next ownership gap, Bank `$15:$7158-$76F1` was confirmed to contain substantial executable code rather than being an undifferentiated orphan resource area. `MapSave_PostOverwriteFlow` already calls the internal `$7413` controller. The range still needs its complete caller/resource contract split before source ownership is expanded; it should no longer be described as having no proven callable entry.
