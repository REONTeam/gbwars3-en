# Graphics

The graphics tree keeps build pixels, CGB palettes, and human-readable compositions separate.

- Normal build PNGs are indexed images converted to 2bpp by `rgbgfx`.
- If a graphic can use more than one runtime palette, there is **one neutral four-shade PNG only**. The available in-game colors remain explicit `.pal` data; palette swaps do not create duplicate PNGs.
- `source_tiles/` contains physical ROM tile ordering needed for exact reconstruction when that ordering is not a useful human-facing layout.
- Conventional PNG names and `composed/` files show recognizable complete tiles, units, panels, or animation frames rather than raw tile-memory order.
- Preview-only/color-variant PNG directories are intentionally not kept.
- `make gfx-resources` regenerates neutral compositions and ROM-authentic palette files from `baserom.gbc`.

