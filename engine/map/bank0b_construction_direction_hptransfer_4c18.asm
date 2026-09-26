include "macros/macros.inc"
include "constants/unit_constants.inc"

; closes Bank $0B:$4C18-$4DF1 between the Construction bridge
; executor and the Unit HP-transfer runtime. The first half is the shared
; Construction terrain-action direction picker used by RUNWAY/CLEAR/BRIDGE. The $4D3A+
; family is the adjacent-unit eligibility/list path used by UnitHPTransfer_Run.
; $C948/$C949 are lifetime-scoped candidate count/list scratch shared with
; other map-action subsystems.

DEF wUnitActionCandidateCount EQU $c948
DEF wUnitActionCandidateList  EQU $c949
DEF wConstructionActionSelectionIndex EQU $c940
DEF wConstructionActionPulseTimer EQU $c9a5
DEF wConstructionActionPreviewTileId EQU $c9a6
DEF wMapInteractionInputState EQU $ca91

section "Bank $0B Construction direction and HP-transfer helpers", romx[$4c18], bank[$0b]

Construction_SelectTerrainActionDirection::
    ; Select one entry from the direction list built by the RUNWAY/CLEAR/BRIDGE
    ; candidate builders. B/C initially identify the Construction Truck. The
    ; helper moves the shared map cursor among candidates, blinks the preview
    ; tile, and returns A=0 on confirm or $FF on cancel. On confirm B/C are the
    ; selected target coordinates used by the action executor.
    push de
    ldh a, [hWRAMBank]
    push af
    ld a, $05
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    call Construction_GetSelectedDirectionCoordinates
    call MapCursor_SetMapCoordinates
    call MapCursor_Show
    call Construction_RedrawSelectedDirectionCell

.input_loop
    call MapControl_UpdateInteractionInputState
    call Construction_UpdateDirectionSelectionPulse
    ld a, [wMapInteractionInputState]
    bit 0, a
    jr nz, .confirm
    bit 1, a
    jr nz, .cancel
    bit 5, a
    jr nz, .previous
    bit 6, a
    jr nz, .previous
    bit 4, a
    jr nz, .next
    bit 7, a
    jr nz, .next
    jr .input_loop

.confirm
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call Construction_RefreshSelectedDirectionCell
    ld a, SFX_CONFIRM
    call Audio_PlaySFX
    call Construction_GetSelectedDirectionCoordinates
    xor a
    jr Construction_FinishTerrainActionDirectionSelection

.cancel
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call Construction_RefreshSelectedDirectionCell
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr Construction_FinishTerrainActionDirectionSelection

.previous
    ld a, [wConstructionActionSelectionIndex]
    dec a
    cp $ff
    jr nz, .store_selection
    ld a, [wUnitActionCandidateCount]
    dec a
    jr .store_selection

.next
    ld a, [wUnitActionCandidateCount]
    ld h, a
    ld a, [wConstructionActionSelectionIndex]
    inc a
    cp h
    jr nz, .store_selection
    xor a

.store_selection
    ld [wConstructionActionSelectionIndex], a
    ld a, SFX_CURSOR_MOVE
    call Audio_PlaySFX
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call Construction_RefreshSelectedDirectionCell
    call Construction_GetSelectedDirectionCoordinates
    call MapCursor_SetMapCoordinates
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call Construction_RedrawSelectedDirectionCell
    jp .input_loop

; Restore the cursor to the Construction Truck's own coordinates while
; preserving the selector result in A. This entry is also used by confirm to
; perform the same presentation teardown before bank restoration.
Construction_FinishTerrainActionDirectionSelection::
    push bc
    push af
    ld a, [wUnitRecordScratch + UNIT_RECORD_X_OFFSET]
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_Y_OFFSET]
    ld c, a
    call MapCursor_SetMapCoordinates
    pop af
    pop bc
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    pop de
    ret

Construction_GetSelectedDirectionCoordinates::
    push de
    push hl
    ld a, [wUnitRecordScratch + UNIT_RECORD_X_OFFSET]
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_Y_OFFSET]
    ld c, a
    ld a, [wConstructionActionSelectionIndex]
    ld hl, wUnitActionCandidateList
    call AddAtoHL
    ld a, [hl]
    cp $06
    jr z, .done
    ld e, a
    call HexGrid_GetNeighborCoord
.done
    pop hl
    pop de
    ret

Construction_UpdateDirectionSelectionPulse::
    ld a, [wConstructionActionPulseTimer]
    inc a
    ld [wConstructionActionPulseTimer], a
    cp $0a
    jr z, .show_underlying_cell
    cp $14
    jr nz, .done
    call Construction_RedrawSelectedDirectionCell
    jr .done
.show_underlying_cell
    call Construction_RefreshSelectedDirectionCell
.done
    ret

Construction_RedrawSelectedDirectionCell::
    xor a
    ld [wConstructionActionPulseTimer], a
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, [wConstructionActionPreviewTileId]
    farcall $0b, Bank0B_MapSetup_444D
    ret

Construction_RefreshSelectedDirectionCell::
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    farcall $0b, Bank0B_MapSetup_43D1
    ret

UnitAction_AwardCurrentHPAsExperience::
    ; FORTIFY and BUILD award the acting unit experience equal to its current
    ; HP after the action is finalized.
    ld a, [wUnitRecordScratch + UNIT_RECORD_HP_OFFSET]
    ld l, a
    ld h, $00
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_AddExperienceClamped
    ret

UnitHPTransfer_HasEligibleAdjacentTarget::
    ; Units currently carrying another unit cannot use HP transfer.
    push bc
    push de
    push hl
    ld a, [wUnitRecordScratch + UNIT_RECORD_CARRIED_COUNT_OFFSET]
    and a
    jr nz, .unavailable

    ; Bank $18:$4ADD rejects unit-type classes that cannot participate in
    ; this action. It expects the type index rather than the encoded
    ; type/side byte.
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    srl a
    farcall $18, BattleScene_ClassifyMapTileBinary
    and a
    jr nz, .unavailable

    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    call UnitHPTransfer_BuildEligibleAdjacentTargetList
    and a
    jr z, .unavailable
    xor a
    jr .done

.unavailable
    ld a, $01
.done
    pop hl
    pop de
    pop bc
    ret

UnitHPTransfer_BuildEligibleAdjacentTargetList::
    ; A = encoded source unit type/side. Build a list of adjacent unit IDs
    ; that match it, are not being carried, and whose HP plus the source HP
    ; remains below 20.
    push bc
    push de
    push hl
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, $05
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld e, $00
    xor a
    ld [wUnitActionCandidateCount], a

.direction_loop
    push bc
    push de
    call HexGrid_GetNeighborCoord
    jr c, .next_direction
    call UnitHPTransfer_GetAdjacentUnitCandidate
    cp $ff
    jr z, .next_direction
    cp d
    jr nz, .next_direction

    ; Candidate record offset 5 must be zero (not carrying a child unit).
    push hl
    push bc
    ld a, l
    ld c, UNIT_RECORD_CARRIED_COUNT_OFFSET
    farcall $12, UnitRecord_GetByte
    and a
    pop bc
    pop hl
    jr nz, .next_direction

    ld a, l
    call UnitHPTransfer_IsCombinedHPBelowLimit
    jr z, .next_direction

    push bc
    ld b, l
    ld a, [wUnitActionCandidateCount]
    ld hl, wUnitActionCandidateList
    call AddAtoHL
    ld [hl], b
    pop bc
    ld hl, wUnitActionCandidateCount
    inc [hl]

.next_direction
    pop de
    pop bc
    inc e
    ld a, e
    cp $06
    jr nz, .direction_loop

    ld a, [wUnitActionCandidateCount]
    ld b, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    pop hl
    pop de
    pop bc
    ret

UnitHPTransfer_GetAdjacentUnitCandidate::
    ; B/C = adjacent coordinates. Bank $12:$414E resolves the live unit at
    ; those coordinates and returns $FF when no eligible record is present.
    ; Return A = encoded type/side and L = record index, while excluding the
    ; currently active unit.
    push bc
    push de
    farcall $12, UnitRecord_FindPrimaryAtCoordinates
    cp $ff
    jr z, .none
    ld c, a
    ld a, [wMapAIActiveUnitIndex]
    cp c
    jr z, .none
    ld a, c
    ld l, a
    push hl
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    pop hl
    jr .done
.none
    ld a, $ff
.done
    pop de
    pop bc
    ret

UnitHPTransfer_IsCombinedHPBelowLimit::
    ; A = candidate unit index. Returns NZ only when candidate HP + staged
    ; source HP is strictly below 20; equality with 20 is rejected.
    push bc
    ld c, UNIT_RECORD_HP_OFFSET
    farcall $12, UnitRecord_GetByte
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_HP_OFFSET]
    add a, b
    cp $14
    pop bc
    ret

    assert @ == $4df2
