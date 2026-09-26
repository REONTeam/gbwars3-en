include "macros/macros.inc"
include "charmaps/char_main.inc"

setcharmap main

DEF wMapYieldPromptChoice EQU $dc69

section "Map Yield Prompt", romx[$7997], bank[$27]

MapYieldPrompt_Setup::
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
    ld bc, $0105
    ld de, $1207
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, MapYieldPrompt_Text
    call CoordTextPut
    xor a
    ld [wMapYieldPromptChoice], a
    ld bc, $0709
    farcall Gfx_DrawTwoChoiceHighlightFirst
    ret

MapYieldPrompt_Text::
    coord_text 6, 7, "こうふくしますか?"

MapYieldPrompt_Run::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call FadeToWhite8
    call MapYieldPrompt_Setup
    call FadeFromWhite8

.loop
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 0, a
    jr z, .check_b

    ld a, $02
    call Audio_PlaySFX
    jr .done

.check_b
    bit 1, a
    jr z, .check_up

    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    ld [wMapYieldPromptChoice], a
    jr .done

.check_up
    bit 4, a
    jr z, .check_down

    xor a
    ld [wMapYieldPromptChoice], a
    ld a, $01
    call Audio_PlaySFX
    ld bc, $0709
    farcall Gfx_DrawTwoChoiceHighlightFirst
    jr .continue

.check_down
    bit 5, a
    jr z, .continue

    ld a, $01
    ld [wMapYieldPromptChoice], a
    ld a, $01
    call Audio_PlaySFX
    ld bc, $0709
    farcall Gfx_DrawTwoChoiceHighlightSecond
    jr .continue

.continue
    jr .loop

.done
    call FadeToWhite8
    ld a, [wMapYieldPromptChoice]
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret

assert @ == $7a63
