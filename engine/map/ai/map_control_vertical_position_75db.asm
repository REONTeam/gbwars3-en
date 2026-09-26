include "macros/macros.inc"

; shared vertical map-position retreat helper. This is the reverse
; companion to MapControl_AdvanceVerticalMapPosition at $759C. It decrements
; the $C98C vertical map position, feeds the coordinate through the same MapTileUpdate_QueueHorizontalStrip
; map-position service, and decreases the $C990 transition offset toward zero
; when the coordinate itself is already at the opposite edge.
;
; The strip commit and cursor-offset contracts are now source-backed. $7613 is
; independently reused and is the next hard boundary.

section "Vertical Map Position Retreat", romx[$75db], bank[$0b]

MapControl_RetreatVerticalMapPosition::
    push bc

    ld a, [wMapCursorOffsetY]
    cp $03
    jr nc, .retreat_transition_offset

    ld a, [wMapViewportOriginY]
    and a
    jr z, .retreat_transition_offset

.retreat_coordinate
    ldh a, [hJoyRepeat]
    set 2, a
    ldh [hJoyRepeat], a

    ld a, [wMapViewportOriginX]
    ld b, a
    ld a, [wMapViewportOriginY]
    dec a
    ld c, a
    call MapTileUpdate_QueueHorizontalStrip

    ld a, SFX_CURSOR_MOVE
    call Audio_RequestSFX
    jr .done

.retreat_transition_offset
    ld a, [wMapCursorOffsetY]
    and a
    jr z, .done
    dec a
    ld [wMapCursorOffsetY], a

    ld a, SFX_CURSOR_MOVE
    call Audio_RequestSFX

.done
    pop bc
    ret

    assert @ == $7613

; SHA-1 2ee1ca822d25f2cba264ee81ee8bdaa4b2a444a4 ($75DB-$7612)
