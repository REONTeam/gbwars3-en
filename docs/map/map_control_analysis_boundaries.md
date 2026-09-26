# Map-control analysis helper boundaries

the project re-audits the Bank `$0D:$58F2-$5D9B` map-analysis helper source added around the project. The retail byte stream and the callback/caller graph show that several provisional section starts landed inside instructions or immediately before a preceding routine's `ret`. The emitted byte stream was preserved because those routines were still represented as `db` rows, but the semantic ownership boundaries were wrong.

## Corrected entry points

The phase-cell callback table built by `MapControl_BuildPhaseAnalysisWorkspace` uses `$58F2`, `$590F`, `$593D`, and `$5928`. This proves that `MapControl_ClearPhaseCellReference` runs through the `call $08C5` and `ret` at `$590B-$590E`, while `MapControl_LoadPhaseCellReference` begins at `$590F`, not `$590D`.

The candidate-test body at `$593D` ends with the `ret` at `$599A`, so `MapControl_ClearNeighborPhaseReferences` begins at `$599B`. Likewise, `MapControl_StageAnalysisCoordinates` ends at `$5BB4`, and `MapControl_FindNearestEligibleCell` begins at `$5BB5` with its `push de / ldh a,[hWRAMBank]` prologue.

The derived-map callback graph independently proves `$5CC0` as `MapControl_ClassifyDerivedCell`: `MapControl_BuildMapAnalysisBuffer` installs `$5CC0` as a callback and calls it directly for each cell. Therefore `$5CBC-$5CBF` is the complete `MapControl_UpdateDerivedCellState` wrapper (`call $08C5 / ret`), and the classifier's initial `push bc` belongs at `$5CC0`.

Finally, `MapControl_RemoveDerivedBufferValue` ends with `ret` at `$5D2A`; the following `push bc` at `$5D2B` is the true start of `MapControl_TestDerivedCellMatch`.

## Preservation and semantics

These are source-structure corrections only. The corrected ranges reconstruct byte-for-byte against the supplied Japanese retail ROM, and no English/custom text, graphics, map data, Campaign briefing anchors, or prior-disassembly reference material is changed. Higher-level tactical names remain conservative until the opaque search criteria are decoded from callers and data contracts.
