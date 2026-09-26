include "macros/macros.inc"

; Versus country/map-type continuation around preserved text owners.
; The runtime is split at the independent IR-transfer and map-type text islands.

section "Versus Country Selection Continuation Runtime", romx[$60c6], bank[$18]
Versus_RunAlternateCountrySelection::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call Versus_DrawCountrySelectionScreen
    ld a, $02
    call Audio_PlayMusic
    call FadeFromWhite8
.loc_60da
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 0, a
    jr z, .loc_60f8
    ld a, [$dc55]
    farcall $15, SpriteTransition_SlideRightOffscreen
    ld a, [$dc54]
    jr .loc_6140
.loc_60f8
    bit 1, a
    jr z, .loc_6105
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr .loc_6140
.loc_6105
    bit 6, a
    jr z, .loc_6123
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc54]
    dec a
    cp $ff
    jr nz, .loc_6118
    ld a, $01
.loc_6118
    ld [$dc54], a
    call Versus_UpdateCountryCursor
    call Versus_ShowCountryConflictMessage
    jr .loc_60da
.loc_6123
    bit 7, a
    jr z, .loc_613e
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc54]
    inc a
    cp $02
    jr nz, .loc_6135
    xor a
.loc_6135
    ld [$dc54], a
    call Versus_UpdateCountryCursor
    call Versus_ShowCountryConflictMessage
.loc_613e
    jr .loc_60da
.loc_6140
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
Versus_DrawAlternateCountrySelectionScreen::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    farcall $10, UIWindowStack_Init
    farcall $01, SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    farcall $15, Gfx_LoadCommonScreenAssets
    ld bc, $0504
    ld de, $0a03
    farcall $10, UIWindow_DrawFrame
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0605
    ld de, $0801
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, MapMenu_IRSendLabel
    call CoordTextPut
    ld bc, $0507
    ld de, $0a03
    farcall $10, UIWindow_DrawFrame
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0608
    ld de, $0801
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, MapMenu_IRReceiveLabel
    call CoordTextPut
    ld bc, $010c
    ld de, $1205
    farcall $10, UIWindow_DrawFrame
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $020d
    ld de, $1003
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $67c1
    ld hl, $9000
    ld bc, $0040
    farcall $14, Memcpy
    ld de, $5a10
    ld hl, $9040
    ld bc, $0140
    farcall $15, Memcpy
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ldh a, [hVRAMBank]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call SpriteObject_Create
    ld [$dc57], a
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $0a
    ld bc, $0501
    ld de, $0a02
    ld h, $04
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $00
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $01
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    call Versus_UpdateAlternateCountryCursor
    ret
Versus_UpdateAlternateCountryCursor::
    ld a, [$dc56]
    ld b, $18
    call MultiplyAByB
    ld a, l
    add $3c
    ld c, a
    ld b, $30
    ld a, [$dc57]
    call SpriteObject_SetPosition
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $020d
    ld de, $1003
    xor a
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$dc56]
    cp $00
    jr z, .loc_6290
    jr .loc_629a
.loc_6290
    ld hl, MapMenu_IRSendDescription
    ld bc, $020d
    call TextPrint
    ret
.loc_629a
    ld hl, MapMenu_IRReceiveDescription
    ld bc, $020d
    call TextPrint
    ret
Versus_RunTransferMapChoiceController::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call Versus_DrawAlternateCountrySelectionScreen
    ld a, $02
    call Audio_PlayMusic
    call FadeFromWhite8
.loc_62b8
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 6, a
    jr z, .loc_62e4
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc56]
    dec a
    cp $ff
    jr z, .loc_62da
    xor a
    jr .loc_62dc
.loc_62da
    ld a, $01
.loc_62dc
    ld [$dc56], a
    call Versus_UpdateAlternateCountryCursor
    jr .loc_62b8
.loc_62e4
    bit 7, a
    jr z, .loc_6302
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc56]
    inc a
    cp $02
    jr z, .loc_62f9
    ld a, $01
    jr .loc_62fa
.loc_62f9
    xor a
.loc_62fa
    ld [$dc56], a
    call Versus_UpdateAlternateCountryCursor
    jr .loc_62b8
.loc_6302
    bit 0, a
    jr z, .loc_6310
    ld a, $02
    call Audio_PlaySFX
    ld a, [$dc56]
    jr .loc_631f
.loc_6310
    bit 1, a
    jr z, .loc_631d
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr .loc_631f
.loc_631d
    jr .loc_62b8
.loc_631f
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

    assert @ == $632f

section "Versus Map Type Presentation Runtime", romx[$6389], bank[$18]
Versus_UpdateMapTypeCursor::
    ld a, [$dc5a]
    ld b, $18
    call MultiplyAByB
    ld a, l
    add $3c
    ld c, a
    ld b, $28
    ld a, [$dc5b]
    call SpriteObject_SetPosition
    ret
Versus_DrawMapTypeSelectionScreen::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    farcall $10, UIWindowStack_Init
    farcall $01, SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    farcall $15, Gfx_LoadCommonScreenAssets
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$cc44]
    cp $00
    jr z, .loc_63d5
    jr .loc_63f2
.loc_63d5
    ld de, $76f2
    ld hl, $9000
    ld bc, $0100
    farcall $15, Memcpy
    ld a, $0a
    ld bc, $0601
    ld de, $0802
    ld h, $00
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    jr .loc_640d
.loc_63f2
    ld de, $77f2
    ld hl, $9000
    ld bc, $0100
    farcall $15, Memcpy
    ld a, $0a
    ld bc, $0601
    ld de, $0802
    ld h, $00
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
.loc_640d
    ld de, $67c1
    ld hl, $9100
    ld bc, $0040
    farcall $14, Memcpy
    ld a, $00
    ld b, $08
    ld hl, $7942
    ld c, $15
    call Vram_SetFarPals
    call Vram_SetDefaultBGPal
    call Vram_ApplyPals
    ld bc, $0404
    ld de, $0c03
    farcall $10, UIWindow_DrawFrame
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0505
    ld de, $0a01
    xor a
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, Versus_Menu_Map_Type
    call CoordTextPut
    ld bc, $0407
    ld de, $0c03
    farcall $10, UIWindow_DrawFrame
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0508
    ld de, $0a01
    xor a
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, Versus_Menu_Map_Type_Edit
    call CoordTextPut
    ld bc, $010c
    ld de, $1205
    farcall $22, UIWindow_DrawFrameAndClearInteriorAttributes
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $020d
    ld de, $1003
    xor a
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $10
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $11
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call SpriteObject_Create
    ld [$dc5b], a
    call Versus_UpdateMapTypeCursor
    call Versus_ShowMapTypeDescription
    ret
Versus_ShowMapTypeDescription::
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $020d
    ld de, $1003
    xor a
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$dc5a]
    cp $00
    jr z, .loc_64f5
    jr .loc_64fa
.loc_64f5
    ld hl, Versus_Menu_Map_Type_Description
    jr .loc_64fd
.loc_64fa
    ld hl, Versus_Menu_Map_Type_Description_Edit
.loc_64fd
    ld bc, $020d
    call TextPrint
    ret

    assert @ == $6504

section "Versus Map Type Selection Runtime", romx[$6547], bank[$18]
Versus_RunMapTypeSelectionController::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call Versus_DrawMapTypeSelectionScreen
    call FadeFromWhite8
.loc_6556
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 0, a
    jr z, .loc_6574
    ld a, [$dc5b]
    farcall $15, SpriteTransition_SlideRightOffscreen
    ld a, [$dc5a]
    jr .loc_65bc
.loc_6574
    bit 1, a
    jr z, .loc_6581
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr .loc_65bc
.loc_6581
    bit 6, a
    jr z, .loc_659f
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc5a]
    dec a
    cp $ff
    jr nz, .loc_6594
    ld a, $01
.loc_6594
    ld [$dc5a], a
    call Versus_UpdateMapTypeCursor
    call Versus_ShowMapTypeDescription
    jr .loc_6556
.loc_659f
    bit 7, a
    jr z, .loc_65ba
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc5a]
    inc a
    cp $02
    jr nz, .loc_65b1
    xor a
.loc_65b1
    ld [$dc5a], a
    call Versus_UpdateMapTypeCursor
    call Versus_ShowMapTypeDescription
.loc_65ba
    jr .loc_6556
.loc_65bc
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

    assert @ == $65cc
