include "macros/macros.inc"

; shared horizontal map-position retreat helper. This is the exact
; reverse companion to MapControl_AdvanceHorizontalMapPosition at $7525. It
; decrements the $C98B horizontal map position, feeds the coordinate through
; the same MapTileUpdate_QueueVerticalStrip service, and decreases the wMapCursorOffsetX
; offset toward zero when the coordinate itself is already at the edge.
;
; The strip commit and cursor-offset contracts are now source-backed. $759C is
; independently reused and is the next hard boundary.

section "Horizontal Map Position Retreat", romx[$7564], bank[$0b]

MapControl_RetreatHorizontalMapPosition::
    push bc

    ld a, [wMapCursorOffsetX]
    cp $04
    jr nc, .retreat_transition_offset

    ld a, [wMapViewportOriginX]
    and a
    jr z, .retreat_transition_offset

.retreat_coordinate
    ldh a, [hJoyRepeat]
    set 0, a
    ldh [hJoyRepeat], a

    ld a, [wMapViewportOriginX]
    dec a
    ld b, a
    ld a, [wMapViewportOriginY]
    ld c, a
    call MapTileUpdate_QueueVerticalStrip

    ld a, SFX_CURSOR_MOVE
    call Audio_RequestSFX
    jr .done

.retreat_transition_offset
    ld a, [wMapCursorOffsetX]
    and a
    jr z, .done
    dec a
    ld [wMapCursorOffsetX], a

    ld a, SFX_CURSOR_MOVE
    call Audio_RequestSFX

.done
    pop bc
    ret

    assert @ == $759c

; SHA-1 de3e0b35d74c1b770edce3a0653e5c8c2d1c33e3 ($7564-$759B)
