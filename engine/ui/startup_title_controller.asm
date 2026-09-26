include "macros/macros.inc"
include "charmaps/char_main.inc"
setcharmap main

DEF STARTUP_ERASE_CHORD EQU $65 ; A + Select + Left + Up
DEF wStartupEraseChoice EQU $c021 ; contextual scratch alias for this prompt

; Main title/attract controller. A title timeout cycles through two attract
; presentations before returning to the title. Player input exits immediately.
section "Startup Title Attract Controller", romx[$4dc0], bank[$10]

Startup_TitleAttractLoop::
.loop
    call Startup_CheckAbsoluteEraseShortcut
    ld a, $01
    call Audio_PlayMusic
    call TitleScreen_Run
    and a
    jr nz, .accepted_input

    farcall $23, AttractIntro_Run
    call TitleScreen_Run
    and a
    jr nz, .accepted_input

    call Startup_RunStandardMapAttractDemo
    and a
    jr nz, .loop

    call Interrupt_DisableVBlank
    ld a, [wBootHardwareModel]
    farcall Startup_RunHardwarePresentation
    call Interrupt_EnableVBlank
    jr .loop

.accepted_input
    ld a, SFX_TITLE_START
    call Audio_PlaySFX
    ret

    assert @ == $4df3

; The first independent post-title routine begins at $4E8B. The attract/demo
; helper at $4ED4 is another externally bounded entry in the same startup bank.
section "Startup Standard Map Attract Demo", romx[$4ed4], bank[$10]

Startup_RunStandardMapAttractDemo::
    farcall MapRuntime_ResetDemoState
    call LCD_Disable
    ld a, 60
    farcall MapRecord_SelectStandard
    farcall MapRuntime_PrepareSelectedMapState
    ld a, 5
    ld [wActiveGameMode], a
    call Interrupt_EnableJoypad
    farcall MapControl_RunSelectedMapController
    call Interrupt_DisableJoypad
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld a, 1
    ret

    assert @ == $4efc

; Hidden destructive-save shortcut. Retail checks A+Select+Left+Up held at
; startup, then presents a Japanese double-confirmation prompt before wiping
; all external-RAM banks and rebuilding default SRAM state.
section "Startup Absolute Erase Prompt", romx[$4efc], bank[$10]

Startup_CheckAbsoluteEraseShortcut::
    call Joypad_Update
    ldh a, [hJoyHeld]
    and STARTUP_ERASE_CHORD
    cp STARTUP_ERASE_CHORD
    ret nz

    call LCD_Disable
    call Vram_ClearBGTilemapBothBanks
    farcall SharedGraphics_LoadMainFontBG
    call LoadAbsoluteEraseGraphics
    call Vram_SetDefaultBGPal

    ld a, 1
    ld b, 1
    ld hl, StartupAbsoluteErase_Palette
    call Vram_SetPals
    call Vram_ApplyPals

    farcall UIWindowStack_Init
    ld a, 1
    farcall UIWindowStack_SetBorderTile
    ld bc, $0404
    ld de, $0c09
    farcall UIWindow_DrawFrame

    ld hl, StartupAbsoluteErase_TextEraseAll
    ld bc, $0606
    call TextPut
    ld hl, StartupAbsoluteErase_TextQuestion
    ld bc, $0706
    call TextPut
    ld hl, StartupAbsoluteErase_TextOkay
    ld bc, $0806
    call TextPut
    call FadeFromWhite8

    call StartupAbsoluteErase_SelectChoice
    and a
    jr nz, .finish

    ld hl, StartupAbsoluteErase_TextReally
    ld bc, $0606
    call TextPut
    ld hl, StartupAbsoluteErase_BlankLine
    ld bc, $0706
    call TextPut
    call StartupAbsoluteErase_SelectChoice
    and a
    jr nz, .finish

    ld bc, $0404
    ld de, $0c09
    farcall UIWindow_DrawFrame
    ld hl, StartupAbsoluteErase_TextEraseAll
    ld bc, $0606
    call TextPut
    ld hl, StartupAbsoluteErase_TextErasing
    ld bc, $0806
    call TextPut
    ld bc, $060a
    ld hl, StartupAbsoluteErase_BlankLine
    call TextPut
    xor a
    ldh [hVBlankCounter], a
    call SRAM_EraseAllAndReinitialize
    ldh a, [hVBlankCounter]
    ld hl, StartupAbsoluteErase_TextErased
    ld bc, $0806
    call TextPut
.wait_for_a
    call Joypad_Update
    ldh a, [hJoyPressed]
    bit 0, a
    jr z, .wait_for_a
    ld a, 2
    call Audio_PlaySFX

.finish
    call FadeToWhite8
    ret

    assert @ == $4fbb

StartupAbsoluteErase_Palette::
    dw $7c1f, $7c1f, $0000, $7fff

; Retail Japanese prompt strings are retained byte-for-byte.
StartupAbsoluteErase_TextEraseAll::
    db "セーブデータを", 0
StartupAbsoluteErase_TextQuestion::
    db "すべてけします", 0
StartupAbsoluteErase_TextOkay::
    db "よろしいですか?", 0
StartupAbsoluteErase_TextReally::
    db "ほんとうに  ", 0
StartupAbsoluteErase_BlankLine::
    db "        ", 0
StartupAbsoluteErase_TextErasing::
    db "けしています", 0
StartupAbsoluteErase_TextErased::
    db "けしました ", 0

    assert @ == $4ffb

; Two-choice input used by both confirmation stages. Choice 0 is the
; destructive path; choice 1 is the cancel path. Left/right toggles the choice
; and A accepts it. The five tile IDs are prompt-specific glyphs loaded by
; LoadAbsoluteEraseGraphics rather than main-font characters.
StartupAbsoluteErase_SelectChoice::
    ld hl, StartupAbsoluteErase_ChoiceTiles
    ld bc, $070a
    call TextPut
    call VBlankFIFO_WaitEmpty
    ld a, 1
    ld [wStartupEraseChoice], a
    call StartupAbsoluteErase_UpdateChoiceAttributes
.loop
    call Joypad_Update
    ldh a, [hJoyPressed]
    bit 5, a
    jr nz, .left
    bit 4, a
    jr nz, .right
    bit 0, a
    jr nz, .accept
    jr .loop
.left
    ld a, [wStartupEraseChoice]
    and a
    jr nz, .toggle
    jr .loop
.right
    ld a, [wStartupEraseChoice]
    and a
    jr nz, .loop
.toggle
    xor 1
    ld [wStartupEraseChoice], a
    call StartupAbsoluteErase_UpdateChoiceAttributes
    ld a, 1
    call Audio_PlaySFX
    jr .loop
.accept
    ld a, [wStartupEraseChoice]
    and a
    jr nz, .cancel_sfx
    ld a, 2
    call Audio_PlaySFX
    jr .return_choice
.cancel_sfx
    ld a, SFX_CANCEL
    call Audio_PlaySFX
.return_choice
    ld a, [wStartupEraseChoice]
    ret

StartupAbsoluteErase_ChoiceTiles::
    db $04, $05, $06, $07, $08, 0

; Update the CGB BG attributes for the two prompt choices. The selected pair
; uses palette/attribute 0 and the unselected pair uses 1, matching retail.
StartupAbsoluteErase_UpdateChoiceAttributes::
    xor 1
    ld d, a
    ld bc, $070a
    call Vram_TilemapCoord
    ld a, 1
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, d
    call Vram_Put
    ld a, d
    call Vram_Put
    inc hl
    ld a, d
    xor 1
    call Vram_Put
    ld a, d
    xor 1
    call Vram_Put
    ret

    assert @ == $5080

; Independent attract-mode splash immediately following the title background
; loader. It displays the retail Japanese "Anime Demo" label, waits up to
; 180 frames for A/Start, and returns the pressed-button state or 0 on timeout.
section "Startup Anime Demo Splash", romx[$4e8b], bank[$10]

DEF wStartupAnimeDemoTimer EQU $ccdc

Startup_ShowAnimeDemoSplash::
    call LCD_Disable
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    call Vram_ClearBGTilemapBothBanks
    ld a, 0
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, Startup_AnimeDemoLabel
    call CoordTextPut
    call FadeFromWhite8
    xor a
    ld [wStartupAnimeDemoTimer], a
.loop
    call Joypad_Update
    ldh a, [hJoyPressed]
    bit 0, a
    ret nz
    bit 3, a
    ret nz
    ld a, [wStartupAnimeDemoTimer]
    inc a
    cp $b4
    jr z, .timeout
    ld [wStartupAnimeDemoTimer], a
    jr .loop
.timeout
    call FadeToWhite8
    call LCD_Disable
    xor a
    and a
    ret

Startup_AnimeDemoLabel::
    db 7, 7
    db "アニメデモ", 0

    assert @ == $4ed4
