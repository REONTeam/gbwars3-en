include "macros/macros.inc"
include "constants/unit_constants.inc"

; SUPPLY availability-side owner for Unit Action ID $1B. The Bank $0C service
; runtime now proves the action can service the active unit from compatible
; current-side terrain, an adjacent supplier, or a carried-aircraft path.

section "Unit Action $1B Availability", romx[$60c0], bank[$0b]

UnitActionMenu_AppendAction1BIfAvailable::
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    call UnitTypeSide_IsEmptyOrCurrentPhaseSide
    ret nz
    ld a, [$c9d8]
    farcall UnitSupply_CheckAvailable
    and a
    ret nz
    ld a, $1b
    call UnitActionMenu_AddEntry
    ret

    assert @ == $60d6
