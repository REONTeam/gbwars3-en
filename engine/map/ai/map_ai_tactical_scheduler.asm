include "macros/macros.inc"
include "constants/unit_constants.inc"

section "Map AI Tactical Scheduler Lead-In", romx[$4321], bank[$0d]
MapAI_TacticalSchedulerLeadIn::
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$ccdd]
    ld c, $18
    farcall UnitData_GetByte
    cp $03
    jr z, $4391
    cp $04
    jr z, $4391
    cp $02
    jr z, $438c
    call $43b7
    ld a, b
    cp $ff
    jr z, $4355
    ld a, [$ccdd]
    call $58a2
    call $5bb5
    ld a, b
    cp $ff
    jr nz, $43ae
    ld a, [$de9a]
    cp $ff
    jr z, $4372
    ld b, a
    ld a, [$de9b]
    ld c, a
    ld a, [$ccdd]
    call $58a2
    call $599b
    call $5bb5
    ld a, b
    cp $ff
    jr nz, $43ae
    ld a, [$dea0]
    bit 0, a
    jr z, $43b1
    call $5d9c
    ld a, [$ccdd]
    call $58a2
    call $5bb5
    ld a, b
    cp $ff
    jr nz, $43ae
    jr $43b1
    call $5d9c
    jr $43a0
    ld a, [$dea0]
    bit 2, a
    jr z, $43b1
    ld a, [$de9e]
    ld b, a
    ld a, [$de9f]
    ld c, a
    ld a, [$ccdd]
    call $58a2
    call $5bb5
    ld a, b
    cp $ff
    jr z, $43b1
    call $4546
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
MapAI_FindBestTacticalUnitCandidate::
    push de
    ld a, $ff
    ldh [$ff9a], a
    ldh [$ff9b], a
    ldh [$ff9c], a
    ld e, $32
    ld a, [$c9a3]
    ld d, a
    push de
    ld a, d
    ldh [$ff99], a
    ld c, $00
    call $090b
    and a
    jr z, $43fa
    ld a, [$c9d8]
    call $095e
    ld d, b
    ld e, c
    ldh a, [$ff99]
    call $095e
    call $291d
    ldh [$ff9d], a
    call $5d2b
    and a
    jr nz, $43fa
    ldh a, [$ff9c]
    ld d, a
    ldh a, [$ff9d]
    cp d
    jr nc, $43fa
    ldh [$ff9c], a
    ld a, b
    ldh [$ff9a], a
    ld a, c
    ldh [$ff9b], a
    pop de
    inc d
    dec e
    jr nz, $43c6
    ldh a, [$ff9a]
    ld b, a
    ldh a, [$ff9b]
    ld c, a
    pop de
    ret
    assert @ == $4407
