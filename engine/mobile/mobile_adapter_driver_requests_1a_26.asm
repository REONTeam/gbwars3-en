include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"

; Mobile Adapter GB request handlers in physical Bank $30.
; continues directly from and stops before request $28.

section "Mobile Adapter Driver Requests 1A-26", romx[$4898], bank[$30]
MobileAdapter_RequestHandler1A::
    ld a, [$d06a]
    cp $03
    jp nz, $4225
    jr $48aa
MobileAdapter_RequestHandler1C::
    ld a, [$d06a]
    cp $04
    jp nz, $4225
    ld hl, $d021
    bit 0, [hl]
    jp nz, $4225
    call $6734
    xor a
    ld [$d06b], a
    ld de, $d367
    ld hl, $6072
    ld b, $06
    call $4000
    ld a, [$d06c]
    ld [de], a
    inc de
    ld b, $01
    call $5f66
    ld de, $d347
    ld hl, $6072
    ld b, $05
    call $4000
    ld a, $07
    ld [de], a
    inc de
    ld a, [$d06c]
    ld [de], a
    inc de
    ld bc, $0001
    ld hl, $60c1
    call $4007
    ld b, c
    call $5f66
    ld a, $95
    ld [$d01e], a
    ld hl, $d347
    ld b, $05
    call $5f0a
    ld a, $17
    ld [$d06a], a
    jp $4431
MobileAdapter_RequestHandler1E::
    ld a, [$d021]
    bit 0, a
    jp nz, $4225
    ld a, [$d06a]
    cp $02
    jp nz, $4225
    ld a, [$d06d]
    or a
    jp nz, $4225
    xor a
    ld [$d06b], a
    push hl
    ld c, $20
    call $4399
    jr c, $492e
    ld c, $22
    call $4399
    jr nc, $4932
    pop hl
    jp $4230
    ld de, $d3a7
    ld hl, $6072
    ld b, $05
    call $4000
    inc de
    inc de
    ld hl, $60c8
    call $4007
    pop hl
    push hl
    ld b, $ff
    inc b
    ld a, [hli]
    or a
    jr z, $4952
    cp $40
    jr nz, $4949
    ld a, b
    add a, $06
    ld c, a
    ld [$d3ac], a
    pop hl
    ld de, $d3b3
    call $4000
    ld a, [hli]
    or a
    jr nz, $4960
    call $696e
    ld a, c
    ld [$d3ac], a
    ld bc, $0006
    ld de, $d3f3
    ld a, $20
    call $400f
    call $696e
    ld a, c
    ld [$d3ec], a
    ld de, $d3e7
    ld hl, $6072
    ld b, $05
    call $4000
    ld de, $d3ee
    ld hl, $60ce
    ld b, $05
    call $4000
    ld de, $d3c7
    ld hl, $6072
    ld b, $06
    call $4000
    ld a, $01
    jp $4614
MobileAdapter_RequestHandler20::
    ld hl, $d021
    bit 0, [hl]
    jp nz, $4225
    ld a, [$d06a]
    cp $04
    jp nz, $4225
    ld a, e
    ld [$d06e], a
    ld a, d
    ld [$d06f], a
    xor a
    ld [$d06b], a
    call $6739
    ld de, $d347
    ld hl, $6072
    ld b, $05
    call $4000
    ld a, $07
    ld [de], a
    inc de
    ld a, [$d06c]
    ld [de], a
    inc de
    ld bc, $0001
    ld hl, $60d4
    call $4007
    ld b, c
    call $5f66
    ld a, $95
    ld [$d01e], a
    ld hl, $d347
    ld b, $05
    call $5f0a
    ld a, $18
    ld [$d06a], a
    jp $4431
MobileAdapter_RequestHandler22::
    ld a, [$d021]
    bit 0, a
    jp nz, $4225
    ld a, [$d06a]
    cp $04
    jp nz, $4225
    xor a
    ld [$d06b], a
    ld a, e
    ld [$d06e], a
    ld a, d
    ld [$d06f], a
    ld a, l
    or h
    jp z, $4230
    push hl
    call $6739
    ld de, $d347
    ld hl, $6072
    ld b, $05
    call $4000
    ld a, $0d
    ld [de], a
    inc de
    ld a, [$d06c]
    ld [de], a
    inc de
    ld bc, $0001
    ld hl, $60db
    call $4007
    ld de, $d353
    pop hl
    call $4d36
    ld b, c
    call $5f66
    ld a, $95
    ld [$d01e], a
    ld hl, $d347
    ld b, $05
    call $5f0a
    ld a, $1d
    ld [$d06a], a
    jp $4431
MobileAdapter_RequestHandler24::
    ld a, [$d021]
    bit 2, a
    jr z, $4a6c
    ld a, [$d06a]
    cp $1a
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
    ld a, $0d
    ld [de], a
    inc de
    ld a, [$d06c]
    ld [de], a
    inc de
    ld bc, $0001
    ld hl, $60e8
    call $4007
    ld de, $d353
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
    ld a, $1a
    ld [$d06a], a
    jp $4431
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
    jr z, $4b5b
    dec bc
    dec bc
    ld a, [$d193]
    or a
    jp nz, $4bd4
    ld a, [$d194]
    or a
    jr z, $4b1b
    ld e, a
    xor a
    ld [$d194], a
    cp b
    jr nz, $4b5b
    ld a, e
    cp c
    jr c, $4b5b
    push bc
    sub c
    ld [hl], a
    ld b, c
    ld hl, $d02d
    ld a, [$d193]
    add a, c
    ld [hli], a
    ld a, b
    adc a, $00
    ld [hl], a
    xor a
    ld [$d193], a
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
    ld a, [$d193]
    add a, e
    ld [hli], a
    ld a, $00
    adc a, $00
    ld [hl], a
    xor a
    ld [$d193], a
    ld a, [$d06e]
    or a
    jr z, $4b9a
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
    call $6803
    jr z, $4bba
    di
    ld hl, $d021
    res 2, [hl]
    ld a, $01
    ld [$d06b], a
    ld de, $000b
    ld a, $95
    ld [$d01e], a
    ld hl, $d3c7
    ld b, $05
    jp $5f0a
    ld a, $04
    ld [$d06a], a
    ld hl, $d021
    res 0, [hl]
    res 2, [hl]
    ld hl, $d027
    ld a, [hli]
    ld e, a
    ld d, [hl]
    ld hl, $d02d
    ld b, $02
    jp $4000
    ld e, a
    xor a
    cp b
    jr nz, $4c04
    ld a, e
    cp c
    jr c, $4c04
    ld b, c
    ld hl, $d193
    ld a, [hl]
    sub c
    ld [hl], a
    ld a, $80
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
    ld hl, $d027
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, c
    ld [hli], a
    xor a
    ld [hl], a
    ret
    push hl
    push bc
    ld a, [$d193]
    ld b, a
    ld a, $80
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
    ld a, e
    ld [$d029], a
    ld a, d
    ld [$d02a], a
    pop bc
    ld a, [$d193]
    ld e, a
    ld a, c
    sub e
    ld c, a
    ld a, b
    sbc a, $00
    ld b, a
    ld a, [$d194]
    ld e, a
    pop hl
    jp $4b1b
MobileAdapter_RequestHandler26::
    ld a, [$d021]
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
    call $6739
    ld de, $d347
    ld hl, $6072
    ld b, $05
    call $4000
    ld a, $0d
    ld [de], a
    inc de
    ld a, [$d06c]
    ld [de], a
    inc de
    ld bc, $0001
    ld hl, $60f5
    call $4007
    ld de, $d353
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
    ld a, $1b
    ld [$d06a], a
    jp $4431
    assert @ == $4c9d
