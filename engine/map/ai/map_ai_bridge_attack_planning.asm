include "macros/macros.inc"
include "constants/unit_constants.inc"

; producer-side proof for the final unresolved map-AI action IDs.
; These ranges are kept byte-row exact while their deeper target-ranking helpers
; remain unsourced; public action semantics are established by both producer
; conditions and the source-owned executors.

section "Map AI Bridge and Direct Attack Planning", romx[$6183], bank[$0d]
MapAI_PlanBridgeConstruction::
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$de9a]
    cp $ff
    jp z, $622f
    ld a, $ff
    ld [$c021], a
    ld [$c022], a
    ld a, [$c9a2]
    ld d, a
    ld e, $32
    ld a, d
    call $652d
    and a
    jr z, $61d9
    srl a
    cp $04
    jr nz, $61d9
    ld a, d
    ld c, $08
    call $090b
    cp $02
    jr c, $61d9
    ld a, d
    call $095e
    push de
    ld a, [$de9a]
    ld d, a
    ld a, [$de9b]
    ld e, a
    call $291d
    pop de
    ld c, a
    ld a, [$c021]
    cp c
    jr c, $61d9
    ld a, c
    ld [$c021], a
    ld a, d
    ld [$c022], a
    inc d
    dec e
    jr nz, $61a2
    ld a, [$c022]
    cp $ff
    jr z, $622f
    call $6563
    ld a, [$de9a]
    ld b, a
    ld a, [$de9b]
    ld c, a
    ld a, $08
    call $58a2
    call $5bb5
    ld a, b
    cp $ff
    jr z, $622f
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    ld a, [$de9a]
    ld [$c5f0], a
    ld d, a
    ld a, [$de9b]
    ld [$c5f1], a
    ld e, a
    call $291d
    cp $01
    jr nz, $6227
    ld a, $04
    ld [$c5ec], a
    call $4407
    call $6870
    jp $618c
    ld a, $00
    ld [$c5ec], a
    call $4407
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
MapAI_RunAttackPlannerFamily0::
    ld hl, $623c
    call $6472
    ret
MapAI_AttackPlannerFamily0Order::
    ld bc, $0302
    nop
MapAI_PlanDirectAttackFamily0::
    push de
    call $4c4f
    ld a, b
    cp $ff
    jr nz, $62a1
    ld a, [$c9d8]
    ld [$c5eb], a
    call $5e28
    cp $00
    jr nz, $62ab
    call $4cca
    ld a, b
    cp $ff
    jr z, $62a9
    ld d, b
    ld e, c
    ld a, [$ccdd]
    call $58a2
    call $5bb5
    ld a, b
    cp $ff
    jr z, $62a9
    push bc
    ld b, d
    ld c, e
    call $4be1
    pop bc
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    ld a, $00
    ld [$c5ec], a
    call $4749
    cp $ff
    jr z, $629c
    ld [$c5ef], a
    call $095e
    ld a, b
    ld [$c5f0], a
    ld a, c
    ld [$c5f1], a
    ld a, $03
    ld [$c5ec], a
    call $4407
    jr $62ab
    call $4be1
    call $4654
    jr $62ab
    jr $62ab
    pop de
MapAI_RunAttackPlannerFamily1::
    ret
    db $21, $b4, $62, $cd, $72, $64, $c9
MapAI_AttackPlannerFamily1Order::
    inc b
    nop
MapAI_PlanDirectAttackFamily1::
    push bc
    push de
    call $4d3a
    ld a, b
    cp $ff
    jr nz, $631d
    ld a, [$c9d8]
    ld [$c5eb], a
    call $5e28
    cp $00
    jr nz, $6322
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    ld a, [$ccdd]
    call $58a2
    call $4d99
    ld a, b
    cp $ff
    jr z, $6322
    ld a, [$ccdd]
    call $58a2
    call $5bb5
    ld a, b
    cp $ff
    jr z, $6322
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    ld a, $00
    ld [$c5ec], a
    call $4749
    cp $ff
    jr z, $6318
    ld [$c5ef], a
    call $095e
    ld a, b
    ld [$c5f0], a
    ld a, c
    ld [$c5f1], a
    ld a, $03
    ld [$c5ec], a
    call $4407
    jr $6322
    call $4665
    jr $6322
    pop de
    pop bc
    ret
    assert @ == $6325
