# Map-control movement-cost field and phase-route semantics

the project resolves the callback-driven `$58A2-$599A` layer as a weighted hex-grid movement-cost field rather than generic phase-cell references.

`MapControl_BuildMovementCostField` reads `UNIT_DATA_MOVEMENT_PROFILE_OFFSET` from the encoded unit type in `A`, builds the 52-entry raw-tile movement-cost cache, clears the two-plane 16-bit field at SRAM `$A000-$BFFF`, installs four callbacks, and invokes `HexGrid_RunCallbackFloodFill`. The ROM0 flood-fill engine at `$0850-$08F4` uses a WRAM-bank-7 coordinate queue at `$DE00`, walks all six hex neighbors, and delegates seed/load/test/store behavior through the four callback pointers at HRAM `$FFA3-$FFAA`.

The callbacks at `$58F2/$590F/$5928/$593D` seed a cost of zero, load/store a split 16-bit cost, and accept a neighbor only when its terrain movement cost is nonzero and the newly accumulated cost is lower than the existing field value. Earlier `PhaseCellReference` names remain compatibility aliases.

## Route-river reference

`MapControl_FindRouteRiverReference` (`$59D4-$5A85`) builds the field from the current phase side's HQ using `UNIT_TYPE_DUMMY`'s movement profile. Starting at the opposing HQ, it repeatedly subtracts the current tile's cached movement cost and chooses a neighbor whose field value equals that predecessor cost. This reconstructs one exact shortest route back toward the current HQ.

Whenever the backtrack stands on raw map tile `$28` (`MAP_TERRAIN_RIVER`), it records that coordinate. Because backtracking proceeds from the opposing HQ toward the current HQ and later River cells overwrite earlier ones, the final `$DE9A/$DE9B` pair is the River reference nearest the current HQ on that selected shortest route. It remains `$FF/$FF` if the opposing HQ is unreachable, the route cost is zero, or no River is encountered. `wMapControlRouteRiverX/Y` are the canonical names; `wMapControlReferenceCellX/Y` remain compatibility aliases.

## Phase-analysis flags

`MapControl_RefreshPhaseState` clears `$DEA0`, then performs three producer-proven updates:

- bit 0 (`MAP_CONTROL_ANALYSIS_INFANTRY_HQ_ROUTE_F`) is set only when a movement-cost field built from the current HQ with encoded Infantry (`UNIT_TYPE_INFANTRY << 1`) gives the opposing HQ a non-`$FF` cost. It therefore records Infantry-profile HQ-to-HQ reachability.
- bit 1 (`MAP_CONTROL_ANALYSIS_READY_F`) is set unconditionally after the Infantry reachability test reaches its normal completion point. It is a phase-analysis-ready marker, not a separate candidate success.
- bit 2 (`MAP_CONTROL_ANALYSIS_TRANSPORT_ROUTE_F`) is set by `MapControl_FindTransportRouteCandidates` only after a nearest-Port/current-HQ candidate is found, that Port seeds a `UNIT_TYPE_TRANSPORT_SHIP` movement-cost field, and a finite-cost opposing-HQ-region approach candidate is also found.

These are behavioral names only. They do not assign a stronger player-facing AI strategy name to the consumers that use the results.
