include "macros/macros.inc"

; Bank $0D action dispatcher used by the post-procurement AI runtime.
; resolves the complete seven-way action table from producer+executor
; behavior: move, capture, develop, direct attack, build bridge, area attack, load.

section "Map AI Action Dispatcher", romx[$4407], bank[$0d]
MapAI_DispatchAction::
    farcall UnitSelection_BuildActiveSideExperienceRankTable
    call $65be
    call $4434
    ld a, [$c5ec]
    ld hl, $4426
    call $3a8f
    call $446b
    farcall UnitSelection_PresentExperienceRankChanges
    farcall MapControl_PostAIActionUpdate
    ret
MapAI_ActionHandlerTable::
    db $9f, $44, $a5, $44, $aa, $44, $b6, $44, $ba, $44, $c6, $44, $e2, $44
MapAI_PrepareActionContext::
    push bc
    push de
    ld a, [$c5ed]
    ld [$ccde], a
    ld b, a
    ld a, [$c5ee]
    ld [$ccdf], a
    ld c, a
    farcall MapControl_PanToCoordinates
    farcall MapRuntime_ComputeConnectedAnalysisExtent
    ld [$c9e5], a
    farcall MapGrid_ClearAnalysisFlagAcrossGrid
    farcall Bank0B_MapSetup_428A
    call $45be
    call $65dc
    farcall UnitSelection_RefreshScratchUnitMapPresentation
    ld a, [$c9d8]
    farcall UnitRecord_CopyFromScratch
    pop de
    pop bc
    ret
    push bc
    ld a, [$c9d8]
    ld c, $00
    call $090b
    pop bc
    and a
    jr z, $449e
    farcall MapAI_ApplyAnalysisQueueFuelCost
    farcall UnitTransport_FinalizeMovedCarrierChildren
    ld a, [$cce0]
    set 7, a
    ld [$cce0], a
    ld a, [$c9d8]
    farcall UnitRecord_CopyFromScratch
    ld a, [$ccde]
    ld b, a
    ld a, [$ccdf]
    ld c, a
    ld a, [$c9d8]
    farcall UnitSelection_RefreshScratchOrCarrierMapPresentation
    ret
MapAI_ActionMove::
    ld a, $12
    call $3844
    ret
MapAI_ActionCaptureProperty::
MapAI_ActionHandler1::
    farcall Unit_CapturePropertyAtCurrentPosition
    ret
MapAI_ActionDevelopTerrain::
MapAI_ActionHandler2::
    farcall Unit_DevelopTerrainAtCurrentPosition
    ld a, [$c9d8]
    farcall UnitRecord_CopyToScratch
    ret
MapAI_ActionDirectAttack::
    call $471d
    ret
MapAI_ActionBuildBridge::
    ld a, [$c5f0]
    ld b, a
    ld a, [$c5f1]
    ld c, a
    call $469f
    ret
MapAI_ActionAreaAttack::
MapAI_ActionHandler5::
    ld a, [$c9d8]
    farcall MapAI_ApplyAreaAttackAroundTarget
    add a, $0a
    ld l, a
    ld h, $00
    ld a, [$c9d8]
    farcall UnitRecord_AddExperienceClamped
    ld a, [$c9d8]
    farcall UnitRecord_CopyToScratch
    ret
MapAI_ActionHandlerReturn::
    ret
MapAI_ActionLoadIntoCarrier::
    farcall Unit_LoadIntoCarrierAtActionTarget
    ld a, [$c9d8]
    farcall UnitRecord_CopyToScratch
    ret
    assert @ == $44ee
