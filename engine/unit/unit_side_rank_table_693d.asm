include "macros/macros.inc"
include "constants/unit_constants.inc"

; build the 50-entry experience-rank table for the side containing
; wMapAIActiveUnitIndex. Side 0 uses live-unit indices 0-49 and side 1 uses
; 50-99; stored table offsets are always normalized back to 0-49.
;
; $C9E6 is reset to $FF before the table is rebuilt, but its exact consumer
; contract remains structural. Ownership stops at independently called $6977.

section "Bank $0B active-side experience-rank table", romx[$693d], bank[$0b]

UnitSelection_BuildActiveSideExperienceRankTable::
    push bc
    push de

    ld a, $ff
    ld [$c9e6], a

    ld d, UNITS_PER_SIDE
    ld e, 0
    ld a, [wMapAIActiveUnitIndex]
    cp UNITS_PER_SIDE
    jr c, .loop
    ld e, UNITS_PER_SIDE

.loop
    ld a, e
    farcall $12, UnitRecord_GetExperienceRank
    ld b, a

    ld a, e
    call UnitSelection_NormalizeActiveSideUnitIndex
    ld hl, wUnitSideExperienceRankTable
    call AddAtoHL
    ld [hl], b

    inc e
    dec d
    jr nz, .loop

    pop de
    pop bc
    ret

; A = live-unit index from the same side pool as wMapAIActiveUnitIndex.
; Returns A normalized to that side's local slot 0-49.
UnitSelection_NormalizeActiveSideUnitIndex::
    push af
    ld a, [wMapAIActiveUnitIndex]
    cp UNITS_PER_SIDE
    jr nc, .side_1
    pop af
    ret
.side_1
    pop af
    sub UNITS_PER_SIDE
    ret

    assert @ == $6977
