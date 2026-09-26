include "macros/macros.inc"
include "constants/unit_constants.inc"

; Bank $0D analysis/search helpers used by map-control phase refresh.
; corrects routine boundaries that previously split instructions; bytes remain retail-exact.
; Routines retain conservative contract names where higher-level AI/action meaning is not yet proven.

section "MapControl Movement Cost Seed", romx[$58f2], bank[$0d]
MapControl_SeedMovementCostField::
    xor a
    ldh [$ff99], a
    ldh [$ff9a], a
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add a, $a0
    ld h, a
    ld a, l
    and $f0
    add a, b
    ld l, a
    ld de, $0000
    call $5928
    call $08c5
    ret
    assert @ == $590f

section "MapControl Movement Cost Load", romx[$590f], bank[$0d]
MapControl_LoadMovementCostFieldCell::
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add a, $a0
    ld h, a
    ld a, l
    and $f0
    add a, b
    ld l, a
    ld a, [hl]
    ldh [$ff99], a
    ld a, h
    add a, $10
    ld h, a
    ld a, [hl]
    ldh [$ff9a], a
    ret
    assert @ == $5928

section "MapControl Movement Cost Store", romx[$5928], bank[$0d]
MapControl_StoreMovementCostFieldCell::
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add a, $a0
    ld h, a
    ld a, l
    and $f0
    add a, b
    ld l, a
    ld [hl], e
    ld a, h
    add a, $10
    ld h, a
    ld [hl], d
    ret
    assert @ == $593d

section "MapControl Movement Cost Candidate Test", romx[$593d], bank[$0d]
MapControl_TestMovementCostFieldCandidate::
    push bc
    ldh a, [$ff82]
    push af
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add a, $d0
    ld h, a
    ld a, l
    and $f0
    add a, b
    ld l, a
    ld a, [hl]
    and $3f
    ld e, a
    ld d, $00
    ld hl, $cd43
    add hl, de
    ld a, [hl]
    and a
    jr z, $5993
    ld e, a
    ld d, $00
    ldh a, [$ff99]
    ld l, a
    ldh a, [$ff9a]
    ld h, a
    add hl, de
    ld d, h
    ld e, l
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add a, $a0
    ld h, a
    ld a, l
    and $f0
    add a, b
    ld l, a
    push hl
    push bc
    ld c, [hl]
    ld a, h
    add a, $10
    ld h, a
    ld h, [hl]
    ld l, c
    pop bc
    call $29ca
    pop hl
    jr nc, $5991
    ld b, $00
    jr $5993
    ld b, $01
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, b
    pop bc
    ret
    assert @ == $599b

section "MapControl_ClearNeighborPhaseReferences", romx[$599b], bank[$0d]
MapControl_ClearNeighborPhaseReferences::
    push bc
    push de
    call $0593
    ld a, $0d
    call $058d
    ld e, $00
    push de
    push bc
    call $28d9
    ld d, b
    ld e, c
    pop bc
    jr c, $59c7
    ld a, e
    rrca
    rrca
    ld l, a
    and $0f
    add a, $a0
    ld h, a
    ld a, l
    and $f0
    add a, d
    ld l, a
    ld d, $ff
    ld [hl], d
    ld a, h
    add a, $10
    ld h, a
    ld [hl], d
    pop de
    inc e
    ld a, e
    cp $06
    jr nz, $59a7
    call $059b
    pop de
    pop bc
    ret
    assert @ == $59d4

section "MapControl_FindNearestPortRecordToCurrentHQ", romx[$5ac2], bank[$0d]
MapControl_FindNearestPortRecordToCurrentHQ::
    push de
    ldh a, [$ff82]
    push af
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $ff
    ldh [$ff9a], a
    ldh [$ff9b], a
    ldh [$ff99], a
    ld e, $00
    ld hl, $dd81
    push de
    ld a, [hli]
    ld b, [hl]
    inc hl
    ld c, [hl]
    inc hl
    push hl
    cp $ff
    jr z, $5b05
    call $0985
    call $099b
    cp $09
    jr nz, $5b05
    ld d, b
    ld e, c
    call $5da5
    call $291d
    ld l, a
    ldh a, [$ff99]
    cp l
    jr c, $5b05
    ld a, l
    ldh [$ff99], a
    ld a, d
    ldh [$ff9a], a
    ld a, e
    ldh [$ff9b], a
    pop hl
    pop de
    inc e
    ld a, e
    cp $64
    jr nz, $5ad9
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ldh a, [$ff9a]
    ld b, a
    ldh a, [$ff9b]
    ld c, a
    pop de
    ret
    assert @ == $5b1a

section "MapControl_FindNearestOpposingHQRegionCell", romx[$5b1a], bank[$0d]
MapControl_FindNearestOpposingHQRegionCell::
    push de
    call $0593
    ld a, $ff
    ldh [$ff9a], a
    ldh [$ff9b], a
    ldh [$ff9c], a
    ld a, $0c
    call $058d
    call $5d9c
    ld a, $a0
    call $08e6
    ld a, [hl]
    ldh [$ff99], a
    ld c, $00
    ld b, $00
    ld a, $0c
    call $058d
    ld a, $a0
    call $08e6
    ldh a, [$ff99]
    cp [hl]
    jr nz, $5b71
    ld a, $0d
    call $058d
    ld a, $a0
    call $08e6
    ld a, [hl]
    cp $ff
    jr z, $5b71
    push bc
    ld d, b
    ld e, c
    call $5d9c
    call $291d
    ld d, a
    pop bc
    ldh a, [$ff9a]
    cp d
    jr c, $5b71
    ld a, d
    ldh [$ff9a], a
    ld a, b
    ldh [$ff9b], a
    ld a, c
    ldh [$ff9c], a
    inc b
    ld a, [$c989]
    cp b
    jr nz, $5b3a
    inc c
    ld a, [$c98a]
    cp c
    jr nz, $5b38
    ldh a, [$ff9b]
    ld b, a
    ldh a, [$ff9c]
    ld c, a
    call $059b
    pop de
    ret
    assert @ == $5b8a

section "MapControl_StageAnalysisCoordinates", romx[$5b8a], bank[$0d]
MapControl_StageAnalysisCoordinates::
    push bc
    push de
    ld e, a
    ld c, $00
    call $090b
    ld [$c9c5], a
    ld a, e
    ld c, $07
    call $090b
    ld [$c9c6], a
    ld a, e
    call $095e
    ld a, b
    ld [$c9c7], a
    ld a, c
    ld [$c9c8], a
    xor a
    ld [$c9dd], a
    farcall MapRuntime_BuildCoordinateAnalysisWorkspace
    pop de
    pop bc
    ret
    assert @ == $5bb5

section "MapControl_FindNearestEligibleCell", romx[$5bb5], bank[$0d]
MapControl_FindNearestEligibleCell::
    push de
    ldh a, [$ff82]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0d
    call $058d
    call $0593
    call $5de7
    ld de, $ffff
    ld a, $ff
    ldh [$ff99], a
    ldh [$ff9a], a
    ld a, [$c610]
    ld c, a
    ld a, [$c60f]
    ld b, a
    call $08d7
    push hl
    ld a, [hl]
    cp $ff
    jr z, $5c22
    and a
    jr nz, $5bf0
    ld a, [$cce0]
    bit 0, a
    jr nz, $5c22
    jr $5c03
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [hl]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    pop af
    and $7f
    jr nz, $5c22
    push bc
    ld a, h
    add a, $d0
    ld h, a
    ld c, [hl]
    ld a, h
    add a, $10
    ld h, a
    ld h, [hl]
    ld l, c
    pop bc
    ld a, l
    cp $ff
    jr z, $5c22
    call $29ca
    jr c, $5c22
    ld d, h
    ld e, l
    ld a, b
    ldh [$ff99], a
    ld a, c
    ldh [$ff9a], a
    pop hl
    inc hl
    inc b
    ld a, [$c611]
    cp b
    jr nc, $5bde
    inc c
    ld a, [$c612]
    cp c
    jr nc, $5bd7
    ldh a, [$ff99]
    ld b, a
    ldh a, [$ff9a]
    ld c, a
    call $059b
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    ret
    assert @ == $5c42

section "MapControl_UpdateDerivedCellState", romx[$5cbc], bank[$0d]
MapControl_UpdateDerivedCellState::
    call $08c5
    ret
    assert @ == $5cc0

section "MapControl_ClassifyDerivedCell", romx[$5cc0], bank[$0d]
MapControl_ClassifyDerivedCell::
    push bc
    ldh a, [$ff82]
    push af
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add a, $d0
    ld h, a
    ld a, l
    and $f0
    add a, b
    ld l, a
    ld a, [hl]
    and $3f
    cp $2a
    jr z, $5ce3
    cp $29
    jr nc, $5cfc
    ld e, a
    ld a, h
    add a, $d0
    ld h, a
    ld a, [hl]
    and a
    jr nz, $5cfc
    ldh a, [$ff99]
    ld [hl], a
    ld a, e
    cp $20
    jr nc, $5cf8
    ld hl, $ff9a
    inc [hl]
    ld b, $00
    jr $5cfe
    ld b, $01
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, b
    pop bc
    ret
    assert @ == $5d06

section "MapControl_RemoveDerivedBufferValue", romx[$5d06], bank[$0d]
MapControl_RemoveDerivedBufferValue::
    push bc
    push de
    ld e, a
    ld c, $00
    ld b, $00
    ld a, $a0
    call $08e6
    ld a, [hl]
    cp e
    jr nz, $5d19
    ld a, $ff
    ld [hl], a
    inc hl
    inc b
    ld a, [$c989]
    cp b
    jr nz, $5d12
    inc c
    ld a, [$c98a]
    cp c
    jr nz, $5d0b
    pop de
    pop bc
    ret
    assert @ == $5d2b

section "MapControl_TestDerivedCellMatch", romx[$5d2b], bank[$0d]
MapControl_TestDerivedCellMatch::
    push bc
    push de
    call $0593
    ld a, $0c
    call $058d
    ld a, $a0
    call $08e6
    ld a, [hl]
    cp $ff
    jr z, $5d4e
    ld b, d
    ld c, e
    ld d, a
    ld a, $a0
    call $08e6
    ld a, [hl]
    cp d
    jr nz, $5d4e
    xor a
    jr $5d50
    ld a, $01
    call $059b
    pop de
    pop bc
    ret
    assert @ == $5d56

section "MapControl_BuildPhaseUnitFlags", romx[$5d56], bank[$0d]
MapControl_BuildPhaseUnitFlags::
    push bc
    push de
    ld e, $00
    ld b, a
    ld c, $00
    call $090b
    ld d, a
    ld a, b
    ld c, $08
    call $090b
    and a
    jr z, $5d7c
    ld a, d
    ld c, $14
    farcall UnitData_GetByte
    and a
    jr z, $5d7c
    call $489e
    bit 6, a
    jr z, $5d7c
    ld e, a
    ld a, b
    ld c, $09
    call $090b
    and a
    jr z, $5d98
    ld a, d
    ld c, $16
    farcall UnitData_GetByte
    and a
    jr z, $5d98
    call $489e
    bit 6, a
    jr z, $5d98
    or e
    ld e, a
    ld a, e
    pop de
    pop bc
    ret
    assert @ == $5d9c
