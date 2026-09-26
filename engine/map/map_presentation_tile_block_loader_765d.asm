include "macros/macros.inc"

; Load a 3x1 tile block from the shared presentation tile source at $5878.
; The caller supplies the destination/context expected by the home copy helper.

section "Map presentation 3-tile block loader", romx[$765d], bank[$0b]

MapPresentation_LoadThreeTileBlock::
    push bc
    push hl
    ld hl, $5878
    ld b, $03
    ld c, $01
    call $06d9
    pop hl
    pop bc
    ret

    assert @ == $766c
