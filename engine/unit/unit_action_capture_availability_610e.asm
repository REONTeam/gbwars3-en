include "macros/macros.inc"
include "constants/unit_constants.inc"

; availability-side owner for the player Unit Action CAPTURE command.
; The shared $6283 executor routes action $0B to $635C, which immediately calls
; Unit_CapturePropertyAtCurrentPosition at $648C after common action setup.

section "CAPTURE Action Availability", romx[$610e], bank[$0b]

UnitActionMenu_AppendCaptureIfAvailable::
    ld a, [wUnitRecordScratch]
    call UnitTypeSide_IsEmptyOrCurrentPhaseSide
    ret nz

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call UnitAction_IsCaptureUnavailableAtCoordinates
    and a
    ret nz

    ld a, UNIT_ACTION_CAPTURE
    call UnitActionMenu_AddEntry
    ret

    assert @ == $6128
