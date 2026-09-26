include "macros/macros.inc"
include "constants/unit_constants.inc"

; Map-phase advance helper plus the connected selected-map CALL command.
; The CALL path uses the fixed mercenary list, enforces the retail 50-unit
; side cap, stages the chosen encoded type/side for Bank $1A placement, then
; creates/marks the resulting unit and refreshes map state.
; $74FA is independently reused by five callers and remains the next hard
; ownership boundary.

DEF wSelectedMapCallEncodedTypeSide EQU $c940
DEF wSelectedMapCallSideScratch     EQU $c4a0
DEF wSelectedMapCallTypeScratch     EQU $c4a1
DEF wMapPhaseAdvanceScratch         EQU $c997

section "Map Phase And CALL Command", romx[$746d], bank[$0b]

MapControl_AdvanceMapPhase::
    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    farcall $12, Unit_ClearEndTurnFlagsForSide
    call $428a
    ld a, $00
    ld [wMapPhaseAdvanceScratch], a
    ld a, [wMapPhaseNumber]
    inc a
    ld [wMapPhaseNumber], a
    ret

; CALL: select one entry from the fixed mercenary/special unit list, then hand
; the encoded type/side to the Bank-$1A placement flow. Cancel/failure returns
; without altering the phase. Successful creation increments the built counter,
; creates the record, marks it ended, and records the Campaign procurement
; bookkeeping exactly as retail does.
MapControl_ExecuteSelectedMapCommandCall::
MapControl_ExecuteSelectedMapCommand07:: ; compatibility alias
    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    ld hl, wUnitCountBySide
    call AddAtoHL
    ld a, [hl]
    cp UNITS_PER_SIDE
    jr z, .unit_limit_reached

    call UnitCreation_RunAlternateSelectionController
    cp $ff
    jr z, MapControl_CommandErrorSFX74F4.done
    ld [wSelectedMapCallEncodedTypeSide], a

    call MapTerrainAnimation_Reset
    ld a, [wSelectedMapCallEncodedTypeSide]
    srl a
    ld [wSelectedMapCallTypeScratch], a
    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    ld [wSelectedMapCallSideScratch], a
    call FadeToWhite8

    farcall $1a, MapCall_RunPresentationSequence8
    push af
    farcall $0b, MapControl_ReinitializeAfterResolution
    pop af
    and a
    jr nz, MapControl_CommandErrorSFX74F4.done

    ld bc, $0000
    ld a, [wSelectedMapCallEncodedTypeSide]
    farcall $12, Unit_IncrementBuiltCountForEncodedSide
    farcall $12, MapUnit_CreateInitial
    push af
    farcall $12, Unit_SetEndTurnFlag
    ld a, [wSelectedMapCallEncodedTypeSide]
    farcall $11, CampaignStats_MarkProcuredUnit
    farcall $11, CampaignStats_SetProcuredFlag35
    pop af
    farcall UnitDeployment_RunCalledUnitPlacementController
    jr MapControl_CommandErrorSFX74F4.done

.unit_limit_reached
    ld a, SFX_ERROR
    call Audio_PlaySFX
    ld a, $14
    call $51cd
    jr MapControl_CommandErrorSFX74F4.done

; No direct retail caller has been established for this five-byte tail entry;
; preserve it as an address-oriented helper rather than assigning UI semantics.
MapControl_CommandErrorSFX74F4::
    ld a, SFX_ERROR
    call Audio_PlaySFX

.done
    ret

    assert @ == $74fa

; SHA-1 d4efc78656d877b2afa9371b861b79ba7cd466ad ($746D-$74F9)
