include "macros/macros.inc"
include "constants/unit_constants.inc"

; Player FIRE target-selection/preview runtime plus the BOMB availability
; predicate. These entries sit directly after the shared weapon selectors and
; before the already-sourced direct-combat executor.
;
; The FIRE controller owns a short-lived target-list view over shared scratch:
; $C940 is the selected list index, $C941 the selected live-unit index,
; $DBF7 the candidate count, and $DBF8.. the candidate unit-index list.
DEF wFireTargetSelectionIndex EQU $c940
DEF wFireTargetUnitID         EQU $c941
DEF wFireTargetCount          EQU $dbf7
DEF wFireTargetUnitIDs        EQU $dbf8
DEF wMapInteractionInputState EQU $ca91
DEF wBattleActionOriginX      EQU $ccde
DEF wBattleActionOriginY      EQU $ccdf

section "Unit Action FIRE Target Selection", romx[$418f], bank[$0c]

; A = acting live-unit index, B/C = return/pan coordinate.
; Returns A=0 after executing a direct attack, or $FF when selection is
; cancelled / no usable target exists.
UnitAction_RunFireTargetSelection::
    push bc
    push de
    push hl
    call BattleTargetSelection_RunController
    cp $ff
    jr z, .cancelled

    push af
    farcall UnitAction_FinalizeActiveUnitActionState
    pop af
    ld e, a
    ld a, [wMapAIActiveUnitIndex]
    ld d, a
    call Battle_ExecuteDirectUnitAttack
    farcall MapControl_PanToCoordinates
    farcall MapCursor_SetMapCoordinates
    xor a
    jr .done

.cancelled
    farcall MapControl_PanToCoordinates
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff

.done
    pop hl
    pop de
    pop bc
    ret

    assert @ == $41c1

; Interactive target selector for FIRE. The candidate list is prepared by the
; established Bank-$0B coordinate-analysis path. Left/right-style inputs cycle
; candidates, one input opens the battle-information preview, A validates and
; accepts an enemy target, and B cancels.
BattleTargetSelection_RunController::
    push bc
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [wFireTargetSelectionIndex], a
    call BattleTargetSelection_LoadCurrentTargetPresentation
    farcall MapCursor_Show

.input_loop
    farcall MapControl_UpdateInteractionInputState
    farcall UnitSelection_AdvanceCoordinateInteractionPhase
    ld a, [wMapInteractionInputState]
    bit 0, a
    jp nz, .confirm
    bit 1, a
    jp nz, .cancel
    bit 5, a
    jr nz, .previous_target
    bit 6, a
    jr nz, .previous_target
    bit 4, a
    jr nz, .next_target
    bit 7, a
    jr nz, .next_target
    bit 2, a
    jr nz, .show_unit_status
    bit 3, a
    jr nz, .show_battle_preview
    jr .input_loop

.previous_target
    ld a, [wFireTargetSelectionIndex]
    dec a
    cp $ff
    jr nz, .store_target_index
    ld a, [wFireTargetCount]
    dec a
    jr .store_target_index

.next_target
    ld a, [wFireTargetCount]
    ld b, a
    ld a, [wFireTargetSelectionIndex]
    inc a
    cp b
    jr nz, .store_target_index
    xor a

.store_target_index
    ld [wFireTargetSelectionIndex], a
    farcall UnitMoveStatusOverlay_Clear
    farcall UnitSelection_RefreshCoordinateInteractionState
    call BattleTargetSelection_LoadCurrentTargetPresentation
    ld a, SFX_CURSOR_MOVE
    call Audio_PlaySFX
    jr .input_loop

.show_unit_status
    call MapTerrainAnimation_Reset
    farcall UnitSelection_RefreshCoordinateInteractionState
    call SpriteObject_HideAll
    call Sprite_Update
    call FadeToWhite8
    ld a, [wFireTargetUnitID]
    ld c, $00
    farcall $12, UnitRecord_GetByte
    ld c, a
    and $01
    ld b, a
    ld a, c
    srl a
    farcall UnitReference_Open
    jr .return_from_preview

.show_battle_preview
    call BattleTargetSelection_CheckCurrentTarget
    and a
    jp z, .input_loop
    call MapTerrainAnimation_Reset
    farcall UnitSelection_RefreshCoordinateInteractionState
    ld a, SFX_CONFIRM
    call Audio_PlaySFX
    ld a, [wBattleActionOriginX]
    ld b, a
    ld a, [wBattleActionOriginY]
    ld c, a
    ld a, [wMapAIActiveUnitIndex]
    ld d, a
    ld a, [wFireTargetUnitID]
    ld e, a
    call Battle_BuildCombatParticipantStats
    call SpriteObject_HideAll
    call Sprite_Update
    call FadeToWhite8
    call BattleInfo_ShowScreen

.return_from_preview
    farcall MapControl_ReinitializeAfterResolution
    call BattleTargetSelection_LoadCurrentTargetPresentation
    call SpriteObject_ShowAll
    call Sprite_Update
    jp .input_loop

.confirm
    ld a, [wUnitRecordScratch]
    farcall UnitTypeSide_IsEmptyOrCurrentPhaseSide
    jr nz, .invalid_confirm
    call BattleTargetSelection_CheckCurrentTarget
    and a
    jp z, .input_loop
    ld a, SFX_CONFIRM
    call Audio_PlaySFX
    farcall UnitMoveStatusOverlay_Clear
    farcall UnitSelection_RefreshCoordinateInteractionState
    jr .finish

.invalid_confirm
    ld a, SFX_ERROR
    call Audio_PlaySFX
    jp .input_loop

.cancel
    farcall UnitMoveStatusOverlay_Clear
    ld a, $ff
    ld [wFireTargetUnitID], a
    farcall UnitSelection_RefreshCoordinateInteractionState

.finish
    farcall UnitMoveStatusOverlay_Clear
    farcall MapCursor_SetPalette2
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop bc
    ld a, [wFireTargetUnitID]
    ret

    assert @ == $42e2

; Returns non-zero when the selected target can be attacked with a currently
; usable weapon. An invalid candidate restores the ordinary map presentation,
; plays the retail rejection SFX, and returns zero.
BattleTargetSelection_CheckCurrentTarget::
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitWeapon_BuildSummary
    ld a, [wBattleDistance]
    ld b, a
    ld a, [wFireTargetUnitID]
    ld c, $00
    farcall $12, UnitRecord_GetByte
    call Battle_SelectUsableWeaponAttack
    and a
    ret nz

    farcall UnitSelection_RefreshCoordinateInteractionState
    ld a, SFX_ERROR
    call Audio_PlaySFX
    ld a, $16
    farcall $0b, MapControl_ResolutionSceneRefresh
    call BattleTargetSelection_LoadCurrentTargetPresentation
    xor a
    ret

    assert @ == $430f

; Load the currently indexed target, move/pan the cursor presentation to it,
; and stage its combat-preview state.
BattleTargetSelection_LoadCurrentTargetPresentation::
    ld a, [wFireTargetSelectionIndex]
    ld hl, wFireTargetUnitIDs
    call AddAtoHL
    ld a, [hl]
    ld [wFireTargetUnitID], a

    ld a, [wFireTargetUnitID]
    ld c, $01
    farcall $12, UnitRecord_GetWord
    ld b, e
    ld c, d
    farcall $0b, Bank0B_MapSetup_44F5
    and a
    jr nz, .pan_to_target

    push bc
    farcall MapCursor_SetMapCoordinates
    call BattleTargetSelection_StagePreviewState
    pop bc
    jr .refresh_target

.pan_to_target
    push bc
    farcall MapControl_PanToCoordinates
    call BattleTargetSelection_StagePreviewState
    pop bc
    jr .refresh_target ; preserve retail zero-displacement JR

.refresh_target
    push bc
    ld a, [wFireTargetUnitID]
    ld c, $00
    farcall $12, UnitRecord_GetByte
    pop bc
    farcall $0b, UnitSelection_InitializeCoordinateInteractionState
    ret

    assert @ == $4354

; Stage the selected target's map-overlay values and choose the cursor palette
; from the predicted first combat step.
BattleTargetSelection_StagePreviewState::
    push bc
    push de
    ld a, [wFireTargetUnitID]
    ld c, $04
    farcall $12, UnitRecord_GetByte
    ld [wUnitMoveStatusHP], a
    ld a, [wFireTargetUnitID]
    ld c, $07
    farcall $12, UnitRecord_GetByte
    ld [wUnitMoveStatusFuel], a
    farcall UnitMoveStatusOverlay_Init

    ld a, [wBattleActionOriginX]
    ld b, a
    ld a, [wBattleActionOriginY]
    ld c, a
    ld a, [wMapAIActiveUnitIndex]
    ld d, a
    ld a, [wFireTargetUnitID]
    ld e, a
    call Battle_CalculatePackedHPDamage
    ld a, [wBattleAttackerFocus]
    ld b, a
    ld a, [wBattleDefenderFocus]
    cp b
    jr z, .palette2
    jr c, .palette4
    farcall MapCursor_SetPalette4
    jr .store_target
.palette4
    farcall MapCursor_SetPalette3
    jr .store_target
.palette2
    farcall MapCursor_SetPalette2
.store_target
    ld a, e
    ld [wFireTargetUnitID], a
    pop de
    pop bc
    ret

    assert @ == $43a8

section "Unit Action BOMB Availability", romx[$43a8], bank[$0c]

; A = acting live-unit index. Returns A=0/Z when BOMB is available and A=1/NZ
; otherwise. BOMB requires weapon-slot-0 ammunition and one of the four retail
; BOMB-capable unit types.
UnitAction_CheckBombAvailable::
    farcall $12, UnitWeapon_BuildSummary
    ld a, [wUnitWeaponSummary0CurrentAmmo]
    and a
    jr z, .unavailable

    ld a, [wUnitRecordScratch]
    srl a
    cp UNIT_TYPE_BOMBER
    jr z, .available
    cp UNIT_TYPE_MERCENARY_BOMBER
    jr z, .available
    cp UNIT_TYPE_MERCENARY_MISSILE_FRIGATE
    jr z, .available
    cp UNIT_TYPE_SUBMARINE_S
    jr z, .available
    jr .unavailable

.available
    xor a
    jr .done
.unavailable
    ld a, $01
.done
    ret

    assert @ == $43cf
