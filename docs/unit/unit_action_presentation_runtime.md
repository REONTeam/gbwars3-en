# Unit Action Presentation Runtime

Bank `$0C:$66BB-$6866` owns the shared action-side presentation selector and parameter staging used by CAPTURE, FORTIFY/development, SUPPLY, LOAD, carried-child MOVE, and Construction Truck actions.

The public entry `UnitAction_PresentActionEffect` accepts a ten-way selector in `A`. When map presentation is enabled (`wMapAnalysisOptions` bit 2), it derives an appropriate Bank `$1A` presentation-sequence index and runs that sequence around the shared cursor/map transition. The selector table is fixed at `$6733-$6746`; `$678F-$679D` is the separate 15-byte property/terrain presentation-class table.

## Shared presentation parameters

`$C4A1/$C4A2` are intentionally named `wPresentationParam0` and `wPresentationParam1`. They are shared presentation scratch with action-specific lifetimes, not a single gameplay structure:

- property capture/development: presentation property class + terrain band;
- supply: adjacent target unit type + acting unit type;
- load: child unit type + carrier unit type;
- prepared carried-child MOVE: staged unit-type pair copied from `$C9B0/$C9B1`;
- construction actions: resource/presentation class plus, where required, the current palette/side variant.

The result-presentation code also reuses these bytes with its own lifetime. Code outside presentation contexts should therefore prefer a local specialized alias rather than assigning a universal gameplay meaning to `$C4A1/$C4A2`.

## Presentation sequence identities

The producer/consumer chain now gives stable names to sequence indexes 0-7:

- `0`: completed property CAPTURE; the map-result layer aliases the same sequence as HQ loss;
- `1`: incomplete property CAPTURE progress;
- `2`: terrain transformation used by FORTIFY/development and construction effects;
- `3`: SUPPLY;
- `4`: LOAD with an ordinary carrier;
- `5`: carried-child MOVE with an ordinary carrier;
- `6`: carried-child MOVE with carrier type `$2E/$2F`;
- `7`: LOAD with carrier type `$2E/$2F`.

Selector 8 still returns index 8, but its exact gameplay identity remains deliberately numeric. These indexes live in `constants/presentation_constants.inc`; the stagers use the constants instead of raw sequence numbers without changing emitted bytes.

## Carried-child MOVE staging

`UnitAction_PrepareCarriedChildMovePresentation` at `$6804` records the active child unit type and its carrier class in `$C9B0/$C9B1`, together with a later presentation sequence in `$C9AF`. The selector-4 path consumes this triplet when the MOVE action completes. Carrier types `$2E/$2F` select the special presentation sequence used by retail.

## Verification

`make check-unit-action-presentation-runtime` verifies:

- all 428 retail bytes at Bank `$0C:$66BB-$6866`;
- the ten-entry stager pointer table and 15-byte property-class table;
- symbolic action-side callers for `$66BB/$6804`;
- centralized neutral presentation scratch names;
- the established custom-English linked-ROM SHA-256.
