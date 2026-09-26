include "macros/macros.inc"
include "constants/unit_constants.inc"

; refresh the map-side presentation for the unit currently staged in
; wUnitRecordScratch.  The routine consumes the scratch X/Y pair and selected
; record state, then runs the established map-tile status API before the shared map redraw.  The
; intermediate selector arithmetic and final $43D1 redraw primitive remain
; deliberately structural until their wider consumers close those contracts.
section "Bank $0B scratch-unit map presentation", romx[$683b], bank[$0b]

UnitSelection_RefreshScratchUnitMapPresentation::
    push bc
    ld a, [wUnitRecordScratch + UNIT_RECORD_X_OFFSET]
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_Y_OFFSET]
    ld c, a
    call MapTile_ClearAllFlagsAtCoordinates

    ; Feed the staged type/side byte through the same structural $4798
    ; presentation helper used by the neighboring selection paths.
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    call $4798

    ld a, [wUnitRecordScratch + UNIT_RECORD_STATUS_OFFSET]
    bit 7, a
    jr z, .check_carried_children
    ld a, $02
    call MapTile_SetFlagAtCoordinates

.check_carried_children
    ld a, [wUnitRecordScratch + UNIT_RECORD_CARRIED_COUNT_OFFSET]
    and a
    jr z, .redraw
    ld a, $01
    call MapTile_SetFlagAtCoordinates

.redraw
    call $43d1
    pop bc
    ret

    assert @ == $6869
