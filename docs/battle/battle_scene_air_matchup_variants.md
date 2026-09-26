# Battle scene air-matchup variants and active-slot scheduling (the project)

the project resolves the scratch-state chain used by the Bank $14 used-weapon resource controller.

## Air-matchup variant

Bank $16 `BattleScene_GetAirMatchupVariant` works from the two UnitData types already cached at `$C4B7/$C4B8`. The shared Bank $18 three-way classifier uses the exact UnitData boundaries `$1D` and `$2C`: ground types 0-28, air types 29-43, and naval types 44-51. The selector then collapses that to the air/non-air relationship relative to the current battle side:

- `0`: both units are air or both are non-air;
- `1`: current unit is non-air, opponent is air;
- `2`: current unit is air, opponent is non-air.

The side-0 result is stored at `$C4DC`; side-1 at `$C4DD`. These values are the three variants used by the Bank $17 used-weapon animation-pointer matrix.

## Ten-slot scheduler

`$C4B6` is the physical scan cursor over the ten side-specific active-slot bytes at `$D384/$D38E`. `$C4B5` is a separate ordinal that advances only when an active slot is accepted. The accepted ordinal indexes the ten-byte table at `$C4BD`.

Bank $18 rebuilds `$C4BD-$C4C6` by calling the newly source-owned ROM0 `Random_ZeroToDInclusive` ten times with `D = 60`, so every table entry is in the range 0-60. Bank $17 copies the entry selected by `$C4B5` into the common scene timing state, and Bank $14 adds 15 before scheduling the used-weapon resource.

Bank $31:$41BF selects a **UnitData-type layout pointer**, applies a 20-byte side offset for side 1, indexes the physical slot as a two-byte entry, and returns that entry in BC. the project sources the complete 52-pointer/51-record family through `$4A49`; `wBattleSceneLayoutUnitType` is therefore the UnitData type, not a generic resource class.

The exact meaning of each returned two-byte slot entry remains intentionally structural; the UnitData/side/ten-slot indexing geometry is now proven.
