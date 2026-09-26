include "macros/macros.inc"

; Title-screen graphics/palette/tilemap setup.

section "Title Screen Bank10 Wrapper", romx[$4df3], bank[$10]

; Bank-$10 entry used by the surrounding startup flow; the actual title wait
; implementation lives in Bank $27.
TitleScreen_Run::
    farcall $27, TitleScreen_ShowAndWait
    ret

assert @ == $4df8

section "Title Screen Background Loader", romx[$4df8], bank[$10]

; Load the title-screen palettes and 360 background tiles, then build the
; 20x18 BG map at $9800. Tile IDs run 0..359; attributes come from the stored
; 20x18 attrmap, with VRAM tile-bank bit 3 added for tile IDs >= 256.
TitleScreen_LoadBackgroundAssets::
    push bc
    push de
    push hl
    ldh a, [hVRAMBank]
    push af

    xor a
    ld b, $08
    ld hl, Pals_Title_Screen
    call Vram_SetPals
    call Vram_ApplyPals

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, Image_Title_Screen
    ld hl, $9000
    ld bc, $0800
    call Memcpy
    ld hl, $8800
    ld bc, $0800
    call Memcpy

    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $9000
    ld bc, $0680
    call Memcpy

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld e, $00
    ld d, $00
    ld hl, $9800
    ld c, $00
.row_loop
    push hl
    ld b, $00
.column_loop
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld [hl], e

    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    push de
    push hl
    push bc
    ld b, c
    ld a, $14
    call MultiplyAByB
    pop bc
    ld a, b
    call AddAtoHL
    ld de, Attrmap_Title_Screen
    add hl, de
    ld a, [hl]
    pop hl
    pop de
    bit 0, d
    jr z, .write_attribute
    or $08
.write_attribute
    ld [hl+], a
    inc de
    inc b
    ld a, b
    cp $14
    jr nz, .column_loop

    pop hl
    ld a, $20
    call AddAtoHL
    inc c
    ld a, c
    cp $12
    jr nz, .row_loop

    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop hl
    pop de
    pop bc
    ret

assert @ == $4e8b
