include "macros/macros.inc"

; Main post-reset initialization. Persistent save domains are validated before
; control is handed to the shared Bank $02 bootstrap bridge.
section "Main Initialization", rom0[$156d]
Main_Init::
    ld sp, $d000
    ei
    call CGB_EnableDoubleSpeedIfNeeded
    call Vram_ResetPals
    farcall SharedGraphics_LoadMainFontBG
    farcall MapPresentation_ResetTileUpdateAndAnimationState
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    call Interrupt_EnableVBlank
    call EnableTimerInterrupt
    farcall Main_PrepareStartupDisplay
    farcall MapSRAM_ValidateStoredSlots
    farcall MapSRAM_ValidateEditorSaveSlots
    farcall Bank31_BootSaveValidation
    jr nc, .message_box_ok
    ld a, $06
    farcall MapSave_ShowSlotRecoveryNotice
.message_box_ok
    farcall Main_DisableLCDBeforeDispatch
    ld a, $02
    ldh [hROMBank], a
    ld [rROMB0], a
    jp Main_Bank2StartupBridge

Main_Hang::
    jr Main_Hang

; Enter CGB double-speed mode if the system is currently running at normal
; speed. KEY1 bit 0 requests the speed switch and STOP performs it.
CGB_EnableDoubleSpeedIfNeeded::
    ld hl, $ff4d
    bit 7, [hl]
    jr nz, .done
    set 0, [hl]
    xor a
    ldh [rIF], a
    ldh [rIE], a
    ld a, $30
    ldh [rP1], a
    stop
.done
    ret

; Symmetric retail helper retained even though no sourced caller currently
; reaches it: switch from double-speed back to normal-speed mode when needed.
CGB_DisableDoubleSpeedIfNeeded::
    ld hl, $ff4d
    bit 7, [hl]
    jr z, .done
    set 0, [hl]
    xor a
    ldh [rIF], a
    ldh [rIE], a
    ld a, $30
    ldh [rP1], a
    stop
.done
    ret

    assert @ == $15dd
