include "macros/macros.inc"

; CALL-command presentation wrapper. The caller stages the selected unit type and
; side before entering here. This wrapper runs presentation sequence 8 and
; normalizes its return value to 0, 1, or $ff while preserving the caller's WRAM
; bank. Holding joypad bit 2 forces the zero-result path used by the retail flow.
DEF wMapCallPresentationForceZero EQU $c4a6

section "Map CALL Presentation Wrapper", romx[$4000], bank[$1a]

MapCall_RunPresentationSequence8::
    call DelayFrame
    call Joypad_Read
    ldh a, [hJoyHeld]
    bit 2, a
    jr nz, .force_zero_mode
    xor a
    ld [wMapCallPresentationForceZero], a
    jr .mode_staged

.force_zero_mode
    ld a, 1
    ld [wMapCallPresentationForceZero], a

.mode_staged
    ldh a, [hWRAMBank]
    push af
    ld a, 4
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    farcall $17, AdvancedSprite_Reset
    farcall $27, Presentation_ResetDisplayState
    call PresentationSequence_8
    ld d, a
    ld a, [wMapCallPresentationForceZero]
    cp 1
    jr z, .return_zero
    ld a, d
    cp $ff
    jr z, .return_ff
    cp 0
    jr z, .return_zero
    jr .return_one

.return_zero
    xor a
    ld d, a
.restore_and_return
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret

.return_one
    ld a, 1
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret

.return_ff
    ld a, $ff
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret

    assert @ == $405b
