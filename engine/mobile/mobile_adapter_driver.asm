include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"

; Mobile Adapter GB library front-end in physical Bank $30.
; The ROM0 fixed-bank API writes the even request type to $D188 and enters
; MobileAdapter_DriverDispatch. The dispatcher uses that value directly as a
; byte offset into the word-address table at $4070.

section "Mobile Adapter Driver Frontend", romx[$4000], bank[$30]
MobileAdapter_CopyBBytes::
    ld a, [hli]
    ld [de], a
    inc de
    dec b
    jr nz, $4000
    ret
MobileAdapter_CopyUntilZero::
    ld a, [hli]
    ld [de], a
    or a
    ret z
    inc de
    inc bc
    jr $4007
MobileAdapter_CopyBoundedAndAdvanceBC::
    push bc
    ld c, $00
    ld b, a
    dec b
    ld a, [hli]
    ld [de], a
    or a
    jr z, $4020
    inc de
    inc c
    dec b
    jr nz, $4014
    xor a
    ld [de], a
    ld a, c
    pop bc
    add a, c
    ld c, a
    ld a, b
    adc a, $00
    ld b, a
    ret
MobileAdapter_ClearD23AWord::
    xor a
    ld hl, $d23a
    ld [hli], a
    ld [hl], a
    ret
MobileAdapter_DriverDispatch::
    push de
    ld a, [$d188]
    cp $0c
    jr z, $4047
    cp $0e
    jr z, $4047
    cp $10
    jr z, $4047
    xor a
    ld [$d035], a
    ld a, [$d188]
    ld d, $00
    ld e, a
    ld hl, $4070
    add hl, de
    ld a, [hli]
    ld [$d188], a
    ld a, [hl]
    pop de
    ld hl, $3e35
    push hl
    ld h, a
    ld a, [$d188]
    ld l, a
    push hl
    ld a, $35
    cp l
    jr nz, $4066
    ld a, $42
    cp h
    call nz, $40b4
    ld hl, $d186
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ret
MobileAdapter_DriverRequestHandlers::
    dec d
    ld b, c
    dec [hl]
    ld b, d
    sub b
    ld b, d
    xor e
    ld b, e
    scf
    ld b, h
    push bc
    ld b, h
    ld [hl], a
    ld b, l
    add a, c
    ld b, l
    adc a, e
    ld b, l
    call c, $ee45
    ld b, [hl]
    ld d, [hl]
    ld b, a
    cp $47
    sbc a, b
    ld c, b
    and d
    ld c, b
    inc b
    ld c, c
    and e
    ld c, c
    ld hl, sp + 73
    ld e, d
    ld c, d
    dec sp
    ld c, h
    sbc a, l
    ld c, h
    call c, $fd4d
    ld d, c
    dec b
    ld d, h
    call c, $4440
    ld d, l
    sbc a, c
    ld d, l
    inc [hl]
    ld d, [hl]
    dec hl
    ld b, e
    adc a, a
    ld d, h
    rla
    ld d, [hl]
    xor e
    ld b, e
    inc [hl]
    ld b, d
    ld b, e
    ld d, l
MobileAdapter_PrepareRequestChannel::
    push bc
    di
    ld a, [$d000]
    ld b, a
    ld a, [$d00b]
    ld c, a
    ld a, [$d022]
    ei
    or a
    bit 0, a
    jr z, $40da
    ld a, b
    or a
    jr nz, $40b5
    ld a, c
    cp $04
    jr z, $40b5
    xor a
    ld [$d00f], a
    ld hl, $d021
    set 1, [hl]
    scf
    pop bc
    ret
MobileAdapter_RequestHandler30::
    xor a
    ldh [$ff07], a
    ld e, c
    ld b, a
    ld hl, $6089
    add hl, bc
    ld c, [hl]
    inc hl
    ldh a, [$ff4d]
    bit 7, a
    jr nz, $40f9
    ld a, e
    sra c
    ld a, e
    cp $04
    jr nc, $40f9
    ld de, $000f
    add hl, de
    ld a, c
    ldh [$ff06], a
    ldh [$ff05], a
    ld a, [hli]
    ld [$d01f], a
    ld [$d016], a
    ld a, [hl]
    ld [$d020], a
    ld [$d015], a
    ld c, $07
    ld a, $02
    ldh [c], a
    ld a, $06
    ldh [c], a
    ret
    assert @ == $4115
