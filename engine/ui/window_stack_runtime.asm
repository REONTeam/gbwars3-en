include "macros/macros.inc"

; Shared framed-window stack and renderer used by menus, map briefings, battle
; information screens and other modal UI. Backing rectangles are saved in WRAM
; bank 4 as tile/attribute byte pairs so nested windows can restore what they
; covered.
DEF wUIWindowBorderTile EQU $dc6c
DEF wUIWindowAttributes EQU $dc6d
DEF wUIWindowStackDepth EQU $dc6e
DEF wUIWindowBackingWritePtr EQU $dc6f
DEF wUIWindowBackingPointers EQU $dc71
DEF wUIWindowBackingBuffer EQU $dc79
DEF wUIWindowAnimateDraw EQU $cd79

section "Shared UI Window Stack", romx[$68a8], bank[$10]

; Reset the nested-window stack, backing-buffer pointer, default attributes and
; border-tile base.
UIWindowStack_Init::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [wUIWindowStackDepth], a
    ld a, $79
    ld [wUIWindowBackingWritePtr], a
    ld a, $dc
    ld [wUIWindowBackingWritePtr + 1], a
    xor a
    ld [wUIWindowAttributes], a
    ld a, $aa
    ld [wUIWindowBorderTile], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret


; A = top-left/base border tile.
UIWindowStack_SetBorderTile::
    push bc
    ld b, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    ld [wUIWindowBorderTile], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop bc
    ret


; A = base CGB attribute byte ORed with per-edge flip bits.
UIWindowStack_SetAttributes::
    push bc
    ld b, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    ld [wUIWindowAttributes], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop bc
    ret


; Save the rectangle described by BC=(x,y), DE=(width,height), then draw its
; frame immediately.
UIWindowStack_PushAndDraw::
    call UIWindowStack_PushBacking
    call UIWindow_DrawFrame
    ret


; Save the rectangle and draw the frame with the retail per-row frame delay.
UIWindowStack_PushAndDrawAnimated::
    call UIWindowStack_PushBacking
    call UIWindow_DrawFrameAnimated
    ret


; Restore and pop the most recently saved tile/attribute rectangle.
UIWindowStack_PopRestore::
    call UIWindowStack_PopBacking
    ret


; Push BC/DE geometry and its current tile+attribute contents to the WRAM4
; backing buffer.
UIWindowStack_PushBacking::
    push bc
    push de
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    push de
    ld hl, wUIWindowStackDepth
    ld a, [hl]
    inc [hl]
    add a
    ld e, a
    ld d, $00
    ld hl, wUIWindowBackingPointers
    add hl, de
    ld a, [wUIWindowBackingWritePtr]
    ld [hl+], a
    ld a, [wUIWindowBackingWritePtr + 1]
    ld [hl+], a
    pop de
    ld a, [wUIWindowBackingWritePtr]
    ld l, a
    ld a, [wUIWindowBackingWritePtr + 1]
    ld h, a
    ld [hl], b
    inc hl
    ld [hl], c
    inc hl
    ld [hl], d
    inc hl
    ld [hl], e
    inc hl
    push hl
    call Vram_TilemapCoord
    pop bc

.row_loop:
    push de
    push hl

.column_loop:
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call Vram_Get
    ld [bc], a
    inc bc
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call Vram_Get
    ld [bc], a
    inc bc
    push de
    ld a, l
    and $e0
    ld d, a
    ld a, l
    inc a
    and $1f
    or d
    ld l, a
    pop de
    dec d
    jr nz, .column_loop

    pop hl
    ld a, h
    ld de, $0020
    add hl, de
    cp $9c
    jr nc, .next_row

    ld a, h
    and $9b
    ld h, a

.next_row:
    pop de
    dec e
    jr nz, .row_loop

    ld a, c
    ld [wUIWindowBackingWritePtr], a
    ld a, b
    ld [wUIWindowBackingWritePtr + 1], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret


; Pop the latest backing-buffer record and write its tile/attribute bytes back.
UIWindowStack_PopBacking::
    push bc
    push de
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [wUIWindowStackDepth]
    and a
    jr z, .done

    dec a
    ld [wUIWindowStackDepth], a
    add a
    ld e, a
    ld d, $00
    ld hl, wUIWindowBackingPointers
    add hl, de
    ld a, [hl+]
    ld [wUIWindowBackingWritePtr], a
    ld e, a
    ld a, [hl+]
    ld [wUIWindowBackingWritePtr + 1], a
    ld d, a
    ld a, [de]
    ld b, a
    inc de
    ld a, [de]
    ld c, a
    inc de
    push de
    call Vram_TilemapCoord
    pop bc
    ld a, [bc]
    ld d, a
    inc bc
    ld a, [bc]
    ld e, a
    inc bc

.row_loop:
    push de
    push hl

.column_loop:
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    call Vram_PutWaitBlank
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    call Vram_PutWaitBlank
    push de
    ld a, l
    and $e0
    ld d, a
    ld a, l
    inc a
    and $1f
    or d
    ld l, a
    pop de
    dec d
    jr nz, .column_loop

    pop hl
    ld a, h
    ld de, $0020
    add hl, de
    cp $9c
    jr nc, .next_row

    ld a, h
    and $9b
    ld h, a

.next_row:
    pop de
    dec e
    jr nz, .row_loop

.done:
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret


; Draw a framed rectangle without inter-row delay.
UIWindow_DrawFrame::
    xor a
    ld [wUIWindowAnimateDraw], a
    jr UIWindow_DrawFrameCore

; Draw the same frame with one DelayFrame between completed rows.
UIWindow_DrawFrameAnimated::
    ld a, $01
    ld [wUIWindowAnimateDraw], a

UIWindow_DrawFrameCore:
    push bc
    push de
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call Vram_TilemapCoord
    call UIWindow_DrawTopRow
    push de
    ld a, h
    ld de, $0020

.next_row_address:
    add hl, de
    cp $9c
    jr nc, .row_address_ready

    ld a, h
    and $9b
    ld h, a

.row_address_ready:
    pop de
    dec e

.middle_loop:
    dec e
    jr z, .bottom_row

    call UIWindow_DrawMiddleRow
    push de
    ld a, h
    ld de, $0020
    add hl, de
    cp $9c
    jr nc, .middle_row_address_ready

    ld a, h
    and $9b
    ld h, a

.middle_row_address_ready:
    pop de
    jr .middle_loop

.bottom_row:
    call UIWindow_DrawBottomRow
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret


UIWindow_DrawTopRow::
    push de
    push hl
    ld a, [wUIWindowBorderTile]
    ld b, $00
    call UIWindow_PlaceTile
    dec d

.middle_tiles:
    dec d
    jr z, .right_corner

    ld a, [wUIWindowBorderTile]
    inc a
    ld b, $00
    call UIWindow_PlaceTile
    jr .middle_tiles

.right_corner:
    ld a, [wUIWindowBorderTile]
    ld b, $20
    call UIWindow_PlaceTile
    call UIWindow_MaybeDelayFrame
    pop hl
    pop de
    ret


UIWindow_DrawMiddleRow::
    push de
    push hl
    ld a, [wUIWindowBorderTile]
    add $02
    ld b, $00
    call UIWindow_PlaceTile
    dec d

.middle_tiles:
    dec d
    jr z, .right_edge

    xor a
    ld b, $00
    call UIWindow_PlaceTile
    jr .middle_tiles

.right_edge:
    ld a, [wUIWindowBorderTile]
    add $02
    ld b, $20
    call UIWindow_PlaceTile
    call UIWindow_MaybeDelayFrame
    pop hl
    pop de
    ret


UIWindow_DrawBottomRow::
    push de
    push hl
    ld a, [wUIWindowBorderTile]
    ld b, $40
    call UIWindow_PlaceTile
    dec d

.middle_tiles:
    dec d
    jr z, .right_corner

    ld a, [wUIWindowBorderTile]
    inc a
    ld b, $40
    call UIWindow_PlaceTile
    jr .middle_tiles

.right_corner:
    ld a, [wUIWindowBorderTile]
    ld b, $60
    call UIWindow_PlaceTile
    call UIWindow_MaybeDelayFrame
    pop hl
    pop de
    ret


; Write tile A to VRAM bank 0 and wUIWindowAttributes|B to bank 1, then
; advance HL one tile with 32-column wrapping.
UIWindow_PlaceTile::
    push de
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop af
    call Vram_PutWaitBlank
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [wUIWindowAttributes]
    or b
    call Vram_PutWaitBlank
    ld a, l
    and $e0
    ld d, a
    ld a, l
    inc a
    and $1f
    or d
    ld l, a
    pop de
    ret


UIWindow_MaybeDelayFrame::
    ld a, [wUIWindowAnimateDraw]
    and a
    ret z

    call DelayFrame
    ret


; Fill the interior (one-tile inset) of the BC/DE rectangle with tile A.
UIWindow_FillInterior::
    push bc
    push de
    push af
    ld a, b
    inc a
    and $1f
    ld b, a
    ld a, c
    inc a
    and $1f
    ld c, a
    ld a, d
    sub $02
    ld d, a
    ld a, e
    sub $02
    ld e, a
    call Vram_TilemapCoord
    pop af
    ld c, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a

.row_loop:
    push de
    push hl

.column_loop:
    ld a, c
    ld b, $00
    call UIWindow_PlaceTile
    dec d
    jr nz, .column_loop

    pop hl
    ld a, h
    ld de, $0020
    add hl, de
    cp $9c
    jr nc, .next_row

    ld a, h
    and $9b
    ld h, a

.next_row:
    pop de
    dec e
    jr nz, .row_loop

    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

    assert @ == $6b45
