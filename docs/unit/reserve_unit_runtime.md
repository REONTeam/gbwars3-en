# Reserve-unit runtime semantics

the project resolves the formerly generic Bank `$12:$47CE-$4836` compact-list layer as reserve-unit storage.

## Proven source behavior

`ReserveUnits_SaveSide0` clears a 50 x 4-byte buffer at `$C6A8`, then scans live unit slots 0-49. Each occupied slot contributes its encoded type/side byte, the 16-bit live-record experience total at offsets `$0A-$0B`, and a trailing `$FF`.

`ReserveUnits_RestoreSide0` walks the same 50 entries. Occupied entries are recreated at off-map coordinates `$FF,$FF`, receive live status bit 1, and have the saved experience word at `$0A-$0B` restored. This emitted instruction stream is unchanged from the project; only names/constants are promoted.

## Reference-map corroboration

The DataCrystal RAM map identifies `$C6A8+` as reserve-unit stats and describes the live status byte with bit 1 as Reserve. Its ROM map separately describes `$47CE-$4800` as storing unit type/EXP-style reserve data and `$4801-$4836` as establishing reserved-unit stats. These independent descriptions match the already-sourced save/restore behavior.

The source-backed buffer is exactly 50 x 4 = 200 bytes, `$C6A8-$C76F`. This project therefore uses that exact mechanically proven bound rather than adopting the broader `$C6A8-$C77F` prose range literally; `$C770+` is already used by unrelated campaign statistics.

## Active game mode

The same reference RAM map identifies `$C62F` as the active game mode: Beginner 0, Campaign 1, Standard 2, Map Editor 3, VS 4, Attraction 5. the project names it `wActiveGameMode` and adds `GAME_MODE_*` constants. Existing map runtime/save/menu code now uses the symbol instead of raw `$C62F`, with no byte changes.

## Naming limits

The 16-bit live-record experience total at offsets `$0A-$0B` is still kept generic in source even though the reference map calls it EXP, because this project has not yet sourced enough of its writers/consumers to settle the exact gameplay representation independently.
