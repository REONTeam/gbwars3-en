include "macros/macros.inc"

; early Bank $19 Network/Mobile runtime continuation.
; This owns the previously overlaid bytes from $4195 up to (but not including)
; the next independently farcalled entry at $4A2A. Internal labels are limited
; to direct CALL/JP destinations observed in Bank $19; names remain neutral until
; later caller/UI evidence proves stronger user-facing contracts.

section "Bank19 Network Runtime 4195", romx[$4195], bank[$19]
NetworkRuntime_4195::
    ld a, [$dee3]
    cp $01
    jp z, $4424
    cp $02
    jp z, $443b
    cp $03
    jp z, $4485
    cp $04
    jp z, $44a6
    cp $1b
    jp z, $425b
    cp $1c
    jp z, $426d
    cp $00
    jp z, $42a1
    cp $1f
    jp z, $4377
    cp $20
    jp z, $43a2
    cp $1d
    jp z, $43cd
    cp $1e
    jp z, $43e3
    cp $21
    jp z, $4216
    cp $22
    jp z, $422c
    cp $05
    jp z, $44d3
    cp $06
    jp z, $44e7
    cp $07
    jp z, $450f
    cp $08
    jp z, $4517
    cp $2b
    jr z, $41f5
    cp $2c
    jr z, $4200
    ld a, $2b
    ld [$dee3], a
    farcall BANK_0A, Bank0A_Entry_4081
    jr c, $4212
    farcall BANK_0A, Bank0A_Entry_40AD
    jp c, $4540
    or a
    jr nz, $420c
    jr $4212
    ld a, $2c
    ld [$dee3], a
    ret
    jp $455c
    ret
    farcall Bank31_SetPairedStateFlag
    ld a, [$def4]
    farcall Bank31_RuntimeModeDispatcher_586E
    farcall BANK_27, Bank27_Entry_69B6
    ld de, $2af8
    farcall BANK_0A, Bank0A_Entry_40B0
    farcall BANK_0A, Bank0A_Entry_40BD
    jp c, $423e
    or a
    jr nz, $4238
    jr $4249
    ld a, $22
    ld [$dee3], a
    ret
    farcall Bank31_RuntimeOptionalAction_5A2E
    farcall Bank31_RuntimeMappedAction_5A36
    jp $4540
    ld a, [$cad9]
    cp $01
    jp z, $41f5
    farcall Bank31_ClearPairedStateFlag
    ld a, $05
    ld [$dee3], a
    ret
    farcall Bank31_SetPairedStateFlag
    farcall BANK_27, Bank27_Entry_69B6
    ld de, $2af8
    ld a, [$def5]
    farcall BANK_0A, Bank0A_Entry_4466
    farcall BANK_0A, Bank0A_Entry_44D0
    call $456a
    jp c, $427c
    or a
    jr nz, $4283
    jr $4289
    farcall Bank31_RuntimeOptionalAction_5A2E
    jp $4540
    ld a, $1c
    ld [$dee3], a
    ret
    ld a, [$cad9]
    cp $01
    jp z, $41f5
    farcall Bank31_ClearPairedStateFlag
    ld a, $00
    ld [$dee3], a
    ret
    ld a, $07
    ld [$dee3], a
    ret
    ld a, $01
    farcall BANK_32, Bank32_Entry_43B8
    ld a, [$def4]
    cp $80
    jr z, $42b4
    cp $05
    jr z, $42de
    jr $4315
    ld hl, $cbee
    farcall NetworkText_SkipLeadingASCIIZeroes
    farcall BANK_0A, Bank0A_Entry_4671
    jp c, $435c
    ld [$defc], a
    xor a
    ld [$cbf8], a
    xor a
    farcall BANK_26, Bank26_Entry_5882
    cp $ff
    jr z, $434d
    ld a, [$caca]
    cp $01
    jp z, $4371
    jp $4377
    ret
    farcall Bank31_GetMercenaryUnitClassIndex
    ld [$defc], a
    farcall BANK_0A, Bank0A_Entry_46C5
    ld a, $01
    farcall BANK_26, Bank26_Entry_5882
    cp $ff
    jr nz, $42fd
    ld a, $01
    ld [$cbde], a
    ld [$cbdd], a
    jr z, $434d
    ld a, [$caca]
    cp $01
    jr z, $430e
    xor a
    ld [$cbde], a
    ld a, $1d
    ld [$dee3], a
    ret
    ld a, $01
    ld [$cbde], a
    jr $4371
    ld a, [$def4]
    farcall BANK_0A, Bank0A_Entry_46FE
    jr c, $4334
    ld [$defc], a
    ld a, $02
    farcall BANK_26, Bank26_Entry_5882
    cp $ff
    jr z, $434d
    ld a, [$caca]
    cp $01
    jr z, $4371
    jr $4343
    ld hl, $def7
    ld bc, $0004
    ld a, $30
    call $3b79
    xor a
    ld [$defb], a
    farcall BANK_27, Bank27_Entry_6A1C
    ld a, $21
    ld [$dee3], a
    ret
NetworkRuntime_434D:
    farcall Bank31_RuntimeMappedAction_5A36
    ld a, $01
    ld [$cace], a
    ld a, $05
    ld [$dee3], a
    ret
    ld a, $01
    ld [$cbf8], a
    ld a, $00
    farcall BANK_26, Bank26_Entry_5E54
    farcall Bank31_RuntimeMappedAction_5A36
    ld a, $05
    ld [$dee3], a
    ret
    ld a, $05
    ld [$dee3], a
    ret
NetworkRuntime_4377:
    farcall Bank31_SetPairedStateFlag
    ld a, $02
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $00
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0607
    farcall Bank31_RuntimeBufferClear_5983
    ld hl, $cbee
    farcall NetworkText_SkipLeadingASCIIZeroes
    push hl
    farcall BANK_27, Bank27_Entry_69B6
    ld de, $2af8
    pop hl
    farcall BANK_0A, Bank0A_Entry_4701
    farcall BANK_0A, Bank0A_Entry_4776
    jp c, $43ae
    or a
    jr nz, $43b5
    jr $43bb
    farcall Bank31_RuntimeOptionalAction_5A2E
    jp $4540
    ld a, $20
    ld [$dee3], a
    ret
    ld a, [$cad9]
    cp $01
    jp z, $41f5
    farcall Bank31_ClearPairedStateFlag
    ld a, $1d
    ld [$dee3], a
    ret
    farcall Bank31_SetPairedStateFlag
    farcall BANK_27, Bank27_Entry_69B6
    ld hl, $2af8
    ld a, [$defc]
    ld e, a
    ld a, [$def5]
    farcall BANK_0A, Bank0A_Entry_47C2
    farcall BANK_0A, Bank0A_Entry_4829
    jr c, $43ee
    or a
    jr nz, $43f5
    jr $43fb
    farcall Bank31_RuntimeOptionalAction_5A2E
    jp $4540
    ld a, $1e
    ld [$dee3], a
    ret
    ld a, [$cad9]
    cp $01
    jp z, $41f5
    farcall Bank31_ClearPairedStateFlag
    ld a, [$def4]
    cp $80
    jr z, $4412
    cp $05
    jr z, $441e
    ld a, $00
    farcall BANK_26, Bank26_Entry_5E54
    ld a, $05
    ld [$dee3], a
    ret
    ld a, $05
    ld [$dee3], a
    ret
    call $2a83
    ld a, $00
    farcall BANK_32, Bank32_Entry_43B8
    farcall Bank31_SetPairedStateFlag
    ld a, $03
    farcall BANK_31, Bank31_Entry_5A73
    farcall BANK_0A, Bank0A_Entry_4039
    ld a, [$cad9]
    cp $01
    jp nz, $4450
    ld a, $01
    ld [$cace], a
    ld a, $01
    ld [$cbde], a
    jp $452b
    farcall BANK_0A, Bank0A_Entry_4012
    call $456a
    jp c, $4540
    or a
    jr nz, $445f
    jr $4465
    ld a, $02
    ld [$dee3], a
    ret
    ld a, [$cad9]
    cp $01
    jp nz, $4475
    ld a, $01
    ld [$cace], a
    jp $452b
    ld a, $00
    farcall BANK_32, Bank32_Entry_4D2C
    farcall Bank31_ClearPairedStateFlag
    ld a, $03
    ld [$dee3], a
    ret
    farcall Bank31_SetPairedStateFlag
    ld a, $02
    farcall BANK_31, Bank31_Entry_5A73
    ld a, $00
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $07
    farcall BANK_32, Bank32_Entry_4659
    farcall BANK_27, Bank27_Entry_695E
    ld hl, $cade
    farcall BANK_0A, Bank0A_Entry_4073
    farcall BANK_0A, Bank0A_Entry_407E
    call $456a
    jp c, $4540
    or a
    jr nz, $44b5
    jr $44bb
    ld a, $04
    ld [$dee3], a
    ret
    ld a, [$cad9]
    cp $01
    jp z, $41f5
    farcall Bank31_ClearPairedStateFlag
    ld a, $1b
    ld [$dee3], a
    ld a, $01
    farcall BANK_32, Bank32_Entry_43B8
    ret
    ld a, $17
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $15
    farcall BANK_32, Bank32_Entry_4659
    farcall Bank31_SetPairedStateFlag
    farcall BANK_0A, Bank0A_Entry_43D4
    farcall BANK_0A, Bank0A_Entry_43EB
    call $456a
    jr c, $4540
    or a
    jr nz, $44f5
    jr $44fb
    ld a, $06
    ld [$dee3], a
    ret
    xor a
    ld [$cad9], a
    farcall Bank31_ClearPairedStateFlag
    ld a, $01
    farcall BANK_32, Bank32_Entry_4D2C
    ld a, $07
    ld [$dee3], a
    ret
    farcall Bank31_SetPairedStateFlag
    farcall BANK_0A, Bank0A_Entry_406B
    farcall BANK_0A, Bank0A_Entry_4070
    call $456a
    jr c, $4540
    or a
    jr nz, $4525
    jr $452b
    ld a, $08
    ld [$dee3], a
    ret
NetworkRuntime_452B:
    xor a
    ld [$cad9], a
    farcall BANK_26, Bank26_Entry_54EE
    farcall Bank31_ClearPairedStateFlag
    ld a, $fe
    ld [$dee3], a
    call $413a
    ret
NetworkRuntime_4540:
    ld a, $0f
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $02
    farcall BANK_32, Bank32_Entry_4D2C
    farcall BANK_31, Bank31_Entry_71B8
    ld a, [$dee3]
    ld [$cbf9], a
    ld a, $ff
    ld [$dee3], a
    ret
NetworkRuntime_455C:
    ld a, $01
    ld [$cbde], a
    jp $434d
    ld a, $fd
    ld [$dee3], a
    ret
NetworkRuntime_456A:
    push af
    ld a, [$c8bb]
    cp $33
    jr nz, $4580
    ld a, [$c8bc]
    cp $01
    jr nz, $4580
    ld a, [$c8bd]
    cp $01
    jr z, $4586
    xor a
    ld [$cac4], a
    pop af
    ret
    ld a, $01
    ld [$cac4], a
    pop af
    scf
    ccf
    ret
NetworkRuntime_458F:
    ld a, [$dee3]
    cp $01
    jp z, $45fe
    cp $02
    jp z, $461e
    cp $03
    jp z, $4671
    cp $04
    jp z, $4692
    cp $2d
    jp z, $46bc
    cp $2e
    jp z, $46cf
    cp $2f
    jp z, $46ef
    cp $31
    jp z, $472c
    cp $32
    jp z, $473a
    cp $05
    jp z, $4770
    cp $06
    jp z, $4784
    cp $07
    jp z, $47a5
    cp $08
    jp z, $47ad
    cp $2b
    jp z, $45dd
    cp $2b
    jp z, $45e8
    ld a, $2b
    ld [$dee3], a
    farcall BANK_0A, Bank0A_Entry_4081
    jr c, $45fa
    farcall BANK_0A, Bank0A_Entry_40AD
    jp c, $47d8
    or a
    jr nz, $45f4
    jr $45fa
    ld a, $2c
    ld [$dee3], a
    ret
    jp $47f4
    ret
    call $2a83
    ld a, $00
    farcall BANK_32, Bank32_Entry_43B8
    farcall Bank31_SetPairedStateFlag
    ld a, $03
    farcall BANK_31, Bank31_Entry_5A73
    xor a
    ld [$dee6], a
    ld a, $01
    ld [$dee7], a
    farcall BANK_0A, Bank0A_Entry_4039
    ld a, [$cad9]
    cp $01
    jp nz, $463f
    ld a, $01
    ld [$cace], a
    ld a, $01
    ld [$cbde], a
    ld a, $17
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $15
    farcall BANK_32, Bank32_Entry_4659
    jp $47be
    farcall BANK_0A, Bank0A_Entry_4012
    jp c, $47d8
    or a
    jr nz, $464b
    jr $4651
    ld a, $02
    ld [$dee3], a
    ret
    ld a, [$cad9]
    cp $01
    jp nz, $4661
    ld a, $01
    ld [$cace], a
    jp $47be
    ld a, $00
    farcall BANK_32, Bank32_Entry_4D2C
    farcall Bank31_ClearPairedStateFlag
    ld a, $03
    ld [$dee3], a
    ret
    farcall Bank31_SetPairedStateFlag
    ld a, $02
    farcall BANK_31, Bank31_Entry_5A73
    ld a, $00
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $07
    farcall BANK_32, Bank32_Entry_4659
    farcall BANK_27, Bank27_Entry_695E
    ld hl, $cade
    farcall BANK_0A, Bank0A_Entry_4073
    farcall BANK_0A, Bank0A_Entry_407E
    jp c, $47d8
    or a
    jr nz, $469e
    jr $46a4
    ld a, $04
    ld [$dee3], a
    ret
    ld a, [$cad9]
    cp $01
    jp z, $45dd
    farcall Bank31_ClearPairedStateFlag
    ld a, $2d
    ld [$dee3], a
    ld a, $01
    farcall BANK_32, Bank32_Entry_43B8
    ret
    ld a, [$cad9]
    cp $01
    jp z, $45dd
    farcall BANK_27, Bank27_Entry_69B6
    ld de, $2af8
    farcall BANK_0A, Bank0A_Entry_48AE
    farcall BANK_0A, Bank0A_Entry_48E9
    jp c, $47d8
    or a
    jr nz, $46db
    jr $46e1
    ld a, $2e
    ld [$dee3], a
    ret
    ld a, [$cad9]
    cp $01
    jp z, $45dd
    ld a, $2f
    ld [$dee3], a
    ret
    ld a, [$cad9]
    cp $01
    jp z, $45dd
    ld a, [$cbfa]
    farcall BANK_0A, Bank0A_Entry_4958
    ld a, [$cbfa]
    farcall Bank31_ValidateIndexedPersistentWordSelection_655D
    jr c, $4709
    jr $471a
    ld a, [$cbfa]
    inc a
    ld [$cbfa], a
    cp $10
    jr z, $4726
    ld a, $2f
    ld [$dee3], a
    ret
    farcall Bank31_TestStagedIndexAgainstLimit_65AD
    jr c, $4726
    ld a, $31
    ld [$dee3], a
    ret
    ld a, $05
    ld [$dee3], a
    ret
    farcall BANK_27, Bank27_Entry_69B6
    ld de, $2af8
    ld a, [$cbfa]
    farcall BANK_0A, Bank0A_Entry_4965
    farcall BANK_0A, Bank0A_Entry_49B7
    jp c, $47d8
    or a
    jr nz, $4746
    jr $474c
    ld a, $32
    ld [$dee3], a
    ret
    ld a, [$cad9]
    cp $01
    jp z, $45dd
    farcall Bank31_PersistentSelectionAction_65BC
    ld a, [$cbfa]
    inc a
    ld [$cbfa], a
    cp $10
    jr z, $4726
    ld a, $2f
    ld [$dee3], a
    ld a, [$cacc]
    inc a
    ld [$cacc], a
    ret
    ld a, $17
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $15
    farcall BANK_32, Bank32_Entry_4659
    farcall Bank31_SetPairedStateFlag
    farcall BANK_0A, Bank0A_Entry_43D4
    farcall BANK_0A, Bank0A_Entry_43EB
    jr c, $47d8
    or a
    jr nz, $478f
    jr $4795
    ld a, $06
    ld [$dee3], a
    ret
    farcall Bank31_ClearPairedStateFlag
    ld a, $01
    farcall BANK_32, Bank32_Entry_4D2C
    ld a, $07
    ld [$dee3], a
    ret
    farcall Bank31_SetPairedStateFlag
    farcall BANK_0A, Bank0A_Entry_406B
    farcall BANK_0A, Bank0A_Entry_4070
    jr c, $47d8
    or a
    jr nz, $47b8
    jr $47be
    ld a, $08
    ld [$dee3], a
    ret
NetworkRuntime_47BE:
    ld a, [$cad9]
    cp $01
    jr nz, $47ce
    ld a, $82
    ld [$def4], a
    farcall BANK_26, Bank26_Entry_54EE
    farcall Bank31_ClearPairedStateFlag
    ld a, $fe
    ld [$dee3], a
    ret
    ld a, $0f
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $02
    farcall BANK_32, Bank32_Entry_4D2C
    farcall BANK_31, Bank31_Entry_71B8
    ld a, [$dee3]
    ld [$cbf9], a
    ld a, $ff
    ld [$dee3], a
    ret
NetworkRuntime_47F4:
    ld a, $fd
    ld [$dee3], a
    ret
NetworkRuntime_47FA:
    ld a, [$cbe6]
    cp $00
    jr z, $480d
    cp $01
    jr z, $4817
    cp $02
    jr z, $4817
    cp $03
    jr z, $4827
    farcall BANK_26, Bank26_Entry_5C01
    jr c, $4815
    xor a
    ret
    scf
    ret
    farcall BANK_26, Bank26_Entry_5BE8
    jr c, $4825
    farcall BANK_26, Bank26_Entry_5C1A
    jr c, $4825
    xor a
    ret
    scf
    ret
    farcall BANK_26, Bank26_Entry_5C33
    jr c, $482f
    xor a
    ret
    scf
    ret
NetworkRuntime_4831:
    farcall Bank31_RuntimeSetup_5B73
    ld a, $02
    call $3816
    call $081d
NetworkRuntime_483D:
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 6, a
    jr z, $4863
    ld a, $01
    call $3844
    ld a, [$cbe6]
    dec a
    cp $ff
    jr nz, $4856
    ld a, $03
    ld [$cbe6], a
    farcall Bank31_RuntimeDrawValue_5A19
    farcall BANK_26, Bank26_Entry_54C8
    jr $48c0
    bit 7, a
    jr z, $4882
    ld a, $01
    call $3844
    ld a, [$cbe6]
    inc a
    cp $04
    jr nz, $4875
    xor a
    ld [$cbe6], a
    farcall Bank31_RuntimeDrawValue_5A19
    farcall BANK_26, Bank26_Entry_54C8
    jr $48c0
    bit 0, a
    jr z, $48b3
    ld a, [$cbe6]
    call $47fa
    jr c, $489a
    ld a, [$deee]
    farcall SpriteTransition_SlideRightOffscreen
    ld a, [$cbe6]
    jr $48c3
    ld a, [$cbe6]
    farcall BANK_26, Bank26_Entry_5B35
    cp $ff
    jr nz, $48a7
    jr $48ac
    ld a, [$cbe6]
    jr $48c3
    ld a, $03
    call $3844
    jr $48c0
    bit 1, a
    jr z, $48c0
    ld a, $0c
    call $3844
    ld a, $ff
    jr $48c3
    jp $483d
    push af
    call $07b4
    call $2e67
    pop af
    ret
NetworkRuntime_48CC:
    farcall Bank31_RuntimeSetup_5C29
    call $081d
NetworkRuntime_48D3:
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 0, a
    jr z, $48e5
    ld a, $02
    call $3844
    xor a
    jr $495c
    bit 1, a
    jr z, $48f2
    ld a, $0c
    call $3844
    ld a, $ff
    jr $495c
    bit 6, a
    jr z, $4908
    ld a, $01
    call $3844
    farcall Bank31_IncrementASCIIDecimalDigit
    ld bc, $0806
    farcall Bank31_RuntimeBufferClear_5983
    jr $4959
    bit 7, a
    jr z, $4922
    ld a, $01
    call $3844
    farcall Bank31_RuntimeDrawDecimalFields_59E0
    farcall Bank31_DecrementASCIIDecimalDigit
    ld bc, $0806
    farcall Bank31_RuntimeBufferClear_5983
    jr $4959
    bit 5, a
    jr z, $493e
    ld a, $01
    call $3844
    ld a, [$deef]
    dec a
    cp $ff
    jr nz, $4935
    ld a, $03
    ld [$deef], a
    farcall Bank31_RuntimeDrawDecimalFields_59E0
    jr $4959
    bit 4, a
    jr z, $4959
    ld a, $01
    call $3844
    ld a, [$deef]
    inc a
    cp $04
    jr nz, $4950
    xor a
    ld [$deef], a
    farcall Bank31_RuntimeDrawDecimalFields_59E0
    jr $4959
    jp $48d3
    push af
    call $07b4
    call $2e67
    pop af
    ret
    ld a, [$dee6]
    ld h, a
    ld a, [$dee7]
    ld l, a
    inc hl
    ld a, h
    ld [$dee6], a
    ld a, l
    ld [$dee7], a
    ld a, [$dee4]
    ld e, a
    ld a, [$dee5]
    ld d, a
    inc de
    call $29ca
    ret
NetworkRuntime_4983:
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    farcall BANK_31, Bank31_Entry_704C
    ld a, $0b
    ld b, $03
    ld c, $22
    ld hl, $6134
    call $06d9
    call $06f2
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $5f4c
    ld hl, $8000
    ld bc, $01d0
    farcall BANK_22, Bank22_Entry_3B50
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $80
    ld b, $22
    ld de, $5f33
    call $2de8
    ld [$def2], a
    ld bc, $8c2c
    call $2eae
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
NetworkRuntime_49DD:
    ld a, [$cbf8]
    cp $00
    jr z, $4a0a
    ld a, $0f
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $16
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0607
    farcall Bank31_RuntimeBufferClear_5983
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff91]
    bit 0, a
    jr z, $4a08
    ld a, $02
    call $3844
    jr $4a0a
    jr $49f7
    ret
NetworkRuntime_4A0B:
    ld a, [$cac4]
    cp $01
    jr nz, $4a29
    farcall BANK_31, Bank31_Entry_71B8
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff91]
    bit 0, a
    jr z, $4a27
    ld a, $02
    call $3844
    jr $4a29
    jr $4a16
    ret
    assert @ == $4a2a
