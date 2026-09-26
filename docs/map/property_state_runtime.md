# Property state runtime

Bank `$0C:$5883-$599B` is the shared property capture/development state runtime. It operates on the WRAM-bank-1 property-state table beginning at `$DD81`; `$DD80` is the active-record count used by construction when allocating a new record.

Each of the 100 fixed slots is three bytes: `{state, X, Y}`. `$FF` in the state byte marks an unused slot. `PropertyState_GetAtCoordinates` and `PropertyState_SetAtCoordinates` scan by B/C coordinates, while `PropertyState_FindRecordIndexAtCoordinates` returns the matching slot number.

## State limits

`PropertyState_BaseAndMaximumByTerrainClass` at `$5984-$599B` contains 12 two-byte `{base, maximum}` pairs indexed through `TerrainNameIndexByMapTile`:

`{00,00}, {14,28}, {0A,1E}, {00,0A}, {0A,1E}, {00,0A}, {0A,1E}, {00,0A}, {0A,14}, {0A,1E}, {00,0A}, {0A,1E}`.

The base value is written after a completed ownership/property transition. The maximum is used to clamp positive development changes and to decide whether FORTIFY/development is already complete.

`PropertyState_ApplySignedDeltaAtCoordinates` accepts a signed delta in A, clamps the result to `0..maximum`, and stores it. `PropertyState_ApplyDeltaWithPresentation` wraps that mutation with the retail one-point-at-a-time visual/audio progression. CAPTURE passes negative current HP; development passes positive current HP. CAPTURE therefore completes at zero, while development moves upward toward the terrain-class maximum.

The visual meter setup/renderer immediately before this range (`$571B-$5882`) is source-owned, together with its meter graphics/palettes. The earlier `$5626-$571A` table-management family is source-owned separately; see `docs/map/property_state_table_management.md`.

## Integration

The CAPTURE executor, FORTIFY/development executor and predicate, and action-presentation stager now call the Bank `$0C` property-state API symbolically. The same WRAM1 record block is also used by Bank `$0D` map-control scans; those consumers now use `wMapPropertyStateRecords` rather than a raw `$DD81` address.

`make check-property-state-runtime` verifies all 281 retail bytes, the 24-byte limit table, public entry addresses, WRAM symbols, symbolic callers, and the unchanged custom-English ROM hash.
