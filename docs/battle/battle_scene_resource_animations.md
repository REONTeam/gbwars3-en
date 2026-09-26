# Battle-scene resource animations

the project resolves physical Bank `$14:$4245-$43E4` as the animation-resource layer consumed by the Bank `$18:$5183-$53D6` battle-scene resource selectors/renderers.

The range contains 16 count-prefixed metasprites followed by five animation scripts and a five-word pointer table. Each metasprite entry is an OAM-style four-byte tuple `(x offset, y offset, tile id, attributes)`, matching the format independently established for the Bank `$17` battle-place metasprites. The metasprite counts are `6,6,6,6,6,5,6,6,6,6,6,6,4,4,2,2`.

The scripts begin at `$43A1/$43AC/$43B7/$43C2/$43CD`. The four renderer-specific scripts each contain three `(metasprite pointer, duration)` frames with durations `6,7,6`; the common fallback contains four frames with durations `5,6,6,5`. Every script is terminated by a null pointer. `$43DB-$43E4` stores pointers to the five scripts in the retail order `$43A1,$43AC,$43B7,$43C2,$43CD`.

The Bank `$18` selectors now reference these labels directly: renderer variants 0/1/2/3 select `$43C2/$43B7/$43A1/$43AC`, while the shared fallback selects `$43CD`. Variant numbering remains deliberately positional because the higher-level caller that assigns a visual/gameplay identity to each renderer has not yet been sourced.

The range ends exactly at `$43E5`, where `Image_Battle_Scene_Common_UI_Tiles` is already build-owned. the project also establishes that Bank `$18:$53D7` is not a continuation of this renderer layer; it begins an unrelated state/save-style subsystem and must not be labeled as battle-scene rendering merely because it is adjacent in ROM.
