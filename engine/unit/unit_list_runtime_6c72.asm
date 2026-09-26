include "macros/macros.inc"

; Unit List controller, selection navigation, record-detail entry, and delete UI.
; This code shares the Bank $18 Versus setup/list presentation state and keeps
; the existing Unit List text resources in engine/unit/unit_list.asm.

section "Unit List Controller Runtime", romx[$6c72], bank[$18]
UnitList_GetSelectionDisplayValue::
    ld a, [$dc66]
    ld bc, $0e01
    ld d, $02
    call Text_QueueHexByte
    ld hl, UnitList_Count
    call CoordTextPut
    ret
UnitList_GetSelectedRecordField04::
    call Versus_GetSetupSelectionRelativeIndex
    farcall UnitList_GetFilteredRecordPointer
    ld bc, $0004
    add hl, bc
    ld a, [hl]
    ret
UnitList_GetSelectedRecordField00::
    call Versus_GetSetupSelectionRelativeIndex
    farcall UnitList_GetFilteredRecordPointer
    ld bc, $0000
    add hl, bc
    ld a, [hl]
    ret
UnitList_TestSelectedRecordState::
    call UnitList_GetSelectedRecordField04
    ld c, $03
    farcall $12, UnitRecord_GetByte
    ld [$dc7c], a
    ld a, $01
    ld hl, $dc7c
    call Bitfield_Test
    jr z, UnitList_Local_6cb6
    xor a
    ret
UnitList_Local_6cb6:
    scf
    ret
UnitList_RunController::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call Versus_LoadActiveSideSetupState
    call Versus_DrawSetupSelectionScreen
    farcall UnitList_UpdateScrollArrowVisibility
    call FadeFromWhite8
UnitList_ControllerLoop::
    call Joypad_Update
    call Sprite_Update
    ld a, [$dc66]
    and a
    jp z, UnitList_ControllerExit
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 6, a
    jr z, UnitList_Local_6d3e
    call Versus_GetSetupSelectionRelativeIndex
    cp $00
    jr z, UnitList_ControllerLoop
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc58]
    dec a
    cp $ff
    jr nz, UnitList_Local_6d27
    ld a, [$dc66]
    ld c, a
    ld a, $06
    cp c
    jr nc, UnitList_Local_6d06
    jr UnitList_Local_6d0c
UnitList_Local_6d06:
    ld a, [$dc66]
    dec a
    jr UnitList_Local_6d27
UnitList_Local_6d0c:
    xor a
    push af
    ld a, [$dc5b]
    dec a
    cp $ff
    jr z, UnitList_Local_6d18
    jr UnitList_Local_6d1c
UnitList_Local_6d18:
    ld a, [$dc66]
    dec a
UnitList_Local_6d1c:
    ld [$dc5b], a
    call Versus_DrawSetupUnitEntries
    farcall UnitList_UpdateScrollArrowVisibility
    pop af
UnitList_Local_6d27:
    push af
    ld a, [$dc64]
    dec a
    ld [$dc64], a
    pop af
    ld [$dc58], a
    call UnitList_Runtime_7446
    ld bc, $0101
    call Versus_DrawSelectedUnitName
    jr UnitList_ControllerLoop
UnitList_Local_6d3e:
    bit 7, a
    jr z, UnitList_Local_6d9f
    ld a, [$dc66]
    dec a
    ld c, a
    push bc
    call Versus_GetSetupSelectionRelativeIndex
    pop bc
    cp c
    jp z, UnitList_ControllerLoop
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc58]
    inc a
    push af
    ld a, [$dc66]
    ld c, a
    pop af
    cp c
    jr nz, UnitList_Local_6d65
    xor a
    jr UnitList_Local_6d87
UnitList_Local_6d65:
    cp $06
    jr nz, UnitList_Local_6d87
    ld a, $05
    push af
    ld a, [$dc5b]
    inc a
    push af
    ld a, [$dc66]
    ld c, a
    pop af
    cp c
    jr z, UnitList_Local_6d7b
    jr UnitList_Local_6d7c
UnitList_Local_6d7b:
    xor a
UnitList_Local_6d7c:
    ld [$dc5b], a
    call Versus_DrawSetupUnitEntries
    farcall UnitList_UpdateScrollArrowVisibility
    pop af
UnitList_Local_6d87:
    push af
    ld a, [$dc64]
    inc a
    ld [$dc64], a
    pop af
    ld [$dc58], a
    call UnitList_Runtime_7446
    ld bc, $0101
    call Versus_DrawSelectedUnitName
    jp UnitList_ControllerLoop
UnitList_Local_6d9f:
    bit 4, a
    jr z, UnitList_Local_6df7
    ld a, [$dc5b]
    add a, $06
    ld c, a
    ld a, [$dc66]
    dec a
    cp c
    jp c, UnitList_ControllerLoop
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc5b]
    add a, $06
    ld c, a
    ld a, [$dc66]
    sub $06
    cp c
    jr c, UnitList_Local_6dd5
    ld a, [$dc5b]
    add a, $06
    push af
    ld a, [$dc64]
    add a, $06
    ld [$dc64], a
    pop af
    jr UnitList_Local_6de4
UnitList_Local_6dd5:
    ld a, [$dc66]
    sub $06
    ld c, a
    push af
    ld a, [$dc58]
    add a, c
    ld [$dc64], a
    pop af
UnitList_Local_6de4:
    ld [$dc5b], a
    call Versus_DrawSetupUnitEntries
    farcall UnitList_UpdateScrollArrowVisibility
    ld bc, $0101
    call Versus_DrawSelectedUnitName
    jp UnitList_ControllerLoop
UnitList_Local_6df7:
    bit 5, a
    jr z, UnitList_Local_6e35
    ld a, [$dc5b]
    cp $00
    jp z, UnitList_ControllerLoop
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc5b]
    sub $06
    jr c, UnitList_Local_6e1b
    push af
    ld a, [$dc64]
    sub $06
    ld [$dc64], a
    pop af
    jr UnitList_Local_6e22
UnitList_Local_6e1b:
    ld a, [$dc58]
    ld [$dc64], a
    xor a
UnitList_Local_6e22:
    ld [$dc5b], a
    call Versus_DrawSetupUnitEntries
    farcall UnitList_UpdateScrollArrowVisibility
    ld bc, $0101
    call Versus_DrawSelectedUnitName
    jp UnitList_ControllerLoop
UnitList_Local_6e35:
    bit 2, a
    jr z, UnitList_Local_6e5f
    ld a, $02
    call Audio_PlaySFX
    call UnitList_GetSelectedRecordField00
    srl a
    push af
    call FadeToWhite8
    ld a, [wMapPhaseNumber]
    and $01
    ld b, a
    pop af
    farcall UnitReference_Open
    call Versus_DrawSetupSelectionScreen
    farcall UnitList_UpdateScrollArrowVisibility
    call FadeFromWhite8
    jp UnitList_ControllerLoop
UnitList_Local_6e5f:
    bit 3, a
    jr z, UnitList_Local_6e7b
    ld a, [$dc53]
    call SpriteObject_Hide
    call Sprite_Update
    call UnitList_Runtime_79E7
    ld a, [$dc53]
    call SpriteObject_Show
    call Sprite_Update
    jp UnitList_ControllerLoop
UnitList_Local_6e7b:
    bit 0, a
    jr z, UnitList_Local_6eb8
    call UnitList_TestSelectedRecordState
    jr c, UnitList_Local_6e86
    jr UnitList_Local_6e92
UnitList_Local_6e86:
    ld a, [$dc53]
    farcall SpriteTransition_SlideRightOffscreen
UnitList_Local_6e8d:
    call UnitList_GetSelectedRecordField04
    jr UnitList_Local_6ec6
UnitList_Local_6e92:
    ld a, [$dc53]
    call SpriteObject_Hide
    call Sprite_Update
    xor a
    ld [$dc7a], a
    call UnitList_PostPromotionEntry
    ld a, [$dc7a]
    cp $01
    jr z, UnitList_Local_6e8d
    call UnitList_Runtime_7446
    ld a, [$dc53]
    call SpriteObject_Show
    call Sprite_Update
    jp UnitList_ControllerLoop
UnitList_Local_6eb8:
    bit 1, a
    jr nz, UnitList_Local_6ebf
    jp UnitList_ControllerLoop
UnitList_Local_6ebf:
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
UnitList_Local_6ec6:
    push af
    call FadeToWhite8
    call Versus_SaveActiveSideSetupState
    pop af
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret
UnitList_ControllerExit::
    ld a, $3c
    call AdvanceFrames
    call FadeToWhite8
    ld a, $ff
    jr UnitList_Local_6ec6
UnitList_ReadSelectedRecordStatus::
    call UnitList_GetSelectedRecordField04
    farcall $12, UnitPromotion_GetEligibleEncodedType
    ld [$dc7f], a
    ret
UnitList_RunDeleteAction::
    ld a, SFX_UNIT_LIST_DELETE
    call Audio_PlaySFX
    call UnitList_ReadSelectedRecordStatus
    cp $00
    jr z, UnitList_Local_6efb
    jr UnitList_Local_6f25
UnitList_Local_6efb:
    ld a, $03
    ld [$dc7e], a
    ld bc, $0204
    ld de, $100a
    farcall UIWindowStack_PushAndDrawAnimated
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0305
    ld de, $0e08
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    jr UnitList_Local_6f4d
UnitList_Local_6f25:
    ld a, $04
    ld [$dc7e], a
    ld bc, $0204
    ld de, $100c
    farcall UIWindowStack_PushAndDrawAnimated
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0305
    ld de, $0e0a
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
UnitList_Local_6f4d:
    ld bc, $0305
    call Versus_DrawSelectedUnitName
    ld a, $08
    ld bc, $0606
    ld de, $0402
    ld h, $11
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0608
    ld de, $0402
    ld h, $19
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $060a
    ld de, $0702
    ld h, $21
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    xor a
    ld [$dc5a], a
    call UnitList_ReadSelectedRecordStatus
    cp $00
    jr z, UnitList_Local_6f96
    ld a, $08
    ld bc, $060c
    ld de, $0402
    ld h, $34
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
UnitList_Local_6f96:
    ld a, [$dc7e]
    cp $03
    jr nz, UnitList_Local_6fa8
    ld a, [$dc5a]
    cp $03
    jr nz, UnitList_Local_6fa8
    xor a
    ld [$dc5a], a
UnitList_Local_6fa8:
    ldh a, [hVRAMBank]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call SpriteObject_Create
    ld [$dc57], a
    call UnitList_Runtime_7470
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ret
UnitList_RedrawSelectionScreen::
    call Versus_SetupRuntime_6794
    ld bc, $0101
    call Versus_DrawSelectedUnitName
    call Versus_DrawSetupSelectionRows
    call Versus_DrawSetupUnitEntries
    farcall UnitList_UpdateScrollArrowVisibility
    call UnitList_Runtime_7446
    ret
UnitList_DrawDeleteChoiceLeft::
    ld a, $08
    ld bc, $080b
    ld de, $0201
    ld h, $fb
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0a0b
    ld de, $0101
    ld h, $fd
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $09
    ld bc, $0b0b
    ld de, $0201
    ld h, $fe
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ret
UnitList_DrawDeleteChoiceRight::
    ld a, $09
    ld bc, $080b
    ld de, $0201
    ld h, $fb
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0a0b
    ld de, $0101
    ld h, $fd
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0b0b
    ld de, $0201
    ld h, $fe
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ret
UnitList_RunDeleteConfirmation::
    ld a, [$dc57]
    call SpriteObject_Hide
    call Sprite_Update
    ld bc, $0204
    ld de, $100a
    farcall UIWindowStack_PushAndDraw
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0305
    ld de, $0e08
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, UnitList_Delete_Prompt
    call CoordTextPut
    ld a, $ff
    ld [$dc7d], a
    call UnitList_DrawDeleteChoiceLeft
UnitList_Local_706a:
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 5, a
    jr z, UnitList_Local_708a
    ld a, $01
    call Audio_PlaySFX
    xor a
    ld [$dc7d], a
    call UnitList_DrawDeleteChoiceRight
    jr UnitList_Local_70bb
UnitList_Local_708a:
    bit 4, a
    jr z, UnitList_Local_709d
    ld a, $01
    call Audio_PlaySFX
    ld a, $ff
    ld [$dc7d], a
    call UnitList_DrawDeleteChoiceLeft
    jr UnitList_Local_70bb
UnitList_Local_709d:
    bit 0, a
    jr z, UnitList_Local_70ab
    ld a, $02
    call Audio_PlaySFX
    ld a, [$dc7d]
    jr UnitList_Local_70bd
UnitList_Local_70ab:
    bit 1, a
    jr z, UnitList_Local_70bb
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    ld [$dc7d], a
    jr UnitList_Local_70bd
UnitList_Local_70bb:
    jr UnitList_Local_706a
UnitList_Local_70bd:
    push af
    farcall UIWindowStack_PopRestore
    ld a, [$dc57]
    call SpriteObject_Show
    call Sprite_Update
    pop af
    ret

    assert @ == $70cd, "Unit List controller runtime boundary moved"
