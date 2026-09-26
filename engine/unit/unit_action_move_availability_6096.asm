include "macros/macros.inc"
include "constants/unit_constants.inc"

; MOVE availability appender.  closes action ID $12 as
; MOVE from the executor side; this helper is the matching availability side.

section "MOVE Action Availability", romx[$6096], bank[$0b]

; Append MOVE only while the staged unit's $CCE0 bit 7 is clear.  The exact
; meaning of the remaining $CCE0 bits is intentionally left structural.
UnitActionMenu_AppendMoveIfAvailable::
    ld a, [$cce0]
    bit 7, a
    ret nz
    ld a, UNIT_ACTION_MOVE
    call UnitActionMenu_AddEntry
    ret

    assert @ == $60a2
