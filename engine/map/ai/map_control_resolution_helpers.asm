include "macros/macros.inc"
include "constants/unit_constants.inc"

; byte-authoritative helpers reached by the Bank $0D map-control late-phase/refresh paths.
; Names are intentionally contract-oriented where player-facing event identity remains unresolved.

section "Map Control Resolution Scene Refresh", romx[$51b5], bank[$0b]
MapControl_ResolutionSceneRefresh::
    push bc
    push de
    push hl
    push af
    call $4700
    call $3056
    pop af
    call $51cd
    call $46f9
    call $3056
    pop hl
    pop de
    pop bc
    assert @ == $51cc

section "Map Control Phase Result Dispatch", romx[$7e5f], bank[$27]
MapSurrenderPrompt_Run::
    ld d, a
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, d
    ld [$dc6a], a
    call $07b4
    call $7cb7
    call $081d
    call $05a2
    call $3056
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    bit 0, a
    jr z, $7e8f
    ld a, $02
    call $3844
    jr $7ebe
    bit 4, a
    jr z, $7ea5
    xor a
    ld [$dc69], a
    ld a, $01
    call $3844
    ld bc, $070b
    farcall Gfx_DrawTwoChoiceHighlightFirst
    jr $7ebc
    bit 5, a
    jr z, $7ebc
    ld a, $01
    ld [$dc69], a
    ld a, $01
    call $3844
    ld bc, $070b
    farcall Gfx_DrawTwoChoiceHighlightSecond
    jr $7ebc
    jr $7e76
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $070b
    ld de, $0501
    xor a
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $070b
    ld de, $0501
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$dc69]
    call $7d5c
    call $05a2
    call $3056
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    bit 0, a
    jr z, $7f07
    ld a, $02
    call $3844
    jr $7f09
    jr $7eee
    call $07b4
    ld a, [$dc69]
    ld d, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, d
    ret
    assert @ == $7f17

section "Campaign Resolution Counter Increment", romx[$4d74], bank[$11]
CampaignStats_IncrementResolutionCounter::
    ld hl, $c77c
    call $4dba
    ret
    assert @ == $4d7b

section "Map Control Resolution Reinitialize", romx[$69e6], bank[$0b]
MapControl_ReinitializeAfterResolution::
    call $04f3
    call $0f02
    call $4000
    call $45c1
    call $428a
    call $081d
    xor a
    ld [$ca92], a
    ld [$ca93], a
    ld [$ca94], a
    ld [$ca95], a
    ld [$ca96], a
    ld [$c9a1], a
    set 0, a
    ldh [$ffb1], a
    farcall MapControl_UpdateForceStateIndicator
    ld b, $00
    ld a, [$c633]
    and $01
    jr z, $6a1e
    ld b, $32
    ld a, b
    ld [$ca99], a
    ret
    assert @ == $6a23

section "Map Control Phase Analysis Workspace", romx[$58a2], bank[$0d]
MapControl_BuildMovementCostField::
    push bc
    push de
    push bc
    ld c, $19
    farcall UnitData_GetByte
    farcall MovementData_BuildMapTileCosts
    call $0593
    ld a, $0d
    call $058d
    ld a, $ff
    ld hl, $a000
    ld bc, $2000
    call $3b79
    call $059b
    ld hl, $ffa3
    ld de, $58f2
    call $08c0
    ld de, $590f
    call $08c0
    ld de, $593d
    call $08c0
    ld de, $5928
    call $08c0
    pop bc
    call $0593
    ld a, $0d
    call $058d
    call $0850
    call $059b
    pop de
    pop bc
    ret
    assert @ == $58f2

section "Map Control Phase Route River Search", romx[$59d4], bank[$0d]
MapControl_FindRouteRiverReference::
    push de
    ldh a, [$ff82]
    push af
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    call $5da5
    ld a, $68
    call $58a2
    call $0593
    ld a, $0d
    call $058d
    call $5d9c
    ld a, $ff
    ldh [$ff9b], a
    ldh [$ff9c], a
    ld a, $a0
    call $08e6
    ld a, [hl]
    ldh [$ff99], a
    ld e, a
    ld a, h
    add a, $10
    ld h, a
    ld a, [hl]
    ldh [$ff9a], a
    and e
    cp $ff
    jr z, $5a76
    ldh a, [$ff99]
    ld l, a
    ldh a, [$ff9a]
    ld h, a
    or l
    jr z, $5a76
    push hl
    call $08d7
    ld a, [hl]
    and $3f
    ld e, a
    cp $28
    jr nz, $5a27
    ld a, b
    ldh [$ff9b], a
    ld a, c
    ldh [$ff9c], a
    ld d, $00
    ld hl, $cd43
    add hl, de
    ld a, [hl]
    cpl
    inc a
    ld e, a
    ld d, $ff
    pop hl
    add hl, de
    ld a, l
    ldh [$ff99], a
    ld a, h
    ldh [$ff9a], a
    ld e, $00
    push bc
    push de
    call $28d9
    jr c, $5a63
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
    ld e, [hl]
    ld a, h
    add a, $10
    ld h, a
    ld d, [hl]
    ldh a, [$ff99]
    ld l, a
    ldh a, [$ff9a]
    ld h, a
    call $29ca
    jr z, $5a6d
    pop de
    pop bc
    inc e
    ld a, e
    cp $06
    jr nz, $5a3d
    jr $5a71
    pop de
    pop de
    jr $59f7
    call $05a2
    jr $5a71
    ldh a, [$ff9b]
    ld b, a
    ldh a, [$ff9c]
    ld c, a
    call $059b
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    ret
    assert @ == $5a86

section "Map Control Phase Side Pair", romx[$5d9c], bank[$0d]
MapControl_GetOpposingPhaseSidePair::
    ld a, [$c633]
    and $01
    xor $01
    jr $5daa
MapControl_GetCurrentPhaseSidePair::
    ld a, [$c633]
    and $01
    add a, a
    ld hl, $c646
    call $29bc
    ld b, [hl]
    inc hl
    ld c, [hl]
    ret
    assert @ == $5db5

section "Map Control Transport Route Candidates", romx[$5a86], bank[$0d]
MapControl_FindTransportRouteCandidates::
    push bc
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    call $5ac2
    ld a, b
    cp $ff
    jr z, $5abb
    ld [$de9c], a
    ld a, c
    ld [$de9d], a
    ld a, $60
    call $58a2
    call $5b1a
    ld a, b
    cp $ff
    jr z, $5abb
    ld [$de9e], a
    ld a, c
    ld [$de9f], a
    ld a, [$dea0]
    set 2, a
    ld [$dea0], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop bc
    ret
    assert @ == $5ac2
