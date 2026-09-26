include "macros/macros.inc"
include "constants/unit_constants.inc"

; split the former opaque $4749-$4A42 tactical scorer into natural
; routine boundaries. Names below are limited to behavior proven by direct data
; flow: weapon target masks/ranges, opposing-unit bitfields, firing-cell search,
; and terrain/repair scoring. Raw bytes remain exact while the wider battle-policy
; weighting is still being decoded.

section "Map AI Attack Scoring", romx[$4749], bank[$0d]
MapAI_SelectAdjacentAttackTargetByScore::
    push bc
    push de
    ldh a, [$ff82]
    push af
    xor a
    ld [$c609], a
    ld a, $ff
    ld [$c608], a
    ld e, $00
    ld a, [$c5ed]
    ld b, a
    ld a, [$c5ee]
    ld c, a
    call $28d9
    jr c, $479f
    farcall UnitRecord_FindPrimaryAtCoordinates
    cp $ff
    jr z, $479f
    ld d, a
    ld c, $00
    call $090b
    farcall UnitTypeSide_IsEmptyOrCurrentPhaseSide
    jr z, $479f
    ld a, [$c5ed]
    ld b, a
    ld a, [$c5ee]
    ld c, a
    ld a, d
    call $46b6
    ld b, a
    call $47b0
    and a
    jr nz, $479f
    ld a, b
    and $0f
    ld b, a
    ld a, [$c609]
    cp b
    jr nc, $479f
    ld a, b
    ld [$c609], a
    ld a, d
    ld [$c608], a
    inc e
    ld a, e
    cp $06
    jr nz, $4759
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$c608]
    pop de
    pop bc
    ret
MapAI_TestPackedTacticalScoreOrdering::
    push bc
    push de
    ld b, a
    ld a, [$dbe1]
    and a
    jr z, $47c9
    ld a, b
    and $0f
    jr z, $47cc
    ld c, a
    ld a, b
    and $f0
    swap a
    ld b, a
    ld a, c
    cp b
    jr c, $47cc
    xor a
    jr $47ce
    ld a, $01
    pop de
    pop bc
    ret
MapAI_BuildAttackableEnemyMask::
    push bc
    push de
    push af
    xor a
    ld hl, $c5f4
    ld bc, $0007
    call $3b79
    pop af
    call $481f
    ld a, [$c9a3]
    ld d, a
    ld e, $32
    ld a, d
    ld c, $00
    call $090b
    and a
    jr z, $4818
    ld c, $18
    farcall UnitData_GetByte
    ld hl, $c602
    call $3ac7
    jr z, $4818
    ld a, d
    ld c, $03
    call $090b
    bit 0, a
    jr nz, $4818
    bit 1, a
    jr nz, $4818
    ld a, d
    ld hl, $c9a3
    sub [hl]
    ld hl, $c5f4
    call $3ad1
    inc d
    dec e
    jr nz, $47e8
    pop de
    pop bc
    ret
MapAI_BuildWeaponCapabilityScratch::
    push bc
    push de
    ld b, a
    xor a
    ld [$c605], a
    ld [$c606], a
    ld [$c607], a
    ld [$c602], a
    ld [$c603], a
    ld [$c604], a
    ld a, b
    ld c, $00
    call $090b
    ld d, a
    ld a, b
    ld c, $08
    call $090b
    and a
    jr z, $4866
    ld a, d
    ld c, $14
    farcall UnitData_GetByte
    and a
    jr z, $4866
    call $489e
    ld [$c603], a
    and a
    jr z, $4866
    bit 7, a
    jr z, $4866
    ld a, h
    swap a
    or l
    ld [$c606], a
    ld [$c605], a
    ld a, b
    ld c, $09
    call $090b
    and a
    jr z, $4890
    ld a, d
    ld c, $16
    farcall UnitData_GetByte
    and a
    jr z, $4890
    call $489e
    and a
    jr z, $4890
    bit 7, a
    jr z, $4890
    ld [$c604], a
    ld a, h
    swap a
    or l
    ld [$c607], a
    ld [$c605], a
    ld a, [$c603]
    ld e, a
    ld a, [$c604]
    or e
    ld [$c602], a
    pop de
    pop bc
    ret
MapAI_GetWeaponTargetMaskAndRange::
    push bc
    push de
    ld b, a
    call $48c6
    ld e, a
    ld a, b
    ld c, $08
    farcall WeaponData_GetByte
    cp $01
    jr nz, $48b2
    set 6, e
    ld d, a
    ld a, b
    ld c, $09
    farcall WeaponData_GetByte
    cp $02
    jr c, $48c0
    set 7, e
    ld h, a
    ld l, d
    ld a, e
    pop de
    pop bc
    ret
MapAI_BuildWeaponTargetClassMask::
    push bc
    push de
    ld e, a
    ld d, $05
    ld b, $00
    sla b
    ld a, d
    dec a
    add a, $0a
    ld c, a
    ld a, e
    farcall WeaponData_GetByte
    and a
    jr z, $48de
    set 0, b
    dec d
    jr nz, $48cd
    ld a, b
    pop de
    pop bc
    ret
MapAI_BuildReachableAttackTargetMask::
    push bc
    push de
    ldh a, [$ff82]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$c9d8]
    call $47d1
    ld hl, $c5fb
    ld bc, $0007
    xor a
    call $3b79
    call $5de7
    ld a, [$c610]
    ld c, a
    ld a, [$c60f]
    ld b, a
    call $08d7
    ld a, [hli]
    push hl
    cp $ff
    jr z, $4917
    call $492e
    pop hl
    inc b
    ld a, [$c611]
    cp b
    jr nc, $490e
    inc c
    ld a, [$c612]
    cp c
    jr nc, $4907
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    pop bc
    ret
MapAI_AccumulateTargetsFromCandidateCell::
    push bc
    push de
    ld a, [$c9a3]
    ld d, a
    ld e, $32
    ld a, d
    ld hl, $c9a3
    sub [hl]
    ld hl, $c5f4
    call $3ac7
    jr z, $495e
    ld a, d
    call $4965
    jr nz, $495e
    push de
    push bc
    ld a, d
    call $095e
    ld d, b
    ld e, c
    pop bc
    call $497b
    pop de
    cp $ff
    jr z, $495e
    ld a, d
    call $4970
    inc d
    dec e
    jr nz, $4936
    pop de
    pop bc
    ret
MapAI_TestEnemySearchMaskBit::
    ld hl, $c9a3
    sub [hl]
    ld hl, $c5fb
    call $3ac7
    ret
MapAI_SetEnemySearchMaskBit::
    ld hl, $c9a3
    sub [hl]
    ld hl, $c5fb
    call $3ad1
    ret
MapAI_GetDistanceIfWithinWeaponRange::
    push bc
    push de
    call $291d
    ld d, a
    ld a, [$c605]
    and $0f
    ld l, a
    ld a, d
    cp l
    jr c, $4998
    ld a, [$c605]
    and $f0
    swap a
    cp d
    jr c, $4998
    ld a, d
    jr $499a
    ld a, $ff
    pop de
    pop bc
    ret
MapAI_FindBestRangedAttackPosition::
    push de
    call $095e
    ld d, b
    ld e, c
    ldh a, [$ff82]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$c60a], a
    ld a, $ff
    ld [$c608], a
    ld [$c609], a
    ld c, $00
    ld b, $00
    call $08d7
    push hl
    call $5db5
    and a
    jr nz, $49e8
    call $497b
    cp $ff
    jr z, $49e8
    cp $01
    jr z, $49e8
    ld a, [$ccdd]
    call $4a07
    ld hl, $c60a
    cp [hl]
    jr c, $49e8
    ld [$c60a], a
    ld a, b
    ld [$c608], a
    ld a, c
    ld [$c609], a
    pop hl
    inc hl
    inc b
    ld a, [$c989]
    cp b
    jr nz, $49bf
    inc c
    ld a, [$c98a]
    cp c
    jr nz, $49ba
    ld a, [$c608]
    ld b, a
    ld a, [$c609]
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    ret
MapAI_GetAttackPositionTerrainScore::
    push bc
    push de
    push af
    call $0985
    ld d, a
    ld e, $00
    pop af
    push af
    push bc
    ld c, $18
    farcall UnitData_GetByte
    pop bc
    cp $02
    jr z, $4a24
    ld a, d
    farcall Battle_GetCoverValue
    ld e, a
    pop af
    ld b, d
    farcall Unit_CanRepairOnMapTile
    and a
    jr nz, $4a31
    ld a, e
    add a, $64
    ld e, a
    ld a, e
    pop de
    pop bc
    ret
MapAI_GetTargetPriorityListForUnitType::
    ld hl, $4a43
    call $3a93
    ret
MapAI_GetUnitTypeListProfileB::
    ld hl, $4af9
    call $3a93
    ret
    assert @ == $4a43
