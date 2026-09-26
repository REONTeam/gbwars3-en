# Battle-place metasprite / animation format

the project resolves the `$6F03-$7132` layer selected by the Bank `$17:$49D3` battle-place matrix.

## Metasprites (`$6F03-$6FFF`)

Each metasprite is variable length:

- one byte: OAM entry count
- `count` repetitions of four bytes: X offset, Y offset, tile ID, CGB/OAM attributes

The region contains 45 contiguous metasprites and ends exactly at `$7000`. Most contain one OAM entry; a few contain two or three.

## Animation scripts (`$7000-$70DC`)

Each script is a sequence of:

- `dw metasprite_pointer`
- `db duration`

followed by `dw $0000`. Forty-two scripts are one-frame/static scripts. The script at `$70C8` is the multi-frame exception and chains three metasprites for durations 6, 5, and 4.

## Script pointer table (`$70DD-$7132`)

The ROM contains 43 pointers covering every animation script. `BattlePlaceAnimationPointerMatrix` selects these scripts by row, side, subvariant, and one of two animation slots. The exact gameplay identity of the two slots remains deliberately unnamed until their higher-level consumer is sourced.

`gfx/environment/battle_places/metasprites.csv` and `animation_scripts.csv` are inspection indexes; the authoritative emitted data remains in `engine/battle/battle_place_graphics.asm`.
