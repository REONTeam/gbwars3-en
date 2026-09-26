# Unit terrain resupply / repair compatibility

the project closes the old Bank `$12:$4656-$4740` overlay gap and ties it directly to the AI action/runtime callers. The entire 235-byte range is now explicit source (retail SHA-1 `ccbe13a1a6219e3247aa3f525f7179f00882d9b2`).

`Unit_CanResupplyAtCurrentTerrain` takes a live-unit index plus its encoded unit/side value and tests the unit's current map cell. The cell must classify as a **current-phase property**. Ordinary ground units accept the current HQ/City/Base family; Construction Truck and Supply Truck variants exclude City; naval/submarine target classes require Port; aircraft accept Airport **or Runway**. Return `0` means supported, `$FF` means unsupported.

`Unit_CanRepairAtCurrentTerrain` is the equivalent current-cell wrapper for repair. Its reusable helper `Unit_CanRepairOnMapTile` takes an encoded unit/side value plus a raw tile ID and applies the same phase/property and unit-domain rules, except aircraft repair only at **Airport** and not Runway. This distinction is what separates the previously similar `$4656` and `$46C8/$46E0` routines.

The shared Bank `$0B:$7CF7-$7D23` `MapTile_GetPhaseOwnershipClass` / `MapTile_ClassifyOwnershipForCurrentPhase` routine remains the authoritative phase-relative property classifier: current-side property = 0, opposing-side property = 1, neutral property = 2, and non-property terrain = 3. the project promotes symbolic constants for those four values and uses them in the new service source.

The project repair eligibility path at `$0D:$5720` now calls `Unit_CanRepairAtCurrentTerrain` symbolically and has the compatibility alias `MapAI_TestRepairActionEligibility`. This does **not** rename the entire higher-level action family: its surrounding execution still has additional state/HP conditions, so the broader action remains behavior-oriented until all downstream effects are traced.

Existing English/custom text, graphics, map records, SRAM formats, and Campaign briefing payloads are untouched.
