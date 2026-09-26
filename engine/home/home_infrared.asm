; Game Boy Color infrared hardware primitives.
;
; This ROM0 layer is the timing-sensitive backend used by Bank $18 infrared
; session/framing code. The routines drive rRP ($FF56), encode/decode bytes as
; timed IR pulses, maintain transfer status/checksum scratch, and poll the joypad
; while transfers are in progress.

section "Infrared Hardware Runtime", rom0[$1214]
InfraredHW_InitializeTiming::
    xor a
    ld [$c908], a
    ld [$c909], a
    ld b, a
    inc a
    jr nz, $121c
    inc b
    jr nz, $121c
    ld hl, $c902
    ldh a, [$ff4d]
    bit 7, a
    jr z, $123d
    ld [hl], $0e
    inc hl
    ld [hl], $14
    inc hl
    ld [hl], $08
    inc hl
    ld [hl], $0d
    inc hl
    ld [hl], $0c
    inc hl
    ld [hl], $dc
    ret
    ld [hl], $06
    inc hl
    ld [hl], $08
    inc hl
    ld [hl], $02
    inc hl
    ld [hl], $04
    inc hl
    ld [hl], $05
    inc hl
    ld [hl], $6e
    ret
InfraredHW_EnableReceiver::
    ld a, $c0
    call $134f
    ld a, $01
    ld [$c900], a
    ret
InfraredHW_DisablePort::
    xor a
    call $134f
    ret
InfraredHW_WaitReceiveBitSet::
    inc d
    ret z
    ldh a, [c]
    bit 1, a
    jr z, $125f
    or a
    ret
InfraredHW_WaitReceiveBitClear::
    inc d
    ret z
    ldh a, [c]
    bit 1, a
    jr nz, $1268
    or a
    ret
InfraredHW_WaitReceiveBitClearExtended::
    ld e, $06
    inc d
    jr z, $127d
    ldh a, [c]
    bit 1, a
    jr nz, $1273
    or a
    ret
    dec e
    jr nz, $1276
    ret
InfraredHW_DrivePulseC1::
    ld a, $c1
    ldh [c], a
    ld a, d
    dec a
    jr nz, $1285
    ret
InfraredHW_DrivePulseC0::
    ld a, $c0
    ldh [c], a
    ld a, d
    dec a
    jr nz, $128d
    ret
InfraredHW_DrivePulseC0Long::
    ld a, $c0
    ldh [c], a
    ld a, d
    ld e, $05
    dec a
    jr nz, $1297
    dec e
    ld a, d
    jr nz, $1297
    ret
InfraredHW_NegotiateLinkRole::
    ld d, $00
    ld e, d
    ld a, $01
    ld [$c900], a
    call $1535
    ld b, $02
    ld c, $56
    ld a, [$c909]
    bit 1, a
    jr z, $12bb
    ld a, $ff
    ld [$c901], a
    ret
    bit 0, a
    jr nz, $1302
    ldh a, [c]
    and b
    jr nz, $12a7
InfraredHW_LinkRoleReceiveFirst::
    ld b, $1a
    ld c, $56
    ld d, $00
    call $1271
    jp z, $1423
    ld d, $00
    call $125f
    jp z, $1423
    call $1268
    jp z, $1423
    call $125f
    jp z, $1423
    ld a, $8b
    ld [$c901], a
    ld a, [$c907]
    ld d, a
    call $1291
    ld d, $1a
    call $1281
    ld d, $34
    call $1289
    ld d, $1a
    call $1281
    call $1289
    ret
InfraredHW_LinkRoleSendFirst::
    ld a, $02
    ld [$c900], a
    ld b, $1a
    ld c, $56
    ld a, [$c907]
    ld d, a
    call $1291
    ld d, $1a
    call $1281
    ld d, $34
    call $1289
    ld d, $1a
    call $1281
    call $1289
    ld d, $00
    call $1271
    jp z, $1423
    ld d, $00
    call $125f
    jp z, $1423
    ld d, $00
    call $1268
    jp z, $1423
    ld d, $00
    call $125f
    jp z, $1423
    ld d, $1a
    call $1289
    ld a, $8b
    ld [$c901], a
    ret
InfraredHW_WritePortAndResetStatus::
    ldh [$ff56], a
    ld a, $ff
    ld [$c901], a
    ret
InfraredHW_SendBuffer::
    xor a
    ld [$c8fb], a
    ld [$c8fc], a
    push hl
    push bc
    ld a, [$c907]
    ld d, a
    call $1291
    ld hl, $c8fd
    ld a, $5a
    ld [hli], a
    ld [hl], b
    dec hl
    ld b, $02
    ld d, $1e
    call $1289
    call $13ac
    pop bc
    pop hl
    call $152f
    call $13ac
    ld a, [$c8fb]
    ld [$c8fd], a
    ld a, [$c8fc]
    ld [$c8fe], a
    push hl
    ld hl, $c8fd
    ld b, $02
    call $13ac
    ld hl, $c901
    ld b, $01
    call $14a5
    ld a, [$c8fd]
    ld [$c8fb], a
    ld a, [$c8fe]
    ld [$c8fc], a
    pop hl
    ret
InfraredHW_SendRawBytes::
    ld c, $56
    ld d, $16
    call $1289
    call $1281
    call $1289
    ld a, b
    cpl
    ld b, a
    inc b
    jr z, $1411
    ld a, $08
    ld [$c8fa], a
    ld a, [hli]
    ld e, a
    ld a, [$c8fb]
    add a, e
    ld [$c8fb], a
    jr nc, $13d8
    ld a, [$c8fc]
    inc a
    ld [$c8fc], a
    jr $13db
    call $152f
    ld a, e
    rlca
    ld e, a
    jr nc, $13f0
    ld a, [$c902]
    ld d, a
    call $1281
    ld a, [$c903]
    ld d, a
    call $1289
    jr $13fe
    ld a, [$c904]
    ld d, a
    call $1281
    ld a, [$c905]
    ld d, a
    call $1289
    ld a, [$c8fa]
    dec a
    ld [$c8fa], a
    jr z, $140f
    call $1530
    call $1530
    jr $13db
    jr $13bc
    call $152f
    call $152f
    call $1530
    ld d, $16
    call $1281
    call $1289
    ret
InfraredHW_SetTimeoutError::
    ld a, $10
    ld [$c901], a
    ret
InfraredHW_SetChecksumError::
    ld a, [$c901]
    or $04
    ld [$c901], a
    ret
InfraredHW_SetFramingError::
    ld a, [$c901]
    or $20
    ld [$c901], a
    ret
InfraredHW_ReceiveBuffer::
    xor a
    ld [$c8fb], a
    ld [$c8fc], a
    push bc
    push hl
    ld hl, $c8fd
    ld b, $02
    call $14a5
    ld a, [$c8fe]
    ld [$c8ff], a
    ld b, a
    pop hl
    pop af
    cp b
    jp c, $1432
    ld a, [$c8fd]
    cp $5a
    jp nz, $1432
    call $14a5
    ld a, [$c8fb]
    ld d, a
    ld a, [$c8fc]
    ld e, a
    push hl
    push de
    ld hl, $c8fd
    ld b, $02
    call $14a5
    pop de
    ld hl, $c8fd
    ld a, [hli]
    xor d
    ld b, a
    ld a, [hl]
    xor e
    or b
    jr z, $148a
    ld a, [$c901]
    or $04
    ld [$c901], a
    push de
    ld a, [$c907]
    ld d, a
    call $1291
    ld hl, $c901
    ld b, $01
    call $13ac
    pop de
    pop hl
    ld a, d
    ld [$c8fb], a
    ld a, e
    ld [$c8fc], a
    ret
InfraredHW_ReceiveRawBytes::
    ld c, $56
    ld d, $00
    call $1271
    jp z, $1423
    ld d, $00
    call $125f
    jp z, $1423
    ld d, $00
    call $1268
    jp z, $1423
    call $1530
    call $1530
    push af
    pop af
    ld a, b
    cpl
    ld b, a
    inc b
    jr z, $1517
    ld a, $08
    ld [$c8fa], a
    ld d, $00
    call $125f
    call $1268
    ld a, [$c906]
    cp d
    jr nc, $14e6
    ld a, e
    set 0, a
    ld e, a
    jr $14ea
    ld a, e
    res 0, a
    ld e, a
    ld a, [$c8fa]
    dec a
    ld [$c8fa], a
    jr z, $14fe
    ld a, e
    rlca
    ld e, a
    call $1530
    call $1530
    jr $14d2
    ld a, e
    ld [hli], a
    ld a, [$c8fb]
    add a, e
    ld [$c8fb], a
    jr nc, $1512
    ld a, [$c8fc]
    inc a
    ld [$c8fc], a
    jr $1515
    call $152f
    jr $14ca
    ld d, $00
    call $125f
    jp z, $1423
    ld d, $11
    call $1289
    ret
InfraredHW_SendControlByte::
    ld b, $00
    jp $1357
InfraredHW_ReceiveControlByte::
    ld b, $00
    jp $143b
InfraredHW_TimingRet::
    ret
InfraredHW_TimingPadding::
    jr z, $1532
    jr nz, $1534
    ret
InfraredHW_PollJoypad::
    ld a, $20
    ldh [$ff00], a
    ldh a, [$ff00]
    ldh a, [$ff00]
    cpl
    and $0f
    swap a
    ld b, a
    ld a, $10
    ldh [$ff00], a
    ldh a, [$ff00]
    ldh a, [$ff00]
    ldh a, [$ff00]
    ldh a, [$ff00]
    ldh a, [$ff00]
    ldh a, [$ff00]
    cpl
    and $0f
    or b
    ld c, a
    ld a, [$c908]
    xor c
    and c
    ld [$c909], a
    ldh [$ff91], a
    ld a, c
    ld [$c908], a
    ldh [$ff90], a
    ld a, $30
    ldh [$ff00], a
    ret
    assert @ == $156d
