include "macros/macros.inc"

; Shared save-question screen used by the main-menu and Map Editor save flows.
; The English prompt/confirmation strings remain in engine/ui/main_menu.asm at
; their established fixed addresses.
section "Map Save Prompt Setup", romx[$5d6f], bank[$15]
MapSave_SetupPromptScreen::
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
    ld hl, MainMenu_SavePrompt
    call CoordTextPut
    ld a, $01
    ld [wTwoChoicePromptState], a
    ld bc, $0709
    call Gfx_DrawTwoChoiceHighlightSecond
    ret

    assert @ == $5db7

section "Main Menu Save Prompt Runtime", romx[$5dc2], bank[$15]
MainMenu_RunSavePrompt::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call FadeToWhite8
    call MapSave_SetupPromptScreen
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
    jr .finish
.check_b
    bit 1, a
    jr z, .check_left
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    ld [wTwoChoicePromptState], a
    jr .finish
.check_left
    bit 4, a
    jr z, .check_right
    xor a
    ld [wTwoChoicePromptState], a
    ld a, $01
    call Audio_PlaySFX
    ld bc, $0709
    call Gfx_DrawTwoChoiceHighlightFirst
    jr .loop_tail
.check_right
    bit 5, a
    jr z, .loop_tail
    ld a, $01
    ld [wTwoChoicePromptState], a
    ld a, $01
    call Audio_PlaySFX
    ld bc, $0709
    call Gfx_DrawTwoChoiceHighlightSecond
    jr .loop_tail
.loop_tail:
    jr .loop
.finish
    call FadeToWhite8
    ld a, [wTwoChoicePromptState]
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret

; Clear the central prompt area in both VRAM banks, draw the localized saved
; message, and wait for either A or B. The VBlank FIFO bank is switched twice so
; the same five-byte zero payload is queued to both attribute/tile destinations.
MapSave_ShowSavedConfirmation::
    ld bc, $0709
    call Vram_TilemapCoord
    ld d, h
    ld e, l
    ld a, [hVBlankFIFO_Bank]
    push af
    push de
    xor a
    ld [hVBlankFIFO_Bank], a
    ld b, $05
    ld hl, MapSave_ConfirmationVBlankZeros
    call VBlankFIFO_Queue
    pop de
    ld a, $01
    ld [hVBlankFIFO_Bank], a
    ld b, $05
    ld hl, MapSave_ConfirmationVBlankZeros
    call VBlankFIFO_Queue
    pop af
    ld [hVBlankFIFO_Bank], a

    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0206
    ld de, $1003
    xor a
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0206
    ld de, $1003
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ld hl, MainMenu_SaveConfirmation
    call CoordTextPut
.wait_input
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyPressed]
    bit 0, a
    jr z, .check_b
    ld a, $02
    call Audio_PlaySFX
    jr .done
.check_b
    bit 1, a
    jr z, .loop_tail
    ld a, $02
    call Audio_PlaySFX
    jr .done
.loop_tail:
    jr .wait_input
.done
    ret

MapSave_ConfirmationVBlankZeros::
    db 0, 0, 0, 0, 0

    assert @ == $5ebf

; The Map Menu uses SRAM slot 4; the sibling editor path uses slot 5. This is
; deliberately named by the mode/slot contract rather than by a guessed caller.
section "Map Save Mode Slot Writer", romx[$5eca], bank[$15]
MapSave_WriteModeSlot::
    ld a, [wActiveGameMode]
    cp $03
    jr z, .map_menu_slot
    jr .editor_slot
.map_menu_slot
    ld a, $04
    jr .write
.editor_slot
    ld a, $05
.write
    farcall MapSRAM_SaveActiveMapToSlot
    ret

    assert @ == $5ede
