# Map AI tactical driver and target-priority selector (the project)

Physical Bank `$0D:$4000-$4320` is now continuously source-owned. `$4000-$4105` contains two mirrored 50-unit tactical-planning sweeps and their worker routines. `$4106-$4320` contains the upstream target-priority selector and two fixed unit-domain priority lists immediately before the project scheduler at `$4321`.

The selector boundary is byte-proven. `$4106` loads `wUnitRecordScratch`'s encoded type/side byte, shifts it right once to obtain the UnitData type index, and then reaches `$410B`, which is the instruction `call $4A35`. A direct same-bank call at `$404F` targets `$4106`; therefore `$410B` must not be treated as a routine entry.

`$4A35` is now `MapAI_GetTargetPriorityListForUnitType` (compatibility alias `MapAI_GetUnitTypeListProfileA`). It indexes the 52-entry Profile-A pointer table with the acting unit type. For each candidate unit, `$41A6` returns the candidate type's zero-based position in that list. The selector keeps the lower rank: after loading the current candidate rank into `B`, it compares the saved best rank with `cp b` and skips replacement only when the existing rank is already lower. A candidate on raw map tile `$20+` receives `+$40` before comparison.

This establishes Profile A as an ordered **target-priority** table, without requiring guesses from the unit names in each list. `MapAI_TargetPriorityListTable` is the canonical behavior-backed alias; the earlier `MapAI_UnitTypeListProfileTableA` label remains for compatibility.

The selector also contains two literal domain priority lists. `$42EC` contains every real non-air type exactly once (`1-28` and `44-51`) before a zero terminator; `$4311` contains every air type exactly once (`29-43`) before its terminator. These are now `MapAI_NonAirUnitPriorityList` and `MapAI_AirUnitPriorityList`.

`$4A3C` is a second 52-entry profile lookup and now has a true source label (`MapAI_GetUnitTypeListProfileB`). Whole-ROM direct-xref scanning still finds no direct `CALL` or `JP` to it. Indirect use remains possible, so Profile B is intentionally not declared dead and its policy meaning remains neutral.
