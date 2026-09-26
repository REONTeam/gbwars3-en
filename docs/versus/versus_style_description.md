# Versus style description redraw

Bank `$27:$6AE6-$6B19` owns the description redraw used by the Versus style
selector. It clears the description rectangle, restores the caller's VRAM bank,
then draws one of the two existing strings at `$6B1A`/`$6B31` according to the
style selector at `$DC52`. Both left/right style-change paths call
`Versus_DrawStyleDescription` symbolically.
