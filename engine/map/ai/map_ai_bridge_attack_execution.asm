include "macros/macros.inc"

; local map-AI staging for bridge construction and direct attacks.

section "Map AI Bridge Construction Staging", romx[$469f], bank[$0d]

MapAI_ExecuteBridgeConstruction::
    farcall $0b, MapControl_PanToCoordinates
    push bc
    ld a, $0f
    call $3baf
    pop bc
    farcall $0b, Unit_BuildBridgeAtCoordinates
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_CopyToScratch
    ret
    push bc ; first opcode of the following retail helper; continuation starts at $46B7

    assert @ == $46b7

section "Map AI Direct Attack Staging", romx[$471d], bank[$0d]

MapAI_ExecuteDirectAttack::
    push bc
    push de
    ld a, [$c5f0]
    ld b, a
    ld a, [$c5f1]
    ld c, a
    farcall $0b, MapControl_PanToCoordinates
    ld a, [wMapAIActionX]
    ld b, a
    ld a, [wMapAIActionY]
    ld c, a
    ld a, [wMapAIActiveUnitIndex]
    ld d, a
    ld a, [$c5ef]
    ld e, a
    farcall $0c, Battle_ExecuteDirectUnitAttack
    farcall $0b, MapControl_PostDirectAttackUpdate
    call $66b1
    pop de
    pop bc
    ret

    assert @ == $4749
