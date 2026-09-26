include "macros/macros.inc"

; source the two caller-backed Bank-$0B entries immediately after the
; force-state mode initializer. $6D18 is a compact standalone state initializer;
; $6D1E is the shared post-AI-action map-control update used by both the Bank-$0D
; AI dispatcher and ROM0 map-control flow. $6D69 is independently reached and is
; deliberately left outside this owner until its own contract is established.

section "Map Control Post-Action Update", romx[$6d18], bank[$0b]

Bank0B_Helper6D18::
    ld a, $3d
    ld [$c685], a
    ret

    assert @ == $6d1e

MapControl_PostAIActionUpdate::
    push bc
    call .test_update_condition
    jr z, .done

    ld a, [wActiveGameMode]
    cp GAME_MODE_BEGINNER
    jr z, .beginner_mode

    ld a, [wMapSide0HQTileCount]
    and a
    jr z, .side1_wins_hq_loss

    ld a, [wMapSide1HQTileCount]
    and a
    jr z, .side0_wins_hq_loss

    call MapControl_PostDirectAttackUpdate
    jr .done

.beginner_mode
    call MapControl_CheckBeginnerScenarioCompletion
    and a
    jr nz, .beginner_side0_completion
    jr .done

.side1_wins_hq_loss
    ld a, 2
    ld b, MAP_RESOLUTION_TYPE_HQ_LOSS
    jr .store_resolution

.side0_wins_hq_loss
    ld a, 1
    ld b, MAP_RESOLUTION_TYPE_HQ_LOSS
    jr .store_resolution

.beginner_side0_completion
    ld b, MAP_RESOLUTION_TYPE_FORCE_DEFEAT
    jr .store_resolution

.store_resolution
    ld [wMapControlWinningSide], a
    ld a, b
    ld [wMapControlResolutionType], a

.done
    pop bc
    ret

.test_update_condition
    ld a, [wMapControlInfraredBattleMode]
    cp 1
    ret nz
    ld a, [$c9b5]
    cp 1
    ret

    assert @ == $6d69

; SHA-1 $28b37644e80cbc0f5e05c9c00dfe7d075b31ea77 ($6D18-$6D68)
