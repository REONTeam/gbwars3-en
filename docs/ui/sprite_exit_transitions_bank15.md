# Bank $15 sprite exit transitions

Bank `$15:$5CD0-$5D6E` is a shared blocking sprite-transition family used by UI,
Versus, map-menu, battle, and network presentation paths.

## Public entries

- `SpriteTransition_SlideRightOffscreen` at `$15:$5CD0`
- `SpriteTransition_SlideDownOffscreen` at `$15:$5D1E`

Both entries take a sprite-object slot in `A`. They disable automatic animation
for that object, snapshot its current coordinates, stop the active SFX and play
SFX `$21`, then run a blocking presentation loop that continues servicing
`Joypad_Update`, `Sprite_Update`, and `Gfx_UpdateCommonAnimatedTile`.

The rightward entry advances X by 10 pixels per loop and returns before committing
a candidate X coordinate of `$D0` or greater. The downward entry advances Y by
10 pixels per loop and returns before committing a candidate Y coordinate of
`$B8` or greater. The perpendicular coordinate remains unchanged.

The two routines use dedicated WRAM0 scratch at `$CC9D-$CCA2`. The common UI
animation destination at `$CCA8` is reused so blocking transitions do not freeze
the animated common-screen tile.

## Source boundary

The family ends exactly at `$5D6E`. `$5D6F` begins an unrelated screen/setup
routine and is intentionally not absorbed into this source unit.

The six already-readable Unit List and Versus callers that previously used raw
`farcall $15, $5CD0` now call `SpriteTransition_SlideRightOffscreen`
symbolically. Additional raw-byte callers remain in older battle/network/map UI
modules and can be promoted when those caller bodies are converted to mnemonic
source; their presence does not weaken the provider identity.
