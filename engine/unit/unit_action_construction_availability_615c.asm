include "macros/macros.inc"
include "constants/unit_constants.inc"

; availability-side owner for the Construction Unit Action.
; The helper shares the established $7D24 staged-unit gate, stages the current
; action-target coordinates, and accepts only when the Construction candidate
; predicate reports that at least one Construction terrain action is available.
;
; Executor correlation closes the identity: the shared $6283 dispatcher routes
; action $15 to $634A, whose first action-specific call enters the already
; source-backed Construction_RunTerrainActionController at $4A7C.

section "Unit Action Construction Availability", romx[$615c], bank[$0b]

UnitActionMenu_AppendConstructionIfAvailable::
    ld a, [wUnitRecordScratch]
    call UnitTypeSide_IsEmptyOrCurrentPhaseSide
    ret nz

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call Construction_HasTerrainActionCandidate
    and a
    ret nz

    ld a, UNIT_ACTION_CONSTRUCTION
    call UnitActionMenu_AddEntry
    ret

    assert @ == $6176
