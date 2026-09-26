include "macros/macros.inc"

; close the compact Bank $19 runtime gap between the preserved
; Network registration message and the earlier Shift-JIS profile callers.
; Labels remain contract-oriented until later UI/state consumers prove stronger names.

section "Bank19 Network Runtime 56A2", romx[$56a2], bank[$19]
NetworkRuntime_56A2::
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call $5550
    ld a, $02
    call $3816
    call $081d
NetworkRuntime_56B6:
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 6, a
    jr z, $56d7
    ld a, $01
    call $3844
    ld a, [$cbdf]
    dec a
    cp $ff
    jr nz, $56cf
    ld a, $02
    ld [$cbdf], a
    call $5538
    jr $56b6
    bit 7, a
    jr z, $56f1
    ld a, $01
    call $3844
    ld a, [$cbdf]
    inc a
    cp $03
    jr nz, $56e9
    xor a
    ld [$cbdf], a
    call $5538
    jr $56b6
    bit 0, a
    jr z, $570d
    ld a, [$da32]
    farcall SpriteTransition_SlideRightOffscreen
    ld a, [$cbdf]
    jp $5729
    db $3e, $03, $cd, $44, $38, $ef, $31, $4f, $55, $18, $19
    bit 1, a
    jr z, $571a
    ld a, $0c
    call $3844
    ld a, $ff
    jr $5729
    bit 2, a
    jr z, $5720
    jr $5726
    bit 3, a
    jr z, $5726
    jr $5726
    jp $56b6
NetworkRuntime_5729:
    push af
    call $07b4
    call $2e67
    pop af
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    ret
NetworkRuntime_5739::
    ld a, [$cbe0]
    ld b, $10
    call $2995
    ld a, l
    add a, $34
    ld c, a
    ld b, $14
    ld a, [$da41]
    call $2eae
    ret
    assert @ == $574e
