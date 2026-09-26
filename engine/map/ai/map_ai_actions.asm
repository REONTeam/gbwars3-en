include "macros/macros.inc"
include "constants/unit_constants.inc"

section "Map AI Planned Action Runtime", romx[$55c8], bank[$0d]
MapAI_ProcessActiveUnitActions::
    ld a, [$c9a2]
    ld d, a
    ld e, $32
    ld a, d
    call $652d
    and a
    jr z, $55ed
    ld a, d
    call $656d
    ld a, d
    call $55f2
    cp $01
    jr z, $55ed
    ld a, d
    call $562a
    cp $01
    jr z, $55ed
    ld a, d
    call $569e
    inc d
    dec e
    jr nz, $55ce
    ret
MapAI_EndTurnDamagedCarrierCargo::
MapAI_TryUnitActionPrimary::
    push de
    ld a, [$cce0]
    bit 0, a
    jr z, $5626
    ld a, [$cce3]
    ld c, $00
    call $090b
    srl a
    cp $2e
    jr z, $560c
    cp $2f
    jr nz, $5626
    ld a, [$cce1]
    cp $07
    jr nc, $5628
    ld a, [$cce0]
    set 7, a
    ld [$cce0], a
    ld a, [$c9d8]
    farcall UnitRecord_CopyToScratch
    ld a, $01
    jr $5628
    ld a, $00
    pop de
    ret
MapAI_TryRepairRecoveryAction::
MapAI_TryUnitActionSecondary::
    push de
    call $5720
    cp $01
    jr z, $5682
    call $573c
    cp $00
    jr z, $569a
    call $65a9
    call $5842
    ld a, b
    cp $ff
    jr nz, $5670
    ld a, [$ccdd]
    srl a
    farcall MapAI_BuildRepairPropertyOffsets
    call $578d
    and a
    jr z, $5666
    ld a, b
    cp $ff
    jr z, $569a
    ld a, [$ccdd]
    call $58a2
    call $5bb5
    ld a, b
    cp $ff
    jr z, $569a
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    jr $568e
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    ld a, $06
    ld [$c5ec], a
    call $4407
    jr $5696
    ld a, [$c9d9]
    ld [$c5ed], a
    ld a, [$c9da]
    ld [$c5ee], a
    ld a, $00
    ld [$c5ec], a
    call $4407
    ld a, $01
    jr $569c
    ld a, $00
    pop de
    ret
MapAI_TryResupplyRecoveryAction::
MapAI_TryUnitActionTertiary::
    push de
    call $574a
    cp $01
    jr nz, $571e
    ld a, [$c9d8]
    farcall UnitSupply_CheckAvailable
    and a
    jr z, $56e7
    call $65a9
    call $5842
    ld a, b
    cp $ff
    jr nz, $56f8
    ld a, [$ccdd]
    srl a
    farcall MapAI_BuildResupplyPropertyOffsets
    call $578d
    and a
    jr z, $56dd
    ld a, b
    cp $ff
    jr z, $571e
    ld a, [$ccdd]
    call $58a2
    call $5bb5
    ld a, b
    cp $ff
    jr z, $571e
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    jr $5716
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    farcall MapControl_PanToCoordinates
    call $4648
    jr $571e
    ld a, b
    ld [$c5ed], a
    ld a, c
    ld [$c5ee], a
    ld a, $06
    ld [$c5ec], a
    call $4407
    jr $571e
    ld a, [$c9d9]
    ld [$c5ed], a
    ld a, [$c9da]
    ld [$c5ee], a
    ld a, $00
    ld [$c5ec], a
    call $4407
    pop de
    ret
MapAI_TestPrimaryActionEligibility::
MapAI_TestRepairActionEligibility::
    ld a, [$ccdd]
    ld b, a
    ld a, [$c9d8]
    farcall Unit_CanRepairAtCurrentTerrain
    and a
    jr nz, $5739
    ld a, [$cce1]
    cp $07
    jr nc, $5739
    ld a, $01
    jr $573b
    ld a, $00
    ret
MapAI_TestSecondaryActionEligibility::
    ld a, [$cce1]
    cp $04
    jr nc, $5747
    ld a, $01
    jr $5749
    ld a, $00
    ret
MapAI_TestUnitActionState::
    push bc
    ld a, [$ccdd]
    ld c, $0c
    farcall UnitData_GetByte
    add a, a
    ld b, a
    ld a, [$cce4]
    cp b
    jr c, $5785
    ld a, [$ccdd]
    srl a
    cp $04
    jr z, $577f
    ld a, [$ccfa]
    and a
    jr z, $5789
    ld a, [$ccf7]
    and a
    jr nz, $5789
    ld a, [$cd08]
    and a
    jr z, $5785
    ld a, [$cd05]
    and a
    jr nz, $5789
    jr $5785
    ld a, [$ccf7]
    and a
    jr nz, $5789
    ld a, $01
    jr $578b
    ld a, $00
    pop bc
    ret
MapAI_FindActionCoordinate::
    push de
    ldh a, [$ff82]
    push af
    ld a, $0d
    call $058d
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    ld a, [$ccdd]
    call $58a2
    call $0593
    ld a, $ff
    ldh [$ff99], a
    ldh [$ff9a], a
    ldh [$ff9d], a
    ldh [$ff9e], a
    xor a
    ldh [$ff9b], a
    ld a, $01
    ldh [$ff9c], a
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    ldh a, [$ff9b]
    ld b, $00
    ld c, a
    ld hl, $dd81
    add hl, bc
    add hl, bc
    add hl, bc
    ld d, [hl]
    inc hl
    ld b, [hl]
    inc hl
    ld c, [hl]
    ld a, b
    cp $ff
    jr z, $5822
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    call $08d7
    ld a, [hl]
    and a
    jr nz, $5822
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    ld d, [hl]
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [hl]
    and $3f
    call $588f
    and a
    jr z, $5822
    ld a, d
    cp $ff
    jr nz, $5833
    ld a, $a0
    call $08e6
    ld a, [hl]
    cp $ff
    jr z, $5822
    ld e, a
    ld a, h
    add a, $10
    ld h, a
    ld d, [hl]
    ldh a, [$ff9d]
    ld l, a
    ldh a, [$ff9e]
    ld h, a
    call $29ca
    jr nc, $5822
    ld a, e
    ldh [$ff9d], a
    ld a, d
    ldh [$ff9e], a
    ld a, b
    ldh [$ff99], a
    ld a, c
    ldh [$ff9a], a
    ldh a, [$ff9b]
    inc a
    ldh [$ff9b], a
    cp $64
    jr nz, $57b8
    ldh a, [$ff99]
    ld b, a
    ldh a, [$ff9a]
    ld c, a
    jr $5836
    xor a
    ldh [$ff9c], a
    call $059b
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ldh a, [$ff9c]
    pop de
    ret
MapAI_FindCompatibleCarrierTarget::
MapAI_FindCompatibleUnitTarget::
    ldh a, [$ff82]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$ccdd]
    ld b, $2e
    farcall UnitData_CheckLoadingCompatibility
    jr nz, $5886
    ld a, [$c9a2]
    ld d, a
    ld e, $32
    ld a, d
    ld c, $00
    call $090b
    and a
    jr z, $5882
    srl a
    cp $2e
    jr z, $586f
    cp $2f
    jr nz, $5882
    ld a, d
    call $095e
    call $08d7
    ld a, [hl]
    cp $ff
    jr z, $5882
    farcall Unit_CanLoadIntoCarrierAtCoordinates
    and a
    jr z, $5889
    inc d
    dec e
    jr nz, $585c
    ld bc, $ffff
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
MapAI_TestMapClassForAction::
    push bc
    ld b, a
    ld hl, $c949
    ld a, [hl]
    and a
    jr z, $58a0
    ld a, [$c9a4]
    add a, [hl]
    inc hl
    cp b
    jr nz, $5894
    pop bc
    ret
    assert @ == $58a2
