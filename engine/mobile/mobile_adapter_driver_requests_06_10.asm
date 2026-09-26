include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"

; Mobile Adapter GB request handlers in physical Bank $30.
; The library is the Nintendo Mobile Adapter SDK lineage also present in pret/pokecrystal;
; names below are used only where GBWars3 retail packet/state behavior confirms the role.

section "Mobile Adapter Driver Requests 06-10", romx[$43ab], bank[$30]
MobileAdapter_RequestHandler06_ISPLogin::
    ld a, [$d021]
    bit 0, a
    jp nz, $4225
    ld a, [$d06a]
    cp $01
    jp nz, $4225
    push hl
    ld c, $15
    call $4399
    jr c, $43d1
    ld c, $22
    call $4399
    jr c, $43d1
    ld c, $12
    call $4399
    jr nc, $43d5
    pop hl
    jp $4230
    xor a
    ldh [$ff07], a
    ld [$d06d], a
    ld [$d17a], a
    ld a, [$d070]
    ld c, a
    call $40dc
    ld hl, $d029
    ld a, $80
    ld [hli], a
    ld a, $d0
    ld [hl], a
    call $4484
    push hl
    ld b, a
    call $5f66
    ld b, $05
    ld hl, $6037
    ld de, $d374
    call $4000
    inc de
    inc de
    pop hl
    ld bc, $0000
    call $4007
    ld a, c
    ld [$d37a], a
    ld [$d06b], a
    push de
    inc de
    ld bc, $0000
    ld a, $20
    call $400f
    ld l, e
    ld h, d
    pop de
    ld a, c
    ld [de], a
    ld a, [$d06b]
    add a, c
    add a, $0a
    ld [$d379], a
    call $44af
    ld a, $0b
    ld [$d06a], a
MobileAdapter_MarkRequestActive::
    ld hl, $d021
    set 0, [hl]
    ret
MobileAdapter_RequestHandler08_DialTelephone::
    ld a, [$d021]
    bit 0, a
    jp nz, $4225
    ld a, [$d06a]
    cp $01
    jp nz, $4225
    push hl
    ld c, $15
    call $4399
    jr nc, $4453
    pop hl
    jp $4230
    xor a
    ldh [$ff07], a
    ld [$d17a], a
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
    call $4484
    ld b, a
    call $5f66
    call $44af
    ld a, $0c
    ld [$d06a], a
    jr $4431
MobileAdapter_BuildDialTelephonePacket::
    ld de, $d347
    ld hl, $601d
    ld b, $06
    call $4000
    pop bc
    pop hl
    push bc
    ld a, [$d018]
    cp $8c
    jr c, $449d
    ld a, $03
    jr $44a0
    ld a, [$d071]
    ld [de], a
    inc de
    ld bc, $0001
    ld a, $14
    call $400f
    ld a, c
    ld [$d34c], a
    ret
MobileAdapter_StartIdlePacketTransfer::
    xor a
    ld [$d01e], a
    call $4392
    xor a
    ld [$d06b], a
    ld de, $0001
    ld hl, $6000
    ld b, $01
    jp $5f0a
MobileAdapter_RequestHandler0A_Disconnect::
    ld a, [$d021]
    bit 0, a
    jp nz, $4225
    ld a, [$d06a]
    cp $04
    jr z, $4525
    cp $03
    jr z, $4525
    cp $02
    jp nz, $4225
    ld hl, $d022
    bit 4, [hl]
    jr nz, $4506
    ld a, $02
    ld [$d06b], a
    ld a, $a2
    ld [$d01e], a
    ld de, $000a
    ld hl, $603c
    ld b, $05
    call $5f0a
    ld a, $0e
    ld [$d06a], a
    ld hl, $d021
    set 0, [hl]
    res 3, [hl]
    ret
    ld a, [$d007]
    or a
    jr nz, $451e
    ld a, $01
    ld [$d06a], a
    ld hl, $d022
    res 4, [hl]
    ld hl, $d021
    ld a, [hl]
    and $17
    ld [hl], a
    ret
    ld a, $02
    ld [$d06b], a
    jr $44f9
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
    ld a, $0e
    ld [$d06a], a
    jp $4431
MobileAdapter_RequestHandler0C::
    ld b, $25
    call $4595
    or a
    jp nz, $7576
    ret
MobileAdapter_RequestHandler0E::
    ld b, $26
    call $4595
    or a
    jp nz, $7559
    ret
MobileAdapter_RequestHandler10::
    ld b, $27
    call $4595
    or a
    jp nz, $7569
    ret
MobileAdapter_BeginStateRequest::
    ld a, [$d021]
    bit 0, a
    jr nz, $45d8
    ld a, [$d06a]
    cp $01
    jr nz, $45d8
    ld a, [$d035]
    or a
    ret nz
    ld a, b
    ld [$d336], a
    xor a
    ldh [$ff07], a
    ld a, e
    ld [$d06e], a
    ld a, d
    ld [$d06f], a
    xor a
    ld [$d019], a
    ld a, [$d070]
    ld c, a
    call $40dc
    ld hl, $d029
    ld a, $80
    ld [hli], a
    ld a, $d0
    ld [hl], a
    call $44af
    ld a, [$d336]
    ld [$d06a], a
    xor a
    jp $4431
    pop hl
    jp $4225
    assert @ == $45dc
