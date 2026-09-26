include "macros/macros.inc"

; Selected-map END command pre-transition state. The coordinate pair at
; $C993-$C996 is lifetime-scoped here as one B/C pair per side; other map-result
; code reuses the same bytes for HQ-coordinate staging at a different lifetime.
DEF wEndCommandSideCursorCoordinates EQU $c993
DEF wEndCommandTransitionStarted     EQU $ca97

section "Selected Map End Command Preparation", romx[$72b4], bank[$0c]

MapControl_PrepareSelectedMapEndCommand::
    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    add a, a
    ld hl, wEndCommandSideCursorCoordinates
    call AddAtoHL
    ld a, [wMapActionTargetX]
    ld [hli], a
    ld a, [wMapActionTargetY]
    ld [hl], a

    ld a, [wEndCommandTransitionStarted]
    and a
    jp nz, .play_transition_audio
    ld a, 1
    ld [wEndCommandTransitionStarted], a
.play_transition_audio
    xor a
    call Audio_PlayMusic
    ld a, SFX_END_TURN
    call Audio_PlaySFX
    ret

    assert @ == $72de
