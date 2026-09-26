# Bank $31 battle/presentation resource (the project)

the project resolves the region immediately after the UnitData-indexed layout records without assuming the two-byte layout pairs are coordinates.

## Structured resource at $4A4A-$50F9

The first 1,712 bytes have an exact graphics-resource geometry:

- `$4A4A-$4B19`: 208-byte **16 x 13 tilemap**.
- `$4B1A-$4BE9`: 208-byte matching **CGB attribute map**. Retail values are only `0,2,3,4`; no flip/priority bits are present in this resource.
- `$4BEA-$50F9`: **81 2bpp tiles** (`81 * 16 = 1,296` bytes).

These are now independent build assets under `gfx/battle/layout_resource/`, plus tile-sheet and grayscale tilemap previews. The previews are derived views only; ROM ownership remains the three binary assets included from source.

## Runtime at $50FA-$5452

`$50FA-$5452` is executable presentation/runtime code. Independent external entries include `$50FA`, `$5113`, `$543A`, and `$544C`; same-bank calls expose additional stable internal boundaries. the project sources the complete runtime byte-exactly but keeps address-oriented names until caller/state contracts justify narrower gameplay labels.

`$5453` is independently called from ROM0 and is therefore the next natural boundary, not part of this ownership range.

## Layout-pair audit correction

The the project Bank `$31:$41EA-$4A49` UnitData layout family still has no independent semantic consumer proving the two returned bytes are X/Y or another coordinate pair. Bank `$16:$49A8` is the only direct farcall to `$31:$41BF`; its downstream Bank `$14/$18` path preserves and then discards the pair without reading it. The pair therefore remains structural.

the project's roadmap reference to a new **Bank `$31:$4A4A+` data family** was physically correct but semantically under-specified; the project now owns and classifies that region from its actual byte geometry.
