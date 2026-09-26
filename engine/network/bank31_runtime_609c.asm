include "macros/macros.inc"

; Bank $31 continuation from the externally reached $609C entry.
; This tranche closes the capped persistent counter, decimal formatting, persistent
; cursor/range helper family, and the five-digit display bridge through $637E.
; $637F is the next independently reached Bank-$31 entry (Bank $27:$6874 and same-bank callers).

; Adds incoming A to SRAM-bank-$0E byte $A106 and saturates the stored value at decimal 99.
section " Bank31_AddToPersistentCounterA106Capped99", romx[$609c], bank[$31]
Bank31_AddToPersistentCounterA106Capped99::
    ld e, a
    ld a, $0e
    call $058d
    call $0593
    ld a, e
    push af
    ld a, [$a106]
    ld c, a
    pop af
    add a, c
    cp $64
    jr nc, $60b3
    jr $60b5
    ld a, $63
    ld [$a106], a
    call $059b
    ret
    assert @ == $60bc

section " Bank31_SelectFiveWayParameterRecord", romx[$60bc], bank[$31]
Bank31_SelectFiveWayParameterRecord::
    ld b, $00
    ld c, a
    ld hl, $60ed
    ld a, [hli]
    cp $ff
    jr z, $60d2
    cp c
    jr z, $60d5
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    jr $60c2
    ld a, $ff
    ret
    ld b, a
    ld a, [hli]
    ld c, a
    ld a, [hli]
    ld e, a
    ld a, [hli]
    ld d, a
    ld a, [hli]
    ld [$caae], a
    ld a, $01
    ld [$caaf], a
    ld a, [hli]
    push af
    ld a, [hl]
    ld l, a
    pop af
    ld h, a
    ld a, c
    ret
    assert @ == $60ed

section " Bank31_FiveWayParameterRecords", romx[$60ed], bank[$31]
Bank31_FiveWayParameterRecords::
    ld a, [bc]
    inc bc
    ld d, $67
    nop
    ld a, [de]
    ld a, [hld]
    inc d
    dec b
    ldh a, [$ff67]
    ld bc, $3a1a
    ld [hld], a
    ld a, [bc]
    ret
    db $68, $02, $1a, $3a, $4d, $19, $93, $69, $03, $1a, $3a, $64, $63, $60, $6a, $04
    db $1a, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    assert @ == $6117

section " Bank31_StageAndWriteOneOrTwoDigitDecimal_6117", romx[$6117], bank[$31]
Bank31_StageAndWriteOneOrTwoDigitDecimal_6117::
    ld a, $da
    ld [$c021], a
    ld a, $a8
    ld [$c022], a
    ld a, b
    ld [$c023], a
    ld [$c027], a
    ld a, c
    ld [$c024], a
    ld a, h
    ld [$c025], a
    ld a, l
    ld [$c026], a
    ld a, [$c026]
    cp $ff
    jr z, $6163
    ld a, [$c021]
    ld h, a
    ld a, [$c022]
    ld l, a
    ld a, [$c026]
    call $29bc
    ld a, [$c024]
    ld e, a
    ld d, $00
    ld bc, $000a
    call $2a21
    ld a, e
    cp $00
    jr z, $615e
    ld a, e
    add a, $30
    ld [hl], a
    inc hl
    ld a, c
    add a, $30
    ld [hl], a
    ret
    assert @ == $6164

section " Bank31_WriteOneOrTwoDigitDecimalC_6164", romx[$6164], bank[$31]
Bank31_WriteOneOrTwoDigitDecimalC_6164::
    ld a, $da
    ld [$c021], a
    ld a, $a8
    ld [$c022], a
    ld a, c
    ld [$c024], a
    ld a, [$c021]
    ld h, a
    ld a, [$c022]
    ld l, a
    ld a, [$c026]
    call $29bc
    ld a, [$c024]
    ld e, a
    ld d, $00
    ld bc, $000a
    call $2a21
    ld a, e
    cp $00
    jr z, $6195
    ld a, e
    add a, $30
    ld [hl], a
    inc hl
    ld a, c
    add a, $30
    ld [hl], a
    ret
    assert @ == $619b

section " Bank31_WriteOneOrTwoDigitDecimalB_619B", romx[$619b], bank[$31]
Bank31_WriteOneOrTwoDigitDecimalB_619B::
    ld a, $da
    ld [$c021], a
    ld a, $a8
    ld [$c022], a
    ld a, b
    ld [$c024], a
    ld a, c
    ld [$c025], a
    ld a, [$c021]
    ld h, a
    ld a, [$c022]
    ld l, a
    ld a, [$c025]
    call $29bc
    ld a, [$c024]
    ld e, a
    ld d, $00
    ld bc, $000a
    call $2a21
    ld a, e
    cp $00
    jr z, $61d0
    ld a, e
    add a, $30
    ld [hl], a
    inc hl
    ld a, c
    add a, $30
    ld [hl], a
    ret
    assert @ == $61d6

section " Bank31_AdvancePersistentCursorA_61D6", romx[$61d6], bank[$31]
Bank31_AdvancePersistentCursorA_61D6::
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba40]
    ld h, a
    ld a, [$ba41]
    ld l, a
    inc hl
    ld a, h
    ld [$ba40], a
    ld a, l
    ld [$ba41], a
    call $059b
    ret
    assert @ == $61f3

section " Bank31_TestPersistentCursorAAgainstLimit_61F3", romx[$61f3], bank[$31]
Bank31_TestPersistentCursorAAgainstLimit_61F3::
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba40]
    ld h, a
    ld a, [$ba41]
    ld l, a
    ld a, [$ba42]
    ld d, a
    ld a, [$ba43]
    ld e, a
    call $29ca
    jr z, $6212
    jr $6218
    ld a, $01
    call $059b
    ret
    xor a
    call $059b
    ret
    assert @ == $621d

section " Bank31_AdvancePersistentLimitAAndTest_621D", romx[$621d], bank[$31]
Bank31_AdvancePersistentLimitAAndTest_621D::
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba42]
    ld h, a
    ld a, [$ba43]
    ld l, a
    inc hl
    ld a, h
    ld [$ba42], a
    ld a, l
    ld [$ba43], a
    ld a, [$ba40]
    ld d, a
    ld a, [$ba41]
    ld e, a
    call $29ca
    jr z, $6245
    jr $624a
    call $059b
    xor a
    ret
    call $059b
    scf
    ret
    assert @ == $624f

section " Bank31_AdvancePersistentCursorB_624F", romx[$624f], bank[$31]
Bank31_AdvancePersistentCursorB_624F::
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba3c]
    ld h, a
    ld a, [$ba3d]
    ld l, a
    inc hl
    ld a, h
    ld [$ba3c], a
    ld a, l
    ld [$ba3d], a
    call $059b
    ret
    assert @ == $626c

section " Bank31_TestPersistentCursorBAgainstLimit_626C", romx[$626c], bank[$31]
Bank31_TestPersistentCursorBAgainstLimit_626C::
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba3c]
    ld h, a
    ld a, [$ba3d]
    ld l, a
    ld a, [$ba3e]
    ld d, a
    ld a, [$ba3f]
    ld e, a
    call $29ca
    jr z, $628b
    jr $6291
    ld a, $01
    call $059b
    ret
    xor a
    call $059b
    ret
    assert @ == $6296

section " Bank31_AdvancePersistentLimitBAndTest_6296", romx[$6296], bank[$31]
Bank31_AdvancePersistentLimitBAndTest_6296::
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba3e]
    ld h, a
    ld a, [$ba3f]
    ld l, a
    inc hl
    ld a, h
    ld [$ba3e], a
    ld a, l
    ld [$ba3f], a
    ld a, [$ba3c]
    ld d, a
    ld a, [$ba3d]
    ld e, a
    call $29ca
    jr z, $62be
    jr $62c3
    call $059b
    xor a
    ret
    call $059b
    scf
    ret
    assert @ == $62c8

section " Bank31_FormatSelectedPersistentCursor_62C8", romx[$62c8], bank[$31]
Bank31_FormatSelectedPersistentCursor_62C8::
    ld a, [$caae]
    add a, a
    ld hl, $631c
    call $29bc
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a
    ld hl, $daa8
    add hl, de
    push hl
    ld a, [$caaf]
    cp $00
    jr z, $62e4
    jr $62fa
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba42]
    ld h, a
    ld a, [$ba43]
    ld l, a
    inc hl
    call $059b
    jr $630e
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba3e]
    ld h, a
    ld a, [$ba3f]
    ld l, a
    inc hl
    call $059b
    call $6330
    pop hl
    ld de, $dc10
    ld bc, $0005
    call $3b50
    ret
    assert @ == $631c

section " Bank31_DisplayOffsetTable_631C", romx[$631c], bank[$31]
Bank31_DisplayOffsetTable_631C::
    xor l
    nop
    xor h
    nop
    sbc a, l
    nop
    and b
    nop
    xor c
    nop
    sbc a, h
    nop
    and [hl]
    nop
    and [hl]
    nop
    xor c
    nop
    xor c
    nop
    assert @ == $6330

section " Bank31_WriteFiveDigitDecimalToDC10_6330", romx[$6330], bank[$31]
Bank31_WriteFiveDigitDecimalToDC10_6330::
    ld d, h
    ld e, l
    ld bc, $2710
    call $2a21
    ld h, b
    ld l, c
    ld a, e
    add a, $30
    ld [$dc10], a
    ld d, h
    ld e, l
    ld bc, $03e8
    call $2a21
    ld h, b
    ld l, c
    ld a, e
    add a, $30
    ld [$dc11], a
    ld d, h
    ld e, l
    ld bc, $0064
    call $2a21
    ld h, b
    ld l, c
    ld a, e
    add a, $30
    ld [$dc12], a
    ld d, h
    ld e, l
    ld bc, $000a
    call $2a21
    ld h, b
    ld l, c
    ld a, e
    add a, $30
    ld [$dc13], a
    ld d, h
    ld e, l
    ld bc, $0001
    call $2a21
    ld a, e
    add a, $30
    ld [$dc14], a
    ret
    assert @ == $637f
