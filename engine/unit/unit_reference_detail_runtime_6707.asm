include "macros/macros.inc"
include "constants/unit_constants.inc"

; Main Unit Reference detail-screen controller and the shared submenu-screen
; foundation. The screen uses WRAM bank 3 scratch while active.

DEF wUnitReferenceSide                    EQU $cd78
DEF wUnitReferenceScrollOffset            EQU $d979
DEF wUnitReferenceCursorRow               EQU $d97a
DEF wUnitReferenceSubmenuIndex            EQU $d97c
DEF wUnitReferenceDetailCursorSpriteID    EQU $d97d
DEF wUnitReferenceNextUnitSpriteID        EQU $d97e
DEF wUnitReferencePreviousUnitSpriteID    EQU $d97f
DEF wUnitReferenceGraphicTypeScratch      EQU $d9b9
DEF wUnitReferenceCurrentType             EQU $d9ba
DEF wUnitReferenceWeapon1                 EQU $d9c1
DEF wUnitReferenceWeapon2                 EQU $d9c2
DEF wUnitReferenceLoadCapacity            EQU $d9c7
DEF wUnitReferencePromotedType            EQU $d9c8
DEF wUnitReferenceSubmenuScrollOffset     EQU $da40
DEF wUnitReferenceSubmenuItemCount        EQU $da42
DEF wUnitReferenceSubmenuVisibleRows      EQU $da43

section "Unit Reference Detail Controller", romx[$6707], bank[$25]

UnitReference_UpdateDetailCursorPosition::
    ld a, [wUnitReferenceSubmenuIndex]
    ld hl, UnitReference_DetailCursorYTable
    call AddAtoHL
    ld a, [hl]
    add a, $10
    ld c, a
    ld b, $12
    ld a, [wUnitReferenceDetailCursorSpriteID]
    call SpriteObject_SetPosition
    ret

UnitReference_DetailCursorYTable::
    db $28, $3c, $44, $4c, $54, $64, $6c, $74, $7c, $84

    assert @ == $6727

; Several Bank $25 renderers index side-specific graphics in compact paired or
; offset tables. Keep the transforms explicit rather than duplicating them.
UnitReference_AdjustIndexPlus1ForSide::
    push af
    ld a, [wUnitReferenceSide]
    cp $00
    jr z, .side0
    jr .side1
.side0
    pop af
    ret
.side1
    pop af
    inc a
    ret

    assert @ == $6736

UnitReference_AdjustIndexPlus11ForSide::
    push af
    ld a, [wUnitReferenceSide]
    cp $00
    jr z, .side0
    jr .side1
.side0
    pop af
    ret
.side1
    pop af
    add a, $0b
    ret

    assert @ == $6746

UnitReference_AdjustIndexPlus11ForSideBelow17::
    push af
    ld a, [wUnitReferenceSide]
    cp $00
    jr z, .side0
    jr .side1
.side0
    pop af
    ret
.side1
    pop af
    cp $17
    jr c, .add_side_offset
    jr .no_side_offset
.add_side_offset
    add a, $0b
    ret
.no_side_offset
    ret

    assert @ == $675d

; A = one-based unit type, BC = destination tile coordinate.
UnitReference_DrawUnitGraphic::
    ld [wUnitReferenceGraphicTypeScratch], a
    push bc
    ld a, $05
    farcall MapPresentation_LoadThreeTileBlock
    call Vram_ApplyPals
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $9010
    ld a, [wUnitReferenceGraphicTypeScratch]
    sla a
    call UnitReference_AdjustIndexPlus1ForSide
    farcall UnitGraphic_LoadTiles
    pop bc
    call Vram_TilemapCoord
    ld a, [wUnitReferenceGraphicTypeScratch]
    sla a
    call UnitReference_AdjustIndexPlus1ForSide
    ld d, a
    ld b, $01
    ld c, $05
    ld a, $01
    farcall UnitGraphic_DrawMetatile
    ret

    assert @ == $6797

; Draw/rebuild the main detail page around wUnitReferenceCurrentType.
UnitReference_DrawDetailScreen::
    call UnitReference_SetupScreen
    ldh a, [hVRAMBank]
    push af

    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f98
    call SpriteObject_Create
    ld [wUnitReferenceDetailCursorSpriteID], a
    call UnitReference_UpdateDetailCursorPosition

    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f98
    call SpriteObject_Create
    ld [wUnitReferenceNextUnitSpriteID], a
    ld bc, $a460
    ld a, [wUnitReferenceNextUnitSpriteID]
    call SpriteObject_SetPosition

    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fc2
    call SpriteObject_Create
    ld [wUnitReferencePreviousUnitSpriteID], a
    ld bc, $0c60
    ld a, [wUnitReferencePreviousUnitSpriteID]
    call SpriteObject_SetPosition

    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    call UnitReference_UpdateDetailTypeArrowVisibility
    call Sprite_Update
    ld bc, $0204
    ld a, [wUnitReferenceCurrentType]
    call UnitReference_DrawUnitGraphic
    ld hl, UnitStatus_Header
    ld bc, $0101
    call TextPrint
    call UnitStatus_Menu
    call UnitReference_DrawDetailValues
    call VBlankFIFO_Process
    ret

    assert @ == $6806

; When backing out to the type chooser, reconstruct its viewport origin/cursor
; so the current detail type remains selected.
UnitReference_SyncChooserToCurrentType::
    ld a, [wUnitReferenceCurrentType]
    cp $27
    jr c, .before_final_viewport
    jr .final_viewport
    ret
.before_final_viewport
    xor a
    ld [wUnitReferenceCursorRow], a
    ld a, [wUnitReferenceCurrentType]
    dec a
    ld [wUnitReferenceScrollOffset], a
    ret
.final_viewport
    ld a, $26
    ld [wUnitReferenceScrollOffset], a
    ld a, [wUnitReferenceCurrentType]
    ld c, a
    ld a, $33
    sub c
    ld c, a
    ld a, $0d
    sub c
    dec a
    ld [wUnitReferenceCursorRow], a
    ret

    assert @ == $6831

; A = one-based unit type. Returns A=$FF when backing out to the chooser, or
; otherwise only exits through the frontend's established return contract.
UnitReference_RunDetailController::
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ld [wUnitReferenceCurrentType], a
    call UnitReference_DrawDetailScreen
    call FadeFromWhite8
.loop
    call UnitReference_PollInputAndUpdateSprites
    bit 6, a
    jr z, .check_down
    ld a, $01
    call Audio_PlaySFX
    call UnitReference_MoveDetailCursorUp
    jr .continue
.check_down
    bit 7, a
    jr z, .check_previous_unit
    ld a, $01
    call Audio_PlaySFX
    call UnitReference_MoveDetailCursorDown
    jr .continue
.check_previous_unit
    bit 5, a
    jr z, .check_next_unit
    call UnitReference_SelectPreviousType
    jr .continue
.check_next_unit
    bit 4, a
    jr z, .check_open_submenu
    call UnitReference_SelectNextType
    jr .continue
.check_open_submenu
    bit 0, a
    jr z, .check_back
    call UnitReference_OpenSelectedSubmenu
    jr .continue
.check_back
    bit 1, a
    jr z, .continue
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    call UnitReference_SyncChooserToCurrentType
    ld a, $ff
    jr .finish
.continue
    jr .loop
.finish
    push af
    call FadeToWhite8
    call SpriteObject_DestroyAll
    pop af
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret

    assert @ == $68a1

UnitReference_OpenSelectedSubmenu::
    ld a, [wUnitReferenceSubmenuIndex]
    cp $00
    jr z, .description
    cp $01
    jr z, .movement
    cp $02
    jr z, .upkeep
    cp $03
    jr z, .weapon1
    cp $04
    jr z, .weapon2
    cp $05
    jr z, .initiative
    cp $06
    jr z, .load
    cp $07
    jp z, .promotion
    cp $08
    jp z, .defense
    cp $09
    jp z, .resupply_repair
.description
    ld a, $02
    call Audio_PlaySFX
    call FadeToWhite8
    call UnitReference_RunDescriptionSubmenu
    jp .refresh
.movement
    ld a, $02
    call Audio_PlaySFX
    call FadeToWhite8
    call UnitReference_RunMovementSubmenu
    jp .refresh
.upkeep
    ld a, $02
    call Audio_PlaySFX
    call FadeToWhite8
    call UnitReference_RunUpkeepSubmenu
    jp .refresh
.weapon1
    ld a, [wUnitReferenceWeapon1]
    cp $00
    jr z, .unavailable
    ld a, $02
    call Audio_PlaySFX
    call FadeToWhite8
    xor a
    call UnitReference_RunWeaponSubmenu
    jr .refresh
.weapon2
    ld a, [wUnitReferenceWeapon2]
    cp $00
    jr z, .unavailable
    ld a, $02
    call Audio_PlaySFX
    call FadeToWhite8
    ld a, $01
    call UnitReference_RunWeaponSubmenu
    jr .refresh
.unavailable
    ld a, SFX_ERROR
    call Audio_PlaySFX
    ret
.initiative
    ld a, $02
    call Audio_PlaySFX
    call FadeToWhite8
    call UnitReference_RunInitiativeSubmenu
    jr .refresh
.load
    ld a, [wUnitReferenceLoadCapacity]
    cp $00
    jr z, .unavailable
    ld a, $02
    call Audio_PlaySFX
    call FadeToWhite8
    call UnitReference_RunLoadSubmenu
    jr .refresh
.promotion
    ld a, [wUnitReferencePromotedType]
    cp $00
    jr z, .unavailable
    ld a, $02
    call Audio_PlaySFX
    call FadeToWhite8
    call UnitReference_RunPromotionSubmenu
    jr .refresh
.defense
    ld a, $02
    call Audio_PlaySFX
    call FadeToWhite8
    call UnitReference_RunDefenseSubmenu
    jr .refresh
.resupply_repair
    ld a, $02
    call Audio_PlaySFX
    call FadeToWhite8
    call UnitReference_RunResupplyRepairSubmenu
    jr .refresh
.refresh
    call UnitReference_DrawDetailScreen
    call FadeFromWhite8
    ret

    assert @ == $6980

UnitReference_MoveDetailCursorUp::
    ld a, [wUnitReferenceSubmenuIndex]
    dec a
    cp $ff
    jr nz, .store
    ld a, $09
.store
    ld [wUnitReferenceSubmenuIndex], a
    call UnitReference_UpdateDetailCursorPosition
    ret

    assert @ == $6991

UnitReference_MoveDetailCursorDown::
    ld a, [wUnitReferenceSubmenuIndex]
    inc a
    cp $0a
    jr nz, .store
    xor a
.store
    ld [wUnitReferenceSubmenuIndex], a
    call UnitReference_UpdateDetailCursorPosition
    ret

    assert @ == $69a1

UnitReference_SelectNextType::
    ld a, [wUnitReferenceCurrentType]
    inc a
    cp $34
    jr z, .done
    ld [wUnitReferenceCurrentType], a
    ld [wUnitReferenceCursorRow], a
    ld a, $01
    call Audio_PlaySFX
    ld bc, $0204
    ld a, [wUnitReferenceCurrentType]
    call UnitReference_DrawUnitGraphic
    call UnitReference_DrawDetailValues
    call VBlankFIFO_WaitEmpty
.done
    ret

    assert @ == $69c4

UnitReference_SelectPreviousType::
    ld a, [wUnitReferenceCurrentType]
    dec a
    cp $00
    jr z, .done
    ld [wUnitReferenceCurrentType], a
    ld [wUnitReferenceCursorRow], a
    ld a, $01
    call Audio_PlaySFX
    ld bc, $0204
    ld a, [wUnitReferenceCurrentType]
    call UnitReference_DrawUnitGraphic
    call UnitReference_DrawDetailValues
    call VBlankFIFO_WaitEmpty
.done
    ret

    assert @ == $69e7

; Shared scroll-arrow visibility logic used by the detail subpages.
UnitReference_UpdateSubmenuScrollArrows::
    ld a, [wUnitReferenceSubmenuItemCount]
    ld c, a
    ld a, [wUnitReferenceSubmenuVisibleRows]
    cp c
    jr nc, .not_scrollable

    ld a, [wUnitReferenceSubmenuScrollOffset]
    cp $00
    jr nz, .show_up
    call UnitReference_HideScrollUpArrow
    jr .update_down
.show_up
    call UnitReference_ShowScrollUpArrow
.update_down
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld c, a
    ld a, [wUnitReferenceSubmenuItemCount]
    sub c
    ld c, a
    ld a, [wUnitReferenceSubmenuScrollOffset]
    cp c
    jr z, .hide_down
    call UnitReference_ShowScrollDownArrow
    jr .done
.hide_down
    call UnitReference_HideScrollDownArrow
.done
    ret
.not_scrollable
    call UnitReference_HideScrollUpArrow
    call UnitReference_HideScrollDownArrow
    ret

    assert @ == $6a1f

; Common header/cost presentation used by the deeper Unit Reference subpages.
UnitReference_DrawSubmenuBaseAndCosts::
    call UnitReference_SetupScreen
    call UnitReference_DrawScreenFrame
    ld bc, $0005
    call UnitReference_DrawDividerRow

    ld bc, $0101
    ld a, [wUnitReferenceCurrentType]
    call UnitReference_DrawUnitGraphic
    ld a, [wUnitReferenceCurrentType]
    ld bc, $0401
    call UnitReference_DrawUnitName
    ld bc, $0402
    call UnitReference_DrawUnitClassName

    ld a, $0b
    ld [wUnitReferenceSubmenuVisibleRows], a
    xor a
    ld [wUnitReferenceSubmenuScrollOffset], a

    ld a, [wUnitReferenceCurrentType]
    farcall $32, Description_GetUnitText
    farcall $32, Description_CountLines
    ld a, [wUnitReferenceCurrentType]
    farcall $32, Description_DrawUnitText

    call UnitReference_CreateScrollArrowsTop3C
    call UnitReference_UpdateSubmenuScrollArrows

    ld hl, UnitStatus_String_Costs
    call CoordTextPut
    ld hl, UnitStatus_String_MaterialCost
    call CoordTextPut

    ld a, $08
    ld bc, $0c03
    ld de, $0101
    ld h, $eb
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0c04
    ld de, $0101
    ld h, $ea
    farcall Gfx_DrawSequentialTileRectWithAttributes

    ld hl, UnitReference_String_ValueSeparator
    ld bc, $0d03
    call TextPut
    ld hl, UnitReference_String_ValueSeparator
    ld bc, $0d04
    call TextPut

    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_GOLD_COST_OFFSET
    farcall UnitData_GetWord
    ld hl, $0064
    call Math_SignedMultiplyHLByDE
    ld d, $05
    ld bc, $0e03
    call $3251

    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_MATERIAL_COST_OFFSET
    farcall UnitData_GetWord
    ld h, d
    ld l, e
    ld d, $05
    ld bc, $0e04
    call $3251
    call VBlankFIFO_Process
    ret

    assert @ == $6ad0
