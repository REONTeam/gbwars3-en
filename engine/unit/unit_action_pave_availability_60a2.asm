include "macros/macros.inc"
include "constants/unit_constants.inc"

; PAVE is available only when the selected unit belongs to the current phase
; side and the Bank-$0C PAVE runtime finds an affordable current/adjacent cell.
section "Unit Action Pave Availability", romx[$60a2], bank[$0b]

UnitActionMenu_AppendPaveIfAvailable::
UnitActionMenu_AppendAction14IfAvailable:: ; compatibility alias
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    call UnitTypeSide_IsEmptyOrCurrentPhaseSide
    ret nz
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    ld a, [wMapAIActiveUnitIndex]
    farcall $0c, UnitPave_CheckAvailableAtOrAdjacent
    and a
    ret nz
    ld a, UNIT_ACTION_PAVE
    call UnitActionMenu_AddEntry
    ret

    assert @ == $60c0
