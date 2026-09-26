include "macros/macros.inc"
include "constants/unit_constants.inc"

; shared map-side presentation helpers used by MOVE/context action
; handling and later unit-selection paths.  The family clears/redraws a staged
; coordinate presentation, refreshes the currently staged scratch unit or a
; the staged carrier unit, and can reconstruct the presentation directly from
; a live-unit record.  Carried units are resolved through their carrier before
; the live-record presentation is drawn.
;
; Lower-level $4798/$47E1/$43D1 presentation primitives remain deliberately
; structural.  Ownership stops exactly at the independently reused $68F4 entry.

section "Bank $0B shared unit map presentation", romx[$6869], bank[$0b]

UnitSelection_ClearCoordinateMapPresentation::
    xor a
    call $4798
    call $47e1
    call $43d1
    ret

    assert @ == $6874

UnitSelection_RefreshScratchOrCarrierMapPresentation::
    push bc
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_STATUS_OFFSET]
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr nz, .carrier_unit
    call UnitSelection_RefreshScratchUnitMapPresentation
    jr .done

.carrier_unit
    ld a, [wUnitRecordScratch + UNIT_RECORD_CARRIER_INDEX_OFFSET]
    farcall $12, UnitRecord_CopyToScratch
    call UnitSelection_RefreshScratchUnitMapPresentation
    ld a, b
    farcall $12, UnitRecord_CopyToScratch

.done
    pop bc
    ret

    assert @ == $6893

UnitSelection_RefreshLiveUnitMapPresentation::
    farcall $12, UnitRecord_CopyToScratch
    call UnitSelection_RefreshScratchUnitMapPresentation
    ret

    assert @ == $689b

UnitSelection_RefreshLiveUnitOrCarrierMapPresentation::
    push bc
    push de
    ld d, a

    ; Resolve carried units through their parent/carrier record before drawing.
    ld a, d
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall $12, UnitRecord_GetByte
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr z, .resolved_unit
    ld a, d
    ld c, UNIT_RECORD_CARRIER_INDEX_OFFSET
    farcall $12, UnitRecord_GetByte
    ld d, a

.resolved_unit
    ; Preserve the encoded type/side byte while fetching the live X/Y word.
    ld a, d
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    push af
    push de
    ld a, d
    ld c, UNIT_RECORD_X_OFFSET
    farcall $12, UnitRecord_GetWord
    ld b, e
    ld c, d
    pop de
    pop af

    call $4798
    call $47e1

    push bc
    ld a, d
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall $12, UnitRecord_GetByte
    pop bc
    bit UNIT_RECORD_STATUS_END_TURN_F, a
    jr z, .check_carried_children
    ld a, $02
    call MapTile_SetFlagAtCoordinates

.check_carried_children
    push bc
    ld a, d
    ld c, UNIT_RECORD_CARRIED_COUNT_OFFSET
    farcall $12, UnitRecord_GetByte
    pop bc
    and a
    jr z, .redraw
    ld a, $01
    call MapTile_SetFlagAtCoordinates

.redraw
    call $43d1
    pop de
    pop bc
    ret

    assert @ == $68f4
