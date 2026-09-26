include "macros/macros.inc"

section "Bank31 Runtime 5675", romx[$5675], bank[$31]
Bank31_TestSevenASCIIZeroBytes::
    ld a, [hli]
    cp $30
    jr nz, $569a
    ld a, [hli]
    cp $30
    jr nz, $569a
    ld a, [hli]
    cp $30
    jr nz, $569a
    ld a, [hli]
    cp $30
    jr nz, $569a
    ld a, [hli]
    cp $30
    jr nz, $569a
    ld a, [hli]
    cp $30
    jr nz, $569a
    ld a, [hli]
    cp $30
    jr nz, $569a
    jr $569c
    xor a
    ret
    scf
    ret
Bank31_RuntimeSetup_569E::
    ld bc, $0104
    ld de, $120c
    farcall UIWindowStack_PushAndDrawAnimated
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0205
    ld de, $100a
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $56d7
    ld bc, $0205
    call $2b38
    ld bc, $070c
    farcall Gfx_DrawTwoChoiceHighlightFirst
    ld a, $ff
    ld [$deff], a
    ret
    assert @ == $56d7

section "Bank31 Runtime Message 56D7", romx[$56d7], bank[$31]
Bank31_RuntimeData_56D7::
    db $6a, $79, $cf, $ff, $f4, $eb, $2d, $c0, $7a, $01, $6d, $9b, $76, $e8, $b3, $dd
    db $db, $2d, $ec, $6b, $8a, $73, $62, $7f, $6d, $2e, $01, $01, $01, $83, $63, $62
    db $71, $9c, $e8, $b3, $dd, $db, $2d, $ec, $6c, $7f, $6d, $66, $3f, $00
    assert @ == $5705

section "Bank31 Runtime 5705", romx[$5705], bank[$31]
Bank31_RuntimeStatus_5705::
    ld a, [$def0]
    call $2f5f
    ld a, [$def1]
    call $2f5f
    call $3056
    call $04d2
    call $569e
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 0, a
    jr z, $572e
    ld a, $02
    call $3844
    ld a, [$deff]
    jr $5769
    bit 1, a
    jr z, $573b
    ld a, $0c
    call $3844
    ld a, $ff
    jr $5769
    bit 4, a
    jr z, $5752
    ld a, $01
    call $3844
    ld a, $ff
    ld [$deff], a
    ld bc, $070c
    farcall Gfx_DrawTwoChoiceHighlightFirst
    jr $5767
    bit 5, a
    jr z, $5767
    ld a, $01
    call $3844
    ld a, $01
    ld [$deff], a
    ld bc, $070c
    farcall Gfx_DrawTwoChoiceHighlightSecond
    jr $571a
    push af
    call $04d2
    farcall UIWindowStack_PopRestore
    ld a, [$def0]
    call $2f45
    ld a, [$def1]
    call $2f45
Bank31_RuntimeLookup_577D::
    pop af
    ret
    ld hl, $cbee
    farcall NetworkRuntime_4F0E
    jr nc, $57e0
    ld hl, $cbee
    farcall Bank31_TestSevenASCIIZeroBytes
    jr c, $57e0
    xor a
    push af
    farcall MapRuntime_LoadCurrentModeRecord
    ld a, $01
    ld hl, $ca1d
    call $3ac7
    jr z, $57d8
    pop af
    push af
    add a, a
    ld hl, $391c
    call $29bc
    ld a, [hli]
    ld a, a
    call $058d
    call $0593
    ld a, [hl]
    ld h, a
    ld l, $00
    ld bc, $001c
    add hl, bc
    ld d, h
    ld e, l
    ld hl, $cc14
    ld bc, $0004
    call $3b50
    call $059b
    farcall BANK_26, Bank26_Entry_5CCB
    ld de, $cc19
    ld hl, $cbee
    farcall BANK_0A, Bank0A_Entry_4A53
    jr nc, $57e2
    pop af
    inc a
    cp $0a
    jr z, $57e0
    jr $5792
    xor a
    ret
    pop af
    xor a
    scf
    ret
    assert @ == $57e6
