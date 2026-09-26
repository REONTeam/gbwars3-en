
; Shift-JIS to the game's one-byte text code converter used by
; Bank $22's external-text stream parser. Unsupported inputs map to $0A.
section "Shift-JIS Text Code Converter", rom0[$338b]
Text_ConvertShiftJISToGameCode::
    ld a, b
    cp $82
    jr z, $33a5
    cp $83
    jr z, $33b3
    and a
    jr nz, $33c4
    ld a, c
    cp $80
    jr nc, $33c4
    sub $20
    jr c, $33c4
    ld hl, $33c7
    jr $33bf
    ld a, c
    cp $f2
    jr nc, $33c4
    sub $9f
    jr c, $33c4
    ld hl, $3427
    jr $33bf
    ld a, c
    cp $94
    jr nc, $33c4
    sub $40
    jr c, $33c4
    ld hl, $347a
    call $29bc
    ld a, [hl]
    ret
    ld a, $0a
    ret
Text_ShiftJISASCIIMap::
    ld e, a
    ld bc, $0302
    inc b
    dec b
    ld b, $07
    ld [$0a09], sp
    dec bc
    inc c
    dec c
    ld c, $0f
    jr nc, $340a
    ld [hld], a
    inc sp
    inc [hl]
    dec [hl]
    ld [hl], $37
    jr c, $341a
    ld a, [hld]
    dec sp
    inc a
    dec a
    ld a, $3f
    db $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f
    db $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f
    db $40, $41, $42
    ld b, e
    ld b, h
    ld b, l
    ld b, [hl]
    ld b, a
    ld c, b
    ld c, c
    ld c, d
    ld c, e
    ld c, h
    ld c, l
    ld c, [hl]
    ld c, a
    ld d, b
    ld d, c
    ld d, d
    ld d, e
    ld d, h
    ld d, l
    ld d, [hl]
    ld d, a
    ld e, b
    ld e, c
    ld e, d
    ld e, e
    ld e, h
    ld e, l
    ld e, [hl]
    ld a, [bc]
Text_ShiftJISLead82Map::
    ld h, b
    ld h, c
    ld h, e
    ld h, d
    ld h, l
    ld h, h
    ld h, a
    ld h, [hl]
    ld l, c
    ld l, b
    ld l, d
    ld l, e
    ld l, h
    ld l, l
    ld l, [hl]
    ld l, a
    ld [hl], b
    ld [hl], c
    ld [hl], d
    ld [hl], e
    ld [hl], h
    ld [hl], l
    halt
    db $77, $78, $79, $7a, $7b, $7c, $7d, $7e, $7f, $80, $81, $82, $83, $84, $85, $86
    db $87, $88, $89, $8a, $8b, $8c, $8d, $8e, $8f, $90, $91, $92, $93, $94, $95, $96
    db $97, $98, $99, $9a, $9b, $9c, $9d, $9e, $9f, $a0, $a1, $a2, $a3, $a4, $a5, $a6
    db $a7, $a8, $a9, $aa, $ab, $ac, $0a, $ad, $0a, $0a, $ae, $af
Text_ShiftJISLead83Map::
    or b
    or c
    or d
    or e
    or h
    or l
    or [hl]
    or a
    cp b
    cp c
    cp d
    cp e
    cp h
    cp l
    cp [hl]
    cp a
    ret nz
    pop bc
    jp nz, $c4c3
    push bc
    add a, $c7
    ret z
    ret
    db $ca, $cb, $cc, $cd, $ce, $cf, $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9
    db $da, $db, $dc, $dd, $de, $df, $e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9
    db $ea, $eb, $ec, $ed, $ee, $0a, $ef, $f0, $f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8
    db $f9, $fa, $fb, $fc, $0a, $fd, $0a, $0a, $fe, $ff
    assert @ == $34ce
