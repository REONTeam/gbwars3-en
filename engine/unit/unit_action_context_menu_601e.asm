include "macros/macros.inc"
include "constants/unit_constants.inc"

; shared context-sensitive Unit Action Menu builder.  The MOVE
; controller calls this with B/C = the currently selected destination after
; its coordinate acceptance path; a second same-bank caller at $6240 reuses
; the same helper.  The routine resets the shared menu and chooses which
; availability appenders to run from coordinate occupancy and transient action
; state.  Lower-level $47xx/$61xx helpers remain deliberately structural.

section "Context Unit Action Menu Builder", romx[$601e], bank[$0b]

; B/C = context/destination map coordinate.
; Rebuilds the shared action menu for that coordinate.
UnitActionMenu_BuildContextEntriesAtCoordinates::
    push bc
    ld a, $c0
    call UnitActionMenu_Reset
    pop bc

    ld a, [$c9dd]
    and a
    jr nz, .transient_context

    ld a, [$c9d9]
    cp b
    jr nz, .different_coordinate
    ld a, [$c9da]
    cp c
    jr z, .append_general_entries

.different_coordinate
    farcall $12, UnitRecord_FindPrimaryAtCoordinates
    cp $ff
    jr z, .append_general_entries
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    call UnitTypeSide_IsEmptyOrCurrentPhaseSide
    jr nz, .append_general_entries
    call UnitActionMenu_AppendLoadIntoCarrierIfAvailable
    ret

.transient_context
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_X_OFFSET]
    cp b
    jr nz, .test_target_context
    ld a, [wUnitRecordScratch + UNIT_RECORD_Y_OFFSET]
    cp c
    jr nz, .test_target_context
    jr .test_context_tail

.test_target_context
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call MapTile_GetOverlayIdAtCoordinates
    and a
    ret nz

.test_context_tail
    call MapTile_GetBaseIdAtCoordinates
    farcall $0c, UnitPave_GetTerrainCost
    and a
    ret z
    ld a, UNIT_ACTION_PAVE
    call UnitActionMenu_AddEntry
    ret

.append_general_entries
    call UnitActionMenu_AppendCaptureIfAvailable
    call UnitActionMenu_AppendAction0AIfAvailable
    call UnitActionMenu_AppendFireIfAvailable
    call UnitActionMenu_AppendWaitIfAvailable
    call UnitActionMenu_AppendConstructionIfAvailable
    call UnitActionMenu_AppendBombIfAvailable
    call UnitActionMenu_AppendHPTransferIfAvailable
    call UnitActionMenu_AppendAction0FIfAvailable
    ret

    assert @ == $6096
