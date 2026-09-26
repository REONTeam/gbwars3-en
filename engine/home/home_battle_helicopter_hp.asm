include "macros/macros.inc"
include "constants/battle_helicopter_hp_constants.inc"

section "Battle Helicopter HP Graphics Helpers", rom0[$0166]
BattleHelicopterHPGraphics_UpdateEntry::
    ld e, a
    ldh a, [$ff80]
    push af
    ld a, $02
    ldh [$ff80], a
    ld [$2000], a
    ld a, e
    call $4000
    ld a, [$c4ae]
    cp $00
    jr z, $0180
    ld bc, $0018
    add hl, bc
    push hl
    ld a, [$c4ae]
    cp $00
    jr z, $018a
    jr $018f
    ld hl, $d384
    jr $0192
    ld hl, $d38e
    ld a, [$d33e]
    call $29bc
    ld a, [hl]
    pop hl
    cp $01
    jr z, $01a0
    jr $01d3
    ld a, [$d33e]
    add a, a
    call $29bc
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a
    ld a, [$c4ae]
    cp $00
    jr nz, $01c2
    ld d, $03
    ld e, $01
    ld a, [$d33e]
    call $01da
    ld h, a
    ld a, $00
    ld l, a
    jr $01d0
    ld d, $03
    ld e, $01
    ld a, [$d33e]
    call $01f8
    ld h, a
    ld a, $01
    ld l, a
    call $39db
    pop af
    ldh [$ff80], a
    ld [$2000], a
    ret
BattleHelicopterHPGraphics_UpdateSide0Entry::
    push bc
    push de
    ld hl, $d398
    call $29bc
    ld a, [hl]
    cp $00
    jr z, $01e9
    jr $01f1
    ld a, $01
    ld [hl], a
    ld a, $01
    pop de
    pop bc
    ret
    xor a
    ld [hl], a
    ld a, $ec
    pop de
    pop bc
    ret
BattleHelicopterHPGraphics_UpdateSide1Entry::
    push bc
    push de
    ld hl, $d3a2
    call $29bc
    ld a, [hl]
    cp $00
    jr z, $0207
    jr $020f
    ld a, $01
    ld [hl], a
    ld a, $2b
    pop de
    pop bc
    ret
    xor a
    ld [hl], a
    ld a, $f2
    pop de
    pop bc
    ret
    assert @ == $0216

section "Battle Helicopter HP Graphics VBlank Update", rom0[$0216]
BattleHelicopterHPGraphicsUpdate::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$d340]
    cp $00
    jr z, $0244
    ld a, [$d343]
    ld [$d33e], a
    ld a, [$c4b7]
    ld b, $00
    call $0166
    ld a, [$d343]
    add a, $05
    ld [$d33e], a
    ld a, [$c4b7]
    ld b, $00
    call $0166
BattleHelicopterHPGraphicsUpdate.side1::
    ld a, [$d341]
    cp $00
    jr z, $0269
    ld a, [$d343]
    ld [$d33e], a
    ld a, [$c4b8]
    ld b, $01
    call $0166
    ld a, [$d343]
    add a, $05
    ld [$d33e], a
    ld a, [$c4b8]
    ld b, $01
    call $0166
BattleHelicopterHPGraphicsUpdate.advance_phase::
    ld a, [$d343]
    cp $04
    jr z, $0276
    inc a
    ld [$d343], a
    jr $027a
BattleHelicopterHPGraphicsUpdate.wrap::
    xor a
    ld [$d343], a
BattleHelicopterHPGraphicsUpdate.done::
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $0280
