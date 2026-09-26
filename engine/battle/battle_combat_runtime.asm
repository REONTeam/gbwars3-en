include "macros/macros.inc"
include "constants/unit_constants.inc"

; Two-weapon battle selectors operating on the staged summaries at
; wUnitWeaponSummary0/1. Input A is the encoded target unit type/side and B is
; the requested battle range. Output A is the chosen weapon ID (0 if none),
; D is the selected slot (0/1), and E is its target-class attack value.
section "Battle Weapon Selectors", romx[$40c1], bank[$0c]
Battle_SelectUsableWeaponAttack::
    push bc
    push hl
    ld d, a
    ld a, b
    ld [$c942], a
    ld e, $00
    ld a, [$ccf7]
    and a
    jr z, $40ee
    ld hl, $c942
    ld a, [$ccf9]
    cp [hl]
    jr c, $40ee
    ld a, [$ccf8]
    ld b, a
    ld a, [hl]
    cp b
    jr c, $40ee
    ld a, [$ccf6]
    ld b, a
    ld a, d
    farcall UnitWeapon_GetAttackValue
    and a
    jr z, $40ee
    ld e, a
    ld a, [$cd05]
    and a
    jr z, $4119
    ld hl, $c942
    ld a, [$cd07]
    cp [hl]
    jr c, $4119
    ld a, [$cd06]
    ld b, a
    ld a, [hl]
    cp b
    jr c, $4119
    ld a, [$cd04]
    ld b, a
    ld a, d
    farcall UnitWeapon_GetAttackValue
    and a
    jr z, $4119
    cp e
    jr c, $411f
    jr z, $411f
    ld e, a
    jr $4126
    ld d, $00
    ld a, e
    and a
    jr z, $412b
    ld d, $00
    ld a, [$ccf6]
    jr $412b
    ld d, $01
    ld a, [$cd04]
    pop hl
    pop bc
    ret
Battle_SelectWeaponAttackIgnoringAmmo::
    push bc
    push hl
    ld d, a
    ld a, b
    ld [$c942], a
    ld e, $00
    ld hl, $c942
    ld a, [$ccf9]
    cp [hl]
    jr c, $4155
    ld a, [$ccf8]
    ld b, a
    ld a, [hl]
    cp b
    jr c, $4155
    ld a, [$ccf6]
    ld b, a
    ld a, d
    farcall UnitWeapon_GetAttackValue
    and a
    jr z, $4155
    ld e, a
    ld hl, $c942
    ld a, [$cd07]
    cp [hl]
    jr c, $417a
    ld a, [$cd06]
    ld b, a
    ld a, [hl]
    cp b
    jr c, $417a
    ld a, [$cd04]
    ld b, a
    ld a, d
    farcall UnitWeapon_GetAttackValue
    and a
    jr z, $417a
    cp e
    jr c, $4180
    jr z, $4180
    ld e, a
    jr $4187
    ld d, $00
    ld a, e
    and a
    jr z, $418c
    ld d, $00
    ld a, [$ccf6]
    jr $418c
    ld d, $01
    ld a, [$cd04]
    pop hl
    pop bc
    ret
    assert @ == $418f

section "Battle Cover Lookup", romx[$4861], bank[$0c]
Battle_GetCoverValue::
    farcall Terrain_GetNameIndex
    ld hl, $486d
    call $29bc
    ld a, [hl]
    ret
Battle_CoverValueTable::
    db $00, $46, $1e, $14, $1e, $14, $0a, $14, $0a, $14, $14, $14, $0a, $00, $00, $14
    db $32, $28, $1e, $14, $00, $00, $0a
    assert @ == $4884

section "Battle Flank and Support", romx[$4884], bank[$0c]
Battle_CoverValueTable_End::
Battle_CalcFlankValue::
    push bc
    push de
    ld [$c943], a
    ld a, [$dbf6]
    cp $01
    jr nz, $4902
    xor a
    ld [$c944], a
    ld e, $00
    push bc
    call $28d9
    jr c, $48dd
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    farcall BANK_0B, Bank0B_Entry_15F8
    ld a, [hl]
    ld b, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, b
    and a
    jr z, $48dd
    and $01
    ld b, a
    ld a, [$c943]
    ld c, $00
    farcall UnitRecord_GetByte
    and $01
    cp b
    jr z, $48dd
    ld a, e
    add a, a
    ld hl, $4906
    call $29bc
    ld a, [hli]
    ld b, [hl]
    ld hl, $c944
    call $3ad1
    ld a, b
    call $3ad1
    ld a, e
    call $3ad1
    pop bc
    inc e
    ld a, e
    cp $06
    jr nz, $4896
    ld hl, $c944
    ld e, $00
    ld d, $00
    ld a, e
    call $3ac7
    jr z, $48f2
    inc d
    inc e
    ld a, e
    cp $06
    jr nz, $48eb
    ld a, d
    ld hl, $4912
    call $29bc
    ld a, [hl]
    jr $4903
    xor a
    pop de
    pop bc
    ret
Battle_FlankAdjacentDirectionPairs::
    ld bc, $0002
    inc bc
    nop
    inc b
    ld bc, $0205
    dec b
    inc bc
    inc b
Battle_FlankValueByCoveredDirections::
    nop
    nop
    nop
    nop
    add hl, de
    inc hl
    ld [hld], a
Battle_CalcSupportValue::
    push bc
    push de
    ld [$c941], a
    ld a, d
    ld [$c943], a
    xor a
    ld [$c944], a
    ld a, [$dbf6]
    cp $01
    jr nz, $498b
    ld e, $00
    push bc
    call $28d9
    jr c, $4982
    farcall UnitRecord_FindPrimaryAtCoordinates
    cp $ff
    jr z, $4982
    ld b, a
    ld a, [$c943]
    cp b
    jr z, $4982
    ld a, b
    ld c, $00
    farcall UnitRecord_GetByte
    and $01
    push af
    ld a, [$c943]
    ld c, $00
    farcall UnitRecord_GetByte
    and $01
    ld c, a
    pop af
    cp c
    jr nz, $4982
    ld a, b
    farcall UnitWeapon_BuildSummary
    push de
    ld a, [$c941]
    ld c, $00
    farcall UnitRecord_GetByte
    ld b, $01
    call $40c1
    ld a, e
    srl a
    srl a
    srl a
    ld e, a
    ld a, [$c944]
    add a, e
    ld [$c944], a
    pop de
    pop bc
    inc e
    ld a, e
    cp $06
    jr nz, $492f
    jr $498b
    ld a, [$c944]
    pop de
    pop bc
    ret
    assert @ == $4991

section "Battle Rank Value Lookup", romx[$4991], bank[$0c]
Battle_GetRankMultiplier::
    farcall UnitRecord_GetExperienceRank
    ld hl, $499d
    call $29bc
    ld a, [hl]
    ret
Battle_RankMultiplierTable::
    db $00, $0a, $14, $1e, $28
Battle_RankMultiplierTable_End::
Battle_CalcAttackMultiplier::
    push bc
    push de
    ld hl, $0064
    call $29bc
    ld a, b
    call $29bc
    ld e, c
    ld d, $00
    call $29c3
    ld d, h
    ld e, l
    ld bc, $0064
    call $2a21
    push de
    ld d, c
    ld e, $00
    ld bc, $0064
    call $2a21
    ld l, e
    pop de
    ld h, e
    pop de
    pop bc
    ret
Battle_CalcDefenseMultiplier::
    push bc
    push de
    srl a
    srl b
    srl c
    ld hl, $0064
    call $29bc
    ld a, b
    call $29bc
    ld e, c
    ld d, $00
    call $29c3
    ld d, h
    ld e, l
    ld bc, $0064
    call $2a21
    push de
    ld d, c
    ld e, $00
    ld bc, $0064
    call $2a21
    ld l, e
    pop de
    ld h, e
    pop de
    pop bc
    ret
Battle_CalcStatHPScaled::
    push bc
    push de
    call $2995
    ld b, e
    push hl
    ld e, d
    ld d, $00
    push bc
    call $29d8
    pop bc
    ld d, h
    ld e, l
    pop hl
    ld c, l
    ld a, h
    call $2995
    add hl, de
    push hl
    ld a, c
    call $2995
    ld a, h
    pop hl
    call $29bc
    pop de
    pop bc
    ret
Battle_CalcDoubleStatHPScaled::
    rlca
    call $49fc
    ret
    assert @ == $4a26

section "Battle HP Result and Focus Order", romx[$4a26], bank[$0c]
Battle_CalcAttackerNewHP::
    ld a, [$dbd7]
    ld b, a
    ld a, [$dbd8]
    ld c, a
    ld a, [$dbd9]
    call $49a2
    ld d, h
    ld e, l
    ld a, [$dbd4]
    ld b, a
    ld a, [$dbd3]
    call $49fc
    ld a, l
    ld [$dbda], a
    ld a, h
    ld [$dbdb], a
    push hl
    ld hl, $0064
    ld a, [$dbec]
    ld b, a
    ld a, [$dbed]
    ld c, a
    ld a, [$dbeb]
    call $49cc
    ld d, h
    ld e, l
    ld a, [$dbea]
    ld b, a
    ld a, [$dbe8]
    call $4a21
    ld a, l
    ld [$dbf1], a
    ld a, h
    ld [$dbf2], a
    pop de
    call $29c3
    jr c, $4a96
    ld d, h
    ld e, l
    ld a, [$dbea]
    rlca
    ld c, a
    ld b, $00
    call $2a21
    ld a, b
    or c
    jr z, $4a85
    inc de
    ld a, d
    and a
    jr nz, $4a91
    ld a, [$dbe8]
    ld d, a
    ld a, e
    cp d
    jr c, $4a97
    ld a, [$dbe8]
    jr $4a97
    xor a
    ret
Battle_CalcDefenderNewHP::
    ld a, [$dbec]
    ld b, a
    ld a, [$dbed]
    ld c, a
    ld a, [$dbee]
    call $49a2
    ld d, h
    ld e, l
    ld a, [$dbe9]
    ld b, a
    ld a, [$dbe8]
    call $49fc
    ld a, l
    ld [$dbef], a
    ld a, h
    ld [$dbf0], a
    push hl
    ld hl, $0064
    ld a, [$dbd7]
    ld b, a
    ld a, [$dbd8]
    ld c, a
    ld a, [$dbd6]
    call $49cc
    ld d, h
    ld e, l
    ld a, [$dbd5]
    ld b, a
    ld a, [$dbd3]
    call $4a21
    ld a, l
    ld [$dbdc], a
    ld a, h
    ld [$dbdd], a
    pop de
    call $29c3
    jr c, $4b08
    ld d, h
    ld e, l
    ld a, [$dbd5]
    rlca
    ld c, a
    ld b, $00
    call $2a21
    ld a, b
    or c
    jr z, $4af7
    inc de
    ld a, d
    and a
    jr nz, $4b03
    ld a, [$dbd3]
    ld d, a
    ld a, e
    cp d
    jr c, $4b09
    ld a, [$dbd3]
    jr $4b09
    xor a
    ret
Battle_CalcNewHPByAttackOrder::
    ld a, [$dbcf]
    ld b, a
    ld a, [$dbe4]
    cp b
    jp z, $4b52
    jp nc, $4b35
Battle_FocusOrderAttackerHigher::
    call $4a26
    ld [$dbe8], a
    ld [$dbe1], a
    and a
    jr z, $4b66
    ld a, [$dbe4]
    and a
    jr z, $4b66
    call $4a98
    ld [$dbd3], a
    ld [$dbcc], a
    jr $4b66
Battle_FocusOrderDefenderHigher::
    call $4a98
    ld [$dbd3], a
    ld [$dbcc], a
    and a
    jr z, $4b66
    ld a, [$dbcf]
    and a
    jr z, $4b66
    call $4a26
    ld [$dbe8], a
    ld [$dbe1], a
    jr $4b66
Battle_FocusOrderTied::
    call $4a26
    push af
    call $4a98
    ld [$dbd3], a
    ld [$dbcc], a
    pop af
    ld [$dbe8], a
    ld [$dbe1], a
    ret
    assert @ == $4b67

section "Battle Ammo and Experience", romx[$4b67], bank[$0c]
Battle_ApplyAmmoAndParticipationExperience::
    push bc
    push de
    ld a, [$dbcf]
    ld b, a
    ld a, [$dbe4]
    cp b
    jr z, $4b9d
    jr nc, $4b89
    call $4bc0
    ld a, [$dbe1]
    and a
    jr z, $4ba3
    ld a, [$dbe4]
    and a
    jr z, $4ba3
    call $4bd5
    jr $4ba3
    call $4bd5
    ld a, [$dbcc]
    and a
    jr z, $4ba3
    ld a, [$dbcf]
    and a
    jr z, $4ba3
    call $4bc0
    jr $4ba3
    call $4bc0
    call $4bd5
    ld a, [$dbd3]
    ld b, a
    ld a, [$dbc8]
    ld c, $04
    farcall UnitRecord_SetByte
    ld a, [$dbe8]
    ld b, a
    ld a, [$dbc9]
    ld c, $04
    farcall UnitRecord_SetByte
    pop de
    pop bc
    ret
Battle_ApplyAttackerAmmoAndParticipationExperience::
    ld a, [$dbde]
    ld c, a
    ld a, [$dbc8]
    call $4bea
    ld a, [$dbc9]
    ld b, a
    ld a, [$dbc8]
    call $4bfc
    ret
Battle_ApplyDefenderAmmoAndParticipationExperience::
    ld a, [$dbf3]
    ld c, a
    ld a, [$dbc9]
    call $4bea
    ld a, [$dbc8]
    ld b, a
    ld a, [$dbc9]
    call $4bfc
    ret
Battle_ApplyAmmoUse::
    ld d, a
    ld a, c
    add a, $08
    ld c, a
    ld a, d
    farcall UnitRecord_GetByte
    dec a
    ld b, a
    ld a, d
    farcall UnitRecord_SetByte
    ret
Battle_ApplyParticipationExperience::
    ld c, a
    ld a, [$dbf6]
    cp $01
    jr nz, $4c16
    ld a, c
    ld hl, $0002
    farcall UnitRecord_AddExperienceClamped
    ld a, b
    ld hl, $0001
    farcall UnitRecord_AddExperienceClamped
    jr $4c26
    ld a, c
    ld hl, $0001
    farcall UnitRecord_AddExperienceClamped
    ld a, b
    ld hl, $0002
    farcall UnitRecord_AddExperienceClamped
    ret
Battle_ApplyDamageExperience::
    ld a, [$dbe1]
    ld b, a
    ld a, [$dbe0]
    sub b
    ld l, a
    ld h, $00
    ld a, [$dbe1]
    and a
    jr nz, $4c44
    inc hl
    ld a, [$dbe9]
    ld b, a
    ld a, [$dbd4]
    cp b
    jr nc, $4c44
    add hl, hl
    ld a, [$dbc8]
    farcall UnitRecord_AddExperienceClamped
    ld a, [$dbcc]
    ld b, a
    ld a, [$dbcb]
    sub b
    ld l, a
    ld h, $00
    ld a, [$dbcc]
    and a
    jr nz, $4c68
    inc hl
    ld a, [$dbd4]
    ld b, a
    ld a, [$dbe9]
    cp b
    jr nc, $4c68
    add hl, hl
    ld a, [$dbc9]
    farcall UnitRecord_AddExperienceClamped
    ret
    assert @ == $4c70

section "Battle Info Presentation Runtime", romx[$4c70], bank[$0c]
BattleInfo_ShowScreen::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    call $04f3
    farcall SharedGraphics_LoadMainFontBG
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    call $0618
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ld bc, $0000
    ld de, $1412
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld a, $03
    farcall MapPresentation_LoadThreeTileBlock
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$dbca]
    ld hl, $9000
    farcall UnitGraphic_LoadTiles
    ld a, [$dbdf]
    ld hl, $9040
    farcall UnitGraphic_LoadTiles
    ld b, $01
    ld c, $03
    ld a, [$dbca]
    ld d, a
    ld a, $00
    ld hl, $984b
    farcall UnitGraphic_DrawMetatile
    ld b, $01
    ld c, $03
    ld a, [$dbdf]
    ld d, a
    ld a, $04
    ld hl, $9850
    farcall UnitGraphic_DrawMetatile
    call $4d24
    ld hl, $4d9f
    ld c, $0a
    push hl
    ld a, [hli]
    ld h, [hl]
    ld l, a
    call $336e
    pop hl
    inc hl
    inc hl
    dec c
    jr nz, $4ce2
    call $3537
    ld bc, $0b06
    ld hl, $dbca
    call $4d5d
    call $3537
    ld bc, $1006
    ld hl, $dbdf
    call $4d5d
    call $3537
    call $081d
    call $05a2
    ldh a, [$ff91]
    and $0b
    jr z, $4d0d
    ld a, $0c
    call $3844
    call $07b4
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
BattleInfo_DrawAttackOrder::
    ld d, $01
    ld e, $01
    ld a, [$dbe4]
    ld b, a
    ld a, [$dbcf]
    cp b
    jr z, $4d42
    ld d, $02
    ld e, $03
    jr nc, $4d3c
    ld d, $03
    ld e, $02
    ld a, b
    and a
    jr nz, $4d42
    ld e, $00
    ld bc, $0a05
    ld a, d
    call $4d51
    ld bc, $0f05
    ld a, e
    call $4d51
    ret
BattleInfo_DrawOrderLabel::
    push de
    ld hl, $4e0a
    call $3a93
    call $3353
    pop de
    ret
BattleInfo_DrawParticipantStats::
    ld d, $03
    ld a, $0a
    call $29bc
    ld a, [hli]
    call $31f5
    inc c
    ld a, [hli]
    call $31f5
    inc c
    ld a, [hli]
    call $31f5
    inc c
    ld a, [hli]
    call $31f5
    inc c
    ld a, [hli]
    push af
    call $31f5
    pop af
    and a
    jr z, $4d86
    ld a, $2d
    call $34ed
    inc hl
    inc c
    inc c
    dec b
    push hl
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld d, $04
    call $3251
    pop hl
    inc c
    inc c
    inc hl
    inc hl
    ld a, [hli]
    ld h, [hl]
    ld l, a
    call $3251
    ret
    assert @ == $4d9f
