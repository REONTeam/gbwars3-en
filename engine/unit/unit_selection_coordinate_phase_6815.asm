include "macros/macros.inc"

; advance the MOVE coordinate-interaction phase counter.  The
; $67E3 initializer clears $C9E0.  This helper increments it once per MOVE
; controller tick: at phase $0F it runs the shared coordinate presentation
; helper at $6869 for the staged $C9E1/$C9E2 coordinates; at phase $1E it
; clears the counter and refreshes the saved coordinate-interaction state.
; $683B is independently reused and remains the next source boundary.

section "Bank $0B selected-unit coordinate interaction phase", romx[$6815], bank[$0b]

UnitSelection_AdvanceCoordinateInteractionPhase::
    ld a, [$c9e0]
    inc a
    ld [$c9e0], a
    cp $0f
    jr z, .run_midpoint_presentation
    cp $1e
    jr nz, .done
    xor a
    ld [$c9e0], a
    call UnitSelection_RefreshCoordinateInteractionState
    jr .done

.run_midpoint_presentation
    ld a, [$c9e1]
    ld b, a
    ld a, [$c9e2]
    ld c, a
    call UnitSelection_ClearCoordinateMapPresentation
    jr .done

.done
    ret

    assert @ == $683b
