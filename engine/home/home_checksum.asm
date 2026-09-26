include "macros/macros.inc"

; Sum DE bytes beginning at HL. Returns the 16-bit additive checksum in BC
; while preserving the caller's HL and DE.
section "16-bit Additive Checksum", rom0[$39c7]
Checksum16::
    push de
    push hl
    ld bc, $0000
.loop
    ld a, [hl+]
    add c
    ld c, a
    ld a, b
    adc $00
    ld b, a
    dec de
    ld a, e
    or d
    jr nz, .loop
    pop hl
    pop de
    ret

    assert @ == $39db
