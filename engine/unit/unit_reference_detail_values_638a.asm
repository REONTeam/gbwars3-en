include "macros/macros.inc"
include "constants/unit_constants.inc"

; Main Unit Reference detail-value renderer. This family fills the numerical
; and weapon fields on the detail page and synchronizes the previous/next unit
; navigation arrows. The adjacent two-byte retail record remains semantically neutral.

DEF wUnitReferenceCurrentType              EQU $d9ba
DEF wUnitReferenceWeapon1                  EQU $d9c1
DEF wUnitReferenceWeapon2                  EQU $d9c2
DEF wUnitReferenceWeapon1Value0            EQU $d9c3
DEF wUnitReferenceWeapon1Value1            EQU $d9c4
DEF wUnitReferenceWeapon2Value0            EQU $d9c5
DEF wUnitReferenceWeapon2Value1            EQU $d9c6
DEF wUnitReferenceLoadCapacity             EQU $d9c7
DEF wUnitReferencePromotedType             EQU $d9c8
DEF wUnitReferenceTextBuffer               EQU $cd28
DEF wUnitReferencePreviousUnitSpriteID     EQU $d97f
DEF wUnitReferenceNextUnitSpriteID         EQU $d97e

section "Unit Reference Detail Adjacent Data Record", romx[$6388], bank[$25]
UnitReference_DetailAdjacentDataRecord::
    db $63, $00
    assert @ == $638a

section "Unit Reference Detail Values", romx[$638a], bank[$25]

; BC = destination. Weapon-data fields 8 and 9 are shown as either a single
; equal value or as a separated pair when they differ.
UnitReference_DrawWeapon1ValuePair::
    push bc
    ld a, [wUnitReferenceWeapon1]
    ld c, $08
    farcall WeaponData_GetByte
    ld [wUnitReferenceWeapon1Value0], a
    ld a, [wUnitReferenceWeapon1]
    ld c, $09
    farcall WeaponData_GetByte
    ld [wUnitReferenceWeapon1Value1], a
    ld a, [wUnitReferenceWeapon1Value0]
    ld c, a
    ld a, [wUnitReferenceWeapon1Value1]
    cp c
    jr z, .equal

    ld hl, UnitReference_String_ValueSeparator
    pop bc
    push bc
    inc b
    call TextPut
    ld a, [wUnitReferenceWeapon1Value1]
    pop bc
    push bc
    inc b
    inc b
    ld d, $01
    call $31f5
    ld a, [wUnitReferenceWeapon1Value0]
    pop bc
    ld d, $01
    call $31f5
    ret

.equal
    ld a, [wUnitReferenceWeapon1Value0]
    pop bc
    push bc
    ld d, $01
    call $31f5
    pop bc
    inc b
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    push bc
    ld de, $0201
    xor a
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop bc
    ld de, $0201
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ret

    assert @ == $63ff

UnitReference_DrawWeapon2ValuePair::
    push bc
    ld a, [wUnitReferenceWeapon2]
    ld c, $08
    farcall WeaponData_GetByte
    ld [wUnitReferenceWeapon2Value0], a
    ld a, [wUnitReferenceWeapon2]
    ld c, $09
    farcall WeaponData_GetByte
    ld [wUnitReferenceWeapon2Value1], a
    ld a, [wUnitReferenceWeapon2Value0]
    ld c, a
    ld a, [wUnitReferenceWeapon2Value1]
    cp c
    jr z, .equal

    ld hl, UnitReference_String_ValueSeparator
    pop bc
    push bc
    inc b
    call TextPut
    ld a, [wUnitReferenceWeapon2Value1]
    pop bc
    push bc
    inc b
    inc b
    ld d, $01
    call $31f5
    ld a, [wUnitReferenceWeapon2Value0]
    pop bc
    ld d, $01
    call $31f5
    ret

.equal
    ld a, [wUnitReferenceWeapon2Value0]
    pop bc
    push bc
    ld d, $01
    call $31f5
    pop bc
    inc b
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    push bc
    ld de, $0201
    xor a
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop bc
    ld de, $0201
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ret

    assert @ == $6474

; Draw the weapon-1 ammo denominator after the shared slash string.
UnitReference_DrawWeapon1AmmoValue::
    push bc
    ld hl, UnitReference_String_Slash
    call TextPut
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_WEAPON1_AMMO_OFFSET
    farcall UnitData_GetByte
    pop bc
    inc b
    inc b
    ld d, $01
    call $31f5
    ret

    assert @ == $648f

UnitReference_DrawWeapon1Details::
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_WEAPON1_OFFSET
    farcall UnitData_GetByte
    ld [wUnitReferenceWeapon1], a
    ld bc, $0b09
    call UnitReference_DrawWeapon1AmmoValue
    ld a, $08
    ld bc, $0f09
    ld de, $0101
    ld h, $f0
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $1009
    call UnitReference_DrawWeapon1ValuePair
    ret

    assert @ == $64b8

UnitReference_DrawWeapon2AmmoValue::
    push bc
    ld hl, UnitReference_String_Slash
    call TextPut
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_WEAPON2_AMMO_OFFSET
    farcall UnitData_GetByte
    pop bc
    inc b
    inc b
    ld d, $01
    call $31f5
    ret

    assert @ == $64d3

UnitReference_DrawWeapon2Details::
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_WEAPON2_OFFSET
    farcall UnitData_GetByte
    ld [wUnitReferenceWeapon2], a
    ld bc, $0b0a
    call UnitReference_DrawWeapon2AmmoValue
    ld a, $08
    ld bc, $0f0a
    ld de, $0101
    ld h, $f0
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $100a
    call UnitReference_DrawWeapon2ValuePair
    ret

    assert @ == $64fc

; Compact text/control resources embedded between the weapon helpers and the
; main value renderer. Keep the exact byte contracts explicit until stronger
; semantics for the $03 control byte are proven.
UnitReference_String_ValueSeparator::
    db $03, $00
UnitReference_String_Slash::
    db $2f, $00
UnitReference_String_DetailMarker::
    db $03, $03, $00

    assert @ == $6503

; Populate the data fields for wUnitReferenceCurrentType on the main detail
; page. This also caches weapon/load/promotion availability for submenu input.
UnitReference_DrawDetailValues::
    ld a, [wUnitReferenceCurrentType]
    ld bc, $0504
    call UnitReference_DrawUnitName
    ld bc, $0505
    call UnitReference_DrawUnitClassName
    ld bc, $1007
    call UnitReference_DrawMovementPower
    ld bc, $0408
    call UnitReference_DrawMaxFuel

    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_WEAPON1_OFFSET
    farcall UnitData_GetByte
    or a
    jr nz, .draw_weapon1_name

    ld bc, $0209
    ld hl, UnitStatus_String_None
    call TextPut
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0409
    ld de, $0f01
    xor a
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0409
    ld de, $0f01
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    jr .weapon1_done

.draw_weapon1_name
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_WEAPON1_OFFSET
    farcall UnitWeapon_CopyNameToBuffer
    ld hl, wUnitReferenceTextBuffer
    farcall UnitList_EncodeDisplayValue
    ld hl, wUnitReferenceTextBuffer
    ld bc, $0209
    call TextPut
.weapon1_done

    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_WEAPON2_OFFSET
    farcall UnitData_GetByte
    or a
    jr nz, .draw_weapon2_name

    ld bc, $020a
    ld hl, UnitStatus_String_None
    call TextPut
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $040a
    ld de, $0f01
    xor a
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $040a
    ld de, $0f01
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    jr .weapon2_done

.draw_weapon2_name
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_WEAPON2_OFFSET
    farcall UnitWeapon_CopyNameToBuffer
    ld hl, wUnitReferenceTextBuffer
    farcall UnitList_EncodeDisplayValue
    ld hl, wUnitReferenceTextBuffer
    ld bc, $020a
    call TextPut
.weapon2_done

    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_WEAPON1_OFFSET
    farcall UnitData_GetByte
    ld [wUnitReferenceWeapon1], a
    or a
    jr z, .weapon1_stats_done
    call UnitReference_DrawWeapon1Details
.weapon1_stats_done

    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, UNIT_DATA_WEAPON2_OFFSET
    farcall UnitData_GetByte
    ld [wUnitReferenceWeapon2], a
    or a
    jr z, .weapon2_stats_done
    call UnitReference_DrawWeapon2Details
.weapon2_stats_done

    ld bc, $0c0c
    call UnitReference_DrawBaseFocus

    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, $0d
    farcall UnitData_GetByte
    ld [wUnitReferenceLoadCapacity], a
    or a
    jr z, .cannot_load

    ld hl, UnitStatus_String_LoadAvailableTail
    ld bc, $090d
    call TextPut
    ld a, $08
    ld bc, $0d0d
    ld de, $0101
    ld h, $ed
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, [wUnitReferenceLoadCapacity]
    ld bc, $0e0d
    ld d, $01
    call $31f5
    jr .load_done

.cannot_load
    ld hl, UnitStatus_String_Unavailable
    ld bc, $090d
    call TextPut
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0d0d
    ld de, $0601
    xor a
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0d0d
    ld de, $0601
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
.load_done

    ld a, [wUnitReferenceCurrentType]
    farcall UnitPromotion_GetPromotedType
    ld [wUnitReferencePromotedType], a
    or a
    jr z, .cannot_promote
    ld a, [wUnitReferencePromotedType]
    ld bc, $090e
    call UnitReference_DrawUnitName
    jr .promotion_done

.cannot_promote
    ld hl, UnitStatus_String_Unavailable
    ld bc, $090e
    call TextPut
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0d0e
    ld de, $0601
    xor a
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0d0e
    ld de, $0601
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
.promotion_done
    call UnitReference_UpdateDetailTypeArrowVisibility
    ret

    assert @ == $66bf

; Hide only the arrow that would move beyond the 1..$33 unit-type domain.
UnitReference_UpdateDetailTypeArrowVisibility::
    ld a, [wUnitReferenceCurrentType]
    cp $01
    jr z, .first_type
    cp $33
    jr z, .last_type
    jr .middle_type
    ret
.first_type
    call UnitReference_HidePreviousTypeArrow
    call UnitReference_ShowNextTypeArrow
    ret
.last_type
    call UnitReference_ShowPreviousTypeArrow
    call UnitReference_HideNextTypeArrow
    ret
.middle_type
    call UnitReference_ShowPreviousTypeArrow
    call UnitReference_ShowNextTypeArrow
    ret

UnitReference_HidePreviousTypeArrow::
    ld a, [wUnitReferencePreviousUnitSpriteID]
    call SpriteObject_Hide
    ret
UnitReference_ShowPreviousTypeArrow::
    ld a, [wUnitReferencePreviousUnitSpriteID]
    call SpriteObject_Show
    ret
UnitReference_HideNextTypeArrow::
    ld a, [wUnitReferenceNextUnitSpriteID]
    call SpriteObject_Hide
    ret
UnitReference_ShowNextTypeArrow::
    ld a, [wUnitReferenceNextUnitSpriteID]
    call SpriteObject_Show
    ret

    assert @ == $66fe
