include "macros/macros.inc"

; Shared map-presentation refresh wrapper. The Bank-$10 target remains
; structurally named until its wider caller and presentation contract is owned.

section "Map presentation shared refresh wrapper", romx[$7645], bank[$0b]

MapPresentation_RunSharedRefresh::
    farcall UIWindowStack_PopBacking
    ret

    assert @ == $764a
