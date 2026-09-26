include "macros/macros.inc"

; Beginner/Campaign post-map routing reached by the main mode dispatcher.
; Instruction forms stay byte-identical to retail while the externally visible
; entry points and established medal/stat dependencies are named.
section "Campaign Mode Entry Runtime", romx[$48af], bank[$11]
BeginnerMode_RunResultFlow::
    xor a
    ld [$c62b], a
    ld [$c62c], a
    ld [$c62d], a
    ld a, $16
    call Audio_PlayMusic
    ld a, [$c6a3]
    farcall MapRecord_SelectBeginner
    ld a, [$ca94]
    cp $02
    jr z, jr_011_4900
    ld a, [$c6a3]
    ld hl, $c68d
    call Bitfield_Set
    farcall MapRuntime_AreBeginnerFlags0To14Set
    and a
    jr z, jr_011_4904
    ld hl, $c687
    ld a, $00
    call Bitfield_Test
    jr nz, jr_011_48f3
    ld a, $00
    call CampaignMedals_SetJustObtainedFlag
    call CampaignStats_SynchronizeFlags
    ld a, $02
    call CampaignMedals_TryAwardMappedMedal
jr_011_48f3:
    ld a, $05
    farcall AttractScene_Run
    call CampaignMedals_PresentAward
    ld a, $01
    jr jr_011_490b
jr_011_4900:
    ld a, $00
    jr jr_011_490b
jr_011_4904:
    ld a, $00
    push af
    call CampaignMedals_PresentAward
    pop af
jr_011_490b:
    ret

CampaignMode_RunResultFlow::
    xor a
jr_011_490d:
    ld [$c62b], a
    ld [$c62c], a
    ld [$c62d], a
    ld a, $16
    call Audio_PlayMusic
    ld a, [$c6a4]
    farcall MapRecord_SelectCampaign
    farcall CampaignResult_ShowSummary
    ld a, [$ca94]
    cp $02
    jr z, jr_011_4971
    ld a, $01
    ld [$c62e], a
    call CampaignMode_HasProgressThreshold
    and a
    jr nz, jr_011_493c
    ld b, $02
    jr jr_011_493e
jr_011_493c:
    ld b, $03
jr_011_493e:
    ld a, [$c6a4]
    farcall MapBriefing_OpenModal
jr_011_4945:
    ld hl, $c77d
    ld a, $36
    call Bitfield_Test
    jr nz, jr_011_4956
    ld a, $17
    call CampaignMedals_SetJustObtainedFlag
    jr jr_011_4956
jr_011_4956:
    ld a, [$c6a4]
    ld hl, $c68f
    call Bitfield_Set
    ld a, [$c6a4]
    ld hl, $c784
    call AddAtoHL
    ld a, [hl]
    cp $63
    jr z, jr_011_4983
    inc a
    ld [hl], a
    jr jr_011_4983
jr_011_4971:
    ld a, $00
    ld [$c62e], a
    ld a, $2d
    ld b, $00
    farcall MapBriefing_OpenModal
    ld a, $02
    call CampaignMedals_SetJustObtainedFlag
jr_011_4983:
    call CampaignMedals_CheckCategoryMedals
    call CampaignMedals_CheckAllUnitMedal
    call CampaignMedals_CheckMasterAndSuperPrize
    call CampaignMedals_CheckMappedAward
    call CampaignStats_SynchronizeFlags
    call CampaignMedals_ClassifyTier
    cp $ff
    jr z, jr_011_499c
    call CampaignMedals_TryAwardMappedMedal
jr_011_499c:
    ld a, [$c6a4]
    ld c, a
    call CampaignMode_SelectNextMap
    ld [$c6a4], a
    cp c
    jr z, jr_011_49d5
    farcall ReserveUnits_SaveSide0
    ld a, [$c6a4]
    cp $80
    jr nc, jr_011_49bc
    ld hl, $c69d
    call Bitfield_Set
    jr jr_011_49d5
jr_011_49bc:
    sub $80
    push af
    farcall AttractScene_Run
    pop af
    ld hl, $c6a6
    call Bitfield_Set
    xor a
    ld [$c6a4], a
    call CampaignMedals_PresentAward
    ld a, $01
    jr jr_011_49da
jr_011_49d5:
    call CampaignMedals_PresentAward
    ld a, $00
jr_011_49da:
    ret
CampaignMode_SelectNextMap:
    ld a, [$ca94]
    cp $02
    jr z, jr_011_49f6
    call CampaignMode_HasProgressThreshold
    and a
    jr nz, jr_011_49ec
    ld b, $01
    jr jr_011_49ee
jr_011_49ec:
    ld b, $00
jr_011_49ee:
    ld a, [$c6a4]
    farcall UnitStatus_GetLayoutValue
    ret
jr_011_49f6:
    ld a, [$c6a4]
    ret
CampaignMode_HasProgressThreshold:
    push bc
    ld a, [$c6a4]
    farcall MapRuntime_GetCampaignTableByte1
    ld b, a
    ld a, [$c633]
    srl a
    cp b
    jr nc, jr_011_4a0e
    xor a
    jr jr_011_4a10
jr_011_4a0e:
    ld a, $01
jr_011_4a10:
    pop bc
    ret

    assert @ == $4a12
