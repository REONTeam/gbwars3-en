# Special battle-unit tiles

the project resolves the physical geometry of Bank $16 `special.2bpp`. Tile 0 is a shared blank tile. Special descriptors 0-3 each point to a three-tile slice immediately followed by another nonzero three-tile slice of identical geometry; special descriptor 4 points to the final three tiles.

The four following slices are named `interstitial_frame` deliberately: their exact animation/effect role is not yet independently proven. They are now separate build inputs because their physical boundaries are exact and together with the descriptor slices reconstruct the complete retail 28-tile family byte-for-byte.

## VBlank consumer result

The ROM0 battle VBlank consumer at `$0216` is now source-owned. It checks the per-side auxiliary-loaded flags created by the Bank `$16` loader and cycles a five-step HP-graphics update phase, processing phase `n` and `n+5` for each enabled side. It does not directly reference the four interstitial ROM slices. Therefore the regular packing remains suggestive, but `interstitial_frame` is still the strongest evidence-safe name.
