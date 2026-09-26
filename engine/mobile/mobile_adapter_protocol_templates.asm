include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"

; Mobile Adapter protocol packet templates, mail/web command strings,
; and the first executable protocol-state core.
; Physical Bank $30:$6000-$642F. $6430 is the next independently-called
; shared Mobile helper and is intentionally left outside this module.

section "Mobile Adapter Protocol Templates and Core", romx[$6000], bank[$30]
MobileAdapter_ProtocolIdleByte::
    db $4b
MobileAdapter_BeginSessionPacketTemplate::
    db $99, $66, $10, $00, $00
MobileAdapter_BeginSessionSignatureBlock::
    db $08, $4e, $49, $4e, $54, $45, $4e, $44, $4f, $02, $77, $80, $00
MobileAdapter_EndSessionPacketTemplate::
    db $99, $66, $11, $00, $00, $00, $00, $11, $80, $00
MobileAdapter_DialTelephonePacketTemplate::
    db $99, $66, $12, $00, $00, $00
MobileAdapter_HangUpTelephonePacketTemplate::
    db $99, $66, $13, $00, $00, $00, $00, $13, $80, $00
MobileAdapter_TelephoneStatusPacketTemplate::
    db $99, $66, $17, $00, $00, $00, $00, $17, $80, $00
MobileAdapter_ISPLoginPacketTemplate::
    db $99, $66, $21, $00, $00
MobileAdapter_ISPLogoutPacketTemplate::
    db $99, $66, $22, $00, $00, $00, $00, $22, $80, $00
MobileAdapter_ReadConfigurationPacketTemplateA::
    db $99, $66, $19, $00, $00, $02, $00, $60, $00, $7b, $80, $00
MobileAdapter_ReadConfigurationPacketTemplateB::
    db $99, $66, $19, $00, $00, $02, $60, $60, $00, $db, $80, $00
MobileAdapter_WriteConfigurationPacketTemplate::
    db $99, $66, $1a, $00, $00
MobileAdapter_DNSQueryPacketTemplate::
    db $99, $66, $28, $00, $00
MobileAdapter_WaitForTelephoneCallPacketTemplate::
    db $99, $66, $14, $00, $00, $00, $00, $14, $80, $00
MobileAdapter_TransferDataPacketTemplate::
    db $99, $66, $15, $00, $00, $01, $ff, $01, $15, $80, $00
MobileAdapter_OpenTCPPacketTemplate::
    db $99, $66, $23, $00, $00, $06
MobileAdapter_CloseTCPPacketTemplate::
    db $99, $66, $24, $00, $00, $01
MobileAdapter_DefaultNetworkParameterBlock::
    db $ec, $14, $c9, $e4, $0f, $0e, $e0, $0c, $53, $c4, $07, $94, $b0, $05, $ee, $ec
    db $10, $b4, $e4, $0c, $dd, $48, $45, $4c, $4f, $20, $00, $4d, $41, $49, $4c, $20
    db $46, $52, $4f, $4d, $3a, $3c, $00, $52, $43, $50, $54, $20, $54, $4f, $3a, $3c
    db $00, $44, $41, $54, $41, $0d, $0a, $00, $51, $55, $49, $54, $0d, $0a, $00, $55
    db $53, $45, $52, $20, $00, $50, $41, $53, $53, $20, $00, $53, $54, $41, $54, $0d
    db $0a, $00, $4c, $49, $53, $54, $20, $30, $30, $30, $30, $30, $0d, $0a, $00, $52
    db $45, $54, $52, $20, $30, $30, $30, $30, $30, $0d, $0a, $00, $44, $45, $4c, $45
    db $20, $30, $30, $30, $30, $30, $0d, $0a, $00, $54, $4f, $50, $20, $30, $30, $30
    db $30, $30, $20, $30, $0d, $0a, $00, $47, $45, $54, $20, $00, $20, $48, $54, $54
    db $50, $2f, $31, $2e, $30, $0d, $0a, $00, $55, $73, $65, $72, $2d, $41, $67, $65
    db $6e, $74, $3a, $20, $43, $47, $42, $2d, $00, $0d, $0a, $0d, $0a, $00, $50, $4f
    db $53, $54, $20, $00, $43, $6f, $6e, $74, $65, $6e, $74, $2d, $4c, $65, $6e, $67
    db $74, $68, $3a, $20, $00
MobileAdapter_ServiceProtocolState::
    ld a, [$d022]
    bit 5, a
    ret nz
    ld a, [$d06a]
    cp $0a
    ret c
    ld c, a
    cp $0d
    jr z, $6187
    cp $0f
    jr z, $6196
    cp $29
    jr z, $6175
    cp $2a
    jr z, $6175
    cp $28
    jr z, $6175
    ld a, [$d007]
    cp $06
    ret z
    ld b, $00
    sla c
    ld hl, $6198
    add hl, bc
    ld a, [hli]
    ld h, [hl]
    ld l, a
    push hl
    ld hl, $d06b
    inc [hl]
    ld a, [hl]
    ret
    ld c, a
    ld a, [$d06b]
    cp $01
    jr nz, $616f
    ld hl, $d021
    res 1, [hl]
    jr $6175
    ld c, a
    ld a, [$d00f]
    cp $24
    jr nz, $616f
    ld a, [$d06b]
    cp $01
    jr nz, $616f
    ld hl, $d021
    res 1, [hl]
    jr $6175
    db $f6, $61, $71, $62, $73, $63, $b6, $63, $e1, $63, $51, $64, $25, $67, $4a, $67
    db $ac, $69, $43, $6d, $43, $6d, $50, $68, $eb, $68, $79, $69, $66, $6a, $81, $6b
    db $fc, $6b, $cb, $6b, $fc, $6b, $81, $6b, $87, $74, $43, $6d, $43, $6d, $43, $6d
    db $43, $6d, $43, $6d, $43, $6d, $d5, $74, $d5, $74, $d5, $74, $fe, $7d, $ae, $7e
    db $e9, $7e, $f6, $61, $87, $74, $2e, $76, $e2, $75, $3d, $28, $05, $3d, $28, $14
    db $35, $c9, $fa, $18, $d0, $b7, $28, $02, $18, $63, $3e, $10, $cd, $5d, $62, $cb
    db $86, $cb, $ce, $c9, $21, $6e, $d0, $2a, $66, $6f, $fa, $18, $d0, $fe, $88, $38
    db $2c, $d6, $88, $77, $fe, $04, $38, $02, $3e, $03, $fe, $03, $20, $01, $3d, $47
    db $3e, $04, $90, $57, $07, $82, $4f, $af, $b8, $28, $03, $3e, $03, $a8, $21, $71
    db $d0, $32, $71, $fa, $6a, $d0, $fe, $0a, $20, $0b, $c3, $a7, $56, $3e, $10, $cd
    db $5d, $62, $c3, $ab, $56, $af, $ea, $21, $d0, $ea, $07, $d0, $3c, $ea, $6a, $d0
    db $c9
MobileAdapter_SetCommandState05::
    ld [$d00f], a
    ld a, $05
    ld [$d06a], a
    ld hl, $d021
    ret
MobileAdapter_ProtocolCore_6269::
    ld a, $91
    ld hl, $6013
    jp $5f02
    db $3d, $28, $18, $3d, $28, $1b, $3d, $28, $27, $3d, $ca, $09, $63, $3d, $ca, $26
    db $63, $3d, $ca, $35, $63, $3d, $ca, $42, $63, $35, $c9, $21, $46, $60, $c3, $6b
    db $63, $21, $29, $d0, $3e, $e0, $22, $3e, $d0, $22, $21, $52, $60, $c3, $6b, $63
    db $21, $80, $d0, $2a, $fe, $4d, $20, $4c, $3a, $fe, $41, $20, $47, $06, $be, $11
    db $00, $00, $2a, $83, $5f, $3e, $00, $8a, $57, $05, $20, $f6, $2a, $ba, $20, $3b
    db $7e, $bb, $20, $37, $21, $84, $d0, $11, $36, $d0, $06, $08, $cd, $00, $40, $21
    db $ca, $d0, $06, $2c, $cd, $00, $40, $fa, $79, $d3, $4f, $d6, $08, $5f, $16, $00
    db $21, $7a, $d3, $19, $5d, $54, $21, $36, $d0, $06, $08, $cd, $00, $40, $41, $cd
    db $66, $5f, $18, $65, $3e, $25, $ea, $72, $d0, $18, $05, $3e, $14, $ea, $72, $d0
    db $3e, $06, $ea, $6b, $d0, $c3, $69, $62, $fa, $21, $d0, $e6, $e0, $20, $04, $06
    db $92, $18, $37, $fe, $e0, $3e, $11, $28, $01, $3c, $ea, $72, $d0, $3e, $06, $ea
    db $6b, $d0, $c3, $69, $62, $57, $fa, $79, $d3, $c6, $0a, $5f, $21, $74, $d3, $3e
    db $a1, $c3, $05, $5f, $3e, $02, $ea, $6a, $d0, $21, $21, $d0, $cb, $86, $cb, $ee
    db $c9, $fa, $72, $d0, $cd, $5d, $62, $c3, $ab, $56, $fa, $4c, $d3, $c6, $0a, $5f
    db $16, $00, $21, $47, $d3, $78, $c3, $05, $5f, $21, $6e, $d0, $3e, $80, $22, $3e
    db $d0, $77, $3e, $97, $21, $2d, $60, $c3, $02, $5f
MobileAdapter_ProtocolCore_636B::
    ld a, $99
    ld de, $000c
    jp $5f05
    db $3d, $28, $e4, $3d, $28, $08, $3d, $28, $1f, $3d, $28, $2e, $35, $c9, $fa, $21
    db $d0, $e6, $e0, $20, $04, $06, $92, $18, $bf, $fe, $e0, $3e, $11, $28, $01, $3c
    db $3e, $03, $ea, $6b, $d0, $c3, $69, $62, $21, $22, $d0, $cb, $e6, $3e, $02, $ea
    db $6a, $d0, $21, $21, $d0, $cb, $86, $cb, $f6, $c9, $fa, $72, $d0, $cd, $5d, $62
    db $c3, $ab, $56, $3d, $28, $05, $3d, $28, $0a, $c9, $35, $3e, $94, $21, $68, $60
    db $c3, $02, $5f, $fa, $3c, $d2, $fe, $ee, $28, $f0, $21, $22, $d0, $cb, $e6, $3e
    db $02, $ea, $6a, $d0, $21, $21, $d0, $cb, $86, $cb, $f6, $cb, $ee, $c9, $3d, $28
    db $0e, $3d, $28, $23, $3d, $28, $2c, $3d, $28, $31, $3d, $28, $31, $35, $c9, $fa
    db $3c, $d2, $fe, $9f, $28, $0f, $cd, $f1, $67, $28, $0a, $21, $6b, $d0, $35, $21
    db $67, $d3, $c3, $d5, $67, $18, $26, $af, $ea, $6d, $d0, $3e, $a2, $21, $3c, $60
    db $c3, $02, $5f, $3e, $93, $21, $23, $60, $c3, $02, $5f, $c3, $69, $62, $21, $22
    db $d0, $cb, $a6, $21, $21, $d0, $7e, $e6, $0f, $77, $c3, $a7, $56
    assert @ == $6430
