include "macros/macros.inc"

; MapMenu Runtime 47E3
; Executable bytes are expressed as LR35902 mnemonics and retain exact retail geometry.

section "MapMenu Runtime 47E3", romx[$47e3], bank[$13]
MapMenu_Runtime47E3::
    ld c, a
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    ld [$dc50], a
    call $4338
    ld a, $02
    call $3816
    call $081d
    call $05a2
    call $3056
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    bit 6, a
    jr z, $4825
    ld a, $01
    call $3844
    ld a, [$dc2b]
    sub $05
    jr c, $4823
    ld [$dc2b], a
    call $44a0
    call $4717
    jr $47fc
    bit 7, a
    jr z, $4842
    ld a, $01
    call $3844
    ld a, [$dc2b]
    add a, $05
    cp $0a
    jr nc, $4840
    ld [$dc2b], a
    call $44a0
    call $4717
    jr $47fc
    bit 5, a
    jr z, $4860
    ld a, $01
    call $3844
    ld a, [$dc2b]
    dec a
    cp $ff
    jr nz, $4855
    ld a, $09
    ld [$dc2b], a
    call $44a0
    call $4717
    jr $47fc
    bit 4, a
    jr z, $487e
    ld a, $01
    call $3844
    ld a, [$dc2b]
    inc a
    cp $0a
    jr nz, $4872
    xor a
    ld [$dc2b], a
    call $44a0
    call $4717
    jp $47fc
    bit 0, a
    jp z, $49d1
    ld a, [$dc4d]
    cp $00
    jp z, $49c2
    cp $01
    jp z, $499e
    cp $02
    jr z, $48b9
    cp $03
    jp z, $4975
    cp $04
    jp z, $493a
    cp $05
    jp z, $49b8
    cp $06
    jr z, $48d3
    cp $08
    jr z, $4902
    cp $09
    jp z, $495b
    cp $0a
    jr z, $491e
    cp $07
    jp z, $493a
    ld a, [$dc2b]
    call $51bd
    jp z, $49a6
    ld a, $02
    call $3844
    call $51ca
    call $51ac
    call $4717
    jp $49de
    ld a, $02
    call $3844
    ld a, [$dc2b]
    call $51bd
    jr z, $48ec
    ld a, $01
    call $5301
    cp $01
    jr nz, $48ec
    jp $49de
    call $44a0
    ld a, [$dc2b]
    ld [$cad1], a
    ld a, [$dc2c]
    farcall $15, SpriteTransition_SlideDownOffscreen
    ld a, [$dc2b]
    jp $49e1
    ld a, [$dc2b]
    call $4563
    jp nc, $49a6
    ld a, [$dc2b]
    ld [$cad1], a
    ld a, [$dc2c]
    farcall $15, SpriteTransition_SlideDownOffscreen
    ld a, [$dc2b]
    jp $49e1
    ld a, [$dc2b]
    call $4563
    jp c, $49a6
    ld a, [$dc2b]
    ld [$cad1], a
    ld a, [$dc2c]
    farcall $15, SpriteTransition_SlideDownOffscreen
    ld a, [$dc2b]
    jp $49e1
    ld a, [$dc2b]
    call $51bd
    jr z, $49a6
    ld a, [$dc2b]
    call $4046
    call $40d0
    jp c, $49ad
    ld a, [$dc2c]
    farcall $15, SpriteTransition_SlideDownOffscreen
    ld a, [$dc2b]
    jp $49e1
    ld a, [$dc2b]
    call $4563
    jr c, $49a6
    ld a, [$dc2b]
    ld [$cad1], a
    ld a, [$dc2c]
    farcall $15, SpriteTransition_SlideDownOffscreen
    ld a, [$dc2b]
    jr $49e1
    ld a, [$dc2b]
    call $51bd
    jr z, $49a6
    ld a, [$dc2c]
    farcall $15, SpriteTransition_SlideDownOffscreen
    call $4581
    xor a
    call $5301
    cp $00
    jr nz, $4996
    ld a, [$dc2b]
    farcall $13, MapSRAM_ClearSlotPresent
    call $51ac
    call $4717
    jr $49de
    ld a, [$dc2b]
    call $51bd
    jr nz, $49c2
    ld a, $03
    call $3844
    jr $49de
    ld a, $03
    call $3844
    xor a
    call $4749
    jr $49de
    ld a, [$dc2b]
    call $51bd
    jr z, $49e1
    jr $49de
    ld a, [$dc2c]
    farcall $15, SpriteTransition_SlideDownOffscreen
    ld a, [$dc2b]
    jr $49e1
    jp $47fc
    bit 1, a
    jr z, $49de
    ld a, $0c
    call $3844
    ld a, $ff
    jr $49e1
    jp $47fc
    ld d, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    push de
    call $07b4
    call $2e67
    pop de
    ld a, d
    ret
    call $04f3
    call $34ce
    call $2d7c
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    farcall $10, UIWindowStack_Init
    farcall $01, SharedGraphics_LoadMainFontBG
    call $0618
    call $0f02
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    farcall $15, Gfx_LoadCommonScreenAssets
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $57cc
    ld hl, $9000
    ld bc, $0090
    call $3b50
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    ld b, $08
    ld hl, $585c
    call $06bc
    call $06af
    ld a, $07
    ld b, $01
    ld c, $19
    ld hl, $7924
    call $06d9
    call $06f2
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $05
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $06
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0101
    ld de, $1204
    farcall $22, UIWindow_DrawFrameAndClearInteriorAttributes

    assert @ == $4a75, "MapMenu Runtime 47E3 boundary moved"
