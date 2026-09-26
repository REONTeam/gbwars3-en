include "macros/macros.inc"
include "constants/unit_constants.inc"

section "Map AI Tactical Helpers A", romx[$44ee], bank[$0d]
MapAI_StageAndExecuteDirectAttackAtCoordinates::
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    ld a, [$c5e7]
    ld [$c5ef], a
    call $095e
    ld a, b
    ld [$c5f0], a
    ld a, c
    ld [$c5f1], a
    ld a, $03
    ld [$c5ec], a
    call $471d
    ret
    push bc
    ld [$c9d8], a
    farcall UnitRecord_CopyToScratch
    ld a, [$c9d8]
    farcall UnitWeapon_BuildSummary
    ld a, [$ccde]
    ld [$c9d9], a
    ld b, a
    ld a, [$ccdf]
    ld [$c9da], a
    ld c, a
    farcall MapControl_PanToCoordinates
    ld a, $0a
    call $3844
    farcall UnitAction_ResetTransientState
    ld a, [$c9d8]
    call $5b8a
    farcall MapGrid_ClearAnalysisFlagAcrossGrid
    pop bc
    ret
    push bc
    push de
    ld a, [$c9d8]
    call $5b8a
    farcall Bank0B_MapSetup_428A
    ld a, b
    ld [$ccde], a
    ld a, c
    ld [$ccdf], a
    farcall MapControl_PanToCoordinates
    ld a, [$ccde]
    ld b, a
    ld a, [$ccdf]
    ld c, a
    farcall MapRuntime_ComputeConnectedAnalysisExtent
    ld [$c9e5], a
    farcall MapGrid_ClearAnalysisFlagAcrossGrid
    farcall Bank0B_MapSetup_428A
    call $45be
    farcall UnitAction_FinalizeActiveUnitActionState
    farcall MapAI_ApplyAnalysisQueueFuelCost
    farcall UnitTransport_FinalizeMovedCarrierChildren
    pop de
    pop bc
    ret
    push bc
    push de
    ld a, b
    ld [$ccde], a
    ld a, c
    ld [$ccdf], a
    farcall MapControl_PanToCoordinates
    ld a, [$ccde]
    ld b, a
    ld a, [$ccdf]
    ld c, a
    farcall MapRuntime_ComputeConnectedAnalysisExtent
    ld [$c9e5], a
    farcall MapGrid_ClearAnalysisFlagAcrossGrid
    farcall Bank0B_MapSetup_428A
    call $45be
    farcall UnitAction_FinalizeActiveUnitActionState
    farcall MapAI_ApplyAnalysisQueueFuelCost
    farcall UnitTransport_FinalizeMovedCarrierChildren
    pop de
    pop bc
    ret
    push bc
    push de
    ldh a, [$ff82]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    farcall UnitSelection_ClearCoordinateMapPresentation
    ld a, [$dd80]
    sub $02
    jr z, $4627
    jr c, $4627
    ld e, a
    push de
    ld a, e
    add a, a
    ld hl, $dd81
    call $29bc
    ld b, [hl]
    inc hl
    ld c, [hl]
    push bc
    farcall MapTile_ReadBank1AtCoordinates
    ld [$c021], a
    and $3f
    farcall MapTile_WriteBank1AtCoordinates
    farcall MapTile_ReadBank2AtCoordinates
    ld [$c022], a
    ld a, [$ccdd]
    farcall MapTile_WriteBank2AtCoordinates
    farcall Bank0B_MapSetup_43D1
    ld a, $02
    call $3baf
    pop bc
    ld a, [$c021]
    farcall MapTile_WriteBank1AtCoordinates
    ld a, [$c022]
    farcall MapTile_WriteBank2AtCoordinates
    farcall Bank0B_MapSetup_43D1
    pop de
    dec e
    jr nz, $45df
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    pop bc
    ret
    call $4546
    ld a, [$c9d8]
    farcall UnitRecord_CopyFromScratch
    ld a, $08
    farcall MapControl_ResolutionSceneRefresh
    ret
    ld a, [$c9d8]
    call $095e
    jr $462f
    farcall UnitSupply_Execute
    ld a, [$c9d8]
    farcall UnitRecord_CopyToScratch
    ret
MapAI_DispatchCaptureAtCoordinates::
    ld a, $01
    ld [$c5ec], a
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    call $4407
    ret
MapAI_DispatchDevelopAtCoordinates::
    ld a, $02
    ld [$c5ec], a
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    call $4407
    ret
    ld c, $01
    call $095e
    call $4546
    farcall Unit_LoadIntoCarrierAtActionTarget
    ld a, [$c9d8]
    farcall UnitRecord_CopyToScratch
    ret
    ret
MapAI_DispatchAreaAttackAtCoordinates::
    ld a, $05
    ld [$c5ec], a
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    call $4407
    ret
    ret
    ret
    ret
    assert @ == $469f

section "Map AI Tactical Helpers B", romx[$46b7], bank[$0d]
MapAI_TacticalHelpersB::
    push de
    ld e, a
    ld a, [$c9d8]
    ld d, a
    farcall MapRuntime_ComputeConnectedAnalysisExtent
    ld [$c9e5], a
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    call $08d7
    ld a, [hl]
    ld [$c5f2], a
    ld a, [$ccdd]
    ld [hl], a
    push bc
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    call $08d7
    ld a, [hl]
    ld [$c5f3], a
    xor a
    ld [hl], a
    pop bc
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    farcall Battle_CalculatePackedHPDamage
    push af
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    call $08d7
    ld a, [$c5f2]
    ld [hl], a
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    call $08d7
    ld a, [$c5f3]
    ld [hl], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop af
    pop de
    pop bc
    ret
    assert @ == $471d
