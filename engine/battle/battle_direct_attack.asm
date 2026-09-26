include "macros/macros.inc"

; direct unit-vs-unit battle executor used by map-AI action ID 3.
; Caller contract is behavior-backed: B,C = staged battle coordinate, D = acting
; live-unit index, E = target live-unit index. The routine builds mirrored battle
; state, invokes the battle presentation/combat pipeline, and returns to map play.
; Internal calls stay byte-row exact pending separate sourcing of the adjacent
; battle setup family.

section "Direct Unit Attack Executor", romx[$43cf], bank[$0c]
Battle_ExecuteDirectUnitAttack::
    push bc
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, e
    ld [$c9e6], a
    farcall UnitRecord_GetExperienceRank
    ld [$c9e7], a
    call $464f
    call $4b67
    call $4c27
    ld a, [$dbca]
    srl a
    ld [$dbca], a
    ld a, [$dbdf]
    srl a
    ld [$dbdf], a
    ld a, [$dbc8]
    ld b, a
    ld a, [$dbc9]
    cp b
    jr c, $4421
    ld de, $dbca
    ld hl, $d377
    ld bc, $0006
    call $3b50
    ld de, $dbdf
    ld hl, $d37d
    ld bc, $0006
    call $3b50
    jr $4439
    ld de, $dbca
    ld hl, $d37d
    ld bc, $0006
    call $3b50
    ld de, $dbdf
    ld hl, $d377
    ld bc, $0006
    call $3b50
    ld a, $04
    farcall UnitAction_PresentActionEffect
    ld a, [$dbed]
    cp $32
    jr nz, $4452
    ld a, [$dbe5]
    ld b, a
    ld a, [$dbe6]
    ld c, a
    farcall Battle_PresentMaximumFlankMarker
    ld a, [$c685]
    bit 0, a
    jr z, $447b
    farcall MapCursor_Hide
    call $3056
    ld a, [$dbd0]
    ld b, a
    ld a, [$dbd1]
    ld c, a
    call $459b
    call $2e67
    call $07b4
    farcall BANK_16, Bank16_Entry_4325
    farcall MapControl_ReinitializeAfterResolution
    jr $447e
    call $4488
    call $4e85
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop bc
    ret
    assert @ == $4488
