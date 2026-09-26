include "macros/macros.inc"
include "constants/unit_constants.inc"

DEF wUnitCreationMenuMode                 EQU $c9ca
DEF wUnitCreationSelectionIndex           EQU $c940
DEF wUnitCreationSelectedEncodedTypeSide EQU $c941

; Unit Creation / CALL selection frontend.
; The standard entry receives A = the property/facility class returned by
; UnitCreation_GetEligiblePropertyTypeNearHQ, builds that property's buyable
; unit list, then runs the common DEPLOY selector. The alternate $5907 entry is
; used by CALL and installs the fixed five-entry mercenary list instead.
;
; Both paths return A = selected encoded UnitData type/side on confirmation and
; A = $FF on cancellation. The standard DEPLOY path commits the purchase itself
; after affordability succeeds; CALL returns the selected type to its caller.
section "Bank $0B Unit Creation selection frontend", romx[$57d6], bank[$0b]

UnitCreation_RunSelectionController::
    farcall $12, UnitPurchase_BuildPropertyUnitList
    xor a
    ld [wUnitCreationMenuMode], a
    xor a
    ld [wUnitCreationSelectionIndex], a

.redraw
    call MapCursor_Hide
    call Sprite_Update
    call DelayFrame
    farcall SharedGraphics_LoadMenuFontTiles
    call UnitCreation_DrawMenuLabels
    ld a, [wUnitCreationSelectionIndex]
    call UnitCreation_DrawSelectedUnitDetails
    ld a, $58
    call LCDScanlineTransition_RunToTarget
    call MapEconomy_DrawStatusPanel

.input_loop
    call Joypad_Update
    call Sprite_Update
    ldh a, [hJoyRepeat]
    bit 1, a
    jr nz, .cancel
    bit 0, a
    jr nz, .confirm
    bit 6, a
    jr nz, .previous
    bit 7, a
    jr nz, .next
    bit 2, a
    jr nz, .show_details
    jr .input_loop

.show_details
    call LCDScanlineTransition_Reset
    call MapEconomy_CloseStatusPanel
    call MapTerrainAnimation_Reset
    call FadeToWhite8
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    and $01
    ld b, a
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    srl a
    farcall UnitReference_Open
    call MapControl_ReinitializeAfterResolution
    jp .redraw

.previous
    ld a, SFX_CURSOR_MOVE
    call Audio_PlaySFX
    ld a, [wUnitCreationSelectionIndex]
    dec a
    cp $ff
    jr nz, .store_previous
    ld a, [wBuyableUnitCount]
    dec a
.store_previous
    ld [wUnitCreationSelectionIndex], a
    call UnitCreation_DrawSelectedUnitDetails
    jr .input_loop

.next
    ld a, SFX_CURSOR_MOVE
    call Audio_PlaySFX
    ld a, [wUnitCreationSelectionIndex]
    inc a
    ld hl, wBuyableUnitCount
    cp [hl]
    jr nz, .store_next
    xor a
.store_next
    ld [wUnitCreationSelectionIndex], a
    call UnitCreation_DrawSelectedUnitDetails
    jr .input_loop

.cancel
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    call MapEconomy_CloseStatusPanel
.cancel_after_panel_close
    call LCDScanlineTransition_Reset
    farcall $0b, MapCursor_LoadGraphics
    call MapCursor_Show
    ret

.confirm
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    call UnitCreation_CheckPurchaseAffordability
    cp UNIT_CREATION_PURCHASE_NO_GOLD
    jr z, .insufficient_gold
    cp UNIT_CREATION_PURCHASE_NO_MATERIAL
    jr z, .insufficient_materials
    cp UNIT_CREATION_PURCHASE_UNIT_LIMIT
    jr z, .unit_limit

    ld a, [wUnitCreationSelectedEncodedTypeSide]
    call UnitCreation_ApplyPurchaseResourceCosts

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    farcall $12, Unit_IncrementBuiltCountForEncodedSide
    farcall $12, MapUnit_CreateInitial
    farcall $12, Unit_SetEndTurnFlag

    call MapEconomy_CloseStatusPanel
    call LCDScanlineTransition_Reset
    ld a, SFX_UNIT_CREATE
    call Audio_PlaySFX
    farcall $0c, MapUnitTransition_BeginCreation
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    call $4798
    call $43d1
    farcall $0c, MapUnitTransition_EndCreation
    ld a, $02
    call $479c
    call $43d1
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    farcall $11, CampaignStats_MarkProcuredUnit
    jp .cancel_after_panel_close

.insufficient_gold
    ld a, SFX_ERROR
    call Audio_PlaySFX
    ld a, $0f
    call $51cd
    jp .input_loop

.insufficient_materials
    ld a, SFX_ERROR
    call Audio_PlaySFX
    ld a, $10
    call $51cd
    jp .input_loop

.unit_limit
    ld a, SFX_ERROR
    call Audio_PlaySFX
    ld a, $14
    call $51cd
    jp .input_loop

    assert @ == $5907

UnitCreation_RunAlternateSelectionController::
    farcall $12, UnitPurchase_AppendMercenaryTypeRange
    ld a, $01
    ld [wUnitCreationMenuMode], a
    xor a
    ld [wUnitCreationSelectionIndex], a

.redraw
    call MapCursor_Hide
    call Sprite_Update
    call DelayFrame
    farcall SharedGraphics_LoadMenuFontTiles
    call UnitCreation_DrawMenuLabels
    ld a, [wUnitCreationSelectionIndex]
    call UnitCreation_DrawSelectedUnitDetails
    ld a, $58
    call LCDScanlineTransition_RunToTarget

.input_loop
    call Joypad_Update
    call Sprite_Update
    ldh a, [hJoyRepeat]
    bit 1, a
    jr nz, .cancel
    bit 0, a
    jr nz, .confirm
    bit 6, a
    jr nz, .previous
    bit 7, a
    jr nz, .next
    bit 2, a
    jr nz, .show_details
    jr .input_loop

.show_details
    call LCDScanlineTransition_Reset
    call MapEconomy_CloseStatusPanel
    call MapTerrainAnimation_Reset
    call FadeToWhite8
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    and $01
    ld b, a
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    srl a
    farcall UnitReference_Open
    call MapControl_ReinitializeAfterResolution
    jp .redraw

.previous
    ld a, SFX_CURSOR_MOVE
    call Audio_PlaySFX
    ld a, [wUnitCreationSelectionIndex]
    dec a
    cp $ff
    jr nz, .store_selection
    ld a, [wBuyableUnitCount]
    dec a
.store_selection
    ld [wUnitCreationSelectionIndex], a
    call UnitCreation_DrawSelectedUnitDetails
    jr .input_loop

.next
    ld a, SFX_CURSOR_MOVE
    call Audio_PlaySFX
    ld a, [wUnitCreationSelectionIndex]
    inc a
    ld hl, wBuyableUnitCount
    cp [hl]
    jr nz, .store_next
    xor a
.store_next
    ld [wUnitCreationSelectionIndex], a
    call UnitCreation_DrawSelectedUnitDetails
    jr .input_loop

.cancel
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr .finish

.confirm
    ld a, SFX_UNIT_CREATE
    call Audio_PlaySFX
    ld a, [wUnitCreationSelectedEncodedTypeSide]
.finish
    push af
    call LCDScanlineTransition_Reset
    farcall $0b, MapCursor_LoadGraphics
    call MapCursor_Show
    pop af
    ret

    assert @ == $59bd
