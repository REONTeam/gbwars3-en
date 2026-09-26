include "macros/macros.inc"

; Reset the WRAM7 scratch owned by the Bank $26 attract/presentation runtime.
section "Bank 26 Runtime State Reset", romx[$549a], bank[$26]
Bank26_ResetRuntimeState::
    ldh a, [hWRAMBank]
    push af
    ld a, $07
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$cbdf], a
    ld [$cbe0], a
    ld [$cbe1], a
    ld [$cbe2], a
    ld [$cbe3], a
    ld [$cbe4], a
    ld [$cbe5], a
    ld [$cbe6], a
    ld [$cc25], a
    ld [$cc26], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

    assert @ == $54c8
