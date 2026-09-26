# Map-control phase-analysis workspace

the regression suite type the WRAM-bank-2 scratch used by `MapControl_RefreshPhaseState` and its movement-analysis helpers. the project replaces the remaining neutral coordinate/flag descriptions with producer-proven behavior while avoiding a stronger player-facing AI strategy name.

## Proven coordinate fields

`$DE9A/$DE9B` are `wMapControlRouteRiverX/Y`. `MapControl_FindRouteRiverReference` builds a DUMMY-profile movement-cost field from the current HQ, backtracks a shortest descending-cost route from the opposing HQ, and records River tiles encountered along that path. Because the walk runs toward the current HQ and later River hits overwrite earlier ones, the final pair is the River reference nearest the current HQ on the selected shortest route. The older `wMapControlReferenceCellX/Y` names remain compatibility aliases.

`$DE9C/$DE9D` are `wMapControlTransportPortX/Y`. The first transport-route search selects the nearest Port analysis record to the current HQ.

`$DE9E/$DE9F` are `wMapControlTransportApproachX/Y`. After the Port becomes the seed of a Transport Ship movement-cost field, the second search chooses the nearest finite-cost cell inside the opposing HQ's derived region. Older Port/region/Primary/Secondary names remain compatibility aliases.

## Result flags

`$DEA0` remains `wMapControlPhaseAnalysisFlags`. The producer paths prove the three bits precisely:

- bit 0, `MAP_CONTROL_ANALYSIS_INFANTRY_HQ_ROUTE_F`: an Infantry-profile movement field seeded at the current HQ reaches the opposing HQ;
- bit 1, `MAP_CONTROL_ANALYSIS_READY_F`: the phase refresh reached its normal ready point after the Infantry reachability check; this bit is set unconditionally there and is not a separate candidate success;
- bit 2, `MAP_CONTROL_ANALYSIS_TRANSPORT_ROUTE_F`: both the current-HQ-nearest Port and the opposing-HQ-region Transport Ship approach candidate were found.

The complete bitfield still receives no stronger gameplay label than phase-analysis state.

## Phase-side pair helper

The source-backed `$5D9C-$5DB4` helper has two entry points. `$5D9C` flips `wMapPhaseNumber & 1` and returns the opposing side's HQ coordinate pair from `$C646-$C649`; `$5DA5` uses the current phase side directly. These remain `MapControl_GetOpposingPhaseSidePair` and `MapControl_GetCurrentPhaseSidePair`.

## Preservation rule

These names are lifetime-scoped to WRAM bank 2 while the map-control analysis path is active. They do not establish unrelated global ownership of `$DE9A-$DEA0`, and no English/custom data is changed by this work.
