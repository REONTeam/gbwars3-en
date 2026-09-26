include "macros/macros.inc"

; Bank $18 Unit List action and promotion runtime.
; Executable bytes are expressed as LR35902 mnemonics; the adjacent custom
; English/Japanese text resources remain owned by engine/unit/unit_list.asm.

section "Unit List Action Runtime", romx[$70d9], bank[$18]

; Draw the selected record's unit graphic into the Unit List detail panel.
UnitList_RenderSelectedRecordField04::
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call UnitList_GetSelectedRecordField04
    ld hl, $0180
    ld bc, $8800
    add hl, bc
    farcall $0b, UnitGraphic_LoadFromRecordIndex
    ret

; Resolve and draw the selected record's status/rank graphic.
UnitList_RenderSelectedRecordStatusField::
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call Versus_GetSetupSelectionRelativeIndex
    farcall UnitList_GetFilteredRecordPointer
    ld bc, $0004
    add hl, bc
    ld a, [hl]
    farcall $12, UnitPromotion_GetEligibleEncodedType
    ld [$dc7f], a
    ld hl, $01c0
    ld bc, $8800
    add hl, bc
    ld a, [$dc7f]
    farcall $0b, UnitGraphic_LoadTiles
    ret

; Draw one of the two promotion/action presentation states.
UnitList_RenderActionState::
    cp $00
    jr z, .loc_711c
    jr .loc_713c
.loc_711c:
    ld bc, $0906
    call Vram_TilemapCoord
    push hl
    call Versus_GetSetupSelectionRelativeIndex
    farcall UnitList_GetFilteredRecordPointer
    ld bc, $0000
    add hl, bc
    ld a, [hl]
    ld d, a
    ld a, $98
    ld b, $01
    ld c, $05
    pop hl
    farcall $0b, UnitGraphic_DrawMetatile
    ret
.loc_713c:
    push bc
    ld bc, $0906
    call Vram_TilemapCoord
    pop bc
    ld a, [$dc7f]
    ld d, a
    ld a, $9c
    ld b, $01
    ld c, $05
    farcall $0b, UnitGraphic_DrawMetatile
    ret

; Dispatch the currently selected Unit List record action.
UnitList_RunSelectedRecordAction::
    ld a, [$dc5a]
    cp $00
    jr z, .loc_7167
    cp $01
    jr z, .loc_717b
    cp $02
    jr z, .loc_71d8
    cp $03
    jp z, UnitList_RunPromotionPresentation
.loc_7167:
    ld a, $01
    ld [$dc7a], a
    ld a, [$dc57]
    farcall SpriteTransition_SlideRightOffscreen
    ld a, [$dc57]
    call SpriteObject_Destroy
    xor a
    ret
.loc_717b:
    ld a, [$dc57]
    farcall SpriteTransition_SlideRightOffscreen
    call UnitList_RunDeleteConfirmation
    cp $ff
    jr z, .loc_718b
    jr .loc_7193
.loc_718b:
    call UnitList_Runtime_7470
    xor a
    ld [$dc7a], a
    ret
.loc_7193:
    call UnitList_GetSelectedRecordField04
    farcall $12, Unit_DeleteRecord
    ld a, $02
    call Audio_PlaySFX
    ld a, [$dc66]
    dec a
    ld [$dc66], a
    ld a, [$dc5b]
    dec a
    cp $ff
    jr z, .loc_71b1
    ld [$dc5b], a
.loc_71b1:
    ld a, [$dc58]
    dec a
    cp $ff
    jr z, .loc_71bc
    ld [$dc58], a
.loc_71bc:
    call UnitList_Runtime_7446
    farcall UIWindowStack_PopRestore
    ld a, [$dc57]
    call SpriteObject_Destroy
    call Sprite_Update
    call UnitList_RedrawSelectionScreen
    xor a
    ld [$dc7a], a
    call UnitList_GetSelectionDisplayValue
    scf
    ret
.loc_71d8:
    call Versus_GetSetupSelectionRelativeIndex
    farcall UnitList_GetFilteredRecordPointer
    ld bc, $0003
    add hl, bc
    ld a, [hl]
    cp $04
    jr z, .loc_7231
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$a106]
    ld d, a
    call SRAM_Disable
    ld a, d
    cp $00
    jr z, .loc_7231
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$a106]
    dec a
    cp $ff
    jr z, .loc_720f
    ld [$a106], a
.loc_720f:
    call SRAM_Disable
    call UnitList_GetSelectedRecordField04
    ld hl, $0028
    farcall $12, UnitRecord_AddExperienceClamped
    call Versus_SetupRuntime_6794
    ld a, $01
    ld [$dc7b], a
    ld a, $02
    call Audio_PlaySFX
    call Versus_DrawSetupFooter
    xor a
    ld [$dc7a], a
    ret
.loc_7231:
    ld a, SFX_ERROR
    call Audio_PlaySFX
    xor a
    ret

; Run the promotion/result presentation and restore the Unit List UI.
UnitList_RunPromotionPresentation::
    ld a, [$dc57]
    farcall SpriteTransition_SlideRightOffscreen
    ld bc, $0204
    ld de, $100c
    farcall UIWindowStack_PushAndDraw
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
    ld bc, $0509
    call Versus_DrawSelectedUnitName
    call UnitList_RenderSelectedRecordField04
    call UnitList_RenderSelectedRecordStatusField
    call UnitList_GetSelectedRecordField04
    farcall $12, UnitPromotion_Apply
    call Versus_SetupRuntime_6794
    ld hl, UnitList_Promoted
    ld bc, $050a
    call $3353
    ld a, [$dc7f]
    ld bc, $050b
    call Versus_DrawSetupText_6C39
    ld hl, $7345
    ld bc, $050c
    call $3353
    ld a, [$dc57]
    call SpriteObject_Destroy
    call Sprite_Update
    xor a
    ld [$da58], a
    ld [$da59], a
    ld a, $0a
    ld [$da57], a
    xor a
    call UnitList_RenderActionState
    ld de, $001e
    ld bc, $0000
    farcall $27, Presentation_WaitFrames
    call Audio_StopSFX
    ld a, $64
    call Audio_PlaySFX
.loc_72be:
    call DelayFrame
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ld a, [$da57]
    cp $0a
    jr z, .loc_72d0
    jr .loc_72f3
.loc_72d0:
    xor a
    ld [$da57], a
    ld a, [$da58]
    cp $00
    jr z, .loc_72dd
    jr .loc_72e8
.loc_72dd:
    xor a
    call UnitList_RenderActionState
    ld a, $01
    ld [$da58], a
    jr .loc_72f3
.loc_72e8:
    ld a, $01
    call UnitList_RenderActionState
    xor a
    ld [$da58], a
    jr .loc_72f3
.loc_72f3:
    ld a, [$da57]
    inc a
    ld [$da57], a
    ld a, [$da59]
    inc a
    ld [$da59], a
    cp $78
    jr nz, .loc_72be
    ld a, $85
    call Audio_PlaySFX
    ld a, $01
    call UnitList_RenderActionState
.loc_730f:
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 0, a
    jr z, .loc_7328
    ld a, $02
    call Audio_PlaySFX
    jr .loc_732a
.loc_7328:
    jr .loc_730f
.loc_732a:
    farcall UIWindowStack_PopRestore
    farcall UIWindowStack_PopRestore
    call UnitList_RedrawSelectionScreen
    call UnitList_GetSelectionDisplayValue
    xor a
    ld [$dc7a], a
    ld a, $02
    ld [$dc5a], a
    scf
    ret

    assert @ == $7343, "Unit List action runtime boundary moved"
