include "macros/macros.inc"
include "constants/unit_constants.inc"

; caller-backed Bank $0B movement/selection runtime between the
; existing transport-load owner at $5D84-$5E1D and the separately farcalled
; $5ED4 boundary.  The movement finalizer has a concrete transport contract;
; the following coordinate-selection/input helpers remain deliberately
; presentation-oriented until their $5F0A/$65xx dependencies are sourced.

section "Unit Transport Movement And Selection Runtime", romx[$5e1e], bank[$0b]

; Finalize the cargo-specific part of a selected unit movement.
; If the active unit carries children and its staged origin coordinate differs
; from the current scratch coordinate, award the staged route/analysis extent
; as experience and recursively move every carried child to the carrier's
; current coordinate.  $C9E5 remains semantically neutral beyond the
; queue_count-1 contract.
UnitTransport_FinalizeMovedCarrierChildren::
    push bc
    push de
    push hl
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_CopyToScratch
    ld b, $41
    ld a, [wUnitRecordScratch + UNIT_RECORD_CARRIED_COUNT_OFFSET]
    and a
    jr z, .done
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_X_OFFSET]
    cp b
    jr nz, .moved
    ld a, [wUnitRecordScratch + UNIT_RECORD_Y_OFFSET]
    cp c
    jr z, .done
.moved
    ld a, [$c9e5]
    ld l, a
    ld h, 0
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_AddExperienceClamped
    ld a, [wUnitRecordScratch + UNIT_RECORD_X_OFFSET]
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_Y_OFFSET]
    ld c, a
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, Unit_MoveCarriedChildrenToCoordinates
.done
    pop hl
    pop de
    pop bc
    ret

; B/C = staged map coordinate.  Preserve the coordinate, resolve the primary
; live unit there, copy it to scratch, and enter the shared selected-unit
; interaction/presentation loop.  The post-action path now presents any experience-rank changes symbolically.
UnitSelection_StagePrimaryAtCoordinates::
    ld a, b
    ld [$c9d9], a
    ld a, c
    ld [$c9da], a
    farcall $12, UnitRecord_FindPrimaryAtCoordinates
    ld [wMapAIActiveUnitIndex], a
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_CopyToScratch
    call UnitSelection_RunPrimaryInteractionLoop
    bit 1, a
    jp nz, .done
    call UnitActionMenu_RunActiveUnitController
    call UnitSelection_PresentExperienceRankChanges
.done
    ret

; Shared selected-unit interaction loop.  Its visible/input structure is clear,
; but the exact player-facing identity of its three exits depends on later
; $5F0A/$65xx presentation consumers, so the name remains contract-oriented.
UnitSelection_RunPrimaryInteractionLoop::
.loop
    ld a, 5
    call Vram_ClearPanelRowsBothBanks
    call UnitSelection_DrawSelectedUnitDetails
    call UnitSelection_ShowInteractionPresentation
.wait_input
    call Joypad_Update
    ldh a, [hJoyPressed]
    bit 2, a
    jr nz, .refresh
    bit 1, a
    jr nz, .button1
    bit 0, a
    jr nz, .button0
    jr .wait_input
.refresh
    call LCDScanlineTransition_Reset
    call MapTerrainAnimation_Reset
    call FadeToWhite8
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    and 1
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    srl a
    farcall UnitReference_Open
    farcall $0b, MapControl_ReinitializeAfterResolution
    jr .loop
.button0
    ld a, 2
    jr .sfx
.button1
    ld a, SFX_CANCEL
.sfx
    call Audio_RequestSFX
    call UnitSelection_HideInteractionPresentation
    ldh a, [hJoyPressed]
    ret

    assert @ == $5ed4
