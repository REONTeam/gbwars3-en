include "macros/macros.inc"

; Center the 9x9 map viewport around B/C where possible.  The viewport origin
; is target-4 on each axis, clamped to 0 at the top/left and map_size-9 at the
; bottom/right.  MapCursor_SetMapCoordinates then stages the target
; relative to the new origin.
section "Center map viewport on coordinates", romx[$7acb], bank[$0b]
MapViewport_CenterOnCoordinates::
    ld a, [wMapGridWidth]
    sub $05
    cp b
    jr c, .right_edge
    ld a, b
    sub $04
    jr nc, .store_x
    xor a
    jr .store_x
.right_edge
    ld a, [wMapGridWidth]
    sub $09
.store_x
    ld [wMapViewportOriginX], a

    ld a, [wMapGridHeight]
    sub $05
    cp c
    jr c, .bottom_edge
    ld a, c
    sub $04
    jr nc, .store_y
    xor a
    jr .store_y
.bottom_edge
    ld a, [wMapGridHeight]
    sub $09
    jr .store_y ; explicit zero-distance retail branch
.store_y
    ld [wMapViewportOriginY], a
    call MapCursor_SetMapCoordinates
    ret

    assert @ == $7b01
