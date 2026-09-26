include "macros/macros.inc"

section "Bank14 Divide A by B", romx[$5f1b], bank[$14]

; Divide unsigned A by unsigned B using repeated subtraction.
; Returns quotient in B and remainder in A. DE is preserved.
Math_DivideAByB::
    push de
    ld d, $00
    jp .subtract
.quotient_step
    inc d
.subtract
    sub b
    jr nc, .quotient_step
    add b
    ld b, d
    pop de
    ret

    assert @ == $5f29
