include "macros/macros.inc"
include "constants/unit_constants.inc"

; availability-side owner for loading the active unit into a carrier.
; The helper applies the established staged-unit gate, stages the current action
; target, and accepts only when the existing transport compatibility/capacity
; predicate reports that a compatible carrier with room is present.
;
; Executor correlation closes the identity: action $0D dispatches from $6283 to
; $6312, whose action-specific path performs the shared $68F4 setup and then calls
; Unit_LoadIntoCarrierAtActionTarget at
; $5DC7. This is therefore the player Unit Action counterpart of the already
; source-backed AI load/embark action family.

section "Unit Action Load Into Carrier Availability", romx[$6194], bank[$0b]

UnitActionMenu_AppendLoadIntoCarrierIfAvailable::
    ld a, [wUnitRecordScratch]
    call UnitTypeSide_IsEmptyOrCurrentPhaseSide
    ret nz

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call Unit_CanLoadIntoCarrierAtCoordinates
    and a
    ret nz

    ld a, UNIT_ACTION_LOAD_INTO_CARRIER
    call UnitActionMenu_AddEntry
    ret

    assert @ == $61ae
