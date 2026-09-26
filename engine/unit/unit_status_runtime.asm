include "macros/macros.inc"
include "constants/unit_constants.inc"

; Unit Status selected-unit staging / rendering helper.
;
; The physical WRAM bytes $C61B-$C621 are shared scratch. These aliases are
; valid only while this Bank $25 Unit Status path is active; the same addresses
; have separate infrared-controller and later-feature lifetimes.
section "UnitStatus Selected Unit Runtime", romx[$42be], bank[$25]
UnitStatus_LoadSelectedUnitPanel::
    ld [$c621], a
    ld a, [$c621]
    ld c, $00
    farcall UnitRecord_GetByte
    ld [$c61b], a
    ld a, [$c621]
    ld c, $04
    farcall UnitRecord_GetByte
    ld [$c61c], a
    ld a, [$c621]
    ld c, $07
    farcall UnitRecord_GetByte
    ld [$c61d], a
    ld a, [$c621]
    farcall UnitRecord_GetExperienceRank
    ld [$c61e], a
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$c61f]
    ld b, $40
    call $2995
    ld bc, $8c00
    add hl, bc
    ld a, [$c61b]
    farcall UnitGraphic_LoadTiles
    ld a, [$c620]
    add a, $04
    ld b, a
    ld c, $06
    call $0ed4
    ld b, $01
    ld a, [$c61b]
    ld d, a
    ld c, $05
    push bc
    push de
    push hl
    ld a, [$c61f]
    ld b, $04
    call $2995
    ld a, l
    add a, $c0
    pop hl
    pop de
    pop bc
    farcall UnitGraphic_DrawMetatile
    ld a, [$c620]
    add a, $02
    ld b, a
    ld c, $08
    ld d, $02
    ld a, [$c61c]
    farcall DrawNumber3Digits
    ld a, [$c620]
    add a, $05
    ld b, a
    ld c, $08
    ld d, $02
    ld a, [$c61d]
    farcall DrawNumber3Digits
    ld a, [$c620]
    add a, $08
    ld b, a
    ld c, $08
    ld d, $02
    ld a, [$c61e]
    push bc
    ld b, $02
    call $2995
    ld bc, $43b3
    add hl, bc
    pop bc
    call $3353
    ld a, [$c621]
    farcall UnitWeapon_BuildSummary
    ld a, [$c620]
    add a, $01
    ld b, a
    ld c, $0a
    ld hl, $cced
    call $3353
    ld a, [$c620]
    add a, $07
    ld b, a
    ld c, $0b
    ld d, $02
    ld a, [$ccf7]
    farcall DrawNumber3Digits
    ld a, [$c620]
    add a, $01
    ld b, a
    ld c, $0c
    ld hl, $ccfb
    call $3353
    ld a, [$c620]
    add a, $07
    ld b, a
    ld c, $0d
    ld d, $02
    ld a, [$cd05]
    farcall DrawNumber3Digits
    ret
    assert @ == $43b3
