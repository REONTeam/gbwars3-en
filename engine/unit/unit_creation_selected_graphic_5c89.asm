include "macros/macros.inc"

; selected-unit graphic/presentation helper used by the Unit Creation
; detail renderer. Input A is the same encoded unit-graphic selector prepared by
; UnitCreation_DrawSelectedUnitDetails. The helper derives selector + $34 for
; both the graphics transfer and the three-row tilemap presentation, then stops
; exactly before the separately called $5CB0 state predicate.
section "Bank $0B Unit Creation selected-unit graphic", romx[$5c89], bank[$0b]

UnitCreation_DrawSelectedUnitGraphic::
    push bc
    push de
    push hl
    ld b, a

    ld a, $00
    db $e0, $83 ; LDH [$FF83], A (unnamed hardware/scratch register)
    ldh [rVBK], a
    ld hl, $8fc0
    ld a, b
    add $34
    call MapMetatile_LoadTiles

    ld hl, $9c41
    ld a, b
    add $34
    ld d, a
    ld b, $00
    ld c, $03
    ld a, $fc
    call MapMetatile_DrawTilemap ; shared unit-graphic tilemap presenter

    pop hl
    pop de
    pop bc
    ret

    assert @ == $5cb0
