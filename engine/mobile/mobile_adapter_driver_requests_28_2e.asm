include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"

; Mobile Adapter GB request handlers in physical Bank $30.
; continues directly from and stops before request $3A at $548F.

section "Mobile Adapter Driver Requests 28-2E", romx[$4c9d], bank[$30]
MobileAdapter_RequestHandler28::
    ld a, [$d021]
    bit 2, a
    jr z, $4caf
    ld a, [$d06a]
    cp $1c
    jp nz, $4225
    jp $4af3
    bit 0, a
    jp nz, $4225
    ld a, [$d06a]
    cp $04
    jp nz, $4225
    ld a, l
    or h
    jp z, $4230
    ld a, l
    ld [$d06e], a
    ld a, h
    ld [$d06f], a
    ld hl, $d027
    ld a, e
    ld [hli], a
    ld a, d
    ld [hli], a
    inc de
    inc de
    dec bc
    dec bc
    ld hl, $d18f
    ld a, e
    ld [hli], a
    ld a, d
    ld [hli], a
    ld a, c
    ld [hli], a
    ld a, b
    ld [hl], a
    ld hl, $d029
    ld a, $80
    ld [hli], a
    ld a, $d0
    ld [hli], a
    ld a, $80
    ld [hli], a
    xor a
    ld [hli], a
    xor a
    ld [hli], a
    ld [hli], a
    xor a
    ld [$d06b], a
    ld de, $d347
    ld hl, $6072
    ld b, $05
    call $4000
    ld a, $0e
    ld [de], a
    inc de
    ld a, [$d06c]
    ld [de], a
    inc de
    ld bc, $0001
    ld hl, $6102
    call $4007
    ld de, $d352
    ld hl, $d06e
    ld a, [hli]
    ld h, [hl]
    ld l, a
    call $4d36
    ld b, c
    call $5f66
    ld a, $95
    ld [$d01e], a
    ld hl, $d347
    ld b, $05
    call $5f0a
    ld a, $1c
    ld [$d06a], a
    jp $4431
    push bc
    push de
    ld b, $00
    ld a, $27
    cp h
    jr c, $4d48
    jr nz, $4d51
    ld a, $10
    cp l
    jr z, $4d48
    jr nc, $4d51
    inc b
    ld a, b
    ld bc, $d8f0
    add hl, bc
    ld b, a
    jr $4d3a
    ld a, $30
    or b
    ld [de], a
    inc de
    ld b, $00
    ld a, $03
    cp h
    jr c, $4d66
    jr nz, $4d6f
    ld a, $e8
    cp l
    jr z, $4d66
    jr nc, $4d6f
    inc b
    ld a, b
    ld bc, $fc18
    add hl, bc
    ld b, a
    jr $4d58
    ld a, $30
    or b
    ld [de], a
    inc de
    ld b, $00
    ld a, $00
    cp h
    jr nz, $4d82
    ld a, $64
    cp l
    jr z, $4d82
    jr nc, $4d8b
    inc b
    ld a, b
    ld bc, $ff9c
    add hl, bc
    ld b, a
    jr $4d76
    ld a, $30
    or b
    ld [de], a
    inc de
    ld b, $00
    ld a, l
    cp $0a
    jr c, $4d9c
    sub $0a
    inc b
    jr $4d93
    ld l, a
    ld a, $30
    or b
    ld [de], a
    inc de
    ld a, $30
    or l
    ld [de], a
    pop de
    ld l, e
    ld h, d
    ld b, $05
    ld a, [hl]
    cp $30
    jr nz, $4db6
    inc hl
    dec b
    jr nz, $4dab
    jr $4dd4
    ld a, $05
    cp b
    jr z, $4dd4
    sub b
    ld c, a
    ld a, [$d34c]
    sub c
    ld c, a
    ld [$d34c], a
    push hl
    ld b, $01
    inc b
    ld a, [hli]
    cp $0d
    jr nz, $4dc8
    pop hl
    call $4000
    pop hl
    ret
    pop bc
    ld a, [de]
    inc de
    cp $0a
    jr nz, $4dd5
    ret
MobileAdapter_RequestHandler2A::
    ld a, [$d021]
    bit 2, a
    ld a, [$d06a]
    jr z, $4dff
    cp $13
    jp z, $5043
    cp $1f
    jp z, $5043
    cp $21
    jp z, $5043
    jp $4225
    pop hl
    pop hl
    pop hl
    pop hl
    jp $4230
    cp $02
    jp nz, $4225
    ld a, [$d021]
    bit 0, a
    jp nz, $4225
    ld a, [$d06d]
    or a
    jp nz, $4225
    ld a, l
    ld [$d1b5], a
    ld a, h
    ld [$d1b6], a
    xor a
    ld [$d189], a
    ld [$d1a5], a
    ld [$d18a], a
    ld [$d193], a
    ld a, [hli]
    ld [$d033], a
    ld a, [hli]
    ld [$d034], a
    inc hl
    inc hl
    ld a, l
    ld [$d17f], a
    ld a, h
    ld [$d180], a
    dec hl
    dec hl
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, $80
    cp l
    jr nz, $4e49
    ld a, $d0
    cp h
    jr z, $4dfc
    push hl
    push de
    push bc
    push hl
    ld b, $07
    ld de, $4fac
    ld a, [de]
    inc de
    cp [hl]
    jr nz, $4df8
    inc hl
    dec b
    jr nz, $4e52
    push hl
    ld b, $23
    ld c, $00
    ld de, $4fd8
    ld a, [de]
    inc de
    cp [hl]
    jr nz, $4e6f
    inc hl
    dec b
    jr nz, $4e63
    pop hl
    jr $4df8
    pop hl
    push hl
    ld b, $24
    ld c, $00
    ld de, $501f
    ld a, [de]
    inc de
    cp [hl]
    jr nz, $4e85
    inc hl
    dec b
    jr nz, $4e78
    pop hl
    jp $4df8
    pop hl
    push hl
    ld b, $24
    ld c, $00
    ld de, $4ffb
    ld a, [de]
    inc de
    cp [hl]
    jr nz, $4ea1
    inc hl
    dec b
    jr nz, $4e8e
    pop hl
    ld a, $01
    ld [$d18a], a
    ld c, $01
    jr $4eb2
    pop hl
    ld b, $25
    ld c, $00
    ld de, $4fb3
    ld a, [de]
    inc de
    cp [hl]
    jr nz, $4eca
    inc hl
    dec b
    jr nz, $4ea9
    ld hl, $d17f
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld c, $12
    call $4399
    jp c, $4df8
    ld c, $12
    call $4399
    jp c, $4df8
    ld c, $01
    ld a, c
    ld [$d18f], a
    ld [$d2bc], a
    pop hl
    call $51d6
    ld a, b
    cp $04
    jr c, $4ee2
    jp nz, $4df9
    xor a
    or c
    jp nz, $4df9
    ld hl, $d18b
    xor a
    ld [hli], a
    ld [hli], a
    ld [hli], a
    ld [hl], a
    pop bc
    pop de
    pop hl
    ld a, l
    ld [$d076], a
    ld a, h
    ld [$d077], a
    ld hl, $d072
    ld a, c
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, e
    ld [hli], a
    ld a, d
    ld [hli], a
    inc hl
    inc hl
    xor a
    ld [$d194], a
    ld hl, $d033
    ld a, [hli]
    ld h, [hl]
    ld l, a
    or h
    jr z, $4f11
    xor a
    ld [hl], a
    ld hl, $d191
    xor a
    ld [hli], a
    ld [hl], a
    ld hl, $d066
    ld a, [hli]
    or [hl]
    inc hl
    or [hl]
    inc hl
    or [hl]
    jr nz, $4f27
    ld a, $02
    jp $4614
    ld a, $02
    ld [$d06e], a
    ld a, $1f
    ld [$d351], a
    ld a, $90
    ld [$d352], a
    ld a, $01
    ld [$d06b], a
    ld de, $d347
    ld hl, $607d
    ld b, $06
    call $4000
    ld hl, $d066
    ld b, $04
    call $4000
    inc de
    inc de
    ld b, $06
    call $5f66
    ld a, [$d2bc]
    or a
    jr z, $4f94
    ld hl, $d195
    ld a, [hli]
    cp $99
    jr nz, $4f89
    ld a, [hli]
    cp $66
    jr nz, $4f89
    ld a, [hli]
    cp $23
    jr nz, $4f89
    ld a, $02
    ld [$d06e], a
    dec a
    ld [$d06b], a
    ld a, $a3
    ld de, $0010
    ld hl, $d195
    call $5f05
    ld a, $0f
    ld [$d06a], a
    jp $4431
    ld hl, $d347
    ld de, $d195
    ld b, $10
    call $4000
    ld de, $0010
    ld hl, $d347
    ld a, $a3
    ld [$d01e], a
    ld b, $05
    call $5f0a
    ld a, $0f
    ld [$d06a], a
    jp $4431
    db $68, $74, $74, $70, $3a, $2f, $2f, $67, $61, $6d, $65, $62, $6f, $79, $2e, $64
    db $61, $74, $61, $63, $65, $6e, $74, $65, $72, $2e, $6e, $65, $2e, $6a, $70, $2f
    db $63, $67, $62, $2f, $64, $6f, $77, $6e, $6c, $6f, $61, $64, $67, $61, $6d, $65
    db $62, $6f, $79, $2e, $64, $61, $74, $61, $63, $65, $6e, $74, $65, $72, $2e, $6e
    db $65, $2e, $6a, $70, $2f, $63, $67, $62, $2f, $75, $70, $6c, $6f, $61, $64, $67
    db $61, $6d, $65, $62, $6f, $79, $2e, $64, $61, $74, $61, $63, $65, $6e, $74, $65
    db $72, $2e, $6e, $65, $2e, $6a, $70, $2f, $63, $67, $62, $2f, $75, $74, $69, $6c
    db $69, $74, $79, $67, $61, $6d, $65, $62, $6f, $79, $2e, $64, $61, $74, $61, $63
    db $65, $6e, $74, $65, $72, $2e, $6e, $65, $2e, $6a, $70, $2f, $63, $67, $62, $2f
    db $72, $61, $6e, $6b, $69, $6e, $67
    ld hl, $d027
    ld a, e
    ld [hli], a
    ld a, d
    ld [hli], a
    inc de
    inc de
    ld a, e
    ld [hli], a
    ld a, d
    ld [hli], a
    ld e, [hl]
    ld a, b
    or c
    ld [$d06e], a
    ld [$d06f], a
    dec bc
    dec bc
    jp z, $51c9
    ld a, [$d191]
    or a
    call nz, $515e
    xor a
    cp e
    jp z, $50ea
    xor a
    cp b
    jr nz, $50ab
    ld a, e
    cp c
    jr c, $50ab
    push bc
    sub c
    ld [hl], a
    ld b, c
    ld hl, $d02d
    ld a, c
    ld [hli], a
    xor a
    ld [hl], a
    ld hl, $d23f
    ld a, [hli]
    inc hl
    sub e
    dec a
    ld e, a
    ld d, $00
    add hl, de
    ld a, [$d029]
    ld e, a
    ld a, [$d02a]
    ld d, a
    call $4000
    pop bc
    ld a, [$d191]
    ld l, a
    ld h, $00
    add hl, bc
    ld c, l
    ld b, h
    xor a
    ld [$d191], a
    ld hl, $d027
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, c
    ld [hli], a
    ld [hl], b
    ret
    ld a, c
    sub e
    ld c, a
    ld a, b
    sbc a, $00
    ld b, a
    ld a, c
    ld [hli], a
    ld [hl], b
    ld hl, $d02d
    ld a, [$d191]
    add a, e
    ld [hli], a
    ld a, $00
    adc a, $00
    ld [hl], a
    xor a
    ld [$d191], a
    ld a, [$d06e]
    or a
    jr z, $50ea
    ld b, e
    ld hl, $d23f
    ld a, [hli]
    inc hl
    sub e
    dec a
    ld e, a
    ld d, $00
    add hl, de
    ld a, [$d029]
    ld e, a
    ld a, [$d02a]
    ld d, a
    call $4000
    ld hl, $d029
    ld a, e
    ld [hli], a
    ld a, d
    ld [hl], a
    di
    ld a, $02
    ld [$d189], a
    ld hl, $d021
    res 2, [hl]
    ld a, [$d23c]
    cp $9f
    jr z, $5143
    ld de, $000b
    ld a, $95
    ld [$d01e], a
    ld hl, $d347
    ld b, $05
    call $5f0a
    ld a, $01
    ld [$d06b], a
    ret
    db $21, $27, $d0, $2a, $66, $6f, $fa, $2d, $d0, $22, $fa, $2e, $d0, $77, $21, $8f
    db $d1, $34, $3e, $0f, $ea, $6a, $d0, $3e, $01, $ea, $6b, $d0, $fa, $6d, $d0, $ea
    db $6e, $d0, $af, $ea, $89, $d1, $3e, $a3, $11, $10, $00, $21, $95, $d1, $c3, $05
    db $5f
    res 0, [hl]
    ld hl, $d027
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, [$d02d]
    ld [hli], a
    ld a, [$d02e]
    ld [hl], a
    ld a, $02
    ld [$d06a], a
    xor a
    ld [$d06d], a
    ei
    ret
    ld e, a
    xor a
    cp b
    jr nz, $5167
    ld a, c
    cp e
    jr c, $51a1
    push hl
    push bc
    ld b, e
    ld c, e
    ld a, [$d193]
    sub e
    ld e, a
    ld d, $00
    ld hl, $d080
    add hl, de
    ld a, [$d029]
    ld e, a
    ld a, [$d02a]
    ld d, a
    call $4000
    ld hl, $d029
    ld a, e
    ld [hli], a
    ld a, d
    ld [hl], a
    ld e, c
    ld a, c
    ld hl, $d02d
    ld [hli], a
    xor a
    ld [hl], a
    pop bc
    ld a, c
    sub e
    ld c, a
    ld a, b
    sbc a, $00
    ld b, a
    ld a, [$d192]
    ld [$d02b], a
    ld e, a
    pop hl
    ret
    ld a, e
    sub c
    ld [$d191], a
    ld a, [$d193]
    sub e
    ld e, a
    ld d, $00
    ld hl, $d080
    add hl, de
    ld a, [$d029]
    ld e, a
    ld a, [$d02a]
    ld d, a
    ld b, c
    call $4000
    ld hl, $d027
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, c
    ld [hli], a
    xor a
    ld [hl], a
    pop af
    ret
    ld hl, $d021
    res 2, [hl]
    ld a, $06
    ld [$d06b], a
    jp $6430
    push hl
    ld hl, $d066
    ld a, [hli]
    or [hl]
    inc hl
    or [hl]
    inc hl
    or [hl]
    pop hl
    jr nz, $51ed
    ld de, $0007
    add hl, de
    ld a, [hli]
    cp $2f
    jr nz, $51e7
    dec hl
    ld bc, $ffff
    ld a, [hli]
    inc bc
    or a
    jr nz, $51f0
    ld hl, $d07a
    ld a, c
    ld [hli], a
    ld a, b
    ld [hl], a
    ret
MobileAdapter_RequestHandler2C::
    ld a, [$d021]
    bit 2, a
    ld a, [$d06a]
    jp nz, $53f1
    cp $02
    jp nz, $4225
    ld a, [$d021]
    bit 0, a
    jp nz, $4225
    ld a, [$d06d]
    or a
    jp nz, $4225
    xor a
    ld [$d189], a
    ld [$d18a], a
    ld [$d193], a
    push hl
    push de
    push bc
    push hl
    inc hl
    inc hl
    inc hl
    inc hl
    ld a, l
    ld [$d1b5], a
    ld a, h
    ld [$d1b6], a
    ld a, [hli]
    ld [$d033], a
    ld a, [hli]
    ld [$d034], a
    inc hl
    inc hl
    ld a, l
    ld [$d17f], a
    ld a, h
    ld [$d180], a
    dec hl
    dec hl
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, $80
    cp l
    jr nz, $5258
    ld a, $d0
    cp h
    jp z, $53fe
    ld b, $07
    ld de, $4fac
    ld a, [de]
    inc de
    cp [hl]
    jp nz, $53fe
    inc hl
    dec b
    jr nz, $525d
    push hl
    ld b, $25
    ld c, $00
    ld de, $4fb3
    ld a, [de]
    inc de
    cp [hl]
    jr nz, $527c
    inc hl
    dec b
    jr nz, $526f
    pop hl
    jp $53fe
    pop hl
    push hl
    ld b, $24
    ld c, $00
    ld de, $501f
    ld a, [de]
    inc de
    cp [hl]
    jr nz, $5296
    inc hl
    dec b
    jr nz, $5285
    ld a, $02
    ld [$d18a], a
    pop hl
    jr $52a7
    pop hl
    ld b, $23
    ld c, $00
    ld de, $4fd8
    ld a, [de]
    inc de
    cp [hl]
    jr nz, $52d3
    inc hl
    dec b
    jr nz, $529e
    ld a, [hli]
    or a
    jr nz, $52a7
    ld a, [hld]
    cp $2f
    jr nz, $52ab
    inc hl
    inc hl
    ld a, [hl]
    cp $30
    jr c, $52d3
    cp $3a
    jr nc, $52d3
    ld hl, $d17f
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld c, $12
    call $4399
    jp c, $53fe
    ld c, $12
    call $4399
    jp c, $53fe
    ld c, $01
    ld a, c
    ld [$d18f], a
    ld [$d2bc], a
    pop hl
    ld de, $0006
    add hl, de
    ld a, [hli]
    ld h, [hl]
    ld l, a
    call $51d6
    ld a, b
    cp $04
    jr c, $52f2
    jp nz, $53ff
    xor a
    or c
    jp nz, $53ff
    pop bc
    pop de
    pop hl
    ld a, l
    ld [$d076], a
    ld a, h
    ld [$d077], a
    ld hl, $d072
    ld a, c
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, e
    ld [hli], a
    ld a, d
    ld [hli], a
    inc hl
    inc hl
    ld a, e
    ld [hli], a
    ld a, d
    ld [hl], a
    call $533c
    ld hl, $d076
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, [hli]
    ld [$d1aa], a
    ld a, [hli]
    ld [$d1ab], a
    ld a, [hli]
    ld [$d1ac], a
    ld a, [hli]
    ld [$d1ad], a
    inc hl
    inc hl
    ld a, [hli]
    ld [$d076], a
    ld a, [hl]
    ld [$d077], a
    ld a, [$d18f]
    xor $01
    ld [$d194], a
    jp $4f06
    ld hl, $d076
    ld a, [hli]
    ld h, [hl]
    ld l, a
    inc hl
    inc hl
    ld a, [hli]
    ld h, [hl]
    ld l, a
    xor a
    ld [$d0c9], a
    ld de, $8ad0
    add hl, de
    jr nc, $5355
    add a, $03
    jr $534b
    ld de, $7530
    add hl, de
    ld de, $d8f0
    add hl, de
    jr nc, $5362
    inc a
    jr $5359
    ld de, $2710
    add hl, de
    ld [$d0c6], a
    xor a
    ld de, $f448
    add hl, de
    jr nc, $5374
    add a, $30
    jr $536a
    ld de, $0bb8
    add hl, de
    ld de, $fc18
    add hl, de
    jr nc, $5382
    add a, $10
    jr $5378
    ld de, $03e8
    add hl, de
    ld de, $fed4
    add hl, de
    jr nc, $5390
    add a, $03
    jr $5386
    ld de, $012c
    add hl, de
    ld de, $ff9c
    add hl, de
    jr nc, $539d
    inc a
    jr $5394
    ld de, $0064
    add hl, de
    ld [$d0c7], a
    xor a
    ld de, $ffe2
    add hl, de
    jr nc, $53af
    add a, $30
    jr $53a5
    ld de, $001e
    add hl, de
    ld de, $fff6
    add hl, de
    jr nc, $53bd
    add a, $10
    jr $53b3
    ld de, $000a
    add hl, de
    add a, l
    ld [$d0c8], a
    ld de, $d1a5
    ld hl, $d0c6
    ld a, [hli]
    or $30
    ld [de], a
    inc de
    ld a, [hl]
    swap a
    and $0f
    or $30
    ld [de], a
    inc de
    ld a, [hli]
    and $0f
    or $30
    ld [de], a
    inc de
    ld a, [hl]
    swap a
    and $0f
    or $30
    ld [de], a
    inc de
    ld a, [hl]
    and $0f
    or $30
    ld [de], a
    inc de
    ret
    cp $14
    jp z, $5043
    cp $24
    jp z, $5043
    jp $4225
    pop hl
    pop hl
    pop hl
    pop hl
    jp $4230
MobileAdapter_RequestHandler2E::
    ld a, [$d022]
    bit 4, a
    jr z, $5482
    bit 7, a
    jr nz, $5482
    ld a, [$d021]
    bit 0, a
    jr nz, $5482
    ld a, [$d000]
    or a
    jr nz, $5417
    di
    ld a, [$d021]
    bit 3, a
    jr nz, $547e
    ld a, [$d007]
    or a
    jr nz, $5439
    ld hl, $d021
    set 1, [hl]
    ld a, $23
    ld [$d00f], a
    ld a, $ff
    ei
    ret
    xor a
    ld [$d06b], a
    push hl
    ld hl, $d029
    xor a
    ld [hli], a
    ld [hli], a
    ld [hli], a
    ld [hl], a
    ld de, $d347
    ld hl, $6072
    ld b, $05
    call $4000
    pop hl
    ld a, [hli]
    or a
    jr z, $5488
    cp $81
    jr nc, $5488
    ld c, a
    inc a
    inc a
    ld [de], a
    inc de
    ld a, $ff
    ld [de], a
    inc de
    ld a, c
    ld [de], a
    inc de
    ld b, c
    call $4000
    ld b, c
    inc b
    inc b
    call $5f66
    ld hl, $d022
    set 7, [hl]
    ld hl, $d021
    set 0, [hl]
    ld a, $00
    ei
    ret
    ei
    ld a, $01
    ret
    call $4225
    ld a, $ff
    ret
    ei
    call $4230
    ld a, $ff
    ret
    assert @ == $548f
