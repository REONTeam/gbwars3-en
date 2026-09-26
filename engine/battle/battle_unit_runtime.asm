include "macros/macros.inc"
include "constants/unit_constants.inc"
include "constants/battle_helicopter_hp_constants.inc"
include "constants/battle_scene_resource_constants.inc"

; Bank $16 battle-unit presentation/state runtime. Executable regions are mnemonic;
; the isolated $47DD-$4844 block is retained as typed-neutral data until its fields are proven.

section "Battle Unit Runtime Front Half", romx[$4000], bank[$16]
BattleUnitRuntime_4000::
    xor a
    ld [$c4a7], a
    ld [$c4a8], a
    ld [$c4a9], a
    ld [$c4aa], a
    ret
    ld a, [$c4ad]
    cp $00
    jr z, $4018
    jr $402b
    ret
    ld a, [$c4a7]
    inc a
    ld [$c4a7], a
    ld h, $00
    ld l, a
    ld bc, $0101
    ld d, $02
    call $31f5
    ret
    ld a, [$c4a8]
    inc a
    ld [$c4a8], a
    ld h, $00
    ld l, a
    ld bc, $0b01
    ld d, $02
    call $3251
    ret
    ld a, [$c4d8]
    cp $00
    jr z, $4048
    jr $405b
    ret
    ld a, [$c4a9]
    inc a
    ld [$c4a9], a
    ld h, $00
    ld l, a
    ld bc, $0601
    ld d, $02
    call $3251
    ret
    ld a, [$c4aa]
    inc a
    ld [$c4aa], a
    ld h, $00
    ld l, a
    ld bc, $1001
    ld d, $02
    call $3251
    ret
    call $04f3
    call $34ce
    call $2d7c
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    ldh [$ff97], a
    ldh [$ff98], a
    ld [$d36e], a
    ld [$d36f], a
    ld [$c4b9], a
    ld [$c4ba], a
    ld [$c4bb], a
    ld [$c4bc], a
    ld [$d36c], a
    ld [$d36d], a
    ld [$d370], a
    ld [$d371], a
    ld [$c4ab], a
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call $0618
    call $0f02
    farcall Gfx_LoadCommonScreenAssetsAt8800
    ld a, $89
    farcall UIWindowStack_SetAttributes
    ld a, $bb
    farcall UIWindowStack_SetBorderTile
    farcall AdvancedSprite_Reset
    ld bc, $0000
    ld de, $0a04
    farcall UIWindow_DrawFrame
    ld bc, $0a00
    ld de, $0a04
    farcall UIWindow_DrawFrame
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $80
    ld bc, $0101
    ld de, $0802
    farcall Gfx_TilemapFill
    ld a, $80
    ld bc, $0b01
    ld de, $0802
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    farcall BattlePlace_LoadSharedGraphicsAndPalette
    farcall BANK_18, Bank18_Entry_4949
    farcall BattleScene_RequestPalettes
    xor a
    ld [$d364], a
    ld [$d365], a
    ld [$d366], a
    ld [$d367], a
    ld [$d36a], a
    ld [$d36b], a
    call $41b1
    call $426c
    farcall BattleScene_FillCommonTilemap
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0401
    ld de, $0202
    ld a, $88
    farcall Gfx_TilemapFill
    ld bc, $0e01
    ld de, $0202
    ld a, $88
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    farcall BattleScene_DrawPreparedResourceValues
BattleUnit_LoadBothSideGraphics_Anchor::
    ld a, [$d377]
    ld b, a
    ld a, $00
    call $454b
    ld a, [$d37d]
    ld b, a
    ld a, $01
    call $454b
    ld a, [$c4b7]
    ld b, $00
    call $460f
    ld a, [$c4b8]
    ld b, $01
    call $460f
    ld a, [$d37b]
    ld [$c4b3], a
    ld a, [$d381]
    ld [$c4b4], a
    ld a, $ff
    ld hl, $d384
    ld bc, $000a
    call $3b79
    ld a, $ff
    ld hl, $d38e
    ld bc, $000a
    call $3b79
    ld hl, $d384
    ld a, [$d378]
    ld c, a
    ld b, $00
    ld a, $01
    call $3b79
    ld hl, $d38e
    ld a, [$d37e]
    ld c, a
    ld b, $00
    ld a, $01
    call $3b79
    ret
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$d377]
    farcall BattleScene_ClassifyMapTile3Way
    cp $00
    jr z, $41cd
    cp $01
    jr z, $41d2
    cp $02
    jr z, $41d7
    ld de, $5561
    jr $41dc
    ld de, $6e91
    jr $41dc
    ld de, $5fc1
    jr $41dc
    ld bc, $0010
    ld hl, $9000
    call $3b59
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0004
    ld de, $090e
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $0e
    ld bc, $0004
    ld de, $090e
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d37d]
    farcall BattleScene_ClassifyMapTile3Way
    cp $00
    jr z, $4223
    cp $01
    jr z, $4228
    cp $02
    jr z, $422d
    ld de, $5561
    jr $4232
    ld de, $6e91
    jr $4232
    ld de, $5fc1
    jr $4232
    ld bc, $0010
    ld hl, $92a0
    call $3b59
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0b04
    ld de, $090e
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $2f
    ld bc, $0b04
    ld de, $090e
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$d37a]
    ld [$d375], a
    ld hl, $8bf0
    farcall BattlePlace_LoadGraphicsWindow
    ld a, [$d380]
    ld [$d376], a
    ld hl, $8d50
    farcall BattlePlace_LoadGraphicsWindow
    ld a, [$d377]
    farcall BattleScene_ClassifyUnitTypeDomain4Way
    cp $01
    jr z, $42ac
    cp $03
    jr z, $42bd
    ld bc, $0004
    jr $42cc
    ld a, $32
    ld [$d375], a
    ld hl, $8bf0
    farcall BattlePlace_LoadGraphicsWindow
    ld bc, $000f
    jr $42cc
    ld a, $33
    ld [$d375], a
    ld hl, $8bf0
    farcall BattlePlace_LoadGraphicsWindow
    ld bc, $0004
    ld a, [$d375]
    ld d, $bf
    ld e, $02
    ld h, $00
    farcall BattlePlace_RenderRecord
    ld a, [$d37d]
    farcall BattleScene_ClassifyUnitTypeDomain4Way
    cp $01
    jr z, $42ed
    cp $03
    jr z, $42fe
    ld bc, $0b04
    jr $430d
    ld a, $32
    ld [$d376], a
    ld hl, $8d50
    farcall BattlePlace_LoadGraphicsWindow
    ld bc, $0b0f
    jr $430d
    ld a, $33
    ld [$d376], a
    ld hl, $8d50
    farcall BattlePlace_LoadGraphicsWindow
    ld bc, $0b04
    ld a, [$d376]
    ld d, $d5
    ld e, $04
    ld h, $01
    farcall BattlePlace_RenderRecord
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$d340], a
    ld [$d341], a
    call $406e
    ld a, $00
    ld [$c4ab], a
    ld [$d343], a
    ld [$d342], a
    xor a
    ld hl, $d398
    ld bc, $000a
    call $3b79
    xor a
    ld hl, $d3a2
    ld bc, $000a
    call $3b79
    ld a, [$c686]
    cp $00
    jr z, $4370
    ld a, [$c633]
    and $01
    jr z, $4367
    jr $436b
    ld a, $21
    jr $436d
    ld a, $22
    call $3816
    farcall AdvancedSprite_Reset
    call $4401
    call $03ac
    call $081d
    ld de, $0001
    farcall Presentation_RunFrameServices
    ld a, [$c4de]
    cp $00
    jr z, $4390
    jr $438d
    jp $437d
    xor a
    ldh [$ff96], a
    ld [$c4ab], a
    ld [$d36a], a
    ld [$d36b], a
    ld a, [$d383]
    cp $ff
    jr z, $43dd
    cp $00
    jr nz, $43c2
    farcall AdvancedSprite_Reset
    ld a, [$d379]
    cp $00
    jr z, $43dd
    ld a, [$c4b7]
    ld b, $00
    call $498c
    ld a, $ff
    ld [$d383], a
    jp $437d
    farcall AdvancedSprite_Reset
    ld a, [$d37f]
    cp $00
    jr z, $43dd
    ld a, [$c4b8]
    ld b, $01
    call $498c
    ld a, $ff
    ld [$d383], a
    jp $437d
    xor a
    ld [$c4ab], a
    ld [$d36a], a
    ld [$d36b], a
    ld de, $001e
    farcall Presentation_RunFrameServices
    call $07b4
    farcall AdvancedSprite_Reset
    call $2e67
    call $03b5
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    ld a, [$d37c]
    ld c, a
    ld a, [$d382]
    cp c
    jr z, $440d
    jr $4424
    ld a, [$c4b7]
    ld b, $00
    call $498c
    ld a, [$c4b8]
    ld b, $01
    call $498c
    ld a, $ff
    ld [$d383], a
    jr $447a
    ld a, [$d37c]
    cp $00
    jr z, $444d
    ld a, [$d382]
    cp $00
    jr z, $443e
    ld a, [$d37c]
    ld c, a
    ld a, [$d382]
    cp c
    jr c, $445c
    jr $446b
    ld a, [$c4b7]
    ld b, $00
    call $498c
    ld a, $ff
    ld [$d383], a
    jr $447a
    ld a, [$c4b8]
    ld b, $01
    call $498c
    ld a, $ff
    ld [$d383], a
    jr $447a
    ld a, [$c4b7]
    ld b, $00
    call $498c
    ld a, $01
    ld [$d383], a
    jr $447a
    ld a, [$c4b8]
    ld b, $01
    call $498c
    ld a, $00
    ld [$d383], a
    jr $447a
    ret
    push bc
    push de
    ld hl, $d398
    call $29bc
    ld a, [hl]
    cp $00
    jr z, $448a
    jr $4492
    ld a, $01
    ld [hl], a
    ld a, $01
    pop de
    pop bc
    ret
    xor a
    ld [hl], a
    ld a, $ec
    pop de
    pop bc
    ret
    push bc
    push de
    ld hl, $d3a2
    call $29bc
    ld a, [hl]
    cp $00
    jr z, $44a8
    jr $44b0
    ld a, $01
    ld [hl], a
    ld a, $2b
    pop de
    pop bc
    ret
    xor a
    ld [hl], a
    ld a, $f2
    pop de
    pop bc
    ret
    call $4a32
    ld a, [$c4ae]
    cp $00
    jr z, $44c5
    ld bc, $0018
    add hl, bc
    push hl
    ld a, [$c4ae]
    cp $00
    jr z, $44cf
    jr $44d4
    ld hl, $d384
    jr $44d7
    ld hl, $d38e
    ld a, [$d33e]
    call $29bc
    ld a, [hl]
    pop hl
    cp $01
    jr z, $44e5
    jr $4519
    ld a, [$d33e]
    add a, a
    call $29bc
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a
    ld a, [$c4ae]
    cp $00
    jr nz, $4507
    ld d, $03
    ld e, $01
    ld a, [$d33e]
    call $447b
    ld h, a
    ld a, $00
    ld l, a
    jr $4515
    ld d, $03
    ld e, $01
    ld a, [$d33e]
    call $4499
    ld h, a
    ld a, $01
    ld l, a
    farcall Gfx_DrawSequentialTileRectDirectional
    ret
BattleUnit_GetHelicopterAuxiliaryGraphics::
    cp $27
    jr c, $4548
    cp $2c
    jr c, $4524
    jr $4548
    sub $27
    ld b, $05
    call $2995
    ld bc, $5548
    add hl, bc
    ld a, [hli]
    ld c, a
    ld a, [hli]
    ld b, a
    ld a, [hli]
    push bc
    ld b, $10
    call $2995
    pop bc
    add hl, bc
    ld d, h
    ld e, l
    ld a, [$d370]
    ld b, a
    ld a, [$d371]
    ld c, a
    xor a
    ret
    xor a
    scf
    ret
    assert @ == $454b

section "Battle Unit Runtime Post Loader", romx[$460e], bank[$16]
BattleUnitRuntime_460E::
    ret
    ld c, a
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    ld [$c4ac], a
    call $4a1c
    ld a, [$c4ad]
    cp $00
    jr z, $462b
    ld bc, $0018
    add hl, bc
    xor a
    push af
    ld a, [hli]
    ld b, a
    ld a, [hli]
    ld c, a
    push hl
    ld a, [$c4ad]
    cp $00
    jr nz, $464b
    ld a, [$c4b9]
    ld d, a
    ld a, [$c4ba]
    ld e, a
    ld a, $01
    ld h, a
    ld a, $00
    ld l, a
    ld a, $0e
    jr $465b
    ld a, [$c4bb]
    ld d, a
    ld a, [$c4bc]
    ld e, a
    ld a, $2b
    ld h, a
    ld a, $01
    ld l, a
    ld a, $2f
    farcall Gfx_DrawSequentialTileRectDirectionalWithAttributes
    pop hl
    ld a, [$c4ac]
    farcall BattleScene_ClassifyMapTileBinary
    cp $01
    jr nz, $466e
    pop af
    jr $468b
    ld a, [hl]
    cp $ff
    jr nz, $4676
    pop af
    jr $468b
    ld a, [$c4ad]
    cp $00
    jr nz, $4682
    ld a, [$d378]
    jr $4685
    ld a, [$d37e]
    ld c, a
    pop af
    inc a
    cp c
    jr nz, $462c
    ld a, [$c4ad]
    cp $00
    jp nz, $471f
    ld a, [$d377]
    farcall BattleScene_ClassifyUnitTypeDomain4Way
    cp $00
    jr z, $46aa
    cp $01
    jr z, $46c0
    cp $02
    jr z, $46d3
    cp $03
    jr z, $4704
    ld hl, $5f81
    ld a, $06
    ld b, $01
    call $06bc
    call $06f2
    call $47aa
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    ld hl, $7b21
    ld a, $06
    ld b, $01
    call $06bc
    call $06f2
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    ld hl, $6e51
    ld a, $06
    ld b, $01
    call $06bc
    call $06f2
    ld a, [$d37a]
    cp $09
    jr z, $46f6
    cp $14
    jr z, $46f6
    cp $1d
    jr z, $46f6
    cp $1e
    jr z, $46f6
    jp $4786
    ld a, $29
    ld [$d37a], a
    call $47aa
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    ld hl, $6e51
    ld a, $06
    ld b, $01
    call $06bc
    call $06f2
    ld a, $33
    ld [$d37a], a
    call $47aa
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    ld a, [$d37d]
    farcall BattleScene_ClassifyUnitTypeDomain4Way
    cp $00
    jr z, $4736
    cp $01
    jr z, $474c
    cp $02
    jr z, $475f
    cp $03
    jr z, $478f
    ld hl, $5f89
    ld a, $07
    ld b, $01
    call $06bc
    call $06f2
    call $47aa
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    ld hl, $7b29
    ld a, $07
    ld b, $01
    call $06bc
    call $06f2
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    ld hl, $6e59
    ld a, $07
    ld b, $01
    call $06bc
    call $06f2
    ld a, [$d380]
    cp $09
    jr z, $4781
    cp $14
    jr z, $4781
    cp $1d
    jr z, $4781
    cp $1e
    jr z, $4781
    jr $4786
    ld a, $29
    ld [$d380], a
    call $47aa
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    ld hl, $6e59
    ld a, $07
    ld b, $01
    call $06bc
    call $06f2
    ld a, $33
    ld [$d380], a
    call $47aa
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    ld a, [$c4ad]
    cp $00
    jr nz, $47c6
    ld a, [$d37a]
    add a, a
    ld hl, $47dd
    ld b, $00
    ld c, a
    add hl, bc
    ld de, $c510
    ld a, [hli]
    ld [de], a
    inc de
    ld a, [hl]
    ld [de], a
    jr $47d9
    ld a, [$d380]
    add a, a
    ld hl, $47dd
    ld b, $00
    ld c, a
    add hl, bc
    ld de, $c518
    ld a, [hli]
    ld [de], a
    inc de
    ld a, [hl]
    ld [de], a
    call $06f2
    ret
    assert @ == $47dd

section "Battle Unit Runtime Resource Lookup Data", romx[$47dd], bank[$16]
BattleUnitRuntime_ResourceLookupData::
    db $10, $42, $10, $42, $10, $42, $10, $42, $10, $42, $10, $42, $10, $42, $10, $42
    db $10, $42, $10, $42, $10, $42, $10, $42, $10, $42, $10, $42, $10, $42, $10, $42
    db $10, $42, $10, $42, $10, $42, $10, $42, $10, $42, $10, $42, $10, $42, $10, $42
    db $10, $42, $10, $42, $10, $42, $10, $42, $10, $42, $10, $42, $10, $42, $10, $42
    db $a9, $02, $10, $42, $10, $42, $10, $42, $b1, $29, $a9, $02, $b1, $29, $3d, $43
    db $0f, $7f, $a6, $59, $a6, $59, $a6, $59, $a6, $59, $a6, $59, $a6, $59, $a6, $59
    db $a6, $59, $a6, $59, $6e, $62, $84, $34
    assert @ == $4845

section "Battle Unit Scene Resource Condition", romx[$4845], bank[$16]
BattleUnit_TestSceneResourceCondition::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$c4ad]
    cp $01
    jr nz, $48a7
    ld a, [$c4af]
    ld b, $00
    ld c, a
    ld hl, $d384
    add hl, bc
    ld a, [hl]
    cp $ff
    jp z, $495d
    ld a, [$c4b7]
    farcall BattleScene_ClassifyMapTileBinary
    cp $01
    jr nz, $4874
    xor a
    ld [$c4af], a
    ld a, [$d378]
    ld c, a
    ld a, [$d379]
    cp c
    jp z, $495d
    ld a, [$d378]
    dec a
    ld [$d378], a
    ld a, [$c4b9]
    ld d, a
    ld a, [$c4ba]
    ld e, a
    push de
    ld a, [$c4b7]
    ld b, $00
    call $4a1c
    push hl
    ld a, [$c4af]
    ld b, $00
    ld c, a
    ld hl, $d384
    add hl, bc
    xor a
    ld [hl], a
    pop hl
    jr $48fb
    ld a, [$c4af]
    ld b, $00
    ld c, a
    ld hl, $d38e
    add hl, bc
    ld a, [hl]
    cp $ff
    jp z, $495d
    ld a, [$c4b8]
    farcall BattleScene_ClassifyMapTileBinary
    cp $01
    jr nz, $48c6
    xor a
    ld [$c4af], a
    ld a, [$d37e]
    ld c, a
    ld a, [$d37f]
    cp c
    jp z, $495d
    ld a, [$d37e]
    dec a
    ld [$d37e], a
    ld a, [$c4bb]
    ld d, a
    ld a, [$c4bc]
    ld e, a
    push de
    ld a, [$c4b8]
    ld b, $01
    call $4a1c
    ld bc, $0018
    add hl, bc
    push hl
    ld a, [$c4af]
    ld b, $00
    ld c, a
    ld hl, $d38e
    add hl, bc
    xor a
    ld [hl], a
    pop hl
    ld b, h
    ld c, l
    push bc
    ld a, [$c4af]
    ld b, $02
    call $2995
    pop bc
    add hl, bc
    pop de
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a
    push bc
    push de
    ld a, [$c4ad]
    cp $00
    jr nz, $492c
    ld a, [$c4b7]
    farcall BattleScene_ClassifyMapTileBinary
    cp $01
    jr nz, $4942
    ld a, [$d378]
    cp $00
    jr z, $4942
    pop de
    pop bc
    jr $495d
    ld a, [$c4b8]
    farcall BattleScene_ClassifyMapTileBinary
    cp $01
    jr nz, $4942
    ld a, [$d37e]
    cp $00
    jr z, $4942
    pop de
    pop bc
    jr $495d
    pop de
    pop bc
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    farcall Gfx_ClearTileRect
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    farcall BattleScene_DrawPreparedResourceValues
    xor a
    jr $4963
    farcall BattleScene_DrawPreparedResourceValues
    ld a, $01
    ld d, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, d
    ret
    assert @ == $496b

section "Battle Scene Active Slot Runtime", romx[$496b], bank[$16]
BattleScene_IsCurrentOverlaySlotActive::
    ld a, [$c4ad]
    cp $00
    jr z, $4977
    ld hl, $d38e
    jr $497c
    ld hl, $d384
    jr $497c
    ld a, [$c4b6]
    call $29bc
    ld a, [hl]
    cp $01
    jr z, $4989
    xor a
    ret
    xor a
    scf
    ret
BattleScene_ScheduleActiveOverlayResources::
    ld [$c4b0], a
    ld a, b
    ld [$c4ad], a
    farcall BattleScene_BuildRandomDelayTable
    xor a
    ld [$c4b6], a
    ld [$c4b5], a
    ld [$c4b6], a
    call $496b
    jr nc, $49b9
    farcall BattleScene_GetUnitTypeLayoutEntry
    farcall BattleScene_PrepareUsedWeaponResource
    ld a, [$c4b5]
    inc a
    cp $0a
    jr z, $49c7
    ld [$c4b5], a
    ld a, [$c4b6]
    inc a
    cp $0a
    jr nz, $49a1
    xor a
    ld [$c4b6], a
    jr $49a1
    ret
BattleScene_GetAirMatchupVariant::
    cp $00
    jr nz, $49da
    ld a, [$c4b7]
    ld [$c4b1], a
    ld a, [$c4b8]
    ld [$c4b2], a
    jr $49e6
    ld a, [$c4b8]
    ld [$c4b1], a
    ld a, [$c4b7]
    ld [$c4b2], a
    ld a, [$c4b1]
    farcall BattleScene_ClassifyMapTile3Way
    cp $01
    jr nz, $49fe
    ld a, [$c4b2]
    farcall BattleScene_ClassifyMapTile3Way
    cp $01
    jr nz, $4a13
    jr $4a17
    ld a, [$c4b2]
    farcall BattleScene_ClassifyMapTile3Way
    cp $01
    jr nz, $4a0b
    jr $4a0f
    ld a, $00
    jr $4a1b
    ld a, $01
    jr $4a1b
    ld a, $02
    jr $4a1b
    ld a, $00
    jr $4a1b
    ret
    assert @ == $4a1c
