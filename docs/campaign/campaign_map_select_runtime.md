# Campaign map-selection runtime

the project identifies Bank `$25:$44FD-$48AC` as the Campaign map selector surrounding the already-source-backed `$47BC-$4818` map-selection summary renderer. The screen is distinct from the earlier Unit Status two-pane controller even though both reuse the same physical WRAM scratch window.

## 45-map geometry

The selector decomposes a Campaign map index into five pages of nine maps each. Each page is a 3 x 3 grid:

`map_index = page * 9 + column * 3 + row`

The reverse initialization divides the entry map index by 9, then divides the remainder by 3. Cursor movement wraps row/column at 3 and page at 5. `CampaignMapSelect_GetSelectedMapIndex` recomposes the same expression before loading the Campaign map record.

## Lifetime-scoped scratch aliases

While this selector is active, the shared `$C61A-$C621` bytes mean:

- `$C61A` `wCampaignMapSelectPage`: page 0-4.
- `$C61B` `wCampaignMapSelectMapIndexScratch`: transient map index while drawing the nine availability cells.
- `$C61C` `wCampaignMapSelectCellScratch`: transient cell index 0-8.
- `$C61D` `wCampaignMapSelectCursorSpriteID`: cursor sprite ID.
- `$C61E` `wCampaignMapSelectConfirmEnabled`: zero for view-only entry, one for selectable entry.
- `$C61F` `wCampaignMapSelectRow`: row 0-2.
- `$C620` `wCampaignMapSelectColumn`: column 0-2.
- `$C621` `wCampaignMapSelectEntryMapIndex`: map index supplied when the selector opens.

These names are aliases for this feature lifetime only. They do not replace the infrared-controller or Unit Status meanings of the same physical WRAM.

## Source ownership

the project source-backs `$44FD-$47BB` and `$4819-$48AC`. `$47BC-$4818` remains owned by `engine/unit/unit_status.asm`, preserving the custom 9-character map-name sidecar renderer already integrated there. The selector reads the 45 Campaign clear counters through `wCampaignMapClearCounts` and uses the existing Campaign map-record selector. Existing English/customized source remains authoritative.
## Bank $24 page resources

The five Campaign-selector pages use a fixed resource package in Bank `$24`. Each page begins `$810` bytes after the previous one and contains `$7D0` bytes (125 tiles) of 2bpp graphics followed by `$40` bytes (eight CGB BG palettes):

- page 0: `$5690-$5E9F`;
- page 1: `$5EA0-$66AF`;
- page 2: `$66B0-$6EBF`;
- page 3: `$6EC0-$76CF`;
- page 4: `$76D0-$7EDF`.

All five palette blocks are byte-identical. `CampaignMapSelect_LoadPalettes` loads the page-0 palette block at `$5E60` once, while `CampaignMapSelect_LoadPage` selects only the page-specific graphics pointer. Page 0 deliberately starts inside the physical graphics window also consumed by attract scene 5. The source represents that overlap with one physical owner and symbolic aliases rather than duplicate fixed sections. Bank `$24:$7EE0-$7FFF` is retail `$FF` padding. Logical page graphics, palettes, and neutral tile-sheet previews are organized under `gfx/campaign/map_select/`.

