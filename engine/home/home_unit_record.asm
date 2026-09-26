include "macros/macros.inc"
include "constants/unit_constants.inc"

; ROM0 fast-path accessors for the 100 x 16-byte live-unit pool.
; Bank $0D AI code calls these directly to avoid farcalling the Bank $12 API.

section "ROM0 Live Unit Record Accessors", rom0[$090b]

; A = live unit index, C = byte offset. Returns A = selected byte.
UnitRecord_GetByteROM0::
    push bc
    push de
    ld l, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call UnitRecord_GetAddressROM0
    ld b, 0
    add hl, bc
    ld b, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    pop de
    pop bc
    ret

; A = live unit index, C = byte offset. Returns DE = little-endian word.
UnitRecord_GetWordROM0::
    push bc
    ld l, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call UnitRecord_GetAddressROM0
    ld b, 0
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop bc
    ret

; A = live unit index, B = value, C = byte offset.
UnitRecord_SetByteROM0::
    push bc
    push de
    ld l, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call UnitRecord_GetAddressROM0
    ld e, b
    ld b, 0
    add hl, bc
    ld [hl], e
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

; A = live unit index. Returns B = X and C = Y.
UnitRecord_GetCoordinatesROM0::
    push de
    ld l, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call UnitRecord_GetAddressROM0
    ld bc, UNIT_RECORD_X_OFFSET
    add hl, bc
    ld b, [hl]
    inc hl
    ld c, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    ret

; L = live unit index. Returns HL = WRAM-bank-3 record base ($D000 + index * 16).
UnitRecord_GetAddressROM0::
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, $d000
    add hl, de
    ret

    assert @ == $0985
