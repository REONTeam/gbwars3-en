include "macros/macros.inc"
include "constants/unit_constants.inc"

; Carried-child selection/input controller.
; Reached after UnitTransport_SetupActiveCarriedChildList has rebuilt
; wCarriedUnitList and reset wCarriedChildSelectionIndex. Up/Down wrap through
; that list, Select opens the standard Unit Status detail screen, A accepts a
; child whose end-turn flag is clear, and B restores the carrier as the active
; scratch unit before cancelling.
section "Bank $0B carried-child selection controller", romx[$5ccf], bank[$0b]

UnitTransport_RunCarriedChildSelection::
    push bc
    push de

.redraw
    ld a, $05
    call Vram_ClearPanelRowsBothBanks
    call UnitTransport_ResolveSelectedCarriedChildAndRedraw
    call UnitSelection_ShowInteractionPresentation

.input_loop
    call Joypad_Update
    ldh a, [hJoyRepeat]
    bit 2, a
    jr nz, .show_details
    bit 0, a
    jr nz, .confirm
    bit 1, a
    jr nz, .cancel
    bit 6, a
    jr nz, .previous
    bit 7, a
    jr nz, .next
    jr .input_loop

.previous
    ld a, [wCarriedChildSelectionIndex]
    dec a
    cp $ff
    jr nz, .selection_changed
    ld a, [wCarriedUnitListCount]
    dec a
    jr .selection_changed

.next
    ld a, [wCarriedChildSelectionIndex]
    inc a
    ld hl, wCarriedUnitListCount
    cp [hl]
    jr nz, .selection_changed
    xor a

.selection_changed
    push af
    ld a, SFX_CURSOR_MOVE
    call Audio_PlaySFX
    pop af
    ld [wCarriedChildSelectionIndex], a
    call UnitTransport_ResolveSelectedCarriedChildAndRedraw
    jr .input_loop

.show_details
    call LCDScanlineTransition_Reset
    call MapTerrainAnimation_Reset
    call FadeToWhite8
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    and $01
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    srl a
    farcall UnitReference_Open
    farcall $0b, MapControl_ReinitializeAfterResolution
    jr .redraw

.confirm
    ld a, [wUnitRecordScratch + UNIT_RECORD_STATUS_OFFSET]
    bit UNIT_RECORD_STATUS_END_TURN_F, a
    jr nz, .already_acted
    ld a, SFX_CONFIRM
    call Audio_PlaySFX
    ld a, [wMapAIActiveUnitIndex]
    jr .done

.already_acted
    ld a, SFX_ERROR
    call Audio_PlaySFX
    jr .input_loop

.cancel
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, [wUnitRecordScratch + UNIT_RECORD_CARRIER_INDEX_OFFSET]
    farcall $12, UnitRecord_CopyToScratch
    call UnitSelection_RefreshScratchUnitMapPresentation
    call UnitSelection_HideInteractionPresentation
    ld a, $ff

.done
    pop de
    pop bc
    ret

    assert @ == $5d6c
