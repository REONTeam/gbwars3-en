# Unit transport / turn-status semantics

the project promotes a small set of previously conservative Bank $12 names using the combination of already-sourced behavior and the supplied DataCrystal ROM-map descriptions. No bytes or record geometry changed.

## UnitData loading fields ($1A-$1D)

`UnitData_CheckLoadingCompatibility` at Bank $12:$4329 compares the first unit definition's byte $1A against the second definition's bytes $1B-$1D. The routine treats a zero $1A as the no-class case; otherwise a matching accepted slot returns with Z set. This matches the ROM-map description of $4329-$4350 as the loading-validity test and the UnitData field notes that identify $1A as Carrying Type and $1B-$1D as Carried Type.

The shared constants are therefore:

- `UNIT_DATA_CARRYING_TYPE_OFFSET = $1A`
- `UNIT_DATA_CARRIED_TYPE1_OFFSET = $1B`
- `UNIT_DATA_CARRIED_TYPE2_OFFSET = $1C`
- `UNIT_DATA_CARRIED_TYPE3_OFFSET = $1D`

These are class values, not live carrier/child indices. Live transport relationships remain represented separately by the carried status bit, carried-child count, and carrier live-unit index in the 16-byte runtime record.

## Live status byte $03

The already-sourced Bank $12:$4585-$4655 maintenance cluster now uses behavior-oriented names:

- bit 7: `UNIT_RECORD_STATUS_END_TURN_F`
- bit 2: `UNIT_RECORD_STATUS_SUPPLIED_F`

The four routines are `Unit_SetEndTurnFlag`, `Unit_ClearEndTurnFlagsForSide`, `Unit_ClearSupplyFlagsForSide`, and `Unit_CountSuppliedForSide`. Their instruction bytes are unchanged from the project; only semantics/names changed.

## Built/lost-unit counters

the project corrects the old boundary note around `$423E-$425B`. Retail `$423E-$4240` is actually the final `inc [hl] / pop af / ret` tail of `Unit_InitRecordFromDefinition`; the true next helper begins at `$4241`.

`Unit_IncrementBuiltCountForEncodedSide` at Bank $12:$4241-$425B is now explicit source. It uses encoded type/side bit 0 to select the two-byte words at `$C8B3/$C8B5`, increments that side's built-unit count, and saturates at the retail `$FFFF` sentinel. These words are exposed as `wUnitBuiltCountSide0` / `wUnitBuiltCountSide1`; `$C8B7/$C8B9` remain the already-proven lost-unit counters incremented by `Unit_DeleteRecord`.

The `$C8B3` area is contextually reused by the Map Editor save/footer path, so the built-unit names are aliases describing this unit-runtime ownership rather than a claim that the RAM is globally dedicated to one subsystem at all times.

## Remaining transport work

The purchase/promotion tranche `$43F4-$4509` is now source-backed (the project). Further transport work should proceed from still-unsourced caller/runtime islands rather than the obsolete `$423E-$425B` gap.
