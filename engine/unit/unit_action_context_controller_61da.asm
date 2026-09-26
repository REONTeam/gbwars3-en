include "macros/macros.inc"
include "constants/unit_constants.inc"

; context Unit Action controller used by MOVE after a destination /
; interaction coordinate has been staged. The routine snapshots target-derived
; state, prepares the shared analysis workspace, runs the context Action Menu,
; dispatches the selected action through $6283, and either rebuilds the menu on
; executor result $FF or finalizes the action and movement bookkeeping.
;
; Several lower-level $42xx/$47xx/$68xx helpers and $C9DB/$C9DC/$CCDE/$CCDF
; scratch fields remain address-oriented until their producer/consumer contracts
; are independently source-backed. The physical range stops exactly at $6283,
; the separately called shared Unit Action executor.

section "Context Unit Action Controller", romx[$61da], bank[$0b]

UnitAction_RunContextSelectionController::
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call $4714
    ld [$c9db], a
    call $472a
    ld [$c9dc], a

    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    call UnitSelection_ClearCoordinateMapPresentation

    ld a, [$cce0]
    bit 0, a
    jr z, .stage_target
    ld a, [$cce3]
    call UnitSelection_RefreshLiveUnitMapPresentation
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_CopyToScratch

.stage_target
    ld a, [wMapActionTargetX]
    ld [$ccde], a
    ld b, a
    ld a, [wMapActionTargetY]
    ld [$ccdf], a
    ld c, a
    call UnitSelection_RefreshScratchUnitMapPresentation
    call MapRuntime_ComputeConnectedAnalysisExtent
    ld [$c9e5], a

.menu_loop
    ld a, [$c9dd]
    and a
    jp nz, .run_forced_context_path

    call UnitActionMenu_RunSelection
    and a
    jr z, .cancel

    call UnitAction_ExecuteSelected
    cp $ff
    jr nz, .selected_action_complete

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call UnitActionMenu_BuildContextEntriesAtCoordinates
    jr .menu_loop

.selected_action_complete
    call MapAI_ApplyAnalysisQueueFuelCost
    call UnitTransport_FinalizeMovedCarrierChildren
    xor a
    ret

.run_forced_context_path
    farcall $0c, UnitPave_ExecuteSelectedRoute
    call UnitAction_FinalizeActiveUnitActionState
    jr .selected_action_complete

.cancel
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, [$c9db]
    call $4740
    ld a, [$c9dc]
    call $4758
    call $43d1
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_CopyToScratch
    ld a, [wMapAIActiveUnitIndex]
    call UnitSelection_RefreshScratchOrCarrierMapPresentation
    call $54b6
    call $428a
    ld a, $ff
    ret

    assert @ == $6283
