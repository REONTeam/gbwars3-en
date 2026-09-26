include "macros/macros.inc"

; Shared map/UI coordinate-presentation wrapper. The Bank-$10:$690C
; presentation primitive remains structurally named until its wider contract is known.

section "Map UI coordinate presentation wrapper", romx[$763d], bank[$0b]

MapPresentation_PrepareCoordinatesAndDraw::
    call MapPresentation_ConvertViewportTileToBGMapCoordinates
    farcall UIWindowStack_PushBacking
    ret

    assert @ == $7645
