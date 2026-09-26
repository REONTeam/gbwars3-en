include "macros/macros.inc"
include "constants/unit_constants.inc"

; shared active-unit action-state finalizer used by LOAD, FORTIFY,
; BUILD, CAPTURE, BOMB, WAIT, and the forced context-action path.  The routine
; operates on wUnitRecordScratch, detaches a carried acting unit from its
; carrier when necessary, marks the acting unit as having ended its turn,
; commits the scratch record to wMapAIActiveUnitIndex, and refreshes the map
; presentation.  The lower-level $43D1 redraw primitive remains structural.
;
; Ownership stops exactly at the independently reused $693D entry.

section "Bank $0B common Unit Action finalizer", romx[$68f4], bank[$0b]

UnitAction_FinalizeActiveUnitActionState::
    push bc
    push de
    push hl

    ld a, [wUnitRecordScratch + UNIT_RECORD_STATUS_OFFSET]
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr z, .mark_end_turn

    ; A carried child that acts becomes independent: clear its carried flag,
    ; decrement the parent/carrier's child count, then refresh the carrier-side
    ; map presentation at the staged action coordinates.
    res UNIT_RECORD_STATUS_CARRIED_F, a
    ld [wUnitRecordScratch + UNIT_RECORD_STATUS_OFFSET], a

    ld a, [wUnitRecordScratch + UNIT_RECORD_CARRIER_INDEX_OFFSET]
    ld c, UNIT_RECORD_CARRIED_COUNT_OFFSET
    farcall $12, UnitRecord_GetByte
    dec a
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_CARRIER_INDEX_OFFSET]
    farcall $12, UnitRecord_SetByte

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    farcall $12, UnitRecord_FindPrimaryAtCoordinates
    call UnitSelection_RefreshLiveUnitOrCarrierMapPresentation
    call $43d1

.mark_end_turn
    ld a, [wUnitRecordScratch + UNIT_RECORD_STATUS_OFFSET]
    set UNIT_RECORD_STATUS_END_TURN_F, a
    ld [wUnitRecordScratch + UNIT_RECORD_STATUS_OFFSET], a

    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_CopyFromScratch
    call UnitSelection_RefreshScratchUnitMapPresentation

    pop hl
    pop de
    pop bc
    ret

    assert @ == $693d
