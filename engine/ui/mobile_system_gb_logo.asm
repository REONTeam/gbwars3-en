include "macros/macros.inc"

; MOBILE SYSTEM GB startup logo. The CGB boot path displays this before the
; main title presentation.
section "Mobile System GB Logo Runtime", romx[$4000], bank[$11]

MobileSystemGB_ShowLogo::
    ld a, $81
    ldh [rLCDC], a
    ld [wLCDC], a
    call LCD_Disable
    call MobileSystemGB_LoadAssets
    call LCD_Enable
    ld bc, $0078
    farcall Startup_PresentationBusyDelay
    ret

MobileSystemGB_LoadAssets::
    ld a, 0
    ld b, 1
    ld hl, MobileSystemGB_Palette
    call Vram_SetPals
    call Vram_ApplyPals

    ld a, 0
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, MobileSystemGB_Graphics
    ld hl, $9000
    ; Retail copies 96 tile slots even though the 20x18 map references only
    ; tiles 0-$56 (87 tiles). The final nine copied slots deliberately spill
    ; across the following palette and adjacent Bank-$11 bytes and are unused.
    ld bc, $0600
    call Memcpy

    ld a, 0
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, MobileSystemGB_Tilemap
    call MobileSystemGB_Copy20x18

    ld a, 1
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, MobileSystemGB_Attrmap
    call MobileSystemGB_Copy20x18
    ret

; Copy a tightly packed 20x18 source map to the $9800 BG tilemap, respecting
; the Game Boy's 32-tile destination stride.
MobileSystemGB_Copy20x18::
    ld c, 0
.row
    ld b, 0
    call Vram_TilemapCoord
.column
    ld a, [de]
    inc de
    ld [hli], a
    inc b
    ld a, b
    cp 20
    jr nz, .column
    inc c
    ld a, c
    cp 18
    jr nz, .row
    ret

    assert @ == $4067

section "Mobile System GB Tilemap", romx[$4067], bank[$11]
MobileSystemGB_Tilemap::
    INCBIN "gfx/startup/mobile_system_gb.tilemap"
    assert @ == $41cf

section "Mobile System GB Attrmap", romx[$41cf], bank[$11]
MobileSystemGB_Attrmap::
    INCBIN "gfx/startup/mobile_system_gb.attrmap"
    assert @ == $4337

section "Mobile System GB Graphics", romx[$4337], bank[$11]
MobileSystemGB_Graphics::
    INCBIN "gfx/startup/mobile_system_gb.2bpp"
    assert @ == $48a7

section "Mobile System GB Palette", romx[$48a7], bank[$11]
MobileSystemGB_Palette::
    INCBIN "gfx/startup/mobile_system_gb.pal"
    assert @ == $48af
