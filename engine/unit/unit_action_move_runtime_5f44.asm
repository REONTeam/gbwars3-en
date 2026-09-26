include "macros/macros.inc"
include "constants/unit_constants.inc"

; player Unit Action ID $12 executor.  The action is now
; behavior-backed as MOVE: its availability helper offers $12 only before the
; unit's movement-state bit is set, and the $6283 action dispatcher routes $12
; here.  This controller runs the coordinate/movement interaction state
; machine.  $601E is separately reused and remains the next source boundary.

section "Unit Action Move Controller", romx[$5f44], bank[$0b]

UnitAction_RunMove::
    ld a, [wUnitRecordScratch + UNIT_RECORD_HP_OFFSET]
    ld [wUnitMoveStatusHP], a
    ld a, [wUnitRecordScratch + UNIT_RECORD_FUEL_OFFSET]
    ld [wUnitMoveStatusFuel], a
    call UnitMoveStatusOverlay_Init
    call MapCursor_Show
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    ld a, [$ccdd]
    call UnitSelection_InitializeCoordinateInteractionState
    call $54b6
    call $428a
    call MapControl_UpdateInteractionInputState
    call UnitSelection_AdvanceCoordinateInteractionPhase

.dispatch_state
    ld hl, .state_jump_table
    ld a, [$ca91]
    call $3a9e
    jp hl

.return_after_teardown
    push af
    call UnitMoveStatusOverlay_Clear
    pop af
    ret

.state_4
    call MapControl_AdvanceHorizontalMapPosition
    jr .refresh_state

.state_5
    call MapControl_RetreatHorizontalMapPosition
    jr .refresh_state

.refresh_state
    ld a, [wMapCursorOffsetX]
    cp $05
    jr c, .refresh_low_mode
    call UnitMoveStatusOverlay_PositionMode5Plus
    jr .dispatch_state
.refresh_low_mode
    call UnitMoveStatusOverlay_PositionModeBelow5
    jr .dispatch_state

.state_6
    call MapControl_RetreatVerticalMapPosition
    jr .dispatch_state

.state_7
    call MapControl_AdvanceVerticalMapPosition
    jr .dispatch_state

.state_1
    ld a, SFX_CANCEL
    call Audio_RequestSFX
    call MapGrid_ClearAnalysisFlagAcrossGrid
    call $428a
    call UnitSelection_RefreshCoordinateInteractionState
    ld a, [$c9d8]
    farcall $12, UnitRecord_CopyToScratch
    ld a, $ff
    jr .return_after_teardown

.state_0
    ld a, [$c991]
    ld b, a
    ld a, [$c992]
    ld c, a
    call $644e
    and a
    jr nz, .reject
    call UnitActionMenu_BuildContextEntriesAtCoordinates
    ld a, [wUnitActionMenuEntryCount]
    and a
    jr z, .reject
    ld a, SFX_CONFIRM
    call Audio_RequestSFX
    call MapGrid_ClearAnalysisFlagAcrossGrid
    call $428a
    call UnitSelection_RefreshCoordinateInteractionState
    call UnitMoveStatusOverlay_Clear
    call UnitAction_RunContextSelectionController
    cp $ff
    jr nz, .return_after_teardown
    call UnitMoveStatusOverlay_Init
    call UnitSelection_RefreshScratchUnitMapPresentation
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    ld a, [$ccdd]
    call UnitSelection_InitializeCoordinateInteractionState
    jp .dispatch_state

.reject
    ld a, SFX_ERROR
    call Audio_RequestSFX
    jp .dispatch_state

.state_jump_table
    dw .state_0
    dw .state_1
    dw .dispatch_state
    dw .dispatch_state
    dw .state_4
    dw .state_5
    dw .state_6
    dw .state_7
    dw .dispatch_state

    assert @ == $601e
