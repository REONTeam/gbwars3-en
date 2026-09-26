# Map AI post-procurement action runtime

the project source-backs physical Bank `$0D:$55C8-$58A1` as a contiguous 730-byte AI action-selection/execution tranche immediately following the project procurement tables and ending exactly before the already-owned `$58A2` movement-cost subsystem. Retail SHA-1: `26e376a09b83149c2ac6d8c14202aaee3095549a`.

The public loop at `$55C8` walks the active side's 50-unit pool and attempts three action families in order. The subordinate routines test live-unit state, map/unit conditions and candidate coordinates, then stage action coordinates through the established `$C5EC-$C5EE` action workspace before invoking the existing action executor. Because several external Bank `$0B/$0C/$12` callees remain address-only, the three action families retain neutral `Primary/Secondary/Tertiary` names rather than speculative capture/load/attack labels.

`$578D-$5841` performs a bounded coordinate search using the already-typed map-analysis records at WRAM bank 2 `$DD81+`, rejecting occupied or unsuitable cells and retaining the best coordinate pair in HRAM scratch. `$5842-$588E` scans the 50-unit pool for a compatible target under a UnitData pair filter; `$588F-$58A1` is a compact map-class membership test used by the coordinate search.

This closes the entire Bank `$0D:$55C8-$58A1` overlay gap between procurement planning and movement-cost analysis without changing custom English text, graphics, map data or Campaign briefing content.


## the project follow-up

The previously generic `$5842` helper now has the canonical alias `MapAI_FindCompatibleCarrierTarget`. Its two candidate unit types are Large Carrier and Small Carrier, and the newly sourced Bank `$0B:$5D84` predicate proves the target must accept the selected unit's carrying class and still have transport capacity.

The common action dispatcher at `$0D:$4407` is now source-owned. Action code 6 calls the sourced Bank `$0B:$5DC7` load executor, so every current source branch that stages `$C5EC = 6` is specifically requesting an embark/load action. The remaining action codes retain neutral identities.
