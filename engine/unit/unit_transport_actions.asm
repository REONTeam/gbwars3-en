include "macros/macros.inc"
include "constants/unit_constants.inc"

; transport loading capacity check and load executor used by the
; Bank $0D AI action dispatcher. These routines operate on the shared selected
; unit scratch record plus the current action target coordinates.

section "Unit Transport Load Actions", romx[$5d84], bank[$0b]

; B/C = target coordinates. The selected unit is held in wUnitRecordScratch.
; Returns A = 0 when the primary unit at B/C is a compatible carrier with a
; free transport slot, A = 1 otherwise.
Unit_CanLoadIntoCarrierAtCoordinates::
    push bc
    push de
    push hl
    farcall $12, UnitRecord_FindPrimaryAtCoordinates
    cp $ff
    jr z, .reject
    ld [wUnitLoadTargetIndex], a
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    ld [wUnitLoadTargetTypeSide], a
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    ld b, a
    ld a, [wUnitLoadTargetTypeSide]
    farcall $12, UnitData_CheckLoadingCompatibility
    jr nz, .reject
    ld a, [wUnitLoadTargetTypeSide]
    ld c, UNIT_DATA_TRANSPORT_CAPACITY_OFFSET
    farcall $12, UnitData_GetByte
    ld d, a
    ld a, [wUnitLoadTargetIndex]
    ld c, UNIT_RECORD_CARRIED_COUNT_OFFSET
    farcall $12, UnitRecord_GetByte
    cp d
    jr nc, .reject
    xor a
    jr .done
.reject
    ld a, 1
.done
    pop hl
    pop de
    pop bc
    ret

; Load the active unit into the primary carrier at the staged action target.
; The selected scratch record receives the carried flag and carrier index; the
; carrier's live carried-child count is incremented. The trailing calls are the
; retail presentation/state-update tail and remain conservatively numeric.
Unit_LoadIntoCarrierAtActionTarget::
    push bc
    push de
    push hl
    ld a, [wUnitRecordScratch + UNIT_RECORD_STATUS_OFFSET]
    set UNIT_RECORD_STATUS_CARRIED_F, a
    ld [wUnitRecordScratch + UNIT_RECORD_STATUS_OFFSET], a
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_CopyFromScratch

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    farcall $12, UnitRecord_FindPrimaryAtCoordinates
    ld [wUnitLoadTargetIndex], a

    ld c, UNIT_RECORD_CARRIED_COUNT_OFFSET
    farcall $12, UnitRecord_GetByte
    inc a
    ld b, a
    ld a, [wUnitLoadTargetIndex]
    farcall $12, UnitRecord_SetByte

    ld a, [wUnitLoadTargetIndex]
    ld [wUnitRecordScratch + UNIT_RECORD_CARRIER_INDEX_OFFSET], a
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_CopyFromScratch

    ld a, [wUnitLoadTargetIndex]
    call UnitSelection_RefreshLiveUnitMapPresentation
    ld a, 3
    farcall $0c, UnitAction_PresentActionEffect
    ld a, SFX_TRANSPORT_LOAD
    call Audio_RequestSFX
    ld a, 5
    call $51b5
    pop hl
    pop de
    pop bc
    ret

    assert @ == $5e1e
