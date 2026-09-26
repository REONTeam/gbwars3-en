include "macros/macros.inc"

; selected-map result/transition presentation dispatcher.
; Called from the controller's exit/transition path after result state has been
; staged in wMapControlWinningSide/wMapControlResolutionType. The three mode-specific result presentations are now source-backed in Bank $1A.

section "Map Control Result Transition Presentation", romx[$6e6e], bank[$0b]

MapControl_PresentTransitionResult::
    ld a, [wActiveGameMode]
    cp GAME_MODE_BEGINNER
    jr z, .beginner

    ld a, [wMapControlResolutionType]
    cp MAP_RESOLUTION_TYPE_HQ_LOSS
    jr z, .hq_loss
    cp MAP_RESOLUTION_TYPE_FORCE_DEFEAT
    jr z, .force_defeat
    cp MAP_RESOLUTION_TYPE_TURN_LIMIT
    jr z, .turn_limit
    cp MAP_RESOLUTION_TYPE_YIELD
    jr .yield_or_common
    jr .done

.beginner
    call FadeToWhite8
    jr .done

.hq_loss
    ld a, $3c
    call AdvanceFrames
    call FadeToWhite8
    ld a, [$c685]
    bit 2, a
    jr nz, .done
    ld a, [wMapControlWinningSide]
    dec a
    xor 1
    farcall $1a, MapResult_PresentHQLoss
    jr .done

.force_defeat
    ld a, $3c
    call AdvanceFrames
    call FadeToWhite8
    ld a, [wMapControlWinningSide]
    dec a
    farcall $1a, MapResult_PresentForceDefeat
    jr .done

.turn_limit
    ld a, $3c
    call AdvanceFrames
    call FadeToWhite8

.yield_or_common
    ld a, [wMapControlInfraredBattleMode]
    cp 1
    jr z, .beginner
    ld a, [wMapControlWinningSide]
    dec a
    xor 1
    farcall $1a, MapResult_PresentTurnLimitOrYield

.done
    ret

    assert @ == $6ed6

; SHA-1 6312de9ec291f4639697b5748e2f9b9497ce6399 ($6E6E-$6ED5)
