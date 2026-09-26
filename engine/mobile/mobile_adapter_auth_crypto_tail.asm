include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"

; close the remaining physical Bank $30 Mobile Adapter SDK body.
; $743E-$7F3F contains late protocol states, configuration/telephone helpers,
; the GB00 HTTP authentication MD5/Base64 implementation, and final state cleanup.
; $7F40-$7FFF is retail $FF padding. Existing English/custom data is untouched.

section "Mobile Adapter Authentication and Bank Tail", romx[$743e], bank[$30]
MobileAdapter_StageTransferDataWindow::
    ld hl, $d07f
    ld a, [hld]
    ld b, a
    ld a, [hld]
    ld c, a
    ld a, b
    or c
    ret z
    pop hl
    ld hl, $ff02
    add hl, bc
    jr c, $7452
    xor a
    ld l, a
    ld h, a
    ld e, l
    ld d, h
    ld hl, $d07f
    ld a, d
    ld [hld], a
    ld a, e
    ld [hld], a
    jr nc, $745f
    ld c, $fe
    ld a, [hld]
    ld l, [hl]
    ld h, a
    ld a, c
    inc a
    ld [$d34c], a
    ld de, $d34e
    ld b, c
    call $4000
    ld a, l
    ld [$d07c], a
    ld a, h
    ld [$d07d], a
    ld b, c
    inc b
    call $5f66
    ld hl, $d06b
    dec [hl]
    ld hl, $d347
    ld a, $95
    jp $5f05
MobileAdapter_NetworkProtocolState_1E_2C::
    dec a
    jr z, $7495
    dec a
    jr z, $74b0
    dec a
    jr z, $74b8
    dec a
    jr z, $74ca
    dec [hl]
    ret
    ld a, [$d240]
    cp $00
    jr z, $74ac
    cp $ff
    jr z, $74ac
    ld a, [$d185]
    ld [$d06a], a
    ld hl, $d021
    res 0, [hl]
    ret
    inc [hl]
    inc [hl]
    jr $74b8
    ld a, $97
    ld hl, $602d
    jp $5f02
    ld hl, $d06e
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, [$d242]
    cp $f0
    jr c, $74c7
    set 7, [hl]
    jp $6269
    ld a, [$d06a]
    cp $1e
    jp nz, $6251
    jp $56a7
MobileAdapter_NetworkProtocolState_25_27::
    dec a
    jr z, $74e3
    dec a
    jr z, $74e9
    dec a
    jr z, $74f8
    dec a
    jr z, $74fb
    dec [hl]
    ret
    ld hl, $6046
    jp $636b
    ld hl, $d029
    ld a, $e0
    ld [hli], a
    ld a, $d0
    ld [hli], a
    ld hl, $6052
    jp $636b
    jp $6269
    ld hl, $d080
    ld a, [hli]
    cp $4d
    jr nz, $7542
    ld a, [hld]
    cp $41
    jr nz, $7542
    ld b, $be
    ld de, $0000
    ld a, [hli]
    add a, e
    ld e, a
    ld a, $00
    adc a, d
    ld d, a
    dec b
    jr nz, $750d
    ld a, [hli]
    cp d
    jr nz, $7546
    ld a, [hl]
    cp e
    jr nz, $7546
    ld a, [$d06e]
    ld e, a
    ld a, [$d06f]
    ld d, a
    ld hl, $753a
    push hl
    ld a, [$d06a]
    cp $25
    jr z, $7576
    cp $26
    jr z, $7559
    cp $27
    jr z, $7569
    ld a, $01
    ld [$d035], a
    jp $56a7
    ld a, $25
    jr $7548
    ld a, $14
    call $625d
    jp $56ab
MobileAdapter_CopyFieldWithLeadingZero::
    push de
    ld l, e
    ld h, d
    xor a
    ld [hl], a
    inc de
    call $4000
    pop de
    ret
MobileAdapter_BuildConfigurationField20::
    ld b, $20
    call $754e
    ld a, $21
    ld hl, $d08c
    call $400f
    xor a
    ld [de], a
    ret
MobileAdapter_BuildConfigurationField1E::
    ld b, $1e
    call $754e
    ld a, $1f
    ld hl, $d0ac
    jp $400f
    ld b, $65
MobileAdapter_BuildConfigurationFields65::
    call $754e
    ld hl, $d0f6
    call $75a7
    ld a, $11
    ld hl, $d0fe
    call $400f
    inc de
    ld hl, $d10e
    call $75a7
    ld a, $11
    ld hl, $d116
    call $400f
    inc de
    ld hl, $d126
    call $75a7
    ld a, $11
    ld hl, $d12e
    jp $400f
MobileAdapter_FormatPackedTelephoneDigits::
    ld b, $08
    ld a, [hl]
    swap a
    and $0f
    cp $0f
    jr z, $75d8
    or $30
    cp $3a
    call z, $75dc
    cp $3b
    call z, $75df
    ld [de], a
    inc de
    ld a, [hli]
    and $0f
    cp $0f
    jr z, $75d8
    or $30
    cp $3a
    call z, $75dc
    cp $3b
    call z, $75df
    ld [de], a
    inc de
    dec b
    jr nz, $75a9
    xor a
    ld [de], a
    inc de
    ret
MobileAdapter_PackedTelephoneNibbleHash::
    ld a, $23
    ret
MobileAdapter_PackedTelephoneNibbleStar::
    ld a, $2a
    ret
MobileAdapter_NetworkProtocolState_2E::
    dec a
    jr z, $75f0
    dec a
    jr z, $75f5
    dec a
    jr z, $7628
    dec a
    jr z, $762b
    dec [hl]
    ret
    ld b, $9a
    jp $634b
    ld a, [$d082]
    or a
    jr nz, $75fe
    inc [hl]
    jr $7628
    ld de, $d34c
    ld c, a
    inc a
    ld [de], a
    inc de
    ld a, $80
    ld [de], a
    inc de
    ld hl, $d080
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld b, c
    call $4000
    ld b, c
    inc b
    call $5f66
    ld a, [$d34c]
    add a, $0a
    ld e, a
    ld d, $00
    ld a, $9a
    ld hl, $d347
    jp $5f05
    jp $6269
    jp $56a7
MobileAdapter_NetworkProtocolState_2D::
    dec a
    jr z, $763c
    dec a
    jr z, $7642
    dec a
    jr z, $7677
    dec a
    jr z, $767a
    dec [hl]
    ret
    ld hl, $d347
    jp $636b
    ld a, [$d082]
    or a
    jr z, $764f
    cp $81
    jr nc, $764f
    inc [hl]
    jr $7677
    ld hl, $d34e
    sub $80
    ld [hld], a
    ld a, $80
    ld [hl], a
    ld de, $d34f
    ld b, $02
    call $5f66
    ld hl, $d080
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld de, $0080
    add hl, de
    ld e, h
    ld a, l
    ld hl, $d029
    ld [hli], a
    ld [hl], e
    ld hl, $d347
    jp $636b
MobileAdapter_MD5PreparePaddedBlock::
    jp $6269
    jp $56a7
    db $af, $ea, $28, $d4, $7d, $ea, $07, $d4, $7c, $ea, $08, $d4, $21, $09, $d4, $7b
    db $22, $7a, $22, $78, $22, $21, $07, $d4, $2a, $66, $6f, $11, $67, $d3, $06, $30
    db $48, $cd, $00, $40, $21, $7f, $d1, $2a, $66, $6f, $2a, $b7, $20, $fc, $cd, $07
    db $40, $3e, $37, $b9, $3c, $30, $07, $3e, $02, $ea, $28, $d4, $3e, $78, $91, $47
    db $3e, $80, $12, $13, $af, $05, $28, $04, $12, $13, $18, $f9, $b7, $cb, $21, $cb
    db $10, $cb, $21, $cb, $10, $cb, $21, $cb, $10, $79, $12, $13, $78, $12, $13, $6b
    db $62, $06, $06, $af, $22, $05, $20, $fc, $11, $e7, $d3, $21, $3a, $7b, $06, $10
    db $cd, $00, $40
MobileAdapter_MD5InitializeWorkingState::
    ld hl, $d40c
    ld a, $4a
    ld [hli], a
    ld a, $7b
    ld [hl], a
    ld hl, $d40e
    ld a, $2c
    ld [hli], a
    ld a, $7a
    ld [hl], a
    ld hl, $d3e7
    ld de, $d418
    ld b, $10
    call $4000
MobileAdapter_MD5TransformBlock::
    ld hl, $d40e
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, [hli]
    ld c, a
    push hl
    call $78c5
    ld hl, $d3f7
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d3ff
    call $79ee
    pop hl
    ld a, [hli]
    ld d, [hl]
    inc hl
    ld e, a
    push hl
    ld a, [$d428]
    bit 0, a
    jr z, $7738
    ld hl, $0040
    add hl, de
    ld e, l
    ld d, h
    ld hl, $d367
    add hl, de
    ld e, l
    ld d, h
    ld hl, $d3ff
    call $79ee
    ld hl, $d40c
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d3ff
    call $79ee
    pop hl
    ld a, [hli]
    ld b, a
    ld a, l
    ld [$d40e], a
    ld a, h
    ld [$d40f], a
    ld hl, $d3ff
    call $79fc
    ld hl, $d3f9
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d3ff
    call $79ee
    ld hl, $d3f7
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d3ff
    ld b, $04
    call $4000
    ld hl, $d40c
    ld a, [hli]
    ld h, [hl]
    ld l, a
    inc hl
    inc hl
    inc hl
    inc hl
    ld a, h
    ld [$d40d], a
    ld a, l
    ld [$d40c], a
    cp $4a
    jp nz, $770d
    ld de, $d418
    ld hl, $d3e7
    call $79ee
    ld de, $d41c
    call $79ee
    ld de, $d420
    call $79ee
    ld de, $d424
    call $79ee
    ld hl, $d428
    bit 1, [hl]
    jr z, $77b8
    dec [hl]
    jp $76f0
    ld hl, $d367
    ld de, $d397
    ld bc, $0030
    call $7d22
    ld hl, $d409
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $7a11
    call $4007
    ld hl, $d397
    ld bc, $0020
    call $7c4a
    ld a, l
    ld [$d409], a
    ld a, h
    ld [$d40a], a
    ld b, $12
    ld hl, $d397
    ld de, $d367
    ld a, $40
    and [hl]
    rlca
    ld c, a
    ld a, [hli]
    bit 4, a
    jr z, $77f5
    set 6, c
    bit 2, a
    jr z, $77fb
    set 5, c
    bit 0, a
    jr z, $7801
    set 4, c
    ld a, [hli]
    bit 6, a
    jr z, $7808
    set 3, c
    bit 4, a
    jr z, $780e
    set 2, c
    bit 2, a
    jr z, $7814
    set 1, c
    bit 0, a
    jr z, $781a
    set 0, c
    ld a, c
    ld [de], a
    inc de
    dec b
    jr nz, $77e9
    ld b, $12
    ld hl, $d3ba
    ld de, $d38a
    ld a, $02
    and [hl]
    rrca
    ld c, a
    ld a, [hld]
    bit 3, a
    jr z, $7834
    set 1, c
    bit 5, a
    jr z, $783a
    set 2, c
    bit 7, a
    jr z, $7840
    set 3, c
    ld a, [hld]
    bit 1, a
    jr z, $7847
    set 4, c
    bit 3, a
    jr z, $784d
    set 5, c
    bit 5, a
    jr z, $7853
    set 6, c
    bit 7, a
    jr z, $7859
    set 7, c
    ld a, c
    ld [de], a
    dec de
    dec b
    jr nz, $7828
    ld b, $10
    ld de, $d397
    ld hl, $d3e7
    call $4000
    ld bc, $0010
    ld hl, $d17f
    ld a, [hli]
    ld h, [hl]
    ld l, a
    call $4007
    ld a, $24
    sub c
    ld b, a
    ld l, e
    ld h, d
    ld a, $ff
    ld [hli], a
    dec b
    jr nz, $787e
    xor a
    ld [hl], a
    ld b, $24
    ld hl, $d367
    ld de, $d397
    ld a, [de]
    inc de
    xor [hl]
    ld c, $00
    bit 0, a
    jr z, $7897
    set 3, c
    bit 3, a
    jr z, $789d
    set 6, c
    bit 6, a
    jr z, $78a3
    set 0, c
    and $b6
    or c
    ld [hli], a
    dec b
    jr nz, $788c
    ld hl, $d409
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d367
    ld bc, $0024
    call $7c4a
    ld a, $22
    ld [hli], a
    ld a, $0d
    ld [hli], a
    ld a, $0a
    ld [hli], a
    xor a
    ld [hl], a
    ret
MobileAdapter_MD5RoundOperation::
    call $78da
    ld a, c
    and $f0
    swap a
    or a
    jr z, $78eb
    dec a
    jr z, $792f
    dec a
    jp z, $7973
    jp $799a
MobileAdapter_MD5RoundOperationSelect::
    and $0f
    ld e, a
    ld d, $00
    ld hl, $7b2c
    add hl, de
    ld de, $d3f7
    ld b, $08
    jp $4000
    ld hl, $d3f9
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld de, $d3ff
    ld b, $04
    call $4000
    ld hl, $d3fb
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d3ff
    call $79c7
    ld hl, $d3f9
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld de, $d403
    ld b, $04
    call $4000
    ld hl, $d403
    call $79db
    ld hl, $d3fd
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d403
    call $79c7
    ld hl, $d3ff
    ld de, $d403
    call $79d1
    ret
    ld hl, $d3f9
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld de, $d3ff
    ld b, $04
    call $4000
    ld hl, $d3fd
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d3ff
    call $79c7
    ld hl, $d3fd
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld de, $d403
    ld b, $04
    call $4000
    ld hl, $d403
    call $79db
    ld hl, $d3fb
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d403
    call $79c7
    ld hl, $d3ff
    ld de, $d403
    call $79d1
    ret
MobileAdapter_MD5RoundFunctionH::
    ld hl, $d3f9
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld de, $d3ff
    ld b, $04
    call $4000
    ld hl, $d3fb
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d3ff
    call $79e4
    ld hl, $d3fd
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d3ff
    call $79e4
    ret
MobileAdapter_MD5RoundFunctionI::
    ld hl, $d3fd
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld de, $d3ff
    ld b, $04
    call $4000
    ld hl, $d3ff
    call $79db
    ld hl, $d3f9
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d3ff
    call $79d1
    ld hl, $d3fb
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d3ff
    call $79e4
    ret
MobileAdapter_MD5And32::
    ld b, $04
    ld a, [de]
    inc de
    and [hl]
    ld [hli], a
    dec b
    jr nz, $79c9
    ret
MobileAdapter_MD5Or32::
    ld b, $04
    ld a, [de]
    inc de
    or [hl]
    ld [hli], a
    dec b
    jr nz, $79d3
    ret
MobileAdapter_MD5Not32::
    ld b, $04
    ld a, [hl]
    cpl
    ld [hli], a
    dec b
    jr nz, $79dd
    ret
MobileAdapter_MD5Xor32::
    ld b, $04
    ld a, [de]
    inc de
    xor [hl]
    ld [hli], a
    dec b
    jr nz, $79e6
    ret
MobileAdapter_MD5Add32::
    ld a, [de]
    inc de
    add a, [hl]
    ld [hli], a
    ld b, $03
    ld a, [de]
    inc de
    adc a, [hl]
    ld [hli], a
    dec b
    jr nz, $79f4
    ret
MobileAdapter_MD5RotateLeft32::
    or a
    push hl
    ld a, [hli]
    rla
    ld a, [hl]
    rla
    ld [hli], a
    ld a, [hl]
    rla
    ld [hli], a
    ld a, [hl]
    rla
    ld [hl], a
    pop hl
    ld a, [hl]
    rla
    ld [hl], a
    dec b
    jr nz, $79fc
    ret
MobileAdapter_HTTPAuthorizationGB00Prefix::
    db $41, $75, $74, $68, $6f, $72, $69, $7a, $61, $74, $69, $6f, $6e, $3a, $20, $47
    db $42, $30, $30, $20, $6e, $61, $6d, $65, $3d, $22, $00
MobileAdapter_MD5RoundSchedule::
    db $00, $00, $00, $07, $06, $04, $00, $0c, $04, $08, $00, $11, $02, $0c, $00, $16
    db $00, $10, $00, $07, $06, $14, $00, $0c, $04, $18, $00, $11, $02, $1c, $00, $16
    db $00, $20, $00, $07, $06, $24, $00, $0c, $04, $28, $00, $11, $02, $2c, $00, $16
    db $00, $30, $00, $07, $06, $34, $00, $0c, $04, $38, $00, $11, $02, $3c, $00, $16
    db $10, $04, $00, $05, $16, $18, $00, $09, $14, $2c, $00, $0e, $12, $00, $00, $14
    db $10, $14, $00, $05, $16, $28, $00, $09, $14, $3c, $00, $0e, $12, $10, $00, $14
    db $10, $24, $00, $05, $16, $38, $00, $09, $14, $0c, $00, $0e, $12, $20, $00, $14
    db $10, $34, $00, $05, $16, $08, $00, $09, $14, $1c, $00, $0e, $12, $30, $00, $14
    db $20, $14, $00, $04, $26, $20, $00, $0b, $24, $2c, $00, $10, $22, $38, $00, $17
    db $20, $04, $00, $04, $26, $10, $00, $0b, $24, $1c, $00, $10, $22, $28, $00, $17
    db $20, $34, $00, $04, $26, $00, $00, $0b, $24, $0c, $00, $10, $22, $18, $00, $17
    db $20, $24, $00, $04, $26, $30, $00, $0b, $24, $3c, $00, $10, $22, $08, $00, $17
    db $30, $00, $00, $06, $36, $1c, $00, $0a, $34, $38, $00, $0f, $32, $14, $00, $15
    db $30, $30, $00, $06, $36, $0c, $00, $0a, $34, $28, $00, $0f, $32, $04, $00, $15
    db $30, $20, $00, $06, $36, $3c, $00, $0a, $34, $18, $00, $0f, $32, $34, $00, $15
    db $30, $10, $00, $06, $36, $2c, $00, $0a, $34, $08, $00, $0f, $32, $24, $00, $15
MobileAdapter_MD5WorkingWordPointerOrder::
    db $e7, $d3, $eb, $d3, $ef, $d3, $f3, $d3, $e7, $d3, $eb, $d3, $ef, $d3
MobileAdapter_MD5InitialState::
    db $01, $23, $45, $67, $89, $ab, $cd, $ef, $fe, $dc, $ba, $98, $76, $54, $32, $10
MobileAdapter_MD5KConstants::
    db $78, $a4, $6a, $d7, $56, $b7, $c7, $e8, $db, $70, $20, $24, $ee, $ce, $bd, $c1
    db $af, $0f, $7c, $f5, $2a, $c6, $87, $47, $13, $46, $30, $a8, $01, $95, $46, $fd
    db $d8, $98, $80, $69, $af, $f7, $44, $8b, $b1, $5b, $ff, $ff, $be, $d7, $5c, $89
    db $22, $11, $90, $6b, $93, $71, $98, $fd, $8e, $43, $79, $a6, $21, $08, $b4, $49
    db $62, $25, $1e, $f6, $40, $b3, $40, $c0, $51, $5a, $5e, $26, $aa, $c7, $b6, $e9
    db $5d, $10, $2f, $d6, $53, $14, $44, $02, $81, $e6, $a1, $d8, $c8, $fb, $d3, $e7
    db $e6, $cd, $e1, $21, $d6, $07, $37, $c3, $87, $0d, $d5, $f4, $ed, $14, $5a, $45
    db $05, $e9, $e3, $a9, $f8, $a3, $ef, $fc, $d9, $02, $6f, $67, $8a, $4c, $2a, $8d
    db $42, $39, $fa, $ff, $81, $f6, $71, $87, $22, $61, $9d, $6d, $0c, $38, $e5, $fd
    db $44, $ea, $be, $a4, $a9, $cf, $de, $4b, $60, $4b, $bb, $f6, $70, $bc, $bf, $be
    db $c6, $7e, $9b, $28, $fa, $27, $a1, $ea, $85, $30, $ef, $d4, $05, $1d, $88, $04
    db $39, $d0, $d4, $d9, $e5, $99, $db, $e6, $f8, $7c, $a2, $1f, $65, $56, $ac, $c4
    db $44, $22, $29, $f4, $97, $ff, $2a, $43, $a7, $23, $94, $ab, $39, $a0, $93, $fc
    db $c3, $59, $5b, $65, $92, $cc, $0c, $8f, $7d, $f4, $ef, $ff, $d1, $5d, $84, $85
    db $4f, $7e, $a8, $6f, $e0, $e6, $2c, $fe, $14, $43, $01, $a3, $a1, $11, $08, $4e
    db $82, $7e, $53, $f7, $35, $f2, $3a, $bd, $bb, $d2, $d7, $2a, $91, $d3, $86, $eb
MobileAdapter_Base64Encode::
    ld a, c
    ld [$d410], a
    ld a, b
    ld [$d411], a
    ld c, e
    ld b, d
    ld e, l
    ld d, h
    ld l, c
    ld h, b
    xor a
    ld [$d416], a
MobileAdapter_Base64EncodeLoop::
    ld b, $03
    push hl
    ld hl, $d412
    ld a, [de]
    inc de
    ld [hli], a
    dec b
    jr nz, $7c62
    ld a, [$d410]
    ld c, a
    ld a, [$d411]
    ld b, a
    xor a
    or b
    jr nz, $7c8b
    ld a, $02
    cp c
    jr c, $7c8b
    push hl
    dec hl
    ld a, c
    ld [$d416], a
    xor a
    ld [hld], a
    inc c
    ld a, $03
    cp c
    jr nz, $7c7f
    pop hl
    ld bc, $0003
    dec bc
    dec bc
    dec bc
    ld a, c
    ld [$d410], a
    ld a, b
    ld [$d411], a
    push de
    dec hl
    ld c, [hl]
    dec hl
    ld b, [hl]
    dec hl
    ld a, [hl]
    ld d, a
    srl a
    srl a
    ld [hli], a
    ld a, $03
    and d
    ld d, a
    ld a, $f0
    and b
    or d
    swap a
    ld [hli], a
    ld a, $0f
    and b
    ld d, a
    ld a, c
    and $c0
    or d
    rlca
    rlca
    ld [hli], a
    ld a, $3f
    and c
    ld [hld], a
    dec hl
    dec hl
    pop de
    ld b, h
    ld c, l
    pop hl
    ld a, [bc]
    inc bc
    call $7d03
    ld [hli], a
    ld a, [bc]
    inc bc
    call $7d03
    ld [hli], a
    ld a, [bc]
    inc bc
    call $7d03
    ld [hli], a
    ld a, [bc]
    inc bc
    call $7d03
    ld [hli], a
    ld a, [$d410]
    cp $00
    jp nz, $7c5c
    ld a, [$d411]
    cp $00
    jp nz, $7c5c
    ld a, [$d416]
    cp $00
    jr z, $7cff
    push hl
    dec hl
    ld b, a
    ld a, $3d
    ld [hld], a
    inc b
    ld a, $03
    cp b
    jr nz, $7cf5
    pop hl
    ld a, $00
    ld [hl], a
    ret
MobileAdapter_Base64ValueToChar::
    cp $1a
    jr c, $7d16
    cp $34
    jr c, $7d19
    cp $3e
    jr c, $7d1c
    cp $3e
    jr z, $7d1f
    ld a, $2f
    ret
    add a, $41
    ret
    add a, $47
    ret
    sub $04
    ret
    ld a, $2b
    ret
MobileAdapter_Base64Decode::
    ld a, c
    ld [$d410], a
    ld a, b
    ld [$d411], a
    ld c, e
    ld b, d
    ld e, l
    ld d, h
    ld l, c
    ld h, b
MobileAdapter_Base64DecodeLoop::
    ld a, [$d411]
    or a
    jr nz, $7d3e
    ld a, [$d410]
    cp $04
    jp c, $7de2
    ld b, $04
    push hl
    ld hl, $d412
    ld a, [de]
    inc de
    call $7db6
    ld [hli], a
    dec b
    jr nz, $7d44
    ld a, [$d410]
    ld c, a
    ld a, [$d411]
    ld b, a
    dec bc
    dec bc
    dec bc
    dec bc
    ld a, b
    or c
    jr z, $7d6a
    ld a, [de]
    cp $0d
    jr z, $7d66
    cp $0a
    jr nz, $7d6a
    inc de
    dec bc
    jr $7d5d
    ld a, c
    ld [$d410], a
    ld a, b
    ld [$d411], a
    push de
    dec hl
    ld d, [hl]
    dec hl
    ld c, [hl]
    dec hl
    ld b, [hl]
    dec hl
    ld a, [hl]
    sla b
    sla b
    sla b
    rla
    sla b
    rla
    ld [hli], a
    ld [hl], b
    inc hl
    rrc c
    rrc c
    ld [hl], c
    dec hl
    ld a, $0f
    and c
    or [hl]
    ld [hli], a
    ld a, [hli]
    and $c0
    or [hl]
    dec hl
    ld [hld], a
    dec hl
    pop de
    ld b, h
    ld c, l
    pop hl
    ld a, [bc]
    ld [hli], a
    inc bc
    ld a, [bc]
    ld [hli], a
    inc bc
    ld a, [bc]
    ld [hli], a
    ld a, [$d410]
    or a
    jr nz, $7d30
    ld a, [$d411]
    or a
    jp nz, $7d30
    xor a
    ld [hl], a
    ret
MobileAdapter_Base64CharToValue::
    cp $2b
    jr c, $7de0
    jr z, $7ded
    cp $2f
    jr c, $7de0
    jr z, $7df0
    cp $30
    jr c, $7de0
    cp $3a
    jr c, $7df3
    cp $3d
    jr c, $7de0
    jr z, $7df6
    cp $41
    jr c, $7de0
    cp $5b
    jr c, $7df8
    cp $61
    jr c, $7de0
    cp $7b
    jr c, $7dfb
    pop hl
    pop hl
MobileAdapter_Base64DecodeError::
    ld hl, $d021
    set 1, [hl]
    ld a, $20
    ld [$d00f], a
    ret
    ld a, $3e
    ret
    ld a, $3f
    ret
    add a, $04
    ret
    xor a
    ret
    sub $41
    ret
    sub $47
    ret
MobileAdapter_NetworkProtocolState_28::
    dec a
    jr z, $7e0b
    dec a
    jr z, $7e41
    dec a
    jr z, $7e64
    dec a
    jr z, $7e6c
    ret
    ld a, [$d007]
    cp $08
    jr nz, $7e14
    dec [hl]
    ret
    xor a
    ld [$d06d], a
    ld a, $02
    ld [$d06a], a
    ld hl, $d021
    ld a, [hl]
    and $10
    set 5, a
    ld [hl], a
    jp $7e74
MobileAdapter_NetworkProtocolState28_ResponseGate::
    ld a, [$d06d]
    or a
    ld a, [$d23c]
    jr z, $7e3d
    cp $9f
    jr z, $7e41
    cp $a4
    jr z, $7e41
    jp $6430
    cp $a3
    jr z, $7e3a
    xor a
    ld [$d06d], a
    ld [$d01e], a
    ld a, $02
    ld [$d06a], a
    ld a, $03
    ld [$d007], a
    ld hl, $d021
    ld a, [hl]
    and $10
    set 5, a
    ld [hl], a
    ld hl, $d022
    bit 0, [hl]
    call z, $5f9a
    ret
    ld a, [$d007]
    cp $08
    jr z, $7e12
    ret
    ld a, $01
    ld [$d06b], a
    jp $7e29
MobileAdapter_ResetProtocolCommandState::
    ld a, $ff
    ld [$d01e], a
    ld hl, $d022
    res 5, [hl]
    res 0, [hl]
    jp $5f9a
    db $21, $22, $d0, $7e, $f5, $cb, $9e, $cb, $86, $21, $1a, $d0, $2a, $5f, $2a, $57
    db $2a, $66, $6f, $23, $23, $3a, $2b, $ee, $80, $ea, $1e, $d0, $06, $05, $cd, $0a
    db $5f, $f1, $cb, $47, $c8, $21, $22, $d0, $cb, $c6, $c9
MobileAdapter_NetworkProtocolState_29::
    dec a
    jr z, $7eb6
    dec a
    jr z, $7ebf
    dec [hl]
    ret
    ld a, [$d007]
    cp $08
    jr nz, $7e74
    dec [hl]
    ret
    ld a, $26
    call $625d
    ld a, $2a
    ld [$d06a], a
    ld hl, $d020
    ld a, [hld]
    ld h, [hl]
    ld l, a
    ld e, l
    ld d, h
    add hl, de
    add hl, de
    ld e, l
    ld d, h
    ld hl, $d015
    ld e, a
    ld [hli], a
    ld a, d
    ld [hl], a
    xor a
    ld [$d000], a
    ld hl, $d347
    ld a, $02
    ld [hli], a
    dec a
    ld [hl], a
    ret
MobileAdapter_NetworkProtocolState_2A::
    dec a
    jr z, $7ef1
    dec a
    jr z, $7f0b
    dec [hl]
    ret
    ld a, [$d007]
    cp $08
    jr nz, $7efa
    dec [hl]
    ret
    xor a
    ld [$d23c], a
    ld [$d22f], a
    ld a, [$d01e]
    cp $91
    jr z, $7f0b
    jp $7e74
    xor a
    ld [$d06d], a
    ld hl, $d021
    set 0, [hl]
    ld hl, $d022
    xor a
    ld [hl], a
    xor a
    ld [$d00b], a
    xor a
    ld [$d347], a
    ld hl, $d020
    ld a, [hld]
    ld h, [hl]
    ld l, a
    ld e, l
    ld d, h
    add hl, de
    add hl, de
    ld e, l
    ld d, h
    ld hl, $d015
    ld e, a
    ld [hli], a
    ld a, d
    ld [hl], a
    xor a
    ld [$d000], a
    ld hl, $d347
    xor a
    ld [hli], a
    inc a
    ld [hl], a
    ret
MobileAdapter_Bank30Padding::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    assert @ == $8000
