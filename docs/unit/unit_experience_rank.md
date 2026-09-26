# Unit experience and rank semantics

the project promotes the live-unit 16-bit field at offsets `$0A-$0B` from a positional name to **experience**.

The identification is supported by three independent layers:

1. The already-sourced Bank `$12` writer adds to the field and clamps it to **400**.
2. The adjacent helper divides the same field by **100** and returns the quotient. With the clamp, the only results are 0-4, matching the game's five visible ranks **D, C, B, A, S**.
3. the project's Campaign reserve-unit path preserves this exact word when surviving units are stored and restored between maps. Public gameplay documentation independently describes Arrangement as retaining unit experience between Campaign battles and rank-ups at each 100 EXP threshold.

The source therefore names the field `UNIT_RECORD_EXPERIENCE_OFFSET`, the writer `UnitRecord_AddExperienceClamped`, and the quotient helper `UnitRecord_GetExperienceRank`.

## Rank values

| Rank | Value | Minimum EXP |
| --- | ---: | ---: |
| D | 0 | 0 |
| C | 1 | 100 |
| B | 2 | 200 |
| A | 3 | 300 |
| S | 4 | 400 |

`UNIT_EXPERIENCE_MAX` remains 400 because that limit is emitted by the sourced routine itself. The project does not source the still-overlay-owned `$12:$4991+` level-table/combat-multiplier code, so no attack/defense bonus semantics are imported into source without the verification ROM.
