include "macros/macros.inc"

; initialize the compact map-control force-state mode from the
; active game mode. Beginner and Campaign use dedicated modes 1 and 2;
; every other gameplay mode uses the shared mode 3.
;
; Bank $0D:$6776 consumes wMapControlForceStateMode as the controlling mode
; for the force-state indicator. $6D18 is the next independently farcalled
; Bank-$0B entry and remains a separate owner.

section "Map Control Force State Mode", romx[$6cfd], bank[$0b]

MapControl_StageForceStateModeFromGameMode::
    ld a, [wActiveGameMode]
    cp GAME_MODE_BEGINNER
    jr z, .beginner
    cp GAME_MODE_CAMPAIGN
    jr z, .campaign
    jr .other

.beginner
    ld a, 1
    jr .store

.campaign
    ld a, 2
    jr .store

.other
    ld a, 3

.store
    ld [wMapControlForceStateMode], a
    ret

    assert @ == $6d18
