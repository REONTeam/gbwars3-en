include "macros/macros.inc"
; Bank $31 continuation from the externally reached $655D entry.
; The tranche preserves hard caller-backed boundaries through $66E3.
; $66E4 is the next independently farcalled Bank-$31 entry (Bank $22:$64AA).

; Validates a nonzero/non-$FFFF 16-bit selection against the indexed persistent-word table rooted at SRAM $BA44; higher-level UI identity remains neutral.
section " Bank31_ValidateIndexedPersistentWordSelection_655D", romx[$655d], bank[$31]
Bank31_ValidateIndexedPersistentWordSelection_655D::
    ld [$cbff], a
    ld a, h
    ld [$cbfb], a
    ld a, l
    ld [$cbfc], a
    ld a, [$cbfb]
    ld h, a
    ld a, [$cbfc]
    ld l, a
    ld de, $0000
    call $29ca
    jr z, $65a5
    ld a, [$cbfb]
    ld h, a
    ld a, [$cbfc]
    ld l, a
    ld de, $ffff
    call $29ca
    jr z, $65ab
    ld a, [$cbff]
    call $6526
    ld a, h
    ld [$cbfd], a
    ld a, l
    ld [$cbfe], a
    ld a, [$cbfb]
    ld d, a
    ld a, [$cbfc]
    ld e, a
    call $29ca
    jr z, $65a7
    jr $65a9
    scf
    ret
    scf
    ret
    xor a
    ret
    xor a
    ret
    assert @ == $65ad

section " Bank31_TestStagedIndexAgainstLimit_65AD", romx[$65ad], bank[$31]
Bank31_TestStagedIndexAgainstLimit_65AD::
    ld a, [$cacc]
    ld c, a
    ld a, [$cacd]
    dec a
    cp c
    jr c, $65ba
    xor a
    ret
    scf
    ret
    assert @ == $65bc

section " Bank31_PersistentSelectionAction_65BC", romx[$65bc], bank[$31]
Bank31_PersistentSelectionAction_65BC::
    farcall Bank31_CopyFourByteStagingState_6622
    ld de, $a0cc
    ld hl, $4a97
    farcall BANK_0A, Bank0A_Entry_4A53
    jr nc, $6621
    ld a, $0f
    call $058d
    call $0593
    ld hl, $a0cf
    ld a, [hli]
    push hl
    sub $30
    ld b, $0a
    call $2995
    ld c, l
    pop hl
    ld a, [hl]
    sub $30
    add a, c
    call $059b
    call $609c
    ld hl, $d826
    ld a, [hli]
    push af
    ld a, [hl]
    ld h, a
    pop af
    ld l, a
    ld de, $a0cc
    add hl, de
    ld a, $0f
    call $058d
    call $0593
    xor a
    ld [hl], a
    call $059b
    ld a, $ff
    ld hl, $a0d3
    farcall BANK_22, Bank22_Entry_7C19
    farcall BANK_31, Bank31_Entry_73EC
    ld a, [$cbfb]
    ld h, a
    ld a, [$cbfc]
    ld l, a
    ld a, [$cbff]
    call $6540
    ret
    assert @ == $6622

section " Bank31_CopyFourByteStagingState_6622", romx[$6622], bank[$31]
Bank31_CopyFourByteStagingState_6622::
    ld a, [$d82a]
    ld [$d6a7], a
    ld a, [$d82b]
    ld [$d6a8], a
    ld a, [$d828]
    ld [$d6aa], a
    ld a, [$d829]
    ld [$d6ab], a
    ret
    db $fa, $cc, $ca, $4f, $fa, $cd, $ca, $91, $c9
    assert @ == $6644

section " Bank31_StreamRecordWalkerA_6644", romx[$6644], bank[$31]
Bank31_ConvertShiftJISSingleByteAndAppend::
Bank31_StreamRecordWalkerA_6644::
    push hl
    xor a
    ld b, a
    ld a, [hl]
    ld c, a
    call $338b
    push af
    ld a, [$df04]
    ld h, a
    ld a, [$df05]
    ld l, a
    ld de, $dc0e
    call $29ca
    jr z, $666b
    pop af
    ld [hl], a
    inc hl
    ld a, h
    ld [$df04], a
    ld a, l
    ld [$df05], a
    pop hl
    inc hl
    ret
    ld hl, $dc0e
    ld [hl], $00
    ld hl, $dc0f
    ld [hl], $00
    pop af
    pop hl
    inc hl
    ret
    assert @ == $6679

section " Bank31_StreamRecordWalkerB_6679", romx[$6679], bank[$31]
Bank31_AppendFallbackCodeAndConsumeOneByte::
Bank31_StreamRecordWalkerB_6679::
    push hl
    xor a
    ld b, a
    ld a, [hl]
    ld c, a
    ld a, $0a
    push af
    ld a, [$df04]
    ld h, a
    ld a, [$df05]
    ld l, a
    ld de, $dc0e
    call $29ca
    jr z, $669f
    pop af
    ld [hl], a
    inc hl
    ld a, h
    ld [$df04], a
    ld a, l
    ld [$df05], a
    pop hl
    inc hl
    ret
    ld hl, $dc0e
    ld [hl], $00
    ld hl, $dc0f
    ld [hl], $00
    pop af
    pop hl
    inc hl
    ret
    assert @ == $66ad

section " Bank31_StreamRecordWalkerC_66AD", romx[$66ad], bank[$31]
Bank31_ConvertShiftJISTwoByteAndAppend::
Bank31_StreamRecordWalkerC_66AD::
    push hl
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a
    call $338b
    push af
    ld a, [$df04]
    ld h, a
    ld a, [$df05]
    ld l, a
    ld de, $dc0e
    call $29ca
    jr z, $66d5
    pop af
    ld [hl], a
    inc hl
    ld a, h
    ld [$df04], a
    ld a, l
    ld [$df05], a
    pop hl
    inc hl
    inc hl
    ret
    ld hl, $dc0e
    ld [hl], $00
    ld hl, $dc0f
    ld [hl], $00
    pop af
    pop hl
    inc hl
    inc hl
    ret
    assert @ == $66e4
