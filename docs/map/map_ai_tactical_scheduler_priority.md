# Map AI tactical scheduler and unit-type priority profiles (the project)

the project promotes two previously staged Bank `$0D` pieces into the documented tactical-AI architecture and removes an overlapping source claim left by the project.

`$4321-$4406` is the scheduler lead-in immediately before `MapAI_DispatchAction` at `$4407`. The entry reads the active unit's UnitData target class and selects strategic movement candidates from the already-proven phase analysis: the River reference, opposing-HQ-region transport candidate, phase-side pair and derived movement-field search. `$43B7` is a separate best-unit-candidate helper reached directly by the scheduler. The exact higher-level strategy name remains deliberately conservative.

`$4A43-$4B90` is no longer opaque scorer bytes. It consists of two 52-entry unit-type-indexed pointer tables followed by zero-terminated unit-type lists. The width exactly covers UnitData types 0-51 and excludes `UNIT_TYPE_DUMMY`. The lists visibly separate ground-heavy, broad non-air, air, naval, light-ground and mixed candidate sets, but the exact score/priority meaning of table A versus table B is still deferred until all readers are mnemonic source.

the project's `MapAI_TacticalTargetSearchAndScoring` is therefore narrowed to `$4749-$4A42`; `map_ai_tactical_priority_data.asm` is now the sole owner of `$4A43-$4B90`.
