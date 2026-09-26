include "macros/macros.inc"

; Shared Bank $15 screen/tilemap presentation helpers. These routines are used
; by map menus, briefings, Unit Status, battle presentation and attract-mode UI.
; Scratch bytes in $CC52-$CCC1 are deliberately left address-based until their
; lifetimes outside this family are fully mapped.
section "Two Choice Highlight Renderers", romx[$6637], bank[$15]

; Draw the two-choice selection marker with the second row highlighted.
; BC is the top-left tile coordinate of the two-row choice area.
Gfx_DrawTwoChoiceHighlightSecond::
    push bc
    ld a, $0f
    ld de, $0201
    ld h, $fb
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    pop bc
    ld a, b
    add $02
    ld b, a
    push bc
    ld a, $08
    ld de, $0101
    ld h, $fd
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    pop bc
    ld a, b
    inc a
    ld b, a
    ld a, $08
    ld de, $0201
    ld h, $fe
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ret

; Draw the same choice area with the first row highlighted.
Gfx_DrawTwoChoiceHighlightFirst::
    push bc
    ld a, $08
    ld de, $0201
    ld h, $fb
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    pop bc
    ld a, b
    add $02
    ld b, a
    push bc
    ld a, $08
    ld de, $0101
    ld h, $fd
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    pop bc
    ld a, b
    inc a
    ld b, a
    ld a, $0f
    ld de, $0201
    ld h, $fe
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ret

assert @ == $6691

section "Common Screen And Tilemap Runtime", romx[$6691], bank[$15]

; A selects the base tile/theme offset used by the common screen setup.
; Initializes the common tile animation counters, palettes, BG maps and icon tiles.
Gfx_LoadCommonScreenAssets::
    ld [$cca6], a
    xor a
    ld [$cca4], a
    ld [$cca5], a
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$cca6]
    ld b, $10
    call MultiplyAByB
    ld a, h
    ld b, a
    ld a, l
    ld c, a
    ld hl, $8f30
    add hl, bc
    ld de, CommonScreenTiles
    ld bc, $00d0
    call Memcpy
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $0a
    farcall UIWindowStack_SetAttributes
    ld a, [$cca6]
    sub $0c
    farcall UIWindowStack_SetBorderTile
    ld a, $00
    ld b, $08
    ld hl, CommonScreenPalettes
    call Vram_SetPals
    call Vram_SetDefaultBGPal
    call Vram_ApplyPals
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $9800
    ld bc, $0400
    ld a, [$cca6]
    sub $09
    call Memset
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $9800
    ld bc, $0400
    ld a, $0c
    call Memset
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $9c00
    ld bc, $0400
    ld a, [$cca6]
    sub $09
    call Memset
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $9c00
    ld bc, $0400
    ld a, $0c
    call Memset
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $08
    ld b, $04
    ld hl, CommonScreenIconPalettes
    call Vram_SetPals
    call Vram_ApplyPals
    ld de, CommonScreenIconTiles
    ld hl, $8000
    ld bc, $00e0
    call Memcpy
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ret


; Alternate common-screen setup used by the battle presentation path.
Gfx_LoadCommonScreenAssetsAt8800::
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $8800
    ld de, CommonScreenTiles
    ld bc, $00d0
    call Memcpy
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $09
    farcall UIWindowStack_SetAttributes
    ld a, $81
    farcall UIWindowStack_SetBorderTile
    ld a, $01
    ld b, $01
    ld hl, CommonScreenAlternatePalette
    call Vram_SetPals
    ld a, $00
    ld b, $01
    ld hl, CommonScreenPalettes
    call Vram_SetPals
    call Vram_ApplyPals
    ret


; Advance the four-frame common UI tile animation. A selects the destination
; tile offset relative to VRAM $8F70; one frame is copied every four calls.
Gfx_UpdateCommonAnimatedTile::
    ld [$cca8], a
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, h
    ld [$cca6], a
    ld a, l
    ld [$cca7], a
    ld a, [$cca5]
    cp $04
    jp c, .tick

    xor a
    ld [$cca5], a
    ld a, [$cca4]
    inc a
    ld [$cca4], a
    ld a, [$cca4]
    cp $04
    jp c, .copy_frame

    xor a
    ld [$cca4], a

.copy_frame:
    ld a, [$cca4]
    ld b, $10
    call MultiplyAByB
    ld a, h
    ld b, a
    ld a, l
    ld c, a
    ld hl, CommonScreenAnimatedTileFrames
    add hl, bc
    ld a, h
    ld d, a
    ld a, l
    ld e, a
    push de
    ld a, [$cca8]
    ld b, $10
    call MultiplyAByB
    ld a, h
    ld b, a
    ld a, l
    ld c, a
    ld hl, $8f70
    add hl, bc
    pop de
    ld bc, $0010
    call MemcpyWaitLCD

.tick:
    ld a, [$cca5]
    inc a
    ld [$cca5], a
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ret


; Draw D x E sequential tiles starting at H at (B,C), writing tile IDs to
; VRAM bank 0 and fixed CGB attributes A to bank 1.
Gfx_DrawSequentialTileRectWithAttributes::
    ld [$cc5d], a
    ld a, b
    ld [$cc52], a
    ld a, c
    ld [$cc53], a
    xor a
    ld [$cc54], a
    ld [$cc55], a
    ld a, d
    ld [$cc56], a
    ld a, e
    ld [$cc57], a
    ld a, h
    ld [$cc5e], a

.row_loop:
    ld a, [$cc57]
    ld c, a
    ld a, [$cc55]
    cp c
    jp nc, .done

.column_loop:
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
    ldh a, [hVRAMBank]
    push af
    push hl
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$cc5e]
    call Vram_Put
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop hl
    ld a, [$cc5d]
    call Vram_Put
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$cc5e]
    inc a
    ld [$cc5e], a
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
    jr .row_loop

.done:
    ret


Gfx_PutTile::
    call Vram_Put
    ret


; Draw D x E sequential tiles starting at H into VRAM bank 0.
Gfx_DrawSequentialTileRect::
    ld [$ccab], a
    ld a, b
    ld [$ccac], a
    ld a, c
    ld [$ccad], a
    xor a
    ld [$ccae], a
    ld [$ccaf], a
    ld a, d
    ld [$ccb0], a
    ld a, e
    ld [$ccb1], a
    ld a, h
    ld [$ccb2], a

.row_loop:
    ld a, [$ccb1]
    ld c, a
    ld a, [$ccaf]
    cp c
    jp nc, .done

.column_loop:
    ld a, [$ccae]
    ld c, a
    ld a, [$ccac]
    add c
    ld b, a
    ld a, [$ccaf]
    ld c, a
    ld a, [$ccad]
    add c
    ld c, a
    call Vram_TilemapCoord
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$ccb2]
    call Gfx_PutTile
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$ccb2]
    inc a
    ld [$ccb2], a
    ld a, [$ccae]
    inc a
    ld [$ccae], a
    ld a, [$ccb0]
    ld c, a
    ld a, [$ccae]
    cp c
    jp c, .column_loop

    xor a
    ld [$ccae], a
    ld a, [$ccaf]
    inc a
    ld [$ccaf], a
    jr .row_loop

.done:
    ret


; Directional form of the sequential tile/attribute renderer. L=0 walks
; left-to-right; nonzero walks each row right-to-left.
Gfx_DrawSequentialTileRectDirectionalWithAttributes::
    ld [$cc5d], a
    ld a, b
    ld [$cc52], a
    ld a, c
    ld [$cc53], a
    ld a, l
    ld [$ccba], a
    cp $00
    jr z, .forward_init

    jr .reverse_init

.forward_init:
    xor a
    ld [$cc54], a
    ld [$cc55], a
    jr .direction_ready

.reverse_init:
    ld a, d
    dec a
    ld [$cc54], a
    xor a
    ld [$cc55], a

.direction_ready:
    ld a, d
    ld [$cc56], a
    ld a, e
    ld [$cc57], a
    ld a, h
    ld [$cc5e], a

.row_loop:
    ld a, [$cc57]
    ld c, a
    ld a, [$cc55]
    cp c
    jp nc, .done

.column_loop:
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
    ld a, [$cc5e]
    call Vram_Put
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop hl
    ld a, [$cc5d]
    call Vram_Put
    ld a, [$cc5e]
    inc a
    ld [$cc5e], a
    ld a, [$ccba]
    cp $00
    jr z, .advance_forward

    jr .advance_reverse

.advance_forward:
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
    jr .row_loop

.advance_reverse:
    ld a, [$cc54]
    dec a
    ld [$cc54], a
    ld a, [$cc54]
    cp $ff
    jp nz, .column_loop

    ld a, [$cc56]
    dec a
    ld [$cc54], a
    ld a, [$cc55]
    inc a
    ld [$cc55], a
    jp .row_loop


.done:
    ret


; Tile-only directional sequential renderer; L selects forward/reverse rows.
Gfx_DrawSequentialTileRectDirectional::
    ld a, b
    ld [$ccbc], a
    ld a, c
    ld [$ccbd], a
    ld a, l
    ld [$ccba], a
    cp $00
    jr z, .forward_init

    jr .reverse_init

.forward_init:
    xor a
    ld [$ccbe], a
    ld [$ccbf], a
    jr .direction_ready

.reverse_init:
    ld a, d
    dec a
    ld [$ccbe], a
    xor a
    ld [$ccbf], a

.direction_ready:
    ld a, d
    ld [$ccc0], a
    ld a, e
    ld [$ccc1], a
    ld a, h
    ld [$ccbb], a

.row_loop:
    ld a, [$ccc1]
    ld c, a
    ld a, [$ccbf]
    cp c
    jp nc, .done

.column_loop:
    ld a, [$ccbe]
    ld c, a
    ld a, [$ccbc]
    add c
    ld b, a
    ld a, [$ccbf]
    ld c, a
    ld a, [$ccbd]
    add c
    ld c, a
    call Vram_TilemapCoord
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$ccbb]
    call Vram_Put
    ld a, [$ccbb]
    inc a
    ld [$ccbb], a
    ld a, [$ccba]
    cp $00
    jr z, .advance_forward

    jr .advance_reverse

.advance_forward:
    ld a, [$ccbe]
    inc a
    ld [$ccbe], a
    ld a, [$ccc0]
    ld c, a
    ld a, [$ccbe]
    cp c
    jp c, .column_loop

    xor a
    ld [$ccbe], a
    ld a, [$ccbf]
    inc a
    ld [$ccbf], a
    jr .row_loop

.advance_reverse:
    ld a, [$ccbe]
    dec a
    ld [$ccbe], a
    ld a, [$ccbe]
    cp $ff
    jp nz, .column_loop

    ld a, [$ccc0]
    dec a
    ld [$ccbe], a
    ld a, [$ccbf]
    inc a
    ld [$ccbf], a
    jp .row_loop


.done:
    ret


; Clear a D x E rectangle at (B,C) in the currently selected VRAM bank.
Gfx_ClearTileRect::
    ld a, b
    ld [$ccb3], a
    ld a, c
    ld [$ccb4], a
    xor a
    ld [$ccb5], a
    ld [$ccb6], a
    ld a, d
    ld [$ccb7], a
    ld a, e
    ld [$ccb8], a
    ld a, [$ccb7]
    cp $00
    jr z, .done

    ld a, [$ccb8]
    cp $00
    jr z, .done

.row_loop:
    ld a, [$ccb8]
    ld c, a
    ld a, [$ccb6]
    cp c
    jp nc, .done

.column_loop:
    ld a, [$ccb5]
    ld c, a
    ld a, [$ccb3]
    add c
    ld b, a
    ld a, [$ccb6]
    ld c, a
    ld a, [$ccb4]
    add c
    ld c, a
    call Vram_TilemapCoord
    xor a
    call Vram_Put
    ld a, [$ccb5]
    inc a
    ld [$ccb5], a
    ld a, [$ccb7]
    ld c, a
    ld a, [$ccb5]
    cp c
    jp c, .column_loop

    xor a
    ld [$ccb5], a
    ld a, [$ccb6]
    inc a
    ld [$ccb6], a
    jr .row_loop

.done:
    ret


; Fill a D x E rectangle at (B,C) with tile/attribute byte A in the
; currently selected VRAM bank.
Gfx_TilemapFill::
    ld [$cc5d], a
    ld a, b
    ld [$cc52], a
    ld a, c
    ld [$cc53], a
    xor a
    ld [$cc54], a
    ld [$cc55], a
    ld a, d
    ld [$cc56], a
    ld a, e
    ld [$cc57], a
    ld a, [$cc56]
    cp $00
    jr z, .done

    ld a, [$cc57]
    cp $00
    jr z, .done

.row_loop:
    ld a, [$cc57]
    ld c, a
    ld a, [$cc55]
    cp c
    jp nc, .done

.column_loop:
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
    ld a, [$cc5d]
    call Vram_Put
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
    jr .row_loop

.done:
    ret


; In VRAM bank 1, set attribute bit 7 over a D x E rectangle at (B,C),
; restoring the caller's previous VRAM bank afterwards.
Gfx_SetTileRectPriority::
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, b
    ld [$cc52], a
    ld a, c
    ld [$cc53], a
    xor a
    ld [$cc54], a
    ld [$cc55], a
    ld a, d
    ld [$cc56], a
    ld a, e
    ld [$cc57], a
    ld a, [$cc56]
    cp $00
    jr z, .done

    ld a, [$cc57]
    cp $00
    jr z, .done

.row_loop:
    ld a, [$cc57]
    ld c, a
    ld a, [$cc55]
    cp c
    jp nc, .done

.column_loop:
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
    ld a, [hl]
    set 7, a
    call Vram_Put
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
    jr .row_loop

.done:
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ret

    assert @ == $6bba

; The 13-tile common UI payload is also used as the source of the four-frame
; animated tile at offset $40. Keep the overlap explicit rather than emitting a
; duplicate animation resource.
section "Common Screen Tiles", romx[$6bba], bank[$15]
CommonScreenTiles::
    incbin "gfx/ui/common_screen/common_tiles.2bpp", 0, $40
CommonScreenAnimatedTileFrames::
    incbin "gfx/ui/common_screen/common_tiles.2bpp", $40, $90
    assert @ == $6c8a

; Eight common BG palettes. The alternate setup selects the palette beginning
; 16 bytes into this block as its one-palette source.
section "Common Screen Palettes", romx[$6c8a], bank[$15]
CommonScreenPalettes::
    incbin "gfx/ui/common_screen/common_palettes.pal", 0, $10
CommonScreenAlternatePalette::
    incbin "gfx/ui/common_screen/common_palettes.pal", $10, $30
    assert @ == $6cca

section "Common Screen Icon Tiles", romx[$7024], bank[$15]
CommonScreenIconTiles::
    incbin "gfx/ui/common_screen/icon_tiles.2bpp"
    assert @ == $7104

section "Common Screen Icon Palettes", romx[$7104], bank[$15]
CommonScreenIconPalettes::
    incbin "gfx/ui/common_screen/icon_palettes.pal"
    assert @ == $7124
