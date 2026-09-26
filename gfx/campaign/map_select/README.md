# Campaign map-selector graphics

The Campaign selector displays 45 maps as five pages of nine maps. Each page is an `$810`-byte package:

- `$7D0` bytes / 125 2bpp tiles;
- `$40` bytes / eight CGB background palettes.

The package starts are `$5690`, `$5EA0`, `$66B0`, `$6EC0`, and `$76D0`. All five palette blocks are byte-identical.

Page 0 begins inside the Bank `$24` attract scene-5 graphics window. The attract resource module owns the overlapping prefix through `$5E0F`; `engine/campaign/campaign_map_select_resources_bank24.asm` owns the remaining page-0 graphics tail, its palettes, pages 1-4, and final bank padding.

`page_0.2bpp` through `page_4.2bpp` are logical full-page views. Matching PNGs are neutral four-shade inspection sheets, and `.pal` files preserve the CGB palettes exactly.
