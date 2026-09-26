include "macros/macros.inc"

; Draw a 2x2 metatile into a BG tilemap. The generic entry consumes the tile
; IDs/attributes described by MapMetatileDefinitions; the unit wrapper moves a
; unit type into the unit-icon definition range first.
;
; UnitGraphic_DrawMetatile:
;   a  = first VRAM tile ID
;   b  = CGB tile-data bank (0 or 1)
;   c  = CGB palette number
;   d  = unit type
;   hl = destination BG-map address
;
; MapMetatile_DrawTilemap:
;   same inputs, except d is a complete metatile-definition index.
section "Metatile tilemap presenter", romx[$76c9], bank[$0b]

UnitGraphic_DrawMetatile::
    push af
    ld a, d
    add MAP_UNIT_OVERLAY_METATILE_FIRST
    ld d, a
    pop af

MapMetatile_DrawTilemap::
    push bc
    push de
    push hl
    call .build_attributes
    ld e, a
    ld d, 0
    ld bc, wMetatileAttributeScratch

.draw_quadrant
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, e
    call Vram_PutWaitBlank

    ld a, 1
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [bc]
    call Vram_PutWaitBlank
    inc bc

    inc e
    inc d
    ld a, d
    cp 4
    jr z, .done
    push de
    ld a, d
    call .advance_quadrant
    pop de
    jr .draw_quadrant

.done
    pop hl
    pop de
    pop bc
    ret

; Advance HL through the 2x2 tilemap quadrants while wrapping within a
; 32-column BG map: TL -> TR -> BL -> BR.
.advance_quadrant
    cp 1
    jr z, .move_right
    cp 2
    jr z, .move_down_left

.move_right
    ld a, l
    and $e0
    ld d, a
    ld a, l
    inc a
    and $1f
    or d
    ld l, a
    ret

.move_down_left
    ld a, l
    and $e0
    ld d, a
    ld a, l
    dec a
    and $1f
    or d
    ld l, a
    ld a, h
    ld de, $0020
    add hl, de
    cp $9c
    jr nc, .done_advance
    ld a, h
    and $9b
    ld h, a
.done_advance
    ret

; Build the four CGB BG-attribute bytes used by the metatile. The definition's
; stored palette/flip metadata is combined with the caller-selected tile-data
; bank in B and palette in C. A is preserved for the caller's first tile ID.
.build_attributes
    push af
    push bc
    push de
    push hl
    ld l, d
    sla b
    sla b
    sla b
    ld a, b
    or c
    ld c, a
    ld a, l
    call MapMetatileDefinition_Get
    inc hl
    ld de, wMetatileAttributeScratch
    ld b, 4
.loop
    push de
    ld a, [hli]
    inc hl
    ld d, a
    and $f0
    or c
    ld e, a
    ld a, d
    and $07
    sub $03
    add e
    pop de
    ld [de], a
    inc de
    dec b
    jr nz, .loop
    pop hl
    pop de
    pop bc
    pop af
    ret

    assert @ == $775f
