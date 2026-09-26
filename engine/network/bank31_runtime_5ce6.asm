include "macros/macros.inc"

; Bank $31 continuation from the externally reached $5CE6 entry.
; $5CE6 selects one of twelve local encoded messages and prints it through TextPrint.
; $5EA0 is a separate persistent/setup path. $5F06 computes a 34-byte record address
; in the $D9CB workspace. $5F27 is the next independently farcalled boundary.

section "Bank31 Indexed Message Selector", romx[$5ce6], bank[$31]
Bank31_PrintIndexedMessage_5CE6::
    push bc
    add a, a
    ld hl, $5cf9
    call $29bc
    ld a, [hli]
    ld d, a
    ld a, [hl]
    ld e, a
    ld l, d
    ld h, e
    pop bc
    call $2b38
    ret
Bank31_MessagePointerTable_5CF9::
    db $35, $5d, $50, $5d, $11, $5d, $63, $5d, $84, $5d, $b0, $5d, $d2, $5d, $fa, $5d
    db $1e, $5e, $42, $5e, $67, $5e, $82, $5e
Bank31_Message_5D11::
    db $b3, $fb, $2d, $e5, $c8, $ff, $c4, $be, $dd, $c0, $2d, $76, $01, $b1, $b8, $be
    db $bd, $6c, $73, $01, $d2, $ff, $be, $2d, $e4, $75, $9c, $60, $63, $69, $74, $88
    db $7f, $6d, $2e, $00
Bank31_Message_5D35::
    db $b3, $fb, $2d, $e5, $c8, $ff, $c4, $be, $dd, $c0, $2d, $66, $87, $79, $01, $d2
    db $ff, $be, $2d, $e4, $60, $86, $80, $7f, $6d, $2e, $00
Bank31_Message_5D50::
    db $cf, $ff, $f4, $eb, $2d, $c0, $60, $01, $e8, $b3, $dd, $db, $2d, $ec, $6c, $7f
    db $6d, $2e, $00
Bank31_Message_5D63::
    db $b3, $fb, $2d, $e5, $c8, $ff, $c4, $bb, $2d, $ee, $bd, $79, $01, $d5, $2d, $e3
    db $2d, $74, $63, $8b, $68, $10, $7d, $8d, $6a, $63, $60, $01, $6c, $7f, $6d, $2e
    db $00
Bank31_Message_5D84::
    db $6e, $72, $97, $68, $6e, $af, $73, $62, $79, $7d, $8d, $6a, $63, $74, $01, $b3
    db $fb, $2d, $e5, $c8, $ff, $c4, $bb, $2d, $ee, $bd, $79, $01, $71, $ad, $63, $98
    db $8d, $10, $6b, $62, $66, $62, $60, $6c, $7f, $6d, $2e, $00
Bank31_Message_5DB0::
    db $b3, $fb, $2d, $e5, $c8, $ff, $c4, $be, $dd, $c0, $2d, $76, $61, $89, $01, $cf
    db $ff, $f4, $eb, $2d, $c0, $60, $01, $e8, $b3, $dd, $db, $2d, $ec, $6c, $7f, $6d
    db $2e, $00
Bank31_Message_5DD2::
    db $94, $9f, $8d, $8e, $72, $68, $af, $70, $cf, $ff, $f4, $eb, $2d, $c0, $60, $01
    db $b3, $fb, $2d, $e5, $c8, $ff, $c4, $be, $dd, $c0, $2d, $76, $01, $b1, $ff, $f4
    db $db, $2d, $ec, $6c, $7f, $6d, $2e, $00
Bank31_Message_5DFA::
    db $b3, $fb, $2d, $e5, $c8, $ff, $c4, $be, $dd, $c0, $2d, $76, $61, $89, $01, $94
    db $9f, $8d, $79, $cf, $ff, $f4, $eb, $2d, $c0, $60, $01, $6b, $68, $94, $ae, $6c
    db $7f, $6d, $2e, $00
Bank31_Message_5E1E::
    db $b3, $fb, $2d, $e5, $c8, $ff, $c4, $be, $dd, $c0, $2d, $76, $61, $89, $01, $94
    db $9f, $8d, $79, $cf, $ff, $f4, $eb, $2d, $c0, $60, $01, $74, $63, $6a, $63, $6c
    db $7f, $6d, $2e, $00
Bank31_Message_5E42::
    db $b3, $fb, $2d, $e5, $c8, $ff, $c4, $bb, $2d, $ee, $bd, $76, $01, $6e, $72, $97
    db $68, $6d, $89, $70, $82, $79, $6e, $af, $73, $62, $60, $01, $7d, $8d, $6a, $63
    db $6c, $7f, $6d, $2e, $00
Bank31_Message_5E67::
    db $6d, $a0, $73, $79, $b3, $fb, $2d, $e5, $c8, $ff, $c4, $bb, $2d, $ee, $bd, $60
    db $01, $71, $ad, $63, $98, $8d, $6c, $7f, $6d, $2e, $00
Bank31_Message_5E82::
    db $71, $ad, $63, $98, $8d, $6c, $70, $01, $b3, $fb, $2d, $e5, $c8, $ff, $c4, $bb
    db $2d, $ee, $bd, $60, $01, $6b, $62, $66, $62, $6c, $7f, $6d, $2e, $00
    assert @ == $5ea0

section "Bank31 Persistent Setup 5EA0", romx[$5ea0], bank[$31]
Bank31_PersistentSetup_5EA0::
    ld a, $0f
    call $058d
    call $0593
    ld de, $a0cc
    xor a
    call $5f06
    ld a, $00
    call $29bc
    farcall BANK_0A, Bank0A_Entry_4A6D
    inc de
    xor a
    call $5f06
    ld a, $11
    call $29bc
    farcall BANK_0A, Bank0A_Entry_4A6D
    inc de
    ld a, $01
    call $5f06
    ld a, $00
    call $29bc
    farcall BANK_0A, Bank0A_Entry_4A6D
    inc de
    ld a, $01
    call $5f06
    ld a, $11
    call $29bc
    farcall BANK_0A, Bank0A_Entry_4A6D
    inc de
    ld a, $02
    call $5f06
    ld a, $00
    call $29bc
    farcall BANK_0A, Bank0A_Entry_4A6D
    inc de
    ld a, $02
    call $5f06
    ld a, $11
    call $29bc
    farcall BANK_0A, Bank0A_Entry_4A6D
    call $059b
    ret
    assert @ == $5f06

section "Bank31 Indexed 34-Byte Record Address", romx[$5f06], bank[$31]
Bank31_GetIndexed34ByteRecordAddress::
    push de
    ld b, $22
    call $2995
    ld bc, $d9cb
    add hl, bc
    pop de
    ret
    assert @ == $5f12

section "Bank31 BC Nonzero Carry Test", romx[$5f12], bank[$31]
Bank31_TestBCNonzeroCarry::
    push de
    ld d, b
    ld e, c
    ld hl, $0000
    call $29ca
    jr z, $5f20
    jr $5f23
    ret
    xor a
    pop de
    ret
    xor a
    scf
    pop de
    ret
    assert @ == $5f27
