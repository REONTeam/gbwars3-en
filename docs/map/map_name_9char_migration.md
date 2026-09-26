# 9-character map-name sidecar implementation

## Implemented design (the project)

Game Boy Wars 3 now has a backward-compatible logical **9-character map-name** path without widening the physical map record. Characters 1-8 remain in the retail 8-byte name field; character 9 is stored in reserved map-header byte `$1F`.

The persistent/runtime locations are:

- loaded map sidecar: `wMapRecordNameExtra` = `$CA40`
- loaded base name: `wMapRecordName` = `$CA41-$CA48`
- editor sidecar: `wEditorMapNameExtra` = `$C8A4`
- editor base name: `wEditorMapName` = `$C8A5-$C8AC`

`MAP_RECORD_NAME_SIZE` intentionally remains **8**, because it describes the physical contiguous retail field. `MAP_RECORD_NAME_LOGICAL_SIZE` is **9**. The complete prefix remains **46 bytes**.

## Compatibility properties

The implementation does not move any persistent record fields:

- the 32-byte map header remains 32 bytes;
- the four map fields remain at `$CA49-$CA4C` / `$C8AD-$C8B0`;
- width/height remain at `$CA4D/$CA4E` and `$C8B1/$C8B2`;
- terrain and initial-unit placement offsets do not move;
- Bank `$28` map pointers and map-record lengths do not move;
- user-map SRAM slots remain fixed `$1000`-byte containers;
- the serialized map body still begins at slot offset `$0524`;
- no SRAM format version bump is required.

All 122 retail ROM map records have `$00` at header offset `$1F`. Legacy maps and legacy SRAM slots therefore naturally represent an empty ninth character. The existing serializer/deserializer already copies the full 46-byte prefix, so the sidecar is preserved without changing the save layout.

## Text input

Map Editor text-input mode 2 now treats the name as a logical 0-9-character string:

- `$CC2F-$CC36` hold characters 1-8;
- `$CC37` (`wTextInputMapNameExtra`) holds character 9;
- `$CC38` remains live retail text-input state.

The mode-2 length scan is bounded at eight base characters and then checks the sidecar. Append allows a ninth character and writes it only to `$CC37`; backspace from length 9 clears that sidecar before returning to the base field.

The mode-2 redraw path temporarily saves `$CC38`, writes zero there while `TextPut` reads the logical nine-character string, and restores `$CC38` immediately afterward. Non-map text-input modes retain the retail six-character behavior.

## Display and cache strategy

The implementation avoids relocating transient buffers. Each renderer places character 9 in the existing byte immediately after the eight-character base and temporarily borrows the next live byte as the zero terminator while `TextPut` executes.

- Map Menu scratch: `$DC3B-$DC42` base, `$DC43` sidecar, `$DC44` temporarily zeroed/restored.
- Editor display scratch: `$CC65-$CC6C` base, `$CC6D` sidecar, `$CC6E` temporarily zeroed/restored.
- Selected-map cache: `$CC89-$CC90` base, `$CC91` sidecar, `$CC92` map index temporarily zeroed/restored during rendering.
- Unit Status bank-4 scratch: `$DB5A-$DB61` base, `$DB62` sidecar, `$DB63` temporarily zeroed/restored.

This keeps all adjacent retail state at its original address.

## Proof map

Standard map 00 now demonstrates the feature with the English name **`BALL ISLE`**:

- physical 8-byte name field: `BALL ISL`
- header `$1F` sidecar: `E`

The map record remains exactly the same size and starts/ends at the same addresses as before.

## Verification

`tools/verify_map_name_9char.py` / `make check-map-name-9char` checks the sidecar constants and symbols, retail zero-sidecar invariant, editor bridge, mode-2 hooks, display/cache save-zero-restore behavior, hook anchors in the Japanese ROM, and the `BALL ISLE` composition proof.

The full historical map/SRAM verification suite is also expected to remain green. A linked-ROM/runtime test is still desirable once a complete RGBDS build toolchain is available; the bundled RGBDS Git snapshot still lacks generated parser files and this environment does not currently provide Bison.

## Remaining map-name work

The storage/input/display architecture for nine characters is now implemented. Remaining work is validation and polish rather than a format redesign:

1. build and link the complete ROM with a working RGBDS 1.0.3 toolchain;
2. test Map Editor name entry at lengths 0, 8, and 9 on hardware/emulator;
3. test save/load/copy/delete of a 9-character user map and confirm legacy user maps remain readable;
4. inspect UI spacing for each nine-character renderer and adjust coordinates only where visual testing proves necessary;
5. convert additional English map names to nine characters only where the localization benefits.

## Rejected fallback

The earlier the project proposal to widen every map prefix from 46 to 47 bytes remains rejected unless the sidecar design is later disproven. It would unnecessarily shift live WRAM fields, terrain streams, record boundaries, and SRAM layouts.

## Retained the project collision evidence

The implemented sidecar avoids the contiguous-width collision addresses proven in the project, but those addresses remain useful regression evidence: `$CA4F`, `$C8AD`, `$CC38`, `$CC6E`, and `$CC92` are live retail state, and serialized SRAM body data begins at slot offset `$0524`. This is why the sidecar remains the preferred **backward-compatible SRAM-slot** design rather than a 47-byte prefix.
