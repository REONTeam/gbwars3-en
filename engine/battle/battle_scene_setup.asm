include "macros/macros.inc"
include "constants/battle_scene_resource_constants.inc"
include "constants/unit_constants.inc"
include "constants/battle_scene_side_state.inc"

; early Bank $18 battle-scene selector.
; The caller provides the active battle side in wBattleUnitSide. For side 0 the
; used-weapon index comes from wBattleSceneSide0UsedWeapon; for side 1 it comes from
; wBattleSceneSide1UsedWeapon. proves these bytes are the combat participant
; used-weapon IDs. The 32-byte table maps weapon IDs $00-$1F to a compact scene
; resource index. Side 0 stores the table value directly, while side 1 adds
; $4A before storing it in wBattleSceneResourceIndex.
;
; Keep the table values positional until the downstream $4948+ graphics loader
; is fully sourced and proves the higher-level identity of each resource.
section "Battle Scene Resource Selector", romx[$48fb], bank[$18]
BattleScene_SelectResourceIndex::
    push bc
    push de
    push hl
    ld a, [$c4ad]
    cp $00
    jr nz, $490a
    ld a, [$d37b]
    jr $490d
    ld a, [$d381]
    ld c, a
    ld b, $00
    ld hl, $4928
    add hl, bc
    ld a, [$c4ad]
    cp $01
    jr nz, $4920
    ld a, [hl]
    add a, $4a
    jr $4921
    ld a, [hl]
    ld [$c4db], a
    pop hl
    pop de
    pop bc
    ret
BattleSceneWeaponResourceIndexTable::
    db $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1f, $20, $20, $20, $20, $20, $21, $21
    db $22, $22, $23, $23, $23, $22, $22, $22, $22, $22, $22, $22, $24, $24, $1e, $1e
    assert @ == $4948

section "Battle Scene Common Setup", romx[$4948], bank[$18]
BattleSceneWeaponResourceIndexTable_End::
BattleScene_LoadCommonGraphics::
    ld hl, $83f0
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $7133
    ld hl, $8000
    ld bc, $01a0
    farcall BANK_17, Bank17_Entry_3B50
    ld de, $43e5
    ld hl, $8200
    ld bc, $04b0
    farcall BANK_14, Bank14_Entry_3B50
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ret
BattleScene_RequestPalettes::
    ld a, $08
    ld b, $02
    ld hl, $47f5
    ld c, $14
    call $06d9
    call $06bc
    ret
BattleScene_DispatchSetupPhase::
    push af
    ld a, b
    cp $00
    jr nz, $49ac
    pop af
    cp $00
    jr z, $4995
    cp $01
    jr z, $49a0
    cp $02
    jr z, $49a6
    ld a, $00
    ld b, a
    ld a, [$d37b]
    call $49cf
    jr $49ce
    farcall BattleScene_SetupPhase1Side0
    jr $49ce
    farcall BattleScene_SetupPhase2Side0
    jr $49ce
    pop af
    cp $00
    jr z, $49b9
    cp $01
    jr z, $49c4
    cp $02
    jr z, $49ca
    ld a, $01
    ld b, a
    ld a, [$d381]
    call $49cf
    jr $49ce
    farcall BattleScene_SetupPhase1Side1
    jr $49ce
    farcall BattleScene_SetupPhase2Side1
    ret
BattleScene_DispatchWeaponRow::
    cp $08
    jr c, $49e9
    jr z, $49fa
    cp $0c
    jr c, $49e9
    cp $10
    jr c, $49fa
    cp $12
    jr c, $49e9
    cp $1b
    jr z, $4a0b
    cp $1e
    jr c, $49e9
    ld a, b
    cp $00
    jr nz, $49f4
    farcall BattleScene_SetupFamily0Side0
    jr $4a1c
    farcall BattleScene_SetupFamily0Side1
    jr $4a1c
    ld a, b
    cp $00
    jr nz, $4a05
    farcall BattleScene_SetupFamily1Side0
    jr $4a1c
    farcall BattleScene_SetupFamily1Side1
    jr $4a1c
    ld a, b
    cp $00
    jr nz, $4a16
    farcall BattleScene_SetupFamily2Side0
    jr $4a1c
    farcall BattleScene_SetupFamily2Side1
    jr $4a1c
    ret
    assert @ == $4a1d

section "Battle Scene Common Tilemap Fill", romx[$4a1d], bank[$18]
BattleScene_FillCommonTilemap::
    ldh a, [$ff83]
    push af
    xor a
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $8e
    ld bc, $0904
    ld de, $020e
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $88
    ld bc, $0904
    ld de, $020e
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ret
    assert @ == $4a49

section "Battle Scene Pre-Family Helpers", romx[$4a49], bank[$18]
BattleScene_NoopHook::
    ret
BattleScene_BuildRandomDelayTable::
    push af
    push bc
    xor a
    ld hl, $c4bd
    push af
    ld d, $3c
    call $294b
    ld [hli], a
    pop af
    inc a
    cp $0a
    jr nz, $4a50
    pop bc
    pop af
    ret
BattleScene_ResetScratchTable::
    db $21, $bd, $c4, $11, $6d, $4a, $01, $0a, $00, $cd, $50, $3b, $c9
BattleSceneDefaultScratchTable::
    db $00, $04, $08, $10, $20, $35, $46, $57, $68, $79
BattleScene_ResetRuntimeState::
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d3], a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld [$c4d8], a
    ld [$c4d9], a
    ld [$c4db], a
    ld a, $0f
    ld [$c4d4], a
    ld b, $17
    ld c, $00
    ld de, $70c8
    farcall AdvancedSprite_Add
    ret
BattleScene_ClassifyUnitTypeDomain3Way::
BattleScene_ClassifyMapTile3Way:: ; compatibility alias
    cp $1d
    jr c, $4ab6
    cp $2c
    jr c, $4ab8
    cp $34
    jr c, $4abb
    xor a
    ret
    ld a, $01
    ret
    ld a, $02
    ret
BattleScene_ClassifyUnitTypeDomain4Way::
    cp $32
    jr z, $4ada
    cp $33
    jr z, $4ada
    cp $1d
    jr c, $4ad2
    cp $2c
    jr c, $4ad4
    cp $34
    jr c, $4ad7
    xor a
    ret
    ld a, $01
    ret
    ld a, $02
    ret
    ld a, $03
    ret
BattleScene_ClassifyUnitTypeSpecialBinary::
BattleScene_ClassifyMapTileBinary:: ; compatibility alias
    cp $23
    jr c, $4aed
    cp $27
    jr c, $4aef
    cp $2c
    jr c, $4aed
    cp $34
    jr c, $4aef
    xor a
    ret
    ld a, $01
    ret
    assert @ == $4af2

section "Battle Scene Family 0 Side 0", romx[$4af2], bank[$18]
BattleScene_SetupFamily0Side0::
    ld a, $04
    ld [$c4cc], a
    xor a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d1], a
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $02
    ld [$c4d4], a
    ld a, $4b
    ld [$c4d5], a
    ld a, $22
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
BattleScene_SetupFamily0Side0_Continue::
    ld a, $01
    ld [$c4de], a
    call $4f95
    call $4f16
    xor a
    ld [$c4da], a
    ld a, $04
    ld [$c4cc], a
    xor a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d3], a
    ld a, $03
    ld [$c4d4], a
    ld a, $00
    ld [$c4ad], a
    ld a, [$c4dc]
    ld [$db30], a
    ld a, [$d37b]
    ld bc, $0002
    farcall BattlePlace_GetAnimationPointer
    ld a, [$c4d0]
    ld b, $17
    call $2ee8
    xor a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    ld a, [$c4d0]
    call $2f5f
    ld a, $51
    ld [$c4d5], a
    ld a, $e3
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $4b86

section "Battle Scene Family 0 Side 1", romx[$4b86], bank[$18]
BattleScene_SetupFamily0Side1::
    ld a, $fc
    ld [$c4cc], a
    xor a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d1], a
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $02
    ld [$c4d4], a
    ld a, $4b
    ld [$c4d5], a
    ld a, $b6
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
BattleScene_SetupFamily0Side1_Continue::
    ld a, $01
    ld [$c4de], a
    call $4fad
    call $4f16
    xor a
    ld [$c4da], a
    ld a, $fc
    ld [$c4cc], a
    xor a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d3], a
    ld a, $03
    ld [$c4d4], a
    ld a, $01
    ld [$c4ad], a
    ld a, [$c4dd]
    ld [$db30], a
    ld a, [$d381]
    ld bc, $0002
    farcall BattlePlace_GetAnimationPointer
    ld a, [$c4d0]
    ld b, $17
    call $2ee8
    xor a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    ld a, [$c4d0]
    call $2f5f
    ld a, $52
    ld [$c4d5], a
    ld a, $65
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $4c1a

section "Battle Scene Phase 1 Side 0", romx[$4c1a], bank[$18]
BattleScene_SetupPhase1Side0::
    ld a, $03
    ld [$c4cc], a
    ld a, $00
    ld [$c4cd], a
    ld a, $fd
    ld [$c4ce], a
    ld a, $00
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $05
    ld [$c4d4], a
    ld a, $4c
    ld [$c4d5], a
    ld a, $50
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $4c50

section "Battle Scene Phase 1 Side 0 Continue", romx[$4c50], bank[$18]
BattleScene_SetupPhase1Side0_Continue::
    ld a, $01
    ld [$c4de], a
    xor a
    ld [$c4da], a
    call $4f95
    call $4f16
    ld a, [$c4c8]
    add a, $04
    ld [$c4c8], a
    ld a, [$c4ca]
    add a, $10
    ld [$c4ca], a
    xor a
    ld [$c4d3], a
    ld a, $05
    ld [$c4d4], a
    ld a, $00
    ld [$c4ad], a
    ld a, [$c4dc]
    ld [$db30], a
    ld a, [$d37b]
    ld bc, $0002
    farcall BattlePlace_GetAnimationPointer
    ld a, [$c4d0]
    ld b, $17
    call $2ee8
    xor a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    ld a, [$c4d0]
    call $2f5f
    ld a, $53
    ld [$c4d5], a
    ld a, $5f
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $4cb6

section "Battle Scene Family 1 Side 0", romx[$4cb6], bank[$18]
BattleScene_SetupFamily1Side0::
    ld a, $03
    ld [$c4cc], a
    ld a, $00
    ld [$c4cd], a
    ld a, $fd
    ld [$c4ce], a
    ld a, $00
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $0a
    ld [$c4d4], a
    ld a, $4c
    ld [$c4d5], a
    ld a, $ec
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $4cec

section "Battle Scene Family 1 Side 0 Continue", romx[$4cec], bank[$18]
BattleScene_SetupFamily1Side0_Continue::
    ld a, $01
    ld [$c4de], a
    call $4f95
    call $4f54
    xor a
    ld [$c4da], a
    ld a, $03
    ld [$c4ce], a
    ld a, $00
    ld [$c4cf], a
    xor a
    ld [$c4d3], a
    ld a, $06
    ld [$c4d4], a
    ld a, $00
    ld [$c4ad], a
    ld a, [$c4dc]
    ld [$db30], a
    ld a, [$d37b]
    ld bc, $0002
    farcall BattlePlace_GetAnimationPointer
    ld a, [$c4d0]
    ld b, $17
    call $2ee8
    xor a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    ld a, [$c4d0]
    call $2f5f
    ld a, $51
    ld [$c4d5], a
    ld a, $e3
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $4d4c

section "Battle Scene Family 2 Side 0", romx[$4d4c], bank[$18]
BattleScene_SetupFamily2Side0::
    ld a, $03
    ld [$c4cc], a
    ld a, $00
    ld [$c4cd], a
    ld a, $fd
    ld [$c4ce], a
    ld a, $00
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $05
    ld [$c4d4], a
    ld a, $4d
    ld [$c4d5], a
    ld a, $82
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $4d82

section "Battle Scene Family 2 Side 0 Continue", romx[$4d82], bank[$18]
BattleScene_SetupFamily2Side0_Continue::
    ld a, $01
    ld [$c4de], a
    call $4f95
    xor a
    ld [$c4da], a
    ld a, $04
    ld [$c4cc], a
    call $4f16
    xor a
    ld [$c4cd], a
    ld [$c4cf], a
    ld [$c4ce], a
    ld [$c4d3], a
    ld a, $05
    ld [$c4d4], a
    ld a, $00
    ld [$c4ad], a
    ld a, [$c4dc]
    ld [$db30], a
    ld a, [$d37b]
    ld bc, $0002
    farcall BattlePlace_GetAnimationPointer
    ld a, [$c4d0]
    ld b, $17
    call $2ee8
    xor a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    ld a, [$c4d0]
    call $2f5f
    ld a, $52
    ld [$c4d5], a
    ld a, $e7
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $4de6

section "Battle Scene Family 1 Side 1", romx[$4de6], bank[$18]
BattleScene_SetupFamily1Side1::
    ld a, $fd
    ld [$c4cc], a
    ld a, $00
    ld [$c4cd], a
    ld a, $fd
    ld [$c4ce], a
    ld a, $00
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $0a
    ld [$c4d4], a
    ld a, $4e
    ld [$c4d5], a
    ld a, $1c
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $4e1c

section "Battle Scene Family 1 Side 1 Continue", romx[$4e1c], bank[$18]
BattleScene_SetupFamily1Side1_Continue::
    ld a, $01
    ld [$c4de], a
    call $4fad
    call $4f54
    xor a
    ld [$c4da], a
    ld a, $03
    ld [$c4ce], a
    ld a, $00
    ld [$c4cf], a
    xor a
    ld [$c4d3], a
    ld a, $06
    ld [$c4d4], a
    ld a, $01
    ld [$c4ad], a
    ld a, [$c4dd]
    ld [$db30], a
    ld a, [$d381]
    ld bc, $0002
    farcall BattlePlace_GetAnimationPointer
    ld a, [$c4d0]
    ld b, $17
    call $2ee8
    xor a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    ld a, [$c4d0]
    call $2f5f
    ld a, $52
    ld [$c4d5], a
    ld a, $65
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $4e7c

section "Battle Scene Family 2 Side 1", romx[$4e7c], bank[$18]
BattleScene_SetupFamily2Side1::
    ld a, $fd
    ld [$c4cc], a
    ld a, $00
    ld [$c4cd], a
    ld a, $fd
    ld [$c4ce], a
    ld a, $00
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $05
    ld [$c4d4], a
    ld a, $4e
    ld [$c4d5], a
    ld a, $b2
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $4eb2

section "Battle Scene Family 2 Side 1 Continue", romx[$4eb2], bank[$18]
BattleScene_SetupFamily2Side1_Continue::
    ld a, $01
    ld [$c4de], a
    call $4fad
    xor a
    ld [$c4da], a
    ld a, $fc
    ld [$c4cc], a
    call $4f16
    xor a
    ld [$c4cd], a
    ld [$c4cf], a
    ld [$c4ce], a
    ld [$c4d3], a
    ld a, $05
    ld [$c4d4], a
    ld a, $01
    ld [$c4ad], a
    ld a, [$c4dd]
    ld [$db30], a
    ld a, [$d381]
    ld bc, $0002
    farcall BattlePlace_GetAnimationPointer
    ld a, [$c4d0]
    ld b, $17
    call $2ee8
    xor a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    ld a, [$c4d0]
    call $2f5f
    ld a, $52
    ld [$c4d5], a
    ld a, $e7
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $4f16

section "Battle Scene Position Helpers", romx[$4f16], bank[$18]
BattleScene_SetVerticalPosition::
    push af
    push bc
    push de
    ld a, [$c4d8]
    cp $00
    jr z, $4f25
    ld a, [$d377]
    jr $4f2a
    ld a, [$d37d]
    jr $4f2a
    call $4aaa
    cp $00
    jr z, $4f37
    cp $01
    jr z, $4f3c
    jr $4f41
    ld hl, $4f6a
    jr $4f46
    ld hl, $4f75
    jr $4f46
    ld hl, $4f80
    jr $4f46
    ld a, [$c4d9]
    call $29bc
    ld a, [hl]
    ld [$c4ca], a
    pop de
    pop bc
    pop af
    ret
BattleScene_SetVerticalPositionFamily1::
    push af
    push bc
    push de
    ld a, [$c4d9]
    ld hl, $4f6a
    call $29bc
    ld a, [hl]
    sub $15
    ld [$c4ca], a
    pop de
    pop bc
    pop af
    ret
BattleScene_VerticalPositionsClass0:
    ld d, b
    ld d, b
    ld h, b
    ld h, b
    ld [hl], b
    ld [hl], b
    add a, b
    add a, b
    sub b
    sub b
    rst $38
BattleScene_VerticalPositionsClass1:
    jr c, $4faf
    ld c, b
    ld c, b
    ld e, b
    ld e, b
    ld l, b
    ld l, b
    ld a, b
    ld a, b
    rst $38
BattleScene_VerticalPositionsClass2:
    ld h, b
    ld h, b
    ld h, b
    ld [hl], b
    ld [hl], b
    ld [hl], b
    add a, b
    add a, b
    add a, b
    add a, b
    rst $38
BattleScene_HorizontalPositionOffsets:
    jr z, $4f9d
    jr nc, $4fa7
    jr z, $4fa1
    jr nc, $4fab
    jr z, $4fa5
BattleScene_SetHorizontalPositionSide0::
    push af
    push bc
    push de
    ld a, [$c4d9]
    ld hl, $4f8b
    call $29bc
    ld a, [hl]
    ld c, a
    ld a, $58
    add a, c
    ld [$c4c8], a
    pop de
    pop bc
    pop af
    ret
BattleScene_SetHorizontalPositionSide1::
    push af
    push bc
    push de
    ld a, [$c4d9]
    ld hl, $4f8b
    call $29bc
    ld a, [hl]
    ld c, a
    ld a, $58
    sub c
    ld [$c4c8], a
    pop de
    pop bc
    pop af
    ret
    assert @ == $4fc5

section "Battle Scene Phase 1 Side 1", romx[$4fc5], bank[$18]
BattleScene_SetupPhase1Side1::
    ld a, $fd
    ld [$c4cc], a
    ld a, $00
    ld [$c4cd], a
    ld a, $fd
    ld [$c4ce], a
    ld a, $00
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $05
    ld [$c4d4], a
    ld a, $4f
    ld [$c4d5], a
    ld a, $f9
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    ret
    assert @ == $4ff9

section "Battle Scene Phase 1 Side 1 Continue", romx[$4ff9], bank[$18]
BattleScene_SetupPhase1Side1_Continue::
    ld a, $01
    ld [$c4de], a
    xor a
    ld [$c4da], a
    call $4fad
    call $4f16
    ld a, [$c4c8]
    sub $04
    ld [$c4c8], a
    ld a, [$c4ca]
    add a, $10
    ld [$c4ca], a
    xor a
    ld [$c4d3], a
    ld a, $05
    ld [$c4d4], a
    ld a, $01
    ld [$c4ad], a
    ld a, [$c4dd]
    ld [$db30], a
    ld a, [$d381]
    ld bc, $0002
    farcall BattlePlace_GetAnimationPointer
    ld a, [$c4d0]
    ld b, $17
    call $2ee8
    xor a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    ld a, [$c4d0]
    call $2f5f
    ld a, $51
    ld [$c4d5], a
    ld a, $e3
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $505f

section "Battle Scene Phase 2 Side 0", romx[$505f], bank[$18]
BattleScene_SetupPhase2Side0::
    ld a, $03
    ld [$c4cc], a
    ld a, $00
    ld [$c4cd], a
    ld a, $03
    ld [$c4ce], a
    ld a, $00
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $07
    ld [$c4d4], a
    ld a, $50
    ld [$c4d5], a
    ld a, $93
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    ret
    assert @ == $5093

section "Battle Scene Phase 2 Side 0 Continue", romx[$5093], bank[$18]
BattleScene_SetupPhase2Side0_Continue::
    ld a, $01
    ld [$c4de], a
    xor a
    ld [$c4da], a
    call $4f95
    call $4f16
    ld a, [$c4ca]
    sub $08
    ld [$c4ca], a
    xor a
    ld [$c4d3], a
    ld a, $05
    ld [$c4d4], a
    ld a, $00
    ld [$c4ad], a
    ld a, [$c4dc]
    ld [$db30], a
    ld a, [$d37b]
    ld bc, $0002
    farcall BattlePlace_GetAnimationPointer
    ld a, [$c4d0]
    ld b, $17
    call $2ee8
    xor a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    ld a, [$c4d0]
    call $2f5f
    ld a, $51
    ld [$c4d5], a
    ld a, $e3
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $50f1

section "Battle Scene Phase 2 Side 1", romx[$50f1], bank[$18]
BattleScene_SetupPhase2Side1::
    ld a, $fd
    ld [$c4cc], a
    ld a, $00
    ld [$c4cd], a
    ld a, $03
    ld [$c4ce], a
    ld a, $00
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $07
    ld [$c4d4], a
    ld a, $51
    ld [$c4d5], a
    ld a, $25
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    ret
    assert @ == $5125

section "Battle Scene Phase 2 Side 1 Continue", romx[$5125], bank[$18]
BattleScene_SetupPhase2Side1_Continue::
    ld a, $01
    ld [$c4de], a
    xor a
    ld [$c4da], a
    call $4fad
    call $4f16
    ld a, [$c4ca]
    sub $08
    ld [$c4ca], a
    xor a
    ld [$c4d3], a
    ld a, $05
    ld [$c4d4], a
    ld a, $01
    ld [$c4ad], a
    ld a, [$c4dd]
    ld [$db30], a
    ld a, [$d381]
    ld bc, $0002
    farcall BattlePlace_GetAnimationPointer
    ld a, [$c4d0]
    ld b, $17
    call $2ee8
    xor a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    ld a, [$c4d0]
    call $2f5f
    ld a, $52
    ld [$c4d5], a
    ld a, $65
    ld [$c4d6], a
    ld a, $18
    ld [$c4d7], a
    jp $028a
    assert @ == $5183

section "Battle Scene Resource Selection Helpers", romx[$5183], bank[$18]
BattleScene_PrepareCommonResourceLookup::
    xor a
    ld [$c4d3], a
    ld a, $13
    ld [$c4d4], a
    ld de, $43cd
    ld a, $20
    ld b, $14
    ld c, $10
    ld de, $43cd
    ret
BattleScene_SelectResourceSide0Facing::
    ld c, $10
    ld b, $14
    ld de, $43c2
    ld a, $20
    call $2de8
    ld [$c4d0], a
    ret
BattleScene_SelectResourceSide1Facing::
    ld c, $10
    ld b, $14
    ld de, $43b7
    ld a, $20
    call $2de8
    ld [$c4d0], a
    ret
BattleScene_SelectResourceFamily2Centered::
    ld c, $10
    ld b, $14
    ld de, $43a1
    ld a, $20
    call $2de8
    ld [$c4d0], a
    ret
BattleScene_SelectResourcePhase1Side0::
    ld c, $10
    ld b, $14
    ld de, $43ac
    ld a, $20
    call $2de8
    ld [$c4d0], a
    ret
BattleScene_SelectCommonResource::
    call $5183
    call $2de8
    ld [$c4d0], a
    ret
    assert @ == $51e3

section "Battle Scene Resource Renderer 0", romx[$51e3], bank[$18]
BattleScene_RenderResourceSide0Facing::
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld [$c4d3], a
    ld a, $13
    ld [$c4d4], a
    ld a, [$c4d0]
    call $2e1f
    ld a, [$c4d9]
    ld [$c4af], a
    ld a, [$c4d8]
    ld [$c4ad], a
    farcall BattleUnit_TestSceneResourceCondition
    cp $00
    jr nz, $5240
    call $5199
    ld a, [$c4c8]
    add a, $08
    ld [$c4c8], a
    ld b, a
    ld a, [$c4ca]
    ld c, a
    ld a, [$c4d0]
    call $2eae
    call $3056
    call $48cf
    ld a, [$c4db]
    call $3844
    jp $028a
    call $51d9
    ld a, [$c4c8]
    add a, $08
    ld [$c4c8], a
    ld b, a
    ld a, [$c4ca]
    ld c, a
    ld a, [$c4d0]
    call $2eae
    call $3056
    call $48cf
    ld a, [$c4db]
    call $3844
    jp $028a
    assert @ == $5265

section "Battle Scene Resource Renderer 1", romx[$5265], bank[$18]
BattleScene_RenderResourceSide1Facing::
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld [$c4d3], a
    ld a, $13
    ld [$c4d4], a
    ld a, [$c4d0]
    call $2e1f
    ld a, [$c4d9]
    ld [$c4af], a
    ld a, [$c4d8]
    ld [$c4ad], a
    farcall BattleUnit_TestSceneResourceCondition
    cp $00
    jr nz, $52c2
    call $51a9
    ld a, [$c4c8]
    sub $08
    ld [$c4c8], a
    ld b, a
    ld a, [$c4ca]
    ld c, a
    ld a, [$c4d0]
    call $2eae
    call $3056
    call $48cf
    ld a, [$c4db]
    call $3844
    jp $028a
    call $51d9
    ld a, [$c4c8]
    sub $08
    ld [$c4c8], a
    ld b, a
    ld a, [$c4ca]
    ld c, a
    ld a, [$c4d0]
    call $2eae
    call $3056
    call $48cf
    ld a, [$c4db]
    call $3844
    jp $028a
    assert @ == $52e7

section "Battle Scene Resource Renderer 2", romx[$52e7], bank[$18]
BattleScene_RenderResourceFamily2Centered::
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld [$c4d3], a
    ld a, $13
    ld [$c4d4], a
    ld a, [$c4d0]
    call $2e1f
    ld a, [$c4d9]
    ld [$c4af], a
    ld a, [$c4d8]
    ld [$c4ad], a
    farcall BattleUnit_TestSceneResourceCondition
    cp $00
    jr nz, $533f
    call $51b9
    ld a, [$c4c8]
    ld b, a
    ld a, [$c4ca]
    ld c, a
    ld a, [$c4d0]
    call $2eae
    call $3056
    call $48cf
    ld a, [$c4db]
    call $3844
    jp $028a
    call $51d9
    ld a, [$c4c8]
    ld b, a
    ld a, [$c4ca]
    ld c, a
    ld a, [$c4d0]
    call $2eae
    call $3056
    call $48cf
    ld a, [$c4db]
    call $3844
    jp $028a
    assert @ == $535f

section "Battle Scene Resource Renderer 3", romx[$535f], bank[$18]
BattleScene_RenderResourcePhase1Side0::
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld [$c4d3], a
    ld a, $13
    ld [$c4d4], a
    ld a, [$c4d0]
    call $2e1f
    ld a, [$c4d9]
    ld [$c4af], a
    ld a, [$c4d8]
    ld [$c4ad], a
    farcall BattleUnit_TestSceneResourceCondition
    cp $00
    jr nz, $53b7
    call $51c9
    ld a, [$c4c8]
    ld b, a
    ld a, [$c4ca]
    ld c, a
    ld a, [$c4d0]
    call $2eae
    call $3056
    call $48cf
    ld a, [$c4db]
    call $3844
    jp $028a
    call $51d9
    ld a, [$c4c8]
    ld b, a
    ld a, [$c4ca]
    ld c, a
    ld a, [$c4d0]
    call $2eae
    call $3056
    call $48cf
    ld a, [$c4db]
    call $3844
    jp $028a
    assert @ == $53d7

section "Battle Scene Resource Metasprites", romx[$4245], bank[$14]
BattleSceneResourceMetasprite_4245::
    db $06, $00, $04, $05, $01, $00, $fc, $04, $01, $00, $f4, $03, $01, $f8, $04, $02
    db $01, $f8, $fc, $01, $01, $f8, $f4, $00, $01
BattleSceneResourceMetasprite_425E::
    db $06, $00, $04, $0b, $01, $00, $fc, $0a, $01, $00, $f4, $09, $01, $f8, $04, $08
    db $01, $f8, $fc, $07, $01, $f8, $f4, $06, $01
BattleSceneResourceMetasprite_4277::
    db $06, $00, $04, $11, $01, $00, $fc, $10, $01, $00, $f4, $0f, $01, $f8, $04, $0e
    db $01, $f8, $fc, $0d, $01, $f8, $f4, $0c, $01
BattleSceneResourceMetasprite_4290::
    db $06, $00, $04, $17, $01, $00, $fc, $16, $00, $00, $f4, $15, $01, $f8, $04, $14
    db $00, $f8, $fc, $13, $00, $f8, $f4, $12, $00
BattleSceneResourceMetasprite_42A9::
    db $06, $00, $04, $1d, $00, $00, $fc, $1c, $00, $00, $f4, $1b, $00, $f8, $04, $1a
    db $00, $f8, $fc, $19, $00, $f8, $f4, $18, $00
BattleSceneResourceMetasprite_42C2::
    db $05, $00, $04, $22, $00, $00, $fc, $21, $00, $00, $f4, $20, $00, $f8, $04, $1f
    db $00, $f8, $f4, $1e, $00
BattleSceneResourceMetasprite_42D7::
    db $06, $00, $04, $28, $00, $00, $fc, $27, $01, $00, $f4, $26, $01, $f8, $04, $25
    db $01, $f8, $fc, $24, $01, $f8, $f4, $23, $01
BattleSceneResourceMetasprite_42F0::
    db $06, $00, $04, $2e, $00, $00, $fc, $2d, $00, $00, $f4, $2c, $01, $f8, $04, $2b
    db $00, $f8, $fc, $2a, $01, $f8, $f4, $29, $01
BattleSceneResourceMetasprite_4309::
    db $06, $00, $04, $34, $00, $00, $fc, $33, $00, $00, $f4, $32, $01, $f8, $04, $31
    db $00, $f8, $fc, $30, $01, $f8, $f4, $2f, $00
BattleSceneResourceMetasprite_4322::
    db $06, $00, $f4, $28, $20, $00, $fc, $27, $21, $00, $04, $26, $21, $f8, $f4, $25
    db $21, $f8, $fc, $24, $21, $f8, $04, $23, $21
BattleSceneResourceMetasprite_433B::
    db $06, $00, $f4, $2e, $20, $00, $fc, $2d, $20, $00, $04, $2c, $21, $f8, $f4, $2b
    db $20, $f8, $fc, $2a, $21, $f8, $04, $29, $21
BattleSceneResourceMetasprite_4354::
    db $06, $00, $f4, $34, $20, $00, $fc, $33, $20, $00, $04, $32, $21, $f8, $f4, $31
    db $20, $f8, $fc, $30, $21, $f8, $04, $2f, $20
BattleSceneResourceMetasprite_436D::
    db $04, $00, $00, $38, $00, $00, $f8, $37, $00, $f8, $00, $36, $00, $f8, $f8, $35
    db $00
BattleSceneResourceMetasprite_437E::
    db $04, $00, $00, $3c, $00, $00, $f8, $3b, $00, $f8, $00, $3a, $00, $f8, $f8, $39
    db $00
BattleSceneResourceMetasprite_438F::
    db $02, $f8, $00, $3e, $00, $f8, $f8, $3d, $00
BattleSceneResourceMetasprite_4398::
    db $02, $f8, $00, $40, $00, $f8, $f8, $3f, $00
    assert @ == $43a1

section "Battle Scene Resource Animation Scripts", romx[$43a1], bank[$14]
BattleSceneResourceMetasprites_End::
BattleSceneResourceAnimFamily2Centered::
    db $45, $42, $06, $5e, $42, $07, $77, $42, $06, $00, $00
BattleSceneResourceAnimPhase1Side0::
    db $90, $42, $06, $a9, $42, $07, $c2, $42, $06, $00, $00
BattleSceneResourceAnimSide1Facing::
    db $d7, $42, $06, $f0, $42, $07, $09, $43, $06, $00, $00
BattleSceneResourceAnimSide0Facing::
    db $22, $43, $06, $3b, $43, $07, $54, $43, $06, $00, $00
BattleSceneResourceAnimCommon::
    db $6d, $43, $05, $7e, $43, $06, $8f, $43, $06, $98, $43, $05, $00, $00
    assert @ == $43db

section "Battle Scene Resource Animation Pointer Table", romx[$43db], bank[$14]
BattleSceneResourceAnimationScripts_End::
BattleSceneResourceAnimationPointers::
    and c
    ld b, e
    xor h
    ld b, e
    or a
    ld b, e
    jp nz, $cd43
    ld b, e
    assert @ == $43e5
