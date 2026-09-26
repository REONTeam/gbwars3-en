include "macros/macros.inc"

; Selected-map STATUS presentation. The controller at $62AB toggles between
; two complete status pages while preserving the original retail layout and
; returning 0 for A, $FF for B, or looping until a supported input arrives.

section "Map Status Presentation", romx[$5f13], bank[$27]

MapStatus_DrawOverviewPage::
    call $04f3
    call $34ce
    call $2d7c
    xor a
    ldh [$ff95], a
    ldh [$ff97], a
    ldh [$ff98], a
    ld a, $04
    ldh [$ff96], a
    rst $28
    db $10
    xor b
    ld l, b
    rst $28
    ld bc, $4000
    call $0618
    call $0f02
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $00
    rst $28
    dec d
    sub c
    ld h, [hl]
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a

jr_027_5f48:
    ldh [rVBK], a
    ld de, $65d3
    ld hl, $9000
    ld bc, $0220
    call $3b50
    ld de, $67b1
    ld hl, $9220
    ld bc, $0010
    rst $28
    inc d
    ld d, b
    dec sp
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    call MapStatus_LoadOverviewIcons
    ld a, $00
    ld b, $08
    ld hl, $67f3
    call $06bc
    call $06af
    call $06f2
    ld a, $05
    rst $28
    dec bc
    ld e, l
    halt
    ld bc, $010f
    ld de, $1203
    rst $28
    ld [hl+], a
    ld b, a
    ld h, d
    ld a, [$c883]
    inc a
    ld bc, $0210
    ld d, $02
    call $3237
    ld bc, $0009
    ld a, $00
    ld hl, $cc65
    call $3b79
    ld de, $c8a5
    ld hl, $cc65
    ld bc, $0008
    call $3b50
    ld bc, $0510
    ld hl, $cc65
    call $3353
    ld a, $08
    ld bc, $1110
    ld de, $0101
    ld h, $19
    rst $28
    dec d
    db $fd
    ld h, a
    ld a, [$c633]
    srl a
    inc a
    ld bc, $0f10
    ld d, $02
    call $31f5
    ld bc, $0101
    ld de, $060e
    rst $28
    ld [hl+], a
    ld b, a
    ld h, d
    ld bc, $0202
    ld hl, $65a0
    call $3353
    ld a, [$cd09]
    ld bc, $0403
    ld d, $02
    call $31f5
    ld bc, $0204
    call $0ed4
    ld a, $23
    ld b, $01
    ld c, $05
    ld d, $02
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c64c]
    ld bc, $0405
    ld d, $02
    call $31f5
    ld bc, $0206
    call $0ed4
    ld a, $27
    ld b, $01
    ld c, $05
    ld d, $04
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c64e]
    ld bc, $0407
    ld d, $02
    call $31f5
    ld bc, $0208
    call $0ed4
    ld a, $2b
    ld b, $01
    ld c, $05
    ld d, $06
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c650]
    ld bc, $0409
    ld d, $02
    call $31f5
    ld bc, $020a
    call $0ed4
    ld a, $2f
    ld b, $01
    ld c, $05
    ld d, $09
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c653]
    ld bc, $040b
    ld d, $02
    call $31f5
    ld bc, $020c
    call $0ed4
    ld a, $33
    ld b, $01
    ld c, $05
    ld d, $0b
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c655]
    ld bc, $040d
    ld d, $02
    call $31f5
    ld bc, $0701
    ld de, $060e
    rst $28
    ld [hl+], a
    ld b, a
    ld h, d
    ld bc, $0804
    call $0ed4
    ld a, $37
    ld b, $01
    ld c, $05
    ld d, $17
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c661]
    ld bc, $0a05
    ld d, $02
    call $31f5
    ld bc, $0806
    call $0ed4
    ld a, $3b
    ld b, $01
    ld c, $05
    ld d, $19
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c663]
    ld bc, $0a07
    ld d, $02
    call $31f5
    ld bc, $0808
    call $0ed4
    ld a, $3f
    ld b, $01
    ld c, $05
    ld d, $1b
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c665]
    ld bc, $0a09
    ld d, $02
    call $31f5
    ld bc, $080a
    call $0ed4
    ld a, $43
    ld b, $01
    ld c, $05
    ld d, $1d
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c667]
    ld bc, $0a0b
    ld d, $02
    call $31f5
    ld bc, $080c
    call $0ed4
    ld a, $47
    ld b, $01
    ld c, $05
    ld d, $1f
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c669]
    ld bc, $0a0d
    ld d, $02
    call $31f5
    ld bc, $0d01
    ld de, $060e
    rst $28
    ld [hl+], a
    ld b, a
    ld h, d
    ld bc, $0e02
    ld hl, $65a0
    call $3353
    ld a, [$cd0a]
    ld bc, $1003
    ld d, $02
    call $31f5
    ld bc, $0e04
    call $0ed4
    ld a, $4b
    ld b, $01
    ld c, $05
    ld d, $0d
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c657]
    ld bc, $1005
    ld d, $02
    call $31f5
    ld bc, $0e06
    call $0ed4
    ld a, $4f
    ld b, $01
    ld c, $05
    ld d, $0f
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c659]
    ld bc, $1007
    ld d, $02
    call $31f5
    ld bc, $0e08
    call $0ed4
    ld a, $53
    ld b, $01
    ld c, $05
    ld d, $11
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c65b]
    ld bc, $1009
    ld d, $02
    call $31f5
    ld bc, $0e0a
    call $0ed4
    ld a, $57
    ld b, $01
    ld c, $05
    ld d, $14
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c65e]
    ld bc, $100b
    ld d, $02
    call $31f5
    ld bc, $0e0c
    call $0ed4
    ld a, $5b
    ld b, $01
    ld c, $05
    ld d, $16
    rst $28
    dec bc
    rst $08
    halt
    ld a, [$c660]
    ld bc, $100d
    ld d, $02
    call $31f5
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f52
    call $2de8
    ld [$c93f], a
    ld bc, $5818
    call $2eae
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ret


MapStatus_ShowDetailPage::
    xor a
    ld [$c93d], a
    call MapStatus_DrawDetailPage
    ret


MapStatus_LoadOverviewIcons::
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $02
    ld hl, $9230
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $04
    ld hl, $9270
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $06
    ld hl, $92b0
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $09
    ld hl, $92f0
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $0b
    ld hl, $9330
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $17
    ld hl, $9370
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $19
    ld hl, $93b0
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $1b
    ld hl, $93f0
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $1d
    ld hl, $9430
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $1f
    ld hl, $9470
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $0d
    ld hl, $94b0
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $0f
    ld hl, $94f0
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $11
    ld hl, $9530
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $14
    ld hl, $9570
    rst $28
    dec bc
    ld [hl], a
    halt
    ld a, $16
    ld hl, $95b0
    rst $28
    dec bc
    ld [hl], a
    halt
    ret


MapStatus_ClearStatRow::
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    push bc
    call $0ed4
    ld bc, $0008
    ld a, $22
    call $3b79
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    pop bc
    call $0ed4
    ld bc, $0008
    ld a, $08
    call $3b79
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ret


MapStatus_Run::
    call MapStatus_ShowDetailPage
    call $081d

jr_027_62b1:
    call $05a2
    call $3056
    ld a, $00
    rst $28
    dec d
    sub c
    ld h, a
    ldh a, [$ff92]
    bit 6, a
    jr z, jr_027_62de

    ld a, [$c93d]
    cp $00
    jr z, jr_027_62b1

    ld a, $01
    call $3844
    xor a
    ld [$c93d], a
    call $07b4
    call MapStatus_ShowDetailPage
    call $081d
    jr jr_027_62b1

jr_027_62de:
    bit 7, a
    jr z, jr_027_62f9

    ld a, [$c93d]
    cp $01
    jr z, jr_027_62b1

    ld a, $01
    call $3844
    call $07b4
    call MapStatus_ShowOverviewPage
    call $081d
    jr jr_027_62b1

jr_027_62f9:
    bit 0, a
    jr z, jr_027_6300

    xor a
    jr jr_027_630a

jr_027_6300:
    bit 1, a
    jr z, jr_027_6308

    ld a, $ff
    jr jr_027_630a

jr_027_6308:
    jr jr_027_62b1

jr_027_630a:
    push af
    ld a, $0c
    call $3844
    call $07b4
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    call $2e67
    pop af
    ret


MapStatus_DrawDetailPage::
    call $04f3
    call $34ce
    call $2d7c
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    ldh [$ff97], a
    ldh [$ff98], a
    rst $28
    db $10
    xor b
    ld l, b
    rst $28
    ld bc, $4000
    call $0618
    call $0f02
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $00
    rst $28
    dec d
    sub c
    ld h, [hl]
    call $04f3
    xor a
    ldh [$ff95], a
    ld a, $00
    rst $28
    dec d
    sub c
    ld h, [hl]
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld de, $65d3
    ld hl, $9000
    ld bc, $0220
    call $3b50
    ld de, $67b1
    ld hl, $9220
    ld bc, $0010
    rst $28
    inc d
    ld d, b
    dec sp
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, [$c93f]
    call $2f5f
    call $3056
    ld a, $00
    ld b, $08
    ld hl, $67f3
    call $06bc
    call $06af
    call $06f2
    ld bc, $0000
    ld de, $0a12
    rst $28
    db $10
    add hl, bc
    ld l, d
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    xor a
    ld bc, $0101
    ld de, $0810
    rst $28
    dec d
    db $d3
    ld l, d
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $0b
    ld bc, $0401
    ld de, $0202
    ld h, $1a
    rst $28
    dec d
    db $fd
    ld h, a
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $0103
    call $0ed4
    ld de, $65a5
    call $0f63
    ld a, [$c8b4]
    ld h, a
    ld a, [$c8b3]
    ld l, a
    ld bc, $0404
    ld d, $05
    call $3251
    ld bc, $0105
    call $0ed4
    ld de, $65ae
    call $0f63
    ld a, [$c8b8]
    ld h, a
    ld a, [$c8b7]
    ld l, a
    ld bc, $0406
    ld d, $05
    call $3251
    ld bc, $0107
    call MapStatus_ClearStatRow
    ld bc, $0108
    call $0ed4
    ld de, $65b7
    call $0f63
    ld hl, $c634
    ld bc, $0409
    ld d, $05
    call $32a3
    ld bc, $010a
    call $0ed4
    ld de, $65bb
    call $0f63
    ld a, [$c63a]
    ld l, a
    ld a, [$c63b]
    ld h, a
    ld bc, $040b
    ld d, $05
    call $3251
    ld bc, $010c
    call MapStatus_ClearStatRow
    ld bc, $010d
    call $0ed4
    ld de, $65bf
    call $0f63
    ld a, [$c63f]
    ld h, a
    ld a, [$c63e]
    ld l, a
    ld bc, $030e
    ld d, $05
    call $3251
    ld bc, $080e
    call $0ed4
    ld de, $65d1
    call $0f63
    ld bc, $010f
    call $0ed4
    ld de, $65c8
    call $0f63
    ld a, [$c643]
    ld h, a
    ld a, [$c642]
    ld l, a
    ld bc, $0410
    ld d, $05
    call $3251
    ld bc, $0a00
    ld de, $0a12
    rst $28
    db $10
    add hl, bc
    ld l, d
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    xor a
    ld bc, $0b01
    ld de, $0810
    rst $28
    dec d
    db $d3
    ld l, d
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $0b
    ld bc, $0e01
    ld de, $0202
    ld h, $1e
    rst $28
    dec d
    db $fd
    ld h, a
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $0b03
    call $0ed4
    ld de, $65a5
    call $0f63
    ld a, [$c8b6]
    ld h, a
    ld a, [$c8b5]
    ld l, a
    ld bc, $0e04
    ld d, $05
    call $3251
    ld bc, $0b05
    call $0ed4
    ld de, $65ae
    call $0f63
    ld a, [$c8ba]
    ld h, a
    ld a, [$c8b9]
    ld l, a
    ld bc, $0e06
    ld d, $05
    call $3251
    ld bc, $0b07
    call MapStatus_ClearStatRow
    ld bc, $0b08
    call $0ed4
    ld de, $65b7
    call $0f63
    ld hl, $c637
    ld bc, $0e09
    ld d, $05
    call $32a3
    ld bc, $0b0a
    call $0ed4
    ld de, $65bb
    call $0f63
    ld a, [$c63c]
    ld l, a
    ld a, [$c63d]
    ld h, a
    ld bc, $0e0b
    ld d, $05
    call $3251
    ld bc, $0b0c
    call MapStatus_ClearStatRow
    ld bc, $0b0d
    call $0ed4
    ld de, $65bf
    call $0f63
    ld a, [$c641]
    ld h, a
    ld a, [$c640]
    ld l, a
    ld bc, $0d0e
    ld d, $05
    call $3251
    ld bc, $120e
    call $0ed4
    ld de, $65d1
    call $0f63
    ld bc, $0b0f
    call $0ed4
    ld de, $65c8
    call $0f63
    ld a, [$c645]
    ld h, a
    ld a, [$c644]
    ld l, a
    ld bc, $0e10
    ld d, $05
    call $3251
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f60
    call $2de8
    ld [$c93e], a
    ld bc, $5898
    call $2eae
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ret


MapStatus_ShowOverviewPage::
    ld a, $01
    ld [$c93d], a
    call MapStatus_DrawOverviewPage
    ret

