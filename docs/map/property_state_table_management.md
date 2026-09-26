# Property-state table management

Bank `$0C:$5626-$571A` owns the lifecycle around the WRAM-bank-1 property-state table used by capture, development and constructed properties.

`PropertyState_RebuildRecordsFromMap` at `$5626` clears the 100 three-byte slots at `wMapPropertyStateRecords`, scans the active map dimensions, maps each raw tile through `Terrain_GetNameIndex`, and creates records for the twelve state-bearing classes. `PropertyState_InitializeRecordFromTerrainClass` at `$567C` writes the class-specific base state plus X/Y coordinates.

`PropertyState_AddRecordAtCoordinates` at `$5697` is the construction-side allocator. It finds the first `$FF` slot, updates the raw-tile histogram, creates the state record, recalculates income, and increments `wMapPropertyStateRecordCount`. The RUNWAY construction path now calls this entry symbolically.

`PropertyState_RemoveRecordAtCoordinates` at `$56D5` is the inverse: it clears the matching record, decrements the tile histogram, recalculates income, and decrements the active-record count. Its currently visible caller is still inside an unsourced Bank `$0C` map-mutation family, so that caller remains a later integration target rather than being guessed from proximity.

`MapGrid_CountPropertyTiles` at `$5705` sums histogram entries `$00-$1F`, the complete raw property/building range below natural terrain `$20`. The Map Editor calls this helper before enforcing its 100-property/building limit; the surrounding editor controller remains a separate source-ownership target.

`make check-property-state-table-management` locks all 245 retail bytes, public entry addresses, symbolic source-owned callers, the two remaining opaque cross-references, and the unchanged custom-English ROM hash.
