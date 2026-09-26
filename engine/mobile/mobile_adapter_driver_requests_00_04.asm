include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"

; Mobile Adapter GB request-handler cluster in physical Bank $30.
; These routines are split on proven request-table and local helper boundaries.
; Numeric request IDs remain canonical until later packet/state behavior proves
; a stable protocol-facing name.

section "Mobile Adapter Driver Requests 00-04", romx[$4115], bank[$30]
MobileAdapter_RequestHandler00::
    ld hl, $d021
    bit 1, [hl]
    jr nz, $4120
    xor a
    ld l, a
    ld h, a
    ret
    res 1, [hl]
    ld a, [$d00f]
    ld e, a
    cp $22
    jr z, $416a
    cp $23
    jr z, $416a
    cp $25
    jr z, $416a
    cp $26
    jr z, $418e
    cp $24
    jr z, $41a4
    cp $30
    jp z, $41f7
    cp $31
    jp z, $420c
    cp $32
    jr z, $41a4
    cp $33
    jr z, $41a4
    swap a
    and $0f
    cp $01
    jr z, $416a
    cp $00
    jr z, $415d
    ld hl, $0000
    ld a, e
    ret
    ld a, e
    add a, $15
    ld e, a
    xor a
    ld hl, $d010
    ld [hli], a
    ld [hl], a
    ld hl, $d021
    xor a
    ld [$d06d], a
    ld [hl], a
    ld [$d007], a
    inc a
    ld [$d06a], a
    ld hl, $d022
    res 0, [hl]
    res 5, [hl]
    ld hl, $d347
    xor a
    ld [hli], a
    inc a
    ld [hl], a
    call $568d
    ld a, $15
    cp e
    jr nz, $4158
    jr $41d6
    ld a, [$d021]
    bit 4, a
    ld a, $01
    jr z, $416a
    ld a, $02
    ld [$d06a], a
    ld a, [$d005]
    ld [$d007], a
    jr $4158
    res 0, [hl]
    ld hl, $d022
    res 5, [hl]
    ld hl, $d021
    res 7, [hl]
    res 6, [hl]
    set 5, [hl]
    xor a
    ld [$d06d], a
    ld [$d1af], a
    ld a, $02
    ld [$d06a], a
    ld a, $04
    ld [$d007], a
    ld a, e
    cp $32
    jr z, $41d6
    cp $33
    jr z, $41d6
    cp $30
    jr z, $41d6
    cp $31
    jr nz, $4158
    ld hl, $d010
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, $32
    cp e
    jp nz, $415b
    ld a, $03
    cp h
    jp nz, $415b
    dec a
    cp l
    jr z, $41f1
    dec a
    cp l
    jp nz, $415b
    ld bc, $d080
    jp $415b
    ld a, [$d23c]
    cp $a4
    jr z, $41a4
    ld a, $03
    ld [$d06a], a
    ld hl, $d010
    ld a, [hli]
    ld h, [hl]
    ld l, a
    jp $415b
    ld a, [$d010]
    cp $02
    jr z, $41a4
    cp $03
    jr z, $41a4
    ld a, $04
    ld [$d06a], a
    ld hl, $d010
    ld a, [hli]
    ld h, [hl]
    ld l, a
    jp $415b
MobileAdapter_SetEvent21::
    ld a, $21
    ld [$d00f], a
    ld hl, $d021
    set 1, [hl]
    ret
MobileAdapter_SetEvent20::
    ld a, $20
    jr $4227
MobileAdapter_InternalHandler40::
    nop
MobileAdapter_RequestHandler02::
    ld a, [$d188]
    push af
    push bc
    push hl
    xor a
    ldh [$ff07], a
    ldh a, [$ff0f]
    and $1b
    ldh [$ff0f], a
    call $4029
    ld bc, $0452
    ld hl, $d000
    xor a
    ld [hli], a
    dec bc
    ld a, c
    or b
    jr nz, $424d
    ld a, [$d022]
    set 6, a
    ld [$d022], a
    pop hl
    ld a, l
    ld [$d181], a
    ld a, h
    ld [$d182], a
    pop bc
    ld hl, $d183
    ld a, c
    ld [hli], a
    ld a, b
    ld [hl], a
    ld hl, $d06e
    ld a, e
    ld [hli], a
    ld [hl], d
    xor a
    ld [$d019], a
    ld c, $0c
    call $40dc
    call $44af
    pop af
    cp $34
    jr nz, $4288
    ld a, $2b
    jr $428a
    ld a, $0a
    ld [$d06a], a
    jp $4431
MobileAdapter_RequestHandler04::
    ld a, [$d021]
    bit 1, a
    jr z, $42a5
    ld a, [$d00f]
    cp $14
    jr z, $42b2
    cp $25
    jr z, $42b2
    ld a, [$d021]
    bit 0, a
    jp nz, $4225
    ld a, [$d06a]
    cp $01
    jp nz, $4225
    xor a
    ldh [$ff07], a
    xor a
    ld [$d019], a
    ld a, l
    ld b, h
    ld hl, $d080
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, c
    ld [hli], a
    ld a, e
    ld [hli], a
    ld a, d
    ld [hl], a
    ld a, [$d070]
    ld c, a
    call $40dc
    ld hl, $d029
    ld a, $72
    ld [hli], a
    ld a, $d0
    ld [hl], a
    ld de, $d347
    ld b, $05
    ld hl, $605e
    call $4000
    ld a, [$d082]
    ld c, a
    or a
    jr z, $42f1
    cp $80
    jr nc, $42f1
    ld c, $80
    jr $42f3
    ld a, $80
    ld b, a
    inc a
    ld [de], a
    inc de
    ld a, $80
    add a, c
    ld hl, $d082
    ld [hli], a
    ld a, [hl]
    ld [de], a
    inc de
    add a, $80
    ld [hl], a
    ld hl, $d080
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld c, b
    call $4000
    ld a, l
    ld [$d080], a
    ld a, h
    ld [$d081], a
    ld b, c
    inc b
    call $5f66
    call $44af
    ld a, $2e
    ld [$d06a], a
    ld hl, $d021
    res 1, [hl]
    set 0, [hl]
    ret
MobileAdapter_RequestHandler38::
    ld a, [$d021]
    bit 1, a
    jp nz, $4225
    bit 0, a
    jp nz, $4225
    ld a, [$d06a]
    cp $01
    jp nz, $4225
    xor a
    ldh [$ff07], a
    ld [$d019], a
    ld hl, $d080
    ld a, e
    ld [hli], a
    ld a, d
    ld [hli], a
    ld a, c
    ld [hli], a
    ld a, b
    ld [hli], a
    ld hl, $d029
    ld a, e
    ld [hli], a
    ld a, d
    ld [hl], a
    ld a, [$d070]
    ld c, a
    call $40dc
    ld de, $d347
    ld b, $06
    ld hl, $6046
    call $4000
    ld a, [$d083]
    ld [de], a
    inc de
    ld a, [$d082]
    ld c, a
    or a
    jr z, $437e
    cp $80
    jr nc, $437e
    ld c, $80
    jr $4380
    ld a, $80
    ld [de], a
    inc de
    ld b, $02
    call $5f66
    call $44af
    ld a, $2d
    ld [$d06a], a
    jp $4431
MobileAdapter_EnableTimerSerialInterrupts::
    ld c, $ff
    ldh a, [c]
    or $0c
    ldh [c], a
    ret
MobileAdapter_ValidateZeroTerminatedLength::
    ld b, $00
    inc b
    jr z, $43a2
    ld a, [hli]
    or a
    jr nz, $439b
    ld a, b
    cp c
    jr nc, $43a9
    cp $02
    ret
    scf
    ret
    assert @ == $43ab
