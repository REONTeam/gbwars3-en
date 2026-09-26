include "macros/macros.inc"
include "constants/unit_constants.inc"

; final focused Bank $0D semantic split. The former 
; $6325-$6617 byte block is now organized around the behavior-proven Bomber
; area-attack planner, ordered unit planner dispatch, and shared selected-unit
; tactical context helpers. Remaining lower-level helpers retain conservative names.

section "Map AI Tactical Selector Continuation", romx[$6325], bank[$0d]
MapAI_RunBomberAreaAttackPlanner::
    ld hl, $632c
    call $6472
    ret
MapAI_BomberPlannerOrder::
    inc hl
    nop
MapAI_PlanBomberAreaAttack::
    push bc
    push de
    ld a, [$cce5]
    and a
    jr z, $638c
    call $638f
    ld a, b
    cp $ff
    jr nz, $6383
    call $63e5
    ld a, b
    cp $ff
    jr z, $638c
    ld d, b
    ld e, c
    ld a, [$ccdd]
    call $58a2
    call $5bb5
    ld a, b
    cp $ff
    jr z, $638c
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    push bc
    ldh a, [$ff82]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    ld b, d
    ld c, e
    call $08d7
    ld d, [hl]
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop bc
    ld a, d
    cp $ff
    jr nz, $6383
    ld a, $00
    ld [$c5ec], a
    call $4407
    jr $638c
    call $6443
    and a
    jr z, $6379
    call $468b
    pop de
    pop bc
    ret
MapAI_FindBestBomberAreaTargetInSearchBounds::
    push de
    ldh a, [$ff82]
    push af
    ld a, $ff
    ldh [$ff99], a
    ldh [$ff9a], a
    xor a
    ldh [$ff9b], a
    call $5de7
    ld a, [$c610]
    ld c, a
    ld a, [$c60f]
    ld b, a
    call $08d7
    push hl
    push hl
    call $5db5
    pop hl
    and a
    jr nz, $63c8
    call $6443
    cp $02
    jr c, $63c8
    ld hl, $ff9b
    cp [hl]
    jr c, $63c8
    ldh [$ff9b], a
    ld a, b
    ldh [$ff99], a
    ld a, c
    ldh [$ff9a], a
    pop hl
    inc hl
    inc b
    ld a, [$c611]
    cp b
    jr nc, $63aa
    inc c
    ld a, [$c612]
    cp c
    jr nc, $63a3
    ldh a, [$ff99]
    ld b, a
    ldh a, [$ff9a]
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    ret
MapAI_FindBestBomberAreaTargetFromAnalysisRecords::
    push de
    ldh a, [$ff82]
    push af
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $ff
    ldh [$ff99], a
    ldh [$ff9a], a
    xor a
    ldh [$ff9b], a
    ld a, [$ccde]
    ld d, a
    ld a, [$ccdf]
    ld e, a
    xor a
    ldh [$ff9d], a
    ld hl, $dd81
    ld a, [hli]
    ld b, [hl]
    inc hl
    ld c, [hl]
    inc hl
    push hl
    cp $ff
    jr z, $642c
    call $0985
    farcall MapTile_ClassifyOwnershipForCurrentPhase
    cp $01
    jr nz, $642c
    call $6443
    ld hl, $ff9b
    cp [hl]
    jr c, $642c
    ldh [$ff9b], a
    ld a, b
    ldh [$ff99], a
    ld a, c
    ldh [$ff9a], a
    pop hl
    ldh a, [$ff9d]
    inc a
    ldh [$ff9d], a
    cp $64
    jr nz, $6406
    ldh a, [$ff99]
    ld b, a
    ldh a, [$ff9a]
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    ret
MapAI_CountOpposingPropertiesInArea::
    push bc
    push de
    ld d, $00
    call $0985
    farcall MapTile_ClassifyOwnershipForCurrentPhase
    cp $01
    jr nz, $6453
    inc d
    ld e, $00
    push bc
    call $28d9
    jr c, $6467
    call $0985
    farcall MapTile_ClassifyOwnershipForCurrentPhase
    cp $01
    jr nz, $6467
    inc d
    pop bc
    inc e
    ld a, e
    cp $06
    jr nz, $6455
    ld a, d
    pop de
    pop bc
    ret
MapAI_RunOrderedUnitPlannerList::
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld de, $de90
    ld a, [hli]
    ld [de], a
    inc de
    and a
    jr nz, $647e
    ld a, [$c9a2]
    ld d, a
    ld e, $32
    ld a, d
    call $652d
    and a
    jr z, $64a8
    srl a
    call $64af
    and a
    jr z, $64a8
    push af
    ld a, d
    call $6563
    pop af
    call $64bd
    ld a, [$ca94]
    and a
    jr nz, $64ac
    inc d
    dec e
    jr nz, $648a
    pop de
    pop bc
    ret
MapAI_UnitTypeIsInPlannerOrder::
    push bc
    ld b, a
    ld hl, $de90
    ld a, [hli]
    cp b
    jr z, $64bb
    and a
    jr nz, $64b4
    pop bc
    ret
MapAI_DispatchPlannerForUnitType::
    ld hl, $64c4
    call $3a93
    jp hl
MapAI_UnitPlannerDispatchTable::
    db $00, $00, $40, $62, $40, $62, $40, $62, $b6, $62, $2c, $65, $2c, $65, $2c, $65
    db $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65
    db $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65
    db $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65
    db $2c, $65, $2c, $65, $2c, $65, $2e, $63, $2e, $63, $2c, $65, $2c, $65, $2c, $65
    db $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65, $2c, $65
    db $2c, $65, $2c, $65, $2c, $65, $2c, $65
MapAI_NoUnitPlanner::
    ret
MapAI_GetEligiblePlannerUnitEncodedType::
    push bc
    ld b, a
    ld c, $00
    call $090b
    and a
    jr z, $6560
    ld c, a
    push bc
    ld a, b
    ld c, $03
    call $090b
    pop bc
    bit 7, a
    jr nz, $6560
    bit 1, a
    jr nz, $6560
    bit 0, a
    jr z, $655d
    push bc
    ld a, b
    ld c, $06
    call $090b
    ld c, $03
    call $090b
    pop bc
    bit 0, a
    jr nz, $6560
    ld a, c
    jr $6561
    xor a
    pop bc
    ret
MapAI_SelectUnitAndEnsureTacticalContext::
    ld [$c9d8], a
    call $6574
    call $65a9
    ret
MapAI_SelectUnitAndLoadTacticalContext::
    ld [$c9d8], a
    call $6574
    ret
MapAI_LoadSelectedUnitTacticalContext::
    xor a
    ld [$c613], a
    ld a, [$c9d8]
    farcall UnitRecord_CopyToScratch
    ld a, [$c9d8]
    farcall UnitWeapon_BuildSummary
    ld a, [$ccde]
    ld [$c9d9], a
    ld a, [$ccdf]
    ld [$c9da], a
    farcall UnitAction_ResetTransientState
    ld a, $ff
    ld [$c5ed], a
    ld [$c5ee], a
    ld [$c5f0], a
    ld [$c5f1], a
    xor a
    ld [$c5ec], a
    ret
MapAI_EnsureSelectedUnitMapContext::
    ld a, [$c613]
    and a
    ret nz
    ld a, [$c9d8]
    call $5b8a
    farcall MapGrid_ClearAnalysisFlagAcrossGrid
    ld a, $01
    ld [$c613], a
    ret
MapAI_CommitSelectedUnitTacticalPosition::
    push bc
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    farcall MapControl_PanToCoordinates
    ld a, $02
    call $3844
    ld a, [$c9d8]
    call $5b8a
    farcall Bank0B_MapSetup_428A
    pop bc
    ret
MapAI_ResolveSelectedUnitCarriedState::
    ld a, [$cce0]
    bit 0, a
    ret z
    push bc
    push de
    res 0, a
    ld [$cce0], a
    ld a, [$cce3]
    ld c, $05
    call $090b
    dec a
    ld b, a
    ld a, [$cce3]
    call $0942
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    farcall UnitRecord_FindPrimaryAtCoordinates
    farcall UnitSelection_RefreshLiveUnitOrCarrierMapPresentation
    farcall Bank0B_MapSetup_43D1
    pop de
    pop bc
    ret
MapAI_ResetPlannerScratchAndInitializePlayers::
    xor a
    ld [$c99f], a
    call $6618
    ret
    assert @ == $6618
