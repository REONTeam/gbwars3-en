include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"

; Mobile Adapter LCD/timer-driven transmit and packet-state service.
; Physical Bank $30:$58E4-$5FF5. The next bytes at $5FF6-$5FFF are padding;
; structured Mobile protocol/template data begins at $6000.

section "Mobile Adapter LCD Timer Service", romx[$58e4], bank[$30]
MobileAdapter_DriverLCDStatInterrupt::
    ld a, [$d00b]
    cp $04
    call z, $5b40
    call $614e
    ld hl, $d007
    ld a, [hli]
    cp $02
    jr c, $592d
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a
    and b
    cp $ff
    jr z, $5904
    ld a, c
    or b
    jr nz, $592d
    ld hl, $d007
    ld a, $06
    cp [hl]
    jp z, $5b3f
    ld [hl], a
    ld a, $10
    ld [$d00f], a
    xor a
    ld [$d000], a
    ld hl, $d022
    res 0, [hl]
    ld hl, $d021
    ld a, [hl]
    and $0f
    or $02
    ld [hl], a
    ld a, $10
    ld [$d00f], a
    jp $5b3f
    ld a, [$d000]
    cp $01
    jp z, $5b25
    cp $03
    jp z, $5a30
    ld a, [$d007]
    cp $01
    jp c, $5b3f
    ld hl, $d015
    dec [hl]
    jp nz, $5b3f
    inc hl
    dec [hl]
    jp nz, $5b3f
    ld hl, $d007
    ld a, [$d022]
    bit 3, a
    jp nz, $5a11
    bit 4, a
    jr nz, $59a2
    ld a, [hl]
    cp $01
    jp z, $59f6
    cp $0a
    jr z, $598a
    cp $08
    jr z, $5983
    ld a, [$d06a]
    cp $2a
    jr z, $5997
    cp $0d
    jr nz, $597d
    ld a, [$d06b]
    cp $04
    jr nc, $59a2
    call $5f9a
    jp $5b3f
    ld a, [$d005]
    ld [hl], a
    jp $5b3f
    xor a
    ld [hl], a
    ld hl, $d021
    res 0, [hl]
    call $568d
    jp $5b3f
    xor a
    ld [hl], a
    ld [$d021], a
    call $568d
    jp $5b3f
    ld b, a
    ld [hl], a
    or a
    jp z, $5b3f
    ld a, [$d022]
    bit 7, a
    jr nz, $59c4
    ld a, [$d021]
    bit 3, a
    jr nz, $597d
    ld de, $000b
    ld hl, $6072
    ld a, $95
    call $5f05
    jp $5b3f
    ld a, [$d021]
    bit 3, a
    jr nz, $59e3
    ld a, [$d34c]
    add a, $0a
    ld e, a
    ld d, $00
    ld a, $95
    ld [$d01e], a
    ld hl, $d347
    ld b, $05
    call $5f0a
    jp $5b3f
    ld hl, $d021
    set 1, [hl]
    res 0, [hl]
    ld hl, $d022
    res 7, [hl]
    ld a, $21
    ld [$d00f], a
    jr $59af
    ld a, $90
    ld [$d01e], a
    ld [$d008], a
    ld b, $05
    ld de, $0012
    ld hl, $6001
    call $5f0a
    ld a, $01
    ld [$d006], a
    jp $5b3f
    ld a, [hl]
    cp $06
    jp z, $5b3f
    ld hl, $d022
    res 3, [hl]
    res 0, [hl]
    ld hl, $d01a
    ld a, [hli]
    ld e, a
    ld a, [hli]
    ld d, a
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld b, $05
    call $5f0a
    jp $5b3f
    ld hl, $d00b
    ld a, [hld]
    or a
    jr z, $5a4b
    cp $03
    jr nz, $5a44
    ld a, [hl]
    cp $02
    jr z, $5abd
    cp $03
    jr z, $5ac1
    ld a, $4b
    ldh [$ff01], a
    jp $5b32
    ld hl, $d015
    dec [hl]
    jr nz, $5a44
    inc hl
    dec [hl]
    jr nz, $5a44
    inc hl
    dec [hl]
    jr z, $5a67
    ld hl, $d01f
    ld a, [hli]
    ld d, a
    ld a, [hl]
    ld hl, $d015
    ld [hli], a
    ld a, d
    ld [hli], a
    jr $5a44
    di
    ld a, [$d06a]
    cp $2a
    jr z, $5aac
    ld hl, $d1b2
    inc [hl]
    ld a, [hl]
    cp $01
    jr z, $5a95
    ld hl, $d022
    res 5, [hl]
    res 0, [hl]
    ld hl, $d021
    res 4, [hl]
    ld a, $00
    ld [$d005], a
    ld a, $29
    ld [$d06a], a
    ld a, $01
    ld [$d006], a
    jr $5aac
    ld a, $29
    ld [$d06a], a
    xor a
    ld [$d006], a
    ld [$d06b], a
    ld [$d00b], a
    ld [$d000], a
    ld a, $08
    ld [$d007], a
    call $4029
    call $5656
    ld hl, $d022
    res 5, [hl]
    res 0, [hl]
    ei
    jp $5b3f
    ld a, $80
    jr $5a46
    ld a, [$d014]
    or a
    jr nz, $5acf
    ld a, [$d23c]
    xor $80
    jp $5a46
    ld hl, $d019
    inc [hl]
    ld a, $03
    cp [hl]
    jr z, $5b02
    call $4029
    ld a, $03
    ld [$d000], a
    xor a
    ld hl, $d00a
    ld [hli], a
    ld [hli], a
    ld [hl], a
    ld hl, $d015
    ld a, [$d020]
    ld [hli], a
    ld a, [$d01f]
    ld [hli], a
    ld a, [$d022]
    bit 0, a
    jr z, $5afd
    ld a, $0b
    jr $5aff
    ld a, $20
    ld [hli], a
    jr $5b20
    ld hl, $d006
    xor a
    ld [hli], a
    ld [$d000], a
    ld a, $06
    ld [hl], a
    ld hl, $d021
    set 1, [hl]
    ld a, $15
    ld [$d00f], a
    ld a, $02
    ld [$d010], a
    xor a
    ld [$d011], a
    ld a, $f1
    jp $5a46
MobileAdapter_TimerStartSerialByteTransfer::
    ld hl, $d003
    ld a, [hli]
    ld e, a
    ld d, [hl]
    ld a, [de]
    ldh [$ff01], a
    inc de
    ld a, d
    ld [hld], a
    ld [hl], e
    ld hl, $d022
    set 1, [hl]
    ld a, $03
    ldh [$ff02], a
    ld a, $83
    ldh [$ff02], a
MobileAdapter_TimerServiceReturn::
    ret
MobileAdapter_ProcessCompletedPacketState::
    xor a
    ld [$d019], a
    ld [$d00b], a
    ld hl, $d1b1
    ld [hli], a
    ld [hl], a
    ld [$d000], a
    ld hl, $d022
    res 5, [hl]
    bit 0, [hl]
    jr z, $5b5d
    ld a, [$d22f]
    jr $5b60
    ld a, [$d23c]
    cp $9f
    jr nz, $5b66
    ld a, $95
    ld b, a
    ld hl, $5e2b
    push hl
    cp $ee
    jp z, $5e2e
    ld a, [$d01e]
    cp $ff
    jp z, $5efb
    cp $95
    jp z, $5c1a
    cp $a8
    jp z, $5d26
    cp $a3
    jr z, $5bc1
    cp $a4
    jr z, $5bc1
    cp $93
    jr z, $5be3
    cp $99
    jr z, $5bf3
    cp $9a
    jr z, $5c09
    cp $97
    jp z, $5d73
    cp $a1
    jr z, $5bd3
    cp $a2
    jr z, $5bcd
    cp $90
    jp z, $5d3c
    cp $94
    jp z, $5d68
    cp $92
    jp z, $5d68
    ld hl, $d022
    res 0, [hl]
    ld a, $0a
    ld [$d007], a
    xor a
    ld [$d000], a
    ret
    ld a, [$d240]
    ld [$d06c], a
    ld a, $04
    ld [$d007], a
    ret
    ld a, $03
    ld [$d007], a
    ret
    ld a, $04
    ld [$d007], a
    ld de, $d023
    ld hl, $d240
    ld b, $04
    jp $4000
    ld a, $02
    ld [$d007], a
    ld hl, $d022
    res 4, [hl]
    ld hl, $d021
    res 4, [hl]
    ret
    ld hl, $d029
    ld a, [hli]
    ld d, [hl]
    ld e, a
    ld hl, $d23f
    ld a, [hli]
    dec a
    ld b, a
    inc hl
    call $4000
    ld a, $02
    ld [$d007], a
    ret
    ld de, $d072
    ld hl, $d240
    ld b, $02
    call $4000
    ld a, $02
    ld [$d007], a
    ret
MobileAdapter_HandleTransferDataResponseState::
    ld a, [$d23c]
    cp $9f
    jp z, $5d0a
    ld a, [$d06f]
    ld b, a
    ld a, [$d06e]
    or b
    jp z, $5d0a
    ld hl, $d02b
    ld a, [hli]
    ld e, a
    ld d, [hl]
    ld a, [$d23f]
    dec a
    jp z, $5d0a
    ld c, a
    ld a, [$d022]
    bit 4, a
    jp z, $5cc5
    ld a, [$d192]
    or a
    jr nz, $5c8c
    ld a, [$d241]
    or a
    jr z, $5c53
    cp $81
    jr c, $5c55
    ld a, $80
    ld b, a
    ld a, [$d23f]
    dec a
    dec a
    cp b
    jr c, $5c71
    ld hl, $d021
    set 3, [hl]
    ld hl, $d193
    ld a, $01
    ld [hli], a
    ld a, [$d23f]
    dec a
    ld [hl], a
    jp $5d0a
    ld hl, $d192
    or a
    jr z, $5c86
    ld [hld], a
    ld [hl], b
    ld b, a
    ld hl, $d242
    ld de, $d080
    call $4000
    jp $5d0a
    ld a, $ff
    ld [hld], a
    ld [hl], b
    jr $5d0a
    cp $ff
    jr nz, $5ca0
    ld hl, $d191
    ld a, [hli]
    ld b, a
    ld a, [$d23f]
    dec a
    cp b
    jr nc, $5c5e
    jr z, $5c5e
    xor a
    ld [hl], a
    ld hl, $d191
    ld a, [hli]
    sub [hl]
    ld b, a
    ld a, [$d23f]
    dec a
    cp b
    jr nc, $5c5e
    jr z, $5c5e
    ld b, a
    ld l, [hl]
    ld h, $00
    add a, l
    ld [$d192], a
    ld de, $d080
    add hl, de
    ld e, l
    ld d, h
    ld hl, $d241
    call $4000
    jr $5d0a
    xor a
    cp d
    jr nz, $5cdd
    ld a, c
    cp e
    jr c, $5cdd
    jr z, $5cdd
    ld a, [$d021]
    set 2, a
    ld [$d021], a
    ld a, c
    sub e
    ld c, e
    ld e, a
    jr $5ce4
    ld a, e
    sub c
    ld e, a
    ld a, d
    sbc a, $00
    ld d, a
    ld a, d
    ld [hld], a
    ld [hl], e
    ld a, [$d029]
    ld e, a
    ld a, [$d02a]
    ld d, a
    ld hl, $d241
    ld a, c
    or a
    jr z, $5d0a
    ld b, a
    call $4000
    ld hl, $d029
    ld a, e
    ld [hli], a
    ld [hl], d
    ld de, $0003
    add hl, de
    ld a, [hl]
    add a, c
    ld [hli], a
    jr nc, $5d0a
    inc [hl]
    ld a, [$d022]
    bit 4, a
    jr z, $5d1f
    bit 7, a
    jr z, $5d1f
    ld hl, $d022
    res 7, [hl]
    ld hl, $d021
    res 0, [hl]
    ld a, [$d005]
    ld [$d007], a
    ret
MobileAdapter_CopyPacketStateToBuffer::
    ld a, [$d029]
    ld e, a
    ld a, [$d02a]
    ld d, a
    ld hl, $d240
    ld b, $04
    call $4000
    ld a, $04
    ld [$d007], a
    ret
MobileAdapter_TestResponseSignature::
    ld de, $d23f
    ld hl, $6006
    ld b, $09
    ld a, [de]
    inc de
    cp [hl]
    jr nz, $5d4d
    inc hl
    dec b
    jr nz, $5d44
    ld a, b
    or a
    jr nz, $5d5c
    ld a, [$d24a]
    cp $80
    jr c, $5d65
    cp $90
    jr nc, $5d65
    ld [$d018], a
    ld a, $02
    ld [$d007], a
    ret
    xor a
    jr $5d5c
    ld a, $03
    ld [$d007], a
    ld hl, $d021
    set 4, [hl]
    ret
MobileAdapter_UpdateConnectionResponseState::
    ld hl, $d022
    bit 0, [hl]
    jr z, $5dc3
    ld a, [$d005]
    ld [$d007], a
    ld a, [$d233]
    ld b, a
    call $5ddc
    call $5e18
    res 0, [hl]
    ld a, b
    cp $07
    jr z, $5dac
    or a
    ret nz
    ld hl, $d021
    res 4, [hl]
    set 1, [hl]
    ld a, [$d022]
    bit 4, a
    jr nz, $5dbe
    ld a, $23
    ld [$d00f], a
    ld a, $06
    ld [$d007], a
    ret
    ld hl, $d021
    res 4, [hl]
    set 1, [hl]
    ld a, $11
    ld [$d00f], a
    ld a, $06
    ld [$d007], a
    ret
    xor a
    ld [$d007], a
    ret
    ld hl, $d06e
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, [$d240]
    ld b, a
    call $5ddc
    call $5e18
    ld a, b
    ld [hl], a
    ld a, [$d005]
    ld [$d007], a
    ret
MobileAdapter_ClassifyConnectionState::
    cp $ff
    jr z, $5dea
    or a
    ret z
    cp $04
    jr z, $5ded
    cp $05
    jr z, $5e15
    ld b, $07
    ret
    ld b, $05
    ld a, [$d022]
    bit 0, a
    jr z, $5dfb
    ld a, [$d06a]
    jr $5dfe
    ld a, [$d185]
    cp $04
    ret z
    cp $1c
    ret z
    cp $1a
    ret z
    dec b
    cp $03
    ret z
    ld b, $01
    ld a, [$d022]
    bit 4, a
    ret z
    inc b
    ret
    ld b, $03
    ret
MobileAdapter_StoreConnectionStateBits::
    ld a, b
    and $07
    rrca
    rrca
    rrca
    push hl
    ld l, a
    ld a, [$d021]
    and $1f
    or l
    ld [$d021], a
    pop hl
    ret
    db $c3, $29, $40
MobileAdapter_ApplyReceivedCommandState::
    ld a, [$d01e]
    cp $ff
    jp z, $5efb
    ld a, [$d06a]
    cp $0d
    jr z, $5e4b
    cp $2a
    jr z, $5e4b
    ld a, $06
    ld [$d007], a
    ld hl, $d021
    set 1, [hl]
    ld a, [$d022]
    bit 0, a
    jr z, $5e57
    ld hl, $d233
    jr $5e5a
    ld hl, $d240
    ld a, [hli]
    ld [$d00e], a
    cp $10
    jr z, $5e8b
    cp $12
    jr z, $5e8f
    cp $13
    jr z, $5ea4
    cp $15
    jr z, $5eb1
    cp $19
    jr z, $5edf
    cp $21
    jr z, $5ee3
    cp $22
    jr z, $5ea4
    cp $23
    jr z, $5ee7
    cp $24
    jr z, $5ef0
    cp $28
    jr z, $5eec
    ld a, [hl]
    ld [$d00f], a
    ret
    ld a, $10
    jr $5e87
    ld a, [hl]
    or $00
    jr z, $5ea0
    cp $02
    jr z, $5e9c
    ld a, $13
    jr $5e87
    ld a, $17
    jr $5e87
    ld a, $12
    jr $5e87
    ld hl, $d021
    res 1, [hl]
    res 4, [hl]
    ld a, $02
    ld [$d007], a
    ret
    ld a, [hl]
    cp $01
    jr nz, $5ed6
    ld a, [$d022]
    bit 4, a
    jr z, $5ed6
    res 4, a
    ld [$d022], a
    ld hl, $d021
    ld a, [hl]
    and $0f
    or $02
    ld [hl], a
    ld a, $23
    ld [$d00f], a
    ld a, $06
    ld [$d007], a
    ret
    ld hl, $d022
    res 5, [hl]
    ld a, $24
    jr $5e87
    ld a, $14
    jr $5e87
    ld a, $22
    jr $5e87
    ld hl, $d021
    res 1, [hl]
    ld a, $24
    jr $5e87
    ld hl, $d021
    res 1, [hl]
    ld a, $03
    ld [$d007], a
    ret
MobileAdapter_RestoreRequestState::
    ld a, [$d005]
    ld [$d007], a
    ret
    db $11, $0a, $00
MobileAdapter_BeginPacketOperation::
    ld [$d01e], a
    ld b, $05
MobileAdapter_StartPacketOperation::
    call $40b4
    ret c
    ld a, [$d000]
    cp $00
    jr z, $5f1a
    call $4225
    scf
    ret
    ldh a, [$ff02]
    and $80
    jr nz, $5f1a
    di
    ld a, [$d01e]
    cp $ff
    jr z, $5f38
    ld a, l
    ld [$d01c], a
    ld a, h
    ld [$d01d], a
    ld a, e
    ld [$d01a], a
    ld a, d
    ld [$d01b], a
    ld a, e
    ld [$d001], a
    ld a, d
    ld [$d002], a
    ld a, l
    ld [$d003], a
    ld a, h
    ld [$d004], a
    ld hl, $d007
    ld a, [hl]
    cp b
    jr z, $5f52
    ld [$d005], a
    ld a, b
    ld [$d007], a
    xor a
    ld [$d006], a
    ld a, $01
    ld [$d000], a
    ld hl, $d022
    set 5, [hl]
    ei
MobileAdapter_BuildPacketHeader::
    ret
    db $d5, $21, $00, $00, $48, $af, $b8, $28, $05, $cd, $90, $5f, $20, $fb, $06, $04
    db $cd, $90, $5f, $20, $fb, $5d, $54, $21, $0a, $00, $09, $4d, $44, $e1, $7a, $22
    db $7b, $22, $3e, $80, $22, $af, $77, $59, $50, $c9
MobileAdapter_AccumulatePacketChecksum::
    dec de
    ld a, [de]
    add a, l
    ld l, a
    ld a, $00
    adc a, h
    ld h, a
    dec b
    ret
MobileAdapter_TestTransferCompletion::
    ld hl, $d022
    bit 0, [hl]
    ret nz
    ld a, [$d007]
    cp $02
    jr c, $5fce
    cp $05
    jr z, $5fce
    cp $06
    jr nz, $5fd0
    ld a, [$d00f]
    cp $22
    jr z, $5fce
    cp $23
    jr z, $5fce
    cp $26
    jr z, $5fce
    swap a
    and $0f
    cp $01
    jr z, $5fce
    cp $00
    jr z, $5fce
    cp $08
    jr nz, $5fd0
    scf
    ret
    ld b, $05
    ld hl, $d01e
    ld a, [hl]
    cp $ff
    jr z, $5fec
    ld a, $97
    ld [hl], a
    ld hl, $602d
    ld de, $000a
    call $5f0a
    ld hl, $d022
    set 0, [hl]
    ret
    ld hl, $6001
    ld de, $0012
    jp $5f0a
    db $00
    assert @ == $5ff6
