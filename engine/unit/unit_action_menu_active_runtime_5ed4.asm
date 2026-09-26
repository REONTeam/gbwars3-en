include "macros/macros.inc"
include "constants/unit_constants.inc"

; active-unit Action Menu setup/run family.  $5ED4 is independently
; farcalled by two Bank-$0D tactical paths; $5F44 is a separate same-bank
; dispatcher entry and is deliberately left as a separate ownership boundary.

section "Active Unit Action Menu Runtime", romx[$5ed4], bank[$0b]

; Clear three transient action/analysis bytes used while rebuilding the active
; unit command context.  $C9E5 retains only the established 
; queue_count-1 contract; the exact roles of $C9DD/$C9DE remain neutral.
UnitAction_ResetTransientState::
    xor a
    ld [$c9dd], a
    ld [$c9de], a
    ld [$c9e5], a
    ret

; Reset the shared Unit Action Menu with tile base $C0, then run the individual
; availability appenders for the currently staged unit.  When $CCE0 bit 7 is
; set, the later action families are skipped exactly as in retail.
UnitActionMenu_BuildActiveUnitEntries::
    ld a, $c0
    call UnitActionMenu_Reset
    call UnitActionMenu_AppendMoveIfAvailable
    call UnitActionMenu_AppendCarriedChildActionIfAvailable
    ld a, [$cce0]
    bit 7, a
    jr nz, .done
    call UnitActionMenu_AppendFireIfAvailable
    call UnitActionMenu_AppendAction1BIfAvailable
    call UnitActionMenu_AppendCaptureIfAvailable
    call UnitActionMenu_AppendAction0AIfAvailable
    call UnitActionMenu_AppendPaveIfAvailable
    call UnitActionMenu_AppendConstructionIfAvailable
    call UnitActionMenu_AppendAction1AIfAvailable
    call UnitActionMenu_AppendHPTransferIfAvailable
.done
    ret

; Rebuild and run the active unit's Action Menu.  No staged entries returns
; immediately.  The single retail action ID $12 takes the direct execution
; path; otherwise the shared selector returns an action ID which is passed to
; the still-unsourced $6283 action executor.  $FF requests a complete menu
; rebuild, matching the loop back to this entry.
UnitActionMenu_RunActiveUnitController::
.loop
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_CopyToScratch
    call UnitAction_ResetTransientState
    call UnitSelection_BuildActiveSideExperienceRankTable
    call UnitActionMenu_BuildActiveUnitEntries
    ld a, [$c9be]
    and a
    jp z, .done
    ld a, [$c9be]
    cp 1
    jr nz, .select
    ld a, [$c9b6]
    cp UNIT_ACTION_MOVE
    jp z, .execute
.select
    call UnitActionMenu_RunSelection
    and a
    jr z, .done
    call UnitAction_ExecuteSelected
    cp $ff
    jr z, .loop
    jp .done
.execute
    call UnitAction_ExecuteSelected
.done
    ret

    assert @ == $5f44
