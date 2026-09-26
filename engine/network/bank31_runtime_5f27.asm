include "macros/macros.inc"

; Bank $31 continuation from the externally reached $5F27 entry.
; $5F27 stores the caller's index and 16-bit value in shared scratch, performs
; three threshold-style tests through the existing ROM0 arithmetic helper,
; then indexes one of two 13-byte value tables.  The exact higher-level field
; remains intentionally neutral until the ROM0 $2A21 helper and Bank $19
; callers are source-backed.  $609C is the next independently farcalled entry.

section "Bank31 Indexed Range Value Selector", romx[$5f27], bank[$31]
Bank31_SelectIndexedRangeValue_5F27::
    ld [$cad7], a
    ld a, h
    ld [$cad5], a
    ld a, l
    ld [$cad6], a
    ld a, [$cad5]
    ld d, a
    ld a, [$cad6]
    ld e, a
    ld bc, $0004
    call $2a21
    call $5f12
    jr c, $5f6e
    ld a, [$cad5]
    ld d, a
    ld a, [$cad6]
    ld e, a
    ld bc, $0064
    call $2a21
    call $5f12
    jr c, $5f74
    ld a, [$cad5]
    ld d, a
    ld a, [$cad6]
    ld e, a
    ld bc, $0190
    call $2a21
    call $5f12
    jr nc, $5f74
    jr $5f6e
    ret
    ld hl, $5f82
    jr $5f7a
    ret
    ld hl, $5f8f
    jr $5f7a
    ret
    ld a, [$cad7]
    call $29bc
    ld a, [hl]
    ret
Bank31_RangeValueTableA_5F82::
    db $00, $1f, $1c, $1f, $1e, $1f, $1e, $1f, $1f, $1e, $1f, $1e, $1f
Bank31_RangeValueTableB_5F8F::
    db $00, $1f, $1d, $1f, $1e, $1f, $1e, $1f, $1f, $1e, $1f, $1e, $1f
    assert @ == $5f9c

section "Bank31 Runtime Setup 5F9C", romx[$5f9c], bank[$31]
Bank31_RuntimeSetup_5F9C::
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba3c]
    ld h, a
    ld a, [$ba3d]
    ld l, a
    call $059b
    ld de, $0000
    call $29ca
    jr z, $600d
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba3e]
    ld h, a
    ld a, [$ba3f]
    ld l, a
    inc hl
    ld d, h
    ld [$cac6], a
    ld e, l
    ld [$cac7], a
    call $059b
    ld bc, $0005
    call $2a21
    ld h, b
    ld l, c
    ld de, $0000
    call $29ca
    jr z, $5fe5
    jr $600d
    ld a, $02
    call $609c
    ld de, $6b36
    ld b, $05
    ld c, $02
    ld a, $3e
    ld [$c026], a
    ld a, $08
    ld [$caae], a
    ld a, $01
    ld [$caaf], a
    farcall BANK_31, Bank31_Entry_6EAA
    ld a, [$cacc]
    inc a
    ld [$cacc], a
    xor a
    ret
    scf
    ret
    assert @ == $600f

section "Bank31 Runtime Setup 600F", romx[$600f], bank[$31]
Bank31_RuntimeSetup_600F::
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba3c]
    ld h, a
    ld a, [$ba3d]
    ld l, a
    call $059b
    ld de, $0000
    call $29ca
    jr z, $6052
    ld a, $01
    call $609c
    ld de, $6b36
    ld b, $05
    ld c, $01
    ld a, $3e
    ld [$c026], a
    ld a, $09
    ld [$caae], a
    ld a, $01
    ld [$caaf], a
    farcall BANK_31, Bank31_Entry_6EAA
    ld a, [$cacc]
    inc a
    ld [$cacc], a
    xor a
    ret
    scf
    ret
    assert @ == $6054

section "Bank31 Runtime Validation 6054", romx[$6054], bank[$31]
Bank31_RuntimeValidation_6054::
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba3c]
    ld h, a
    ld a, [$ba3d]
    ld l, a
    ld de, $0000
    call $29ca
    jr z, $6097
    ld a, [$ba3e]
    cp $00
    jr nz, $6097
    ld a, [$ba3f]
    inc a
    call $60bc
    cp $ff
    jr z, $6097
    call $059b
    push bc
    push hl
    push de
    call $609c
    pop de
    pop hl
    pop bc
    farcall BANK_31, Bank31_Entry_6E92
    ld a, [$cacc]
    inc a
    ld [$cacc], a
    xor a
    ret
    call $059b
    scf
    ret
    assert @ == $609c
