include "macros/macros.inc"
include "charmaps/char_news.inc"

; Contextual scratch aliases used only by the Bank $23 attract-text runtime.
DEF wAttractSequenceId EQU $c622
DEF wAttractCurrentChar EQU $c021
DEF wAttractLocalState EQU $c022
DEF wAttractTextColumn EQU $c023
DEF wAttractTextRow EQU $c024
DEF wAttractScriptPointer EQU $c025 ; 2 bytes
DEF wAttractCharacterDelay EQU $c027
DEF wAttractCursorSpriteId EQU $c028
DEF wAttractSequenceSkipFlags EQU $c6a6

section "Attract Text Control Helpers", romx[$42be], bank[$23]
AttractSequence_CheckSkipEnabled::
    ld a, [$c622]
    ld c, a
    ld b, $00
    ld hl, $42cd
    add hl, bc
    ld a, [$c6a6]
    and [hl]
    ret
AttractSequence_SkipMasks::
    ld bc, $0402
    ld [$2010], sp
    nop
    nop
AttractText_WaitForConfirmAndHideCursor::
    call $05a2
    call $3056
    ldh a, [$ff91]
    and $09
    jr z, $42d5
    ld a, [$c028]
    call $2f5f
    ret
AttractText_WaitFramesOrConfirmAndHideCursor::
    ld c, a
    push bc
    call $05a2
    call $3056
    pop bc
    dec bc
    ld a, c
    or c
    jr z, $42fc
    ldh a, [$ff91]
    and $09
    jr z, $42e9
    ld a, [$c028]
    call $2f5f
    ret
AttractText_WaitForFinalConfirmAndHideCursor::
    call $05a2
    call $3056
    ldh a, [$ff91]
    and $09
    jr z, $4303
    ld a, [$c028]
    call $2f5f
    ret
    assert @ == $4316

section "Attract Introduction Runtime", romx[$48ac], bank[$23]
AttractIntro_Run::
    ld a, $06
    ld [$c622], a
AttractText_RunCurrentSequence::
    call $3815
    call $04f3
    call $34ce
    call $2d7c
    call $48f5
    call $081d
    call $05a2
    call $3056
    ld a, [$c622]
    cp $06
    jr nz, $48d8
    ldh a, [$ff91]
    and $09
    jr nz, $48e9
    jr $48e3
    ld a, [$c622]
    cp $07
    jr z, $48e3
    cp $05
    jr z, $48e3
    call $498e
    and a
    jr nz, $48c9
    ld a, $02
    call $3844
    call $07b4
    call $2e67
    ret
AttractText_SetupScreen::
    farcall AttractText_LoadGraphics
    ld hl, $7132
    ld c, $26
    ld a, $00
    ld b, $01
    call $06d9
    call $06f2
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
    ld c, $26
    ld a, $08
    ld b, $04
    ld hl, $71a4
    call $06d9
    call $06f2
    ld de, $7184
    ld hl, $8000
    ld bc, $0020
    farcall BANK_26, Bank26_Entry_3B50
    ld a, $20
    ld c, $00
    ld b, $26
    ld de, $717c
    call $2de8
    ld [$c028], a
    ld bc, $0000
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
    ld hl, $4a6e
    add hl, bc
    ld a, [hli]
    ld [$c025], a
    ld a, [hl]
    ld [$c026], a
    ld a, $01
    ld [$c027], a
    ret
AttractText_Update::
    call $42be
    jr z, $499a
    ldh a, [$ff91]
    and $08
    jp nz, $4a47
    ldh a, [$ff90]
    and $01
    or a
    jr nz, $49ab
    ld a, [$c027]
    dec a
    ld [$c027], a
    jp nz, $4a3a
    ld a, $06
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
    jr z, $4a3d
    cp $ff
    jr z, $49f5
    ld [$c021], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$c023]
    inc a
    ld [$c023], a
    ld b, a
    ld a, [$c024]
    add a, $01
    ld c, a
    call $0ed4
    ld de, $c021
    call $0f63
    call $4a49
    ld a, $04
    call $3844
    jr $4a3a
    xor a
    ld [$c023], a
    ld a, [$c024]
    inc a
    ld [$c024], a
    cp $10
    jr c, $4a3a
    ld a, $3c
    call $42e8
    ld a, [$c622]
    cp $06
    jr z, $4a1c
    call $42be
    jr z, $4a1c
    ldh a, [$ff91]
    and $08
    jp nz, $4a47
    xor a
    ld [$c024], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0000
    ld de, $1412
    farcall Gfx_TilemapFill
    ld a, [$c028]
    call $2f5f
    ld a, $02
    ret
    ld a, $01
    ret
    ld a, [$c622]
    cp $06
    jr z, $4a47
    call $4303
    xor a
    ret
AttractText_UpdateCursorSprite::
    ld a, [$c023]
    sla a
    sla a
    sla a
    add a, $14
    ld b, a
    ld a, [$c024]
    sla a
    sla a
    sla a
    add a, $1c
    ld c, a
    ld a, [$c028]
    call $2eae
    ld a, [$c028]
    call $2f45
    ret
    assert @ == $4a6e

section "Attract Introduction Scripts", romx[$4a6e], bank[$23]
AttractScriptPointerTable::
    db $59, $4c, $59, $4c, $59, $4c, $59, $4c, $7e, $4a, $7e, $4a, $ba, $4a, $98, $4a
AttractScript_ToBeContinued::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $24, $1f, $5f, $12, $15, $5f, $13, $1f, $1e
    db $24, $19, $1e, $25, $15, $14, $0e, $0e, $0e, $00
AttractScript_PlayNextArea15::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1c, $15, $24, $07, $23, $5f, $20, $1c, $11
    db $29, $5f, $1e, $15, $28, $24, $ff, $31, $35, $5f, $11, $22, $15, $11, $0e, $0e
    db $0e, $00
AttractScript_GameIntroduction::
    db $27, $15, $1c, $13, $1f, $1d, $15, $5f, $24, $1f, $ff, $24, $18, $15, $5f, $27
    db $1f, $22, $1c, $14, $5f, $1f, $16, $ff, $17, $11, $1d, $15, $12, $1f, $29, $5f
    db $27, $11, $22, $23, $33, $ff, $ff, $11, $23, $5f, $24, $18, $15, $5f, $13, $1f
    db $1d, $1d, $11, $1e, $14, $15, $22, $ff, $1f, $16, $5f, $15, $19, $24, $18, $15
    db $22, $ff, $24, $18, $15, $5f, $22, $15, $14, $23, $24, $11, $22, $5f, $16, $1f
    db $22, $13, $15, $ff, $1f, $22, $5f, $24, $18, $15, $5f, $27, $18, $19, $24, $15
    db $1d, $1f, $1f, $1e, $ff, $16, $1f, $22, $13, $15, $0c, $ff, $29, $1f, $25, $22
    db $5f, $1d, $19, $23, $23, $19, $1f, $1e, $5f, $27, $19, $1c, $1c, $ff, $12, $15
    db $5f, $24, $1f, $5f, $14, $15, $16, $15, $11, $24, $ff, $24, $18, $15, $5f, $15
    db $1e, $15, $1d, $29, $5f, $19, $1e, $ff, $26, $19, $22, $24, $25, $11, $1c, $5f
    db $23, $20, $11, $13, $15, $0e, $ff, $ff, $ff, $ff, $29, $1f, $25, $22, $5f, $1d
    db $19, $23, $23, $19, $1f, $1e, $5f, $27, $19, $1c, $1c, $ff, $12, $15, $5f, $24
    db $1f, $5f, $1f, $13, $13, $25, $20, $29, $ff, $24, $1f, $27, $1e, $23, $0c, $5f
    db $16, $11, $13, $24, $1f, $22, $19, $15, $23, $0c, $ff, $18, $11, $22, $12, $1f
    db $22, $23, $0c, $5f, $11, $1e, $14, $ff, $11, $19, $22, $20, $1f, $22, $24, $23
    db $5f, $24, $1f, $5f, $18, $15, $1c, $20, $ff, $29, $1f, $25, $5f, $24, $1f, $5f
    db $29, $1f, $25, $22, $ff, $25, $1c, $24, $19, $1d, $11, $24, $15, $5f, $26, $19
    db $13, $24, $1f, $22, $29, $0e, $ff, $ff, $29, $1f, $25, $22, $5f, $25, $1c, $24
    db $19, $1d, $11, $24, $15, $ff, $26, $19, $13, $24, $1f, $22, $29, $5f, $27, $19
    db $1c, $1c, $5f, $12, $15, $ff, $11, $13, $18, $19, $15, $26, $15, $14, $5f, $12
    db $29, $ff, $1f, $13, $13, $25, $20, $29, $19, $1e, $17, $5f, $24, $18, $15, $ff
    db $15, $1e, $15, $1d, $29, $5f, $13, $11, $20, $19, $24, $11, $1c, $5f, $1f, $22
    db $ff, $12, $29, $5f, $11, $1e, $1e, $19, $18, $19, $1c, $11, $24, $19, $1e, $17
    db $ff, $24, $18, $15, $5f, $15, $1e, $15, $1d, $29, $5f, $16, $1f, $22, $13, $15
    db $23, $0e, $ff, $ff, $17, $1f, $1f, $14, $5f, $1c, $25, $13, $1b, $5f, $1f, $1e
    db $ff, $29, $1f, $25, $22, $5f, $1d, $19, $23, $23, $19, $1f, $1e, $0e, $00
AttractScript_StaffCredits::
    db $ff, $ff, $ff, $ff, $5f, $5f, $17, $11, $1d, $15, $12, $1f, $29, $5f, $27, $11
    db $22, $23, $33, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f, $5f, $5f, $5f
    db $23, $24, $11, $16, $16, $ff, $ff, $ff, $ff, $ff, $20, $1c, $11, $1e, $1e, $19
    db $1e, $17, $5f, $14, $19, $22, $15, $13, $24, $1f, $22, $ff, $ff, $5f, $1d, $19
    db $1b, $19, $1f, $5f, $25, $15, $29, $11, $1d, $11, $ff, $ff, $ff, $20, $1c, $11
    db $1e, $1e, $15, $22, $23, $ff, $ff, $5f, $23, $18, $19, $1e, $5f, $23, $11, $23
    db $11, $1b, $19, $ff, $ff, $5f, $1b, $11, $2a, $25, $1d, $19, $5f, $1b, $11, $24
    db $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $20, $22, $1f, $17, $22, $11, $1d, $15
    db $22, $23, $ff, $ff, $5f, $1d, $19, $24, $24, $25, $5f, $24, $11, $1b, $11, $18
    db $11, $23, $18, $19, $ff, $ff, $5f, $18, $19, $22, $1f, $23, $18, $19, $5f, $19
    db $23, $18, $19, $1d, $11, $22, $25, $ff, $ff, $5f, $1d, $11, $23, $11, $24, $1f
    db $5f, $24, $1f, $12, $19, $23, $11, $27, $11, $ff, $ff, $ff, $1e, $15, $24, $27
    db $1f, $22, $1b, $5f, $20, $22, $1f, $17, $22, $11, $1d, $15, $22, $ff, $ff, $5f
    db $18, $19, $24, $1f, $23, $18, $19, $5f, $1f, $1b, $25, $1e, $1f, $ff, $ff, $ff
    db $ff, $ff, $17, $22, $11, $20, $18, $19, $13, $5f, $14, $15, $23, $19, $17, $1e
    db $15, $22, $23, $ff, $ff, $5f, $11, $1b, $19, $18, $19, $1b, $1f, $5f, $11, $2a
    db $25, $1d, $11, $ff, $ff, $5f, $1b, $11, $2a, $25, $23, $18, $19, $5f, $1b, $1f
    db $25, $23, $11, $1b, $11, $ff, $ff, $5f, $1e, $11, $1f, $1b, $19, $5f, $29, $11
    db $1d, $11, $23, $18, $19, $24, $11, $ff, $ff, $ff, $14, $15, $23, $19, $17, $1e
    db $5f, $14, $19, $22, $15, $13, $24, $1f, $22, $ff, $ff, $5f, $29, $25, $24, $11
    db $1b, $11, $5f, $23, $11, $24, $1f, $ff, $ff, $ff, $ff, $ff, $1d, $25, $23, $19
    db $13, $ff, $ff, $5f, $1b, $11, $2a, $25, $18, $19, $1b, $1f, $5f, $23, $11, $27
    db $11, $17, $25, $13, $18, $19, $ff, $ff, $ff, $23, $1f, $25, $1e, $14, $5f, $15
    db $16, $16, $15, $13, $24, $ff, $ff, $5f, $1d, $11, $23, $11, $24, $1f, $5f, $11
    db $19, $18, $11, $22, $11, $ff, $ff, $ff, $23, $1f, $25, $1e, $14, $5f, $14, $19
    db $22, $15, $13, $24, $1f, $22, $23, $ff, $ff, $5f, $11, $1b, $19, $18, $19, $22
    db $1f, $5f, $23, $11, $24, $1f, $18, $ff, $ff, $5f, $1f, $23, $11, $1d, $25, $5f
    db $1e, $11, $22, $19, $24, $11, $ff, $ff, $14, $15, $12, $25, $17, $ff, $ff, $5f
    db $18, $19, $14, $15, $1b, $19, $5f, $1d, $19, $16, $25, $1a, $19, $ff, $ff, $ff
    db $1d, $11, $1e, $25, $11, $1c, $5f, $15, $14, $19, $24, $1f, $22, $ff, $ff, $5f
    db $1b, $11, $2a, $25, $15, $5f, $1d, $11, $15, $14, $11, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $17, $11, $1d, $15, $5f, $14, $19, $22, $15, $13, $24, $1f
    db $22, $ff, $ff, $5f, $1d, $11, $23, $11, $24, $1f, $5f, $24, $1f, $12, $19, $23
    db $11, $27, $11, $ff, $ff, $ff, $20, $22, $1f, $14, $25, $13, $24, $5f, $1d, $11
    db $1e, $11, $17, $15, $22, $ff, $ff, $5f, $29, $11, $23, $25, $24, $11, $1b, $11
    db $5f, $1b, $11, $1b, $19, $23, $15, $1b, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $13, $1f, $1f, $22, $14, $19, $1e, $11, $24, $1f, $22, $23, $ff, $ff
    db $5f, $24, $11, $1b, $25, $1a, $19, $5f, $18, $1f, $24, $24, $11, $ff, $ff, $5f
    db $1d, $11, $23, $11, $1d, $19, $13, $18, $19, $5f, $16, $25, $1a, $19, $27, $11
    db $22, $11, $ff, $ff, $ff, $1e, $15, $24, $27, $1f, $22, $1b, $ff, $13, $1f, $1f
    db $22, $14, $19, $1e, $11, $24, $1f, $22, $23, $ff, $ff, $5f, $24, $11, $1b, $11
    db $1f, $5f, $1f, $18, $11, $22, $11, $ff, $ff, $5f, $29, $25, $19, $13, $18, $19
    db $22, $1f, $5f, $19, $24, $1f, $ff, $ff, $ff, $ff, $23, $20, $15, $13, $19, $11
    db $1c, $5f, $24, $18, $11, $1e, $1b, $23, $5f, $24, $1f, $ff, $ff, $5f, $18, $19
    db $22, $1f, $23, $18, $19, $5f, $23, $11, $24, $1f, $ff, $ff, $5f, $1b, $15, $1e
    db $24, $11, $22, $1f, $5f, $1e, $19, $23, $18, $19, $1d, $25, $22, $11, $ff, $ff
    db $ff, $20, $22, $1f, $14, $25, $13, $15, $22, $ff, $ff, $5f, $23, $18, $19, $1e
    db $19, $13, $18, $19, $5f, $1e, $11, $1b, $11, $1d, $1f, $24, $1f, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $15, $28, $15, $13, $25, $24, $19, $26, $15, $5f, $20, $22
    db $1f, $14, $25, $13, $15, $22, $ff, $ff, $5f, $18, $19, $22, $1f, $23, $18, $19
    db $5f, $1b, $25, $14, $1f, $ff, $ff, $ff, $ff, $ff, $11, $1c, $1c, $5f, $1e, $19
    db $1e, $24, $15, $1e, $14, $1f, $ff, $ff, $11, $1c, $1c, $5f, $18, $25, $14, $23
    db $1f, $1e, $ff, $ff, $23, $25, $20, $15, $22, $5f, $1d, $11, $22, $19, $1f, $5f
    db $13, $1c, $25, $12, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $5f, $5f, $5f, $5f, $5f, $24, $18, $15, $5f, $15, $1e, $14, $00
    assert @ == $4fc7
