include "macros/macros.inc"

; Smoothly pan the map presentation until the staged action-target coordinates
; at wMapActionTargetX/Y reach B/C. Horizontal motion is resolved first, then
; vertical motion. Each single-axis step runs the normal map-strip update and
; refresh sequence before the next comparison.
section "Map pan to coordinates", romx[$7b01], bank[$0b]
MapControl_PanToCoordinates::
    push bc
    push de
    push hl
.loop
    call MapControl_IsActionTargetAtCoordinates
    and a
    jr z, .done

    ld a, [wMapActionTargetX]
    cp b
    jr c, .advance_x
    jr nz, .retreat_x
    jr .check_y
.advance_x
    call MapControl_AdvanceHorizontalMapPosition
    jr .finish_step
.retreat_x
    call MapControl_RetreatHorizontalMapPosition
.finish_step
    call MapControl_CompletePanStep

.check_y
    call MapControl_IsActionTargetAtCoordinates
    and a
    jr z, .done

    ld a, [wMapActionTargetY]
    cp c
    jr c, .advance_y
    jr nz, .retreat_y
    jr .loop
.retreat_y
    call MapControl_RetreatVerticalMapPosition
    jr .finish_y_step
.advance_y
    call MapControl_AdvanceVerticalMapPosition
.finish_y_step
    call MapControl_CompletePanStep
    jr .loop

.done
    call MapControl_CompletePanStep
    pop hl
    pop de
    pop bc
    ret

    assert @ == $7b43

; Return A = 0 when wMapActionTargetX/Y already equal B/C, else $FF.
MapControl_IsActionTargetAtCoordinates::
    ld a, [wMapActionTargetX]
    cp b
    jr nz, .not_equal
    ld a, [wMapActionTargetY]
    cp c
    jr nz, .not_equal
    xor a
    ret
.not_equal
    ld a, $ff
    ret

    assert @ == $7b54

; Advance frame/input processing until the pending map strip has completed,
; then apply the shared map-position and presentation refresh helpers.
MapControl_CompletePanStep::
    push bc
.wait_for_strip
    call Sprite_Update
    call Joypad_Update
    call Joypad_Update
    ldh a, [hMapTileUpdateFlags]
    bit 7, a
    jr nz, .wait_for_strip
    call MapTileUpdate_CommitCompletedScroll
    call MapCursor_UpdateAbsoluteCoordinates
    call MapCursor_UpdatePropertyEligibilityAppearance
    pop bc
    ret

    assert @ == $7b6f
