include "macros/macros.inc"
include "constants/unit_constants.inc"

; availability-side owner for the HP-transfer Unit Action. The helper
; shares the established $7D24 staged-unit gate, stages the current action
; target coordinate, and accepts only when the existing $4D3A adjacent-target
; predicate reports at least one compatible HP-transfer target.
;
; Executor correlation closes the identity: the shared $6283 dispatcher routes
; action $0E to $631B, whose first action-specific call enters the already
; source-backed UnitHPTransfer_Run at $4DF2.

section "Unit Action HP Transfer Availability", romx[$6142], bank[$0b]

UnitActionMenu_AppendHPTransferIfAvailable::
    ld a, [wUnitRecordScratch]
    call UnitTypeSide_IsEmptyOrCurrentPhaseSide
    ret nz

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call UnitHPTransfer_HasEligibleAdjacentTarget
    and a
    ret nz

    ld a, UNIT_ACTION_HP_TRANSFER
    call UnitActionMenu_AddEntry
    ret

    assert @ == $615c
