include "macros/macros.inc"
include "constants/battle_scene_resource_constants.inc"

; source ownership for the Bank $14 battle-scene resource-controller
; lead-in. The policy-heavy $4000-$4200 body stays byte-exact until its callers
; and scratch fields support safe mnemonic names. The $4201-$4244 tail is split
; separately because its used-weapon resource-selection contract is now proven.
section "Battle Scene Resource Controller Lead-In", romx[$4000], bank[$14]
BattleScene_DrawPreparedResourceValue::
    push bc
    ld b, $04
    call MultiplyAByB
    ld c, l
    ld a, $8f
    add a, c
    ld h, a
    ld a, $88
    ld de, $0202
    pop bc
    farcall Gfx_DrawSequentialTileRect
    ret

BattleScene_DrawPreparedResourceValues::
    ld a, [$d378]
    ld bc, $0401
    call BattleScene_DrawPreparedResourceValue
    ld a, [$d37e]
    ld bc, $0e01
    call BattleScene_DrawPreparedResourceValue
    ret

BattleScene_SelectSideResourceFamily::
    push af
    ld a, b
    cp $00
    jr nz, .side1
    pop af
    cp $00
    jr z, .side0_family0
    cp $01
    jr z, .side0_family1
    cp $02
    jr z, .side0_family2
.side0_family0
    ld a, $00
    ld b, a
    ld a, [$c4b3]
    call BattleScene_SelectUnitClassResourceFamily
    jr .done
.side0_family1
    farcall BattleScene_StagePhase1Side0Descriptor
    jr .done
.side0_family2
    farcall BattleScene_StagePhase2Side0Descriptor
    jr .done
.side1
    pop af
    cp $00
    jr z, .side1_family0
    cp $01
    jr z, .side1_family1
    cp $02
    jr z, .side1_family2
.side1_family0
    ld a, $01
    ld b, a
    ld a, [$c4b4]
    call BattleScene_SelectUnitClassResourceFamily
    jr .done
.side1_family1
    farcall BattleScene_StagePhase1Side1Descriptor
    jr .done
.side1_family2
    farcall BattleScene_StagePhase2Side1Descriptor
.done
    ret

BattleScene_SelectUnitClassResourceFamily::
    cp $08
    jr c, .family0
    jr z, .family1
    cp $0c
    jr c, .family0
    cp $10
    jr c, .family1
    cp $12
    jr c, .family0
    cp $1b
    jr z, .family2
    cp $1e
    jr c, .family0
.family0
    ld a, b
    cp $00
    jr nz, .family0_side1
    farcall BattleScene_StageFamily0Side0Descriptor
    jr .done
.family0_side1
    farcall BattleScene_StageFamily0Side1Descriptor
    jr .done
.family1
    ld a, b
    cp $00
    jr nz, .family1_side1
    farcall BattleScene_StageFamily1Side0Descriptor
    jr .done
.family1_side1
    farcall BattleScene_StageFamily1Side1Descriptor
    jr .done
.family2
    ld a, b
    cp $00
    jr nz, .family2_side1
    farcall BattleScene_StageFamily2Side0Descriptor
    jr .done
.family2_side1
    farcall BattleScene_StageFamily2Side1Descriptor
    jr .done
.done
    ret

BattleScene_CreatePreparedResourceSprite::
    ld a, [$c4d8]
    cp $00
    jr z, .side0
    jr .side1
.side0
    ld a, [$db31]
    ld [$c4cc], a
    ld a, [$db32]
    ld [$c4cd], a
    ld a, [$db33]
    ld [$c4ce], a
    ld a, [$db34]
    ld [$c4cf], a
    ld a, [$db35]
    ld [$c4d1], a
    ld a, [$db36]
    ld [$c4d2], a
    ld a, [$db37]
    ld [$c4d3], a
    ld a, [$db38]
    ld [$c4d4], a
    ld a, [$db39]
    ld [$c4d5], a
    ld a, [$db3a]
    ld [$c4d6], a
    ld a, [$db3b]
    ld [$c4d7], a
    ld a, [$c4d0]
    call $2e1f
    call Sprite_Update
    ld c, $00
    ld b, $17
    ld a, [$db3c]
    ld d, a
    ld a, [$db3d]
    ld e, a
    jr .create
.side1
    ld a, [$db3e]
    ld [$c4cc], a
    ld a, [$db3f]
    ld [$c4cd], a
    ld a, [$db40]
    ld [$c4ce], a
    ld a, [$db41]
    ld [$c4cf], a
    ld a, [$db42]
    ld [$c4d1], a
    ld a, [$db43]
    ld [$c4d2], a
    ld a, [$db44]
    ld [$c4d3], a
    ld a, [$db45]
    ld [$c4d4], a
    ld a, [$db46]
    ld [$c4d5], a
    ld a, [$db47]
    ld [$c4d6], a
    ld a, [$db48]
    ld [$c4d7], a
    ld a, [$c4d0]
    call $2e1f
    ld c, $00
    ld b, $17
    ld a, [$db49]
    ld d, a
    ld a, [$db4a]
    ld e, a
.create
    ld a, $20
    call SpriteObject_Create
    ld [$c4d0], a
    ld a, [$c4c8]
    ld b, a
    ld a, [$c4ca]
    ld c, a
    ld a, [$c4d0]
    call SpriteObject_SetPosition
    jp $028a

    assert @ == $4193

BattleScene_ResetPreparedResourceRuntime::
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d3], a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld a, $0f
    ld [$c4d4], a
    ld b, $17
    ld c, $00
    ld de, $70c8
    ld a, $40
    ld [$c4d5], a
    ld a, $c4
    ld [$c4d6], a
    ld a, $14
    ld [$c4d7], a
    farcall AdvancedSprite_Add
    ld [$c4d0], a
    ret

    assert @ == $41cf

section "Battle Scene Air-Matchup Variant Preparation", romx[$41cf], bank[$14]
; Build the side-relative air-matchup variant and immediately use it to select
; both the Bank $18 setup family and the Bank $17 used-weapon animation pointer.
BattleScene_PrepareSideAnimationVariant::
    ld a, [wBattleSceneResourceSide]
    cp 0
    jr nz, .side1
.side0
    ld a, 0
    farcall $16, BattleScene_GetAirMatchupVariant
    ld [wBattleSceneAirVariantSide0], a
    ld b, 0
    call $4029
    ld a, 0
    farcall $17, BattlePlace_SelectAnimationPointer
    jr .done
.side1
    ld a, 1
    farcall $16, BattleScene_GetAirMatchupVariant
    ld [wBattleSceneAirVariantSide1], a
    ld b, 1
    call $4029
    ld a, 1
    farcall $17, BattlePlace_SelectAnimationPointer
.done
    ret

    assert @ == $4201

section "Battle Scene Used-Weapon Resource Controller", romx[$4201], bank[$14]
; The caller-visible BC value is preserved and later restored into HL. The helper
; at Bank $17:$4768 stages the per-active-slot randomized resource delay. DE is then copied into
; one of two side-specific WRAM pairs according to wBattleUnitSide. Finally the
; Bank $18 selector maps the current used-weapon ID through its 32-entry compact
; resource table. The exact identities of the C4xx/DBxx scratch fields remain
; intentionally neutral.
BattleScene_PrepareUsedWeaponResource::
    push bc
    call BattleScene_PrepareSideAnimationVariant
    farcall $17, BattlePlace_LoadResourceDelayFromActiveOrdinal
    ld a, [$c4d2]
    add $0f
    ld [$c4d2], a
    ld a, [wBattleUnitSide]
    cp 0
    jr z, .side0
    jr .side1
.side0
    ld a, d
    ld [$db3c], a
    ld a, e
    ld [$db3d], a
    jr .side_done
.side1
    ld a, d
    ld [$db49], a
    ld a, e
    ld [$db4a], a
    jr .side_done
.side_done
    ld a, [wBattleUnitSide]
    ld [$c4d8], a
    ld a, [wBattleSceneActiveSlotOrdinal]
    ld [$c4d9], a
    pop bc
    ld h, b
    ld l, c
    farcall $18, BattleScene_SelectResourceIndex
    call BattleScene_ResetPreparedResourceRuntime
    ret

BattleScene_PrepareUsedWeaponResource_End::
    assert BattleScene_PrepareUsedWeaponResource_End == $4245
