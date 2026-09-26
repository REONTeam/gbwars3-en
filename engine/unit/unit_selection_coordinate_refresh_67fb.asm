include "macros/macros.inc"

; refresh the staged coordinate-interaction presentation.  The
; helper restores the saved B/C coordinate pair from $C9E1/$C9E2, reapplies
; the staged selected-unit/context byte from $C9E3 and saved map-cell byte
; from $C9E4 through the existing presentation helpers, then redraws the map.
; BC is preserved for callers.  The following $6815 entry is independently
; called and remains a separate ownership boundary.

section "Bank $0B selected-unit coordinate interaction refresh", romx[$67fb], bank[$0b]

UnitSelection_RefreshCoordinateInteractionState::
    push bc
    ld a, [$c9e1]
    ld b, a
    ld a, [$c9e2]
    ld c, a
    ld a, [$c9e3]
    call $4798
    ld a, [$c9e4]
    call $4740
    call $43d1
    pop bc
    ret

    assert @ == $6815
