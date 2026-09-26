include "macros/macros.inc"
include "constants/unit_constants.inc"

DEF wUnitCreationSelectionIndex             EQU $c940
DEF wUnitCreationSelectedEncodedTypeSide   EQU $c941
DEF wUnitCreationSelectedGoldCost          EQU $c942 ; little-endian word
DEF wUnitCreationSelectedMaterialCost      EQU $c944 ; little-endian word
DEF wUnitCreationSelectedWeaponMinRange    EQU $ccf8
DEF wUnitCreationSelectedWeaponMaxRange    EQU $ccf9
DEF wUnitCreationSelectedWeaponAmmo        EQU $ccfa

; Unit Creation / CALL selected-unit detail presentation.
; The selector stores an index into wBuyableUnitList. This renderer converts
; that raw UnitData type to the active side's encoded type/side byte, draws the
; unit graphic/name, then presents transport capacity, purchase costs,
; movement/fuel and both weapon summary rows.
;
; The translated menu labels remain owned by engine/unit/unit_creation.asm.
; $5A9C is the retail padding byte immediately after that owner. The range ends
; exactly before the independently source-backed purchase-affordability gate at
; $5C1F.
section "Bank $0B Unit Creation selected-unit details", romx[$5a9c], bank[$0b]

UnitCreation_DetailRuntimePadding:
    db $00 ; $5A9C

UnitCreation_DrawSelectedUnitDetails::
    push bc
    push de
    push hl

    ; Convert the selected raw UnitData type to the encoded type/side value.
    ld hl, wBuyableUnitList
    ld c, a
    ld b, $00
    add hl, bc
    ld a, [hl]
    rlca
    ld b, a
    ld a, [wMapPhaseNumber]
    and $01
    add a, b
    ld [wUnitCreationSelectedEncodedTypeSide], a

    call UnitCreation_DrawSelectedUnitGraphic

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ; Unit name.
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    farcall $12, UnitData_CopyNameToBuffer
    ld hl, wUnitNameBuffer
    ld bc, $0422
    call TextPut

    ; Clear the weapon/name row before drawing optional fields.
    ld hl, UnitCreation_DetailBlankTileRow
    ld bc, $0f22
    call TextPut

    ; Transport capacity, when non-zero.
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    ld c, UNIT_DATA_TRANSPORT_CAPACITY_OFFSET
    farcall $12, UnitData_GetByte
    and a
    jr z, .transport_done
    push af
    ld a, $b5
    ld bc, $0f22
    call Vram_DrawTileAtCoordinates
    pop af
    inc b
    add a, $81
    call Vram_DrawTileAtCoordinates
.transport_done

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ; Gold cost (stored by UnitData in units of 100G, displayed raw here using
    ; the existing five-digit UI convention).
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    ld c, UNIT_DATA_GOLD_COST_OFFSET
    farcall $12, UnitData_GetWord
    ld a, e
    ld [wUnitCreationSelectedGoldCost], a
    ld a, d
    ld [wUnitCreationSelectedGoldCost + 1], a
    ld h, d
    ld l, e
    ld bc, $0623
    ld d, $03
    call DrawNumber5Digits

    ; Material cost.
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    ld c, UNIT_DATA_MATERIAL_COST_OFFSET
    farcall $12, UnitData_GetWord
    ld a, e
    ld [wUnitCreationSelectedMaterialCost], a
    ld a, d
    ld [wUnitCreationSelectedMaterialCost + 1], a
    ld h, d
    ld l, e
    ld bc, $0e23
    ld d, $03
    call DrawNumber5Digits

    ; Movement power.
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    ld c, UNIT_DATA_MOVEMENT_POWER_OFFSET
    farcall $12, UnitData_GetByte
    ld bc, $0225
    ld d, $02
    call DrawNumber3Digits

    ; Maximum fuel.
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    ld c, UNIT_DATA_MAX_FUEL_OFFSET
    farcall $12, UnitData_GetByte
    ld bc, $0226
    ld d, $02
    call DrawNumber3Digits

    ; Weapon slot 1: name, maximum ammo and WeaponData min/max range.
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    ld c, UNIT_DATA_WEAPON1_OFFSET
    farcall $12, UnitWeapon_CopyNameToBuffer
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    ld c, UNIT_DATA_WEAPON1_AMMO_OFFSET
    farcall $12, UnitData_GetByte
    ld [wUnitCreationSelectedWeaponAmmo], a
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    ld c, UNIT_DATA_WEAPON1_OFFSET
    farcall $12, UnitData_GetByte
    ld b, a
    ld c, WEAPON_DATA_MIN_RANGE_OFFSET
    farcall $12, WeaponData_GetByte
    ld [wUnitCreationSelectedWeaponMinRange], a
    ld a, b
    ld c, WEAPON_DATA_MAX_RANGE_OFFSET
    farcall $12, WeaponData_GetByte
    ld [wUnitCreationSelectedWeaponMaxRange], a
    ld bc, $0525
    call UnitCreation_DrawResourceComparisonRow

    ; Weapon slot 2.
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    ld c, UNIT_DATA_WEAPON2_OFFSET
    farcall $12, UnitWeapon_CopyNameToBuffer
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    ld c, UNIT_DATA_WEAPON2_AMMO_OFFSET
    farcall $12, UnitData_GetByte
    ld [wUnitCreationSelectedWeaponAmmo], a
    ld a, [wUnitCreationSelectedEncodedTypeSide]
    ld c, UNIT_DATA_WEAPON2_OFFSET
    farcall $12, UnitData_GetByte
    ld b, a
    ld c, WEAPON_DATA_MIN_RANGE_OFFSET
    farcall $12, WeaponData_GetByte
    ld [wUnitCreationSelectedWeaponMinRange], a
    ld a, b
    ld c, WEAPON_DATA_MAX_RANGE_OFFSET
    farcall $12, WeaponData_GetByte
    ld [wUnitCreationSelectedWeaponMaxRange], a
    ld bc, $0526
    call UnitCreation_DrawResourceComparisonRow

    pop hl
    pop de
    pop bc
    ret

UnitCreation_DrawResourceComparisonRow:
    ; Draw the current weapon name followed by ammo and range metadata. An
    ; absent weapon is represented by the retail blank row at $5C17.
    ld hl, wUnitNameBuffer
    call TextPut
    ld a, b
    add a, $08
    ld b, a
    ld hl, UnitCreation_DetailBlankTileRow
    call TextPut
    ld a, [wUnitNameBuffer]
    cp $80
    jr z, .done

    ld a, $a7
    call Vram_DrawTileAtCoordinates
    inc b
    ld a, [wUnitCreationSelectedWeaponAmmo]
    add a, $81
    call Vram_DrawTileAtCoordinates
    inc b
    inc b
    ld a, $b3
    call Vram_DrawTileAtCoordinates
    inc b
    ld a, [wUnitCreationSelectedWeaponMinRange]
    add a, $81
    call Vram_DrawTileAtCoordinates
    inc b

    ld hl, UnitCreation_DetailBlankTileRow
    call TextPut
    ld a, [wUnitCreationSelectedWeaponMinRange]
    ld hl, wUnitCreationSelectedWeaponMaxRange
    cp [hl]
    jr z, .done
    ld a, $a7
    call Vram_DrawTileAtCoordinates
    inc b
    ld a, [wUnitCreationSelectedWeaponMaxRange]
    add a, $81
    call Vram_DrawTileAtCoordinates
.done
    ret

UnitCreation_DetailBlankTileRow:
    db $80, $80, $80, $80, $80, $80, $80, $00

    assert @ == $5c1f
