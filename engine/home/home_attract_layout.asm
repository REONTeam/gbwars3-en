include "constants/hardware.inc"

; Render the attract-scene rectangle described by the shared $CC50-$CC62
; scratch block. Tile bytes come from bank $CC61; attribute bytes come from
; bank $CC62. Retail forces VRAM bank 1 for every attribute and offsets the
; stored palette number by three because attract palettes occupy BG slots 3-7.
section "Attract Scene Layout Renderer", rom0[$35fe]
AttractScene_RenderLayout::
    ldh a, [hROMBank]
    push af
    xor a
    ld [$cc54], a
    ld [$cc55], a
    ld [$cc50], a
    ld [$cc51], a
.rowLoop
    ld a, [$cc57]
    ld c, a
    ld a, [$cc55]
    cp c
    jp nc, .done
.columnLoop
    ld a, [$cc54]
    ld c, a
    ld a, [$cc52]
    add c
    ld b, a
    ld a, [$cc55]
    ld c, a
    ld a, [$cc53]
    add c
    ld c, a
    call Vram_TilemapCoord
    push hl

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    push af
    ld a, [$cc61]
    ld a, a
    ldh [hROMBank], a
    ld [rROMB0], a
    pop af
    ld a, [$cc59]
    ld l, a
    ld a, [$cc58]
    ld h, a
    ld a, [$cc50]
    ld c, a
    ld a, [$cc51]
    ld b, a
    add hl, bc
    ld a, [hl]
    pop hl
    push hl
    call Vram_Put

    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    push af
    ld a, [$cc62]
    ld a, a
    ldh [hROMBank], a
    ld [rROMB0], a
    pop af
    ld a, [$cc5b]
    ld l, a
    ld a, [$cc5a]
    ld h, a
    ld a, [$cc50]
    ld c, a
    ld a, [$cc51]
    ld b, a
    add hl, bc
    ld a, [hl]
    set 3, a
    push af
    and $07
    add $03
    and $07
    ld d, a
    pop af
    and $f8
    add d
    pop hl
    call Vram_Put

    ld a, [$cc51]
    ld b, a
    ld a, [$cc50]
    ld c, a
    inc bc
    ld a, b
    ld [$cc51], a
    ld a, c
    ld [$cc50], a
    ld a, [$cc54]
    inc a
    ld [$cc54], a
    ld a, [$cc56]
    ld c, a
    ld a, [$cc54]
    cp c
    jp c, .columnLoop

    xor a
    ld [$cc54], a
    ld a, [$cc55]
    inc a
    ld [$cc55], a
    jp .rowLoop
.done
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ret

    assert @ == $36c4
