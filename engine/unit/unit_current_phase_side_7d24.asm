include "constants/map_constants.inc"
include "constants/unit_constants.inc"

; Test an encoded UnitRecord type/side byte against the active phase side.
; Empty type 0 returns Z immediately. Otherwise bit 0 is the encoded side and
; Z is set only when it matches wMapPhaseNumber bit 0. All action-availability
; callers consume this through RET NZ / JR NZ.
section "Unit current phase side test", romx[$7d24], bank[$0b]
UnitTypeSide_IsEmptyOrCurrentPhaseSide::
    push bc
    and a
    jr z, .done
    and UNIT_TYPE_SIDE_MASK
    ld b, a
    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    cp b
.done
    pop bc
    ret

    assert @ == $7d33
