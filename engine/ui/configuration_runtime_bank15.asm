include "macros/macros.inc"

; Shared configuration/options frontend. This owns the setup, cursor/input loop,
; value adjustment, enabled/disabled-state redraw, and help-panel controller.
; The localized descriptions themselves remain in data/config.asm at $43C3+.

section "Configuration Runtime", romx[$4000], bank[$15]

Options_ResetState::
    xor a
    ld [$c627], a
    ld [$c625], a
    ret


Options_SetupScreen::
    call $04f3
    call $34ce
    call $2d7c
    rst $28
    inc de
    call nz, $ea59
    daa
    add $af
    ldh [$ff95], a
    ldh [$ff96], a
    rst $28
    db $10
    xor b
    ld l, b
    rst $28
    ld bc, Options_ResetState
    call $0618
    call $0f02
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $00
    rst $28
    dec d
    sub c
    ld h, [hl]
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld de, $4503
    ld hl, $9000
    ld bc, $0390
    call $3b50
    ld de, $5928
    ld hl, $9390
    ld bc, $0040
    rst $28
    inc d
    ld d, b
    dec sp
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $00
    ld b, $08
    ld hl, $4893
    call $06bc
    call $06af
    call $06f2
    ld a, $0a
    ld bc, $0301
    ld de, $0e02
    ld h, $01
    rst $28
    dec d
    db $fd
    ld h, a
    ld bc, $0104
    ld de, $120b
    rst $28
    ld [hl+], a
    ld b, a
    ld h, d
    ld hl, $43dd
    call $336e
    ld hl, $43f1
    call $336e
    ld hl, $43fa
    call $336e
    ld hl, $43e7
    call $336e
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $0a
    ld bc, $0111
    ld de, $0301
    ld h, $21
    rst $28
    dec d
    db $fd
    ld h, a
    ld a, $08
    ld bc, $0411
    ld de, $0401
    ld h, $35
    rst $28
    dec d
    db $fd
    ld h, a
    ld a, $0a
    ld bc, $0911
    ld de, $0101
    ld h, $34
    rst $28
    dec d
    db $fd
    ld h, a
    ld a, $08
    ld bc, $0a11
    ld de, $0401
    ld h, $39
    rst $28
    dec d
    db $fd
    ld h, a
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $1d
    rst $28
    dec d
    db $fd
    ld h, a
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $1e
    rst $28
    dec d
    db $fd
    ld h, a
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call $2de8
    ld [$c626], a
    call Options_UpdateCursorSprite
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    call Options_DrawValues
    ret


Options_UpdateCursorSprite::
    ld a, [$c625]
    ld b, $10
    call $2995
    ld a, l
    add $44
    ld c, a
    ld b, $1c
    ld a, [$c626]
    call $2eae
    ret


Options_Run::
    call Options_SetupScreen
    ld a, $02
    call $3816
    call $081d

Jump_015_4136:
jr_015_4136:
    call $05a2
    call $3056
    ld a, $00
    rst $28
    dec d
    sub c
    ld h, a
    ldh a, [$ff92]
    bit 6, a
    jr z, jr_015_415f

    ld a, $01
    call $3844
    ld a, [$c625]
    dec a
    cp $ff
    jr nz, jr_015_4157

    ld a, $03

jr_015_4157:
    ld [$c625], a
    call Options_UpdateCursorSprite
    jr jr_015_4136

jr_015_415f:
    bit 7, a
    jr z, jr_015_4179

    ld a, $01
    call $3844
    ld a, [$c625]
    inc a
    cp $04
    jr nz, jr_015_4171

    xor a

jr_015_4171:
    ld [$c625], a
    call Options_UpdateCursorSprite
    jr jr_015_4136

jr_015_4179:
    bit 4, a
    jr z, jr_015_4185

    call Options_AdjustRight
    call Options_DrawValues
    jr jr_015_4136

jr_015_4185:
    bit 5, a
    jr z, jr_015_4191

    call Options_AdjustLeft
    call Options_DrawValues
    jr jr_015_4136

jr_015_4191:
    bit 3, a
    jr z, jr_015_419f

    ld a, $02
    call $3844
    call Options_ShowHelp
    jr jr_015_4136

jr_015_419f:
    bit 0, a
    jr z, jr_015_41b1

    ld a, $02
    call $3844
    ld a, [$c627]
    rst $28
    inc de
    ret z

    ld e, c
    jr jr_015_41bb

jr_015_41b1:
    bit 1, a
    jp z, Jump_015_4136

    ld a, $0c
    call $3844

jr_015_41bb:
    call $07b4
    ret


Options_AdjustLeft::
    ld a, [$c625]
    cp $00
    jr z, jr_015_41d5

    cp $01
    jr z, jr_015_41d2

    cp $02
    jr z, jr_015_41d9

    cp $03
    jr z, jr_015_41dd

jr_015_41d2:
    xor a
    jr jr_015_41e1

jr_015_41d5:
    ld a, $02
    jr jr_015_41e1

jr_015_41d9:
    ld a, $03
    jr jr_015_41e1

jr_015_41dd:
    ld a, $05
    jr jr_015_41e1

jr_015_41e1:
    push af
    call Options_TestCurrentValue
    jr z, jr_015_41e9

    pop af
    ret


jr_015_41e9:
    ld a, $01
    call $3844
    pop af
    ld hl, $c627
    call $3ad1
    ret


Options_AdjustRight::
    ld a, [$c625]
    cp $00
    jr z, jr_015_420c

    cp $01
    jr z, jr_015_4209

    cp $02
    jr z, jr_015_4210

    cp $03
    jr z, jr_015_4214

jr_015_4209:
    xor a
    jr jr_015_4218

jr_015_420c:
    ld a, $02
    jr jr_015_4218

jr_015_4210:
    ld a, $03
    jr jr_015_4218

jr_015_4214:
    ld a, $05
    jr jr_015_4218

jr_015_4218:
    push af
    call Options_TestCurrentValue
    jr nz, jr_015_4220

    pop af
    ret


jr_015_4220:
    ld a, $01
    call $3844
    pop af
    ld hl, $c627
    call $3adc
    ret


Options_TestCurrentValue::
    ld hl, $c627
    call $3ac7
    ret


Options_DrawValues::
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $08
    ld c, $06
    call Options_DrawValueLabel
    ld a, $02
    call Options_TestCurrentValue
    jr z, jr_015_4258

    ld a, $0f
    ld c, $06
    call Options_DrawValueDisabled
    ld a, $08
    ld c, $06
    call Options_DrawValueEnabled
    jr jr_015_4266

jr_015_4258:
    ld a, $08
    ld c, $06
    call Options_DrawValueDisabled
    ld a, $0f
    ld c, $06
    call Options_DrawValueEnabled

jr_015_4266:
    ld a, $08
    ld c, $0a
    call Options_DrawValueLabel
    ld a, $03
    call Options_TestCurrentValue
    jr z, jr_015_4284

    ld a, $0f
    ld c, $0a
    call Options_DrawValueDisabled
    ld a, $08
    ld c, $0a
    call Options_DrawValueEnabled
    jr jr_015_4294

jr_015_4284:
    ld a, $08
    ld c, $0a
    call Options_DrawValueDisabled
    ld a, $0f
    ld c, $0a
    call Options_DrawValueEnabled
    jr jr_015_4294

jr_015_4294:
    ld a, $08
    ld c, $0c
    call Options_DrawValueLabel
    ld a, $05
    call Options_TestCurrentValue
    jr z, jr_015_42b2

    ld a, $0f
    ld c, $0c
    call Options_DrawValueDisabled
    ld a, $08
    ld c, $0c
    call Options_DrawValueEnabled
    jr jr_015_42c0

jr_015_42b2:
    ld a, $08
    ld c, $0c
    call Options_DrawValueDisabled
    ld a, $0f
    ld c, $0c
    call Options_DrawValueEnabled

jr_015_42c0:
    ld a, $08
    ld c, $08
    call Options_DrawValueLabel
    ld a, $00
    call Options_TestCurrentValue
    jr z, jr_015_42de

    ld a, $0f
    ld c, $08
    call Options_DrawValueDisabled
    ld a, $08
    ld c, $08
    call Options_DrawValueEnabled
    jr jr_015_42ec

jr_015_42de:
    ld a, $08
    ld c, $08
    call Options_DrawValueDisabled
    ld a, $0f
    ld c, $08
    call Options_DrawValueEnabled

jr_015_42ec:
    ret


Options_DrawValueLabel::
    ld b, $0e
    ld de, $0101
    ld h, $28
    rst $28
    dec d
    db $fd
    ld h, a
    ret


Options_DrawValueDisabled::
    ld b, $0c
    ld de, $0201
    ld h, $26
    rst $28
    dec d
    db $fd
    ld h, a
    ret


Options_DrawValueEnabled::
    ld b, $0f
    ld de, $0301
    ld h, $29
    rst $28
    dec d
    db $fd
    ld h, a
    ret


Options_ShowHelp::
    ld a, [$c626]
    call $2f5f
    call $3056
    ld bc, $0104
    ld de, $120d
    rst $28
    db $10
    ld a, [$f068]
    add e
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    xor a
    ld bc, $0205
    ld de, $100b
    rst $28
    dec d
    db $d3
    ld l, d
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $0111
    call $0ed4
    ld bc, $000e
    ld a, $f7
    call $3b84
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $0111
    call $0ed4
    ld bc, $000e
    ld a, $0c
    call $3b84
    call Configuration_ShowSelectedDescription

jr_015_4368:
    call $05a2
    call $3056
    ld a, $00
    rst $28
    dec d
    sub c
    ld h, a
    ldh a, [$ff92]
    bit 1, a
    jr z, jr_015_4368

    rst $28
    db $10
    ld [$3e69], sp
    nop
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $0a
    ld bc, $0111
    ld de, $0301
    ld h, $21
    rst $28
    dec d
    db $fd
    ld h, a
    ld a, $08
    ld bc, $0411
    ld de, $0401
    ld h, $35
    rst $28
    dec d
    db $fd
    ld h, a
    ld a, $0a
    ld bc, $0911
    ld de, $0101
    ld h, $34
    rst $28
    dec d
    db $fd
    ld h, a
    ld a, $08
    ld bc, $0a11
    ld de, $0401
    ld h, $39
    rst $28
    dec d
    db $fd
    ld h, a
    ld a, [$c626]
    call $2f45
    ret


