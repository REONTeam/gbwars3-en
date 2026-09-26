include "macros/macros.inc"
include "charmaps/char_main.inc"

setcharmap main

DEF wMapSaveContinueChoice EQU $dc6b

section "Map Save Continue Prompt", romx[$7f17], bank[$27]

MapSaveContinuePrompt_Setup::
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
    ld hl, MapSaveContinuePrompt_Text
    call CoordTextPut
    ld a, $01
    ld [wMapSaveContinueChoice], a
    ld bc, $0709
    farcall Gfx_DrawTwoChoiceHighlightSecond
    ret

MapSaveContinuePrompt_Text::
    coord_text 4, 7, "ゲームをつづけますか?"

MapSaveContinuePrompt_Run::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call FadeToWhite8
    call MapSaveContinuePrompt_Setup
    call FadeFromWhite8

.loop
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 0, a
    jr z, .check_up

    ld a, $02
    call Audio_PlaySFX
    jr .done

.check_up
    bit 4, a
    jr z, .check_down

    xor a
    ld [wMapSaveContinueChoice], a
    ld a, $01
    call Audio_PlaySFX
    ld bc, $0709
    farcall Gfx_DrawTwoChoiceHighlightFirst
    jr .continue

.check_down
    bit 5, a
    jr z, .continue

    ld a, $01
    ld [wMapSaveContinueChoice], a
    ld a, $01
    call Audio_PlaySFX
    ld bc, $0709
    farcall Gfx_DrawTwoChoiceHighlightSecond
    jr .continue

.continue
    jr .loop

.done
    call FadeToWhite8
    ld a, [wMapSaveContinueChoice]
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret

assert @ == $7fd6

section "Bank 27 Tail Padding", romx[$7fd6], bank[$27]
    ds $8000 - @, $ff
