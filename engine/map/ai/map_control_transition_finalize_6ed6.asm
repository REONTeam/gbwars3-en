include "macros/macros.inc"

; selected-map transition finalization immediately after the result
; presentation dispatcher. The routine clears the hardware scroll offsets,
; derives a side/result parameter from the staged wMapControlWinningSide/wMapControlResolutionType state plus the
; current map-control configuration, invokes the Bank-$27 two-side result
; presentation service, and conditionally chains into the independently called
; $6F1E family. wMapControlInfraredBattleMode is set by the Versus style frontend; in
; infrared battle mode Yield finalization is handled by the remote-battle path.

section "Map Control Transition Finalization", romx[$6ed6], bank[$0b]

MapControl_FinalizeTransitionResult::
    xor a
    ldh [hSCX], a
    ldh [hSCY], a

    ld a, [wMapControlInfraredBattleMode]
    cp 1
    jr nz, .select_side_parameter

    ld a, [wMapControlResolutionType]
    cp MAP_RESOLUTION_TYPE_YIELD
    jr nz, .select_side_parameter
    ret

.select_side_parameter
    ld a, [wMapSide0Control]
    cp MAP_PLAYER_CONTROL_CPU
    jr z, .use_opposing_side

    ld a, [wActiveGameMode]
    cp GAME_MODE_VS
    jr nz, .use_current_side

    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    jr nz, .use_opposing_side

.use_current_side
    ld a, [wMapControlWinningSide]
    dec a
    ld b, a
    xor a
    jr .apply_result_service

.use_opposing_side
    ld a, [wMapControlWinningSide]
    dec a
    xor 1
    ld b, a
    ld a, 1

.apply_result_service
    farcall $27, MapResult_PresentSideOutcome

    ld a, [wMapControlInfraredBattleMode]
    cp 1
    ret nz

    call MapControl_ShowOpponentCancelPrompt
    ret

    assert @ == $6f1e

; SHA-1 dba28347964205aac5421415561d71a4642201f4 ($6ED6-$6F1D)
