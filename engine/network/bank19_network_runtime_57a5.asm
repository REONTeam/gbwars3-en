include "macros/macros.inc"
; source-own the Bank $19 Network presentation/controller tranche
; from the first unowned byte after through the next independently
; farcalled boundary at $61E6. Internal labels are direct CALL/JP targets;
; user-facing field names remain conservative until later callers prove them.
section "Bank19 Network Runtime 57A5", romx[$57a5], bank[$19]
NetworkRuntime_57A5::
    farcall NetworkUI_InitializeMobileMenu
    farcall BANK_22, Bank22_Entry_64B8
    ld hl, $d839
    ld bc, $00ff
    ld a, $00
    call $3b79
    call $574e
    ld a, $0a
    ld bc, $0111
    ld de, $0301
    ld h, $44
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0411
    ld de, $0401
    ld h, $4c
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0911
    ld de, $0101
    ld h, $47
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0a11
    ld de, $0401
    ld h, $50
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $48
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $62
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0100
    ld de, $1203
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, $5a11
    call $336e
    ld bc, $0103
    ld de, $120e
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, $5a21
    call $336e
    ld hl, $5a28
    call $336e
    ld hl, $5a2c
    call $336e
    ld hl, $5a30
    call $336e
    ld hl, $5a36
    call $336e
    ld hl, $5a3a
    call $336e
    ld hl, $5a3e
    call $336e
    ld hl, $5a4a
    call $336e
    ld hl, $5a4e
    call $336e
    ld hl, $5a52
    call $336e
    ld hl, $5a5c
    call $336e
    ld hl, $5a60
    call $336e
    ld hl, $5a64
    call $336e
    ld hl, $5a6b
    call $336e
    ld hl, $5a6f
    call $336e
    ld hl, $5a73
    call $336e
    ld hl, $5a7f
    call $336e
    ld hl, $5a83
    call $336e
    ld hl, $5a83
    call $336e
    ld hl, $5a87
    call $336e
    ld a, $08
    ld bc, $0a0b
    ld de, $0101
    ld h, $68
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0d0b
    ld de, $0101
    ld h, $69
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $100b
    ld de, $0101
    ld h, $6a
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld hl, $d839
    call $61e6
    cp $00
    jr z, $58de
    ld hl, $d839
    ld bc, $0505
    call $3353
    ld hl, $d846
    call $61e6
    cp $00
    jr z, $58f1
    ld hl, $d846
    ld bc, $0507
    call $3353
    ld hl, $d853
    call $61e6
    cp $00
    jr z, $5904
    ld hl, $d853
    ld bc, $0b09
    call $3353
    ld hl, $d82e
    ld bc, $000b
    ld a, $00
    call $3b79
    ld de, $d85a
    ld hl, $d82e
    ld bc, $0004
    call $3b50
    ld de, $d85e
    ld hl, $d833
    ld bc, $0002
    call $3b50
    ld de, $d860
    ld hl, $d836
    ld bc, $0002
    call $3b50
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba79]
    cp $00
    jr nz, $594d
    ld hl, $d82e
    ld a, $00
    ld bc, $000b
    call $3b79
    call $059b
    ld hl, $d82e
    call $61e6
    cp $00
    jr z, $5975
    ld hl, $d82e
    ld bc, $060b
    call $3353
    ld hl, $d833
    ld bc, $0b0b
    call $3353
    ld hl, $d836
    ld bc, $0e0b
    call $3353
    ld a, [$d863]
    cp $ff
    jr z, $5991
    ld a, [$d863]
    cp $00
    jr nz, $598b
    ld hl, $5a05
    call $336e
    jr $5991
    ld hl, $5a0b
    call $336e
    ld a, [$d865]
    cp $ff
    jr z, $59ad
    ld a, [$d865]
    cp $00
    jr nz, $59a7
    ld hl, $59fc
    call $336e
    jr $59d5
    ld hl, $59f3
    call $336e
    ld hl, $da98
    ld bc, $000f
    ld a, $00
    call $3b79
    ld de, $d867
    ld hl, $da98
    ld bc, $000e
    call $3b50
    ld hl, $da98
    call $61e6
    jr z, $59d5
    ld hl, $da98
    ld bc, $030f
    call $3353
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call $2de8
    ld [$da41], a
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    call $5739
    call $3537
    ret
    db $0b, $0e, $6c, $9b, $64, $78, $aa, $5f, $00, $0b, $0e, $6c, $9b, $64, $76, $89
    db $62, $00, $0e, $0c, $68, $87, $72, $00, $0e, $0c, $68, $af, $89, $00, $03, $01
    db $f5, $0d, $c5, $0d, $87, $64, $ac, $6e, $0f, $97, $af, $72, $64, $00, $02, $04
    db $9e, $a6, $64, $77, $00, $04, $05, $2b, $00, $11, $05, $2d, $00, $02, $06, $89
    db $9d, $66, $00, $04, $07, $2b, $00, $11, $07, $2d, $00, $02, $08, $76, $ab, $62
    db $6a, $af, $8d, $89, $9d, $66, $00, $0a, $09, $2b, $00, $11, $09, $2d, $00, $02
    db $0a, $7a, $62, $8c, $af, $6b, $82, $93, $00, $05, $0b, $2b, $00, $11, $0b, $2d
    db $00, $02, $0c, $7a, $62, $98, $83, $00, $0d, $0c, $2b, $00, $11, $0c, $2d, $00
    db $02, $0e, $68, $76, $a8, $7a, $15, $f0, $0d, $fa, $2b, $00, $11, $0e, $2d, $00
    db $02, $0f, $2b, $00, $11, $0f, $2d, $00
NetworkRuntime_5A8B:
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call $57a5
    ld a, $02
    call $3816
    call $081d
NetworkRuntime_5A9F:
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 6, a
    jr z, $5ac0
    ld a, $01
    call $3844
    ld a, [$cbe0]
    dec a
    cp $ff
    jr nz, $5ab8
    ld a, $05
    ld [$cbe0], a
    call $5739
    jr $5a9f
    bit 7, a
    jr z, $5ada
    ld a, $01
    call $3844
    ld a, [$cbe0]
    inc a
    cp $06
    jr nz, $5ad2
    xor a
    ld [$cbe0], a
    call $5739
    jr $5a9f
    bit 0, a
    jr z, $5aec
    ld a, [$da41]
    farcall SpriteTransition_SlideRightOffscreen
    ld a, [$cbe0]
    jr $5b16
    jr $5a9f
    bit 1, a
    jr z, $5af9
    ld a, $0c
    call $3844
    ld a, $ff
    jr $5b16
    bit 3, a
    jr z, $5b13
    call $5b26
    or a
    jr z, $5b0a
    ld a, $03
    call $3844
    jr $5b13
    ld a, $02
    call $3844
    ld a, $fe
    jr $5b16
    jp $5a9f
    push af
    call $07b4
    call $2e67
    pop af
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    ret
NetworkRuntime_5B26:
    ld a, [$d839]
    or a
    jr z, $5b4e
    ld a, [$d846]
    or a
    jr z, $5b4e
    ld a, [$d853]
    or a
    jr z, $5b4e
    ld a, [$d85a]
    or a
    jr z, $5b4e
    ld a, [$d863]
    cp $ff
    jr z, $5b4e
    ld a, [$d865]
    cp $ff
    jr z, $5b4e
    xor a
    ret
    ld a, $01
    ret
NetworkRuntime_5B51:
    ld a, [$cbe1]
    cp $00
    jr z, $5b60
    cp $01
    jr z, $5b64
    cp $02
    jr z, $5b68
    ld a, $30
    jr $5b6c
    ld a, $60
    jr $5b6c
    ld a, $80
    jr $5b6c
    ld b, a
    push bc
    ld a, $64
    ld c, a
    ld a, [$da42]
    call $2eae
    pop bc
    ld a, $74
    ld c, a
    ld a, [$da43]
    call $2eae
    ret
NetworkRuntime_5B82:
    ld a, [$da44]
    ld bc, $030b
    ld d, $01
    call $31f5
    ld a, [$da45]
    ld bc, $040b
    ld d, $01
    call $31f5
    ld a, [$da46]
    ld bc, $050b
    ld d, $01
    call $31f5
    ld a, [$da47]
    ld bc, $060b
    ld d, $01
    call $31f5
    ld a, [$da48]
    ld bc, $0a0b
    ld d, $02
    call $3244
    ld a, [$da49]
    ld bc, $0e0b
    ld d, $02
    call $3244
    ret
NetworkRuntime_5BC5:
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba79]
    cp $01
    jr z, $5bfc
    ld a, $32
    ld [$d85a], a
    ld a, $30
    ld [$d85b], a
    ld a, $30
    ld [$d85c], a
    ld a, $31
    ld [$d85d], a
    ld a, $30
    ld [$d85e], a
    ld a, $31
    ld [$d85f], a
    ld a, $30
    ld [$d860], a
    ld a, $31
    ld [$d861], a
    call $059b
    ld a, [$d85a]
    sub $30
    ld [$da44], a
    ld a, [$d85b]
    sub $30
    ld [$da45], a
    ld a, [$d85c]
    sub $30
    ld [$da46], a
    ld a, [$d85d]
    sub $30
    ld [$da47], a
    ld a, [$d85e]
    sub $30
    ld b, $0a
    call $2995
    ld a, l
    ld [$da48], a
    ld a, [$d85f]
    sub $30
    ld c, a
    ld a, [$da48]
    add a, c
    ld [$da48], a
    ld a, [$d860]
    sub $30
    ld b, $0a
    call $2995
    ld a, l
    ld [$da49], a
    ld a, [$d861]
    sub $30
    ld c, a
    ld a, [$da49]
    add a, c
    ld [$da49], a
    ret
NetworkRuntime_5C56:
    ld a, [$da44]
    add a, $30
    ld [$d85a], a
    ld a, [$da45]
    add a, $30
    ld [$d85b], a
    ld a, [$da46]
    add a, $30
    ld [$d85c], a
    ld a, [$da47]
    add a, $30
    ld [$d85d], a
    ld a, [$da48]
    ld b, $0a
    farcall Math_DivideAByB
    ld a, b
    add a, $30
    ld [$d85e], a
    ld a, [$da48]
    ld b, $0a
    farcall Math_DivideAByB
    add a, $30
    ld [$d85f], a
    ld a, [$da49]
    ld b, $0a
    farcall Math_DivideAByB
    ld a, b
    add a, $30
    ld [$d860], a
    ld a, [$da49]
    ld b, $0a
    farcall Math_DivideAByB
    add a, $30
    ld [$d861], a
    ret
NetworkRuntime_5CB1:
    farcall NetworkUI_InitializeMobileMenu
    call $71b1
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $48
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $62
    farcall Gfx_DrawSequentialTileRectWithAttributes
    call $5bc5
    ld hl, $5d16
    call $336e
    ld hl, $5d21
    call $336e
    ld hl, $5d30
    call $336e
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fb4
    call $2de8
    ld [$da42], a
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call $2de8
    ld [$da43], a
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    call $5b51
    call $5b82
    ret
    db $02, $02, $7a, $62, $8c, $af, $6b, $82, $93, $ae, $00, $02, $03, $8a, $a4, $64
    db $a9, $a6, $6e, $76, $85, $6e, $7f, $74, $62, $00, $07, $0b, $8c, $af, $5f, $5f
    db $5f, $6b, $83, $5f, $5f, $8a, $80, $00
NetworkRuntime_5D3E:
    call $5e29
    ret
NetworkRuntime_5D42:
    ld d, h
    ld e, l
    ld bc, $03e8
    call $2a21
    ld a, e
    ld [$da44], a
    ld h, b
    ld l, c
    ld d, h
    ld e, l
    ld bc, $0064
    call $2a21
    ld a, e
    ld [$da45], a
    ld h, b
    ld l, c
    ld d, h
    ld e, l
    ld bc, $000a
    call $2a21
    ld a, e
    ld [$da46], a
    ld h, b
    ld l, c
    ld a, c
    ld [$da47], a
    ret
NetworkRuntime_5D71:
    push hl
    ld de, $076b
    call $29ca
    jr c, $5d7c
    jr $5d89
    pop hl
    push hl
    ld de, $07d5
    call $29ca
    jr c, $5d89
    pop hl
    jr $5d8d
    pop hl
    xor a
    scf
    ret
    xor a
    ret
NetworkRuntime_5D8F:
    ld a, [$cbe1]
    cp $00
    jr z, $5d9e
    cp $01
    jr z, $5db1
    cp $02
    jr z, $5dc2
    call $5d3e
    inc hl
    call $5d71
    jr nc, $5daa
    ld hl, $076c
    call $5d42
    call $5e67
    ret
    ld a, [$da48]
    inc a
    cp $0d
    jr nz, $5dbb
    ld a, $01
    ld [$da48], a
    call $5e67
    ret
    ld a, [$da49]
    inc a
    cp $20
    jr nz, $5dcc
    ld a, $01
    ld [$da49], a
    call $5e67
    jr c, $5dd6
    jr $5dd7
    ret
    ld a, $01
    ld [$da49], a
    ret
NetworkRuntime_5DDD:
    ld a, [$cbe1]
    cp $00
    jr z, $5dec
    cp $01
    jr z, $5dff
    cp $02
    jr z, $5e10
    call $5d3e
    dec hl
    call $5d71
    jr nc, $5df8
    ld hl, $07d5
    call $5d42
    call $5e67
    ret
    ld a, [$da48]
    dec a
    cp $00
    jr nz, $5e09
    ld a, $0c
    ld [$da48], a
    call $5e67
    ret
    ld a, [$da49]
    dec a
    cp $00
    jr nz, $5e1a
    ld a, $1f
    ld [$da49], a
    call $5e82
    jr c, $5e24
    jr $5e25
    ret
    call $5e67
    ret
NetworkRuntime_5E29:
    ld bc, $0000
    push bc
    ld a, [$da44]
    ld d, $00
    ld e, a
    ld hl, $03e8
    call $29d8
    pop bc
    add hl, bc
    ld b, h
    ld c, l
    push bc
    ld a, [$da45]
    ld d, $00
    ld e, a
    ld hl, $0064
    call $29d8
    pop bc
    add hl, bc
    ld b, h
    ld c, l
    push bc
    ld a, [$da46]
    ld d, $00
    ld e, a
    ld hl, $000a
    call $29d8
    pop bc
    add hl, bc
    ld b, h
    ld c, l
    ld a, [$da47]
    ld h, $00
    ld l, a
    add hl, bc
    ret
NetworkRuntime_5E67:
    call $5e29
    ld a, [$da48]
    farcall Bank31_SelectIndexedRangeValue_5F27
    inc a
    ld c, a
    ld a, [$da49]
    cp c
    jr c, $5e7b
    jr $5e7c
    ret
    dec c
    ld a, c
    ld [$da49], a
    ret
NetworkRuntime_5E82:
    call $5e29
    ld a, [$da48]
    farcall Bank31_SelectIndexedRangeValue_5F27
    inc a
    ld c, a
    ld a, [$da49]
    cp c
    ret
NetworkRuntime_5E93:
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call $5cb1
    call $081d
NetworkRuntime_5EA2:
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 6, a
    jr z, $5eb9
    ld a, $01
    call $3844
    call $5d8f
    call $5b82
    jr $5ea2
    bit 7, a
    jr z, $5eca
    ld a, $01
    call $3844
    call $5ddd
    call $5b82
    jr $5ea2
    bit 5, a
    jr z, $5ee5
    ld a, $01
    call $3844
    ld a, [$cbe1]
    dec a
    cp $ff
    jr nz, $5edd
    ld a, $02
    ld [$cbe1], a
    call $5b51
    jr $5ea2
    bit 4, a
    jr z, $5eff
    ld a, $01
    call $3844
    ld a, [$cbe1]
    inc a
    cp $03
    jr nz, $5ef7
    xor a
    ld [$cbe1], a
    call $5b51
    jr $5ea2
    bit 0, a
    jr z, $5f20
    ld a, $02
    call $3844
    call $5c56
    call $4e05
    ld a, $0e
    call $058d
    call $0593
    ld a, $01
    ld [$ba79], a
    call $059b
    jr $5f30
    bit 1, a
    jr z, $5f2d
    ld a, $0c
    call $3844
    ld a, $ff
    jr $5f30
    jp $5ea2
    push af
    call $07b4
    call $2e67
    pop af
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    ret
NetworkRuntime_5F40:
    ld a, [$cbe2]
    ld b, $08
    call $2995
    ld a, l
    add a, $64
    ld c, a
    ld b, $40
    ld a, [$da4a]
    call $2eae
    ret
NetworkRuntime_5F55:
    farcall NetworkUI_InitializeMobileMenu
    call $71b1
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $48
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $62
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld hl, $5fab
    call $336e
    ld hl, $5fb3
    call $336e
    ld hl, $5fc2
    call $336e
    ld hl, $5fc8
    call $336e
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f98
    call $2de8
    ld [$da4a], a
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    call $5f40
    ret
    db $02, $02, $7a, $62, $98, $83, $ae, $00, $02, $03, $8a, $a4, $64, $a9, $a6, $6e
    db $76, $85, $6e, $7f, $74, $62, $00, $08, $0a, $68, $87, $72, $00, $08, $0b, $68
    db $af, $89, $00
NetworkRuntime_5FCE:
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call $5f55
    call $081d
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 6, a
    jr z, $5ffe
    ld a, $01
    call $3844
    ld a, [$cbe2]
    dec a
    cp $ff
    jr nz, $5ff6
    ld a, $01
    ld [$cbe2], a
    call $5f40
    jr $5fdd
    bit 7, a
    jr z, $6018
    ld a, $01
    call $3844
    ld a, [$cbe2]
    inc a
    cp $02
    jr nz, $6010
    xor a
    ld [$cbe2], a
    call $5f40
    jr $5fdd
    bit 0, a
    jr z, $602c
    ld a, $02
    call $3844
    ld a, [$cbe2]
    ld [$d863], a
    call $4df3
    jr $603b
    bit 1, a
    jr z, $6039
    ld a, $0c
    call $3844
    ld a, $ff
    jr $603b
    jr $5fdd
    push af
    call $07b4
    call $2e67
    pop af
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    ret
NetworkRuntime_604B:
    ld a, [$cbe3]
    ld b, $08
    call $2995
    ld a, l
    add a, $74
    ld c, a
    ld b, $3c
    ld a, [$da4b]
    call $2eae
    ret
NetworkRuntime_6060:
    farcall NetworkUI_InitializeMobileMenu
    call $71b1
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $48
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $62
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld hl, $60ce
    call $336e
    ld hl, $60da
    call $336e
    ld hl, $60e5
    call $336e
    ld hl, $60f4
    call $336e
    ld hl, $6103
    call $336e
    ld hl, $6112
    call $336e
    ld hl, $6121
    call $336e
    ld hl, $6129
    call $336e
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f98
    call $2de8
    ld [$da4b], a
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    call $604b
    ret
    db $02, $02, $68, $76, $a8, $7a, $15, $f0, $0d, $fa, $ae, $00, $02, $03, $6c, $9b
    db $64, $76, $9d, $78, $6a, $3f, $00, $02, $07, $b5, $b8, $0d, $c9, $dc, $d2, $d7
    db $ca, $ff, $ce, $0d, $8a, $00, $02, $08, $61, $89, $7e, $61, $85, $8d, $f0, $d2
    db $ca, $0d, $c7, $a3, $00, $02, $09, $ed, $d2, $e6, $d6, $0d, $ce, $6b, $61, $aa
    db $72, $87, $ae, $00, $02, $0a, $15, $f0, $0d, $fa, $86, $68, $76, $a8, $7a, $76
    db $9d, $78, $00, $07, $0c, $6c, $9b, $64, $78, $aa, $00, $07, $0d, $6c, $9b, $64
    db $76, $89, $62, $00
NetworkRuntime_6132:
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call $6060
    call $081d
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 6, a
    jr z, $6162
    ld a, $01
    call $3844
    ld a, [$cbe3]
    dec a
    cp $ff
    jr nz, $615a
    ld a, $01
    ld [$cbe3], a
    call $604b
    jr $6141
    bit 7, a
    jr z, $617c
    ld a, $01
    call $3844
    ld a, [$cbe3]
    inc a
    cp $02
    jr nz, $6174
    xor a
    ld [$cbe3], a
    call $604b
    jr $6141
    bit 0, a
    jr z, $61a4
    ld a, $02
    call $3844
    ld a, [$cbe3]
    cp $00
    jr z, $618e
    jr $6199
    ld a, $01
    ld [$d865], a
    call $4e1d
    xor a
    jr $61b3
    xor a
    ld [$d865], a
    call $4e1d
    ld a, $ff
    jr $61b3
    bit 1, a
    jr z, $61b1
    ld a, $0c
    call $3844
    ld a, $ff
    jr $61b3
    jr $6141
    push af
    call $07b4
    call $2e67
    pop af
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    ret
NetworkRuntime_61C3:
    ld a, [$da4d]
    ld b, $08
    call $2995
    ld a, l
    add a, $1c
    ld d, a
    push de
    ld a, [$da4e]
    ld b, $08
    call $2995
    ld a, l
    add a, $64
    ld c, a
    pop de
    ld a, d
    ld b, a
    ld a, [$da4c]
    call $2eae
    ret
    assert @ == $61e6
