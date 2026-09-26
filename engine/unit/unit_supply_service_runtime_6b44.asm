include "macros/macros.inc"
include "constants/unit_constants.inc"

; SUPPLY action availability/execution and its servicing-cost helpers. The action
; can restore fuel/ammunition and repair HP from a compatible current-side
; property, from an adjacent supply-capable unit, or while an aircraft is
; carried. Gold/Materials costs are staged in a short-lived scratch window.
; Adjacent supplier use consumes one SUPPLIES-ammo charge and awards the supplier
; experience equal to the receiver's current HP before the refill.
DEF wUnitSupplySubjectIndex              EQU $c9cb
DEF wUnitSupplySubjectTypeSide           EQU $c9cc
DEF wUnitSupplyGoldCost                  EQU $c9cd ; 16-bit LE
DEF wUnitSupplyMaterialCost              EQU $c9cf
DEF wUnitSupplySkipAdjacentPresentation  EQU $c9d0

section "Unit Supply Service Runtime", romx[$6b44], bank[$0c]

UnitSupply_CheckAvailable::
    ; A = live-unit index. Return 0 when at least one SUPPLY service path can act.
    push bc
    push de
    push hl
    ld b, a
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall UnitRecord_GetByte
    bit UNIT_RECORD_STATUS_SUPPLIED_F, a
    jr nz, .unavailable
    ld a, b
    call UnitSupply_CheckTerrainResupplyAvailable
    and a
    jr z, .available
    ld a, b
    call UnitSupply_CheckTerrainRepairAvailable
    and a
    jr z, .available
    ld a, b
    call UnitSupply_CheckAdjacentOrCarriedAirResupplyAvailable
    and a
    jr z, .available
    ld a, b
    call UnitSupply_CheckCarriedAirRepairAvailable
    and a
    jr z, .available
.unavailable
    ld a, $01
    jr .done
.available
    xor a
.done
    pop hl
    pop de
    pop bc
    ret
UnitSupply_Execute::
    ; Execute SUPPLY for wMapAIActiveUnitIndex, present any adjacent-supplier
    ; animation/HP delta, then mark the receiver supplied for this turn.
    push bc
    push de
    ld a, [wMapAIActiveUnitIndex]
    ld c, UNIT_RECORD_HP_OFFSET
    farcall UnitRecord_GetByte
    ld b, a
    push bc
    ld a, [wMapAIActiveUnitIndex]
    call UnitSupply_ApplyTerrainServices
    ld a, [wMapAIActiveUnitIndex]
    call UnitSupply_ApplyAdjacentOrCarriedAirServices
    and a
    jr nz, .skip_adjacent_supply_presentation
    ld a, $02
    farcall UnitAction_PresentActionEffect
.skip_adjacent_supply_presentation
    ld a, [wMapAIActiveUnitIndex]
    ld c, UNIT_RECORD_HP_OFFSET
    farcall UnitRecord_GetByte
    pop bc
    sub b
    ld d, a
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, d
    farcall MapHPChange_PresentSignedDelta
    ld a, SFX_SUPPLY
    call Audio_PlaySFX
    ld a, $0b
    farcall MapControl_ResolutionSceneRefresh
    ld a, [wMapAIActiveUnitIndex]
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall UnitRecord_GetByte
    set UNIT_RECORD_STATUS_SUPPLIED_F, a
    ld b, a
    ld a, [wMapAIActiveUnitIndex]
    farcall UnitRecord_SetByte
    ld a, [wMapAIActiveUnitIndex]
    farcall UnitSelection_RefreshScratchOrCarrierMapPresentation
    pop de
    pop bc
    ret
UnitSupply_CheckTerrainResupplyAvailable::
    ; Non-reserve/non-carried unit on compatible current-side service terrain,
    ; with at least one refill need and enough Gold/Materials.
    push bc
    push de
    ld [wUnitSupplySubjectIndex], a
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall UnitRecord_GetByte
    and a
    jr z, .unavailable
    ld [wUnitSupplySubjectTypeSide], a
    ld a, [wUnitSupplySubjectIndex]
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall UnitRecord_GetByte
    bit UNIT_RECORD_STATUS_RESERVE_F, a
    jr nz, .unavailable
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr nz, .unavailable
    ld a, [wUnitSupplySubjectTypeSide]
    ld b, a
    ld a, [wUnitSupplySubjectIndex]
    farcall Unit_CanResupplyAtCurrentTerrain
    and a
    jr nz, .unavailable
    ld a, [wUnitSupplySubjectIndex]
    call UnitSupply_CheckRefillCostAffordable
    and a
    jr nz, .unavailable
    xor a
    jr .done
.unavailable
    ld a, $01
.done
    pop de
    pop bc
    ret
UnitSupply_CheckTerrainRepairAvailable::
    ; Non-reserve/non-carried unit on compatible current-side repair terrain.
    push bc
    push de
    ld [wUnitSupplySubjectIndex], a
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall UnitRecord_GetByte
    and a
    jr z, .unavailable
    ld [wUnitSupplySubjectTypeSide], a
    ld a, [wUnitSupplySubjectIndex]
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall UnitRecord_GetByte
    bit UNIT_RECORD_STATUS_RESERVE_F, a
    jr nz, .unavailable
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr nz, .unavailable
    ld a, [wUnitSupplySubjectTypeSide]
    ld b, a
    ld a, [wUnitSupplySubjectIndex]
    farcall Unit_CanRepairAtCurrentTerrain
    and a
    jr nz, .unavailable
    ld a, [wUnitSupplySubjectIndex]
    call UnitSupply_CheckRepairCostAffordable
    and a
    jr nz, .unavailable
    xor a
    jr .done
.unavailable
    ld a, $01
.done
    pop de
    pop bc
    ret
UnitSupply_CheckAdjacentOrCarriedAirResupplyAvailable::
    ; Grounded/non-carried units require an adjacent supply source. Carried
    ; aircraft use the paid service path directly.
    push bc
    push de
    ld [wUnitSupplySubjectIndex], a
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall UnitRecord_GetByte
    and a
    jr z, .unavailable
    ld [wUnitSupplySubjectTypeSide], a
    ld a, [wUnitSupplySubjectIndex]
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall UnitRecord_GetByte
    bit UNIT_RECORD_STATUS_RESERVE_F, a
    jr nz, .unavailable
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr nz, .carried_air
    ld a, [wUnitSupplySubjectIndex]
    call UnitSupply_CalculateRefillCosts
    ld a, d
    or e
    and a
    jr z, .unavailable
    xor a
    ld [wUnitSupplyGoldCost], a
    ld [wUnitSupplyGoldCost + 1], a
    ld [wUnitSupplyMaterialCost], a
    ld a, [wUnitSupplySubjectIndex]
    farcall Unit_BuildAdjacentSupplyList
    ld a, [wAdjacentSupplyUnitCount]
    and a
    jr z, .unavailable
    jr .available
.carried_air
    ld a, [wUnitSupplySubjectTypeSide]
    ld c, UNIT_DATA_TARGET_CLASS_OFFSET
    farcall UnitData_GetByte
    cp UNIT_TARGET_CLASS_AIR
    jr nz, .unavailable
    ld a, [wUnitSupplySubjectIndex]
    call UnitSupply_CheckRefillCostAffordable
    and a
    jr nz, .unavailable
.available
    xor a
    jr .done
.unavailable
    ld a, $01
.done
    pop de
    pop bc
    ret
UnitSupply_CheckCarriedAirRepairAvailable::
    ; Carried, non-reserve aircraft below 10 HP can use the paid repair path.
    push bc
    push de
    ld [wUnitSupplySubjectIndex], a
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall UnitRecord_GetByte
    bit UNIT_RECORD_STATUS_RESERVE_F, a
    jr nz, .unavailable
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr z, .unavailable
    ld a, [wUnitSupplySubjectIndex]
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall UnitRecord_GetByte
    ld [wUnitSupplySubjectTypeSide], a
    ld c, UNIT_DATA_TARGET_CLASS_OFFSET
    farcall UnitData_GetByte
    cp UNIT_TARGET_CLASS_AIR
    jr nz, .unavailable
    ld a, [wUnitSupplySubjectIndex]
    ld c, UNIT_RECORD_HP_OFFSET
    farcall UnitRecord_GetByte
    cp $0a
    jr z, .unavailable
    ld a, [wUnitSupplySubjectIndex]
    call UnitSupply_CheckRepairCostAffordable
    and a
    jr nz, .unavailable
    xor a
    jr .done
.unavailable
    ld a, $01
.done
    pop de
    pop bc
    ret
UnitSupply_CheckRefillCostAffordable::
    ; Stage refill Gold/Materials costs and return 0 when nonzero work is needed
    ; and the current side can afford both.
    push bc
    push de
    call UnitSupply_CalculateRefillCosts
    ld [wUnitSupplyMaterialCost], a
    ld a, e
    ld [wUnitSupplyGoldCost], a
    ld a, d
    ld [wUnitSupplyGoldCost + 1], a
    or e
    and a
    jr z, .unavailable
    farcall MapEconomy_CheckCurrentSideGoldAtLeastDE
    jr c, .unavailable
    farcall MapEconomy_GetCurrentSideMaterials
    ld d, h
    ld e, l
    ld h, $00
    ld a, [wUnitSupplyMaterialCost]
    ld l, a
    call Math_CompareHLToDE
    jr c, .unavailable
    xor a
    jr .done
.unavailable
    ld a, $01
.done
    pop de
    pop bc
    ret
UnitSupply_CalculateRefillCosts::
    ; A = live-unit index. Return DE = Gold cost, A = Materials cost. Gold cost
    ; combines missing ammo shot-costs plus missing fuel. MATERIAL ammo shortage
    ; is additionally returned as the Materials component.
    push bc
    push af
    farcall UnitWeapon_BuildSummary
    ld a, [wUnitWeaponSummary0CurrentAmmo]
    ld b, a
    ld a, [wUnitWeaponSummary0MaxAmmo]
    sub b
    ld b, a
    ld a, [wUnitWeaponSummary0WeaponID]
    ld c, WEAPON_DATA_COST_PER_SHOT_OFFSET
    farcall WeaponData_GetByte
    call MultiplyAByB
    push hl
    ld a, [wUnitWeaponSummary1CurrentAmmo]
    ld b, a
    ld a, [wUnitWeaponSummary1MaxAmmo]
    sub b
    ld b, a
    ld a, [wUnitWeaponSummary0WeaponID]
    ld c, WEAPON_DATA_COST_PER_SHOT_OFFSET
    farcall WeaponData_GetByte
    call MultiplyAByB
    pop de
    add hl, de
    pop af
    ld d, a
    ld c, UNIT_RECORD_FUEL_OFFSET
    farcall UnitRecord_GetByte
    ld b, a
    ld a, d
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall UnitRecord_GetByte
    ld c, UNIT_DATA_MAX_FUEL_OFFSET
    farcall UnitData_GetByte
    sub b
    ld e, a
    ld d, $00
    add hl, de
    push hl
    ld a, [wUnitWeaponSummary0WeaponID]
    cp WEAPON_MATERIAL
    jr nz, .no_material_ammo
    ld a, [wUnitWeaponSummary0CurrentAmmo]
    ld b, a
    ld a, [wUnitWeaponSummary0MaxAmmo]
    sub b
    ld b, a
    jr .return_costs
.no_material_ammo
    ld b, $00
.return_costs
    pop hl
    ld d, h
    ld e, l
    ld a, b
    pop bc
    ret
UnitSupply_CheckRepairCostAffordable::
    ; Stage repair Gold/Materials costs and return 0 when affordable.
    push bc
    push de
    call UnitSupply_CalculateRepairCosts
    ld [wUnitSupplyMaterialCost], a
    ld a, e
    ld [wUnitSupplyGoldCost], a
    ld a, d
    ld [wUnitSupplyGoldCost + 1], a
    or e
    and a
    jr z, .unavailable
    farcall MapEconomy_CheckCurrentSideGoldAtLeastDE
    jr c, .unavailable
    farcall MapEconomy_GetCurrentSideMaterials
    ld d, h
    ld e, l
    ld h, $00
    ld a, [wUnitSupplyMaterialCost]
    ld l, a
    call Math_CompareHLToDE
    jr c, .unavailable
    xor a
    jr .done
.unavailable
    ld a, $01
.done
    pop de
    pop bc
    ret
UnitSupply_CalculateRepairCosts::
    ; A = live-unit index. Return DE = Gold repair cost and A = Materials cost.
    ; Repair amount is clamped so displayed HP never exceeds the retail 10-HP cap.
    push bc
    ld d, a
    ld c, UNIT_RECORD_HP_OFFSET
    farcall UnitRecord_GetByte
    ld c, a
    ld a, d
    call UnitSupply_GetRepairHPAmount
    ld e, a
    ld a, c
    add a, e
    ld b, a
    ld a, $0a
    cp b
    jr nc, .repair_amount_clamped
    sub c
    ld e, a
.repair_amount_clamped
    push de
    push de
    ld a, d
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall UnitRecord_GetByte
    ld c, UNIT_DATA_GOLD_COST_OFFSET
    farcall UnitData_GetWord
    pop hl
    ld h, $00
    call Math_SignedMultiplyHLByDE
    ld de, $000a
    call Math_SignedMultiplyHLByDE
    pop de
    push hl
    push de
    ld a, d
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall UnitRecord_GetByte
    ld c, UNIT_DATA_MATERIAL_COST_OFFSET
    farcall UnitData_GetWord
    pop hl
    ld h, $00
    call Math_SignedMultiplyHLByDE
    ld d, h
    ld e, l
    ld bc, $000a
    call Math_DivideDEByBC
    ld a, e
    pop de
    pop bc
    ret
UnitSupply_GetRepairHPAmount::
    ; A = live-unit index. Carried units repair by 2 HP; otherwise the property
    ; state at the unit coordinates determines ceil(state / 10), i.e. 1..4 HP.
    push bc
    push de
    ld d, a
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall UnitRecord_GetByte
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr nz, .carried_unit
    ld a, d
    ld c, UNIT_RECORD_X_OFFSET
    farcall UnitRecord_GetWord
    ld b, e
    ld c, d
    farcall PropertyState_GetAtCoordinates
    dec a
    ld e, a
    ld d, $00
    ld bc, $000a
    call Math_DivideDEByBC
    ld a, e
    inc a
    jr .done
.carried_unit
    ld a, $02
.done
    pop de
    pop bc
    ret
UnitSupply_ApplyTerrainServices::
    ; Apply compatible current-property refill and repair services.
    push bc
    push de
    ld [wUnitSupplySubjectIndex], a
    call UnitSupply_CheckTerrainResupplyAvailable
    and a
    jr nz, .check_repair
    call UnitSupply_CommitStagedCosts
    ld a, [wUnitSupplySubjectIndex]
    farcall Unit_RefillFuelFromDefinition
    ld a, [wUnitSupplySubjectIndex]
    farcall Unit_RefillAmmoFromDefinition
    ld a, [wUnitSupplySubjectIndex]
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall UnitRecord_GetByte
    set UNIT_RECORD_STATUS_SUPPLIED_F, a
    ld b, a
    ld a, [wUnitSupplySubjectIndex]
    farcall UnitRecord_SetByte
.check_repair
    ld a, [wUnitSupplySubjectIndex]
    call UnitSupply_CheckTerrainRepairAvailable
    and a
    jr nz, .done
    call UnitSupply_CommitStagedCosts
    ld a, [wUnitSupplySubjectIndex]
    call UnitSupply_GetRepairHPAmount
    ld b, a
    ld a, [wUnitSupplySubjectIndex]
    farcall Unit_AddHPClampedToMax
    ld a, [wUnitSupplySubjectIndex]
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall UnitRecord_GetByte
    set UNIT_RECORD_STATUS_SUPPLIED_F, a
    ld b, a
    ld a, [wUnitSupplySubjectIndex]
    farcall UnitRecord_SetByte
.done
    pop de
    pop bc
    ret
UnitSupply_ApplyAdjacentOrCarriedAirServices::
    ; Apply adjacent-supplier or carried-aircraft refill, then carried-air repair.
    ; Return 0 only when an adjacent supplier was consumed and its presentation
    ; should be shown by UnitSupply_Execute.
    push bc
    push de
    ld [wUnitSupplySubjectIndex], a
    ld a, $01
    ld [wUnitSupplySkipAdjacentPresentation], a
    ld a, [wUnitSupplySubjectIndex]
    call UnitSupply_CheckAdjacentOrCarriedAirResupplyAvailable
    and a
    jr nz, .check_carried_air_repair
    ld a, [wUnitSupplyGoldCost]
    ld c, a
    ld a, [wUnitSupplyGoldCost + 1]
    or c
    and a
    jr nz, .pay_direct_costs
    xor a
    ld [wUnitSupplySkipAdjacentPresentation], a
    ld a, [wAdjacentSupplyUnitList]
    ld c, UNIT_RECORD_WEAPON1_AMMO_OFFSET
    farcall UnitRecord_GetByte
    dec a
    ld b, a
    ld a, [wAdjacentSupplyUnitList]
    farcall UnitRecord_SetByte
    ld a, [wUnitSupplySubjectIndex]
    ld c, UNIT_RECORD_HP_OFFSET
    farcall UnitRecord_GetByte
    ld l, a
    ld h, $00
    ld a, [wAdjacentSupplyUnitList]
    farcall UnitRecord_AddExperienceClamped
    jr .refill_receiver
.pay_direct_costs
    call UnitSupply_CommitStagedCosts
.refill_receiver
    ld a, [wUnitSupplySubjectIndex]
    farcall Unit_RefillFuelFromDefinition
    ld a, [wUnitSupplySubjectIndex]
    farcall Unit_RefillAmmoFromDefinition
    ld a, [wUnitSupplySubjectIndex]
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall UnitRecord_GetByte
    set UNIT_RECORD_STATUS_SUPPLIED_F, a
    ld b, a
    ld a, [wUnitSupplySubjectIndex]
    farcall UnitRecord_SetByte
.check_carried_air_repair
    ld a, [wUnitSupplySubjectIndex]
    call UnitSupply_CheckCarriedAirRepairAvailable
    and a
    jr nz, .done
    call UnitSupply_CommitStagedCosts
    ld a, [wUnitSupplySubjectIndex]
    call UnitSupply_GetRepairHPAmount
    ld b, a
    ld a, [wUnitSupplySubjectIndex]
    farcall Unit_AddHPClampedToMax
    ld a, [wUnitSupplySubjectIndex]
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall UnitRecord_GetByte
    set UNIT_RECORD_STATUS_SUPPLIED_F, a
    ld b, a
    ld a, [wUnitSupplySubjectIndex]
    farcall UnitRecord_SetByte
.done
    ld a, [wUnitSupplySkipAdjacentPresentation]
    pop de
    pop bc
    ret
UnitSupply_CommitStagedCosts::
    ; Commit the previously staged Gold and Materials costs.
    push de
    ld a, [wUnitSupplyGoldCost]
    ld e, a
    ld a, [wUnitSupplyGoldCost + 1]
    ld d, a
    farcall MapEconomy_TrySubtractCurrentSideGold
    ld a, [wUnitSupplyMaterialCost]
    ld e, a
    ld d, $00
    farcall MapEconomy_SubtractCurrentSideMaterials
    pop de
    ret

    assert @ == $6f70

; Retail SHA-1 for $6B44-$6F6F is verified by tools/verify_unit_supply_service_runtime.py.
