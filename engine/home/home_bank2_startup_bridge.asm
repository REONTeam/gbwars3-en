include "macros/macros.inc"

; Shared bootstrap bridge entered after persistent-save validation and by the
; retail Bank $02 test path. It normalizes RAM/VRAM banking and display state
; before handing control to the main mode dispatcher in Bank $14.
section "Bank 02 Startup Bridge", romx[$4b68], bank[$02]
Main_Bank2StartupBridge::
    ld a, $00
    call SwitchSRAMBank
    ld a, $00
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call ResetRuntimeState
    call VBlankFIFO_Clear
    call Vram_ResetPals
    farcall SharedGraphics_LoadMainFontBG
    farcall MapPresentation_ResetTileUpdateAndAnimationState
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    call Interrupt_EnableVBlank
    call EnableTimerInterrupt
    farcall Main_ModeDispatcher
    ret

    assert @ == $4b9b
