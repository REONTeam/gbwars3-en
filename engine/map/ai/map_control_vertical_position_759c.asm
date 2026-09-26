include "macros/macros.inc"

; shared vertical map-position advance helper. This is the vertical
; counterpart to 's horizontal advance routine. It advances the
; $C98C vertical map position toward the height-derived bound from $C98A,
; feeds the updated B/C coordinate through MapTileUpdate_QueueHorizontalStrip
; service, and uses $C990 as the associated transition offset when the
; coordinate itself can no longer advance.
;
; The strip commit and cursor-offset contracts are now source-backed. $75DB is
; independently reused and is the next hard boundary.

section "Vertical Map Position Advance", romx[$759c], bank[$0b]

MapControl_AdvanceVerticalMapPosition::
    push bc

    ld a, [wMapCursorOffsetY]
    cp $06
    jr c, .advance_transition_offset

    ld a, [$c98a]
    sub $09
    ld hl, wMapViewportOriginY
    cp [hl]
    jr z, .advance_transition_offset

.advance_coordinate
    ldh a, [hJoyRepeat]
    set 3, a
    ldh [hJoyRepeat], a

    ld a, [wMapViewportOriginX]
    ld b, a
    ld a, [wMapViewportOriginY]
    add $09
    ld c, a
    call MapTileUpdate_QueueHorizontalStrip

    ld a, SFX_CURSOR_MOVE
    call Audio_RequestSFX
    jr .done

.advance_transition_offset
    ld a, [wMapCursorOffsetY]
    inc a
    cp $09
    jr z, .done
    ld [wMapCursorOffsetY], a

    ld a, SFX_CURSOR_MOVE
    call Audio_RequestSFX

.done
    pop bc
    ret

    assert @ == $75db

; SHA-1 4496a4f4dd95da12530032210a6919748e511597 ($759C-$75DA)
