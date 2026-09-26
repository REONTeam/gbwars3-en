# Property-state presentation and segmented meter runtime

Bank `$0C` now exposes the complete presentation layer used while CAPTURE and terrain development change a property's state value.

## Owned ranges

- `$571B-$57F9` — `PropertyStateMeter_Setup`
- `$57FC-$580D` — variable-width meter frame tile template
- `$580E-$5882` — property-value renderer plus the shared segmented-meter helpers
- `$59FB-$5B2A` — 19 source-backed meter/UI tiles
- `$5B2B-$5B42` — three four-color ownership palettes

The two bytes at `$57FA-$57FB` are intentionally not claimed. They have no proven direct consumer in the project and are not needed by either meter entry point.

## Property presentation setup

`PropertyStateMeter_Setup` accepts map coordinates in `B/C`. It first reads the existing property-state record and returns `$FF` if the coordinate has no record. For a valid property it then:

1. resolves the raw base map-tile ID;
2. clears three lower-panel rows in both VRAM banks;
3. uploads the 19 meter/UI tiles to VRAM `$8D00`;
4. chooses one of three BG palettes from the raw side-0, side-1, or neutral property ranges;
5. loads and draws the property's 2x2 metatile;
6. resolves and prints the existing `Property_Name_Strings` entry;
7. derives the terrain-class maximum from `PropertyState_GetMaximumForTerrainClass`;
8. copies the variable-width frame row and writes its attributes;
9. draws the current value; and
10. opens the lower window through the existing scanline transition, hiding the map cursor first when the target lies near the bottom edge.

The setup uses two presentation-lifetime scratch bytes at `$C9A7/$C9A8` for the selected raw map-tile ID and initial property-state value. These names remain local to the module rather than being promoted as global WRAM structure fields.

## Shared segmented meter

`SegmentedMeter_Draw` is not property-specific. Its calling convention is:

- `A` — current value;
- `B` — positive maximum in five-point units;
- `C` — base tile ID;
- `HL` — destination tilemap address.

Each five-point segment occupies two tilemap cells. `SegmentedMeterFillTilePairs` supplies six two-tile offset pairs representing fill values `0..5`. The property renderer uses base tile `$D0`; the already-existing Bank `$18` infrared UI independently calls the same `$5836` entry with a 20-point scale, confirming that this is a general segmented-meter primitive.

`SegmentedMeter_LoadGraphics` copies the first eight tiles of `PropertyStateMeterGraphics`, exactly the subset required by the six fill states. The infrared UI already calls this `$5828` entry when building its interface.

## Graphics and palettes

`gfx/ui/property_state_meter.png` is the editable 152x8 source for the 19-tile `$59FB-$5B2A` graphics block. It is a 2-bit indexed PNG and round-trips through the project's legacy `rgbgfx` converter to the exact 304 retail bytes.

`PropertyStateMeterOwnershipPalettes` contains the three original four-color BGR555 palettes selected by the side-0, side-1, and neutral-property tile ranges.

## Integration

`PropertyState_ApplyDeltaWithPresentation` now calls `PropertyStateMeter_Setup` and `PropertyStateMeter_DrawValue` symbolically rather than raw `$571B/$580E` addresses. The connected FORTIFY availability verifier was also modernized to expect `PropertyState_CompareCurrentToTerrainMaximum` instead of the obsolete raw Bank `$0C:$58BA` call spelling.

`make check-property-state-presentation` locks the fixed addresses, exact retail fingerprints, graphics payload, symbolic integration, and unchanged custom-English ROM hash.
