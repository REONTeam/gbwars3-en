include "macros/macros.inc"
include "constants/unit_constants.inc"

; Unit-to-unit HP redistribution action used by the Bank $25 Unit Status screen.
; The source/target HP bytes are adjusted in the UI, then committed here.
; $C940 and $C948/$C949 are action-lifetime selection/list scratch shared with
; other Bank-$0B map actions.
DEF wUnitHPTransferSelectionIndex EQU $c940
DEF wUnitActionCandidateCount EQU $c948
DEF wUnitActionCandidateList EQU $c949
DEF wMapInteractionInputState EQU $ca91

section "Unit HP Transfer Runtime", romx[$4df2], bank[$0b]

UnitHPTransfer_Run::
.restart
    ; Build the adjacent compatible-target list around the staged action
    ; coordinates, then let the player choose one of those units.
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    call UnitHPTransfer_BuildEligibleAdjacentTargetList
    call UnitHPTransfer_SelectTarget
    cp $ff
    jp z, .finish

    ; Stage the current source/target HP values and the source unit's maximum
    ; HP for the Bank-$25 redistribution screen.
    ld a, [wUnitTransferTargetUnitID]
    ld c, UNIT_RECORD_HP_OFFSET
    farcall $12, UnitRecord_GetByte
    ld [wUnitTransferTargetHP], a
    ld a, [wUnitRecordScratch + UNIT_RECORD_HP_OFFSET]
    ld [wUnitTransferSourceHP], a
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    ld c, UNIT_DATA_MAX_HP_OFFSET
    farcall $12, UnitData_GetByte
    ld [wUnitTransferMaxHP], a

    call MapTerrainAnimation_Reset
    call FadeToWhite8
    farcall $25, UnitStatus_RunController
    bit 0, a
    jr nz, .commit

    ; Leaving the status screen without committing returns to target choice.
    call FadeToWhite8
    call MapControl_ReinitializeAfterResolution
    jp .restart

.commit
    call FadeToWhite8
    call MapControl_ReinitializeAfterResolution
    farcall $0c, UnitHPTransfer_PreparePresentation

    ; Commit the source unit first through the normal action finalizer.
    ld a, [wUnitTransferSourceHP]
    ld [wUnitRecordScratch + UNIT_RECORD_HP_OFFSET], a
    call UnitAction_FinalizeActiveUnitActionState

    ; The receiving unit also ends its turn and receives the adjusted HP.
    ld a, [wUnitTransferTargetUnitID]
    farcall $12, Unit_SetEndTurnFlag
    ld a, [wUnitTransferTargetHP]
    ld b, a
    ld c, UNIT_RECORD_HP_OFFSET
    ld a, [wUnitTransferTargetUnitID]
    farcall $12, UnitRecord_SetByte
    farcall $0c, UnitHPTransfer_PresentTransfer

    ; A redistribution may reduce either participant to zero HP. Retail uses
    ; the normal recursive deletion path in that case and rebuilds the map
    ; presentation around the vacated coordinate.
    ld a, [wUnitTransferSourceHP]
    and a
    jr nz, .source_survives
    ld a, [wUnitRecordScratch + UNIT_RECORD_X_OFFSET]
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_Y_OFFSET]
    ld c, a
    farcall $0c, MapUnitTransition_BeginRemoval
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, Unit_DeleteWithCarriedAtCoordinates
    call $47e1
    xor a
    call $4798
    call $43d1
    farcall $0c, MapUnitTransition_EndRemoval

.source_survives
    ld a, [wUnitTransferTargetUnitID]
    ld c, UNIT_RECORD_X_OFFSET
    farcall $12, UnitRecord_GetWord
    ld b, e
    ld c, d
    ld a, [wUnitTransferTargetHP]
    and a
    jr nz, .target_survives
    farcall $0c, MapUnitTransition_BeginRemoval
    ld a, [wUnitTransferTargetUnitID]
    farcall $12, Unit_DeleteWithCarriedAtCoordinates
    call $47e1
    xor a
    call $4798
    call $43d1
    farcall $0c, MapUnitTransition_EndRemoval
    jr .success

.target_survives
    ld a, [wUnitTransferTargetUnitID]
    call UnitSelection_RefreshLiveUnitMapPresentation

.success
    xor a
.finish
    push af
    call MapCursor_Show
    pop af
    ret

UnitHPTransfer_SelectTarget::
    push bc
    push de
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, $05
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [wUnitHPTransferSelectionIndex], a
    call UnitHPTransfer_LoadTarget
    call MapCursor_Show

.input_loop
    call MapControl_UpdateInteractionInputState
    ld a, [wMapInteractionInputState]
    bit 5, a
    jr nz, .previous
    bit 4, a
    jr nz, .next
    bit 0, a
    jr nz, .confirm
    bit 1, a
    jr nz, .cancel
    jr .input_loop

.previous
    ld a, [wUnitHPTransferSelectionIndex]
    dec a
    cp $ff
    jr nz, .store_selection
    ld a, [wUnitActionCandidateCount]
    dec a
    jr .store_selection

.next
    ld a, [wUnitActionCandidateCount]
    ld b, a
    ld a, [wUnitHPTransferSelectionIndex]
    inc a
    cp b
    jr nz, .store_selection
    xor a

.store_selection
    ld [wUnitHPTransferSelectionIndex], a
    ld a, SFX_CURSOR_MOVE
    call Audio_PlaySFX
    call UnitMoveStatusOverlay_Clear
    call UnitHPTransfer_LoadTarget
    jr .input_loop

.confirm
    ld a, SFX_CONFIRM
    call Audio_PlaySFX
    call UnitMoveStatusOverlay_Clear
    jr .finish

.cancel
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    call UnitMoveStatusOverlay_Clear
    ld a, $ff
    ld [wUnitTransferTargetUnitID], a

.finish
    ; Restore the map cursor to the acting unit before returning the selected
    ; target ID (or $FF for cancel).
    ld a, [wUnitRecordScratch + UNIT_RECORD_X_OFFSET]
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_Y_OFFSET]
    ld c, a
    call MapCursor_SetMapCoordinates
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ld a, [wUnitTransferTargetUnitID]
    ret

UnitHPTransfer_LoadTarget::
    ; Resolve the selected candidate ID, move the cursor to it, and populate
    ; the HP/fuel values consumed by the small move-status overlay.
    ld a, [wUnitHPTransferSelectionIndex]
    ld hl, wUnitActionCandidateList
    call AddAtoHL
    ld a, [hl]
    ld [wUnitTransferTargetUnitID], a

    ld c, UNIT_RECORD_X_OFFSET
    farcall $12, UnitRecord_GetWord
    ld b, e
    ld c, d
    call MapCursor_SetMapCoordinates

    ld a, [wUnitTransferTargetUnitID]
    ld c, UNIT_RECORD_HP_OFFSET
    farcall $12, UnitRecord_GetByte
    ld [wUnitMoveStatusHP], a
    ld a, [wUnitTransferTargetUnitID]
    ld c, UNIT_RECORD_FUEL_OFFSET
    farcall $12, UnitRecord_GetByte
    ld [wUnitMoveStatusFuel], a
    call UnitMoveStatusOverlay_Init
    ret

    assert @ == $4f82
