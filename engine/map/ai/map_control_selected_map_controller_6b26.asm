include "macros/macros.inc"

section "Selected Map Control Controller", romx[$6b26], bank[$0b]
MapControl_RunSelectedMapController::
    ldh a, [$ff82]
    push af
    call $6b06
    farcall BANK_27, Bank27_Entry_5566
    xor a
    ld [$ca97], a
    ld [$ca98], a
    farcall MapAI_ResetPlannerScratchAndInitializePlayers
    call $6a23
    farcall BANK_0C, Bank0C_Entry_6867
    jr $6b47
MapControl_ReenterSelectedMapAfterResolution::
    call $69e6
    call $6d9a
    and a
    jp nz, $6ca5
    ld a, [$c997]
    cp $00
    jp nz, $6bac
    ld a, $01
    ld [$c997], a
    xor a
    ld [$c98e], a
    farcall MapCursor_UseNormalAnimation
    call $3056
    farcall BANK_0C, Bank0C_Entry_73A5
    farcall MapControl_UpdateForceStateIndicator
    farcall MapCursor_Show
    call $6d9a
    and a
    jp nz, $6ca5
    ld a, [$c633]
    and $01
    ld hl, $c631
    call $29bc
    ld a, [hl]
    cp $01
    jr nz, $6bac
    call $2633
    ld a, [$ca94]
    and a
    jp nz, $6ca5
    farcall MapControl_PrepareSelectedMapEndCommand
    call $746d
    ld a, [$c62f]
    cp $05
    jr nz, $6ba9
    ld a, [$c633]
    cp $02
    jp z, $6cae
    jp $6b47
    call $6d1e
    ld a, [$ca94]
    and a
    jp nz, $6ca5
    call $4654
    call $74fa
    ld a, [$ca91]
    and a
    jr nz, $6bee
    ld a, [$ca93]
    and a
    jp nz, $6b47
    ld a, [$ca92]
    inc a
    ld [$ca92], a
    cp $1e
    jp nz, $6b47
    ld a, [$c991]
    ld b, a
    ld a, [$c992]
    ld c, a
    farcall PropertyStateMeter_Setup
    cp $ff
    jp z, $6b47
    ld a, $01
    ld [$ca93], a
    jp $6b47
    xor a
    ld [$ca92], a
    ld a, [$ca93]
    and a
    jr z, $6c02
    call $4860
    call $46f9
    xor a
    ld [$ca93], a
    ldh a, [$ff90]
    bit 3, a
    jr nz, $6c63
    ld a, [$ca91]
    ld hl, $6cbb
    call $3a9e
    jp hl
    call $7525
    jp $6b47
    call $7564
    jp $6b47
    call $75db
    jp $6b47
    call $759c
    jp $6b47
    call $2164
    call $07b4
    ld a, [$c991]
    ld b, a
    ld a, [$c992]
    ld c, a
    farcall UnitRecord_FindPrimaryAtCoordinates
    cp $ff
    jr z, $6c54
    ld c, $00
    farcall UnitRecord_GetByte
    ld c, a
    and $01
    ld b, a
    ld a, c
    srl a
    farcall UnitReference_Open
    jp $6b44
    ld a, [$c633]
    and $01
    ld b, a
    ld a, $ff
    farcall UnitReference_Open
    jp $6b44
    call $6fca
    jp $6b47
    call $6f95
    and a
    jp nz, $6b47
    call $7226
    cp $01
    jp z, $6b44
    cp $00
    jp z, $6b47
    cp $03
    jr z, $6c88
    ld a, $01
    ld [$ca96], a
    jr $6cae
    ld a, [$c883]
    farcall MapRecord_SelectBeginner
    ld a, [$ca1f]
    ld [$c883], a
    ld [$c6a3], a
    call $4088
    call $6b06
    call $07b4
    jp $6b44
    ret
    call $2164
    call $6e6e
    call $6ed6
    call $2164
    ld a, $04
    ldh [$ff94], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $6cbb

section "Selected Map Control State Jump Table", romx[$6cbb], bank[$0b]
MapControl_SelectedMapStateJumpTable::
    db $69, $6c, $70, $6c, $2a, $6c, $63, $6c, $12, $6c, $18, $6c, $1e, $6c, $24, $6c
    db $c2, $6b
    assert @ == $6ccd

section "Selected Map Control HQ Coordinate Test", romx[$6ccd], bank[$0b]
MapControl_TestCurrentOrOpposingHQCoordinates::
    ld hl, $c646
    ld a, [$c633]
    and $01
    add a, a
    call $29bc
    ld b, [hl]
    inc hl
    ld c, [hl]
    ld a, [$c991]
    cp b
    jr nz, $6cf9
    ld a, [$c992]
    cp c
    jr nz, $6cf9
    ld hl, $c646
    ld a, [$c633]
    and $01
    xor $01
    add a, a
    call $29bc
    ld b, [hl]
    inc hl
    ld c, [hl]
    call $7b01
    ret
    assert @ == $6cfd
