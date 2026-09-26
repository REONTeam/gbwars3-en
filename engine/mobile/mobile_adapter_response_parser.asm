include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"

; Mobile Adapter response-field parser and protocol state-dispatch support.
; Physical Bank $30:$6B21-$6E55. This continues directly from and
; stops immediately before the independently reached $6E56 protocol-state body.
; Names remain contract-oriented where the public SDK/mail-client identity is not proven.

section "Mobile Adapter Response Parser Runtime", romx[$6b21], bank[$30]
MobileAdapter_ParseNumericResponseField::
    ld a, [$d072]
    push af
    ld a, [$d073]
    push af
    ld a, [$d074]
    push af
    ld bc, $0300
    ld de, $d072
    call $6b70
    call nc, $6b70
    call nc, $6b70
    dec hl
    ld a, [hli]
    cp $0d
    jr z, $6b46
    cp $20
    jr nz, $6b3d
    push hl
    ld hl, $d072
    ld de, $0000
    ld a, b
    or a
    jr z, $6b59
    dec a
    jr z, $6b5b
    dec a
    jr z, $6b5f
    jr $6b62
    ld a, [hli]
    ld d, a
    ld a, [hli]
    swap a
    ld e, a
    ld a, [hli]
    or e
    ld e, a
    pop hl
    pop af
    ld [$d074], a
    pop af
    ld [$d073], a
    pop af
    ld [$d072], a
    ret
MobileAdapter_ReadDecimalDigit::
    ld a, [hli]
    cp $30
    jr c, $6b7f
    cp $3a
    jr nc, $6b7f
    and $0f
    ld [de], a
    inc de
    dec b
    ret
    scf
    ret
MobileAdapter_NetworkResponseState_6B81::
    dec a
    jr z, $6b85
    ret
    call $67f1
    jr nz, $6bb3
    ld hl, $d080
    ld a, [hli]
    cp $2b
    jr nz, $6bc5
    ld a, [hli]
    cp $20
    jr nz, $6b92
    ld a, [hli]
    cp $20
    jr nz, $6b97
    call $6abc
    ld hl, $d06e
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, e
    ld [hli], a
    ld a, d
    ld [hli], a
    ld a, c
    ld [hli], a
    ld a, $04
    ld [$d06a], a
    jp $68e3
    ld a, [$d23c]
    cp $9f
    jp z, $6a52
    ld hl, $d06b
    dec [hl]
    ld hl, $d3c7
    jp $67d5
    ld de, $0004
    jp $6a3c
    dec a
    jr z, $6bcf
    ret
    call $67f1
    jr nz, $6be4
    ld hl, $d080
    ld a, [hli]
    cp $2b
    jr nz, $6bf6
    ld a, $04
    ld [$d06a], a
    jp $68e3
    ld a, [$d23c]
    cp $9f
    jp z, $6a52
    ld hl, $d06b
    dec [hl]
    ld hl, $d3c7
    jp $67d5
    ld de, $0004
    jp $6a3c
    dec a
    jr z, $6c07
    dec a
    jp z, $6ceb
    dec a
    ret nz
MobileAdapter_NetworkTransferBufferState_6C05::
    dec [hl]
    ret
    ld a, [$d080]
    cp $2d
    jr nz, $6c13
    call $67f1
    jr z, $6c1b
    ld a, [$d021]
    bit 2, a
    jp z, $6cff
    ld hl, $d06b
    inc [hl]
    ld hl, $d080
    ld a, [hli]
    cp $2b
    jp nz, $6d30
    ld b, $7f
    ld a, [hli]
    dec b
    cp $0a
    jr nz, $6c2a
    push hl
    ld hl, $d18f
    ld a, [hli]
    ld e, a
    ld a, [hli]
    ld d, a
    ld a, b
    ld [$d02d], a
    ld a, [hli]
    ld h, [hl]
    sub b
    ld l, a
    ld a, h
    sbc a, $00
    ld h, a
    jr nc, $6c66
    cp $ff
    jr nz, $6c66
    ld hl, $d191
    ld a, [hli]
    ld c, a
    inc hl
    ld a, b
    sub c
    ld [hli], a
    ld a, [$d02b]
    ld [hl], a
    ld hl, $d027
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, c
    ld [hli], a
    xor a
    ld [hl], a
    pop hl
    ld b, c
    jp $4000
    ld [$d193], a
    ld a, [$d02b]
    ld c, a
    ld [$d194], a
    push hl
    ld a, l
    sub c
    ld l, a
    ld a, h
    sbc a, $00
    ld h, a
    jr nc, $6caf
    cp $ff
    jr nz, $6caf
    ld a, c
    ld [$d23d], a
    ld a, [$d23f]
    sub c
    pop hl
    ld c, l
    pop hl
    push af
    call $4000
    pop af
    push de
    ld hl, $d240
    ld e, a
    ld d, $00
    add hl, de
    pop de
    ld b, c
    call $4000
    ld a, [$d23d]
    sub c
    ld [$d194], a
    ld hl, $d027
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, [$d191]
    ld [hli], a
    xor a
    ld [hl], a
    ret
    ld [$d194], a
    ld a, l
    ld [$d02b], a
    ld a, h
    ld [$d02c], a
    pop hl
    pop hl
    call $4000
    ld a, [$d23f]
    sub c
    push de
    ld hl, $d240
    ld e, a
    ld d, $00
    add hl, de
    pop de
    ld b, c
    call $4000
    ld a, [$d02d]
    add a, c
    ld [$d02d], a
    ld a, [$d02e]
    adc a, $00
    ld [$d02e], a
    ld hl, $d029
    ld a, e
    ld [hli], a
    ld a, d
    ld [hl], a
    ld hl, $d021
    res 2, [hl]
    ld a, [$d021]
    bit 2, a
    jr z, $6cfa
    ld a, $02
    ld [$d06b], a
    jp $6d19
    call $6803
    jr z, $6d11
    ld a, [$d23c]
    cp $9f
    jp z, $6a52
    ld hl, $d06b
    dec [hl]
    ld hl, $d3c7
    jp $67d5
    ld a, $04
    ld [$d06a], a
    call $68e3
MobileAdapter_CopyPendingTransferResult::
    ld a, [$d06e]
    ld l, a
    ld a, [$d06f]
    or l
    ret z
    ld hl, $d027
    ld a, [hli]
    ld e, a
    ld d, [hl]
    ld hl, $d02d
    ld b, $02
    jp $4000
MobileAdapter_ReturnNetworkResultCode4::
    ld a, [$d06a]
    cp $1a
    jr nz, $6d3d
    ld de, $0004
    jp $6a3c
    ld de, $0004
    jp $6a3c
MobileAdapter_NetworkProtocolStateDispatcher::
    dec a
    jr z, $6d97
    dec a
    jr z, $6daf
    dec a
    jp z, $6e56
    dec a
    jr z, $6d5d
    dec a
    jp z, $7349
    dec a
    jp z, $73b8
    dec a
    jp $6e56
    db $c9
MobileAdapter_NetworkProtocolStateGate::
    ld a, [$d06a]
    cp $23
    jr z, $6d7d
    cp $1f
    jr z, $6d70
    cp $20
    jr z, $6d7d
    cp $22
    jr nz, $6d92
    ld hl, $d18b
    ld a, [hli]
    cp $01
    jr nz, $6d92
    ld a, [hl]
    cp $04
    jr nz, $6d92
    ld hl, $d06e
    xor a
    ld [hli], a
    ld [hl], a
    ld hl, $d02b
    ld [hli], a
    ld [hl], a
    ld hl, $d021
    res 2, [hl]
    ld hl, $d06b
    dec [hl]
    dec [hl]
    ld hl, $d06b
    dec [hl]
    ret
MobileAdapter_StartTransferDataTemplateTransaction::
    call $743e
    ld de, $d347
    ld hl, $6072
    ld b, $06
    call $4000
    ld a, [$d06c]
    ld [de], a
    inc de
    ld b, $01
    call $5f66
    ld a, [$d021]
    bit 2, a
    jr z, $6dbb
    ld a, $03
    ld [hl], a
    jr $6dd1
    ld a, [$d23c]
    cp $9f
    jr z, $6dd1
    ld hl, $d06b
    dec [hl]
    ld de, $000b
    ld hl, $d347
    ld b, $05
    jp $5f0a
MobileAdapter_NetworkProtocolState_6DD1::
    ld a, [$d189]
    cp $02
    jr nc, $6e02
    call $6f71
    bit 2, a
    ret nz
    cp $03
    jr z, $6e48
    cp $01
    jr nz, $6e02
    ld a, [$d06a]
    cp $1f
    jr z, $6df1
    cp $20
    jr nz, $6e02
    ld hl, $d18b
    ld a, [hli]
    cp $01
    jr nz, $6e02
    ld a, $04
    cp [hl]
    jr nz, $6e02
    xor a
    ld [$d190], a
MobileAdapter_CopyTransferDescriptorResult::
    ld a, [$d06e]
    ld l, a
    ld a, [$d06f]
    or l
    ret z
    ld a, [$d06a]
    cp $13
    jr z, $6e31
    cp $14
    jr z, $6e31
    cp $20
    ret z
    cp $22
    ret z
    cp $23
    ret z
    cp $1f
    jr nz, $6e31
    ld hl, $d18b
    ld a, [hli]
    cp $00
    ret nz
    ld a, $02
    cp [hl]
    ret nz
    ld a, [$d06a]
    cp $24
    jr nz, $6e3a
    ld hl, $d078
    jr $6e3d
    ld hl, $d027
    ld a, [hli]
    ld e, a
    ld d, [hl]
    ld hl, $d02d
    ld b, $02
    jp $4000
MobileAdapter_StageNetworkCommand24::
    ld hl, $d021
    set 1, [hl]
    res 0, [hl]
    ld de, $d18b
    ld a, $24
    jr $6ea5
    assert @ == $6e56
