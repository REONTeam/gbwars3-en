include "macros/macros.inc"

; Display preparation used by Main_Init before persistent-save validation.
section "Main Startup Display Preparation", romx[$4c70], bank[$14]
Main_PrepareStartupDisplay::
    farcall UIWindowStack_Init
    call Vram_ClearBGTilemapBothBanks
    call InfraredController_LoadTransferTiles
    ld a, $01
    farcall UIWindowStack_SetBorderTile
    call Vram_SetDefaultBGPal
    call Vram_ApplyPals
    call LCD_Enable
    ret

    assert @ == $4c8a

; Independent eight-byte retail record between the startup display and LCD-disable owners.
; Its consumer semantics remain intentionally neutral.
section "Main Startup Adjacent Data Record", romx[$4c8a], bank[$14]
Main_StartupAdjacentDataRecord::
    db $ff, $7f, $6c, $03, $08, $02, $00, $00
    assert @ == $4c92

section "Main Pre-Dispatch LCD Disable", romx[$4c92], bank[$14]
Main_DisableLCDBeforeDispatch::
    call LCD_Disable
    ret

    assert @ == $4c96
