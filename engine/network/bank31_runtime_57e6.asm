include "macros/macros.inc"

; Bank $31 continuation selected from Bank $19:$62AB.
; This tranche is source-owned through the next independently farcalled entry at $5AC0.
; Several helpers are behavior-backed (mercenary type classification, ASCII decimal editing,
; and the paired-state bitfield helpers); the broader UI/status callers remain conservative.

section "Bank31 Runtime 57E6", romx[$57e6], bank[$31]
Bank31_RuntimeValidateList_57E6::
    ld a, [$da96]
    cp $00
    jr z, $580a
    ld hl, $da50
    ld d, $00
    ld a, [hli]
    cp $00
    jr z, $57fa
    inc d
    jr $57f2
    ld a, d
    cp $00
    jr z, $580a
    ld b, $00
    ld c, d
    ld hl, $da61
    ld a, $0a
    call $3b79
    ld hl, $da61
    farcall NetworkText_GetZeroTerminatedLength
    cp $00
    jr z, $581e
    ld hl, $da61
    ld bc, $0206
    call $3353
    ret
    assert @ == $581f

section "Bank31 Runtime 581F", romx[$581f], bank[$31]
Bank31_RuntimeSetup_581F::
    ld a, $16
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $14
    farcall BANK_32, Bank32_Entry_4659
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0804
    ld de, $0501
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$cad4]
    ld bc, $020c
    ld d, $02
    call $3237
    ld a, [$cad3]
    ld bc, $060c
    ld d, $02
    call $3237
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff91]
    bit 0, a
    jr z, $586b
    ld a, $02
    call $3844
    jr $586d
    jr $585a
    ret
    assert @ == $586e

section "Bank31 Runtime 586E", romx[$586e], bank[$31]
Bank31_RuntimeModeDispatcher_586E::
    cp $0b
    jr z, $5892
    cp $0c
    jr z, $5899
    cp $00
    jr z, $5899
    cp $01
    jr z, $589f
    cp $0a
    jr z, $58b1
    cp $02
    jr z, $58c3
    cp $03
    jr z, $58d5
    cp $05
    jr z, $58e7
    cp $07
    jr z, $58ec
    ld a, $01
    farcall BANK_26, Bank26_Entry_56C4
    ret
    xor a
    farcall BANK_26, Bank26_Entry_56C4
    ret
    ld a, $04
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0307
    farcall Bank31_RuntimeWRAM4BufferClear_599F
    farcall BANK_26, Bank26_Entry_57A6
    ret
    ld a, $05
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0607
    farcall Bank31_RuntimeWRAM4BufferClear_598A
    farcall BANK_26, Bank26_Entry_57C0
    ret
    ld a, $06
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0607
    farcall Bank31_RuntimeWRAM4BufferClear_598A
    farcall BANK_26, Bank26_Entry_57E2
    ret
    ld a, $00
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0607
    farcall Bank31_RuntimeBufferClear_5983
    farcall BANK_26, Bank26_Entry_57F5
    ret
    farcall BANK_26, Bank26_Entry_5814
    ret
    farcall BANK_26, Bank26_Entry_5820
    ret
    assert @ == $58f1

section "Bank31 Runtime 58F1", romx[$58f1], bank[$31]
Bank31_RuntimePositionHelper_58F1::
    ld a, [$cbe8]
    ld b, $18
    call $2995
    ld a, l
    add a, $50
    ld c, a
    ld b, $18
    ld a, [$cbe7]
    call $2eae
    ret
    assert @ == $5906

section "Bank31 Runtime 5906", romx[$5906], bank[$31]
Bank31_RuntimePositionHelper_5906::
    ld a, [$cbe4]
    ld b, $08
    call $2995
    ld a, l
    add a, $34
    ld c, a
    ld b, $1c
    ld a, [$da31]
    call $2eae
    call $591e
    ret
Bank31_RuntimePositionSetup_591E::
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
    ld a, [$cbe4]
    add a, $09
    ld bc, $020d
    farcall Bank31_PrintIndexedMessage_5CE6
    ret
    assert @ == $5944

section "Bank31 Mercenary Unit Class Lookup", romx[$5944], bank[$31]
Bank31_GetMercenaryUnitClassIndex::
    ld a, [$c4a1]
    ld hl, $594f
    call $29bc
    ld a, [hl]
    ret
Bank31_MercenaryUnitClassByType::
    rst $38
    rst $38
    rst $38
    nop
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    ld bc, $ffff
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    ld [bc], a
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    inc bc
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    inc b
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    assert @ == $5983

section "Bank31 Runtime 5983", romx[$5983], bank[$31]
Bank31_RuntimeBufferClear_5983::
    ld hl, $cbf1
    call $3353
    ret
    assert @ == $598a

section "Bank31 Runtime 598A", romx[$598a], bank[$31]
Bank31_RuntimeWRAM4BufferClear_598A::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld hl, $dc44
    call $3353
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $599f

section "Bank31 Runtime 599F", romx[$599f], bank[$31]
Bank31_RuntimeWRAM4BufferClear_599F::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld hl, $dc3b
    call $3353
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $59b4

section "Bank31 ASCII Decimal Digit Editing", romx[$59b4], bank[$31]
Bank31_IncrementASCIIDecimalDigit::
    ld a, [$deef]
    add a, $03
    ld b, $00
    ld c, a
    ld hl, $cbee
    add hl, bc
    ld a, [hl]
    inc a
    cp $3a
    jr nz, $59c8
    ld a, $30
    ld [hl], a
    ret
Bank31_DecrementASCIIDecimalDigit::
    ld a, [$deef]
    add a, $03
    ld b, $00
    ld c, a
    ld hl, $cbee
    add hl, bc
    ld a, [hl]
    dec a
    cp $2f
    jr nz, $59de
    ld a, $39
    ld [hl], a
    ret
    assert @ == $59e0

section "Bank31 Runtime 59E0", romx[$59e0], bank[$31]
Bank31_RuntimeDrawDecimalFields_59E0::
    ld a, [$deef]
    cp $00
    jr z, $59f3
    cp $01
    jr z, $59f7
    cp $02
    jr z, $59fb
    cp $03
    jr z, $59ff
    ld a, $4c
    jr $5a03
    ld a, $54
    jr $5a03
    ld a, $5c
    jr $5a03
    ld a, $64
    jr $5a03
    ld b, a
    push bc
    ld a, $3c
    ld c, a
    ld a, [$def0]
    call $2eae
    pop bc
    ld a, $4c
    ld c, a
    ld a, [$def1]
    call $2eae
    ret
    assert @ == $5a19

section "Bank31 Runtime 5A19", romx[$5a19], bank[$31]
Bank31_RuntimeDrawValue_5A19::
    ld a, [$cbe6]
    ld b, $08
    call $2995
    ld a, l
    add a, $34
    ld c, a
    ld b, $1c
    ld a, [$deee]
    call $2eae
    ret
    assert @ == $5a2e

section "Bank31 Runtime 5A2E", romx[$5a2e], bank[$31]
Bank31_RuntimeOptionalAction_5A2E::
    cp $ff
    ret nz
    farcall BANK_0A, Bank0A_Entry_4081
    ret
    assert @ == $5a36

section "Bank31 Runtime 5A36", romx[$5a36], bank[$31]
Bank31_RuntimeMappedAction_5A36::
    ld a, [$def4]
    cp $00
    jr z, $5a55
    cp $01
    jr z, $5a59
    cp $0a
    jr z, $5a59
    cp $02
    jr z, $5a5d
    cp $03
    jr z, $5a61
    cp $05
    jr z, $5a65
    cp $07
    jr z, $5a69
    ld a, $00
    jr $5a6b
    ld a, $01
    jr $5a6b
    ld a, $02
    jr $5a6b
    ld a, $03
    jr $5a6b
    ld a, $05
    jr $5a6b
    ld a, $07
    farcall BANK_0A, Bank0A_Entry_49FD
    ret
    assert @ == $5a70

section "Bank31 Paired State Bitfield Helpers", romx[$5a70], bank[$31]
Bank31_SetPairedStateFlag::
    call $5a8e
    ld hl, $cada
    call $3ad1
    ret
Bank31_ClearPairedStateFlag::
    call $5a8e
    ld hl, $cada
    call $3adc
    ret
Bank31_TestPairedStateFlag::
    call $5a8e
    ld hl, $cada
    call $3ac7
    ret
Bank31_GetPairedStateFlagIndex::
    ld a, [$dee3]
    ld hl, $5a99
    call $29bc
    ld a, [hl]
    ret
Bank31_PairedStateFlagIndexTable::
    db $00, $00, $00, $01, $01, $02, $02, $03, $03, $04, $04, $05, $05, $06, $06, $07
    db $07, $08, $08, $09, $09, $0a, $0a, $0b, $0b, $0c, $0c, $0d, $0d, $0e, $0e, $0f
    db $0f, $10, $10, $11, $11, $12, $12
    assert @ == $5ac0
