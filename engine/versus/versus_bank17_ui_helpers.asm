include "macros/macros.inc"

; Small Bank $17 display primitive used by the Bank $18 Versus setup screen.
; The caller supplies tilemap coordinates in BC.  Retail draws the same
; 14-tile horizontal divider in tile VRAM and assigns attribute $08 to it.
section "Versus Setup Bank17 UI Helper", romx[$731b], bank[$17]
VersusSetup_DrawDividerRow::
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    push bc
    call Vram_TilemapCoord
    ld bc, $000e
    ld a, $10
    call MemsetWaitLCD

    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop bc
    call Vram_TilemapCoord
    ld bc, $000e
    ld a, $08
    call MemsetWaitLCD

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ret

    assert @ == $7346, "Versus setup Bank $17 helper boundary moved"
