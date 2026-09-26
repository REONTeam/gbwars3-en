# PAVE, FIRE availability, and end-phase upkeep

Bank `$0C` contains the target scan that enables FIRE, the Construction Truck PAVE runtime, selected-map END preparation, and the end-phase aircraft fuel upkeep loop.

## FIRE availability (`$4000-$40C0`)

`UnitAction_CheckFireAvailable` builds the same target-ID list later consumed by the interactive FIRE selector. It scans the opposing 50-unit pool, ignores empty/carried/reserve records, computes hex distance, and delegates weapon suitability to `Battle_SelectWeaponAttackIgnoringAmmo`. FIRE is available when at least one candidate survives those tests.

## PAVE (`$7078-$72B3`)

PAVE is available only to a non-carried Construction Truck. Its weapon-1 ammunition is the paving resource. `UnitPave_GetTerrainCost` establishes the retail terrain costs: PLAIN costs 1, WOOD and WASTELAND cost 2, and every other terrain costs 0 and is not paveable.

The route analyzer reuses the map movement interaction while tracking two independent costs: normal movement cost in WRAM bank 5 and cumulative paving cost in WRAM bank 7. Opposing occupied cells are rejected. Cells adjacent to opposing units may be selectable but do not propagate the breadth-first search farther. Route execution converts eligible queued cells to ROAD, consumes the corresponding paving resource, updates the map, and advances the established Campaign development statistics.

## Selected-map END preparation (`$72B4-$72DD`)

`MapControl_PrepareSelectedMapEndCommand` stores the active side's cursor/action coordinates in a lifetime-scoped side pair, sets the END transition-start flag, and starts the established transition audio.

## End-phase aircraft fuel upkeep (`$72DE-$73A4`)

`UnitPhase_ProcessAircraftFuelUpkeep` scans the active side's live-unit pool. Empty, reserve, carried, and non-air records are skipped. Aircraft parked on a current-side AIRPORT or RUNWAY do not pay fuel upkeep. Other aircraft lose their UnitData fuel-upkeep value; aircraft whose fuel reaches zero are presented with the normal destruction animation and removed through the established map-resolution refresh path.
