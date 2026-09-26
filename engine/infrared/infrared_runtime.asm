include "macros/macros.inc"

; Game Boy Color infrared communication runtime.
; Byte-authoritative ownership is split around the intervening IR UI/text layer.
; The high-level API uses $C614-$C618 session/result state and the literal
; nine-byte peer signature "GBoyWARS3". The low-level transport drives rRP
; ($FF56) through the existing ROM0 IR helpers and exchanges framed payloads.
;
; The retail instruction stream remains as byte rows at
; stable routine boundaries. Later work can convert each routine to mnemonics
; as the ROM0 $12xx-$15xx helper contracts are sourced, without changing layout.

section "Infrared Session and Transfer API", romx[$53d7], bank[$18]
Infrared_ResetSessionState::
    xor a
    ld [$c615], a
    ld [$c618], a
    ret
Infrared_StartSession::
    call $10fd
    jr c, $53ff
    cp $01
    jr nz, $53f5
    call $58ed
    ld a, $01
    ld [$c618], a
    xor a
    ld [$c615], a
    ret
    call $5430
    xor a
    ld a, $01
    ld [$c615], a
    ret
    call $5430
    ld a, $01
    ld [$c614], a
    scf
    ret
Infrared_CheckSessionHealth::
    ld a, [$c615]
    or a
    jr z, $542b
    ld hl, $c618
    ld de, $c618
    ld c, $02
    call $5b51
    jr c, $5421
    call $59df
    jr nc, $542b
    call $5430
    ld a, $01
    ld [$c614], a
    scf
    ret
    xor a
    ld [$c614], a
    ret
Infrared_WaitInputRelease::
    ret
    db $cd, $ac, $05, $f0, $90, $e6, $01, $20, $f6, $cd, $ac, $05, $f0, $90, $e6, $01
    db $20, $ed, $c9
Infrared_ResetHardware::
    call $58e3
    ret
Infrared_CheckLinkReady::
    ld a, [$c615]
    or a
    jr nz, $5455
    call $58ed
    jr c, $545f
    jr $545a
    call $5a21
    jr c, $545f
    xor a
    ld [$c614], a
    ret
    call $5430
    ld a, $02
    ld [$c614], a
    scf
    ret
Infrared_VerifyPeerSignature::
    db $c5, $f0, $82, $f5, $3e, $04, $e0, $82, $e0, $70, $cd, $81, $54, $cb, $11, $f1
    db $e0, $82, $e0, $70, $cb, $19, $c1, $c9, $0e, $09, $21, $e5, $54, $11, $6e, $db
    db $2a, $12, $13, $0d, $20, $fa, $fa, $15, $c6, $b7, $20, $0d, $cd, $ed, $58, $38
    db $3d, $fa, $18, $c6, $b7, $28, $37, $18, $1f, $21, $6e, $db, $11, $77, $db, $0e
    db $09, $cd, $c2, $5a, $38, $28, $21, $6e, $db, $11, $77, $db, $0e, $09, $cd, $51
    db $5b, $38, $1b, $cd, $df, $59, $38, $16, $0e, $09, $21, $6e, $db, $11, $77, $db
    db $1a, $be, $20, $14, $13, $23, $0d, $20, $f7, $af, $ea, $14, $c6, $c9, $cd, $30
    db $54, $3e, $02, $ea, $14, $c6, $37, $c9, $3e, $03, $18, $f7
Infrared_PeerSignature::
    db $47, $42, $6f, $79, $57, $41, $52, $53, $33
Infrared_ComparePeerByte::
    ld [$c616], a
    ld a, [$c615]
    or a
    jr nz, $5504
    call $58ed
    jr c, $553c
    ld a, [$c618]
    or a
    jr z, $553c
    jr $5523
    ld hl, $c616
    ld de, $c617
    ld c, $01
    call $5ac2
    jr c, $553c
    ld hl, $c616
    ld de, $c617
    ld c, $01
    call $5b51
    jr c, $553c
    call $59df
    jr c, $553c
    ld e, $00
    ld a, [$c616]
    ld hl, $c617
    cp [hl]
    jr z, $5536
    jr c, $5534
    ld e, $01
    jr $5536
    ld e, $ff
    xor a
    ld [$c614], a
    ld a, e
    ret
    call $5430
    ld a, $02
    ld [$c614], a
    scf
    ret
Infrared_SendBuffer::
    ldh a, [$ff82]
    push af
    ld a, b
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$c615]
    or a
    jr z, $55ce
    ld a, c
    or a
    jr z, $555d
    ld a, $80
    cp c
    jr nc, $557e
    push bc
    push de
    push hl
    ld c, $80
    call $5b51
    pop hl
    pop de
    pop bc
    jr c, $55e3
    ld a, c
    sub $80
    ld c, a
    ld a, $80
    add a, l
    ld l, a
    ld a, $00
    adc a, h
    ld h, a
    ld a, $80
    add a, e
    ld e, a
    ld a, $00
    adc a, d
    ld d, a
    call $5b51
    jr c, $55e3
    call $59df
    jr c, $55e3
    jr $55d9
Infrared_ReceiveBuffer::
    ldh a, [$ff82]
    push af
    ld a, b
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$c615]
    or a
    jr z, $55ce
    ld a, c
    or a
    jr z, $55a1
    ld a, $80
    cp c
    jr nc, $55c2
    push bc
    push de
    push hl
    ld c, $80
    call $5ac2
    pop hl
    pop de
    pop bc
    jr c, $55e3
    ld a, c
    sub $80
    ld c, a
    ld a, $80
    add a, l
    ld l, a
    ld a, $00
    adc a, h
    ld h, a
    ld a, $80
    add a, e
    ld e, a
    ld a, $00
    adc a, d
    ld d, a
    call $5ac2
    jr c, $55e3
    call $59df
    jr c, $55e3
    jr $55d9
    call $58ed
    jr c, $55e3
    ld a, [$c618]
    or a
    jr z, $55e3
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$c614], a
    ret
    call $5430
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $02
    ld [$c614], a
    scf
    ret
    assert @ == $55f2

section "Infrared Interface and Connection UI", romx[$55f2], bank[$18]
InfraredUI_Initialize::
    call $04f3
    call $34ce
    call $2d7c
    ld a, $fc
    ldh [$ff95], a
    xor a
    ldh [$ff96], a
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call $0618
    call $0f02
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ld bc, $0000
    ld de, $1305
    farcall UIWindow_DrawFrame
    ld bc, $000d
    ld de, $1305
    farcall UIWindow_DrawFrame
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0101
    ld de, $1103
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0101
    ld de, $1103
    farcall Gfx_TilemapFill
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $010e
    ld de, $1103
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $010e
    ld de, $1103
    farcall Gfx_TilemapFill
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0102
    call $0ed4
    ld de, $56b0
    call $0f63
    ld bc, $0103
    call $0ed4
    ld de, $56c2
    call $0f63
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $9200
    farcall SegmentedMeter_LoadGraphics
    ld a, $01
    call $5890
    call $09bd
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ret
InfraredUI_PositioningInstructionLine1::
    ld l, [hl]
    ld h, a
    adc a, [hl]
    ld h, d
    ld l, [hl]
    adc a, l
    ld [hl], d
    ld h, e
    ld l, h
    adc a, l
    sbc a, a
    ld a, c
    inc d
    rst $08
    dec l
    cp b
    ld h, b
    nop
InfraredUI_PositioningInstructionLine2::
    add a, c
    ld h, [hl]
    ld h, d
    ld h, c
    adc a, h
    ld l, [hl]
    ld [hl], e
    ld [hl], c
    ld h, [hl]
    sbc a, d
    ld l, c
    ld [hl], e
    ld l, b
    sbc a, b
    ld l, e
    ld h, d
    ld l, $00
InfraredUI_DrawConnectionStatus::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, h
    or a
    jr nz, $56eb
    add hl, hl
    ld de, $5722
    add hl, de
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld b, $18
    ld c, $11
    ld de, $db5a
    call $09a6
    or a
    jr z, $56f9
    inc hl
    jr $56fb
    ld a, $20
    ld [de], a
    inc de
    dec c
    jr nz, $56f0
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld [de], a
    ld bc, $0101
    call $0ed4
    ld de, $db5a
    call $0f63
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
InfraredUI_ConnectionStatusPointers::
    db $2c, $57, $3b, $57, $49, $57, $58, $57, $66, $57
InfraredUI_StatusPreparing::
    db $6e, $72, $97, $68, $94, $ad, $8d, $9e, $71, $ad, $63, $9b, $6d, $2e, $00
InfraredUI_StatusWaiting::
    db $6e, $72, $97, $68, $70, $62, $67, $71, $ad, $63, $9b, $6d, $2e, $00
InfraredUI_StatusCommunicating::
    db $70, $98, $62, $7f, $72, $63, $6c, $8d, $71, $ad, $63, $9b, $6d, $2e, $00
InfraredUI_StatusConnectionFailed::
    db $6e, $72, $97, $68, $9b, $67, $7f, $6e, $8d, $9b, $6c, $70, $2e, $00
InfraredUI_StatusCommunicationError::
    db $72, $63, $6c, $8d, $b4, $d7, $2d, $8e, $7a, $af, $6e, $62, $6c, $7f, $6c, $70
    db $2e, $00
InfraredUI_DrawPrompt::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, h
    or a
    jr nz, $578f
    add hl, hl
    ld de, $580a
    add hl, de
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld b, $18
    ld a, b
    ld [$db6d], a
    ld b, $02
    ld de, $db5a
    ld c, $11
    push bc
    ld a, [$db6d]
    ld b, a
    call $09a6
    pop bc
    or a
    jr z, $57d3
    push bc
    ld a, [$db6d]
    ld b, a
    call $09a6
    pop bc
    cp $00
    jr z, $57ba
    cp $01
    jr z, $57ba
    inc hl
    jr $57bc
    ld a, $20
    ld [de], a
    inc de
    dec c
    jr nz, $57a6
    xor a
    ld [de], a
    push bc
    ld a, [$db6d]
    ld b, a
    call $09a6
    pop bc
    cp $01
    jr nz, $57dc
    inc hl
    jr $57dc
    ld a, $20
    ld [de], a
    inc de
    dec c
    jr nz, $57d5
    xor a
    ld [de], a
    push bc
    push de
    push hl
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $02
    sub b
    add a, $0e
    ld c, a
    ld b, $01
    call $0ed4
    ld de, $db5a
    call $0f63
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    pop hl
    pop de
    pop bc
    dec b
    jr nz, $5795
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
InfraredUI_PromptPointers::
    db $12, $58, $30, $58, $4e, $58, $70, $58
InfraredUI_PromptReady::
    db $94, $ad, $8d, $9e, $8e, $9b, $67, $70, $87, $2c, $9c, $71, $87, $66, $8e, $01
    db $41, $f1, $c0, $dd, $60, $65, $6c, $73, $68, $98, $6b, $62, $2e, $00
InfraredUI_PromptWaitOrCancel::
    db $6c, $9d, $87, $68, $65, $7f, $71, $68, $98, $6b, $62, $2e, $01, $41, $f1, $c0
    db $dd, $60, $65, $6d, $74, $71, $ad, $63, $6c, $6c, $7f, $6d, $2e, $00
InfraredUI_PromptRestartAnyButton::
    db $6b, $62, $6c, $ae, $66, $87, $84, $88, $75, $65, $6c, $73, $68, $98, $6b, $62
    db $2e, $01, $75, $76, $66, $f1, $c0, $dd, $60, $65, $6c, $73, $68, $98, $6b, $62
    db $2e, $00
InfraredUI_PromptRestartAButton::
    db $6b, $62, $6c, $ae, $66, $87, $84, $88, $75, $65, $6c, $73, $68, $98, $6b, $62
    db $2e, $01, $41, $f1, $c0, $dd, $60, $65, $6c, $73, $68, $98, $6b, $62, $2e, $00
InfraredUI_LoadPromptGraphics::
    push hl
    push de
    ld bc, $1420
    ld hl, $9a0a
    farcall SegmentedMeter_Draw
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $08
    ld hl, $9a0a
    ld bc, $0008
    call $3b84
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    pop de
    pop hl
    ret
    assert @ == $58b8

section "Infrared Low-Level Framed Transport", romx[$58b8], bank[$18]
Infrared_SelectROMBank::
    ld [$ffab], a
    ld [$4000], a
    ret
Infrared_WaitPulse::
    ld c, $56
    call $1535
    ld a, [$c909]
    bit 0, a
    jr nz, $58d0
    ldh a, [c]
    bit 1, a
    jr nz, $58c1
    scf
    ret
Infrared_ReturnSuccess::
    xor a
    ret
Infrared_EnterCriticalIO::
    di
    ldh a, [$ff56]
    and $c0
    cp $c0
    ret z
    call $124f
    call $1214
    ret
Infrared_DisableEmitter::
    ld a, $00
    ldh [$ff56], a
    jp $125a
Infrared_Return::
    ret
Infrared_LeaveCriticalIO::
    ei
    ret
Infrared_LinkHandshake::
    call $58d4
    call $124f
    call $1535
    ld a, [$c909]
    bit 0, a
    jr nz, $5933
    call $12c3
    ld a, [$c901]
    cp $8b
    jr nz, $58f3
    ld hl, $c8ec
    ld b, $08
    call $143b
    ld a, [$c901]
    cp $8b
    jr nz, $58f0
    call $152a
    ld a, [$c901]
    cp $8b
    jr nz, $58f0
    ld a, [$c8ec]
    cp $0d
    jr nc, $58f0
    ld hl, $5944
    call $5939
    jr nc, $58f0
    scf
    ret
    db $37, $c9
    call $58eb
    xor a
    scf
    ret
Infrared_DispatchPacketType::
    add a, a
    add a, l
    ld l, a
    ld a, $00
    adc a, h
    ld h, a
    ld a, [hli]
    ld h, [hl]
    ld l, a
    jp hl
Infrared_PacketDispatchTable::
    db $5e, $59, $64, $59, $5e, $59, $5e, $59, $5e, $59, $5e, $59, $5e, $59, $5e, $59
    db $69, $59, $5e, $59, $5e, $59, $a4, $59, $5e, $59
Infrared_PacketTypeDefault::
    call $58eb
    pop hl
    or a
    ret
Infrared_PacketTypeExtended::
    call $59a4
    jr $595e
Infrared_ReceivePacketPayload::
    call $124f
    call $1535
    ld a, [$c909]
    bit 0, a
    jr nz, $59a2
    call $1302
    ld a, [$c901]
    cp $8b
    jr nz, $596c
    ld a, [$c8ee]
    ld l, a
    ld a, [$c8ef]
    ld h, a
    ld a, [$c8f2]
    ld b, a
    call $1357
    ld a, [$c901]
    cp $8b
    jr nz, $5969
    call $1525
    ld a, [$c901]
    cp $8b
    jr nz, $5969
    xor a
    ret
    scf
    ret
Infrared_SendPacketPayload::
    call $124f
    call $1535
    ld a, [$c909]
    bit 0, a
    jr nz, $59dd
    call $12c3
    ld a, [$c901]
    cp $8b
    jr nz, $59a7
    ld a, [$c8f0]
    ld l, a
    ld a, [$c8f1]
    ld h, a
    ld a, [$c8f2]
    ld b, a
    call $143b
    ld a, [$c901]
    cp $8b
    jr nz, $59a4
    call $152a
    ld a, [$c901]
    cp $8b
    jr nz, $59a4
    xor a
    ret
    scf
    ret
Infrared_ExchangeFrame::
    call $58d4
    ld a, $00
    call $5aaa
    call $1535
    ld a, [$c909]
    bit 0, a
    jr nz, $5a1a
    call $124f
    call $5b39
    ld a, [$c901]
    cp $8b
    jr nz, $5a1a
    ld hl, $c8ec
    ld b, $08
    call $1357
    ld a, [$c901]
    cp $8b
    jr nz, $59e7
    call $1525
    ld a, [$c901]
    cp $8b
    jr nz, $59e7
    xor a
    jr $5a1b
    scf
    push af
    call $58eb
    pop af
    ret
Infrared_LinkSelfTest::
    ld a, $55
    ld [$c8f4], a
    ld a, $aa
    ld [$c8f5], a
    call $58d4
    ld hl, $c8f4
    ld de, $c8f4
    ld c, $02
    ld a, $01
    call $5aaa
    call $1535
    ld a, [$c909]
    bit 0, a
    jr nz, $5aa6
    call $124f
    call $5b39
    ld a, [$c901]
    cp $8b
    jr nz, $5aa6
    ld hl, $c8ec
    ld b, $08
    call $1357
    ld a, [$c901]
    cp $8b
    jr nz, $5aa6
    call $1525
    ld a, [$c901]
    cp $8b
    jr nz, $5aa6
    call $1535
    ld a, [$c909]
    bit 0, a
    jr nz, $5aa6
    call $124f
    call $1302
    ld a, [$c901]
    cp $8b
    jr nz, $5aa6
    ld a, [$c8ee]
    ld l, a
    ld a, [$c8ef]
    ld h, a
    ld a, [$c8f2]
    ld b, a
    call $1357
    ld a, [$c901]
    cp $8b
    jr nz, $5aa6
    call $1525
    ld a, [$c901]
    cp $8b
    jr nz, $5aa6
    xor a
    jp $5a1b
    scf
    jp $5a1b
Infrared_SetTransferDescriptor::
    ld [$c8ec], a
    ld a, l
    ld [$c8ee], a
    ld a, h
    ld [$c8ef], a
    ld a, e
    ld [$c8f0], a
    ld a, d
    ld [$c8f1], a
    ld a, c
    ld [$c8f2], a
    ret
Infrared_ReceiveFrame::
    call $58d4
    ld a, $08
    call $5aaa
    call $1535
    ld a, [$c909]
    bit 0, a
    jr nz, $5b35
    call $124f
    call $5b39
    ld a, [$c901]
    cp $8b
    jr nz, $5b35
    ld hl, $c8ec
    ld b, $08
    call $1357
    ld a, [$c901]
    cp $8b
    jr nz, $5aca
    call $1525
    ld a, [$c901]
    cp $8b
    jr nz, $5aca
    call $124f
    call $1535
    ld a, [$c909]
    bit 0, a
    jr nz, $5b35
    call $12c3
    ld a, [$c901]
    cp $8b
    jr nz, $5afd
    ld a, [$c8f0]
    ld l, a
    ld a, [$c8f1]
    ld h, a
    ld a, [$c8f2]
    ld b, a
    call $143b
    ld a, [$c901]
    cp $8b
    jr nz, $5afa
    call $152a
    ld a, [$c901]
    cp $8b
    jr nz, $5afa
    xor a
    jp $5a1b
    scf
    jp $5a1b
Infrared_WaitFrameReady::
    call $1535
    ld a, [$c909]
    bit 0, a
    jr nz, $5b4f
    call $1302
    ld a, [$c901]
    cp $8b
    jr nz, $5b39
    xor a
    ret
    scf
    ret
Infrared_SendFrame::
    call $58d4
    ld a, $0b
    call $5aaa
    call $1535
    ld a, [$c909]
    bit 0, a
    jr nz, $5bc4
    call $124f
    call $5b39
    ld a, [$c901]
    cp $8b
    jr nz, $5bc4
    ld hl, $c8ec
    ld b, $08
    call $1357
    ld a, [$c901]
    cp $8b
    jr nz, $5b59
    call $1525
    ld a, [$c901]
    cp $8b
    jr nz, $5b59
    call $124f
    call $1535
    ld a, [$c909]
    bit 0, a
    jr nz, $5bc4
    call $1302
    ld a, [$c901]
    cp $8b
    jr nz, $5b8c
    ld a, [$c8ee]
    ld l, a
    ld a, [$c8ef]
    ld h, a
    ld a, [$c8f2]
    ld b, a
    call $1357
    ld a, [$c901]
    cp $8b
    jr nz, $5b89
    call $1525
    ld a, [$c901]
    cp $8b
    jr nz, $5b89
    xor a
    jp $5a1b
    scf
    jp $5a1b
    assert @ == $5bc8
