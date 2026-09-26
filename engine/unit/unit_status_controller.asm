include "macros/macros.inc"

; Bank $25 Unit Status controller / comparison-style status screen.
; Shared WRAM aliases in $C61A-$C622 are valid only while this screen is active.
section "UnitStatus Controller Runtime", romx[$4110], bank[$25]
UnitStatus_RunController::
    call $04f3
    call $34ce
    call $2d7c
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    farcall UIWindowStack_Init
    farcall MapGraphics_LoadGameplayAssetsAndFontBG
    call $0618
    call $0f02
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ld a, $05
    farcall MapPresentation_LoadThreeTileBlock
    ld bc, $0401
    ld de, $0c03
    farcall UIWindow_DrawFrame
    ld bc, $0005
    ld de, $0a0a
    farcall UIWindow_DrawFrame
    ld bc, $0a05
    ld de, $0a0a
    farcall UIWindow_DrawFrame
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0502
    ld de, $0a01
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0502
    ld de, $0a01
    farcall Gfx_TilemapFill
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0106
    ld de, $0808
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0106
    ld de, $0808
    farcall Gfx_TilemapFill
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0b06
    ld de, $0808
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0b06
    ld de, $0808
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fa6
    call $2de8
    ld [$c61a], a
    ld bc, $5848
    call $2eae
    ld a, [$c61a]
    call $2f45
    ld a, [$c941]
    ld c, $00
    farcall UnitRecord_GetByte
    farcall UnitData_CopyNameToBuffer
    ld bc, $0502
    ld hl, $cd28
    call $3353
    ld a, $00
    ld [$c61f], a
    ld a, $00
    ld [$c620], a
    ld a, [$c9d8]
    call $42be
    ld a, $01
    ld [$c61f], a
    ld a, $0a
    ld [$c620], a
    ld a, [$c941]
    call $42be
    call $43bd
    call $4475
    ld a, [$c942]
    ld [$c622], a
    ld a, $26
    call $3816
    call $081d
    call $05a2
    call $3056
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff91]
    bit 0, a
    jr nz, $429c
    bit 1, a
    jr nz, $4295
    ldh a, [$ff92]
    bit 4, a
    jr nz, $4251
    bit 5, a
    jr nz, $4273
    jr $422f
    ld a, [$c942]
    and a
    jr z, $422f
    ld a, [$c943]
    ld b, a
    ld a, [$c944]
    cp b
    jr z, $422f
    ld hl, $c942
    dec [hl]
    ld hl, $c943
    inc [hl]
    ld a, $01
    call $3844
    call $4475
    jr $422f
    ld a, [$c943]
    and a
    jr z, $422f
    ld a, [$c942]
    ld b, a
    ld a, [$c944]
    cp b
    jr z, $422f
    ld hl, $c943
    dec [hl]
    ld hl, $c942
    inc [hl]
    ld a, $01
    call $3844
    call $4475
    jr $422f
    ld a, $0c
    call $3844
    jr $42b2
    ld a, [$c942]
    ld b, a
    ld a, [$c622]
    cp b
    jr nz, $42ad
    ld a, $03
    call $3844
    jr $422f
    ld a, $02
    call $3844
    call $07b4
    call $3815
    call $2e67
    ldh a, [$ff91]
    ret
    assert @ == $42be

section "UnitStatus Panel Graphics Runtime", romx[$43bd], bank[$25]
UnitStatus_LoadPanelGraphics::
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $7ab8
    ld hl, $9000
    ld bc, $0210
    farcall BANK_18, Bank18_Entry_3B50
    ld de, $5928
    ld hl, $9390
    ld bc, $0040
    farcall BANK_14, Bank14_Entry_3B50
    ld de, $4843
    ld hl, $9300
    ld bc, $0010
    farcall BANK_15, Bank15_Entry_3B50
    ld a, $0a
    ld bc, $0910
    ld de, $0101
    ld h, $30
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0a10
    ld de, $0401
    ld h, $39
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0f10
    ld de, $0101
    ld h, $0c
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1010
    ld de, $0301
    ld h, $0d
    farcall Gfx_DrawSequentialTileRectWithAttributes
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld h, $00
    ld l, $0f
    ld a, $00
    ld [$c620], a
    call $443b
    ld a, $0a
    ld [$c620], a
UnitStatus_DrawPaneIcons::
    ld a, [$c620]
    add a, $01
    ld b, a
    ld c, $08
    ld a, $0b
    ld de, $0101
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, [$c620]
    add a, $04
    ld b, a
    ld c, $08
    ld a, $0b
    ld de, $0101
    ld h, $02
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, [$c620]
    add a, $07
    ld b, a
    ld c, $08
    ld a, $0b
    ld de, $0101
    ld h, $03
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
UnitStatus_DrawPairValues::
    ld a, [$c942]
    ld bc, $0208
    ld d, $02
    farcall DrawNumber3Digits
    ld a, [$c943]
    ld bc, $0c08
    farcall DrawNumber3Digits
    ret
    assert @ == $448c
