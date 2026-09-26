include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"
; Mobile Adapter network client / HTTP request and response helpers.
; Physical Bank $30:$6430-$6B20. This continues directly from the earlier
; protocol-template core and stops immediately before the independently-called
; helper at $6B21. Existing packet/string tables remain in the earlier module.

section "Mobile Adapter Network Client Runtime", romx[$6430], bank[$30]
MobileAdapter_StartCloseTCPTransaction::
    ld a, $03
    ld [$d007], a
    ld de, $d347
    ld hl, $6083
    ld b, $06
    call $4000
    ld a, [$d06c]
    ld [de], a
    inc de
    inc b
    call $5f66
    ld a, $a4
    ld hl, $d347
    jp $5f05
MobileAdapter_NetworkClientState_6451::
    dec a
    jr z, $6458
    dec a
    jr z, $6496
    ret
    ld b, $06
    ld de, $d3a3
    call $5f66
    ld a, [$d06e]
    inc a
    cp $03
    jr nz, $648b
    ld a, [$d2bc]
    or a
    jr z, $648b
    ld hl, $d195
    ld a, [hli]
    cp $99
    jr nz, $6480
    ld a, [hli]
    cp $66
    jr nz, $6480
    ld a, [hli]
    cp $23
    jr z, $648b
    ld hl, $d397
    ld de, $d195
    ld b, $10
    call $4000
    ld a, $a3
    ld de, $0010
    ld hl, $d397
    jp $5f05
    ld a, [$d23c]
    cp $a3
    jr z, $64ce
    ld a, [$d022]
    bit 3, a
    jr z, $64ab
    dec [hl]
    ld a, $03
    ld [$d007], a
    ret
    ld a, [$d1af]
    cp $05
    jr c, $64b8
    ld hl, $d021
    set 1, [hl]
    ret
    dec [hl]
    ld hl, $d1af
    inc [hl]
    ld hl, $d022
    set 3, [hl]
    ld hl, $d015
    ld a, [$d020]
    ld [hli], a
    ld a, [$d01f]
    ld [hl], a
    ret
    xor a
    ld [$d1af], a
    ld a, [$d06e]
    inc a
    ld [$d06d], a
    dec a
    jp z, $661c
    dec a
    jp z, $6654
    dec a
    jp z, $6597
    dec a
    jp z, $6566
    call $65c7
    push de
    ld de, $d080
    ld hl, $d027
    ld a, e
    ld [hli], a
    ld a, d
    ld [hli], a
    ld a, e
    ld [hli], a
    ld a, d
    ld [hli], a
    ld a, $01
    ld [$d06e], a
    ld a, $fa
    ld [hli], a
    xor a
    ld [hli], a
    xor a
    ld [hli], a
    ld [hli], a
    pop de
    ld a, $01
    ld [$d194], a
    call $669b
    ld a, $05
    ld [$d06b], a
    call $6534
    ld a, [$d1a5]
    or a
    jr z, $6521
    ld a, $01
    add a, $23
    ld [$d06a], a
    ld a, [$d18a]
    cp $02
    jr nz, $6531
    xor a
    ld [$d1a5], a
    jp $65bf
MobileAdapter_BuildTransferDataPacketFromWorkspace::
    ld b, $fa
    ld hl, $d080
    xor a
    ld [hli], a
    dec b
    jr nz, $653a
    ld a, [$d076]
    ld [$d07c], a
    ld a, [$d077]
    ld [$d07d], a
    ld a, [$d07a]
    ld [$d07e], a
    ld a, [$d07b]
    ld [$d07f], a
    ld a, c
    ld [$d358], a
    ld b, c
    call $5f66
    ld a, $95
    ld hl, $d353
    jp $5f05
MobileAdapter_NetworkClientState_6566::
    call $65c7
    ld a, [$d35a]
    and $01
    or a
    jr nz, $657d
    ld a, [$d18a]
    cp $02
    jr nz, $657d
    ld a, $01
    ld [$d194], a
    call $669b
    ld a, $05
    ld [$d06b], a
    call $6534
    ld a, [$d1a5]
    or a
    jr z, $6590
    ld a, $01
    add a, $21
    ld [$d06a], a
    jr $65bf
MobileAdapter_NetworkClientState_6597::
    call $65c7
    call $669b
    ld a, $05
    ld [$d06b], a
    call $6534
    ld a, [$d18f]
    ld b, a
    ld a, [$d194]
    and $01
    add a, $13
    bit 0, b
    jr z, $65bc
    sub $13
    add a, $1f
    dec b
    sla b
    add a, b
    ld [$d06a], a
MobileAdapter_MarkProtocolCommandActive::
    ld hl, $d021
    set 0, [hl]
    res 2, [hl]
    ret
MobileAdapter_PrepareTransferDataDescriptor::
    ld hl, $d072
    ld a, [hli]
    ld c, a
    ld a, [hli]
    ld b, a
    ld a, [hli]
    ld e, a
    ld d, [hl]
    ld a, [$d194]
    and $01
    xor $01
    ld [$d06b], a
    ld hl, $d027
    ld a, e
    ld [hli], a
    ld a, d
    ld [hli], a
    inc de
    inc de
    ld a, $80
    ld [hli], a
    ld a, $d0
    ld [hli], a
    dec bc
    dec bc
    ld a, $fa
    ld [hli], a
    ld a, $00
    ld [hli], a
    xor a
    ld [hli], a
    ld [hli], a
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
    inc de
    ld a, [$d06c]
    ld [de], a
    inc de
    ret
MobileAdapter_NetworkClientState_661C::
    xor a
    ld [$d06b], a
    ld a, [$d06c]
    ld [$d3bd], a
    ld de, $d3ad
    ld [de], a
    inc de
    ld b, $01
    call $5f66
    call $6734
    ld a, [$d3bc]
    ld b, a
    ld de, $d3bd
    add a, e
    ld e, a
    ld a, $00
    adc a, d
    ld d, a
    call $5f66
    ld hl, $d3a7
    call $67d5
    ld a, $11
    ld [$d06a], a
    ld hl, $d021
    set 0, [hl]
    ret
MobileAdapter_NetworkClientState_6654::
    xor a
    ld [$d06b], a
    ld a, [$d06c]
    ld [$d3ad], a
    ld [$d3ed], a
    ld de, $d3cd
    ld [de], a
    inc de
    ld b, $01
    call $5f66
    call $6734
    ld a, [$d3ec]
    ld b, a
    ld de, $d3ed
    add a, e
    ld e, a
    ld a, $00
    adc a, d
    ld d, a
    call $5f66
    ld a, [$d3ac]
    ld b, a
    ld de, $d3ad
    add a, e
    ld e, a
    ld a, $00
    adc a, d
    ld d, a
    call $5f66
    ld hl, $d3c7
    call $67d5
    ld a, $12
    ld [$d06a], a
    jr $664e
MobileAdapter_AppendHTTPRequestMethod::
    ld bc, $0001
    ld hl, $6110
    ld a, [$d194]
    or a
    call nz, $66ac
    call $4007
    ret
MobileAdapter_SelectHTTPPostMethod::
    ld hl, $6137
    ret
MobileAdapter_AppendHTTPVersion::
    ld hl, $6115
    jp $4007
MobileAdapter_AppendHTTPUserAgent::
    ld hl, $6121
    call $4007
    ld hl, $013f
    ld b, $04
    call $4000
    ld a, $2d
    ld [de], a
    inc de
    ld a, [$014c]
    and $f0
    swap a
    cp $0a
    jr c, $66d7
    add a, $37
    jr $66d9
    or $30
    ld [de], a
    inc de
    ld a, [$014c]
    and $0f
    cp $0a
    jr c, $66e8
    add a, $37
    jr $66ea
    or $30
    ld [de], a
    inc de
    ld a, $07
    add a, c
    ld c, a
    ld hl, $6132
    jp $4007
MobileAdapter_AppendHTTPContentLength::
    xor a
    ld [$d06b], a
    ld hl, $613d
    call $4007
    ld hl, $d1a5
    ld b, $05
    ld a, [hl]
    cp $30
    jr nz, $6711
    inc hl
    dec b
    ld a, $01
    cp b
    jr nz, $6705
    push bc
    call $4000
    ld a, $0d
    ld [de], a
    inc de
    ld a, $0a
    ld [de], a
    inc de
    pop bc
    ld a, b
    add a, $02
    add a, c
    ld c, a
    or c
    ret
MobileAdapter_FinishNetworkClientOperation::
    xor a
    ld [$d06c], a
    ld a, $02
    ld [$d06a], a
    ld hl, $d021
    res 0, [hl]
    ret
MobileAdapter_ResetProtocolSubstate::
    ld a, $ff
    ld [$d06e], a
MobileAdapter_ResetTransferDescriptor::
    push hl
    ld hl, $d02c
    xor a
    ld [hld], a
    ld a, $ff
    ld [hld], a
    ld a, $d0
    ld [hld], a
    ld a, $80
    ld [hl], a
    pop hl
    ret
MobileAdapter_NetworkResponseState_674A::
    dec a
    jr z, $6762
    dec a
    jr z, $679f
    dec a
    jr z, $6754
    ret
    xor a
    ld [$d06d], a
    ld a, $30
    call $625d
    set 1, [hl]
    res 0, [hl]
    ret
    call $67f1
    jr nz, $678a
    ld hl, $d080
    call $6b21
    ld a, $02
    cp d
    jr nz, $67c7
    ld a, $20
    cp e
    jr nz, $67c7
    call $6734
    ld a, [$d3bc]
    add a, $0a
    ld e, a
    ld d, $00
    ld a, $95
    ld hl, $d3b7
    jp $5f05
    ld a, [$d23c]
    cp $9f
    jr z, $67dd
    ld hl, $d06b
    dec [hl]
    xor a
    ld [$d23f], a
    ld hl, $d3a7
    jp $67d5
    call $67f1
    jr nz, $678a
    ld hl, $d080
    call $6b21
    ld a, $02
    cp d
    jr nz, $67c7
    ld a, $50
    cp e
    jr nz, $67c7
    ld a, $03
    ld [$d06a], a
    ld hl, $d021
    ld a, [hl]
    and $d6
    or $80
    ld [hl], a
    xor a
    ld [$d18a], a
    ret
MobileAdapter_StageNetworkStatusWord::
    ld hl, $d010
    ld a, e
    ld [hli], a
    ld [hl], d
    ld a, $02
    ld [$d06b], a
    jp $6430
MobileAdapter_StartTransferDataResponse::
    ld de, $000b
    ld a, $95
    jp $5f05
MobileAdapter_ResetNetworkResponseState::
    ld hl, $d010
    xor a
    ld [hli], a
    ld [hl], a
    xor a
    ld [$d06d], a
    ld a, $30
    call $625d
    set 1, [hl]
    res 0, [hl]
    ret
MobileAdapter_ShiftResponseWindowAndCheckCRLF::
    call $6817
    ld hl, $d032
    ld a, [hli]
    cp $0d
    ret nz
    ld a, [hl]
    cp $0a
    ret nz
    ld a, $20
    ld [hl], a
    ret
MobileAdapter_ShiftResponseWindowAndCheckDotCRLF::
    call $6817
    ld hl, $d02f
    ld a, [hli]
    cp $0d
    ret nz
    ld a, [hli]
    cp $0a
    ret nz
    ld a, [hli]
    cp $2e
    ret nz
    jr $67f7
MobileAdapter_UpdateFiveByteResponseWindow::
    push bc
    push de
    ld hl, $d23f
    ld a, [hl]
    dec a
    jr z, $683d
    ld c, a
    cp $05
    jr nc, $6840
    ld a, $05
    sub c
    ld b, a
    ld e, c
    ld d, $00
    ld hl, $d02f
    add hl, de
    ld de, $d02f
    call $4000
    ld hl, $d241
    ld b, c
    call $4000
    pop de
    pop bc
    ret
    sub $05
    ld c, a
    ld b, $00
    ld hl, $d241
    add hl, bc
    ld b, $05
    ld de, $d02f
    jr $683a
MobileAdapter_NetworkResponseState_6850::
    dec a
    jr z, $6854
    ret
    call $67f1
    jr nz, $68bb
    ld hl, $d080
    ld a, [hli]
    cp $32
    jr nz, $68cd
    ld a, [hli]
    cp $35
    jr nz, $68cd
    call $6734
    ld hl, $d07c
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, [hl]
    or a
    jr z, $68ad
    push hl
    ld hl, $d06b
    dec [hl]
    ld bc, $0001
    ld de, $d35a
    ld hl, $60b0
    call $4007
    pop hl
    ld a, $80
    call $400f
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
    ld hl, $d353
    ld d, $00
    ld e, c
    ld a, $95
    jp $5f05
    ld a, $03
    ld [$d06a], a
    call $68e3
    ld a, $01
    ld [$d18a], a
    ret
    ld a, [$d23c]
    cp $9f
    jp z, $67dd
    ld hl, $d06b
    dec [hl]
    ld hl, $d347
    jp $67d5
MobileAdapter_StageParsedResponseStatus::
    ld hl, $d080
    call $6b21
    ld hl, $d010
    ld a, e
    ld [hli], a
    ld [hl], d
    ld a, $30
    call $625d
    set 1, [hl]
    res 0, [hl]
    ret
MobileAdapter_ClearNetworkActiveFlags::
    ld hl, $d021
    res 0, [hl]
    res 2, [hl]
    ret
MobileAdapter_NetworkResponseState_68EB::
    dec a
    jr z, $6957
    dec a
    jr z, $68f5
    dec a
    jr z, $6923
    ret
    ld a, [$d23c]
    cp $9f
    jp z, $67dd
    call $743e
    ld a, [$d06f]
    or a
    jr nz, $6911
    ld a, $03
    ld [$d06a], a
    ld hl, $d021
    res 0, [hl]
    ret
    call $6734
    ld de, $d34c
    ld a, $01
    ld [de], a
    inc de
    inc de
    ld b, $01
    call $5f66
    jr $6951
    call $67f1
    jr nz, $694d
    ld a, [$d23c]
    cp $9f
    jp z, $67dd
    ld hl, $d080
    call $6b21
    ld a, d
    cp $02
    jr nz, $696b
    ld a, e
    cp $50
    jr nz, $696b
    ld a, $03
    ld [$d06a], a
    call $68e3
    xor a
    ld [$d18a], a
    ret
    ld hl, $d06b
    dec [hl]
    ld hl, $d347
    jp $67d5
    call $67f1
    jr nz, $694d
    ld hl, $d080
    call $6b21
    ld a, d
    cp $03
    jr nz, $696b
    ld a, e
    cp $54
    ret z
    jp $68cd
MobileAdapter_AppendCRLF::
    ld a, $0d
    ld [de], a
    inc de
    inc c
    ld a, $0a
    ld [de], a
    inc de
    inc c
    ret
MobileAdapter_NetworkResponseState_6979::
    dec a
    jr z, $6980
    dec a
    jr z, $6999
    ret
    ld a, [$d23c]
    cp $9f
    jr z, $6996
    call $67f1
    jr z, $6996
    ld hl, $d06b
    dec [hl]
    ld hl, $d367
    jp $67d5
    jp $6430
    xor a
    ld [$d06d], a
    ld a, $02
    ld [$d06a], a
    ld hl, $d021
    res 0, [hl]
    res 7, [hl]
    set 5, [hl]
    ret
MobileAdapter_NetworkResponseState_69AC::
    dec a
    jr z, $69ba
    dec a
    jr z, $69d9
    dec a
    jr z, $69f7
    dec a
    jp z, $6a2d
    ret
    call $67f1
    jr nz, $6a0e
    ld a, [$d080]
    cp $2b
    jr nz, $6a1f
    call $6734
    ld a, [$d3ac]
    add a, $0a
    ld e, a
    ld d, $00
    ld a, $95
    ld hl, $d3a7
    jp $5f05
    ld d, a
    call $67f1
    jr nz, $6a0e
    ld a, [$d080]
    cp $2b
    jr nz, $6a1f
    call $6734
    ld a, [$d3ec]
    add a, $0a
    ld e, a
    ld a, $95
    ld hl, $d3e7
    jp $5f05
    call $67f1
    jr nz, $6a0e
    ld a, [$d080]
    cp $2b
    jr nz, $6a1f
    ld a, $04
    ld [$d06a], a
    call $68e3
    set 7, [hl]
    ret
    ld a, [$d23c]
    cp $9f
    jr z, $6a52
    ld hl, $d06b
    dec [hl]
    ld hl, $d3c7
    jp $67d5
    ld a, [$d06b]
    ld [$d367], a
    ld a, $03
    ld [$d06b], a
    jp $6430
    xor a
    ld [$d06d], a
    ld de, $0002
    ld a, [$d367]
    cp $01
    jr z, $6a3c
    inc de
    ld hl, $d021
    set 1, [hl]
    res 0, [hl]
    ld hl, $d00f
    ld a, $31
    ld [hli], a
    ld a, e
    ld [hli], a
    ld [hl], d
    ld a, $05
    ld [$d06a], a
    ret
MobileAdapter_ResetNetworkStatusAndReturn::
    ld hl, $d010
    xor a
    ld [hli], a
    ld [hl], a
    xor a
    ld [$d06d], a
    ld a, $31
    call $625d
    set 1, [hl]
    res 0, [hl]
    ret
MobileAdapter_NetworkResponseState_6A66::
    dec a
    jr z, $6a6a
    ret
    call $67f1
    jr nz, $6aa5
    ld hl, $d080
    ld a, [hli]
    cp $2b
    jr nz, $6ab6
    ld a, [hli]
    cp $20
    jr nz, $6a77
    call $6abc
    ld a, [$d06e]
    ld c, a
    ld a, [$d06f]
    ld b, a
    ld a, e
    ld [bc], a
    inc bc
    ld a, d
    ld [bc], a
    call $6abc
    ld hl, $d06e
    ld a, [hli]
    ld h, [hl]
    ld l, a
    inc hl
    inc hl
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
    jr z, $6a52
    ld hl, $d06b
    dec [hl]
    ld hl, $d3c7
    jp $67d5
    ld de, $0005
    jp $6a3c
MobileAdapter_ParseDecimal24::
    ld a, [$d072]
    push af
    ld a, [$d073]
    push af
    ld a, [$d074]
    push af
    ld bc, $0000
    ld de, $0000
    ld a, [hli]
    cp $0d
    jr z, $6b14
    cp $20
    jr z, $6b14
    and $0f
    ld b, a
    sla e
    rl d
    rl c
    ld a, e
    ld [$d072], a
    ld a, d
    ld [$d073], a
    ld a, c
    ld [$d074], a
    sla e
    rl d
    rl c
    sla e
    rl d
    rl c
    ld a, [$d072]
    add a, e
    ld e, a
    ld a, [$d073]
    adc a, d
    ld d, a
    ld a, [$d074]
    adc a, c
    ld c, a
    ld a, b
    add a, e
    ld e, a
    ld a, $00
    adc a, d
    ld d, a
    ld a, $00
    adc a, c
    ld c, a
    jr $6ace
    pop af
    ld [$d074], a
    pop af
    ld [$d073], a
    pop af
    ld [$d072], a
    ret
    assert @ == $6b21
