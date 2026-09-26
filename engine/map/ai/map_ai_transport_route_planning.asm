include "macros/macros.inc"
include "constants/unit_constants.inc"

; close the Bank $0D transport-routing gap between the phase-side helper
; and the bridge/direct-attack planner.  The routines are kept byte-row exact where
; their deeper status-bit meaning is not yet fully named, but public boundaries and
; the air/sea transport identities are proven by unit-type tests and route inputs.

section "Map AI Transport Route Planning", romx[$5db5], bank[$0d]
MapAI_TestTransportPlanningCellAvailable::
    ldh a, [$ff82]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [hl]
    cp $ff
    jr z, $5dde
    and a
    jr z, $5dd3
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [hl]
    and $7f
    jr nz, $5dde
    jr $5dda
    ld a, [$cce0]
    bit 0, a
    jr nz, $5dde
    ld h, $00
    jr $5de0
    ld h, $01
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, h
    ret
MapAI_BuildTransportSearchBounds::
    push bc
    push de
    ld a, [$ccdd]
    ld c, $0c
    farcall UnitData_GetByte
    ld e, a
    ld a, [$ccde]
    ld b, a
    ld a, [$ccdf]
    ld c, a
    ld a, b
    sub e
    jr nc, $5e00
    xor a
    ld [$c60f], a
    ld a, b
    add a, e
    ld hl, $c989
    cp [hl]
    jr c, $5e0d
    ld a, [hl]
    dec a
    ld [$c611], a
    ld a, c
    sub e
    jr nc, $5e15
    xor a
    ld [$c610], a
    ld a, c
    add a, e
    ld hl, $c98a
    cp [hl]
    jr c, $5e22
    ld a, [hl]
    dec a
    ld [$c612], a
    pop de
    pop bc
    ret
MapAI_TryTransportSupportAction::
    push bc
    push de
    ld a, [$cce0]
    bit 0, a
    jr nz, $5e67
    call $60fa
    cp $ff
    jr z, $5e67
    ld d, a
    call $095e
    ldh a, [$ff82]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    call $08d7
    ld e, [hl]
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, e
    cp $ff
    jr z, $5e67
    ld a, [$ccde]
    ld b, a
    ld a, [$ccdf]
    ld c, a
    farcall MapControl_PanToCoordinates
    ld a, d
    call $4676
    ld a, $01
    jr $5e68
    xor a
    pop de
    pop bc
    ret
MapAI_TestTransportUnitDefinitionField0D::
    push bc
    ld c, $0d
    farcall UnitData_GetByte
    pop bc
    and a
    ret
MapAI_TestTransportUnitTerrainCompatibility::
    push bc
    ld d, a
    ld c, $00
    call $090b
    ld c, $18
    farcall UnitData_GetByte
    cp $03
    jr nc, $5eb8
    cp $02
    jr z, $5e9e
    ld a, d
    call $095e
    call $0985
    call $099b
    cp $14
    jr nc, $5eb3
    cp $10
    jr z, $5eb3
    jr $5eb0
    ld a, d
    call $095e
    call $0985
    call $099b
    cp $14
    jr nc, $5eb3
    cp $10
    jr z, $5eb3
    xor a
    jr $5ec4
    ld a, $01
    and a
    jr $5ec4
    ld a, d
    call $095e
    call $0985
    call $099b
    cp $09
    pop bc
    ret
MapAI_UpdateTransportUnitRouteStatus::
    push bc
    push de
    ld d, a
    ld c, $03
    call $090b
    and $30
    cp $00
    jr z, $5ed4
    ld a, d
    call $5e75
    jr nz, $5eec
    ld a, d
    ld c, $03
    call $090b
    and $30
    or $10
    ld b, a
    ld a, d
    ld c, $03
    farcall UnitRecord_SetByte
    pop de
    pop bc
    ret
MapAI_NoTransportCandidateStub::
    push bc
    push de
    ldh a, [$ff82]
    push af
    ld a, $0d
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$dea0]
    bit 0, a
    jr nz, $5f01
    ld b, $ff
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, b
    pop de
    pop bc
    ret
MapAI_RunAirTransportRouting::
    ld a, [$c9a2]
    ld [$c5eb], a
    ld e, $32
    ld a, [$c5eb]
    call $652d
    and a
    jr z, $5f30
    srl a
    cp $25
    jr z, $5f2d
    cp $2a
    jr z, $5f2d
    cp $2b
    jr z, $5f2d
    jr $5f30
    call $5f3e
    ld a, [$ca94]
    and a
    jr nz, $5f3d
    ld hl, $c5eb
    inc [hl]
    dec e
    jr nz, $5f14
    ret
MapAI_ProcessAirTransportUnit::
    push de
    ld a, [$c5eb]
    call $4510
    call $5f74
    ld a, [$cce0]
    and $30
    cp $10
    jr z, $5f6b
    cp $20
    jr z, $5f6d
    call $5fec
    ld a, [$ccdd]
    call $58a2
    call $5bb5
    ld a, b
    cp $ff
    jr z, $5f72
    call $4546
    jr $5f72
    jr $5f72
    call $5ff0
    jr $5f72
    pop de
    ret
MapAI_UpdateAirTransportRouteState::
    push bc
    push de
    ld a, [$cce0]
    and $30
    cp $00
    jr z, $5f8b
    cp $10
    jr z, $5fac
    cp $20
    jr z, $5fc8
    cp $30
    jr z, $5fc8
    call $5da5
    ld d, b
    ld e, c
    ld a, [$ccde]
    ld b, a
    ld a, [$ccdf]
    ld c, a
    call $291d
    cp $06
    jr nc, $5fd8
    ld a, [$c5eb]
    call $5e75
    jr nz, $5fd8
    ld b, $10
    call $5fdb
    ld a, [$ccdd]
    ld c, $0d
    farcall UnitData_GetByte
    ld d, a
    ld a, [$c5eb]
    ld c, $05
    call $090b
    cp d
    jr nz, $5fd8
    ld b, $20
    call $5fdb
    jr $5fd8
    ld a, [$c5eb]
    ld c, $05
    call $090b
    and a
    jr nz, $5fd8
    ld b, $00
    call $5fdb
    pop de
    pop bc
    ret
MapAI_StoreAirTransportRouteState::
    ld a, [$cce0]
    and $cf
    or b
    ld [$cce0], a
    ld a, [$c5eb]
    farcall UnitRecord_CopyFromScratch
    ret
MapAI_GetCurrentSideHQForAirTransport::
    call $5da5
    ret
MapAI_RouteAirTransportTowardOpposingHQ::
    call $5d9c
    ld a, [$ccdd]
    call $58a2
    call $5bb5
    ld a, b
    cp $ff
    jr z, $6004
    call $4546
    ret
MapAI_RunTransportShipRouting::
    ld a, [$c9a2]
    ld [$c5eb], a
    ld e, $32
    ld a, [$c5eb]
    call $652d
    and a
    jr z, $601f
    srl a
    cp $30
    jr nz, $601f
    call $602d
    ld a, [$ca94]
    and a
    jr nz, $602c
    ld hl, $c5eb
    inc [hl]
    dec e
    jr nz, $600d
    ret
MapAI_ProcessTransportShip::
    push de
    ld a, [$c5eb]
    call $4510
    call $6063
    ld a, [$cce0]
    and $30
    cp $10
    jr z, $605a
    cp $20
    jr z, $605c
    call $60d7
    ld a, [$ccdd]
    call $58a2
    call $5bb5
    ld a, b
    cp $ff
    jr z, $6061
    call $4546
    jr $6061
    jr $6061
    call $60e0
    jr $6061
    pop de
    ret
MapAI_UpdateTransportShipRouteState::
    push bc
    push de
    ld a, [$cce0]
    and $30
    cp $00
    jr z, $6076
    cp $10
    jr z, $6097
    cp $20
    jr z, $60b3
    call $5da5
    ld d, b
    ld e, c
    ld a, [$ccde]
    ld b, a
    ld a, [$ccdf]
    ld c, a
    call $291d
    cp $06
    jr nc, $60c3
    ld a, [$c5eb]
    call $5e75
    jr nz, $60c3
    ld b, $10
    call $60c6
    ld a, [$ccdd]
    ld c, $0d
    farcall UnitData_GetByte
    ld d, a
    ld a, [$c5eb]
    ld c, $05
    call $090b
    cp d
    jr nz, $60c3
    ld b, $20
    call $60c6
    jr $60c3
    ld a, [$c5eb]
    ld c, $05
    call $090b
    and a
    jr nz, $60c3
    ld b, $00
    call $60c6
    pop de
    pop bc
    ret
MapAI_StoreTransportShipRouteState::
    ld a, [$cce0]
    and $cf
    or b
    ld [$cce0], a
    ld a, [$c5eb]
    farcall UnitRecord_CopyFromScratch
    ret
MapAI_GetTransportPortCandidateCoordinates::
    ld a, [$de9c]
    ld b, a
    ld a, [$de9d]
    ld c, a
    ret
MapAI_RouteTransportShipTowardApproach::
    ld a, [$de9e]
    ld b, a
    ld a, [$de9f]
    ld c, a
    ld a, [$ccdd]
    call $58a2
    call $5bb5
    ld a, b
    cp $ff
    jr z, $60f9
    call $4546
    ret
MapAI_FindNearestCompatibleTransportUnit::
    push bc
    push de
    ld a, $ff
    ldh [$ff9c], a
    ldh [$ff9d], a
    ld a, [$c5eb]
    ld c, $00
    call $090b
    ldh [$ff9a], a
    ld a, [$c9a2]
    ldh [$ff99], a
    ld e, $32
    push de
    ldh a, [$ff99]
    ld c, $00
    call $090b
    and a
    jr z, $6175
    ldh [$ff9b], a
    ldh a, [$ff99]
    ld c, $03
    call $090b
    bit 0, a
    jr nz, $6175
    bit 1, a
    jr nz, $6175
    and $30
    cp $10
    jr nz, $6175
    ldh a, [$ff9a]
    ld b, a
    ldh a, [$ff9b]
    farcall UnitData_CheckLoadingCompatibility
    jr nz, $6175
    ldh a, [$ff9b]
    ld c, $0d
    farcall UnitData_GetByte
    ld b, a
    ldh a, [$ff99]
    ld c, $05
    call $090b
    cp b
    jr z, $6175
    ld a, [$c5eb]
    call $095e
    ld d, b
    ld e, c
    ldh a, [$ff99]
    call $095e
    call $5d2b
    and a
    jr nz, $6175
    call $291d
    ld hl, $ff9c
    cp [hl]
    jr nc, $6175
    ldh [$ff9c], a
    ldh a, [$ff99]
    ldh [$ff9d], a
    pop de
    ldh a, [$ff99]
    inc a
    ldh [$ff99], a
    dec e
    jr nz, $6113
    ldh a, [$ff9d]
    pop de
    pop bc
    ret
    assert @ == $6183
