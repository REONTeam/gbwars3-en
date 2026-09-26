# Unit List Bank $17 helpers

Bank `$17:$7346-$73D3` is the compact Unit List provider used by the mnemonic Bank `$18` controller/action/filter code.

- `$7346` returns `wUnitListFilteredRecords + A * 5`. The 50-entry buffer at WRAM3 `$DA5A` is rebuilt from occupied live units and is the filtered Unit List record set.
- `$7352` returns `wUnitListStagingRecords + A * 5`. The 50-entry WRAM3 buffer at `$DB54` is cleared and repopulated by Unit List category/filter transforms before being copied back when appropriate.
- `$735E` clears the selected Unit List display row in both VRAM banks: a 2x2 block and adjoining 16x1 strip beginning at `(2, 4 + A*2)`.
- `$73A3` updates the two Unit List scroll-arrow sprites. The upper arrow is hidden on visible row zero; the lower arrow is shown only when another record exists beyond the six-row window.

All direct source-backed Unit List callers now use these APIs symbolically. Retail Bank `$17:$73D4-$7FFF` is entirely `$FF` padding and is now explicitly emitted as source padding rather than inherited from the overlay ROM. The preceding `$72D3-$7345` region remains separate because it mixes battle-place palette data and an independently unproven helper; it is not absorbed merely by adjacency.
