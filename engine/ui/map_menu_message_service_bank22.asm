include "macros/macros.inc"

; Shared Bank $22 frame/update helper used while modal map-menu messages wait
; for A/B input, plus the adjacent 16-tile VRAM row initializer.
section "Bank22 Map Menu Message Service", romx[$620d], bank[$22]

MapMenuMessage_ServiceFrame::
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ret

MapMenuMessage_Fill16TileRow::
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    push bc
    call Vram_TilemapCoord
    ld bc, $0010
    ld a, $6b
    call MemsetWaitLCD
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop bc
    call Vram_TilemapCoord
    ld bc, $0010
    ld a, $08
    call MemsetWaitLCD
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ret

    assert @ == $6247
