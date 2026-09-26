include "macros/macros.inc"

; Versus style/country controller continuation.
; Runtime immediately follows the preserved custom-English " VS STYLE" header.
; The country-label bytes at $6031-$6043 and the warning strings at $6075+
; remain owned by engine/versus/versus.asm.

section "Versus Style Country Runtime", romx[$5e65], bank[$18]
Versus_RunStyleCountryController::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call Versus_DrawStyleSelectionScreen
    ld a, $02
    call Audio_PlayMusic
    call FadeFromWhite8

.input_loop
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 0, a
    jr z, .check_cancel

    ld a, [$dc53]
    farcall SpriteTransition_SlideRightOffscreen
    ld a, [$dc52]
    cp $00
    jr z, .select_local
    cp $01
    jr z, .select_infrared

.select_local
    ld a, $00
    ld [wMapControlInfraredBattleMode], a
    jr .finish

.select_infrared
    ld a, $01
    ld [wMapControlInfraredBattleMode], a
    jr .finish

.check_cancel
    bit 1, a
    jr z, .check_left
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr .finish

.check_left
    bit 6, a
    jr z, .check_right
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc52]
    dec a
    cp $ff
    jr nz, .store_style_left
    ld a, $01
.store_style_left
    ld [$dc52], a
    call Versus_UpdateStyleCursor
    farcall $27, Versus_DrawStyleDescription
    jr .input_loop

.check_right
    bit 7, a
    jr z, .repeat_input
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc52]
    inc a
    cp $02
    jr nz, .store_style_right
    xor a
.store_style_right
    ld [$dc52], a
    call Versus_UpdateStyleCursor
    farcall $27, Versus_DrawStyleDescription
.repeat_input
    jr .input_loop

.finish
    push af
    ld a, [$dc52]
    ld [$cc44], a
    call FadeToWhite8
    call SpriteObject_DestroyAll
    pop af
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret

Versus_UpdateStyleCursor::
    ld a, [$dc52]
    ld b, $10
    call MultiplyAByB
    ld a, l
    add $48
    ld c, a
    ld b, $38
    ld a, [$dc53]
    call $2eae
    ret

Versus_UpdateCountryCursor::
    ld a, [$dc54]
    ld b, $18
    call MultiplyAByB
    ld a, l
    add $40
    ld c, a
    ld b, $28
    ld a, [$dc55]
    call $2eae
    ret

Versus_DrawCountrySelectionScreen::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call $0618
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $77f2
    ld hl, $9000
    ld bc, $0100
    farcall $15, Memcpy
    ld de, $67c1
    ld hl, $9100
    ld bc, $0040
    farcall $14, Memcpy
    ld de, $6773
    ld hl, $9140
    ld bc, $0080
    farcall $27, Memcpy
    ld a, $00
    ld b, $08
    ld hl, Pals_MapSelection
    ld c, $15
    call $06d9
    call $06af
    call $06f2
    ld bc, $0404
    ld de, $0c07
    farcall UIWindow_DrawFrame
    ld hl, $6031
    call CoordTextPut
    ld hl, $603a
    call CoordTextPut
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0505
    ld de, $0a05
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $010c
    ld de, $1205
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld a, $0a
    ld bc, $0601
    ld de, $0802
    ld h, $00
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $10
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $11
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0b
    ld bc, $0505
    ld de, $0202
    ld h, $14
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0b
    ld bc, $0508
    ld de, $0202
    ld h, $18
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call $2de8
    ld [$dc55], a
    call Versus_UpdateCountryCursor
    call Versus_ShowCountryConflictMessage
    ret

    assert @ == $6031

section "Versus Country Conflict Message Runtime", romx[$6044], bank[$18]
Versus_ShowCountryConflictMessage::
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $020d
    ld de, $1003
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$dc54]
    cp $00
    jr z, .left_country
    jr .right_country
.left_country
    ld hl, $6075
    jr .draw
.right_country
    ld hl, $609d
.draw
    ld bc, $020d
    call TextPrint
    ret

    assert @ == $6075
