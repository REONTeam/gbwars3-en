include "macros/macros.inc"

; Setup prefix for the suspended-game resume prompt. Retail falls through at
; $6025 into SuspendMenu_DrawLabels, which returns to this routine's caller.
section "Suspend Resume Setup", romx[$5fe5], bank[$15]
SuspendResume_SetupScreen::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ldh [hWX], a
    ldh [hWY], a
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ld bc, $0101
    ld de, $1206
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld bc, $0107
    ld de, $120a
    farcall UIWindow_DrawFrameAndClearInteriorAttributes

    assert @ == SuspendMenu_DrawLabels

section "Suspend Resume Runtime", romx[$6096], bank[$15]
SuspendResume_Runtime::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call FadeToWhite8
    call SuspendResume_SetupScreen
    call FadeFromWhite8
.loop
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 0, a
    jr z, .check_left
    ld a, $02
    call Audio_PlaySFX
    jr .finish
.check_left
    bit 4, a
    jr z, .check_right
    xor a
    ld [$dc68], a
    ld a, $01
    call Audio_PlaySFX
    ld bc, $070e
    call Gfx_DrawTwoChoiceHighlightFirst
    jr .continue
.check_right
    bit 5, a
    jr z, .continue
    ld a, $01
    ld [$dc68], a
    ld a, $01
    call Audio_PlaySFX
    ld bc, $070e
    call Gfx_DrawTwoChoiceHighlightSecond
    jr .continue
.continue
    jr .loop
.finish
    call FadeToWhite8
    ld a, [$dc68]
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret

SuspendResume_DrawLeftPreview::
    farcall MapSave_SetPreviewRendererSourceB
    ld a, [$dc5c]
    ld bc, $0c05
    ld de, $0602
    farcall MapSave_DrawPreviewRect12
    farcall MapSave_SetPreviewRendererSourceA
    ld a, [$dc5c]
    ld bc, $0905
    ld de, $0302
    farcall MapSave_DrawPreviewRect6
    ret

SuspendResume_DrawRightPreview::
    farcall MapSave_SetPreviewRendererSourceB
    ld a, [$dc5d]
    ld bc, $0c05
    ld de, $0602
    farcall MapSave_DrawPreviewRect12
    farcall MapSave_SetPreviewRendererSourceA
    ld a, [$dc5d]
    ld bc, $0905
    ld de, $0302
    farcall MapSave_DrawPreviewRect6
    ret

SuspendResume_DrawRank::
    ld a, [$dc5d]
    add a
    ld hl, Rank_Strings
    call AddAtoHL
    ld a, [hl+]
    ld b, a
    ld a, [hl]
    ld c, a
    ld l, b
    ld h, c
    ld bc, $060b
    call TextPut
    ret

    assert @ == $6159
