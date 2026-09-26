; bounded random helper used by the battle-scene delay table.
; Random_Advance leaves the high byte of the updated 16-bit LCG seed in A.
section "Random Range Zero Through D", rom0[$294b]
Random_ZeroToDInclusive::
    push bc
    ld e, 0
    ld a, d
    sub e
    ld b, a
    call Random_Advance
.reduce
    cp b
    jr c, .done
    jr z, .done
    sub b
    dec a
    jr .reduce
.done
    add e
    pop bc
    ret

    assert @ == $2960
