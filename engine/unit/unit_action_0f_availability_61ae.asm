include "macros/macros.inc"
include "constants/unit_constants.inc"

; context-only Unit Action $0F availability helper. The established
; staged-unit gate must accept, and the current action-target coordinates must
; exactly match the staged $C9D9/$C9DA coordinate pair. Only then is action
; $0F appended to the shared Unit Action Menu.
;
; Executor correlation is exact but not yet semantically sufficient for a
; player-facing constant: the shared $6283 dispatcher routes $0F to $63C5,
; whose action arm calls the still-unsourced $6524 helper before returning.
; Keep the action numeric until that finalization/presentation family is owned.

section "Unit Action $0F Availability", romx[$61ae], bank[$0b]

UnitActionMenu_AppendAction0FIfAvailable::
    ld a, [wUnitRecordScratch]
    call UnitTypeSide_IsEmptyOrCurrentPhaseSide
    ret nz

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, [$c9d9]
    cp b
    ret nz
    ld a, [$c9da]
    cp c
    ret nz

    ld a, $0f
    call UnitActionMenu_AddEntry
    ret

    assert @ == $61cd
