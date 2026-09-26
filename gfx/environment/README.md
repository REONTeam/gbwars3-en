# Environment graphics

The environment graphics are separated by runtime role.

- `map/` contains the normal gameplay-map layer: the 96-tile static terrain/property sheet, all 52 base metatile compositions, and the five three-phase Bridge 1 / Bridge 2 / River / Sea / Shoal animations. These are active build-owned assets.
- `battle_places/` contains Bank `$17` battle-screen environment work. the project removes the old false `$4A00-$73DF` monolithic 2bpp asset: that range mixes pointer/layout/data structures with graphics and must not be edited as one image.
- `battle_places/runtime_windows/` contains one reference preview for each raw map tile ID `$00-$33`, reconstructed from the `$160`-byte graphics window selected by the first pointer in the 52-entry Bank `$17:$47CB-$49D2` battle-place table. Many entries intentionally share or overlap ROM source windows, so these previews are reference views rather than independent `INCBIN` assets.

Do not mix battle-place graphics with the normal map-screen terrain assets under `map/`. Future Bank `$17` work should source the remaining pointer consumers and isolate genuinely independent pixel payloads before converting them to build-owned PNGs.
