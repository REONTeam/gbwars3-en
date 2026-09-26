# Map-control phase runtime (the project)

the project extends physical Bank `$0D` map-control ownership through `$68C1` and sources the two dependencies called by the project initializers.

## Force-state continuation

`$6758-$686F` consumes `wMapControlForceClass`. The first helper returns 0 for balanced, 1 when the current phase side is the favored side, and 2 when the opposing side is favored. Later helpers fold that relation into a compact cached state and gate a late-phase resolution path.

The gate is deliberately documented only by proven conditions: control flag bit 5 is set, runtime state is zero, the phase counter is sufficiently late, the active side is outnumbered by more than 2:1 with at least ten opposing units, the active-side word at the `$C642/$C644` pair is below 30, and the active side is on the severe (>4x) losing side of the force classifier. The resulting event is not named yet.

## Phase refresh

`$6870-$68C1` temporarily switches to WRAM bank 2, clears `wMapControlPhaseAnalysisFlags` (`$DEA0`), calls the `$59D4/$5DA5/$58A2/$5D9C` chain, and stores the reference-cell coordinates returned in `B/C` into `wMapControlReferenceCellX/Y` (`$DE9A/$DE9B`). the project further proves `$DE9C-$DE9F` are two later candidate coordinate pairs and `$DEA0` is a result bitfield with bits 0-2 set by distinct success paths. Exact tactical identities remain intentionally unnamed until the intervening search helpers are owned.

## Rebuilt dependencies

`MapControl_RebuildCaptureTargetMask` at `$4B91-$4BE0` clears the 13-byte mask at WRAM-bank-2 `$DD80` and scans 100 three-byte raw-tile/X/Y analysis records at WRAM-bank-1 `$DD81`. the project sources the former `$0B:$7D33` predicate and proves that accepted entries are opposing-side properties or intact neutral properties; active-side properties, neutral ruins, and ordinary terrain are omitted. Accepted record indices are set with `Bitfield_Set`. `MapControl_RebuildUnitEligibilityMask` remains only as a compatibility alias.

`MapControl_BuildMapAnalysisBuffer` at `$5C42-$5CBB` clears `$A000-$AD7F`, then walks `x=0..$C989-1` and `y=0..$C98A-1` through the existing map-cell helper chain. It stores the final derived state count at `$C60C`.

These names intentionally describe observable dataflow, not guessed AI or UI identities.
