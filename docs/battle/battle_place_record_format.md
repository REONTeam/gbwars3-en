# Battle-place record format

the project sources the Bank $17 consumers that define the five-word `BattlePlaceMapTileRecords` format. There is one record for each raw gameplay map tile ID `$00-$33`.

| Offset | Size | Meaning |
|---|---:|---|
| `$00` | 2 | Source of the fixed `$160`-byte battle-place graphics copy window |
| `$02` | 2 | 9x3 tilemap/layout byte source |
| `$04` | 2 | Matching 9x3 CGB attribute byte source |
| `$06` | 2 | Palette-table source |
| `$08` | 2 | Palette variant selector (`$0000/$0002/$0004`) |

`BattlePlace_RenderRecord` copies the tilemap into VRAM bank 0 and attributes into VRAM bank 1. The palette helper multiplies the low-byte variant by eight, so selector values `$00/$02/$04` choose palette-table byte offsets 0, 16, and 32. Exactly two palettes are loaded, into BG palette pair starting at palette 2 or 4 depending on the render destination.

the project closes the physical packing model: every unique layout is exactly 27 bytes (9x3), every attribute map is exactly 27 bytes (9x3), and every palette pointer heads a 64-byte table of four 16-byte/two-palette variants. Together with the graphics windows these resources form one gapless physical arena at Bank $17:$4D53-$6BF2. Physical slices are now stored with format-specific `.tilemap`, `.attrmap`, `.2bpp`, and `.pal` extensions under `gfx/environment/battle_places/resources/`; symbolic labels expose every logical pointer.

The separate `$49D3-$4CEA` matrix is not part of these 52 records. It is indexed as `row * 24 + side * 12 + subvariant * 4 + slot_offset` and supplies two additional `$70xx` layout pointers for each side/subvariant combination. Their downstream meanings remain intentionally unresolved.
