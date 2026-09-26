include "macros/macros.inc"
include "constants/unit_constants.inc"

; Small Unit Reference value/name renderers immediately following the exported
; type strings. These are shared by the main detail panel and its subpages.

DEF wUnitReferenceCurrentType       EQU $d9ba
DEF wUnitReferenceWeaponSlot        EQU $d9bf
DEF wUnitReferenceTextBuffer        EQU $cd28

section "Unit Reference Detail Value Helpers", romx[$5e7b], bank[$25]

; Draw the MAX GAS label/value. BC is the label coordinate.
UnitReference_DrawMaxFuel::
    push bc
    ld hl, UnitStatus_String_Gas
    call TextPut
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_MAX_FUEL_OFFSET
    farcall UnitData_GetByte
    pop bc
    push af
    ld a, b
    add a, $0c
    ld b, a
    pop af
    ld d, $02
    call $31f5
    ret

    assert @ == $5e9a

; Draw the selected weapon name and its compact range/ammunition summary.
; wUnitReferenceWeaponSlot selects UnitData weapon 1 (0) or weapon 2 (nonzero).
UnitReference_DrawSelectedWeaponSummary::
    push bc
    ld a, [wUnitReferenceWeaponSlot]
    cp $00
    jr z, .weapon1
    jr .weapon2
.weapon1
    ld c, UNIT_DATA_WEAPON1_OFFSET
    jr .copy_name
.weapon2
    ld c, UNIT_DATA_WEAPON2_OFFSET
.copy_name
    ld a, [wUnitReferenceCurrentType]
    sla a
    farcall UnitWeapon_CopyNameToBuffer
    ld hl, wUnitReferenceTextBuffer
    farcall UnitList_EncodeDisplayValue
    ld hl, wUnitReferenceTextBuffer
    pop bc
    call TextPut

    ld a, [wUnitReferenceWeaponSlot]
    cp $00
    jr z, .draw_weapon1_values
    jr .draw_weapon2_values
.draw_weapon1_values
    ld bc, $0902
    call UnitReference_DrawWeapon1ValuePair
    ret
.draw_weapon2_values
    ld bc, $0902
    call UnitReference_DrawWeapon2ValuePair
    ret

    assert @ == $5ed8

; A = 0 for weapon 1, nonzero for weapon 2. BC = text coordinate.
UnitReference_DrawWeaponNameBySlot::
    push bc
    cp $00
    jr z, .weapon1
    jr .weapon2
.weapon1
    ld c, UNIT_DATA_WEAPON1_OFFSET
    jr .copy_name
.weapon2
    ld c, UNIT_DATA_WEAPON2_OFFSET
.copy_name
    ld a, [wUnitReferenceCurrentType]
    sla a
    farcall UnitWeapon_CopyNameToBuffer
    ld hl, wUnitReferenceTextBuffer
    farcall UnitList_EncodeDisplayValue
    ld hl, wUnitReferenceTextBuffer
    pop bc
    call TextPut
    ret

    assert @ == $5efd

UnitReference_DrawBaseFocus::
    push bc
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_BASE_FOCUS_OFFSET
    farcall UnitData_GetByte
    ld d, $02
    pop bc
    call $31f5
    ret

    assert @ == $5f10

UnitReference_DrawFocusLoss::
    push bc
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_FOCUS_LOSS_OFFSET
    farcall UnitData_GetByte
    ld d, $02
    pop bc
    call $31f5
    ret

    assert @ == $5f23

UnitReference_DrawMovementPower::
    push bc
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_MOVEMENT_POWER_OFFSET
    farcall UnitData_GetByte
    pop bc
    ld d, $02
    call $31f5
    ret

    assert @ == $5f36
