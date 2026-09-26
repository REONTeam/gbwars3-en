include "macros/macros.inc"

; Campaign medal/statistics runtime in physical Bank $11.
; corrected the older DataCrystal block-number -> physical-bank mistake.
; closes the three intervening gaps along natural routine/data boundaries.
; Names remain conservative where exact gameplay presentation semantics are not yet proven.

section "Campaign Master/Super Medal Check", romx[$4a12], bank[$11]
CampaignMedals_CheckMasterAndSuperPrize::
    push bc
    ld hl, $c68f
    ld b, $00
    ld a, b
    call $3ac7
    jr z, $4a42
    inc b
    ld a, b
    cp $2d
    jr nz, $4a18
    ld a, $01
    call $4bd3
    ld b, $00
    ld c, $00
    ld hl, $c784
    ld a, [hli]
    add a, b
    cp $37
    jr nc, $4a42
    ld b, a
    inc c
    ld a, c
    cp $2d
    jr nz, $4a30
    ld a, $03
    call $4bd3
    pop bc
    ret
    assert @ == $4a44

section "Campaign Mapped Award Check", romx[$4a44], bank[$11]
CampaignMedals_CheckMappedAward::
    push bc
    ld a, [$c6a4]
    ld c, a
    call $49db
    cp $80
    jr c, $4a57
    sub $80
    add a, $04
    call $4bd3
    pop bc
    ret
    assert @ == $4a59

section "Campaign Category Medal Checks", romx[$4a59], bank[$11]
CampaignMedals_CheckCategoryMedals::
    push de
    ld de, $c770
    ld hl, $01f4
    call $4ddf
    jr c, $4a6a
    ld a, $0a
    call $4bd3
    ld de, $c770
    ld hl, $00fa
    call $4ddf
    jr c, $4a7a
    ld a, $09
    call $4bd3
    ld de, $c772
    ld hl, $012c
    call $4ddf
    jr c, $4a8a
    ld a, $0c
    call $4bd3
    ld de, $c772
    ld hl, $0096
    call $4ddf
    jr c, $4a9a
    ld a, $0b
    call $4bd3
    ld de, $c774
    ld hl, $00c8
    call $4ddf
    jr c, $4aaa
    ld a, $0e
    call $4bd3
    ld de, $c774
    ld hl, $0064
    call $4ddf
    jr c, $4aba
    ld a, $0d
    call $4bd3
    ld de, $c776
    ld hl, $00c8
    call $4ddf
    jr c, $4aca
    ld a, $10
    call $4bd3
    ld de, $c776
    ld hl, $0064
    call $4ddf
    jr c, $4ada
    ld a, $0f
    call $4bd3
    ld de, $c778
    ld hl, $0190
    call $4ddf
    jr c, $4aea
    ld a, $12
    call $4bd3
    ld de, $c778
    ld hl, $00c8
    call $4ddf
    jr c, $4afa
    ld a, $11
    call $4bd3
    ld de, $c77a
    ld hl, $00c8
    call $4ddf
    jr c, $4b0a
    ld a, $14
    call $4bd3
    ld de, $c77a
    ld hl, $0064
    call $4ddf
    jr c, $4b1a
    ld a, $13
    call $4bd3
    ld a, [$c77c]
    cp $0a
    jr c, $4b26
    ld a, $16
    call $4bd3
    pop de
    ret
    assert @ == $4b28

section "Campaign All Unit Medal Check", romx[$4b28], bank[$11]
CampaignMedals_CheckAllUnitMedal::
    push bc
    ld b, $01
    ld a, b
    ld hl, $c77d
    call $3ac7
    jr z, $4b3f
    inc b
    ld a, b
    cp $34
    jr nz, $4b2b
    ld a, $15
    call $4bd3
    pop bc
    ret
    assert @ == $4b41

section "Campaign Result Award Dispatcher", romx[$4b41], bank[$11]
CampaignMedals_HandleResultAwards::
    ld a, [$c6a5]
    farcall MapRecord_SelectStandard
    ld a, $16
    call $3816
    farcall CampaignResult_ShowSummary
    call $4bc4
    cp $00
    jr z, $4b5d
    call $4c36
    jr $4bc3
    ld a, [$c6a5]
    ld hl, $c695
    call $3ad1
    ld a, [$c633]
    srl a
    inc a
    ld b, a
    ld a, [$c6a5]
    call $4ded
    ld a, [$c6a5]
    cp $0e
    jr z, $4b8b
    cp $1d
    jr z, $4b99
    cp $2c
    jr z, $4ba7
    cp $3b
    jr z, $4bb5
    call $4c36
    jr $4bc3
    farcall AttractText_ShowPlayNextArea15
    ld hl, $c6a7
    set 0, [hl]
    call $4c36
    jr $4bc3
    farcall BANK_1A, Bank1A_Entry_7816
    ld hl, $c6a7
    set 1, [hl]
    call $4c36
    jr $4bc3
    farcall AttractText_ShowPlayNextArea15
    ld hl, $c6a7
    set 2, [hl]
    call $4c36
    jr $4bc3
    farcall BANK_1A, Bank1A_Entry_7C32
    ld hl, $c6a7
    set 3, [hl]
    call $4c36
    jr $4bc3
    ret
    assert @ == $4bc4

section "Campaign Side State Selector", romx[$4bc4], bank[$11]
CampaignStats_GetCurrentSideState::
    ld a, [$ca94]
    cp $02
    jr z, $4bcf
    ld a, [$c631]
    ret
    ld a, [$c632]
    ret
    assert @ == $4bd3

section "Campaign Just Obtained Medal Flag", romx[$4bd3], bank[$11]
CampaignMedals_SetJustObtainedFlag::
    ld hl, $c62b
    call $3ad1
    ret
    assert @ == $4bda

section "Campaign Flag Synchronizer", romx[$4bda], bank[$11]
CampaignStats_SynchronizeFlags::
    ld de, $c687
    ld hl, $cc97
    ld bc, $0003
    call $3b50
    ld e, $00
    push de
    ld a, e
    ld hl, $c687
    call $3ac7
    jr nz, $4c15
    ld a, e
    ld hl, $c62b
    call $3ac7
    jr z, $4c15
    ld a, $29
    call $3816
    ld a, e
    push de
    farcall BANK_15, Bank15_Entry_6424
    pop de
    ld hl, $c687
    ld a, e
    call $3ad1
    ld hl, $cc97
    ld a, e
    call $3ad1
    pop de
    inc e
    ld a, e
    cp $18
    jr nz, $4be8
    ret
    assert @ == $4c1d

section "Campaign Award Helper", romx[$4c1d], bank[$11]
CampaignMedals_TryAwardMappedMedal::
    push bc
    ld c, a
    ld a, [$c68b]
    ld b, a
    ld a, c
    call $4c4d
    cp $ff
    jr z, $4c34
    ld a, $29
    call $3816
    farcall BANK_15, Bank15_Entry_6344
    pop bc
    ret
    assert @ == $4c36

section "Campaign Award Presentation", romx[$4c36], bank[$11]
CampaignMedals_PresentAward::
    ld a, $16
    call $3816
    farcall MainMenu_RunSavePrompt
    cp $01
    jr nz, $4c4c
    ld a, $00
    ld [$cc9a], a
    farcall MapSave_RunGameplayPresentation
    ret
    assert @ == $4c4d

section "Campaign Best Value Update", romx[$4c4d], bank[$11]
CampaignStats_UpdateBestValue::
    ld hl, $c68b
    cp [hl]
    jr c, $4c58
    jr z, $4c58
    ld [hl], a
    jr $4c5a
    ld a, $ff
    ret
    assert @ == $4c5b

section "Campaign Medal Tier Classifier", romx[$4c5b], bank[$11]
CampaignMedals_ClassifyTier::
    push bc
    ld b, $00
    ld c, $00
    ld hl, $c68f
    ld a, b
    call $3ac7
    jr z, $4c6a
    inc c
    inc b
    ld a, b
    cp $2d
    jr nz, $4c63
    ld a, [$c68b]
    ld b, a
    ld hl, $c68f
    ld a, $2b
    call $3ac7
    jr nz, $4cd6
    ld a, $2c
    call $3ac7
    jr nz, $4cd6
    ld a, $22
    call $3ac7
    jr nz, $4cfd
    ld a, $23
    call $3ac7
    jr nz, $4cfd
    ld a, $19
    call $3ac7
    jr nz, $4cf9
    ld a, $1a
    call $3ac7
    jr nz, $4cf9
    ld a, $0f
    call $3ac7
    jr nz, $4cf5
    ld a, $10
    call $3ac7
    jr nz, $4cf5
    ld a, $11
    call $3ac7
    jr nz, $4cf5
    ld a, $06
    call $3ac7
    jr nz, $4cf1
    ld a, $07
    call $3ac7
    jr nz, $4cf1
    ld a, $08
    call $3ac7
    jr nz, $4cf1
    ld a, $02
    call $3ac7
    jr nz, $4ced
    ld a, $ff
    jr $4d17
    ld a, c
    cp $2d
    jr z, $4d15
    cp $28
    jr nc, $4d11
    cp $23
    jr nc, $4d0d
    cp $1e
    jr nc, $4d09
    cp $19
    jr nc, $4d05
    jr $4d01
    ld a, $02
    jr $4d17
    ld a, $03
    jr $4d17
    ld a, $04
    jr $4d17
    ld a, $05
    jr $4d17
    ld a, $06
    jr $4d17
    ld a, $07
    jr $4d17
    ld a, $08
    jr $4d17
    ld a, $09
    jr $4d17
    ld a, $0a
    jr $4d17
    ld a, $0b
    jr $4d17
    ld a, $0c
    pop bc
    ret
    assert @ == $4d19

section "Campaign Stat Pointer Resolver", romx[$4d19], bank[$11]
CampaignStats_GetIndexedPointer::
    push bc
    ld b, a
    ld a, [$c633]
    and $01
    jr nz, $4d33
    ld a, b
    add a, a
    ld c, $18
    farcall UnitData_GetByte
    ld hl, $4d35
    call $3a93
    call $4dc6
    pop bc
    ret
    assert @ == $4d35

section "Campaign Stat Pointer Table", romx[$4d35], bank[$11]
CampaignStats_PointerTable::
    db $72, $c7, $70, $c7, $74, $c7, $76, $c7, $76, $c7
    assert @ == $4d3f

section "Campaign Procured Unit Flag Writer", romx[$4d3f], bank[$11]
CampaignStats_MarkProcuredUnit::
    push bc
    ld b, a
    ld a, [$c62f]
    cp $01
    jr nz, $4d58
    ld a, [$c633]
    and $01
    jr nz, $4d58
    ld a, b
    srl a
    ld hl, $c77d
    call $3ad1
    pop bc
    ret
    assert @ == $4d5a

section "Campaign Property Statistics Counters", romx[$4d5a], bank[$11]
CampaignStats_IncrementCapturedProperties::
    ld a, [$c633]
    and $01
    ret nz
    ld hl, $c778
    call $4dc6
    ret
CampaignStats_IncrementDevelopedProperties::
    ld a, [$c633]
    and $01
    ret nz
    ld hl, $c77a
    call $4dc6
    ret
    assert @ == $4d74
