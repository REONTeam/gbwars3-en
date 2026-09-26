include "macros/macros.inc"
include "constants/unit_constants.inc"

; Resolve a live-unit record's encoded type/side byte before entering the
; shared unit-graphic loader at $7675. The public entry preserves HL and
; intentionally falls through to the next independently callable entry.
section "Unit graphic loader from live record", romx[$766c], bank[$0b]

UnitGraphic_LoadFromRecordIndex::
    push hl
    ld d, a
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    pop hl

    assert @ == $7675
