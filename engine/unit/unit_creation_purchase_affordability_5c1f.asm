include "macros/macros.inc"
include "constants/unit_constants.inc"

; shared Unit Creation / AI procurement affordability gate.
; Input A is the encoded unit/type-side selector. Return A is a compact status:
;   0 = affordable / slot available
;   1 = insufficient Gold
;   2 = insufficient Materials
;   3 = current side already has 50 live units
; The current-side Gold/Materials helpers are source-backed in the Bank $0B economy runtime.
section "Bank $0B Unit Creation purchase affordability", romx[$5c1f], bank[$0b]

UnitCreation_CheckPurchaseAffordability::
    push bc
    push de
    ld b, a

    ld a, [wMapPhaseNumber]
    and $01
    ld hl, wUnitCountBySide
    call AddAtoHL
    ld a, [hl]
    cp UNITS_PER_SIDE
    jr z, .unit_limit

    ld a, b
    ld c, UNIT_DATA_GOLD_COST_OFFSET
    farcall UnitData_GetWord
    ld h, d
    ld l, e
    call Math_MultiplyHLBy100
    ld d, h
    ld e, l
    call MapEconomy_CheckCurrentSideGoldAtLeastDE
    jr c, .insufficient_gold

    ld a, b
    ld c, UNIT_DATA_MATERIAL_COST_OFFSET
    farcall UnitData_GetWord
    push de
    call MapEconomy_GetCurrentSideMaterials
    ld d, h
    ld e, l
    pop hl
    call Math_CompareHLToDE
    jr c, .insufficient_materials

    xor a ; UNIT_CREATION_PURCHASE_OK
    jr .done

.insufficient_gold
    ld a, UNIT_CREATION_PURCHASE_NO_GOLD
    jr .done

.insufficient_materials
    ld a, UNIT_CREATION_PURCHASE_NO_MATERIAL
    jr .done

.unit_limit
    ld a, UNIT_CREATION_PURCHASE_UNIT_LIMIT

.done
    pop de
    pop bc
    ret

    assert @ == $5c68
