include "macros/macros.inc"

DEF wVersusStyleSelection EQU $dc52

section "Versus Style Description", romx[$6ae6], bank[$27]

Versus_DrawStyleDescription::
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $020d
    ld de, $1003
    xor a
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [wVersusStyleSelection]
    cp $00
    jr nz, .infrared
    ld hl, Versus_Menu_Type_Description
    ld bc, $020d
    call TextPrint
    ret
.infrared
    ld hl, Versus_Menu_Type_Description_Infrared
    ld bc, $020d
    call TextPrint
    ret

    assert @ == $6b1a
