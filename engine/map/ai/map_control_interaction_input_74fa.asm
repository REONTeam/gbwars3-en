include "macros/macros.inc"

; shared map-interaction input/update state used by selected-map,
; MOVE, Construction-direction, and HP-transfer selection paths. The helper
; preserves repeated input while an incremental map strip redraw is pending,
; then runs the established map cursor/presentation update pair.
;
; $7525 is independently reused and remains the next hard boundary.

section "Map Interaction Input State", romx[$74fa], bank[$0b]

MapControl_UpdateInteractionInputState::
    call Sprite_Update
    call Joypad_Update
    call .capture_input_during_map_update
    call MapTileUpdate_CommitCompletedScroll
    call MapCursor_UpdateAbsoluteCoordinates
    ret

.capture_input_during_map_update
    ldh a, [hJoyRepeat]
    ld [$ca91], a

.wait_for_map_update
    ldh a, [hMapTileUpdateFlags]
    bit 7, a
    jr z, .done

    call Joypad_Update
    ldh a, [hJoyRepeat]
    ld b, a
    ld a, [$ca91]
    or b
    ld [$ca91], a
    jr .wait_for_map_update

.done
    ret

    assert @ == $7525

; SHA-1 f8823099f6d8dc51ebe7bac83f4e1c41523771f4 ($74FA-$7524)
