include "macros/macros.inc"

section "Bank31 Boot Save Validation Runtime", romx[$5453], bank[$31]
Bank31_BootSaveValidation::
    ld a, $0e
    call $058d
    call $0593
    call $542f
    ld c, a
    ld a, [$ba65]
    cp c
    jr z, $5468
    jr $546e
    ret
    call $059b
    scf
    ccf
    ret
    ld hl, $a138
    ld bc, $1900
    xor a
    call $3b79
    xor a
    ld [$ba38], a
    ld [$ba39], a
    call $059b
    farcall BANK_31, Bank31_Entry_71E4
    scf
    ret
    ld hl, $cb64
    ld bc, $0030
    xor a
    call $3b79
    ld a, $0e
    call $058d
    call $0593
    ld de, $d96a
    ld hl, $cb64
    ld bc, $001f
    call $3b50
    ld hl, $cab3
    ld de, $dc10
    farcall Text_ConvertGameCodeToShiftJISStream
    ld de, $dc10
    ld hl, $cb83
    ld bc, $0011
    call $3b50
    call $059b
    ret
    assert @ == $54c0

section "Bank31 Boot Save Validation Messages", romx[$54c0], bank[$31]
Bank31_BootSaveValidationMessages::
    db $91, $8d, $93, $62, $73, $62, $6c, $71, $ad, $63, $9b, $6d, $2e, $01, $bb, $2d
    db $ee, $bd, $60, $6b, $62, $66, $62, $6d, $89, $7f, $9b, $01, $6c, $86, $63, $9b
    db $67, $7f, $6e, $8d, $2e, $00, $91, $8d, $93, $62, $b3, $fb, $2d, $e5, $c8, $ff
    db $c4, $bb, $2d, $ee, $bd, $7a, $01, $73, $62, $6c, $6c, $73, $62, $7f, $6e, $8d
    db $2e, $00
    assert @ == $5502

section "Bank31 Save Prompt Runtime", romx[$5502], bank[$31]
Bank31_SavePromptState_5502::
    cp $01
    jr z, $550c
    cp $02
    jr z, $551d
    jr $552e
    ld a, $0e
    call $058d
    call $0593
    ld a, [$bb5c]
    cp $00
    jr z, $554a
    jr $5530
    ld a, $0e
    call $058d
    call $0593
    ld a, [$bb5c]
    cp $01
    jr z, $554a
    jr $553d
    xor a
    ret
    call $059b
    ld a, $03
    call $3844
    call $554f
    scf
    ret
    call $059b
    ld a, $03
    call $3844
    call $5572
    scf
    ret
    call $059b
    xor a
    ret
Bank31_SaveDataRuntime_554F::
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $020d
    ld de, $1003
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $020d
    ld hl, $54c0
    call $2b38
    ret
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $020d
    ld de, $1003
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $020d
    ld hl, $54e6
    call $2b38
    ret
    ld bc, $0104
    ld de, $120d
    farcall UIWindowStack_PushAndDraw
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0205
    ld de, $100b
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $55dd
    call $336e
    ld hl, $55eb
    call $336e
    ld hl, $55f5
    call $336e
    ld hl, $5605
    call $336e
    ld bc, $070c
    farcall Gfx_DrawTwoChoiceHighlightFirst
    ld a, $ff
    ld [$defe], a
    ret
    assert @ == $55dd

section "Bank31 Save Prompt Messages", romx[$55dd], bank[$31]
Bank31_SavePromptMessages::
    db $02, $05, $7a, $83, $7d, $6e, $ae, $6a, $62, $76, $76, $9d, $78, $00, $02, $06
    db $83, $64, $ad, $a9, $a6, $64, $87, $00, $02, $07, $7a, $83, $7d, $6e, $a9, $a6
    db $64, $6b, $6a, $6a, $a9, $9d, $78, $00, $06, $0a, $a7, $ac, $76, $62, $86, $78
    db $6a, $3f, $00
    assert @ == $5610

section "Bank31 Save Data Runtime", romx[$5610], bank[$31]
Bank31_SaveDataRuntime_5610::
    ld a, [$dee1]
    call $2f5f
    call $5595
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 0, a
    jr z, $562d
    ld a, $02
    call $3844
    ld a, [$defe]
    jr $5668
    bit 1, a
    jr z, $563a
    ld a, $0c
    call $3844
    ld a, $ff
    jr $5668
    bit 4, a
    jr z, $5651
    ld a, $01
    call $3844
    ld a, $ff
    ld [$defe], a
    ld bc, $070c
    farcall Gfx_DrawTwoChoiceHighlightFirst
    jr $5666
    bit 5, a
    jr z, $5666
    ld a, $01
    call $3844
    ld a, $01
    ld [$defe], a
    ld bc, $070c
    farcall Gfx_DrawTwoChoiceHighlightSecond
    jr $5619
    push af
    farcall UIWindowStack_PopRestore
    ld a, [$dee1]
    call $2f45
    pop af
    ret
    assert @ == $5675
