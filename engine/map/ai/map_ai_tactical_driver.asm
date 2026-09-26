include "macros/macros.inc"
include "constants/unit_constants.inc"

section "Map AI Tactical Planning Driver", romx[$4000], bank[$0d]
MapAI_TacticalPlanningSweepA::
    ld a, [$c9a2]
    ld [$c5eb], a
    ld e, $32
    ld a, [$c5eb]
    call $652d
    and a
    jr z, $4025
    ld a, [$c5eb]
    call $481f
    ld a, [$c602]
    bit 7, a
    jr z, $4025
    and $1f
    jr z, $4025
    call $4033
    ld a, [$ca94]
    and a
    jr nz, $4032
    ld hl, $c5eb
    inc [hl]
    dec e
    jr nz, $4008
    ret
MapAI_TacticalPlanningWorkerA::
    push bc
    push de
    ld a, [$c5eb]
    call $4510
    ld a, [$cce0]
    bit 0, a
    jr nz, $4056
    call $5e28
    cp $00
    jr nz, $4094
    ld a, [$c9d8]
    call $48e5
    call $4106
    cp $02
    jr z, $405b
    call $4321
    jr $4094
    ld a, [$c5e8]
    ld b, a
    ld a, [$c5e9]
    ld c, a
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    ld a, [$c5e7]
    ld [$c5ef], a
    call $095e
    ld a, b
    ld [$c5f0], a
    ld a, c
    ld [$c5f1], a
    ld a, $03
    ld [$c5ec], a
    call $4407
    jr $4094
    call $44ee
    ld a, [$ccde]
    ld b, a
    ld a, [$ccdf]
    ld c, a
    call $462f
    pop de
    pop bc
    ret
MapAI_TacticalPlanningSweepB::
    ld a, [$c9a2]
    ld [$c5eb], a
    ld e, $32
    ld a, [$c5eb]
    call $652d
    and a
    jr z, $40b8
    ld a, [$c5eb]
    call $5d56
    bit 6, a
    jr z, $40b8
    ld [$c602], a
    call $40c6
    ld a, [$ca94]
    and a
    jr nz, $40c5
    ld hl, $c5eb
    inc [hl]
    dec e
    jr nz, $409f
    ret
MapAI_TacticalPlanningWorkerB::
    push bc
    push de
    ld a, [$c5eb]
    call $4510
    call $5e28
    cp $00
    jr nz, $4103
    call $41c2
    cp $02
    jr z, $40e8
    call $41cc
    cp $02
    jr z, $40e8
    call $4321
    jr $4103
    ld a, [$c5ed]
    ld b, a
    ld a, [$c5ee]
    ld c, a
    call $4546
    call $44ee
    jr $4103
    ld a, [$ccde]
    ld b, a
    ld a, [$ccdf]
    ld c, a
    call $462f
    pop de
    pop bc
    ret
    assert @ == $4106
