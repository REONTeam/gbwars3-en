include "macros/macros.inc"

; Draw a BG rectangle from parallel tile/attribute streams described by the
; shared $CC50-$CC5C renderer scratch block. $CC50 is the source index,
; $CC52/$CC53 are the destination X/Y, $CC54/$CC55 the loop column/row,
; $CC56/$CC57 the width/height, $CC58/$CC59 the tile source, $CC5A/$CC5B
; the attribute source, and $CC5C the tile-number offset.
section "Indexed BG Rectangle Renderer", rom0[$357b]
Vram_DrawBGRectIndexed::
.row_check
    ld a, [$cc57]
    ld c, a
    ld a, [$cc55]
    cp c
    jp nc, .done
.column_loop
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
    ld a, [$cc59]
    ld l, a
    ld a, [$cc58]
    ld h, a
    ld a, [$cc50]
    call AddAtoHL
    ld a, [hl]
    ld c, a
    ld a, [$cc5c]
    add c
    pop hl
    push hl
    call Vram_Put
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$cc5b]
    ld l, a
    ld a, [$cc5a]
    ld h, a
    ld a, [$cc50]
    call AddAtoHL
    ld a, [hl]
    pop hl
    set 3, a
    call Vram_Put
    ld a, [$cc50]
    inc a
    ld [$cc50], a
    ld a, [$cc54]
    inc a
    ld [$cc54], a
    ld a, [$cc56]
    ld c, a
    ld a, [$cc54]
    cp c
    jp c, .column_loop
    xor a
    ld [$cc54], a
    ld a, [$cc55]
    inc a
    ld [$cc55], a
    jp .row_check
.done
    ret

    assert @ == $35fe
