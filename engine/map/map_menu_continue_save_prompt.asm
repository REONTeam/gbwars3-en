include "macros/macros.inc"

; Saved-data continuation prompt controller.
; Reuses the existing MapMenu_Suspend presentation, runs the two-choice input
; loop, and returns 0/1 for the selected choice or $FF on B/cancel.
section "MapMenu Continue Save Prompt", romx[$54c0], bank[$13]
MapMenu_RunContinueFromSavePrompt::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    call $5400
    call $081d
.loop
    call $05a2
    call $3056
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    bit 5, a
    jr z, .check_right

    ld a, $01
    call $3844
    xor a
    ld [$dc4f], a
    ld bc, $070b
    call $53ae
    jr .redraw

.check_right
    bit 4, a
    jr z, .check_confirm

    ld a, $01
    call $3844
    ld a, $01
    ld [$dc4f], a
    ld bc, $070b
    call $53d7
    jr .redraw

.check_confirm
    bit 0, a
    jr z, .check_cancel

    ld a, [$dc4f]
    cp $00
    jr nz, .confirm_second
    ld a, $02
    call $3844
    ld a, $00
    jr .finish

.confirm_second
    ld a, $0c
    call $3844
    ld a, $01
    jr .finish

.check_cancel
    bit 1, a
    jr z, .redraw
    ld a, $0c
    call $3844
    ld a, $ff
    jr .finish

.redraw
    jr .loop

.finish
    ld b, a
    push bc
    call $07b4
    pop bc
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, b
    ret

    assert @ == $5541
