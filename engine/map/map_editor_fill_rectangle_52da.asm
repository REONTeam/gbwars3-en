include "macros/macros.inc"

; Rectangular Map Editor fill primitive. B/C and D/E are the two selected map
; corners and A is the terrain tile to write. The routine normalizes the corner
; order, fills WRAM bank 1's terrain plane, clears any units in WRAM bank 2 over
; the same rectangle, and keeps the two live unit-side counts synchronized.

DEF wMapEditorFillTerrainId  EQU $c946
DEF wMapEditorFillRowWidth   EQU $c947

section "Map Editor Fill Rectangle", romx[$52da], bank[$0f]

MapEditor_FillRectangle::
    push bc
    push de
    ld [wMapEditorFillTerrainId], a

    ; Normalize X bounds into B=min, D=max.
    ld a, b
    cp d
    jr c, .x_ordered
    ld b, d
    ld d, a
.x_ordered

    ; Normalize Y bounds into C=min, E=max.
    ld a, c
    cp e
    jr c, .y_ordered
    ld c, e
    ld e, a
.y_ordered

    ; Convert max coordinates to inclusive width/height counts.
    ld a, d
    sub b
    inc a
    ld d, a
    ld a, e
    sub c
    inc a
    ld e, a

    ldh a, [hWRAMBank]
    push af
    ld a, d
    ld [wMapEditorFillRowWidth], a

.row
    ld a, [wMapEditorFillRowWidth]
    ld d, a
    ; Retail uses the farcall trampoline with bank $0B even though MapGridCoord
    ; is ROM0; retain that exact call form for byte identity.
    farcall $0b, MapGridCoord

.column
    ld a, 1
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [wMapEditorFillTerrainId]
    ld [hl], a

    ld a, 2
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [hl]
    and a
    jr z, .advance_cell
    push hl
    and 1
    ld hl, wUnitCountBySide
    call AddAtoHL
    dec [hl]
    pop hl
    xor a
    ld [hl], a
.advance_cell
    inc hl
    dec d
    jr nz, .column
    inc c
    dec e
    jr nz, .row

    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

    assert @ == $5333

section "Map Editor Pre-Terrain-Fragment Padding", romx[$5333], bank[$0f]
    ds $5340 - @, $ff
    assert @ == $5340
