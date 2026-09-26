include "macros/macros.inc"
include "constants/unit_constants.inc"

; Unit deployment controllers shared by reserve-unit redeployment and the
; selected-map CALL command. Reserve units must deploy on a compatible current-
; side property near HQ; newly called units use an empty, traversable map cell.
; Both commit through the same record/status/map-presentation path.
DEF wUnitDeploymentIndex      EQU $c940
DEF wMapInteractionInputState EQU $ca91

DEF UNIT_DEPLOY_DOMAIN_GROUND         EQU $02
DEF UNIT_DEPLOY_DOMAIN_SERVICE_GROUND EQU $04
DEF UNIT_DEPLOY_DOMAIN_AIR            EQU $06
DEF UNIT_DEPLOY_DOMAIN_SEA            EQU $09

section "Unit Deployment Runtime", romx[$7b89], bank[$0c]

UnitDeployment_RunReservePlacementController::
    ; A = reserve live-unit index. Interactive placement returns 0 on deployment
    ; and $FF on B-button cancel.
    ld [wUnitDeploymentIndex], a
    farcall MapControl_ReinitializeAfterResolution
.input_loop
    farcall MapControl_UpdateInteractionInputState
    call UnitDeployment_UpdateReserveCursorEligibility
    ld a, [wMapInteractionInputState]
    bit 4, a
    jr nz, .move_right
    bit 5, a
    jr nz, .move_left
    bit 6, a
    jr nz, .move_up
    bit 7, a
    jr nz, .move_down
    bit 0, a
    jr nz, .confirm
    bit 1, a ; B button
    jr nz, .cancel
    jr .input_loop
.move_right
    farcall MapControl_AdvanceHorizontalMapPosition
    jr .input_loop
.move_left
    farcall MapControl_RetreatHorizontalMapPosition
    jr .input_loop
.move_up
    farcall MapControl_RetreatVerticalMapPosition
    jr .input_loop
.move_down
    farcall MapControl_AdvanceVerticalMapPosition
    jr .input_loop
.confirm
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call UnitDeployment_CheckReservePlacementAvailable
    and a
    jr nz, .invalid
    call UnitDeployment_CommitAtCoordinates
    xor a
    jr .done
.cancel
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr .done
.invalid
    ld a, SFX_ERROR
    call Audio_PlaySFX
    jp .input_loop
.done
    ret
UnitDeployment_UpdateReserveCursorEligibility::
    ; Toggle the normal/eligible cursor animation for reserve deployment.
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, [wMapCursorSpriteVariant]
    and a
    jr nz, .currently_highlighted
    call UnitDeployment_CheckReservePlacementAvailable
    and a
    jr nz, .done
    farcall MapCursor_UseEligiblePropertyAnimation
    ld a, $01
    ld [wMapCursorSpriteVariant], a
    jr .done
.currently_highlighted
    call UnitDeployment_CheckReservePlacementAvailable
    and a
    jr z, .done
    farcall MapCursor_UseNormalAnimation
    xor a
    ld [wMapCursorSpriteVariant], a
.done
    ret
UnitDeployment_CommitAtCoordinates::
    ; B/C = destination coordinates. Move the selected live record to B/C, clear
    ; reserve status, mark its turn ended, draw it on the map, and run the paired
    ; reserve-deployment transition.
    push bc
    push de
    push bc
    ld e, b
    ld d, c
    ld c, UNIT_RECORD_X_OFFSET
    ld a, [wUnitDeploymentIndex]
    farcall UnitRecord_SetWord
    ld a, [wUnitDeploymentIndex]
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall UnitRecord_GetByte
    res UNIT_RECORD_STATUS_RESERVE_F, a
    set UNIT_RECORD_STATUS_END_TURN_F, a
    ld b, a
    ld a, [wUnitDeploymentIndex]
    farcall UnitRecord_SetByte
    ld a, SFX_CONFIRM
    call Audio_PlaySFX
    pop bc
    farcall MapUnitTransition_BeginDeployment
    push bc
    ld a, [wUnitDeploymentIndex]
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall UnitRecord_GetByte
    pop bc
    farcall MapTile_SetOverlayByteAtCoordinates
    ld a, [wUnitDeploymentIndex]
    farcall UnitSelection_RefreshLiveUnitMapPresentation
    farcall MapUnitTransition_EndDeployment
    pop de
    pop bc
    ret
UnitDeployment_CheckReservePlacementAvailable::
    ; B/C = candidate coordinates. Require a current-side eligible property near
    ; HQ and a property/domain pairing accepted by MapAI_TestDomainCompatibility.
    push bc
    farcall UnitCreation_GetEligiblePropertyTypeNearHQ
    and a
    jr z, .unavailable
    ld b, a
    call UnitDeployment_ClassifyUnitTypeDomain
    farcall MapAI_TestDomainCompatibility
    and a
    jr nz, .unavailable
    xor a
    jr .done
.unavailable
    ld a, $01
.done
    pop bc
    ret
UnitDeployment_ClassifyUnitTypeDomain::
    ; Classify the selected unit for property-domain placement: the three service
    ; truck types use their special ground code; other land, air, and sea groups
    ; use the established 2/6/9 domain values.
    push bc
    ld a, [wUnitDeploymentIndex]
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall UnitRecord_GetByte
    srl a
    cp UNIT_TYPE_CONSTRUCTION_TRUCK
    jr z, .service_ground
    cp UNIT_TYPE_SUPPLY_TRUCK
    jr z, .service_ground
    cp UNIT_TYPE_SUPPLY_TRUCK_S
    jr z, .service_ground
    cp UNIT_TYPE_FIGHTER_PLANE_A
    jr c, .ordinary_ground
    cp UNIT_TYPE_AEGIS_WARSHIP
    jr c, .air
    ld a, UNIT_DEPLOY_DOMAIN_SEA
    jr .done
.service_ground
    ld a, UNIT_DEPLOY_DOMAIN_SERVICE_GROUND
    jr .done
.ordinary_ground
    ld a, UNIT_DEPLOY_DOMAIN_GROUND
    jr .done
.air
    ld a, UNIT_DEPLOY_DOMAIN_AIR
.done
    pop bc
    ret
UnitDeployment_RunCalledUnitPlacementController::
    ; A = newly created CALL unit index. Placement cannot be cancelled here; the
    ; controller loops until A confirms an empty traversable cell.
    ld [wUnitDeploymentIndex], a
.input_loop
    farcall MapControl_UpdateInteractionInputState
    call UnitDeployment_UpdateCalledCursorEligibility
    ld a, [wMapInteractionInputState]
    bit 4, a
    jr nz, .move_right
    bit 5, a
    jr nz, .move_left
    bit 6, a
    jr nz, .move_up
    bit 7, a
    jr nz, .move_down
    bit 0, a
    jr nz, .confirm
    jr .input_loop
.move_right
    farcall MapControl_AdvanceHorizontalMapPosition
    jr .input_loop
.move_left
    farcall MapControl_RetreatHorizontalMapPosition
    jr .input_loop
.move_up
    farcall MapControl_RetreatVerticalMapPosition
    jr .input_loop
.move_down
    farcall MapControl_AdvanceVerticalMapPosition
    jr .input_loop
.confirm
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call UnitDeployment_CheckCalledPlacementAvailable
    and a
    jr nz, .invalid
    call UnitDeployment_CommitAtCoordinates
    xor a
    jr .done
.invalid
    ld a, SFX_ERROR
    call Audio_PlaySFX
    jp .input_loop
.done
    ret
UnitDeployment_CheckCalledPlacementAvailable::
    ; B/C = candidate coordinates. Require no unit overlay and a nonzero movement
    ; cost for the selected unit's movement profile on the underlying terrain.
    push bc
    farcall MapTile_GetOverlayIdAtCoordinates
    and a
    jr nz, .unavailable
    farcall MapTile_GetBaseIdAtCoordinates
    farcall Terrain_GetNameIndex
    ld b, a
    ld a, [wUnitDeploymentIndex]
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall UnitRecord_GetByte
    ld c, UNIT_DATA_MOVEMENT_PROFILE_OFFSET
    farcall UnitData_GetByte
    farcall MovementData_GetCost
    and a
    jr z, .unavailable
    xor a
    jr .done
.unavailable
    ld a, $01
.done
    pop bc
    ret
UnitDeployment_UpdateCalledCursorEligibility::
    ; Toggle the cursor highlight according to CALL-unit placement validity.
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, [wMapCursorSpriteVariant]
    and a
    jr nz, .currently_highlighted
    call UnitDeployment_CheckCalledPlacementAvailable
    and a
    jr nz, .done
    farcall MapCursor_UseEligiblePropertyAnimation
    ld a, $01
    ld [wMapCursorSpriteVariant], a
    jr .done
.currently_highlighted
    call UnitDeployment_CheckCalledPlacementAvailable
    and a
    jr z, .done
    farcall MapCursor_UseNormalAnimation
    xor a
    ld [wMapCursorSpriteVariant], a
.done
    ret

    assert @ == $7d68

; Retail SHA-1 for $7B89-$7D67 is verified by tools/verify_unit_deployment_runtime.py.
