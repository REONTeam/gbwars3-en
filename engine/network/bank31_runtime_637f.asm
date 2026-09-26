include "macros/macros.inc"

; Bank $31 continuation from the externally reached $637F entry.
; The tranche closes the persistent-cursor controller, compact lookup data, arithmetic helpers,
; and paired SRAM-bank-$0E indexed word read/write helpers through $655C.
; $655D is the next independently farcalled Bank-$31 entry (Bank $19:$4701).

; Controller over the two persistent cursor families; higher-level screen/statistic identity remains neutral.
section " Bank31_PersistentCursorController_637F", romx[$637f], bank[$31]
Bank31_PersistentCursorController_637F::
    farcall Bank31_TestPersistentCursorBAgainstLimit_626C
    cp $00
    jr z, $6391
    farcall Bank31_TestPersistentCursorAAgainstLimit_61F3
    cp $00
    jr z, $63b3
    jr $63c9
    farcall Bank31_TestStagedIndexAgainstLimit_65AD
    jr c, $63c9
    farcall Bank31_RuntimeValidation_6054
    jr nc, $63a7
    farcall Bank31_RuntimeSetup_5F9C
    jr nc, $63a7
    farcall Bank31_RuntimeSetup_600F
    farcall Bank31_AdvancePersistentLimitBAndTest_6296
    farcall Bank31_TestPersistentCursorAAgainstLimit_61F3
    cp $01
    jr z, $637f
    farcall Bank31_TestStagedIndexAgainstLimit_65AD
    jr c, $63c9
    farcall Bank31_PersistentCursorActionB_6407
    jr nc, $63c3
    farcall Bank31_PersistentCursorActionA_63CA
    farcall Bank31_AdvancePersistentLimitAAndTest_621D
    jr $637f
    ret
    assert @ == $63ca

section " Bank31_PersistentCursorActionA_63CA", romx[$63ca], bank[$31]
Bank31_PersistentCursorActionA_63CA::
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba40]
    ld h, a
    ld a, [$ba41]
    ld l, a
    ld de, $0000
    call $29ca
    jr z, $6403
    ld a, $01
    call $609c
    ld de, $6c0c
    ld b, $01
    ld c, $39
    ld a, $07
    ld [$caae], a
    ld a, $00
    ld [$caaf], a
    farcall BANK_31, Bank31_Entry_6ECC
    ld a, [$cacc]
    inc a
    ld [$cacc], a
    call $059b
    ret
    assert @ == $6407

section " Bank31_PersistentCursorActionB_6407", romx[$6407], bank[$31]
Bank31_PersistentCursorActionB_6407::
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba40]
    ld h, a
    ld a, [$ba41]
    ld l, a
    ld de, $0000
    call $29ca
    jr z, $648c
    ld a, [$ba42]
    ld h, a
    ld a, [$ba43]
    ld l, a
    inc hl
    call $64de
    ld b, $07
    call $2995
    ld a, l
    ld hl, $6491
    call $29bc
    ld a, [hli]
    ld [$caae], a
    ld a, $00
    ld [$caaf], a
    ld a, [hli]
    cp $ff
    jr z, $648c
    push hl
    ld d, a
    call $294b
    cp $00
    jr z, $6451
    pop hl
    jr $648c
    pop hl
    ld a, [hli]
    push af
    ld a, [hli]
    ld b, a
    ld a, h
    ld [$c021], a
    ld a, l
    ld [$c022], a
    pop af
    ld h, b
    ld l, a
    call $6510
    call $059b
    cp $00
    jr z, $648c
    push af
    call $609c
    ld a, [$c021]
    ld h, a
    ld a, [$c022]
    ld l, a
    ld a, [hli]
    ld e, a
    ld a, [hli]
    ld d, a
    ld a, [hl]
    ld c, a
    pop af
    ld b, a
    farcall BANK_31, Bank31_Entry_6ECC
    ld a, [$cacc]
    inc a
    ld [$cacc], a
    xor a
    ret
    call $059b
    scf
    ret
    assert @ == $6491

section " Bank31_CursorLookupParameterData_6491", romx[$6491], bank[$31]
Bank31_CursorLookupParameterData_6491::
    ld b, $09
    dec b
    add hl, bc
    xor b
    ld l, l
    ld h, [hl]
    rst $38
    rst $38
    ld bc, $ff01
    rst $38
    rst $38
    rst $38
    rst $38
    ld bc, $ff01
    rst $38
    rst $38
    rst $38
    rst $38
    ld bc, $ff01
    rst $38
    rst $38
    rst $38
    rst $38
    ld bc, $ff01
    rst $38
    rst $38
    dec b
    inc de
    ld [bc], a
    dec b
    rst $18
    ld l, h
    ld e, h
    rst $38
    rst $38
    ld bc, $ff01
    rst $38
    rst $38
    rst $38
    rst $38
    ld bc, $ff01
    rst $38
    rst $38
    rst $38
    rst $38
    ld bc, $ff01
    rst $38
    rst $38
    rst $38
    rst $38
    ld bc, $ff01
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    assert @ == $64de

section " Bank31_ArithmeticHelper_64DE", romx[$64de], bank[$31]
Bank31_ArithmeticHelper_64DE::
    ld d, h
    ld e, l
    ld bc, $2710
    call $2a21
    ld h, b
    ld l, c
    ld d, h
    ld e, l
    ld bc, $03e8
    call $2a21
    ld h, b
    ld l, c
    ld d, h
    ld e, l
    ld bc, $0064
    call $2a21
    ld h, b
    ld l, c
    ld d, h
    ld e, l
    ld bc, $000a
    call $2a21
    ld h, b
    ld l, c
    ld d, h
    ld e, l
    ld bc, $0001
    call $2a21
    ld a, e
    ret
    assert @ == $6510

section " Bank31_IndexAdjustHelper_6510", romx[$6510], bank[$31]
Bank31_IndexAdjustHelper_6510::
    push hl
    ld a, h
    ld c, a
    ld a, l
    pop hl
    cp c
    jr z, $6525
    ld a, l
    ld c, a
    ld a, h
    sub c
    push hl
    ld d, a
    call $294b
    pop hl
    ld c, a
    ld a, l
    add a, c
    ret
    assert @ == $6526

section " Bank31_ReadPersistentWordBA44ByIndex_6526", romx[$6526], bank[$31]
Bank31_ReadPersistentWordBA44ByIndex_6526::
    ld e, a
    ld a, $0e
    call $058d
    call $0593
    ld a, e
    add a, a
    add a, $44
    ld l, a
    ld a, $ba
    adc a, $00
    ld h, a
    ld a, [hli]
    ld h, [hl]
    ld l, a
    call $059b
    ret
    assert @ == $6540

section " Bank31_WritePersistentWordBA44ByIndex_6540", romx[$6540], bank[$31]
Bank31_WritePersistentWordBA44ByIndex_6540::
    ld e, a
    ld a, $0e
    call $058d
    call $0593
    ld a, e
    ld d, h
    ld e, l
    add a, a
    add a, $44
    ld l, a
    ld a, $ba
    adc a, $00
    ld h, a
    ld a, e
    ld [hli], a
    ld a, d
    ld [hl], a
    call $059b
    ret
    assert @ == $655d
