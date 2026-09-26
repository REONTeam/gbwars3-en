include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"

; Mobile Adapter GB request handlers in physical Bank $30.
; continues directly from and stops before request $1A.

section "Mobile Adapter Driver Requests 12-18", romx[$45dc], bank[$30]
MobileAdapter_RequestHandler12::
    ld a, [$d021]
    bit 0, a
    jp nz, $4225
    ld a, [$d06a]
    cp $01
    jp nz, $4225
    xor a
    ldh [$ff07], a
    ld a, [$d070]
    ld c, a
    call $40dc
    ld hl, $d18f
    ld a, $81
    ld [hli], a
    ld a, $d0
    ld [hli], a
    xor a
    ld [hli], a
    ld [hli], a
    ld [hli], a
    ld [hl], a
    ld a, $ff
    ld [$d06e], a
    call $44af
    ld a, $0d
    ld [$d06a], a
    jp $4431
MobileAdapter_BuildModeSelectedControlPacket::
    ld b, $15
    ld [$d06e], a
    or a
    jr z, $4624
    dec a
    jr z, $462b
    dec a
    jp z, $46c0
    ret
    ld a, $19
    ld hl, $d03e
    jr $4630
    ld a, $6e
    ld hl, $d052
    push hl
    push bc
    ld [$d3a2], a
    ld hl, $d029
    ld a, $9d
    ld [hli], a
    ld a, $d3
    ld [hl], a
    xor a
    ld [$d3a1], a
    ld [$d06b], a
    ld [$d1af], a
    ld de, $d397
    ld hl, $607d
    ld b, $06
    call $4000
    ld de, $d347
    ld hl, $6063
    ld b, $05
    call $4000
    pop bc
    pop hl
    push de
    inc de
    ld a, b
    ld bc, $0000
    call $400f
    ld a, c
    pop hl
    ld [hl], a
    ld b, c
    call $5f66
    ld a, [$d06e]
    cp $02
    jr nz, $46ab
    ld a, [$d2bc]
    or a
    jr z, $46ab
    ld hl, $d195
    ld a, [hli]
    cp $99
    jr nz, $46ab
    ld a, [hli]
    cp $66
    jr nz, $46ab
    ld a, [hli]
    cp $23
    jr nz, $46ab
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
    ld a, $a8
    ld [$d01e], a
    ld b, $05
    call $5f0a
    ld a, $0f
    ld [$d06a], a
    jp $4431
MobileAdapter_PrepareConfigurationBuffer::
    ld b, $50
    ld hl, $d076
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld de, $0007
    add hl, de
    ld de, $d0ff
    ld a, [hli]
    ld [de], a
    cp $2f
    jr z, $46d9
    inc de
    dec b
    jr nz, $46cf
    xor a
    ld [de], a
    dec hl
    ld a, l
    ld [$d076], a
    ld a, h
    ld [$d077], a
    ld hl, $d0ff
    ld a, $50
    ld b, $40
    jp $4630
MobileAdapter_RequestHandler14_ReadConfigurationData::
    ld a, [$d021]
    bit 0, a
    jp nz, $4225
    ld a, [$d06a]
    cp $02
    jp nz, $4225
    ld a, [$d06d]
    or a
    jp nz, $4225
    push hl
    ld c, $20
    call $4399
    jr nc, $4711
    pop hl
    jp $4230
    xor a
    ld [$d06b], a
    ld de, $d3a7
    ld hl, $6072
    ld b, $06
    call $4000
    ld de, $d3b7
    ld hl, $6072
    ld b, $05
    call $4000
    inc de
    inc de
    ld bc, $0001
    ld hl, $609e
    call $4007
    pop hl
    push hl
    ld b, $ff
    inc b
    ld a, [hli]
    or a
    jr z, $4743
    cp $40
    jr nz, $473a
    ld a, c
    add a, b
    add a, $02
    ld [$d3bc], a
    pop hl
    call $4000
    call $696e
    ld a, $00
    jp $4614
MobileAdapter_RequestHandler16::
    ld a, [$d021]
    bit 0, a
    jp nz, $4225
    ld a, [$d06a]
    cp $03
    jp nz, $4225
    ld a, [$d18a]
    or a
    jp nz, $4225
    push hl
    ld a, [hli]
    or a
    jr nz, $476e
    ld a, [hl]
    or a
    jp z, $47fa
    pop hl
    push hl
    ld c, $20
    call $4399
    jr c, $47fa
    ld c, $81
    call $4399
    jr c, $47fa
    xor a
    cp [hl]
    jr nz, $4780
    call $6734
    xor a
    ld [$d06b], a
    ld de, $d347
    ld hl, $6072
    ld b, $06
    call $4000
    ld a, [$d06c]
    ld [de], a
    inc de
    ld b, $01
    call $5f66
    ld de, $d353
    ld hl, $6072
    ld b, $05
    call $4000
    ld de, $d359
    ld a, [$d06c]
    ld [de], a
    inc de
    ld bc, $0001
    ld de, $d35a
    ld hl, $60a4
    call $4007
    pop hl
    call $4007
    ld a, $3e
    ld [de], a
    inc de
    inc c
    ld a, l
    ld [$d07c], a
    ld a, h
    ld [$d07d], a
    call $696e
    ld a, c
    ld [$d358], a
    ld b, c
    call $5f66
    ld a, $95
    ld [$d01e], a
    ld hl, $d353
    ld d, $00
    ld e, c
    ld b, $05
    call $5f0a
    ld a, $15
    ld [$d06a], a
    jp $4431
    pop hl
    jp $4230
MobileAdapter_RequestHandler18::
    ld a, [$d021]
    bit 0, a
    jp nz, $4225
    ld a, [$d06a]
    cp $03
    jp nz, $4225
    ld a, [$d18a]
    or a
    jp z, $4225
    ld a, c
    or b
    jp z, $4230
    ld a, l
    ld [$d07c], a
    ld a, h
    ld [$d07d], a
    ld hl, $d07e
    ld a, c
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, d
    ld [$d06f], a
    call $6734
    ld hl, $d18a
    ld a, [hl]
    and $01
    xor $01
    ld [$d06b], a
    inc [hl]
    ld de, $d347
    ld hl, $6072
    ld b, $06
    call $4000
    ld de, $d34d
    ld a, [$d06c]
    ld [de], a
    inc de
    ld b, $01
    call $5f66
    ld de, $d3dd
    ld hl, $6072
    ld b, $05
    call $4000
    ld de, $d3e3
    ld a, [$d06c]
    ld [de], a
    ld a, [$d06b]
    or a
    jr nz, $4890
    ld bc, $0001
    ld de, $d3e4
    ld hl, $60ba
    call $4007
    ld a, c
    ld [$d3e2], a
    ld b, c
    call $5f66
    ld a, $95
    ld [$d01e], a
    ld de, $0011
    ld hl, $d3dd
    ld b, $05
    call $5f0a
    ld a, $16
    ld [$d06a], a
    jp $4431
    assert @ == $4898
