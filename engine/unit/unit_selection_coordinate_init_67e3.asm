include "macros/macros.inc"

; initialize the coordinate-interaction scratch state used by MOVE.
; A is the selected/active unit index and B/C are the staged map coordinates.
; The helper snapshots the complete WRAM-bank-1 map cell at B/C and resets the
; local interaction-state byte.  The following $67FB entry is independently
; reused and remains a separate ownership boundary.

section "Bank $0B selected-unit coordinate interaction init", romx[$67e3], bank[$0b]

UnitSelection_InitializeCoordinateInteractionState::
    push hl
    ld [$c9e3], a
    ld a, b
    ld [$c9e1], a
    ld a, c
    ld [$c9e2], a
    call MapTile_ReadBank1AtCoordinates
    ld [$c9e4], a
    xor a
    ld [$c9e0], a
    pop hl
    ret

    assert @ == $67fb
