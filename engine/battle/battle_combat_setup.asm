include "macros/macros.inc"
include "constants/unit_constants.inc"
include "constants/battle_scene_side_state.inc"

; Bank $0C battle setup / presentation gap between the direct-attack
; executor and the already-source-owned Cover/combat runtime. The $464F path
; builds the mirrored 21-byte battle participant records; the direct-attack
; executor copies their first six bytes into the $D377-$D382 scene records.
; Those bytes are therefore Unit type, old/displayed HP, new/target HP, terrain,
; used weapon, and Focus. Presentation-heavy helpers remain byte-exact where
; stronger names are not independently proven.

section "BattleScene_PresentCombatHPTransition", romx[$4488], bank[$0c]
BattleScene_PresentCombatHPTransition::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    farcall MapCursor_Hide
    call $3056
    ld bc, $0506
    ld de, $0a06
    farcall MapPresentation_PrepareCoordinatesAndDraw
    farcall UIWindow_DrawFrame
    ld a, $80
    farcall UIWindow_FillInterior
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $8f80
    ld a, [$d377]
    add a, a
    farcall UnitGraphic_LoadTiles
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $8fc0
    ld a, [$d37d]
    add a, a
    inc a
    farcall UnitGraphic_LoadTiles
    ld bc, $0707
    farcall MapPresentation_ConvertViewportTileToBGMapCoordinates
    call $0ed4
    ld a, [$d377]
    add a, a
    ld d, a
    ld bc, $0003
    ld a, $f8
    farcall UnitGraphic_DrawMetatile
    ld bc, $0b07
    farcall MapPresentation_ConvertViewportTileToBGMapCoordinates
    call $0ed4
    ld a, [$d37d]
    add a, a
    inc a
    ld d, a
    ld bc, $0003
    ld a, $fc
    farcall UnitGraphic_DrawMetatile
    ld a, $02
    call $3844
    call $457a
    ld b, $06
    call $04d2
    dec b
    jr nz, $450a
    ld c, $00
    ld a, [$d379]
    ld b, a
    ld a, [$d378]
    cp b
    jr z, $4522
    ld c, $01
    dec a
    ld [$d378], a
    ld a, [$d37f]
    ld b, a
    ld a, [$d37e]
    cp b
    jr z, $4534
    ld c, $01
    dec a
    ld [$d37e], a
    jr $4500
    ld a, c
    and a
    jr nz, $4500
    ld b, $3c
    push bc
    call $05a2
    pop bc
    dec b
    jr z, $4548
    ldh a, [$ff91]
    and $0b
    jr z, $453a
    farcall MapPresentation_RunSharedRefresh
    farcall MapCursor_Show
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $4556

section "BattleScene_DrawHPTransitionFrame", romx[$4556], bank[$0c]
BattleScene_DrawHPTransitionFrame::
    ld bc, $0607
    ld e, $04
    push bc
    push de
    farcall MapPresentation_ConvertViewportTileToBGMapCoordinates
    ld hl, $4571
    call $3353
    pop de
    pop bc
    inc c
    dec e
    jr nz, $455b
    call $352e
    ret
    db $80, $80, $80, $80, $80, $80, $80, $80, $00
    assert @ == $457a

section "BattleScene_DrawDisplayedHPValues", romx[$457a], bank[$0c]
BattleScene_DrawDisplayedHPValues::
    ld bc, $070a
    farcall MapPresentation_ConvertViewportTileToBGMapCoordinates
    ld d, $02
    ld a, [$d378]
    farcall DrawNumber3Digits
    ld bc, $0b0a
    farcall MapPresentation_ConvertViewportTileToBGMapCoordinates
    ld d, $02
    ld a, [$d37e]
    farcall DrawNumber3Digits
    ret
    assert @ == $459b

section "BattleScene_RenderBattleMapContext", romx[$459b], bank[$0c]
BattleScene_RenderBattleMapContext::
    call $2164
    ld a, $18
    call $3844
    ld d, b
    ld e, c
    ld a, [$c98b]
    ld b, a
    ld a, [$c98c]
    ld c, a
    ld a, e
    sub c
    add a, a
    ld c, a
    ld a, d
    sub b
    add a, a
    srl e
    adc a, $00
    ld b, a
    ld d, $15
    ld e, $15
    call $04d2
    ld a, c
    sub e
    jr c, $45c7
    call $45eb
    ld a, c
    add a, e
    cp $12
    jr nc, $45d0
    call $45eb
    ld a, b
    sub d
    jr c, $45d7
    call $461d
    ld a, b
    add a, d
    cp $14
    jr nc, $45e0
    call $461d
    dec d
    dec e
    ld a, e
    cp $ff
    jr nz, $45bd
    call $461d
    ret
    assert @ == $45eb

section "BattleScene_RenderHorizontalMapStrip", romx[$45eb], bank[$0c]
BattleScene_RenderHorizontalMapStrip::
    push bc
    push de
    ld c, a
    ld b, $00
    farcall MapPresentation_ConvertViewportTileToBGMapCoordinates
    call $0ed4
    ld e, $14
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    call $0f2d
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    call $0f2d
    ld a, l
    and $e0
    ld d, a
    ld a, l
    inc a
    and $1f
    or d
    ld l, a
    dec e
    jr nz, $45f9
    pop de
    pop bc
    ret
    assert @ == $461d

section "BattleScene_RenderVerticalMapStrip", romx[$461d], bank[$0c]
BattleScene_RenderVerticalMapStrip::
    push bc
    push de
    ld b, a
    ld c, $00
    farcall MapPresentation_ConvertViewportTileToBGMapCoordinates
    call $0ed4
    ld e, $12
    push de
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    call $0f2d
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    call $0f2d
    ld de, $0020
    add hl, de
    ld a, h
    and $9b
    ld h, a
    pop de
    dec e
    jr nz, $462b
    pop de
    pop bc
    ret
    assert @ == $464f

section "Battle_BuildCombatParticipantStats", romx[$464f], bank[$0c]
Battle_BuildCombatParticipantStats::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    push bc
    xor a
    ld hl, $dbca
    ld bc, $0015
    call $3b79
    xor a
    ld hl, $dbdf
    ld bc, $0015
    call $3b79
    pop bc
    ld a, d
    ld [$dbc8], a
    ld a, e
    ld [$dbc9], a
    ld a, b
    ld [$dbd0], a
    ld a, c
    ld [$dbd1], a
    ld a, [$dbc9]
    ld c, $01
    farcall UnitRecord_GetWord
    ld a, e
    ld [$dbe5], a
    ld a, d
    ld [$dbe6], a
    ld a, [$dbd0]
    ld b, a
    ld a, [$dbd1]
    ld c, a
    ld a, [$dbe5]
    ld d, a
    ld a, [$dbe6]
    ld e, a
    farcall BANK_0B, Bank0B_Entry_291D
    ld [$dbf6], a
    ld a, [$dbc8]
    ld c, $00
    farcall UnitRecord_GetByte
    ld [$dbca], a
    ld a, [$dbc8]
    ld c, $04
    farcall UnitRecord_GetByte
    ld [$dbcb], a
    ld [$dbcc], a
    ld [$dbd3], a
    ld a, [$dbca]
    ld c, $18
    farcall UnitData_GetByte
    ld [$dbd2], a
    ld a, [$dbd0]
    ld b, a
    ld a, [$dbd1]
    ld c, a
    farcall MapTile_GetBaseIdAtCoordinates
    ld [$dbcd], a
    call $4861
    ld [$dbd6], a
    ld a, [$dbd2]
    cp $02
    jr nz, $46f0
    xor a
    ld [$dbd6], a
    ld a, [$dbc8]
    call $4991
    ld [$dbd7], a
    ld a, [$dbd0]
    ld b, a
    ld a, [$dbd1]
    ld c, a
    ld a, [$dbc8]
    call $4884
    ld [$dbd8], a
    ld a, [$dbc8]
    ld d, a
    ld a, [$dbe5]
    ld b, a
    ld a, [$dbe6]
    ld c, a
    ld a, [$dbc9]
    call $4919
    ld [$dbd9], a
    ld a, [$dbc9]
    ld c, $00
    farcall UnitRecord_GetByte
    ld [$dbdf], a
    ld a, [$dbc9]
    ld c, $04
    farcall UnitRecord_GetByte
    ld [$dbe0], a
    ld [$dbe1], a
    ld [$dbe8], a
    ld a, [$dbdf]
    ld c, $18
    farcall UnitData_GetByte
    ld [$dbe7], a
    ld a, [$dbe5]
    ld b, a
    ld a, [$dbe6]
    ld c, a
    farcall MapTile_GetBaseIdAtCoordinates
    ld [$dbe2], a
    call $4861
    ld [$dbeb], a
    ld a, [$dbe7]
    cp $02
    jr nz, $4769
    xor a
    ld [$dbeb], a
    ld a, [$dbc9]
    call $4991
    ld [$dbec], a
    ld a, [$dbe5]
    ld b, a
    ld a, [$dbe6]
    ld c, a
    ld a, [$dbc9]
    call $4884
    ld [$dbed], a
    ld a, [$dbc9]
    ld d, a
    ld a, [$dbd0]
    ld b, a
    ld a, [$dbd1]
    ld c, a
    ld a, [$dbc8]
    call $4919
    ld [$dbee], a
    call $47a7
    call $4800
    call $4b0a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $47a7

section "Battle_SelectParticipantWeapons", romx[$47a7], bank[$0c]
Battle_SelectParticipantWeapons::
    ld a, [$dbc8]
    farcall UnitWeapon_BuildSummary
    ld a, [$dbf6]
    ld b, a
    ld a, [$dbdf]
    call $40c1
    ld [$dbce], a
    ld a, d
    ld [$dbde], a
    ld a, e
    ld [$dbd4], a
    ld a, [$dbe7]
    add a, $1e
    ld c, a
    ld a, [$dbca]
    farcall UnitData_GetByte
    ld [$dbd5], a
    ld a, [$dbc9]
    farcall UnitWeapon_BuildSummary
    ld a, [$dbf6]
    ld b, a
    ld a, [$dbca]
    call $40c1
    ld [$dbe3], a
    ld a, d
    ld [$dbf3], a
    ld a, e
    ld [$dbe9], a
    ld a, [$dbd2]
    add a, $1e
    ld c, a
    ld a, [$dbdf]
    farcall UnitData_GetByte
    ld [$dbea], a
    ret
    assert @ == $4800

section "Battle_CalcWeaponDerivedResult", romx[$4800], bank[$0c]
Battle_CalcWeaponDerivedResult::
    push de
    ld a, [$dbce]
    and a
    jr z, $4826
    ld a, [$dbca]
    ld c, $23
    farcall UnitData_GetByte
    ld e, a
    ld a, [$dbca]
    ld c, $24
    farcall UnitData_GetByte
    ld b, a
    ld a, [$c9e5]
    call $2995
    ld a, e
    sub l
    call $484a
    ld [$dbcf], a
    ld a, [$dbf6]
    cp $01
    jr nz, $4844
    ld a, [$dbe3]
    and a
    jr z, $4844
    ld a, [$dbdf]
    ld c, $23
    farcall UnitData_GetByte
    call $484a
    jr $4845
    xor a
    ld [$dbe4], a
    pop de
    ret
    assert @ == $484a

section "Battle_QuantizeResultToTensMinOne", romx[$484a], bank[$0c]
Battle_QuantizeResultToTensMinOne::
    push bc
    ld c, $00
    sub $0a
    jr c, $4859
    push af
    ld a, c
    add a, $0a
    ld c, a
    pop af
    jr $484d
    ld a, c
    and a
    jr nz, $485f
    ld a, $01
    pop bc
    ret
    assert @ == $4861
