# Map AI tactical scheduler and unit-type list profiles

the project closes the scheduler lead-in immediately before the seven-way map-AI action dispatcher and separates the data tail of the tactical scoring block from executable code.

## Scheduler boundary

Physical Bank `$0D:$4321-$4406` is source-owned as `MapAI_TacticalSchedulerLeadIn`. The byte at `$4320` is **not** part of this routine: it is the zero terminator of the preceding unit-type list. Direct Bank `$0D` callers at `$4056` and `$40E3` target `$4321`, independently fixing the entry boundary.

The scheduler consumes the already-proven phase-analysis/route state and reaches the source-owned action staging/runtime. Policy names remain conservative where the exact ranking objective is not yet proven.

## Tactical list-profile data

The former opaque tail `$4A43-$4B90` is split into `engine/map/ai/map_ai_tactical_priority_data.asm`.

Two pointer tables each contain exactly **52 little-endian entries**, indexed by the real UnitData types `0-51`; `UNIT_TYPE_DUMMY` (`52`) is deliberately outside the table geometry. Each pointer selects one of a small number of shared zero-terminated unit-type lists.

The lists are named only by their observable contents (`GroundHeavy`, `BroadNonAir`, `Air`, `Naval`, `GroundLight`, `Mixed`, or empty). These names describe membership, not tactical intent. Whether a list is a preferred-target, avoidance, support, or other scoring profile remains deferred The Profile-A path is now proven as ordered target priority by the `$4106` selector; Profile B remains neutral until an indirect consumer is proven.

## Preservation rules

No English/custom text, graphics, map records, SRAM format, or Campaign briefing payloads are changed by the project. The Japanese ROM is verification input only.
