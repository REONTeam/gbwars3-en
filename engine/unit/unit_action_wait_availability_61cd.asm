include "macros/macros.inc"
include "constants/unit_constants.inc"

; WAIT availability helper. The established staged-unit gate must
; accept; there is no additional coordinate/state predicate before WAIT is
; appended to the shared context Unit Action Menu.
;
; The player-facing identity is presentation-backed as well as executor-backed.
; UnitActionMenu_GetGraphicPointer selects action_id * $80 from Bank $11
; Image_Action_Menu, and slice $10 is the preserved custom-English "Wait" label.
; The shared $6283 executor independently routes $10 to $63B7.

section "WAIT Action Availability", romx[$61cd], bank[$0b]

UnitActionMenu_AppendWaitIfAvailable::
    ld a, [wUnitRecordScratch]
    call UnitTypeSide_IsEmptyOrCurrentPhaseSide
    ret nz

    ld a, UNIT_ACTION_WAIT
    call UnitActionMenu_AddEntry
    ret

    assert @ == $61da
