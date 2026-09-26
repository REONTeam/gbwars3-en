include "macros/macros.inc"

; check whether the selected map has reached its terminal phase/day
; limit. VS mode has no limit here. Beginner/Campaign retrieve a map-specific
; limit through Bank $28; other modes use 99 days. A reached limit stages the
; existing map-control transition pair at wMapControlWinningSide/wMapControlResolutionType and returns 1; otherwise
; it returns 0. $6DFC is an independently called next entry and is not absorbed.

section "Map Control Turn Limit Check", romx[$6d9a], bank[$0b]

MapControl_CheckTurnLimitTransition::
    ld a, [wActiveGameMode]
    cp GAME_MODE_VS
    jr z, .no_transition
    cp GAME_MODE_CAMPAIGN
    jr z, .campaign_limit
    cp GAME_MODE_BEGINNER
    jr z, .beginner_limit

    ; Standard, Map Editor, and Attraction use the common 99-day cap.
    ld a, $63
    jr .have_day_limit

.beginner_limit
    ld a, [$c883]
    farcall MapRuntime_GetBeginnerDayLimit
    jr .have_day_limit

.campaign_limit
    ld a, [$c883]
    farcall MapRuntime_GetCampaignDayLimit

.have_day_limit
    ; Convert the one-based day limit to the zero-based phase for side 1.
    ; The active side/control arrangement below selects the neighboring phase
    ; when required.
    add a
    dec a
    ld b, a

    ld a, [wMapSide0Control]
    and a
    jr nz, .check_next_phase

    ld a, [wMapPhaseNumber]
    cp b
    jr z, .stage_side1_win

.check_next_phase
    inc b
    ld a, [wMapPhaseNumber]
    cp b
    jr z, .stage_side0_win
    jr .no_transition

.stage_side0_win
    ld a, 1
    ld b, MAP_RESOLUTION_TYPE_TURN_LIMIT
    jr .stage_resolution

.stage_side1_win
    ld a, 2
    ld b, MAP_RESOLUTION_TYPE_TURN_LIMIT

.stage_resolution
    ld [wMapControlWinningSide], a
    ld a, b
    ld [wMapControlResolutionType], a
    ld a, 1
    jr .normalize_99_day_phase

.no_transition
    xor a
    ; Keep the retail zero-distance branch: it is part of the exact byte stream.
    jr .normalize_99_day_phase

.normalize_99_day_phase
    push af
    ld a, [wMapPhaseNumber]
    cp $c6
    jr nz, .restore_result
    ld a, $c4
    ld [wMapPhaseNumber], a

.restore_result
    pop af
    ret

    assert @ == $6dfc

; SHA-1 $2b13e8c876c02758b7153279ffe1c1ed3e1474f9 ($6D9A-$6DFB)
