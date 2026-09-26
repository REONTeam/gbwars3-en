# Bank $22 window frame/attribute helper

`UIWindow_DrawFrameAndClearInteriorAttributes` at `$22:$6247` is the shared
modal-window helper used by Battle Info, the Map Menu suspend screen, and the
infrared opponent-cancel result prompt.

Inputs follow the normal window API: `BC` is the outer-frame tile coordinate
and `DE` is the outer width/height. The routine first calls
`UIWindow_DrawFrame`, then advances the coordinate by one tile and subtracts
two from both dimensions. In VRAM bank 1 it fills that interior rectangle with
attribute byte `$00` through `Gfx_TilemapFill`, finally restoring the caller's
VRAM bank.

The source-owned range is exactly `$6247-$626C`. `$626D` begins the separate
Game Code/Shift-JIS conversion family.
