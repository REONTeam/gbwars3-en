include "macros/macros.inc"
include "constants/unit_constants.inc"

; Carried-child action controller used by FLY and DROP. The carrier index is
; preserved while the player chooses one of its carried units; the selected
; child then receives its own reduced Action Menu. A child may MOVE when its
; movement/end-state permits it, and may also receive the normal SUPPLY entry.
; Cancelling restores the carrier as the active unit and returns $FF so the
; parent Action Menu can be rebuilt.

DEF wCarriedChildActionCarrierIndex EQU $c9df
DEF wCarriedChildActionTransient EQU $c9de

section "Bank $0B UnitTransport_RunCarriedChildActionController", romx[$63cf], bank[$0b]

UnitTransport_RunCarriedChildActionController::
    ld a, [wMapAIActiveUnitIndex]
    ld [wCarriedChildActionCarrierIndex], a
    call UnitTransport_SetupActiveCarriedChildList

.select_child
    ld a, [wCarriedChildActionCarrierIndex]
    ld [wMapAIActiveUnitIndex], a
    farcall $12, UnitRecord_CopyFromScratch
    call UnitTransport_RunCarriedChildSelection
    cp $ff
    jr z, .cancel

    call LCDScanlineTransition_Reset

.action_menu
    call UnitTransport_BuildSelectedChildActionMenu
    ld a, [wUnitActionMenuEntryCount]
    and a
    jr z, .cancel
    cp 1
    jr z, .single_move_entry

    call UnitActionMenu_RunSelection
    cp UNIT_ACTION_MOVE
    jr z, .run_move
    cp UNIT_ACTION_SUPPLY
    jr z, .execute_selected
    jr .select_child

.single_move_entry
    farcall $0c, UnitAction_PrepareCarriedChildMovePresentation
    ld a, $01
    ld [wCarriedChildActionTransient], a
    ld a, UNIT_ACTION_MOVE
    call UnitAction_ExecuteSelected
    cp $ff
    jr z, .select_child
    jr .done

.run_move
    farcall $0c, UnitAction_PrepareCarriedChildMovePresentation
    ld a, $01
    ld [wCarriedChildActionTransient], a
    ld a, UNIT_ACTION_MOVE

.execute_selected
    call UnitAction_ExecuteSelected
    cp $ff
    jr z, .action_menu
    jr .done

.cancel
    ld a, [wCarriedChildActionCarrierIndex]
    ld [wMapAIActiveUnitIndex], a
    ld a, $ff
.done
    ret

    assert @ == $6437

section "Bank $0B UnitTransport_BuildSelectedChildActionMenu", romx[$6437], bank[$0b]

UnitTransport_BuildSelectedChildActionMenu::
    push bc
    push de
    ld a, $c0
    call UnitActionMenu_Reset
    ld a, [wUnitRecordScratch + UNIT_RECORD_STATUS_OFFSET]
    bit UNIT_RECORD_STATUS_END_TURN_F, a
    jr nz, .done
    call UnitActionMenu_AppendMoveIfAvailable
    call UnitActionMenu_AppendAction1BIfAvailable
.done
    pop de
    pop bc
    ret

    assert @ == $644e

section "Bank $0B UnitAction_IsContextTargetUnavailable", romx[$644e], bank[$0b]

; B/C = candidate coordinate. Returns A = 0 when the coordinate may open the
; context Action Menu and A = 1 when it must be rejected. Remaining on the
; unit's origin is allowed only when the scratch unit is not marked carried;
; other coordinates require map-plane-2 bit 7, the movement-analysis reachability
; flag used by the MOVE cursor runtime.
UnitAction_IsContextTargetUnavailable::
Bank0B_Helper644E:: ; compatibility alias
    push bc
    ld a, [$c9d9]
    cp b
    jr nz, .different_coordinate
    ld a, [$c9da]
    cp c
    jr nz, .different_coordinate
    ld a, [wUnitRecordScratch + UNIT_RECORD_STATUS_OFFSET]
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr z, .available
    jr .unavailable

.different_coordinate
    call MapTile_ReadBank2AtCoordinates
    bit 7, a
    jr z, .unavailable
    jr .available

.available
    xor a
    jr .done
.unavailable
    ld a, $01
.done
    pop bc
    ret

    assert @ == $6474

section "Bank $0B Capture Availability Predicate", romx[$6474], bank[$0b]

; B/C = target map coordinate. Returns A = 0 only when the staged unit state
; satisfies the retail capture gate and the base tile is accepted by the existing
; capture-target classifier; otherwise returns A = 1. The exact meaning of the
; initial scratch-record class threshold remains intentionally structural.
UnitAction_IsCaptureUnavailableAtCoordinates::
Bank0B_Helper6474:: ; compatibility alias retained from earlier source
    ld a, [wUnitRecordScratch]
    srl a
    cp 4
    jr nc, .reject
    call MapTile_GetBaseIdAtCoordinates
    call MapControl_IsCaptureTargetRejected
    and a
    jr z, .accept
.reject
    ld a, 1
    jr .done
.accept
    xor a
.done
    ret

    assert @ == $648c
