include "macros/macros.inc"
include "constants/unit_constants.inc"

; BOMB availability-side owner. The acting unit must belong to the active side;
; the Bank-$0C predicate then requires slot-0 ammunition and one of the four
; BOMB-capable unit types proven by the BOMB target/execution runtime.

section "Unit Action $1A Availability", romx[$6176], bank[$0b]

UnitActionMenu_AppendBombIfAvailable::
UnitActionMenu_AppendAction1AIfAvailable:: ; compatibility alias
    ld a, [wUnitRecordScratch]
    call UnitTypeSide_IsEmptyOrCurrentPhaseSide
    ret nz

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, [$c9d8]
    farcall $0c, UnitAction_CheckBombAvailable
    and a
    ret nz

    ld a, UNIT_ACTION_BOMB
    call UnitActionMenu_AddEntry
    ret

    assert @ == $6194
