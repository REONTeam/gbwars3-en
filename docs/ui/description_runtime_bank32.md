# Bank $32 scrollable description runtime

Bank `$32:$577D-$58A9` is the shared text provider used by Unit Reference detail
and submenu pages. `Description_DrawVisibleLines` buffers each row into an
18-tile scratch line, pads it with spaces, and draws only the configured visible
row count. `$DA40` supplies the scroll offset, `$DA42` receives the total line
count, and `$DA43` supplies the visible-row count.

`Description_GetUnitText` indexes `Description_Strings` at `$58AA`.
`Description_GetTerrainText` indexes the same pointer table beginning after the
52 unit entries. Gas, initiative, and promotion pages use fixed explanation
resources at `$7B6B`, `$7C93`, and `$7D22`.

The retail words at `$5884`, `$5891`, and `$589E` are not independent pointer
records: they are the immediate 16-bit operands of the three `ld hl, ...`
instructions beginning at `$5883`, `$5890`, and `$589D`. The source models them
that way while retaining compatibility constants for the old names.
