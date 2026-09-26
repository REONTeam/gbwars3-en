include "macros/macros.inc"
include "constants/unit_constants.inc"

; shared player/AI Unit Creation purchase resource application.
; Input A is the encoded UnitData selector. The caller must have already passed
; UnitCreation_CheckPurchaseAffordability; this routine applies both established
; UnitData purchase costs to the active side's current economy balances.
section "Bank $0B Unit Creation purchase resource application", romx[$5c68], bank[$0b]

UnitCreation_ApplyPurchaseResourceCosts::
    push bc
    push de
    ld b, a

    ld a, b
    ld c, UNIT_DATA_GOLD_COST_OFFSET
    farcall UnitData_GetWord
    ld h, d
    ld l, e
    call Math_MultiplyHLBy100
    ld d, h
    ld e, l
    call MapEconomy_TrySubtractCurrentSideGold

    ld a, b
    ld c, UNIT_DATA_MATERIAL_COST_OFFSET
    farcall UnitData_GetWord
    call MapEconomy_SubtractCurrentSideMaterials

    pop de
    pop bc
    ret

    assert @ == $5c89
