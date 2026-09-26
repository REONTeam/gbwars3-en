# Battle helicopter HP graphics VBlank service

the project replaces the long-standing symbol-only ROM0 `$0216` dependency with byte-authoritative source for `$0166-$027F`.

`BattleVBlankInterrupt` is the only direct retail caller of `BattleHelicopterHPGraphicsUpdate`. The updater switches to WRAM bank 4 and checks the two flags at `$D340/$D341` that the project/297's Bank `$16` sprite loader sets only when helicopter auxiliary graphics were successfully copied for the corresponding battle side.

When a side is enabled, the VBlank updater processes two entries through the `$0166` worker: current phase `0-4` and current phase plus five. `$D343` is advanced once per update and wraps after phase 4. This behavior is consistent with the older extended-ROM-map name "battle helicopter HP graphics updater" and now has a source-backed producer/consumer contract.

This does **not** prove a direct use of the four three-tile Bank `$16` special-sheet interstitial slices. The Bank `$16` loader copies only the five descriptor-selected auxiliary slices into VRAM, and the ROM0 VBlank path operates on the resulting flags/state rather than pointing back into `$7B61+` ROM graphics. The four interstitial slices therefore remain neutral until a separate consumer proves their role.
