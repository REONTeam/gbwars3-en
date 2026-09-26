include "macros/macros.inc"
include "constants/unit_constants.inc"

; upstream tactical-policy selector feeding the earlier scheduler.
; The true entry is $4106: it reads the acting encoded type/side byte, shifts
; away the side bit, and indexes profile table A through $4A35. The formerly
; documented $410B address is the CALL instruction inside this routine.

section "Map AI Tactical Policy Selector", romx[$4106], bank[$0d]
MapAI_TacticalPolicySelector::
    ld a, [$ccdd]
    srl a
    call $4a35
    ld a, l
    ldh [$ff99], a
    ld a, h
    ldh [$ff9a], a
    push bc
    push de
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $ff
    ld [$c5ea], a
    ld e, $32
    ld a, [$c9a3]
    ld d, a
    ld a, d
    call $4965
    jr z, $418b
    ld a, d
    ld c, $00
    call $090b
    srl a
    ld b, a
    ldh a, [$ff99]
    ld l, a
    ldh a, [$ff9a]
    ld h, a
    ld a, b
    call $41a6
    cp $ff
    jr z, $418b
    ldh [$ff9b], a
    ld a, d
    call $499d
    ld a, b
    cp $ff
    jr z, $418b
    ldh [$ff9c], a
    ld a, c
    ldh [$ff9d], a
    ld a, d
    call $46b6
    and $0f
    jr z, $418b
    ld a, d
    call $095e
    call $0985
    cp $20
    jr c, $4170
    ldh a, [$ff9b]
    add a, $40
    ldh [$ff9b], a
    ldh a, [$ff9b]
    ld b, a
    ld a, [$c5ea]
    cp b
    jr c, $418b
    ld a, b
    ld [$c5ea], a
    ld a, d
    ld [$c5e7], a
    ldh a, [$ff9c]
    ld [$c5e8], a
    ldh a, [$ff9d]
    ld [$c5e9], a
    inc d
    dec e
    jr nz, $412a
    ld a, [$c5ea]
    cp $ff
    jp z, $419b
    ld b, $02
    jr $419d
    ld b, $01
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, b
    pop de
    pop bc
    ret
MapAI_FindUnitTypeRankInPriorityList::
    push bc
    ld b, a
    ld c, $00
    ld a, [hli]
    and a
    jr z, $41b7
    cp b
    jr z, $41b4
    inc c
    jr $41aa
    ld a, c
    jr $41b9
    ld a, $ff
    pop bc
    ret
MapAI_SelectPriorityDomain::
    ld a, [$c602]
    bit 2, a
    jr nz, $41cc
MapAI_SelectNonAirPriorityDomain::
    ld a, $ec
    ldh [$ff99], a
    ld a, $42
    ldh [$ff9a], a
    jr $41d4
MapAI_SelectAirPriorityDomain::
    ld a, $11
    ldh [$ff99], a
    ld a, $43
    ldh [$ff9a], a
MapAI_SelectPriorityDomainCandidate::
    push bc
    push de
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $ff
    ld [$c5ea], a
    ld e, $32
    ld a, [$c9a3]
    ld d, a
    push de
    ld a, d
    ld c, $00
    call $090b
    srl a
    jr z, $4272
    ld b, a
    ldh a, [$ff99]
    ld l, a
    ldh a, [$ff9a]
    ld h, a
    ld a, b
    call $41a6
    cp $ff
    jr z, $4272
    ldh [$ff9b], a
    ld a, b
    add a, a
    ld c, $18
    farcall UnitData_GetByte
    ld hl, $c602
    call $3ac7
    jr z, $4272
    ld a, d
    ld c, $03
    call $090b
    bit 0, a
    jr nz, $4272
    bit 1, a
    jr nz, $4272
    ld a, d
    call $095e
    ld a, b
    ldh [$ff9d], a
    ld a, c
    ldh [$ff9e], a
    ld a, d
    call $428f
    cp $ff
    jr z, $4272
    ld a, d
    call $095e
    call $0985
    cp $20
    jr c, $4247
    ldh a, [$ff9b]
    add a, $40
    ldh [$ff9b], a
    ldh a, [$ff9b]
    ld b, a
    ld a, [$c5ea]
    cp b
    jr c, $4272
    ld a, b
    ld [$c5ea], a
    ld a, d
    ld [$c5e7], a
    ldh a, [$ff9d]
    ld b, a
    ld [$c5e8], a
    ldh a, [$ff9e]
    ld c, a
    ld [$c5e9], a
    ldh a, [$ff9f]
    ld e, a
    call $28d9
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    pop de
    inc d
    dec e
    jp nz, $41ea
    ld a, [$c5ea]
    cp $ff
    jp z, $4284
    ld b, $02
    jr $4286
    ld b, $01
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, b
    pop de
    pop bc
    ret
MapAI_FindBestNeighborByTacticalScore::
    push bc
    push de
    ld d, a
    ldh a, [$ff82]
    push af
    xor a
    ldh [$ff9c], a
    ld a, $ff
    ldh [$ff9f], a
    ld e, $00
    push bc
    call $28d9
    jr c, $42db
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    call $08d7
    ld a, [hl]
    cp $ff
    jr z, $42db
    and a
    jr nz, $42bc
    ld a, [$cce0]
    bit 0, a
    jr z, $42c7
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [hl]
    and $7f
    jr nz, $42db
    ld a, d
    call $46b6
    and $0f
    jr z, $42db
    ld b, a
    ldh a, [$ff9c]
    cp b
    jr nc, $42db
    ld a, b
    ldh [$ff9c], a
    ld a, e
    ldh [$ff9f], a
    pop bc
    inc e
    ld a, e
    cp $06
    jr nz, $429e
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ldh a, [$ff9f]
    pop de
    pop bc
    ret
MapAI_NonAirUnitPriorityList::
    inc sp
    ld [hld], a
    ld d, $15
    db $10, $0f, $12, $14, $13, $1c, $1b, $1a, $19, $18, $17, $0c, $0b, $11, $0e, $0d
    db $0a, $09, $03, $02, $01, $04, $08, $07, $06, $05, $2d, $31, $2f, $30, $2c, $2e
    db $00
MapAI_AirUnitPriorityList::
    rra
    inc h
    inc hl
    dec h
    ld h, $29
    dec hl
    ld a, [hli]
    dec e
    ld e, $28
    daa
    ld [hli], a
    jr nz, $4341
    nop
    assert @ == $4321
