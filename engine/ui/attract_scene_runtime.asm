include "macros/macros.inc"

; Contextual scratch aliases for the six-scene Bank $23 attract controller.
DEF wAttractSceneId EQU $c622
DEF wAttractSceneCurrentChar EQU $c021
DEF wAttractSceneLocalState EQU $c022
DEF wAttractSceneTextColumn EQU $c023
DEF wAttractSceneTextRow EQU $c024
DEF wAttractSceneScriptPointer EQU $c025 ; 2 bytes
DEF wAttractSceneCharacterDelay EQU $c027
DEF wAttractSceneCursorSpriteId EQU $c028
DEF wAttractTransitionBannerSpriteId EQU $c023
DEF wAttractTransitionMovingSpriteId EQU $c024
DEF wAttractTransitionMovingY EQU $c025

section "Attract Scene Controller", romx[$4000], bank[$23]
AttractScene_Run::
    cp $05
    jr c, $4006
    ld a, $05
    ld [$c622], a
    call $04f3
    call $34ce
    call $2d7c
    call $417e
    call $4043
    call $081d
    call $05a2
    call $3056
    call $4217
    and a
    jr nz, $401b
    call $07b4
    call $2e67
    ld a, [$c622]
    cp $04
    jr nz, $4039
    call $4773
    jr $403c
    call $48b1
    call $3815
    call $2e67
    ret
AttractScene_LoadPresentation::
    ld a, [$c622]
    sla a
    ld c, a
    ld b, $00
    ld hl, $4136
    add hl, bc
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld h, a
    ld a, b
    ld l, a
    ld a, [hli]
    ld [$cc61], a
    ld [$cc62], a
    ld a, [hli]
    ld d, a
    ld a, [hli]
    ld e, a
    push hl
    ld a, [$cc61]
    cp $24
    jr z, $4096
    cp $31
    jr z, $40c2
    push de
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $9000
    ld bc, $0800
    call $3b50
    pop de
    ld hl, $0800
    add hl, de
    ld a, h
    ld d, a
    ld a, l
    ld e, a
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $8800
    ld bc, $0800
    call $3b50
    jr $40ec
    push de
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $9000
    ld bc, $0800
    farcall BANK_24, Bank24_Entry_3B50
    pop de
    ld hl, $0800
    add hl, de
    ld a, h
    ld d, a
    ld a, l
    ld e, a
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $8800
    ld bc, $0800
    farcall BANK_24, Bank24_Entry_3B50
    jr $40ec
    push de
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $9000
    ld bc, $0800
    farcall BANK_31, Bank31_Entry_3B50
    pop de
    ld hl, $0800
    add hl, de
    ld a, h
    ld d, a
    ld a, l
    ld e, a
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $8800
    ld bc, $0800
    farcall BANK_31, Bank31_Entry_3B50
    pop hl
    ld a, [hli]
    ld b, a
    ld a, [hli]
    ld c, a
    push hl
    ld a, b
    ld h, a
    ld a, c
    ld l, a
    ld a, [$cc61]
    ld c, a
    ld a, $03
    ld b, $05
    call $06d9
    call $06f2
    pop hl
    ld a, $00
    ld [$cc52], a
    ld [$cc53], a
    ld a, $14
    ld [$cc56], a
    ld a, $0a
    ld [$cc57], a
    ld a, [hli]
    ld [$cc58], a
    ld a, [hli]
    ld [$cc59], a
    ld a, [hli]
    ld [$cc5a], a
    ld a, [hli]
    ld [$cc5b], a
    ld a, $00
    ld [$cc5c], a
    push hl
    call $35fe
    pop hl
    ld a, [hl]
    call $3816
    ret
    assert @ == $4136

section "Attract Scene Descriptors", romx[$4136], bank[$23]
AttractSceneDescriptorPointers::
    db $42, $41, $4c, $41, $56, $41, $60, $41, $6a, $41, $74, $41
AttractSceneDescriptor_0::
    db $31, $4b, $da, $50, $ba, $4a, $4a, $4b, $12, $18
AttractSceneDescriptor_1::
    db $23, $51, $57, $5d, $d7, $4f, $c7, $50, $8f, $19
AttractSceneDescriptor_2::
    db $24, $41, $90, $4c, $40, $40, $00, $40, $c8, $1a
AttractSceneDescriptor_3::
    db $23, $5f, $a7, $6b, $c7, $5e, $17, $5e, $df, $1b
AttractSceneDescriptor_4::
    db $23, $6d, $97, $7a, $07, $6c, $07, $6c, $cf, $1c
AttractSceneDescriptor_5::
    db $24, $4e, $10, $56, $40, $4c, $80, $4d, $48, $17
    assert @ == $417e

section "Attract Scene Text Layer Setup", romx[$417e], bank[$23]
AttractScene_SetupTextLayer::
    farcall SharedGraphics_LoadMainFontBG
    ld hl, $7b97
    ld c, $23
    ld a, $00
    ld b, $01
    call $06d9
    call $06f2
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $000a
    ld de, $1408
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $000a
    ld de, $1408
    farcall Gfx_TilemapFill
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld c, $15
    ld a, $08
    ld b, $04
    ld hl, $7104
    call $06d9
    call $06f2
    ld de, $7024
    ld hl, $8000
    ld bc, $00b0
    farcall BANK_15, Bank15_Entry_3B50
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call $2de8
    ld [$c028], a
    ld bc, $589c
    ld a, [$c028]
    call $2eae
    ld a, [$c028]
    call $2f5f
    xor a
    ld [$c022], a
    ld [$c023], a
    ld [$c024], a
    ld a, [$c622]
    sla a
    ld c, a
    ld b, $00
    ld hl, $4316
    add hl, bc
    ld a, [hli]
    ld [$c025], a
    ld a, [hl]
    ld [$c026], a
    ld a, $01
    ld [$c027], a
    ret
    assert @ == $4217

section "Attract Scene Text Update", romx[$4217], bank[$23]
AttractScene_UpdateText::
    call $42be
    jr z, $4223
    ldh a, [$ff91]
    and $08
    jp nz, $42b7
    ldh a, [$ff90]
    and $01
    or a
    jr nz, $4233
    ld a, [$c027]
    dec a
    ld [$c027], a
    jr nz, $42b1
    ld a, $08
    ld [$c027], a
    ld a, [$c025]
    ld l, a
    ld a, [$c026]
    ld h, a
    ld a, [hli]
    ld b, a
    ld a, l
    ld [$c025], a
    ld a, h
    ld [$c026], a
    ld a, b
    cp $00
    jr z, $42b4
    cp $01
    jr z, $4275
    ld [$c021], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$c023]
    inc a
    ld [$c023], a
    ld b, a
    ld a, [$c024]
    add a, $0b
    ld c, a
    call $0ed4
    ld de, $c021
    call $0f63
    jr $42b1
    xor a
    ld [$c023], a
    ld a, [$c024]
    inc a
    ld [$c024], a
    cp $06
    jr c, $42b1
    ld a, [$c028]
    call $2f45
    call $42d5
    call $42be
    jr z, $4299
    ldh a, [$ff91]
    and $08
    jp nz, $42b7
    xor a
    ld [$c024], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $000a
    ld de, $1408
    farcall Gfx_TilemapFill
    ld a, $02
    ret
    ld a, $01
    ret
    call $42d5
    ld a, $02
    call $3844
    xor a
    ret
    assert @ == $42be

section "Attract Scene Script Pointers", romx[$4316], bank[$23]
AttractSceneScriptPointers::
    db $51, $46, $22, $43, $05, $44, $af, $44, $82, $45, $26, $47
    assert @ == $4322

section "Attract Scene Script 1", romx[$4322], bank[$23]
AttractSceneScript_1::
    db $ce, $dc, $b2, $c4, $d1, $2d, $dd, $7e, $8d, $67, $ae, $71, $9b, $79, $01, $7a
    db $91, $6c, $62, $6e, $8d, $74, $63, $7a, $2c, $73, $62, $6c, $6c, $70, $2e, $01
    db $6d, $9b, $76, $ce, $dc, $b2, $c4, $d1, $2d, $dd, $76, $7a, $01, $6a, $79, $70
    db $70, $66, $62, $60, $72, $9a, $69, $89, $71, $66, $87, $7a, $01, $79, $6a, $af
    db $73, $62, $75, $66, $af, $70, $2e, $01, $01, $6c, $66, $6c, $2c, $8c, $8a, $8c
    db $8a, $83, $01, $6a, $8a, $62, $94, $ae, $63, $79, $8f, $6e, $62, $76, $01, $70
    db $64, $87, $8a, $89, $7a, $95, $83, $75, $68, $01, $ce, $dc, $b2, $c4, $d1, $2d
    db $dd, $79, $01, $73, $62, $6e, $8d, $86, $63, $6e, $62, $60, $63, $69, $62, $8a
    db $01, $6e, $8d, $6f, $63, $7a, $6c, $ad, $63, $69, $72, $6c, $70, $2e, $01, $6f
    db $6c, $73, $6e, $66, $62, $76, $7a, $01, $7d, $62, $8c, $8e, $65, $74, $95, $8a
    db $70, $10, $10, $10, $01, $01, $01, $01, $6a, $79, $70, $70, $66, $62, $9b, $79
    db $7b, $ae, $63, $66, $7a, $2c, $01, $01, $1b, $6b, $68, $6e, $8d, $73, $67, $20
    db $6c, $ae, $63, $88, $1d, $98, $2e, $01, $01, $65, $82, $9b, $74, $63, $2e, $01
    db $67, $80, $7a, $85, $63, $6c, $ad, $63, $75, $01, $6c, $8a, $62, $66, $8d, $98
    db $21, $21, $00
    assert @ == $4405

section "Attract Scene Script 2", romx[$4405], bank[$23]
AttractSceneScript_2::
    db $8c, $8a, $8c, $8a, $8e, $01, $6e, $8d, $6f, $63, $60, $72, $9a, $69, $87, $8a
    db $89, $79, $83, $01, $6a, $6a, $7f, $9b, $98, $af, $70, $2e, $01, $01, $01, $01
    db $98, $8e, $6c, $66, $6c, $2c, $ce, $dc, $b2, $c4, $d1, $2d, $dd, $83, $01, $6f
    db $8a, $7a, $65, $75, $94, $98, $af, $70, $2e, $01, $6a, $63, $71, $ac, $68, $94
    db $ae, $63, $70, $62, $66, $87, $01, $67, $ad, $63, $6e, $8d, $7d, $74, $7a, $af
    db $73, $8d, $6c, $70, $2e, $01, $01, $01, $6f, $6c, $73, $6e, $66, $62, $76, $7a
    db $2c, $01, $62, $71, $65, $63, $79, $7d, $62, $8c, $8e, $65, $74, $95, $8a, $70
    db $2e, $01, $01, $01, $01, $6a, $79, $70, $70, $66, $62, $9b, $79, $7b, $ae, $63
    db $66, $7a, $2c, $01, $01, $1b, $6e, $8d, $94, $ad, $72, $73, $67, $20, $6c, $ae
    db $63, $88, $1d, $98, $2e, $01, $01, $67, $80, $7a, $7d, $62, $67, $8d, $73, $67
    db $75, $01, $6c, $8a, $62, $66, $8d, $98, $2e, $00
    assert @ == $44af

section "Attract Scene Script 3", romx[$44af], bank[$23]
AttractSceneScript_3::
    db $bd, $d8, $b8, $6b, $9d, $68, $9b, $79, $70, $70, $66, $62, $7a, $01, $cf, $d8
    db $de, $2d, $74, $63, $60, $65, $65, $67, $68, $63, $66, $62, $6c, $70, $01, $ce
    db $dc, $b2, $c4, $d1, $2d, $dd, $90, $8d, $76, $86, $af, $73, $01, $8c, $8e, $90
    db $8d, $7a, $98, $62, $6f, $8d, $8e, $62, $60, $63, $69, $70, $2e, $01, $69, $af
    db $67, $ae, $68, $2c, $6e, $8d, $6e, $8d, $60, $7e, $63, $67, $6c, $01, $6a, $63
    db $70, $62, $60, $65, $6a, $75, $af, $70, $2e, $01, $ce, $dc, $b2, $c4, $d1, $2d
    db $dd, $74, $da, $ff, $ec, $bd, $c0, $2d, $7a, $01, $6a, $63, $71, $ac, $68, $94
    db $ae, $63, $70, $62, $74, $75, $88, $01, $6f, $6c, $73, $2c, $75, $8d, $78, $8d
    db $83, $79, $61, $62, $98, $01, $6e, $8d, $6f, $63, $8e, $72, $9a, $62, $70, $10
    db $10, $10, $01, $01, $6a, $79, $70, $70, $66, $62, $9b, $79, $7b, $ae, $63, $66
    db $7a, $2c, $01, $01, $1b, $6b, $68, $6e, $8d, $73, $67, $20, $7a, $62, $a1, $68
    db $1d, $98, $2e, $01, $01, $67, $80, $76, $7a, $2c, $83, $63, $62, $71, $9c, $6b
    db $62, $6c, $ae, $66, $87, $01, $70, $70, $66, $62, $75, $65, $6c, $73, $7e, $6c
    db $62, $2e, $00
    assert @ == $4582

section "Attract Scene Script 4", romx[$4582], bank[$23]
AttractSceneScript_4::
    db $8c, $8a, $8c, $8a, $7a, $01, $1b, $bd, $b7, $d1, $6b, $9d, $68, $1d, $60, $74
    db $af, $a2, $9b, $67, $95, $76, $01, $6a, $63, $70, $62, $60, $65, $6a, $75, $af
    db $70, $2e, $01, $01, $01, $01, $6b, $87, $76, $2c, $01, $1b, $d7, $d0, $d8, $e5
    db $70, $62, $88, $68, $1d, $7d, $79, $01, $94, $ae, $63, $88, $68, $76, $6c, $af
    db $a2, $62, $6c, $70, $69, $af, $66, $01, $ce, $dc, $b2, $c4, $d1, $2d, $dd, $79
    db $98, $62, $7a, $8d, $91, $67, $8e, $01, $66, $62, $6c, $6b, $8a, $70, $2e, $01
    db $01, $6f, $6c, $73, $2c, $75, $8d, $78, $8d, $66, $8d, $83, $79, $61, $62, $98
    db $01, $7a, $91, $6c, $62, $70, $70, $66, $62, $8e, $72, $9a, $62, $70, $10, $10
    db $10, $01, $01, $01, $01, $6a, $79, $70, $70, $66, $62, $9b, $79, $7b, $ae, $63
    db $66, $7a, $01, $01, $1b, $6e, $8d, $88, $ac, $68, $73, $67, $20, $7a, $62, $a1
    db $68, $1d, $98, $2e, $01, $01, $67, $80, $7a, $6c, $8a, $62, $66, $8d, $74, $6c
    db $73, $7a, $6c, $af, $66, $68, $98, $2e, $01, $83, $63, $62, $71, $9c, $6b, $62
    db $6c, $ae, $66, $87, $01, $70, $70, $66, $62, $75, $65, $6e, $21, $21, $00
    assert @ == $4651

section "Attract Scene Script 0", romx[$4651], bank[$23]
AttractSceneScript_0::
    db $ce, $dc, $b2, $c4, $d1, $2d, $dd, $7a, $01, $6d, $a0, $73, $79, $6e, $8d, $74
    db $63, $60, $2c, $73, $62, $6c, $6c, $70, $2e, $01, $66, $68, $71, $76, $71, $87
    db $9d, $89, $ce, $dc, $b2, $c4, $d1, $2d, $dd, $90, $8d, $83, $01, $73, $62, $6a
    db $63, $60, $84, $82, $70, $2e, $01, $01, $01, $ce, $dc, $b2, $c4, $d1, $2d, $dd
    db $7a, $6a, $63, $7c, $68, $6c, $01, $72, $62, $76, $6e, $8d, $6f, $63, $7a, $2c
    db $6c, $ad, $63, $69, $72, $6c, $70, $2e, $01, $01, $6a, $79, $70, $70, $66, $62
    db $7a, $2c, $da, $ff, $ec, $bd, $c0, $2d, $79, $01, $96, $8d, $82, $8d, $73, $67
    db $6c, $ae, $63, $88, $76, $65, $8c, $af, $70, $2e, $01, $01, $6f, $6c, $73, $6e
    db $66, $62, $76, $7a, $01, $7d, $62, $8c, $8e, $65, $74, $95, $8a, $70, $10, $10
    db $10, $01, $01, $01, $01, $6a, $79, $70, $70, $66, $62, $9b, $79, $7b, $ae, $63
    db $66, $7a, $2c, $01, $01, $1b, $6e, $8d, $88, $ac, $68, $73, $67, $20, $6c, $ae
    db $63, $88, $1d, $98, $2e, $01, $01, $65, $82, $9b, $74, $63, $2e, $01, $67, $80
    db $7a, $70, $62, $7d, $8d, $85, $63, $6c, $ad, $63, $75, $01, $6c, $8a, $62, $66
    db $8d, $98, $21, $21, $00
    assert @ == $4726

section "Attract Scene Script 5", romx[$4726], bank[$23]
AttractSceneScript_5::
    db $6a, $8a, $76, $73, $6c, $66, $8d, $8e, $af, $6a, $63, $7a, $01, $6f, $72, $8f
    db $ae, $63, $74, $75, $89, $2e, $01, $62, $7f, $7f, $9b, $20, $7f, $75, $8d, $98
    db $6a, $74, $60, $01, $6b, $62, $98, $62, $91, $8d, $76, $20, $66, $72, $86, $63
    db $6c, $73, $01, $6a, $8d, $92, $60, $70, $70, $66, $62, $77, $62, $73, $7e, $6c
    db $62, $01, $69, $8d, $74, $63, $60, $20, $62, $79, $89, $21, $00
    assert @ == $4773

section "Attract Scene 4 Transition", romx[$4773], bank[$23]
AttractScene_RunSequence4Transition::
    call $04f3
    call $34ce
    call $2d7c
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0000
    ld de, $1412
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0000
    ld de, $1412
    farcall Gfx_TilemapFill
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $7a47
    ld hl, $9000
    ld bc, $0110
    farcall BANK_23, Bank23_Entry_3B50
    ld hl, $7b57
    ld c, $23
    ld a, $00
    ld b, $01
    call $06d9
    call $06f2
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld c, $22
    ld a, $08
    ld b, $08
    ld hl, $5dc1
    call $06d9
    call $06f2
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $5c61
    ld hl, $8000
    ld bc, $0160
    farcall BANK_22, Bank22_Entry_3B50
    ld a, $20
    ld c, $00
    ld b, $22
    ld de, $5c53
    call $2de8
    ld [$c023], a
    ld bc, $5850
    call $2eae
    ld a, [$c023]
    call $2f5f
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $5f32
    ld hl, $8160
    ld bc, $0700
    farcall BANK_1F, Bank1F_Entry_3B50
    ld a, $20
    ld c, $0b
    ld b, $1f
    ld de, $5ecb
    call $2de8
    ld [$c024], a
    ld bc, $c050
    call $2eae
    ld a, $c0
    ld [$c025], a
    call $081d
    call $05a2
    call $3056
    call $42be
    jr z, $4845
    ldh a, [$ff91]
    and $08
    jp nz, $4899
    ld a, [$c025]
    dec a
    ld [$c025], a
    cp $58
    jr c, $485b
    ld b, a
    ld c, $50
    ld a, [$c024]
    call $2eae
    jr $4833
    ld a, [$c024]
    call $2e1f
    ld a, [$c023]
    call $2f45
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $060a
    call $0ed4
    ld de, $5680
    ld bc, $0008
    farcall BANK_24, Bank24_Entry_3B59
    ld bc, $060b
    call $0ed4
    ld de, $5688
    ld bc, $0008
    farcall BANK_24, Bank24_Entry_3B59
    call $05a2
    call $3056
    ldh a, [$ff91]
    and $09
    jr z, $488d
    ld a, $02
    call $3844
    call $07b4
    call $2e67
    ret
AttractText_ShowPlayNextArea15::
    ld a, $07
    ld [$c622], a
    jr $48b1
    assert @ == $48ac
