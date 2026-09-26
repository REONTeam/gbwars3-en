include "macros/macros.inc"

; Reset the map/demo work state used before the standard-map attract sequence.
section "Map Demo State Reset", romx[$4000], bank[$13]
MapRuntime_ResetDemoState::
    ld hl, $c67e
    ld bc, $0200
    xor a
    call Memset
    xor a
    ld [$c633], a
    ld [$c631], a
    ld [$c632], a
    ld [$c630], a
    ld [$c9b5], a
    ld hl, $c8b3
    ld bc, $0008
    xor a
    call Memset
    ld a, $3d
    ld [$c685], a
    ld a, $01
    ld [$c686], a
    ret
