# Map AI procurement / unit-composition runtime

the project source-backs physical Bank `$0D:$4E53-$55C7` as one contiguous AI unit-procurement planning tranche. It is downstream of the project phase-analysis state and repeatedly consumes `wMapControlPhaseAnalysisFlags` while constructing desired unit counts and prioritized `(unit type, count)` entries.

## Proven scratch geometry

The runtime uses WRAM bank 2 `$DD81-$DE8A` as type-indexed planning state. `$DD81-$DDB4` is a 52-byte per-type live-unit count array and `$DDB5-$DDE8` is a parallel 52-byte desired-count array. The size is significant: it covers UnitData types 0-51 exactly and excludes `UNIT_TYPE_DUMMY` (52). `MapAI_CountActiveUnitsByType` clears and rebuilds the first array from 50 live-unit slots; `MapAI_InitializeDesiredUnitPlan` clears the second array and enables entries only for types accepted by the already-source-backed purchase filter.

`$DDED` is the number of packed procurement entries. `$DDEE-$DE55` is exactly 104 bytes, enough for 52 `(unit type, desired count)` pairs; `MapAI_AppendDesiredUnit` writes those two bytes per accepted type and updates the parallel desired-count array. `$DE56` begins a separate composition flag byte and `$DE57+` begins another 52-byte type-count array used by the secondary/opposing-side evaluation path. `$DDE9-$DDEC` are four one-byte category thresholds populated later in the same tranche; their exact gameplay labels remain conservative.

## Phase-analysis consumers

The producer-proven current source bits now have direct procurement consequences:

- `MAP_CONTROL_ANALYSIS_READY_F` enables transport-aircraft planning. The routine adds Transport Helicopter (`$2A`) and Transport Plane (`$25`) desired entries using a capped count derived from adjacent analysis state.
- `MAP_CONTROL_ANALYSIS_TRANSPORT_ROUTE_F` adds Transport Ship (`$30`) demand. When the Infantry HQ route is absent, the same path also derives APC (`$0D`) and IFV (`$17`) needs from the Infantry desired count.
- `MAP_CONTROL_ANALYSIS_INFANTRY_HQ_ROUTE_F` independently adds fixed APC and IFV demand in another composition path.

This proves the phase-analysis workspace is not passive diagnostics: it directly shapes the CPU side's unit-composition/procurement plan. Stronger strategic names such as "invasion", "amphibious assault", or "capture strategy" are intentionally avoided because the later purchase execution/action-selection callers are not yet sourced.

## Composition tables

`$550C-$55C7` is a family of zero-terminated `(unit type, count)` tables consumed by `MapAI_AppendDesiredUnitTable`. The records are structurally explicit and contain recognizable air, naval-support, and ground-combat mixes. Examples include Battle Helicopter / Attack Plane / Fighter / Bomber groups, Small/Large Carrier plus Supply Tanker groups, and Tank/Artillery/AA/Rocket/Tank-Destroyer groups. Their numeric policy-family identities remain positional until the selectors at `$4FBE-$5185` are tied to higher-level map/AI modes.

The complete source-owned span is **1,909 bytes** (`$4E53-$55C7`). Existing English/custom text, graphics, maps, and Campaign briefing data are not touched.
