include "macros/macros.inc"
include "constants/unit_constants.inc"

; FORTIFY availability helper. The staged-unit gate must accept, then the
; current action-target coordinate is checked by UnitFortify_IsAvailableAtCoordinates.
; The shared executor independently routes UNIT_ACTION_FORTIFY to
; Unit_DevelopTerrainAtCurrentPosition, closing the player-facing identity.

section "Unit Action $0A Availability", romx[$6128], bank[$0b]

UnitActionMenu_AppendAction0AIfAvailable::
    ld a, [wUnitRecordScratch]
    call UnitTypeSide_IsEmptyOrCurrentPhaseSide
    ret nz

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call UnitFortify_IsAvailableAtCoordinates
    and a
    ret nz

    ld a, UNIT_ACTION_FORTIFY
    call UnitActionMenu_AddEntry
    ret

    assert @ == $6142
