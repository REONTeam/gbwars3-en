include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"

; Mobile Adapter HTTP/mail response-header parsing and transfer staging.
; Physical Bank $30:$6E56-$743D. This continues directly from 
; and stops immediately before the independently reached $743E helper.
; Names are behavior-backed by literal header strings, parser contracts, and
; packet/transfer state effects; broader SDK-facing identities stay conservative.

section "Mobile Adapter Response Headers", romx[$6e56], bank[$30]
MobileAdapter_NetworkProtocolState_6E56::
    ld a, [$d06a]
    cp $1f
    jr z, $6eb6
    cp $20
    jr z, $6eb6
    ld a, [$d18a]
    cp $01
    jr z, $6e75
    ld a, [$d06a]
    cp $21
    jp z, $6efa
    cp $22
    jp z, $6efa
    ld a, [$d190]
    or a
    jp z, $6f4d
    ld hl, $d18c
    ld a, [hld]
    cp $03
    jr nz, $6e8f
    ld a, [hl]
    or a
    jr z, $6e8f
    cp $03
    jr nc, $6e8f
    call $7430
    ld hl, $d021
    set 1, [hl]
    res 0, [hl]
    ld de, $d18b
    ld a, [$d190]
    cp $01
    ld a, $32
    jr z, $6ea5
    inc de
    inc de
    inc a
    ld [$d00f], a
    ld hl, $d010
    ld a, [de]
    inc de
    ld [hli], a
    ld a, [de]
    ld [hl], a
    ld a, $05
    ld [$d06a], a
    ret
    ld hl, $d18b
    ld a, [hli]
    ld h, [hl]
    ld l, a
    cp $00
    jr nz, $6ed1
    ld a, $02
    cp h
    jr nz, $6ed1
    ld a, [$d18d]
    ld b, a
    ld a, [$d18e]
    or b
    jr nz, $6e7c
    jr $6f4d
    ld a, $01
    cp l
    jr nz, $6e7c
    ld a, $04
    cp h
    jr nz, $6e7c
    ld a, [$d1a5]
    or a
    jr nz, $6f0b
    ld a, [$d06e]
    ld l, a
    ld a, [$d06f]
    or l
    jr nz, $6f0b
    ld a, $02
    ld [$d06a], a
    xor a
    ld [$d06d], a
    ld hl, $d021
    res 0, [hl]
    ret
MobileAdapter_NetworkProtocolState_6EFA::
    ld hl, $d18b
    ld a, [hli]
    ld h, [hl]
    ld l, a
    cp $00
    jp nz, $6e7c
    ld a, $02
    cp h
    jp nz, $6e7c
    ld a, [$d18d]
    ld b, a
    ld a, [$d18e]
    cp b
    jp nz, $6e7c
    or a
    jr z, $6f23
    cp $01
    jp nz, $6e7c
    ld a, $01
    ld [$d193], a
    ld a, [$d06b]
    cp $07
    jr z, $6f4d
    ld hl, $d18f
    inc [hl]
    ld a, $0f
    ld [$d06a], a
    ld a, $01
    ld [$d06b], a
    ld a, [$d06d]
    ld [$d06e], a
    xor a
    ld [$d189], a
    ld a, $a3
    ld de, $0010
    ld hl, $d195
    jp $5f05
MobileAdapter_NetworkProtocolState_6F4D::
    ld a, [$d193]
    cp $01
    jr nz, $6f62
    ld a, $02
    ld [$d190], a
    ld hl, $d18d
    dec a
    ld [hli], a
    ld [hl], a
    jp $6e8f
    ld a, $02
    ld [$d06a], a
    xor a
    ld [$d06d], a
    ld hl, $d021
    res 0, [hl]
    ret
MobileAdapter_ParseNetworkResponseHeaders::
    ld hl, $d189
    ld a, [hl]
    or a
    jr nz, $6f9a
    inc [hl]
    ld hl, $d080
    ld de, $0008
    add hl, de
    ld a, [hli]
    cp $20
    jr z, $6f80
    dec hl
    ld d, $00
    cp $32
    jr z, $6f8d
    inc d
    ld a, d
    ld [$d190], a
    call $6b21
    ld hl, $d18b
    ld a, e
    ld [hli], a
    ld [hl], d
    ld hl, $d080
    ld a, [$d02d]
    ld b, a
    or a
    jr nz, $6fb1
    ld hl, $d18b
    ld a, $00
    ld [hli], a
    ld [hl], a
    ld a, $01
    ld [$d190], a
    ret
    call $7007
    call $703a
    call $7058
    call $7086
    call $7199
    call $71b2
    push hl
    call $729a
    jr c, $6fdb
    pop de
    ld a, $0d
    cp [hl]
    jr z, $6fd4
    ld a, $0a
    cp [hl]
    jr nz, $6fb1
    ld hl, $d190
    res 2, [hl]
    jr $7000
    pop hl
    ld a, l
    cp $80
    jr nz, $6ffb
    ld a, h
    cp $d0
    jr nz, $6ffb
    ld a, $01
    ld [$d190], a
    ld hl, $d18b
    xor a
    ld [hli], a
    ld [hl], a
    ld a, $0d
    ld [$d178], a
    ld a, $0a
    ld [$d179], a
    ld hl, $d190
    set 2, [hl]
    call $709d
    ld a, [$d190]
    ret
MobileAdapter_TryParseDateHeader::
    ld de, $7033
    push hl
    call $72b3
    jr nc, $7012
    pop hl
    ret
    pop de
    push bc
    push de
    push hl
    ld b, $00
    inc b
    ld a, [hli]
    cp $0a
    jr nz, $7018
    pop hl
    ld c, b
    ld a, [$d033]
    ld e, a
    ld a, [$d034]
    ld d, a
    or e
    jr z, $7030
    call $4000
    xor a
    ld [de], a
    pop hl
    pop bc
    ret
MobileAdapter_HTTP_DateHeaderPrefix::
    db $64, $61, $74, $65, $3a, $20, $00
MobileAdapter_TryParseGbStatusHeader::
    ld de, $72d8
    push hl
    call $72a5
    jr nc, $7045
    pop hl
    ret
    call $6b21
    ld hl, $d18d
    ld a, e
    ld [hli], a
    ld [hl], d
    pop hl
    ld a, d
    or e
    ret z
    ld a, $02
    ld [$d190], a
    ret
MobileAdapter_TryParseGbAuthIDHeader::
    ld de, $72e4
    push hl
    call $72a5
    jr nc, $7063
    pop hl
    ret
    pop hl
    push bc
    push hl
    push hl
    ld b, $00
    inc b
    ld a, [hli]
    cp $0a
    jr nz, $7069
    pop hl
    ld c, b
    ld de, $d359
    call $4000
    ld hl, $d359
    ld de, $d1b5
    ld b, c
    call $4000
    xor a
    ld [de], a
    pop hl
    pop bc
    ret
MobileAdapter_TryParseWWWAuthenticateHeader::
    ld de, $72f1
    push hl
    call $72a5
    jr nc, $7091
    pop hl
    ret
    push bc
    ld de, $d1b5
    ld b, $30
    call $767d
    pop bc
    pop hl
    ret
MobileAdapter_ProcessResponseBodyWindow::
    ld hl, $d080
    ld a, [$d02d]
    ld b, a
    call $729a
    jp nc, $70bb
    ld a, [$d23c]
    cp $9f
    jp nz, $71db
    push hl
    ld hl, $d190
    res 2, [hl]
    pop hl
    jr $70c7
    ld a, [hl]
    cp $0d
    jr z, $70c6
    cp $0a
    jr z, $70c7
    jr $70a4
    inc hl
    inc hl
    push bc
    ld a, [$d072]
    ld b, a
    ld a, [$d073]
    or b
    pop bc
    jr z, $70e5
    ld a, [$d06a]
    cp $23
    jr z, $70e5
    cp $20
    jr z, $70e5
    cp $22
    jr z, $70e5
    jr $7108
    xor a
    ld hl, $d06e
    ld [hli], a
    ld [hl], a
    ld hl, $d021
    res 2, [hl]
    ld a, [$d06a]
    cp $13
    jr z, $70fa
    cp $14
    ret nz
    ld a, $06
    ld [$d06b], a
    ld a, [$d23c]
    cp $9f
    ret z
    jp $6430
    ld a, [$d02b]
    ld c, a
    dec b
    dec b
    ld a, b
    ld [$d02d], a
    jr z, $713f
    ld a, [$d073]
    ld d, a
    ld a, [$d072]
    ld e, a
    dec de
    dec de
    xor a
    or d
    jr nz, $7127
    ld a, e
    cp b
    jp c, $7238
    ld a, e
    sub b
    ld [$d02b], a
    ld a, d
    sbc a, $00
    ld [$d02c], a
    ld a, [$d074]
    ld e, a
    ld a, [$d075]
    ld d, a
    inc de
    inc de
    call $4000
    ld a, [$d23c]
    cp $9f
    jr z, $7182
    ld a, [$d23f]
    or a
    jr z, $7182
    ld l, c
    sub c
    ld c, a
    ld a, l
    ld hl, $d240
    add hl, bc
    ld b, a
    push de
    ld a, [$d02b]
    ld e, a
    ld a, [$d02c]
    ld d, a
    xor a
    or d
    jr nz, $7167
    ld a, e
    cp b
    jp c, $7277
    pop de
    push hl
    ld hl, $d02d
    ld a, [hl]
    add a, b
    ld [hli], a
    ld a, [hl]
    adc a, $00
    ld [hl], a
    ld c, b
    pop hl
    call $4000
    ld hl, $d02b
    ld a, [hl]
    sub c
    ld [hli], a
    ld a, [hl]
    sbc a, $00
    ld [hl], a
    ld hl, $d029
    ld a, e
    ld [hli], a
    ld a, d
    ld [hl], a
    ld hl, $d021
    res 2, [hl]
    ld a, $01
    ld [$d06b], a
    ld a, $02
    ld [$d189], a
    ret
MobileAdapter_TryParseURIHeader::
    ld de, $7331
    push hl
    call $72a5
    jr nc, $71a4
    pop hl
    ret
    pop de
    push bc
    push de
    push hl
    ld b, $00
    inc b
    ld a, [hli]
    cp $0a
    jr nz, $71aa
    jr $71c9
MobileAdapter_TryParseLocationHeader::
    ld de, $733e
    push hl
    call $72a5
    jr nc, $71bd
    pop hl
    ret
    pop de
    push bc
    push de
    push hl
    ld b, $00
    inc b
    ld a, [hli]
    cp $0a
    jr nz, $71c3
    pop hl
    ld c, b
    ld de, $d357
    ld a, b
    ld [de], a
    inc de
    dec b
    dec b
    call $4000
    xor a
    ld [de], a
    pop hl
    pop bc
    ret
MobileAdapter_CopyResponseLineToTransferBuffer::
    ld hl, $d179
    ld de, $d080
    ld b, $00
    ld c, b
    ld a, [hl]
    cp $0a
    jr z, $71f6
    ld a, [hld]
    inc b
    cp $0a
    jr nz, $71e9
    inc hl
    inc hl
    dec b
    ld c, b
    call $4000
    ld a, [$d02b]
    ld b, a
    add a, c
    ld c, a
    push bc
    ld a, $ff
    sub b
    ld c, a
    ld b, $00
    ld hl, $d240
    add hl, bc
    pop bc
    call $4000
    ld a, c
    ld [$d02d], a
    ld a, $fa
    sub c
    ld [$d02b], a
    ld hl, $d029
    ld a, e
    ld [hli], a
    ld a, d
    ld [hl], a
    ld l, e
    ld h, d
    ld de, $d17a
    xor a
    ld [hli], a
    ld a, l
    cp e
    jr nz, $7221
    ld a, d
    cp h
    jr nz, $7221
    ld hl, $d021
    res 2, [hl]
    ld hl, $d06b
    dec [hl]
    dec [hl]
    ld a, $04
    ret
    ld a, b
    sub e
    ld [$d191], a
MobileAdapter_StageResponseBodyChunk::
    ld a, [$d021]
    bit 2, a
    ld a, c
    jr nz, $7246
    xor a
    ld [$d192], a
    ld b, e
    ld c, e
    ld a, [$d074]
    ld e, a
    ld a, [$d075]
    ld d, a
    inc de
    inc de
    call $4000
    ld a, [$d191]
    ld [$d193], a
    ld b, a
    ld de, $d080
    call $4000
    ld hl, $d02d
    ld a, c
    ld [hli], a
    xor a
    ld [hl], a
    ld hl, $d021
    set 2, [hl]
    ld a, $03
    ld [$d06b], a
    ret
    ld a, b
    sub e
    ld [$d192], a
    ld [$d02b], a
    ld b, e
    ld c, e
    pop de
    call $4000
    ld hl, $d02d
    ld a, c
    add a, [hl]
    ld [hli], a
    ld a, $00
    adc a, [hl]
    ld [hl], a
    ld hl, $d021
    set 2, [hl]
    ld a, $03
    ld [$d06b], a
    ret
MobileAdapter_ScanToLF::
    dec b
    ld a, [hli]
    cp $0a
    ret z
    xor a
    or b
    jr nz, $729a
    scf
    ret
MobileAdapter_MatchHeaderPrefix::
    ld c, $00
    ld a, [de]
    inc de
    or a
    ret z
    xor [hl]
    inc hl
    or c
    ld c, a
    jr z, $72a7
    scf
    ret
MobileAdapter_MatchHeaderPrefixCaseInsensitive::
    ld c, $00
    push hl
    ld l, e
    ld h, d
    pop de
    ld a, [de]
    inc de
    call $72cf
    xor [hl]
    inc hl
    or c
    ld c, a
    xor a
    cp [hl]
    jr z, $72ca
    cp c
    jr z, $72b9
    scf
    push hl
    ld l, e
    ld h, d
    pop de
    ret
MobileAdapter_ASCIIToLowerIfUppercase::
    cp $41
    ret c
    cp $5b
    ret nc
    or $20
    ret
MobileAdapter_HTTPResponseHeaderStrings::
    db $47, $62, $2d, $53, $74, $61, $74, $75, $73, $3a, $20, $00
MobileAdapter_HTTP_GbAuthIDHeaderPrefix::
    db $47, $62, $2d, $41, $75, $74, $68, $2d, $49, $44, $3a, $20, $00
MobileAdapter_HTTP_WWWAuthenticateGB00Prefix::
    db $57, $57, $57, $2d, $41, $75, $74, $68, $65, $6e, $74, $69, $63, $61, $74, $65
    db $3a, $20, $47, $42, $30, $30, $20, $6e, $61, $6d, $65, $3d, $22, $00
MobileAdapter_HTTP_ContentTypeXCGBHeader::
    ld b, e
    ld l, a
    ld l, [hl]
    ld [hl], h
    ld h, l
    ld l, [hl]
    ld [hl], h
    dec l
    ld d, h
    ld a, c
    ld [hl], b
    ld h, l
    ld a, [hld]
    jr nz, $737f
    ld [hl], b
    ld [hl], b
    ld l, h
    ld l, c
    ld h, e
    ld h, c
    ld [hl], h
    ld l, c
    ld l, a
    ld l, [hl]
    cpl
    ld a, b
    dec l
    ld h, e
    ld h, a
    ld h, d
    dec c
    ld a, [bc]
    nop
MobileAdapter_HTTP_URIHeaderPrefix::
    ld d, l
    ld d, d
    ld c, c
    dec l
    ld l, b
    ld h, l
    ld h, c
    ld h, h
    ld h, l
    ld [hl], d
    ld a, [hld]
    jr nz, $733e
MobileAdapter_HTTP_LocationHeaderPrefix::
    ld c, h
    ld l, a
    ld h, e
    ld h, c
    ld [hl], h
    ld l, c
    ld l, a
    ld l, [hl]
    ld a, [hld]
    jr nz, $7349
MobileAdapter_NetworkProtocolState_7349::
    ld a, $01
    ld [$d06b], a
    ld de, $d359
    ld a, [$d06c]
    ld [de], a
    inc de
    ld bc, $0001
    call $66b0
    ld hl, $730f
    ld a, [$d1a5]
    or a
    call nz, $4007
    ld a, [$d06a]
    cp $22
    jr nz, $7376
    ld a, [$d18a]
    cp $02
    jr nz, $7383
    jr $737a
    cp $24
    jr nz, $7383
    ld a, [$d1a5]
    or a
    jr z, $739c
    call $7410
    ld hl, $d1b5
    call $4007
    call $66b6
    ld a, c
    ld [$d358], a
    ld b, c
    call $5f66
    ld a, $95
    ld hl, $d353
    jp $5f05
    ld hl, $73a4
    call $4007
    jr $7383
MobileAdapter_HTTP_ContentLengthZeroHeader::
    ld b, e
    ld l, a
    ld l, [hl]
    ld [hl], h
    ld h, l
    ld l, [hl]
    ld [hl], h
    dec l
    ld c, h
    ld h, l
    ld l, [hl]
    ld h, a
    ld [hl], h
    ld l, b
    ld a, [hld]
    jr nz, $73e5
    dec c
    ld a, [bc]
    nop
MobileAdapter_NetworkProtocolState_73B8::
    call $743e
    ld a, $01
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
    ld b, $06
    call $4000
    ld a, [$d06d]
    cp $03
    jp nz, $7349
    ld de, $d359
    ld a, [$d06c]
    ld [de], a
    inc de
    ld bc, $0001
    call $66b0
    ld a, [$d194]
    or a
    call nz, $7410
    call $66b6
    ld a, c
    ld [$d358], a
    ld b, c
    call $5f66
    ld a, $95
    ld hl, $d353
    jp $5f05
MobileAdapter_ResetNetworkTransferState::
    call $66f6
    xor a
    ld [$d06b], a
    ld a, [$d1aa]
    ld [$d07c], a
    ld a, [$d1ab]
    ld [$d07d], a
    ld a, [$d1ac]
    ld [$d07e], a
    ld a, [$d1ad]
    ld [$d07f], a
    ret
MobileAdapter_CopyStagedNetworkPayload::
    ld hl, $d357
    ld de, $d080
    ld a, [hli]
    ld b, a
    call $4000
    xor a
    ld [de], a
    ret
    assert @ == $743e
