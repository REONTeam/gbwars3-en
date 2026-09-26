# Map popup and HP-change presentation runtime

Bank `$0C:$5B43-$66BA` is the shared map-space popup/presentation family used by unit creation/removal, HP redistribution, signed HP changes, maximum-flank feedback, and experience-rank increases. The entire range is source-owned and byte-exact against the Japanese retail ROM while the existing custom-English ROM remains unchanged.

## Runtime layout

- `$5B43-$5C23` provides shared OBJ-palette loading, six paired unit-transition entry points, map-space transition sprite creation, animation completion waits, and frame waits.
- `$5C24-$5D3D` presents HP redistribution between adjacent units. It derives the donor/receiver from the Unit Status result, resolves one of six hex directions, loads the transfer-magnitude graphic, and moves the popup sprite along the source-to-target vector.
- `$5D3E-$5E15` presents signed HP changes. Deltas `+1..+4` and `-1..-4` select separate OAM/animation variants and use the shared vertical-bounce motion.
- `$5E16-$5E70` presents the direct-combat maximum-flank marker. Producer analysis ties this entry to the retail flank value `50`.
- `$5E71-$5F06` presents experience-rank increases and ends on the explicit `UP` marker. `$5ECC` is the generic map-coordinate-to-screen sprite positioner used by these popup effects.

The unit-transition pair at `$5B75/$5B86` is behavior-backed by the unit-creation controller, while `$5B8F/$5BA0` is behavior-backed by HP-transfer zero-HP deletion. `$5B5B/$5B6C` is behavior-backed as the deployment transition by the reserve Unit List and selected-map CALL placement controllers in Bank `$0C:$7B89-$7D67`.

## Resources

`$5F07-$66BA` contains the connected OAM frames, animation streams, graphics, and OBJ palettes. Four editable source images are retained beside their generated tile payloads:

- `gfx/effects/map_unit_transition.png` — 13 tiles / 208 bytes.
- `gfx/effects/unit_hp_transfer.png` — 36 tiles / 576 bytes.
- `gfx/effects/map_hp_change.png` — 12 tiles / 192 bytes.
- `gfx/effects/map_status_markers.png` — 20 tiles / 320 bytes.

The bundled legacy `rgbgfx` regenerates each `.2bpp` file byte-for-byte.

## Symbolic consumers

The Unit Creation controller uses the creation transition pair. HP transfer uses the prepare/present routines and the removal transition pair. Area attack uses `MapHPChange_PresentSignedDelta`. The experience/rank-change controller uses `UnitRank_PresentIncreaseAtCoordinates`. The transition runtime also reuses the already-source-owned area-attack map-coordinate positioner rather than embedding its numeric address.

`make check-map-popup-presentation-runtime` verifies the complete retail range, public entry addresses, symbolic integrations, editable-graphics round trips, and the unchanged custom-English ROM hash.
