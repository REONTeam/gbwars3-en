include "macros/macros.inc"

; MapMenu Runtime 4B86
; Executable bytes are expressed as LR35902 mnemonics and retain exact retail geometry.

section "MapMenu Runtime 4B86", romx[$4b86], bank[$13]
MapMenu_Runtime4B86::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$dc50], a
    call $49f1
    call $4b0a
    ld a, $02
    call $3816
    call $081d
    call $05a2
    call $3056
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    bit 6, a
    jr z, $4bca
    ld a, $01
    call $3844
    ld a, [$dc36]
    sub $03
    jr c, $4bc8
    ld [$dc36], a
    call $4ac3
    call $4b0a
    jr $4ba1
    bit 7, a
    jr z, $4be7
    ld a, $01
    call $3844
    ld a, [$dc36]
    add a, $03
    cp $06
    jr nc, $4be5
    ld [$dc36], a
    call $4ac3
    call $4b0a
    jr $4ba1
    bit 5, a
    jr z, $4c05
    ld a, $01
    call $3844
    ld a, [$dc36]
    dec a
    cp $ff
    jr nz, $4bfa
    ld a, $05
    ld [$dc36], a
    call $4ac3
    call $4b0a
    jr $4ba1
    bit 4, a
    jr z, $4c23
    ld a, $01
    call $3844
    ld a, [$dc36]
    inc a
    cp $06
    jr nz, $4c17
    xor a
    ld [$dc36], a
    call $4ac3
    call $4b0a
    jp $4ba1
    bit 0, a
    jp z, $4c33
    ld a, $02
    call $3844
    ld a, [$dc36]
    jp $4c44
    bit 1, a
    jr z, $4c41
    ld a, $0c
    call $3844
    ld a, $ff
    jp $4d16
    jp $4ba1
    cp $00
    jr z, $4c5e
    cp $01
    jr z, $4c63
    cp $02
    jr z, $4c68
    cp $03
    jr z, $4c6d
    cp $04
    jp z, $4cb3
    cp $05
    jp z, $4cb7
    ld a, $00
    jp $4cbb
    ld a, $02
    jp $4cbb
    ld a, $04
    jp $4cbb
    ld a, $04
    ld b, $03
    farcall $13, MapSRAM_SlotHasCategoryData
    jr z, $4caf
    call $07b4
    farcall $0f, MapMenu_RunPlayRecordFlow
    cp $ff
    jr z, $4c9e
    cp $01
    jr z, $4c9e
    call $2e67
    farcall $0f, MapMenu_PreparePlayRecord
    call $49f1
    call $4b0a
    ld a, $02
    call $3816
    call $081d
    jp $4ba1
    call $49f1
    call $4b0a
    ld a, $02
    call $3816
    call $081d
    jp $4ba1
    ld a, $01
    jr $4cbb
    ld a, $03
    jr $4cbb
    ld a, $05
    jr $4cbb
    ld [$dc4d], a
    ld a, [$dc37]
    call $2f5f
    ld bc, $0101
    ld de, $1204
    farcall $10, UIWindowStack_PushAndDraw
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0202
    ld de, $1001
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    call $4b49
    ld a, [$dc2c]
    call $2f45
    call $4717
    call $4fba
    ld a, [$dc2c]
    call $2f5f
    farcall $10, UIWindowStack_PopRestore
    ld a, [$dc37]
    call $2f45
    call $4b0a
    ld a, [$ca69]
    cp $01
    jr nz, $4d13
    call $081d
    jp $4ba1
    ld d, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    push de
    call $07b4
    call $2e67
    pop de
    ld a, d
    ret
    ld a, [$dc2b]
    ld [$dc30], a
    ld bc, $0101
    ld de, $1204
    farcall $10, UIWindowStack_PushAndDraw
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0202
    ld de, $1001
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a

    assert @ == $4d4f, "MapMenu Runtime 4B86 boundary moved"
