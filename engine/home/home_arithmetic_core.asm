; Compact ROM0 arithmetic primitives used by map economy, unit setup, battle,
; and network code. These routines preserve the retail register/flag contracts.

section "Multiply HL by 100", rom0[$29ad]
Math_MultiplyHLBy100::
    push de
    add hl, hl
    add hl, hl
    push hl
    add hl, hl
    add hl, hl
    add hl, hl
    push hl
    add hl, hl
    pop de
    add hl, de
    pop de
    add hl, de
    pop de
    ret

    assert @ == $29bc

section "Subtract DE from HL", rom0[$29c3]
Math_SubtractDEFromHL::
    ld a, l
    sub e
    ld l, a
    ld a, h
    sbc d
    ld h, a
    ret

    assert @ == $29ca

; Compare unsigned DE against HL without modifying either pair. Carry is set
; when DE < HL; Z is set and A is cleared when the values are equal. For DE >
; HL, carry and Z are both clear.
section "Compare DE against HL", rom0[$29ca]
Math_CompareHLToDE::
    ld a, d
    cp h
    jr c, .done
    jr nz, .done
    ld a, e
    cp l
    jr c, .done
    jr nz, .done
    xor a
.done
    ret

    assert @ == $29d8

; Signed 16-bit multiply. Zero operands return zero immediately. Otherwise the
; routine converts both inputs to magnitudes, performs a 16-step shift/add
; multiply, then reapplies the XOR of the original signs to HL.
section "Signed multiply HL by DE", rom0[$29d8]
Math_SignedMultiplyHLByDE::
    ld a, h
    or l
    ret z
    ld a, d
    or e
    jr z, Math_ZeroHL

    ld a, h
    xor d
    rlca
    push af

    ld a, d
    rlca
    jr nc, .de_positive
    ld a, d
    cpl
    ld d, a
    ld a, e
    cpl
    ld e, a
    inc de
.de_positive

    ld a, h
    rlca
    jr nc, .hl_positive
    ld a, h
    cpl
    ld h, a
    ld a, l
    cpl
    ld l, a
    inc hl
.hl_positive

    ld b, h
    ld c, l
    ld hl, 0
    ld a, $10
.loop
    add hl, hl
    rl c
    rl b
    jr nc, .no_add
    add hl, de
    jr nc, .no_add
    inc c
    jr nz, .no_add
    inc b
.no_add
    dec a
    jr nz, .loop

    pop af
    ret nc
    ld a, h
    cpl
    ld h, a
    ld a, l
    cpl
    ld l, a
    inc l
    ret nz
    inc h
    ret

    assert @ == $2a1d

section "Zero HL", rom0[$2a1d]
Math_ZeroHL::
    ld hl, 0
    ret

    assert @ == $2a21

; Signed 16-bit division. Input DE is the dividend and BC the divisor. The
; long-division core returns quotient in DE and remainder in BC. When exactly
; one operand was negative, both returned pairs are negated to match retail's
; signed-result convention. No divide-by-zero special case is added here.
section "Divide DE by BC", rom0[$2a21]
Math_DivideDEByBC::
    push hl
    ld hl, wMathDivisionSignState
    ld [hl], $01
    bit 7, b
    call nz, Math_AdjustNegativeBCAndDecrementAtHL
    bit 7, d
    call nz, Math_AdjustNegativeDEAndDecrementAtHL

    ld hl, wMathDivisionDivisor
    ld [hl], c
    inc hl
    ld [hl], b
    inc hl
    ld [hl], $11

    ld bc, 0
    ld hl, wMathDivisionBitCount
.loop
    rl e
    rl d
    dec [hl]
    jr z, .finish
    rl c
    rl b
    dec hl
    dec hl
    ld a, c
    sub [hl]
    ld c, a
    inc hl
    ld a, b
    sbc [hl]
    ld b, a
    jr nc, .subtraction_kept
    dec hl
    ld a, c
    add [hl]
    ld c, a
    inc hl
    ld a, b
    adc [hl]
    ld b, a
    ccf
.subtraction_kept
    jr .loop

.finish
    ld hl, wMathDivisionSignState
    xor a
    cp [hl]
    jr nz, .done
    call Math_NegateBC
    call Math_NegateDE
.done
    pop hl
    ret

    assert @ == $2a70

; Decrement the sign-state byte at HL, then two's-complement BC.
section "Adjust negative BC", rom0[$2a70]
Math_AdjustNegativeBCAndDecrementAtHL::
    dec [hl]
Math_NegateBC::
    ld a, b
    cpl
    ld b, a
    ld a, c
    cpl
    ld c, a
    inc bc
    ret

    assert @ == $2a79

; Decrement the sign-state byte at HL, then two's-complement DE.
section "Adjust negative DE", rom0[$2a79]
Math_AdjustNegativeDEAndDecrementAtHL::
    dec [hl]
Math_NegateDE::
    ld a, d
    cpl
    ld d, a
    ld a, e
    cpl
    ld e, a
    inc de
    ret

    assert @ == $2a82
