include "macros/macros.inc"
include "constants/unit_constants.inc"

; Beginner-mode scenario completion gate used by the post-action
; controller. The selected Beginner map index chooses one of a small set of
; local predicates through the 16-entry pointer table. A satisfied predicate
; returns 1; all non-Beginner modes and unsatisfied predicates return 0.
; $6E6E is an independently reached next entry and is not absorbed.

section "Map Control Beginner Completion Check", romx[$6dfc], bank[$0b]

MapControl_CheckBeginnerScenarioCompletion::
    push bc
    push de

    ld a, [wActiveGameMode]
    cp GAME_MODE_BEGINNER
    jr nz, .not_complete

    ld a, [$c883]
    ld hl, .condition_table
    call $3a8f
    jr nz, .not_complete

    ld a, 1
    jr .done

.not_complete
    xor a

.done
    pop de
    pop bc
    ret

.condition_table
    dw .test_c656_zero
    dw .test_side1_empty
    dw .test_side1_empty
    dw .test_c64c_equals_2
    dw .test_c656_zero
    dw .test_side1_empty
    dw .test_side0_materials_income_20
    dw .test_side1_empty
    dw .test_c656_zero
    dw .test_c656_zero
    dw .test_side1_materials_income_0
    dw .test_side1_empty
    dw .test_side1_empty
    dw .test_first_two_units_full_hp
    dw .test_first_two_units_full_hp
    dw .test_side1_empty

.test_c656_zero
    ld a, [wMapSide1HQTileCount]
    and a
    ret

.test_side1_empty
    ld a, [wUnitCountBySide + 1]
    and a
    ret

.test_c64c_equals_2
    ld a, [$c64c]
    cp 2
    ret

.test_side0_materials_income_20
    ld a, [wMapSide0MaterialsIncome]
    cp 20
    ret

.test_side1_materials_income_0
    ld a, [wMapSide1MaterialsIncome]
    cp 0
    ret

.test_first_two_units_full_hp
    ld a, [wUnitCountBySide + 1]
    and a
    ret nz

    xor a
    ld c, UNIT_RECORD_HP_OFFSET
    farcall $12, UnitRecord_GetByte
    cp 10
    ret nz

    ld a, 1
    ld c, UNIT_RECORD_HP_OFFSET
    farcall $12, UnitRecord_GetByte
    cp 10
    ret

    assert @ == $6e6e

; SHA-1 eab3fabfb666554c3f0c5a1011dda8c1f1611660 ($6DFC-$6E6D)
