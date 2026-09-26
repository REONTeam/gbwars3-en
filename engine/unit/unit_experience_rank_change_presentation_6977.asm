include "macros/macros.inc"
include "constants/unit_constants.inc"

; compare current experience ranks with the earlier side snapshot
; and invoke the existing Bank-$0C coordinate presentation for changed ranks.
section "Bank $0B experience-rank change presentation", romx[$6977], bank[$0b]

UnitSelection_PresentExperienceRankChanges::
    ld d, UNITS_PER_SIDE
    ld e, 0
    ld a, [wMapAIActiveUnitIndex]
    cp UNITS_PER_SIDE
    jr c, .loop
    ld e, UNITS_PER_SIDE
.loop
    ld a, e
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    and a
    jr z, .next
    ld a, e
    farcall $12, UnitRecord_GetExperienceRank
    ld b, a
    ld a, e
    call UnitSelection_NormalizeActiveSideUnitIndex
    ld hl, wUnitSideExperienceRankTable
    call AddAtoHL
    ld a, b
    cp [hl]
    jr z, .next
    push de
    ld a, e
    ld c, UNIT_RECORD_X_OFFSET
    farcall $12, UnitRecord_GetWord
    ld b, e
    ld c, d
    pop de
    farcall $0c, UnitRank_PresentIncreaseAtCoordinates
.next
    inc e
    dec d
    jr nz, .loop

    ld a, [wUnitRankChangeTrackedIndex]
    cp $ff
    jr z, .done
    ld a, [wUnitRankChangeTrackedIndex]
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    and a
    jr z, .done
    ld a, [wUnitRankChangeTrackedIndex]
    farcall $12, UnitRecord_GetExperienceRank
    ld l, a
    ld a, [wUnitRankChangeTrackedRank]
    cp l
    jr z, .done
    ld a, [wUnitRankChangeTrackedIndex]
    ld c, UNIT_RECORD_X_OFFSET
    farcall $12, UnitRecord_GetWord
    ld b, e
    ld c, d
    farcall $0c, UnitRank_PresentIncreaseAtCoordinates
.done
    ret

    assert @ == $69e6
