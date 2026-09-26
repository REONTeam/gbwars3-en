include "macros/macros.inc"
include "constants/unit_constants.inc"

section "Unit Action FIRE Availability", romx[$60f7], bank[$0b]

UnitActionMenu_AppendFireIfAvailable::
UnitActionMenu_AppendAction09IfAvailable:: ; compatibility alias
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, [$c9d8]
    farcall $0c, UnitAction_CheckFireAvailable
    and a
    ret nz
    ld a, UNIT_ACTION_FIRE
    call UnitActionMenu_AddEntry
    ret

    assert @ == $610e
