include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"

; residual Mobile Adapter dispatcher-handler tail in physical Bank $30.
; The range begins at request $3A and ends exactly before the exported serial
; service entry at $56CC. Higher-level SDK names stay numeric unless packet
; command bytes or state effects independently prove a stronger contract.

section "Mobile Adapter Driver Request Tail", romx[$548f], bank[$30]
MobileAdapter_RequestHandler3A::
    ld a, [$d022]
    bit 4, a
    jp z, $4225
    ld a, [$d021]
    bit 0, a
    jp nz, $4225
    bit 3, a
    jp z, $4225
    ld e, l
    ld d, h
    ld a, [$d192]
    or a
    jr nz, $550a
    ld a, [$d193]
    ld c, a
    ld b, $00
    ld hl, $d240
    add hl, bc
    ld a, [hli]
    or a
    jr z, $54be
    cp $81
    jr c, $54c0
    ld a, $80
    ld b, a
    inc c
    add a, c
    ld [$d193], a
    ld a, [$d194]
    dec a
    sub b
    ld c, a
    ld [$d194], a
    ld a, b
    ld [de], a
    inc de
    call $4000
    xor a
    or c
    jr nz, $54df
    ld hl, $d021
    res 3, [hl]
    ret
    ld a, [hli]
    or a
    jr z, $54e7
    cp $81
    jr c, $54e9
    ld a, $80
    cp c
    ret c
    ld [$d191], a
    dec c
    ld a, c
    or a
    jr z, $5503
    ld [$d192], a
    ld b, a
    ld de, $d080
    call $4000
    ld hl, $d021
    res 3, [hl]
    ret
    ld a, $ff
    ld [$d192], a
    jr $54fd
    cp $ff
    jr nz, $550f
    xor a
    ld b, a
    ld a, [$d191]
    sub b
    ld c, a
    ld hl, $d080
    ld a, [$d191]
    ld [de], a
    inc de
    ld a, b
    or a
    jr z, $5524
    call $4000
    ld hl, $d241
    ld b, c
    call $4000
    push hl
    ld a, c
    inc a
    ld [$d193], a
    ld b, a
    ld a, [$d23f]
    sub b
    ld [$d194], a
    ld c, a
    xor a
    ld hl, $d191
    ld [hli], a
    ld [hl], a
    pop hl
    jr $54d5
MobileAdapter_InternalHandler42::
    nop
MobileAdapter_RequestHandler32_TelephoneStatus::
    ld hl, $d021
    bit 0, [hl]
    jp nz, $4225
    ld a, [$d06a]
    cp $05
    jp nc, $4225
    ld [$d185], a
    ld a, e
    ld [$d06e], a
    ld a, d
    ld [$d06f], a
    ld a, [$d007]
    cp $02
    jr c, $5585
    xor a
    ld [$d06b], a
    ld a, $97
    ld hl, $602d
    call $5f02
    ld a, [$d188]
    cp $43
    jr nz, $557d
    ld a, $2c
    jr $557f
    ld a, $1e
    ld [$d06a], a
    jp $4431
    xor a
    ldh [$ff07], a
    ld a, [$d070]
    ld c, a
    call $40dc
    call $44af
    ld a, $01
    ld [$d06b], a
    jr $5572
MobileAdapter_RequestHandler34::
    ld hl, $d06a
    ld a, [hl]
    cp $01
    jp z, $4225
    cp $2a
    jp z, $4225
    ld a, [$d000]
    bit 1, a
    jr nz, $55b2
    ld a, $2a
    jr $55e7
    ld a, [$d01e]
    cp $92
    jr nz, $55e0
    ld a, $2a
    ld b, $00
    di
    ld [hli], a
    ld [hl], b
    ld hl, $d022
    res 5, [hl]
    res 0, [hl]
    xor a
    ld [$d00b], a
    ld [$d000], a
    ld a, $08
    ld [$d007], a
    call $4029
    call $5656
    ld hl, $d021
    set 0, [hl]
    ei
    ret
    ld a, $2a
    ld [hli], a
    ld a, $01
    ld [hl], a
    ret
    di
    push af
    cp $2a
    jr z, $5601
    ld a, [$d06d]
    or a
    ld a, [$d23c]
    jr z, $5610
    cp $9f
    jr z, $5614
    cp $a4
    jr z, $5614
    call $6430
    ld hl, $d021
    set 0, [hl]
    ld a, $01
    ld [$d06b], a
    pop af
    ld [$d06a], a
    ret
    cp $a3
    jr z, $55fe
    ei
    jr $5601
MobileAdapter_RequestHandler3C::
    ld hl, $d06a
    ld a, [hl]
    dec a
    jp z, $4225
    dec a
    jp z, $4225
    ld a, [$d000]
    or a
    jr nz, $562d
    ld a, $28
    jr $55e7
    ld a, $28
    ld b, $02
    ld [hli], a
    ld [hl], b
    ret
MobileAdapter_RequestHandler36::
    ld a, [$d06a]
    cp $01
    jp nz, $4225
    xor a
    ld hl, $d347
    ld [hli], a
    ld [hl], a
    call $568d
    call $4029
    ld bc, $0452
    ld hl, $d000
    xor a
    ld [hli], a
    dec bc
    ld a, c
    or b
    jr nz, $564e
    ret
MobileAdapter_ResetStatusWords::
    ld hl, $d015
    xor a
    ld [hli], a
    ld a, [$d01f]
    ld b, a
    ld a, [$d018]
    ld a, b
    srl a
    srl a
    add a, b
    add a, b
    ld [hl], a
    ret
MobileAdapter_StoreReceivedByte::
    ld hl, $d23a
    ld a, [hli]
    ld e, a
    ld a, [hli]
    ld d, a
    ld a, [$d01e]
    cp $ff
    jr z, $5680
    ld a, [$d022]
    bit 0, a
    jr z, $5683
    ld hl, $d22f
    add hl, de
    ld [hl], c
    inc de
    ld hl, $d23a
    ld a, e
    ld [hli], a
    ld [hl], d
    ret
MobileAdapter_ResetDriverFlags::
    xor a
    ldh [$ff07], a
    ld c, $ff
    ldh a, [c]
    and $f3
    ldh [c], a
    ld a, [$d348]
    ld [$d06a], a
    ld a, [$d347]
    ld c, a
    ld hl, $d021
    ld a, [hl]
    or c
    ld [hl], a
    ret
    db $3e, $01, $18, $05, $cb, $ce, $fa, $6a, $d0, $ea, $48, $d3, $21, $15, $d0, $af
    db $22, $fa, $1f, $d0, $17, $77, $21, $21, $d0, $7e, $47, $e6, $0d, $77, $3e, $02
    db $a0, $ea, $47, $d3, $c9
    assert @ == $56cc
