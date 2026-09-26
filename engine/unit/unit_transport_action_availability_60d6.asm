include "macros/macros.inc"
include "constants/unit_constants.inc"

; availability-side owner for the carried-child/transport action
; family. Actions $0C and $1C both dispatch through the same carried-child
; controller at $63CF; retail selects which menu ID to append from carrier type.

section "Carried Child Action Availability", romx[$60d6], bank[$0b]

UnitActionMenu_AppendCarriedChildActionIfAvailable::
    ; Retail performs this load before the shared predicate even though the
    ; predicate reads the already-staged scratch record directly.
    ld a, [wMapAIActiveUnitIndex]
    call UnitTransport_TestCarriedOrNoCargo
    and a
    ret nz

    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    srl a
    cp UNIT_TYPE_LARGE_CARRIER
    jr z, .carrier_action
    cp UNIT_TYPE_SMALL_CARRIER
    jr z, .carrier_action

    ld a, $1c
    call UnitActionMenu_AddEntry
    ret

.carrier_action
    ld a, $0c
    call UnitActionMenu_AddEntry
    ret

    assert @ == $60f7
