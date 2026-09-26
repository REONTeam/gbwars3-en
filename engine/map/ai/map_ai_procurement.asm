include "macros/macros.inc"
include "constants/unit_constants.inc"

; Bank $0D AI unit procurement/planning runtime.
; This tranche consumes the earlier movement-analysis flags to assemble desired
; unit counts and priority groups. Exact tactical labels remain conservative where
; individual table families are not yet tied to a player-facing AI policy.

section "Map AI Procurement Planning", romx[$4e53], bank[$0d]
MapAI_BuildProcurementState::
    push bc
    push de
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    call $528e
    call $4e4f
    call $5186
    jr c, $4e8c
    call $52c4
    call $5336
    ld a, [$dea0]
    bit 0, a
    jr z, $4e81
    call $5208
    call $51b8
    call $524e
    jr $4e8c
    call $5208
    call $524e
    call $51b8
    jr $4e8c
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    pop bc
    ret
MapAI_InitializeDesiredUnitPlan::
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$dded], a
    ld hl, $ddb5
    ld bc, $0034
    xor a
    call $3b79
    ld e, $00
    ld a, e
    farcall UnitPurchase_CheckBuyable
    cp $00
    jr nz, $4ec0
    ld a, e
    ld hl, $ddb5
    call $29bc
    ld a, $01
    ld [hl], a
    inc e
    ld a, e
    cp $34
    jr nz, $4ead
    call $4f1f
    call $4fb5
    call $4fbe
    call $507d
    call $5126
    call $4f9f
    call $4f58
    call $4f70
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
MapAI_AppendDesiredUnitTable::
    ld a, [hli]
    and a
    jr z, $4ef1
    ld b, [hl]
    inc hl
    push hl
    call $4ef2
    pop hl
    jr $4ee4
    ret
MapAI_AppendDesiredUnit::
    push bc
    ld c, a
    ld hl, $ddb5
    call $29bc
    ld a, [hl]
    and a
    jr z, $4f13
    ld [hl], b
    ld a, [$dded]
    add a, a
    ld hl, $ddee
    call $29bc
    ld a, [$dded]
    inc a
    ld [$dded], a
    ld a, c
    ld [hli], a
    ld [hl], b
    pop bc
    ret
MapAI_HalfCountCappedAtFour::
    srl a
    ld b, a
    cp $04
    jr c, $4f1e
    ld b, $04
    ret
MapAI_AddBaselineInfantryNeeds::
    call $4f47
    cp $36
    jr nc, $4f38
    cp $1b
    jr nc, $4f34
    srl a
    srl a
    srl a
    inc a
    ld b, a
    jr $4f3a
    ld b, $04
    jr $4f3a
    ld b, $05
    ld a, $01
    call $4ef2
    ld a, $02
    srl b
    call $4ef2
    ret
MapAI_SumMapClassCounters::
    ld bc, $0000
    ld hl, $c64a
    ld a, [hli]
    add a, c
    ld c, a
    inc b
    ld a, b
    cp $20
    jr nz, $4f4d
    ld a, c
    ret
MapAI_AddReadyPhaseTransportNeeds::
    ld a, [$dea0]
    bit 1, a
    jr z, $4f6f
    ld a, [$dea1]
    call $4f15
    ld a, $2a
    call $4ef2
    ld a, $25
    call $4ef2
    ret
MapAI_AddTransportRouteNeeds::
    ld a, [$dea0]
    bit 2, a
    jr z, $4f9e
    ld a, $02
    call $4f15
    ld a, $30
    call $4ef2
    ld a, [$dea0]
    bit 0, a
    jr nz, $4f9e
    ld a, $01
    ld hl, $ddb5
    call $29bc
    ld a, [hl]
    srl a
    ld b, a
    ld a, $0d
    call $4ef2
    ld a, $17
    call $4ef2
    ret
MapAI_AddInfantryRouteNeeds::
    ld a, [$dea0]
    bit 0, a
    jr z, $4fb4
    ld a, $0d
    ld b, $02
    call $4ef2
    ld a, $17
    ld b, $03
    call $4ef2
    ret
MapAI_AddConstructionTruckNeed::
    ld a, $03
    ld b, a
    ld a, $04
    call $4ef2
    ret
MapAI_AddCompositionFamilyA::
    ld a, [$dea0]
    bit 1, a
    jp z, $507c
    bit 0, a
    jr z, $4ff3
    bit 2, a
    jr z, $5026
    ld a, [$de56]
    bit 1, a
    jr z, $4fdd
    ld hl, $550c
    call $4ee4
    jr $4fe3
    ld hl, $5519
    call $4ee4
    ld a, [$de56]
    bit 2, a
    jr z, $4ff1
    ld a, $29
    ld b, $02
    call $4ef2
    jr $501d
    ld a, [$dea0]
    bit 2, a
    jr z, $5052
    ld a, [$de56]
    bit 1, a
    jr z, $5009
    ld hl, $5522
    call $4ee4
    jr $500f
    ld hl, $552d
    call $4ee4
    ld a, [$de56]
    bit 2, a
    jr z, $501d
    ld a, $29
    ld b, $03
    call $4ef2
    ld a, $26
    ld b, $02
    call $4ef2
    jr $507c
    ld a, [$de56]
    bit 1, a
    jr z, $5035
    ld hl, $5538
    call $4ee4
    jr $503b
    ld hl, $5543
    call $4ee4
    ld a, [$de56]
    bit 2, a
    jr z, $5049
    ld a, $29
    ld b, $04
    call $4ef2
    ld a, $26
    ld b, $03
    call $4ef2
    jr $507c
    ld a, [$de56]
    bit 1, a
    jr z, $5061
    ld hl, $554e
    call $4ee4
    jr $5067
    ld hl, $554e
    call $4ee4
    ld a, [$de56]
    bit 2, a
    jr z, $5075
    ld a, $29
    ld b, $0a
    call $4ef2
    ld a, $26
    ld b, $04
    call $4ef2
    ret
MapAI_AddCompositionFamilyB::
    ld a, [$dea0]
    bit 2, a
    jp z, $5125
    bit 0, a
    jr z, $50b3
    bit 1, a
    jr z, $50e0
    ld a, [$de56]
    bit 2, a
    jr z, $50a4
    ld a, $2c
    ld b, $08
    call $4ef2
    ld a, $32
    ld b, $04
    call $4ef2
    jr $50ab
    ld a, $2c
    ld b, $0c
    call $4ef2
    ld hl, $5566
    call $4ee4
    jr $5125
    ld a, [$dea0]
    bit 1, a
    jr z, $5100
    ld a, [$de56]
    bit 2, a
    jr z, $50d1
    ld a, $2c
    ld b, $0a
    call $4ef2
    ld a, $32
    ld b, $04
    call $4ef2
    jr $50d8
    ld a, $2c
    ld b, $0e
    call $4ef2
    ld hl, $556d
    call $4ee4
    jr $5125
    ld a, [$de56]
    bit 2, a
    jr z, $50f7
    ld a, $2c
    ld b, $0d
    call $4ef2
    ld a, $32
    ld b, $06
    call $4ef2
    jr $50fe
    ld a, $2c
    ld b, $13
    call $4ef2
    jr $511e
    ld a, [$de56]
    bit 2, a
    jr z, $5117
    ld a, $2c
    ld b, $14
    call $4ef2
    ld a, $32
    ld b, $08
    call $4ef2
    jr $511e
    ld a, $2c
    ld b, $1c
    call $4ef2
    ld a, $31
    ld b, $04
    call $4ef2
    ret
MapAI_AddCompositionFamilyC::
    ld a, [$dea0]
    bit 0, a
    jr z, $5170
    ld a, [$dea0]
    bit 1, a
    jr z, $5152
    ld a, [$de56]
    bit 1, a
    jr z, $5143
    ld hl, $5574
    call $4ee4
    jr $5149
    ld hl, $5585
    call $4ee4
    ld a, $05
    ld b, $02
    call $4ef2
    jr $5185
    ld a, [$de56]
    bit 1, a
    jr z, $5161
    ld hl, $5592
    call $4ee4
    jr $5167
    ld hl, $55a3
    call $4ee4
    ld a, $05
    ld b, $06
    call $4ef2
    jr $5185
    ld a, [$de56]
    bit 1, a
    jr z, $517f
    ld hl, $55b0
    call $4ee4
    jr $5185
    ld hl, $55bf
    call $4ee4
    ret
MapAI_CheckCoreDesiredTypes::
    ld a, $04
    call $53b9
    jr c, $51b7
    ld a, $01
    call $53b9
    jr c, $51b7
    ld a, $02
    call $53b9
    jr c, $51b7
    ld a, $0d
    call $53b9
    jr c, $51b7
    ld a, $30
    call $53b9
    jr c, $51b7
    ld a, $2a
    call $53b9
    jr c, $51b7
    ld a, $25
    call $53b9
    jr c, $51b7
    ret
MapAI_AddPriorityGroupA::
    push bc
    push de
    ld e, $00
    ld a, [$de8c]
    ld b, a
    ld a, [$de8d]
    add a, b
    cp $02
    jr nc, $51d4
    ld a, [$ddec]
    cp $0c
    jr nc, $51d9
    ld hl, $51f2
    jr $51dc
    ld hl, $51fc
    jr $51dc
    ld hl, $51f2
    ld a, [hli]
    and a
    jr z, $51e9
    push hl
    call $53d5
    pop hl
    jr c, $51ef
    jr $51dc
    inc e
    ld a, e
    cp $03
    jr nz, $51bc
    pop de
    pop bc
    ret
MapAI_PriorityGroupA_Table0::
    db $1b, $15, $11, $17, $0f, $19, $13, $0b, $09, $00
MapAI_PriorityGroupA_Table1::
    db $13, $11, $1b, $15, $17, $0f, $19, $0b, $09, $00, $05, $00
MapAI_AddPriorityGroupB::
    ld a, [$de8f]
    and a
    jr nz, $5221
    ld a, [$de8d]
    cp $04
    jr nc, $5226
    ld a, [$ddea]
    cp $08
    jr nc, $522b
    ld hl, $523a
    jr $522e
    ld hl, $5240
    jr $522e
    ld hl, $5242
    jr $522e
    ld hl, $5248
    ld a, [hli]
    and a
    jr z, $5239
    push hl
    call $53b9
    pop hl
    jr $522e
    ret
MapAI_PriorityGroupB_Table0::
    db $1d, $20, $1e, $21, $27, $00
MapAI_PriorityGroupB_Table1::
    db $29, $00
MapAI_PriorityGroupB_Table2::
    db $1d, $20, $1e, $21, $27, $00
MapAI_PriorityGroupB_Table3::
    db $27, $1d, $20, $1e, $21, $00
MapAI_AddPriorityGroupC::
    ld a, [$de8f]
    and a
    jr nz, $5271
    ld a, [$dde9]
    cp $05
    jr nc, $5267
    ld a, [$ddea]
    cp $05
    jr nc, $526c
    ld hl, $5280
    jr $5274
    ld hl, $5284
    jr $5274
    ld hl, $5288
    jr $5274
    ld hl, $528c
    ld a, [hli]
    and a
    jr z, $527f
    push hl
    call $53b9
    pop hl
    jr $5274
    ret
MapAI_PriorityGroupC_Table0::
    db $2c, $2f, $2e, $00
MapAI_PriorityGroupC_Table1::
    db $2f, $2c, $2e, $00
MapAI_PriorityGroupC_Table2::
    db $2e, $2c, $2f, $00
MapAI_PriorityGroupC_Table3::
    db $32, $00
MapAI_CountActiveUnitsByType::
    push bc
    push de
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld hl, $dd81
    ld bc, $0034
    xor a
    call $3b79
    ld a, [$c9a2]
    ld d, a
    ld e, $32
    ld a, d
    ld c, $00
    call $090b
    srl a
    ld hl, $dd81
    call $29bc
    inc [hl]
    inc d
    dec e
    jr nz, $52a9
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    pop bc
    ret
MapAI_CountSecondaryUnitsByType::
    push bc
    push de
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld hl, $de57
    ld bc, $0034
    xor a
    call $3b79
    ld a, [$c9a3]
    ld d, a
    ld e, $32
    ld a, d
    ld c, $03
    call $090b
    bit 1, a
    jr nz, $52f8
    ld a, d
    ld c, $00
    call $090b
    srl a
    ld hl, $de57
    call $29bc
    inc [hl]
    inc d
    dec e
    jr nz, $52df
    ld b, $01
    ld c, $1c
    call $535f
    ld [$de8b], a
    ld b, $1d
    ld c, $1f
    call $535f
    ld [$de8d], a
    ld b, $20
    ld c, $2b
    call $535f
    ld [$de8c], a
    ld b, $2c
    ld c, $31
    call $535f
    ld [$de8e], a
    ld b, $32
    ld c, $33
    call $535f
    ld [$de8f], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    pop bc
    ret
MapAI_UpdateCategoryThresholds::
    ld b, $27
    ld c, $2b
    call $5374
    ld [$dde9], a
    ld b, $1d
    ld c, $26
    call $5374
    ld [$ddea], a
    ld b, $2c
    ld c, $31
    call $5374
    ld [$ddeb], a
    ld b, $01
    ld c, $1c
    call $5374
    ld [$ddec], a
    ret
MapAI_SumSecondaryTypeRange::
    push de
    ld a, b
    ld hl, $de57
    call $29bc
    ld d, $00
    ld a, [hli]
    add a, d
    ld d, a
    ld a, b
    inc b
    cp c
    jr nz, $5369
    ld a, d
    pop de
    ret
MapAI_SumActiveTypeRange::
    push de
    ld a, b
    ld hl, $dd81
    call $29bc
    ld d, $00
    ld a, [hli]
    add a, d
    ld d, a
    ld a, b
    inc b
    cp c
    jr nz, $537e
    ld a, d
    pop de
    ret
MapAI_TestDesiredTypeStatus::
    push de
    ld d, a
    call $53ef
    ld a, b
    cp $ff
    jr z, $53b5
    ld a, d
    ld hl, $ddb5
    call $29bc
    ld e, [hl]
    ld a, d
    ld hl, $dd81
    call $29bc
    ld a, [hl]
    cp e
    jr nc, $53b5
    ld a, d
    add a, a
    farcall UnitCreation_CheckPurchaseAffordability
    and a
    jr nz, $53b3
    ld a, $00
    jr $53b7
    ld a, $02
    ld a, $01
    pop de
    ret
MapAI_TestDesiredTypeCandidate::
    push bc
    push de
    ld d, a
    ld a, d
    call $5389
    cp $02
    jr z, $53d1
    cp $01
    jr z, $53ce
    ld a, d
    call $54a8
    jr $53bc
    xor a
    jr $53d2
    scf
    pop de
    pop bc
    ret
MapAI_TestDesiredTypeCandidateAlternate::
    push bc
    push de
    ld d, a
    ld a, d
    call $5389
    cp $02
    jr z, $53eb
    cp $01
    jr z, $53e8
    ld a, d
    call $54a8
    xor a
    jr $53ec
    scf
    pop de
    pop bc
    ret
MapAI_FindDesiredTypeRecord::
    push de
    ld b, a
    ldh a, [$ff82]
    push af
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, b
    call $5451
    cp $ff
    jr z, $5445
    ld d, a
    cp $02
    jr nz, $5420
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    call $5da5
    call $08d7
    ld l, [hl]
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, l
    and a
    jr z, $544a
    ld e, $00
    ld hl, $dd81
    ld a, [hli]
    ld b, [hl]
    inc hl
    ld c, [hl]
    inc hl
    cp $ff
    jr z, $543f
    farcall UnitCreation_GetEligiblePropertyTypeNearHQ
    and a
    jr z, $543f
    push bc
    ld b, a
    ld a, d
    call $5482
    pop bc
    and a
    jr z, $544a
    inc e
    ld a, e
    cp $64
    jr nz, $5425
    ld bc, $ffff
    jr $544a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    ret
MapAI_ClassifyUnitTypeDomain::
    push bc
    push de
    ld b, a
    farcall UnitPurchase_CheckBuyable
    cp $00
    jr nz, $547d
    ld a, b
    cp $04
    jr z, $5471
    cp $05
    jr z, $5471
    cp $1d
    jr c, $5475
    cp $2c
    jr c, $5479
    ld a, $09
    jr $547f
    ld a, $04
    jr $547f
    ld a, $02
    jr $547f
    ld a, $06
    jr $547f
    ld a, $ff
    pop de
    pop bc
    ret
MapAI_TestDomainCompatibility::
    cp $04
    jr z, $549f
    cp $06
    jr z, $549f
    cp $09
    jr z, $549f
    ld a, $01
    cp b
    jr z, $54a2
    ld a, $02
    cp b
    jr z, $54a2
    ld a, $04
    cp b
    jr z, $54a2
    jr $54a5
    cp b
    jr nz, $54a5
    xor a
    jr $54a7
    ld a, $01
    ret
MapAI_StageSelectedPurchaseType::
    push bc
    push de
    call $54f0
    add a, a
    ld d, a
    ld a, [$c633]
    and $01
    add a, d
    ld d, a
    farcall MapControl_PanToCoordinates
    ld a, d
    farcall UnitCreation_ApplyPurchaseResourceCosts
    ld a, d
    farcall Unit_IncrementBuiltCountForEncodedSide
    ld a, d
    farcall MapUnit_CreateInitial
    farcall Unit_SetEndTurnFlag
    ld a, $08
    call $3844
    farcall MapUnitTransition_BeginCreation
    ld a, d
    farcall MapTile_SetOverlayByteAtCoordinates
    farcall Bank0B_MapSetup_43D1
    farcall MapUnitTransition_EndCreation
    ld a, $02
    farcall MapTile_SetFlagAtCoordinates
    farcall Bank0B_MapSetup_43D1
    pop de
    pop bc
    ret
MapAI_IncrementActiveTypeCount::
    push af
    push bc
    ld b, a
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld hl, $dd81
    ld a, b
    call $29bc
    inc [hl]
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop bc
    pop af
    ret
MapAI_CompositionData::
    daa
    inc b
    jr nz, $5512
    ld hl, $1d02
    inc b
    ld e, $04
    inc hl
    ld [bc], a
    nop
    daa
    inc b
    jr nz, $5521
    ld hl, $2304
    ld [bc], a
    nop
    daa
    inc b
    jr nz, $552a
    ld hl, $1d04
    ld [bc], a
    inc hl
    ld [bc], a
    nop
    daa
    ld b, $20
    dec b
    ld hl, $1d02
    ld [bc], a
    inc hl
    ld [bc], a
    nop
    daa
    inc bc
    jr nz, $553f
    ld hl, $1d03
    ld [bc], a
    inc hl
    inc bc
    nop
    daa
    inc bc
    jr nz, $554b
    ld hl, $1d02
    ld [bc], a
    inc hl
    inc b
    nop
    daa
    inc bc
    jr nz, $5556
    ld hl, $1d02
    inc bc
    ld e, $02
    inc hl
    inc b
    nop
    daa
    ld b, $20
    dec b
    ld hl, $1d05
    ld [bc], a
    inc hl
    ld [bc], a
    nop
    cpl
    ld [bc], a
    ld l, $02
    ld sp, $0002
    cpl
    ld [bc], a
    ld l, $03
    ld sp, $0003
    dec de
    inc b
    dec d
    ld [bc], a
    ld de, $0f02
    ld [bc], a
    add hl, bc
    ld [bc], a
    dec bc
    ld [bc], a
    add hl, de
    ld [bc], a
    inc de
    ld [bc], a
    nop
    add hl, bc
    ld [bc], a
    dec bc
    ld [bc], a
    add hl, de
    ld [bc], a
    rrca
    ld [bc], a
    dec de
    ld b, $15
    inc bc
    nop
    add hl, bc
    inc bc
    dec bc
    ld [bc], a
    add hl, de
    ld [bc], a
    rrca
    inc b
    dec de
    ld b, $15
    inc bc
    ld de, $1302
    inc bc
    nop
    add hl, bc
    inc bc
    dec bc
    ld [bc], a
    add hl, de
    ld [$030f], sp
    dec de
    ld b, $15
    inc b
    nop
    dec bc
    ld [bc], a
    add hl, de
    inc bc
    rrca
    ld [bc], a
    dec de
    inc b
    dec d
    ld [bc], a
    ld de, $1302
    ld [bc], a
    nop
    add hl, de
    ld [bc], a
    rrca
    ld [bc], a
    dec de
    ld b, $15
    inc bc
    nop
    assert @ == $55c8
