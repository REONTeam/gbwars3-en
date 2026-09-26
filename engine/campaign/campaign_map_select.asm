include "macros/macros.inc"

; Bank $25 Campaign map-selection controller. The $C61A-$C621 names below
; are lifetime-scoped aliases valid only while this selector is active.
section "Campaign Map Select Runtime A", romx[$44fd], bank[$25]
CampaignMapSelect_OpenViewOnly::
    push af
    xor a
    ld [$c61e], a
    pop af
    jr $450c
CampaignMapSelect_OpenSelectable::
    db $f5, $3e, $01, $ea, $1e, $c6, $f1
CampaignMapSelect_InitializeIndex::
    ld [$c621], a
    ld bc, $0000
    ld de, $0000
    cp $2d
    jr nc, $451f
    ld e, a
    ld c, $09
    call $2a21
    ld a, e
    ld [$c61a], a
    ld b, $00
    ld d, $00
    ld a, c
    ld e, a
    ld c, $03
    call $2a21
    ld a, e
    ld [$c620], a
    ld a, c
    ld [$c61f], a
CampaignMapSelect_Run::
    call $04f3
    call $34ce
    call $2d7c
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    call $0618
    call $0f02
    farcall SharedGraphics_LoadMainFontBG
    farcall UIWindowStack_Init
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $7024
    ld hl, $8000
    ld bc, $00c0
    farcall BANK_15, Bank15_Entry_3B50
    call $06f2
    ld bc, $010d
    ld de, $1204
    farcall UIWindow_DrawFrame
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $020e
    ld de, $1002
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $020e
    ld de, $1002
    farcall Gfx_TilemapFill
    ld bc, $020f
    call $0ed4
    ld hl, $48a0
    call $3353
    ld bc, $0000
    ld hl, $0000
    push bc
    push hl
    ld a, c
    ld hl, $c784
    call $29bc
    ld a, [hl]
    ld e, a
    ld d, $00
    pop hl
    pop bc
    add hl, de
    inc bc
    ld a, c
    cp $2d
    jr c, $45ac
    ld a, [$ca1f]
    inc a
    ld bc, $0e0f
    ld d, $04
    call $3258
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fde
    call $2de8
    ld bc, $1c4c
    call $2eae
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fa6
    call $2de8
    ld bc, $944c
    call $2eae
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fd0
    call $2de8
    ld [$c61d], a
    ld a, [$c61c]
    push af
    call $4702
    call $471e
    pop af
    ld [$c61c], a
    call $476e
    call $47bc
    call $081d
    call $05a2
    call $3056
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff91]
    bit 1, a
    jp nz, $46ce
    ld a, [$c61e]
    and a
    jr z, $4638
    ldh a, [$ff91]
    bit 0, a
    jp nz, $46d9
    ldh a, [$ff92]
    bit 5, a
    jr nz, $4673
    bit 4, a
    jr nz, $4692
    bit 6, a
    jr nz, $464c
    bit 7, a
    jr nz, $465a
    jr $4618
    ld a, [$c620]
    and a
    jr nz, $4654
    ld a, $03
    dec a
    ld [$c620], a
    jr $4666
    ld a, [$c620]
    inc a
    cp $03
    jr c, $4663
    xor a
    ld [$c620], a
    ld a, $01
    call $3844
    call $476e
    call $47bc
    jr $4618
    ld a, [$c61f]
    and a
    jr z, $467f
    dec a
    ld [$c61f], a
    jr $4666
    ld a, $02
    ld [$c61f], a
    ld a, [$c61a]
    and a
    jr nz, $468c
    ld a, $05
    dec a
    ld [$c61a], a
    jr $46b0
    ld a, [$c61f]
    inc a
    cp $03
    jr nc, $469f
    ld [$c61f], a
    jr $4666
    ld a, $00
    ld [$c61f], a
    ld a, [$c61a]
    inc a
    cp $05
    jr c, $46ad
    xor a
    ld [$c61a], a
    ld a, $01
    call $3844
    call $07b4
    call $471e
    xor a
    ld [$c61c], a
    call $476e
    call $3056
    call $47bc
    call $081d
    jp $4618
    ld a, $0c
    call $3844
    call $46f8
    ld a, $ff
    ret
    call $47a3
    farcall MapRecord_SelectCampaign
    ld a, [$ca1d]
    bit 0, a
    jr nz, $46f3
    bit 2, a
    jr nz, $46f3
    ld a, $03
    call $3844
    jp $4618
    ld a, $02
    call $3844
CampaignMapSelect_Close::
    call $07b4
    call $2e67
    call $47a3
    ret
CampaignMapSelect_LoadPalettes::
    ld c, $24
    ld a, $00
    ld b, $08
    ld hl, $5e60
    call $06d9
    ld c, $15
    ld a, $08
    ld b, $04
    ld hl, $7104
    call $06d9
    call $06f2
    ret
CampaignMapSelect_LoadPage::
    call $04f3
    call $4702
    ld a, [$c61a]
    sla a
    ld e, a
    ld d, $00
    ld hl, $4764
    add hl, de
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $9000
    ld bc, $07d0
    farcall BANK_24, Bank24_Entry_3B50
    ld a, $0a
    ld bc, $0600
    ld de, $0802
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0b
    ld bc, $0403
    ld de, $0c09
    ld h, $11
    farcall Gfx_DrawSequentialTileRectWithAttributes
    call $4819
    ret
CampaignMapSelect_PageGraphicsPointers:
    db $90, $56, $a0, $5e, $b0, $66, $c0, $6e, $d0, $76
    assert @ == $476e

section "Campaign Map Select Runtime B", romx[$476e], bank[$25]
CampaignMapSelect_PositionCursor::
    ld a, [$c61f]
    ld b, a
    ld a, [$c620]
    ld c, a
    ld a, [$c620]
    sla a
    add a, c
    add a, b
    sla a
    ld c, a
    ld b, $00
    ld hl, $4791
    add hl, bc
    ld a, [hli]
    ld c, a
    ld a, [hl]
    ld b, a
    ld a, [$c61d]
    call $2eae
    ret
CampaignMapSelect_CursorCoordinates:
    db $34, $38, $34, $58, $34, $78, $4c, $38, $4c, $58, $4c, $78, $64, $38, $64, $58
    db $64, $78
CampaignMapSelect_GetSelectedMapIndex::
    ld a, [$c61a]
    ld b, $09
    call $2995
    ld a, [$c61f]
    ld b, a
    ld a, [$c620]
    ld c, a
    ld a, [$c620]
    sla a
    add a, c
    add a, b
    add a, l
    ret
    assert @ == $47bc

section "Campaign Map Select Runtime C", romx[$4819], bank[$25]
CampaignMapSelect_DrawPageAvailability::
    xor a
    ld [$c61c], a
    ld a, [$c61a]
    ld b, $09
    call $2995
    ld a, l
    ld [$c61b], a
    ld a, [$c61b]
    farcall MapRecord_SelectCampaign
    ld a, [$ca1d]
    bit 0, a
    jr nz, $487b
    bit 2, a
    jr z, $485c
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$c61c]
    sla a
    ld c, a
    ld b, $00
    ld hl, $488e
    add hl, bc
    ld a, [hli]
    ld c, a
    ld a, [hl]
    ld b, a
    ld a, $0d
    ld de, $0403
    farcall Gfx_TilemapFill
    jr $487b
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$c61c]
    sla a
    ld c, a
    ld b, $00
    ld hl, $488e
    add hl, bc
    ld a, [hli]
    ld c, a
    ld a, [hl]
    ld b, a
    ld a, $09
    ld de, $0403
    farcall Gfx_TilemapFill
    ld a, [$c61b]
    inc a
    ld [$c61b], a
    ld a, [$c61c]
    inc a
    ld [$c61c], a
    cp $09
    jr c, $4829
    ret
CampaignMapSelect_CellCoordinates:
    db $03, $04, $03, $08, $03, $0c, $06, $04, $06, $08, $06, $0c, $09, $04, $09, $08
    db $09, $0c
    assert @ == $48a0
