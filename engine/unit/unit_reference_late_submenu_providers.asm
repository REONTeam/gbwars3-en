include "macros/macros.inc"

; Caller-backed provider layer for the later Unit Reference detail subpages.
; Executable provider families are mnemonic where their contracts are clear.
; Existing custom-English strings remain separate owners in unit_status.asm.

DEF wUnitReferenceTypeList             EQU $d980
DEF wUnitReferenceListCandidateType    EQU $d9b2
DEF wUnitReferenceListItemCount        EQU $d9b3
DEF wUnitReferenceListRenderIndex      EQU $d9b4
DEF wUnitReferenceListScrollOffset     EQU $d9b6
DEF wUnitReferenceListTileX            EQU $d9b7
DEF wUnitReferenceListTileY            EQU $d9b8
DEF wUnitReferenceGraphicTypeScratch   EQU $d9b9
DEF wUnitReferenceCurrentType          EQU $d9ba
DEF wUnitReferenceWeaponSlot           EQU $d9bf
DEF wUnitReferenceSelectedWeapon       EQU $d9c0
DEF wUnitReferenceWeapon1              EQU $d9c1
DEF wUnitReferenceWeapon2              EQU $d9c2
DEF wUnitReferenceLoadCapacity         EQU $d9c7
DEF wUnitReferencePromotedType         EQU $d9c8
DEF wUnitReferenceSubmenuScrollOffset  EQU $da40
DEF wUnitReferenceSubmenuVisibleRows   EQU $da43

section "Unit Reference Weapon Provider", romx[$73c6], bank[$25]

UnitReference_DrawWeaponSubmenu::
    call UnitReference_SetupScreen
    ld a, [wUnitReferenceWeaponSlot]
    cp $00
    jr z, .weapon_1
    jr .weapon_2
.weapon_1
    ld a, [wUnitReferenceWeapon1]
    jr .selected
.weapon_2
    ld a, [wUnitReferenceWeapon2]
.selected
    ld [wUnitReferenceSelectedWeapon], a
    ld bc, $0101
    call UnitReference_DrawSelectedWeaponSummary
    ld hl, UnitStatus_Submenu_Weapon_Range
    call CoordTextPut
    ld a, $08
    ld bc, $0802
    ld de, $0101
    ld h, $f0
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld hl, UnitStatus_Submenu_Weapon_AttackPower
    call CoordTextPut

    ld bc, $0106
    ld hl, UnitStatus_Type_Unarmored
    call TextPut
    ld a, [wUnitReferenceSelectedWeapon]
    ld c, $0b
    farcall $12, WeaponData_GetByte
    cp $00
    jr nz, .value_0b
    ld bc, $0e06
    call UnitReference_DrawText6500
    jr .field_0a
.value_0b
    ld bc, $0e06
    ld d, $02
    call $31f5

.field_0a
    ld bc, $0107
    ld hl, UnitStatus_Type_Armored
    call TextPut
    ld a, [wUnitReferenceSelectedWeapon]
    ld c, $0a
    farcall $12, WeaponData_GetByte
    cp $00
    jr nz, .value_0a
    ld bc, $0e07
    call UnitReference_DrawText6500
    jr .field_0c
.value_0a
    ld bc, $0e07
    ld d, $02
    call $31f5

.field_0c
    ld bc, $0108
    ld hl, UnitStatus_Type_Air
    call TextPut
    ld a, [wUnitReferenceSelectedWeapon]
    ld c, $0c
    farcall $12, WeaponData_GetByte
    cp $00
    jr nz, .value_0c
    ld bc, $0e08
    call UnitReference_DrawText6500
    jr .field_0d
.value_0c
    ld bc, $0e08
    ld d, $02
    call $31f5

.field_0d
    ld bc, $0109
    ld hl, UnitStatus_Type_Sea
    call TextPut
    ld a, [wUnitReferenceSelectedWeapon]
    ld c, $0d
    farcall $12, WeaponData_GetByte
    cp $00
    jr nz, .value_0d
    ld bc, $0e09
    call UnitReference_DrawText6500
    jr .field_0e
.value_0d
    ld bc, $0e09
    ld d, $02
    call $31f5

.field_0e
    ld bc, $010a
    ld hl, UnitStatus_Type_Submarine
    call TextPut
    ld a, [wUnitReferenceSelectedWeapon]
    ld c, $0e
    farcall $12, WeaponData_GetByte
    cp $00
    jr nz, .value_0e
    ld bc, $0e0a
    call UnitReference_DrawText6500
    jr .draw_resupply
.value_0e
    ld bc, $0e0a
    ld d, $02
    call $31f5

.draw_resupply
    ld hl, UnitStatus_Submenu_Weapon
    ld bc, $010d
    call TextPut
    ld a, $08
    ld bc, $0a0d
    ld de, $0101
    ld h, $eb
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld hl, UnitReference_String_ValueSeparator
    ld bc, $0b0d
    call TextPut
    ld a, [wUnitReferenceSelectedWeapon]
    ld c, $0f
    farcall $12, WeaponData_GetByte
    ld bc, $0d0d
    ld d, $03
    call $31f5
    call VBlankFIFO_Process
    ret

    assert @ == $74f0

section "Unit Reference Initiative Provider", romx[$752d], bank[$25]

UnitReference_DrawInitiativeSubmenu::
    call UnitReference_SetupScreen
    ld a, $0d
    ld [wUnitReferenceSubmenuVisibleRows], a
    call UnitReference_DrawScreenFrame
    ld bc, $0004
    call UnitReference_DrawDividerRow
    ld a, [wUnitReferenceCurrentType]
    ld bc, $0101
    call UnitReference_DrawUnitName
    ld bc, $0102
    ld hl, UnitStatus_String_Load
    call TextPut
    ld bc, $0d02
    ld hl, UnitReference_String_Slash
    call TextPut
    ld bc, $0f02
    call UnitReference_DrawBaseFocus
    ld bc, $0103
    ld hl, UnitStatus_Submenu_Initiative
    call TextPut
    ld bc, $0f03
    call UnitReference_DrawFocusLoss
    ld a, $0c
    ld [wUnitReferenceSubmenuVisibleRows], a
    xor a
    ld [wUnitReferenceSubmenuScrollOffset], a
    ld hl, $7c93
    farcall $32, Description_CountLines
    ld a, [wUnitReferenceCurrentType]
    farcall $32, Description_DrawInitiativeExplanation
    call UnitReference_CreateScrollArrowsTop34
    call UnitReference_UpdateSubmenuScrollArrows
    ret

    assert @ == $758c

section "Unit Reference Load Provider", romx[$7625], bank[$25]

UnitReference_LoadProvider_7625::
    ld hl, wUnitReferenceTypeList
    ld bc, $0032
    ld a, $ff
    call Memset
    xor a
    ld [wUnitReferenceListItemCount], a
    ld a, $01
    ld [wUnitReferenceListCandidateType], a
    ld hl, wUnitReferenceTypeList
.loop
    push hl
    ld a, [wUnitReferenceListCandidateType]
    cp $34
    jr z, .done
    ld a, [wUnitReferenceListCandidateType]
    sla a
    ld b, a
    ld a, [wUnitReferenceCurrentType]
    sla a
    farcall $12, UnitData_CheckLoadingCompatibility
    jr z, .append
    jr .next
.append
    pop hl
    ld a, [wUnitReferenceListCandidateType]
    ld [hli], a
    ld a, [wUnitReferenceListItemCount]
    inc a
    ld [wUnitReferenceListItemCount], a
    push hl
.next
    ld a, [wUnitReferenceListCandidateType]
    inc a
    ld [wUnitReferenceListCandidateType], a
    pop hl
    jr .loop
.done
    pop hl
    ret

UnitReference_LoadProvider_7670::
    xor a
    ld [wUnitReferenceListRenderIndex], a
    ld a, $01
    ld [wUnitReferenceListTileX], a
    ld a, $05
    ld [wUnitReferenceListTileY], a
.loop
    ld a, [wUnitReferenceListRenderIndex]
    cp $06
    jr z, .done
    ld a, [wUnitReferenceListItemCount]
    ld c, a
    ld a, [wUnitReferenceListRenderIndex]
    cp c
    jr z, .done
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [wUnitReferenceListRenderIndex]
    ld b, $40
    call MultiplyAByB
    ld bc, $8800
    add hl, bc
    push hl
    ld a, [wUnitReferenceListRenderIndex]
    ld c, a
    ld a, [wUnitReferenceListScrollOffset]
    add a, c
    ld hl, wUnitReferenceTypeList
    call AddAtoHL
    ld a, [hl]
    sla a
    call UnitReference_AdjustIndexPlus1ForSide
    ld [wUnitReferenceGraphicTypeScratch], a
    pop hl
    farcall $0b, UnitGraphic_LoadTiles
    ld a, [wUnitReferenceListTileX]
    ld b, a
    ld a, [wUnitReferenceListTileY]
    ld c, a
    call Vram_TilemapCoord
    ld a, [wUnitReferenceGraphicTypeScratch]
    ld d, a
    ld a, [wUnitReferenceListRenderIndex]
    add a, a
    add a, a
    add a, $80
    ld b, $01
    ld c, $05
    farcall $0b, UnitGraphic_DrawMetatile
    ld a, [wUnitReferenceListTileX]
    add a, $03
    ld b, a
    ld a, [wUnitReferenceListTileY]
    inc a
    ld c, a
    ld a, [wUnitReferenceGraphicTypeScratch]
    srl a
    call UnitReference_DrawUnitName
    ld a, [wUnitReferenceListRenderIndex]
    inc a
    ld [wUnitReferenceListRenderIndex], a
    ld a, [wUnitReferenceListTileY]
    add a, $02
    ld [wUnitReferenceListTileY], a
    jp .loop
.done
    ret

UnitReference_LoadProvider_7702::
    ld a, [wUnitReferenceListScrollOffset]
    cp $00
    jr nz, .show_up
    call UnitReference_HideScrollUpArrow
    jr .down
.show_up
    call UnitReference_ShowScrollUpArrow
.down
    ld a, [wUnitReferenceListScrollOffset]
    inc a
    add a, $06
    ld c, a
    ld a, [wUnitReferenceListItemCount]
    cp c
    jr nc, .show_down
    call UnitReference_HideScrollDownArrow
    jr .done
.show_down
    call UnitReference_ShowScrollDownArrow
.done
    ret

UnitReference_DrawLoadSubmenu::
    call UnitReference_SetupScreen
    call UnitReference_CreateScrollArrowsTop2C
    ld a, $05
    farcall $0b, MapPresentation_LoadThreeTileBlock
    call Vram_ApplyPals
    ld a, [wUnitReferenceCurrentType]
    ld bc, $0101
    call UnitReference_DrawUnitName
    ld a, $08
    ld bc, $0c01
    ld de, $0101
    ld h, $ed
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, [wUnitReferenceLoadCapacity]
    ld bc, $0d01
    ld d, $01
    call $31f5
    ld a, [wUnitReferenceLoadCapacity]
    ld bc, $0102
    ld d, $01
    call $31f5
    ld hl, UnitStatus_Submenu_Load
    ld bc, $0202
    call TextPut
    ld hl, UnitStatus_Submenu_Load_UnitTypes
    ld bc, $0104
    call TextPut
    xor a
    ld [wUnitReferenceListScrollOffset], a
    call UnitReference_LoadProvider_7625
    call UnitReference_LoadProvider_7670
    call UnitReference_LoadProvider_7702
    ret

    assert @ == $7783

section "Unit Reference Promotion Provider", romx[$781c], bank[$25]

UnitReference_DrawPromotionSubmenu::
    call UnitReference_SetupScreen
    ld a, $05
    farcall $0b, MapPresentation_LoadThreeTileBlock
    call Vram_ApplyPals
    ld bc, $0101
    ld hl, UnitStatus_Submenu_Promotion
    call TextPut
    ld a, $08
    ld bc, $0401
    ld de, $0101
    ld h, $ec
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, [wUnitReferencePromotedType]
    ld bc, $0102
    call UnitReference_DrawUnitName
    ld bc, $0204
    ld a, [wUnitReferencePromotedType]
    call UnitReference_DrawUnitGraphic
    ld a, [wUnitReferencePromotedType]
    ld bc, $0504
    call UnitReference_DrawUnitName
    ld a, $0b
    ld [wUnitReferenceSubmenuVisibleRows], a
    xor a
    ld [wUnitReferenceSubmenuScrollOffset], a
    ld hl, $7d22
    farcall $32, Description_CountLines
    farcall $32, Description_DrawPromotionExplanation
    call UnitReference_CreateScrollArrowsTop2C
    call UnitReference_UpdateSubmenuScrollArrows
    ret

    assert @ == $7875

section "Unit Reference Defense Provider", romx[$7917], bank[$25]

UnitReference_DrawDefenseSubmenu::
    call UnitReference_SetupScreen
    ld a, [wUnitReferenceCurrentType]
    ld bc, $0101
    call UnitReference_DrawUnitName
    ld bc, $0104
    ld hl, UnitStatus_String_Resupply_Repair
    call TextPut

    ld bc, $0106
    ld hl, UnitStatus_Type_Unarmored
    call TextPut
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, $1f
    farcall $12, UnitData_GetByte
    cp $00
    jr nz, .value_1f
    ld bc, $0b06
    call UnitReference_DrawText6500
    jr .field_1e
.value_1f
    ld bc, $0b06
    ld d, $02
    call $31f5

.field_1e
    ld bc, $0107
    ld hl, UnitStatus_Type_Armored
    call TextPut
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, $1e
    farcall $12, UnitData_GetByte
    cp $00
    jr nz, .value_1e
    ld bc, $0b07
    call UnitReference_DrawText6500
    jr .field_20
.value_1e
    ld bc, $0b07
    ld d, $02
    call $31f5

.field_20
    ld bc, $0108
    ld hl, UnitStatus_Type_Air
    call TextPut
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, $20
    farcall $12, UnitData_GetByte
    cp $00
    jr nz, .value_20
    ld bc, $0b08
    call UnitReference_DrawText6500
    jr .field_21
.value_20
    ld bc, $0b08
    ld d, $02
    call $31f5

.field_21
    ld bc, $0109
    ld hl, UnitStatus_Type_Sea
    call TextPut
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, $21
    farcall $12, UnitData_GetByte
    cp $00
    jr nz, .value_21
    ld bc, $0b09
    call UnitReference_DrawText6500
    jr .field_22
.value_21
    ld bc, $0b09
    ld d, $02
    call $31f5

.field_22
    ld bc, $010a
    ld hl, UnitStatus_Type_Submarine
    call TextPut
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, $22
    farcall $12, UnitData_GetByte
    cp $00
    jr nz, .value_22
    ld bc, $0b0a
    call UnitReference_DrawText6500
    jr .finish
.value_22
    ld bc, $0b0a
    ld d, $02
    call $31f5
.finish
    call VBlankFIFO_Process
    ret

    assert @ == $79f8

section "Unit Reference Resupply Repair Provider", romx[$7a19], bank[$25]

UnitReference_ResupplyRepairProvider_7A19::
    ld hl, $d980
    ld bc, $0032
    xor a
    call $3b79
    ld a, $01
    ld [$d980], a
    ret
UnitReference_ResupplyRepair_7A29:
    ld [$d9b9], a
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d9b4]
    ld b, $40
    call $2995
    ld bc, $8800
    add hl, bc
    push hl
    ld a, [$d9b9]
    sla a
    pop hl
    call $6727
    farcall $0b, UnitGraphic_LoadTiles
    ld a, [$d9b7]
    ld b, a
    ld a, [$d9b8]
    ld c, a
    call $0ed4
    ld a, [$d9b9]
    sla a
    call $6727
    ld d, a
    ld a, [$d9b4]
    add a, a
    add a, a
    add a, $80
    ld b, $01
    ld c, $03
    farcall $0b, UnitGraphic_DrawMetatile
    ld a, [$d9b7]
    add a, $03
    ld b, a
    ld a, [$d9b8]
    add a, $01
    ld c, a
    ld a, [$d9b9]
    call $5e08
    ret
UnitReference_ResupplyRepair_7A82:
    ld [$d9b9], a
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d9b4]
    ld b, $40
    call $2995
    ld bc, $8800
    add hl, bc
    push hl
    ld a, [$d9b9]
    call $6746
    pop hl
    farcall $0b, MapMetatile_LoadTiles
    ld a, [$d9b7]
    ld b, a
    ld a, [$d9b8]
    ld c, a
    call $0ed4
    ld a, [$d9b9]
    call $6746
    ld d, a
    ld a, [$d9b4]
    add a, a
    add a, a
    add a, $80
    ld b, $01
    ld c, $03
    farcall $0b, MapMetatile_DrawTilemap
    ld a, [$d9b9]
    farcall $0b, Terrain_GetNameIndex
    farcall $0f, MapEditor_Arrange_CopyTerrainNameToBuffer
    ld hl, $c011
    farcall $18, UnitList_EncodeDisplayValue
    ld hl, $c011
    ld a, [$d9b7]
    add a, $03
    ld b, a
    ld a, [$d9b8]
    add a, $01
    ld c, a
    call $3353
    ret
    xor a
    ld [$d9b5], a
UnitReference_ResupplyRepair_7AED:
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d9b4]
    ld b, $40
    call $2995
    ld bc, $8800
    add hl, bc
    push hl
    ld a, [$d9b5]
    ld hl, $c949
    call $29bc
    ld a, [hl]
    cp $00
    jr z, UnitReference_ResupplyRepair_7B56
    ld [$d9b9], a
    sla a
    call $6727
    pop hl
    farcall $0b, UnitGraphic_LoadTiles
    ld a, [$d9b7]
    ld b, a
    ld a, [$d9b8]
    ld c, a
    call $0ed4
    ld a, [$d9b9]
    sla a
    call $6727
    ld d, a
    ld a, [$d9b4]
    add a, a
    add a, a
    add a, $80
    ld b, $01
    ld c, $03
    farcall $0b, UnitGraphic_DrawMetatile
    ld a, [$d9b5]
    inc a
    ld [$d9b5], a
    ld a, [$d9b4]
    inc a
    ld [$d9b4], a
    ld a, [$d9b8]
    add a, $02
    ld [$d9b8], a
    jr UnitReference_ResupplyRepair_7AED
UnitReference_ResupplyRepair_7B56:
    pop hl
    ret
    xor a
    ld [$d9b5], a
UnitReference_ResupplyRepair_7B5C:
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d9b4]
    ld b, $40
    call $2995
    ld bc, $8800
    add hl, bc
    push hl
    ld a, [$d9b5]
    ld hl, $c949
    call $29bc
    ld a, [hl]
    cp $00
    jr z, UnitReference_ResupplyRepair_7BC1
    ld [$d9b9], a
    call $6746
    pop hl
    farcall $0b, MapMetatile_LoadTiles
    ld a, [$d9b7]
    ld b, a
    ld a, [$d9b8]
    ld c, a
    call $0ed4
    ld a, [$d9b9]
    call $6746
    ld d, a
    ld a, [$d9b4]
    add a, a
    add a, a
    add a, $80
    ld b, $01
    ld c, $03
    farcall $0b, MapMetatile_DrawTilemap
    ld a, [$d9b5]
    inc a
    ld [$d9b5], a
    ld a, [$d9b4]
    inc a
    ld [$d9b4], a
    ld a, [$d9b8]
    add a, $02
    ld [$d9b8], a
    jr UnitReference_ResupplyRepair_7B5C
UnitReference_ResupplyRepair_7BC1:
    pop hl
    ret
UnitReference_ResupplyRepair_7BC3:
    ld a, [$da3c]
    ld b, a
    ld a, [$da3d]
    ld c, a
    push bc
    ld hl, $d9d8
    add hl, bc
    ld bc, $c949
    ld d, $00
UnitReference_ResupplyRepair_7BD5:
    ld a, [bc]
    cp $00
    jr z, UnitReference_ResupplyRepair_7BE7
    ld [hl], a
    inc hl
    inc bc
    inc d
    ld a, [$d9b3]
    inc a
    ld [$d9b3], a
    jr UnitReference_ResupplyRepair_7BD5
UnitReference_ResupplyRepair_7BE7:
    pop bc
    push de
    ld a, d
    cp $00
    jr z, UnitReference_ResupplyRepair_7BFB
    ld hl, $da0a
    add hl, bc
    ld a, [$da3e]
    ld b, $00
    ld c, d
    call $3b79
UnitReference_ResupplyRepair_7BFB:
    pop de
    ld a, [$da3c]
    ld h, a
    ld a, [$da3d]
    ld l, a
    ld a, d
    call $29bc
    ld a, h
    ld [$da3c], a
    ld a, l
    ld [$da3d], a
    ret
UnitReference_ResupplyRepairProvider_7C11::
    xor a
    ld [$d9b4], a
    ld a, $01
    ld [$d9b7], a
    ld a, $04
    ld [$d9b8], a
UnitReference_ResupplyRepair_7C1F:
    ld a, [$d9b4]
    cp $06
    jp z, UnitReference_ResupplyRepair_7DB3
    ld a, [$d9b3]
    ld c, a
    ld a, [$d9b4]
    cp c
    jp z, UnitReference_ResupplyRepair_7DB3
    ld a, [$d9b4]
    ld c, a
    ld a, [$d9b6]
    add a, c
    ld hl, $da0a
    call $29bc
    ld a, [hl]
    cp $fb
    jp z, UnitReference_ResupplyRepair_7D59
    cp $fc
    jp z, UnitReference_ResupplyRepair_7D7D
    cp $fe
    jr z, UnitReference_ResupplyRepair_7CAE
    cp $ff
    jp z, UnitReference_ResupplyRepair_7D04
    cp $fd
    jr z, UnitReference_ResupplyRepair_7C58
UnitReference_ResupplyRepair_7C58:
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d9b7]
    ld b, a
    ld a, [$d9b8]
    ld c, a
    ld de, $0202
    xor a
    farcall $15, Gfx_TilemapFill
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d9b7]
    ld b, a
    ld a, [$d9b8]
    ld c, a
    ld de, $0202
    xor a
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d9b7]
    ld b, a
    ld a, [$d9b8]
    ld c, a
    ld hl, $7f6b
    call $3353
    ld a, [$d9b7]
    add a, $03
    ld b, a
    ld a, [$d9b8]
    inc a
    ld c, a
    ld hl, $7f6b
    call $3353
    jp UnitReference_ResupplyRepair_7DA1
UnitReference_ResupplyRepair_7CAE:
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d9b7]
    ld b, a
    ld a, [$d9b8]
    ld c, a
    ld de, $0202
    xor a
    farcall $15, Gfx_TilemapFill
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d9b7]
    ld b, a
    ld a, [$d9b8]
    ld c, a
    ld de, $0202
    xor a
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d9b7]
    ld b, a
    ld a, [$d9b8]
    ld c, a
    ld hl, $7f4d
    call $3353
    ld a, [$d9b7]
    add a, $02
    ld b, a
    ld a, [$d9b8]
    inc a
    ld c, a
    ld hl, $7f6b
    call $3353
    jp UnitReference_ResupplyRepair_7DA1
UnitReference_ResupplyRepair_7D04:
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d9b7]
    ld b, a
    ld a, [$d9b8]
    ld c, a
    ld de, $0202
    xor a
    farcall $15, Gfx_TilemapFill
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d9b7]
    ld b, a
    ld a, [$d9b8]
    ld c, a
    ld de, $0202
    xor a
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d9b7]
    ld b, a
    ld a, [$d9b8]
    ld c, a
    ld hl, $7f5c
    call $3353
    ld a, [$d9b7]
    add a, $02
    ld b, a
    ld a, [$d9b8]
    inc a
    ld c, a
    ld hl, $7f6b
    call $3353
    jr UnitReference_ResupplyRepair_7DA1
UnitReference_ResupplyRepair_7D59:
    ld a, [$d9b4]
    ld c, a
    ld a, [$d9b6]
    add a, c
    ld hl, $d9d8
    call $29bc
    ld a, [hl]
    call UnitReference_ResupplyRepair_7A29
    ld a, [$d9b7]
    add a, $02
    ld b, a
    ld a, [$d9b8]
    ld c, a
    ld hl, $7f6b
    call $3353
    jr UnitReference_ResupplyRepair_7DA1
UnitReference_ResupplyRepair_7D7D:
    ld a, [$d9b4]
    ld c, a
    ld a, [$d9b6]
    add a, c
    ld hl, $d9d8
    call $29bc
    ld a, [hl]
    call UnitReference_ResupplyRepair_7A82
    ld a, [$d9b7]
    add a, $02
    ld b, a
    ld a, [$d9b8]
    ld c, a
    ld hl, $7f6b
    call $3353
    jr UnitReference_ResupplyRepair_7DA1
UnitReference_ResupplyRepair_7DA1:
    ld a, [$d9b4]
    inc a
    ld [$d9b4], a
    ld a, [$d9b8]
    add a, $02
    ld [$d9b8], a
    jp UnitReference_ResupplyRepair_7C1F
UnitReference_ResupplyRepair_7DB3:
    ret
UnitReference_ResupplyRepairProvider_7DB4::
    ld a, [$d9b6]
    cp $00
    jr nz, UnitReference_ResupplyRepair_7DC0
    call $612b
    jr UnitReference_ResupplyRepair_7DC3
UnitReference_ResupplyRepair_7DC0:
    call $611d
UnitReference_ResupplyRepair_7DC3:
    ld a, [$d9b6]
    inc a
    add a, $06
    ld c, a
    ld a, [$d9b3]
    cp c
    jr nc, UnitReference_ResupplyRepair_7DD5
    call $6132
    jr UnitReference_ResupplyRepair_7DD8
UnitReference_ResupplyRepair_7DD5:
    call $6124
UnitReference_ResupplyRepair_7DD8:
    ret
UnitReference_DrawResupplyRepairSubmenu::
    call $600e
    ld a, $07
    ld b, $01
    ld hl, $6c9a
    ld c, $15
    call $06d9
    ld a, $01
    ld b, $06
    ld hl, $5868
    ld c, $01
    call $06d9
    call $06f2
    ld a, $0f
    farcall $10, UIWindowStack_SetAttributes
    call $5fc0
    ld bc, $0003
    call $5fcb
    ld bc, $0003
    ld a, $0f
    ld de, $0101
    ld h, $ee
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $af
    ld bc, $1303
    ld b, $13
    ld de, $0101
    ld h, $ee
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0103
    call $0ed4
    ld a, $0f
    ld bc, $0012
    call $3b84
    ld a, [$d9ba]
    ld bc, $0101
    call $5e08
    ld a, $01
    ld [$d9b7], a
    ld a, $05
    ld [$d9b8], a
    ld hl, $d9d8
    ld bc, $0032
    xor a
    call $3b79
    ld hl, $da0a
    ld bc, $0032
    xor a
    call $3b79
    xor a
    ld [$d9b4], a
    ld [$d9b5], a
    xor a
    ld [$da3c], a
    ld [$da3d], a
    ld [$d9b6], a
    xor a
    ld [$d9b3], a
    ld a, [$da3c]
    ld b, a
    ld a, [$da3d]
    ld c, a
    push bc
    ld hl, $d9d8
    add hl, bc
    ld a, $fe
    ld [hl], a
    pop bc
    ld hl, $da0a
    add hl, bc
    ld a, $fe
    ld [hl], a
    ld a, [$d9b3]
    inc a
    ld [$d9b3], a
    ld a, [$da3c]
    ld h, a
    ld a, [$da3d]
    ld l, a
    inc hl
    ld a, h
    ld [$da3c], a
    ld a, l
    ld [$da3d], a
    ld a, [$d9ba]
    farcall $0c, MapAI_BuildResupplyProviderTypeList
    ld a, $fb
    ld [$da3e], a
    call UnitReference_ResupplyRepair_7BC3
    ld a, [$d9ba]
    farcall $0c, MapAI_BuildResupplyPropertyOffsets
    ld a, $fc
    ld [$da3e], a
    call UnitReference_ResupplyRepair_7BC3
    ld a, [$da3c]
    ld b, a
    ld a, [$da3d]
    ld c, a
    push bc
    ld hl, $d9d8
    add hl, bc
    ld a, $fd
    ld [hl], a
    ld a, [$d9b3]
    inc a
    ld [$d9b3], a
    pop bc
    ld hl, $da0a
    add hl, bc
    ld a, $fd
    ld [hl], a
    ld a, [$da3c]
    ld h, a
    ld a, [$da3d]
    ld l, a
    inc hl
    ld a, h
    ld [$da3c], a
    ld a, l
    ld [$da3d], a
    ld a, [$da3c]
    ld b, a
    ld a, [$da3d]
    ld c, a
    push bc
    ld hl, $d9d8
    add hl, bc
    ld a, $ff
    ld [hl], a
    ld a, [$d9b3]
    inc a
    ld [$d9b3], a
    pop bc
    ld hl, $da0a
    add hl, bc
    ld a, $ff
    ld [hl], a
    ld a, [$da3c]
    ld h, a
    ld a, [$da3d]
    ld l, a
    inc hl
    ld a, h
    ld [$da3c], a
    ld a, l
    ld [$da3d], a
    ld a, [$d9ba]
    farcall $0c, MapAI_BuildCompatibleCarrierTypeList
    ld a, $fb
    ld [$da3e], a
    call UnitReference_ResupplyRepair_7BC3
    ld a, [$d9ba]
    farcall $0c, MapAI_BuildRepairPropertyOffsets
    ld a, $fc
    ld [$da3e], a
    call UnitReference_ResupplyRepair_7BC3
    call UnitReference_ResupplyRepairProvider_7C11
    call $5f36
    call UnitReference_ResupplyRepairProvider_7DB4
    call $3537
    ret

    assert @ == $7f4d
