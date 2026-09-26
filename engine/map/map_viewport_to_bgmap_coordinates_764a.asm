include "macros/macros.inc"

; Convert viewport-relative tile coordinates in B/C to wrapped 32x32 BG-map
; coordinates using the current LCD scroll position.

section "Map viewport to BG-map coordinates", romx[$764a], bank[$0b]

MapPresentation_ConvertViewportTileToBGMapCoordinates::
    ldh a, [hSCX]
    rrca
    rrca
    rrca
    add b
    and $1f
    ld b, a

    ldh a, [hSCY]
    rrca
    rrca
    rrca
    add c
    and $1f
    ld c, a
    ret

    assert @ == $765d
