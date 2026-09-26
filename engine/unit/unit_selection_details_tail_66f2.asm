include "macros/macros.inc"

; selected-unit detail renderer data/local helper tail. These tables
; and helpers are consumed directly by UnitSelection_DrawSelectedUnitDetails.
; The next byte, $67E3, begins a separately callable coordinate/runtime family.

section "Bank $0B selected-unit detail renderer tail", romx[$66f2], bank[$0b]

UnitSelection_DetailHeaderData::
    db $04, $22
    rept 15
        db $aa
    endr
    db $00

UnitSelection_AlternateStatusRowsData::
    db $0f, $20
    db $80, $80, $80, $80, $00

UnitSelection_DetailValueGlyphTable::
    db $8e, $8d, $8c, $8b, $9d
UnitSelection_DetailPanelResourceData::
    db $ff, $7f, $1b, $00, $ff, $7f, $9f, $41
    db $00, $00, $ff, $1c, $ff, $7f, $00, $00

; Draw a detail pattern one tile-column before BC while temporarily selecting
; the alternate text/tile attribute state used by this panel.
UnitSelection_DrawDetailRowWithMode::
    push af
    push bc
    dec b
    ld a, $01
    ld [$ffcb], a
    call $3353
    xor a
    ld [$ffcb], a
    pop bc
    pop af
    ret

UnitSelection_DetailScaleLowData::
    db $07, $07, $07, $00
UnitSelection_DetailScaleHighData::
    db $10, $10, $10, $00

; Draw one of the selected-unit detail records from the staged buffer at HL.
; Exact player-facing row labels remain presentation data until the lower-level
; formatter contracts are fully sourced.
UnitSelection_DrawDetailRecordRows::
    push bc
    push de
    push hl
    ld a, [hl]
    cp $80
    jr nz, .draw_record
    ld hl, UnitSelection_EmptyDetailRowData
    call $3353
    jr .done
.draw_record
    push bc
    push hl
    ld a, $0a
    call $29bc
    ld a, [hl]
    ld hl, UnitSelection_DetailRecordHighPattern
    and a
    jr nz, .have_pattern
    ld hl, UnitSelection_DetailRecordLowPattern
.have_pattern
    call UnitSelection_DrawDetailTilemapWithMode
    pop hl
    pop bc
    call $3353
    ld a, $0a
    call $29bc
    ld a, b
    add $0a
    ld b, a
    dec b
    ld a, $a7
    call Vram_DrawTileAtCoordinates
    inc b
    ld a, [hli]
    add $81
    call Vram_DrawTileAtCoordinates
    inc b
    inc b
    ld a, $b3
    call Vram_DrawTileAtCoordinates
    inc b
    ld a, [hli]
    ld e, a
    add $81
    call Vram_DrawTileAtCoordinates
    ld a, [hli]
    cp e
    jr z, .draw_blank_pair
    ld e, a
    inc b
    ld a, $a7
    call Vram_DrawTileAtCoordinates
    inc b
    ld a, e
    add $81
    call Vram_DrawTileAtCoordinates
    jr .done
.draw_blank_pair
    inc b
    ld a, $80
    call Vram_DrawTileAtCoordinates
    inc b
    ld a, $80
    call Vram_DrawTileAtCoordinates
.done
    pop hl
    pop de
    pop bc
    ret

UnitSelection_EmptyDetailRowData::
    rept 15
        db $80
    endr
    db $00

UnitSelection_DrawDetailTilemapWithMode::
    push af
    ld a, $01
    ld [$ffcb], a
    call $3353
    xor a
    ld [$ffcb], a
    pop af
    ret

UnitSelection_DetailRecordLowPattern::
    rept 11
        db $07
    endr
    db $00
UnitSelection_DetailRecordHighPattern::
    rept 11
        db $10
    endr
    db $00

    assert @ == $67e3
