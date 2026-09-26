include "macros/macros.inc"

; exported Mobile Adapter serial interrupt core in physical Bank $30.
; This span begins at the fixed-bank ABI target $56CC and ends exactly before
; the independently exported LCD/timer-service entry at $58E4.

section "Mobile Adapter Serial Service", romx[$56cc], bank[$30]
MobileAdapter_DriverSerialInterrupt::
    ld a, [$d000]
    rrca
    jp nc, $58c2
    rrca
    jp c, $57ee
    ld hl, $d001
    ld a, [hli]
    ld d, [hl]
    ld e, a
    dec de
    ld a, d
    ld [hld], a
    ld a, e
    ld [hl], a
    cp $02
    jp nc, $58c2
    ld a, d
    or a
    jp nz, $58c2
    ld hl, $d008
    add hl, de
    ldh a, [$ff01]
    ld [hl], a
    ld a, $08
    cp l
    jp nz, $58c2
    ld a, [$d01e]
    cp $ff
    jr z, $571d
    ld a, $f2
    cp [hl]
    jp z, $579d
    dec a
    cp [hl]
    jp z, $57a7
    dec a
    cp [hl]
    jp z, $57a7
    ld a, [$d007]
    cp $01
    jr nz, $571d
    ld a, [$d006]
    or a
    jr z, $577f
    ld a, [$d01e]
    cp $ff
    jr z, $5737
    cp $ee
    jr z, $572e
    cp $9f
    jr nz, $572e
    ld a, $95
    cp [hl]
    jr nz, $57a1
    ld a, [$d018]
    or a
    jr z, $5737
    xor a
    ld [$d019], a
    ld a, $03
    ld [$d000], a
    xor a
    ld hl, $d00a
    ld [hli], a
    ld [hli], a
    ld [hli], a
    ld hl, $d01f
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld hl, $d015
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, [$d022]
    bit 0, a
    jr z, $575e
    ld a, $0b
    jr $577b
    ld a, [$d01e]
    cp $ff
    jr z, $5775
    cp $92
    jr z, $5779
    cp $a3
    jr z, $5779
    cp $a8
    jr z, $5779
    ld a, $20
    jr $577b
    ld a, $03
    jr $577b
    ld a, $60
    ld [hl], a
    jp $58c2
    xor a
    ld [$d000], a
    ld hl, $d020
    ld a, [hld]
    ld e, a
    ld a, [hl]
    dec a
    ld b, $03
    or a
    rra
    rr e
    dec b
    jr nz, $578c
    or a
    inc a
    ld hl, $d016
    ld [hld], a
    ld [hl], e
    jp $58c2
    ld b, $0a
    jr $57a9
    xor a
    ld [hli], a
    ld [hl], a
    jp $58c2
    ld b, $03
    ld hl, $d022
    set 3, [hl]
    ld hl, $d015
    ld a, [$d020]
    ld [hli], a
    ld a, [$d01f]
    ld [hl], a
    xor a
    ld [$d000], a
    ld hl, $d019
    inc [hl]
    ld a, b
    cp [hl]
    jp nc, $58c2
    xor a
    ld hl, $d006
    ld [hli], a
    ld [$d000], a
    ld a, $06
    ld [hl], a
    ld hl, $d021
    set 1, [hl]
    ld a, $15
    ld [$d00f], a
    ld hl, $d010
    ld a, [$d008]
    and $0f
    cp $02
    jr nz, $57e8
    inc a
    ld [hli], a
    xor a
    ld [hl], a
    jp $58c2
MobileAdapter_SerialReceiveStateMachine::
    ld a, [$d00b]
    or a
    jr z, $57fe
    dec a
    jr z, $5874
    dec a
    jp z, $588a
    jp $5898
    ld hl, $d00a
    ld a, [hl]
    or a
    jr nz, $5809
    ld b, $99
    jr $580b
    ld b, $66
    ldh a, [$ff01]
    cp b
    jr z, $5846
    cp $d2
    jr nz, $581d
    xor a
    ld [$d1ae], a
    xor a
    ld [hl], a
    jp $58c2
    ld a, [$d1ae]
    inc a
    ld [$d1ae], a
    cp $14
    jr c, $5818
    ld a, $06
    ld [$d007], a
    ld a, $10
    ld [$d00f], a
    xor a
    ld [$d000], a
    ld hl, $d022
    res 0, [hl]
    ld hl, $d021
    ld a, [hl]
    set 1, a
    and $0f
    ld [hl], a
    jr $58c2
    inc [hl]
    ld a, $02
    cp [hl]
    jr nz, $58c2
    xor a
    ld [hli], a
    inc [hl]
    ld hl, $d012
    ld b, $03
    ld [hli], a
    dec b
    jr nz, $5854
    ld a, [$d022]
    bit 4, a
    jr z, $586a
    ld b, a
    ld a, [$d021]
    bit 3, a
    jr nz, $586a
    jp $5783
    ld a, [$d020]
    ld [hli], a
    ld a, [$d01f]
    ld [hl], a
    jr $58c2
    call $58c8
    ld a, $04
    cp [hl]
    jr nz, $58c2
    xor a
    ld [hli], a
    ldh a, [$ff01]
    ld [$d00c], a
    inc [hl]
    or a
    jr nz, $58c2
    inc [hl]
    jr $58c2
    call $58c8
    ld a, [$d00c]
    cp [hl]
    jr nz, $58c2
    xor a
    ld [hli], a
    inc [hl]
    jr $58c2
    ldh a, [$ff01]
    ld c, a
    call $566b
    ld hl, $d00a
    inc [hl]
    ld a, $02
    cp [hl]
    jr c, $58ba
    ld a, [$d00a]
    add a, $11
    ld e, a
    ld d, $d0
    ld a, [de]
    cp c
    jr z, $58c2
    ld a, $01
    ld [$d014], a
    jr $58c2
    ld a, $04
    cp [hl]
    jr nz, $58c2
    xor a
    ld [hli], a
    inc [hl]
MobileAdapter_SerialServiceReturn::
    ld hl, $d022
    res 1, [hl]
    ret
MobileAdapter_SerialStoreByteAndAdvance::
    ldh a, [$ff01]
    ld c, a
    ld b, $00
    ld hl, $d012
    ld a, [hli]
    ld l, [hl]
    ld h, a
    add hl, bc
    ld a, h
    ld [$d012], a
    ld a, l
    ld [$d013], a
    call $566b
    ld hl, $d00a
    inc [hl]
    ret
    assert @ == $58e4
