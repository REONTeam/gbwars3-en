include "macros/macros.inc"
include "constants/unit_constants.inc"

; direct-attack planner support immediately after the capture-target
; mask builder and before the earlier procurement planner. Public boundaries
; are proven by direct calls from the earlier attack-planner families. Deeper
; ranking formulas remain exact byte rows until their scratch contracts are
; independently typed.

section "Map AI Direct Attack Planner Support", romx[$4be1], bank[$0d]
MapAI_PrepareDirectAttackCandidate::
    call $4be5
    ret
MapAI_PrepareDirectAttackCandidateCore::
    push de
    ldh a, [$ff82]
    push af
    ld de, $0000
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, e
    ld hl, $dd80
    call $3ac7
    jr z, $4c22
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    ld hl, $dd81
    add hl, de
    add hl, de
    add hl, de
    push de
    ld a, [hli]
    ld d, [hl]
    inc hl
    ld e, [hl]
    inc hl
    call $291d
    pop de
    cp $04
    jr nc, $4c22
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, e
    ld hl, $dd80
    call $3adc
    inc e
    ld a, e
    cp $64
    jr nz, $4bec
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    ret
    ld h, a
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, h
    ld hl, $dd80
    call $3ac7
    jr z, $4c46
    ld h, $00
    jr $4c48
    ld h, $01
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, h
    ret
MapAI_FindDirectAttackTargetFamily0::
    push de
    ldh a, [$ff82]
    push af
    ld a, $ff
    ldh [$ff9d], a
    ldh [$ff99], a
    ldh [$ff9a], a
    ldh [$ff9c], a
    call $5de7
    ld a, [$c610]
    ld c, a
    ld a, [$c60f]
    ld b, a
    call $08d7
    push hl
    push hl
    call $5db5
    pop hl
    and a
    jr nz, $4cad
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [hl]
    and $3f
    farcall MapControl_IsCaptureTargetRejected
    and a
    jr nz, $4cad
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    ld e, [hl]
    push hl
    farcall PropertyState_GetAtCoordinates
    ld d, a
    ld hl, $ff9c
    cp [hl]
    pop hl
    jr c, $4ca1
    jr nz, $4cad
    ld a, e
    ld hl, $ff9d
    cp [hl]
    jr nc, $4cad
    ld a, d
    ldh [$ff9c], a
    ld a, e
    ldh [$ff9d], a
    ld a, b
    ldh [$ff99], a
    ld a, c
    ldh [$ff9a], a
    pop hl
    inc hl
    inc b
    ld a, [$c611]
    cp b
    jr nc, $4c6b
    inc c
    ld a, [$c612]
    cp c
    jr nc, $4c64
    ldh a, [$ff99]
    ld b, a
    ldh a, [$ff9a]
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    ret
MapAI_FindDirectAttackApproachFamily0::
    push de
    ldh a, [$ff82]
    push af
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $ff
    ldh [$ff9d], a
    ldh [$ff99], a
    ldh [$ff9a], a
    ld a, [$ccde]
    ld d, a
    ld a, [$ccdf]
    ld e, a
    xor a
    ldh [$ff9b], a
    ldh a, [$ff9b]
    call $4c2f
    and a
    jr nz, $4d24
    ldh a, [$ff9b]
    ld b, $00
    ld c, a
    ld hl, $dd81
    add hl, bc
    add hl, bc
    add hl, bc
    ld a, [hli]
    cp $ff
    jr z, $4d24
    ld b, [hl]
    inc hl
    ld c, [hl]
    call $5d2b
    and a
    jr nz, $4d24
    call $08d7
    ld a, [hl]
    and $3f
    farcall MapControl_IsCaptureTargetRejected
    and a
    call $291d
    ld hl, $ff9d
    cp [hl]
    jr nc, $4d24
    ldh [$ff9d], a
    ld a, b
    ldh [$ff99], a
    ld a, c
    ldh [$ff9a], a
    ldh a, [$ff9b]
    inc a
    ldh [$ff9b], a
    cp $64
    jr nz, $4ce7
    ldh a, [$ff99]
    ld b, a
    ldh a, [$ff9a]
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    ret
MapAI_FindDirectAttackTargetFamily1::
    push de
    ldh a, [$ff82]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $ff
    ldh [$ff9d], a
    ldh [$ff99], a
    ldh [$ff9a], a
    call $5de7
    ld a, [$c610]
    ld c, a
    ld a, [$c60f]
    ld b, a
    call $08d7
    push hl
    ld d, [hl]
    call $5db5
    and a
    jr nz, $4d7c
    call $4e28
    ld e, a
    ld a, [$cce5]
    cp e
    jr c, $4d7c
    ld a, d
    ld hl, $ff9d
    cp [hl]
    jr nc, $4d7c
    ld a, d
    ldh [$ff9d], a
    ld a, b
    ldh [$ff99], a
    ld a, c
    ldh [$ff9a], a
    pop hl
    inc hl
    inc b
    ld a, [$c611]
    cp b
    jr nc, $4d5a
    inc c
    ld a, [$c612]
    cp c
    jr nc, $4d53
    ldh a, [$ff99]
    ld b, a
    ldh a, [$ff9a]
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    ret
MapAI_FindDirectAttackApproachFamily1::
    push de
    ldh a, [$ff82]
    push af
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    call $0593
    ld a, $0d
    call $058d
    ld a, $ff
    ldh [$ff99], a
    ldh [$ff9a], a
    ldh [$ff9d], a
    ldh [$ff9d], a
    xor a
    ldh [$ff9b], a
    ld hl, $dd81
    ld a, [hli]
    ld b, [hl]
    inc hl
    ld c, [hl]
    inc hl
    ldh [$ff9c], a
    push hl
    cp $ff
    jr z, $4e0e
    call $4e28
    ld e, a
    ld a, [$cce5]
    cp e
    jr c, $4e0e
    call $08d7
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld e, [hl]
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, e
    and $7f
    jr nz, $4e0e
    ld a, h
    add a, $d0
    ld h, a
    ld a, [hl]
    cp $ff
    jr z, $4e0e
    ld e, a
    ld a, h
    add a, $10
    ld h, a
    ld d, [hl]
    ldh a, [$ff9d]
    ld l, a
    ldh a, [$ff9d]
    ld h, a
    call $29ca
    jr nc, $4e0e
    ld a, e
    ldh [$ff9d], a
    ld a, d
    ldh [$ff9d], a
    ld a, b
    ldh [$ff99], a
    ld a, c
    ldh [$ff9a], a
    pop hl
    ldh a, [$ff9b]
    inc a
    ldh [$ff9b], a
    cp $64
    jr nz, $4dbb
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
    push de
    call $0985
    ld d, a
    farcall MapTile_IsNeutralPropertyRuins
    and a
    jr z, $4e47
    ld a, d
    farcall MapTile_ClassifyOwnershipForCurrentPhase
    cp $00
    jr nz, $4e4b
    farcall PropertyState_CompareCurrentToTerrainMaximum
    jr z, $4e4b
    ld a, $01
    jr $4e4d
    ld a, $02
    jr $4e4d
    ld a, $ff
    pop de
    ret
    db $cd, $94, $4e, $c9
    assert @ == $4e53
