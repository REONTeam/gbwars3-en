include "macros/macros.inc"

; shared horizontal map-position advance helper. The routine is
; independently reused by MOVE, selected-map control, and a later Bank-$0B
; controller path. It advances the $C98B horizontal map position toward the
; width-derived bound from $C989, feeds the resulting coordinate through the
; MapTileUpdate_QueueVerticalStrip service, and uses wMapCursorOffsetX as the associated
; transition offset when the coordinate itself can no longer advance.
;
; The queued strip is committed later by MapTileUpdate_CommitCompletedScroll.
; The matching $7564 reverse helper is sourced independently.

section "Horizontal Map Position Advance", romx[$7525], bank[$0b]

MapControl_AdvanceHorizontalMapPosition::
    push bc

    ld a, [wMapCursorOffsetX]
    cp $06
    jr c, .advance_transition_offset

    ld a, [$c989]
    sub $09
    ld hl, wMapViewportOriginX
    cp [hl]
    jr z, .advance_transition_offset

.advance_coordinate
    ldh a, [hJoyRepeat]
    set 1, a
    ldh [hJoyRepeat], a

    ld a, [wMapViewportOriginX]
    add $0a
    ld b, a
    ld a, [wMapViewportOriginY]
    ld c, a
    call MapTileUpdate_QueueVerticalStrip

    ld a, SFX_CURSOR_MOVE
    call Audio_RequestSFX
    jr .done

.advance_transition_offset
    ld a, [wMapCursorOffsetX]
    inc a
    cp $09
    jr z, .done
    ld [wMapCursorOffsetX], a

    ld a, SFX_CURSOR_MOVE
    call Audio_RequestSFX

.done
    pop bc
    ret

    assert @ == $7564

; SHA-1 0dc52366873214c6f48bc5671171424d8d38eb45 ($7525-$7563)
