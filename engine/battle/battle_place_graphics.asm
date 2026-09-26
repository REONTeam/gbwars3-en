include "macros/macros.inc"
include "constants/battle_scene_resource_constants.inc"
include "constants/unit_constants.inc"
include "constants/battle_scene_side_state.inc"

; Bank $17 battle-place descriptor table. There is exactly one 10-byte record
; for each raw map tile ID $00-$33. The first four words are retail pointers
; consumed by the battle-place renderer; the final word takes only $0000/$0002/$0004
; and tracks property-side/variant selection. Higher-level names for the four pointer
; roles remain conservative until all Bank $17 consumers are sourced.


DEF BATTLE_PLACE_PALETTE_VARIANT_PRIMARY EQU $0000
DEF BATTLE_PLACE_PALETTE_VARIANT_SIDE0   EQU BATTLE_PLACE_PALETTE_VARIANT_PRIMARY
DEF BATTLE_PLACE_PALETTE_VARIANT_SIDE1   EQU $0002
DEF BATTLE_PLACE_PALETTE_VARIANT_NEUTRAL EQU $0004

MACRO battle_place_record
    dw \1, \2, \3, \4, \5
ENDM

section "Battle Place Map Tile Records", romx[$47cb], bank[$17]
BattlePlaceMapTileRecords::
    battle_place_record BattlePlaceGraphics_4D89, BattlePlaceLayout_4D53, BattlePlaceAttributes_4D6E, BattlePlacePalette_4E59, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $00
    battle_place_record BattlePlaceGraphics_4D89, BattlePlaceLayout_4D53, BattlePlaceAttributes_4D6E, BattlePlacePalette_4E59, BATTLE_PLACE_PALETTE_VARIANT_SIDE0 ; map tile $01
    battle_place_record BattlePlaceGraphics_4ECF, BattlePlaceLayout_4E99, BattlePlaceAttributes_4EB4, BattlePlacePalette_502F, BATTLE_PLACE_PALETTE_VARIANT_SIDE0 ; map tile $02
    battle_place_record BattlePlaceGraphics_50A5, BattlePlaceLayout_506F, BattlePlaceAttributes_508A, BattlePlacePalette_51C5, BATTLE_PLACE_PALETTE_VARIANT_SIDE0 ; map tile $03
    battle_place_record BattlePlaceGraphics_523B, BattlePlaceLayout_5205, BattlePlaceAttributes_5220, BattlePlacePalette_533B, BATTLE_PLACE_PALETTE_VARIANT_SIDE0 ; map tile $04
    battle_place_record BattlePlaceGraphics_53B1, BattlePlaceLayout_537B, BattlePlaceAttributes_5396, BattlePlacePalette_54B1, BATTLE_PLACE_PALETTE_VARIANT_SIDE0 ; map tile $05
    battle_place_record BattlePlaceGraphics_5527, BattlePlaceLayout_54F1, BattlePlaceAttributes_550C, BattlePlacePalette_5617, BATTLE_PLACE_PALETTE_VARIANT_SIDE0 ; map tile $06
    battle_place_record BattlePlaceGraphics_568D, BattlePlaceLayout_5657, BattlePlaceAttributes_5672, BattlePlacePalette_577D, BATTLE_PLACE_PALETTE_VARIANT_SIDE0 ; map tile $07
    battle_place_record BattlePlaceGraphics_57F3, BattlePlaceLayout_57BD, BattlePlaceAttributes_57D8, BattlePlacePalette_58E3, BATTLE_PLACE_PALETTE_VARIANT_SIDE0 ; map tile $08
    battle_place_record BattlePlaceGraphics_5959, BattlePlaceLayout_5923, BattlePlaceAttributes_593E, BattlePlacePalette_5A59, BATTLE_PLACE_PALETTE_VARIANT_SIDE0 ; map tile $09
    battle_place_record BattlePlaceGraphics_5ACF, BattlePlaceLayout_5A99, BattlePlaceAttributes_5AB4, BattlePlacePalette_5B9F, BATTLE_PLACE_PALETTE_VARIANT_SIDE0 ; map tile $0a
    battle_place_record BattlePlaceGraphics_5C15, BattlePlaceLayout_5BDF, BattlePlaceAttributes_5BFA, BattlePlacePalette_5D05, BATTLE_PLACE_PALETTE_VARIANT_SIDE0 ; map tile $0b
    battle_place_record BattlePlaceGraphics_4D89, BattlePlaceLayout_4D53, BattlePlaceAttributes_4D6E, BattlePlacePalette_4E59, BATTLE_PLACE_PALETTE_VARIANT_SIDE1 ; map tile $0c
    battle_place_record BattlePlaceGraphics_4ECF, BattlePlaceLayout_4E99, BattlePlaceAttributes_4EB4, BattlePlacePalette_502F, BATTLE_PLACE_PALETTE_VARIANT_SIDE1 ; map tile $0d
    battle_place_record BattlePlaceGraphics_50A5, BattlePlaceLayout_506F, BattlePlaceAttributes_508A, BattlePlacePalette_51C5, BATTLE_PLACE_PALETTE_VARIANT_SIDE1 ; map tile $0e
    battle_place_record BattlePlaceGraphics_523B, BattlePlaceLayout_5205, BattlePlaceAttributes_5220, BattlePlacePalette_533B, BATTLE_PLACE_PALETTE_VARIANT_SIDE1 ; map tile $0f
    battle_place_record BattlePlaceGraphics_53B1, BattlePlaceLayout_537B, BattlePlaceAttributes_5396, BattlePlacePalette_54B1, BATTLE_PLACE_PALETTE_VARIANT_SIDE1 ; map tile $10
    battle_place_record BattlePlaceGraphics_5527, BattlePlaceLayout_54F1, BattlePlaceAttributes_550C, BattlePlacePalette_5617, BATTLE_PLACE_PALETTE_VARIANT_SIDE1 ; map tile $11
    battle_place_record BattlePlaceGraphics_568D, BattlePlaceLayout_5657, BattlePlaceAttributes_5672, BattlePlacePalette_577D, BATTLE_PLACE_PALETTE_VARIANT_SIDE1 ; map tile $12
    battle_place_record BattlePlaceGraphics_57F3, BattlePlaceLayout_57BD, BattlePlaceAttributes_57D8, BattlePlacePalette_58E3, BATTLE_PLACE_PALETTE_VARIANT_SIDE1 ; map tile $13
    battle_place_record BattlePlaceGraphics_5959, BattlePlaceLayout_5923, BattlePlaceAttributes_593E, BattlePlacePalette_5A59, BATTLE_PLACE_PALETTE_VARIANT_SIDE1 ; map tile $14
    battle_place_record BattlePlaceGraphics_5ACF, BattlePlaceLayout_5A99, BattlePlaceAttributes_5AB4, BattlePlacePalette_5B9F, BATTLE_PLACE_PALETTE_VARIANT_SIDE1 ; map tile $15
    battle_place_record BattlePlaceGraphics_5C15, BattlePlaceLayout_5BDF, BattlePlaceAttributes_5BFA, BattlePlacePalette_5D05, BATTLE_PLACE_PALETTE_VARIANT_SIDE1 ; map tile $16
    battle_place_record BattlePlaceGraphics_4ECF, BattlePlaceLayout_4E99, BattlePlaceAttributes_4EB4, BattlePlacePalette_502F, BATTLE_PLACE_PALETTE_VARIANT_NEUTRAL ; map tile $17
    battle_place_record BattlePlaceGraphics_50A5, BattlePlaceLayout_506F, BattlePlaceAttributes_508A, BattlePlacePalette_51C5, BATTLE_PLACE_PALETTE_VARIANT_NEUTRAL ; map tile $18
    battle_place_record BattlePlaceGraphics_523B, BattlePlaceLayout_5205, BattlePlaceAttributes_5220, BattlePlacePalette_533B, BATTLE_PLACE_PALETTE_VARIANT_NEUTRAL ; map tile $19
    battle_place_record BattlePlaceGraphics_53B1, BattlePlaceLayout_537B, BattlePlaceAttributes_5396, BattlePlacePalette_54B1, BATTLE_PLACE_PALETTE_VARIANT_NEUTRAL ; map tile $1a
    battle_place_record BattlePlaceGraphics_5527, BattlePlaceLayout_54F1, BattlePlaceAttributes_550C, BattlePlacePalette_5617, BATTLE_PLACE_PALETTE_VARIANT_NEUTRAL ; map tile $1b
    battle_place_record BattlePlaceGraphics_568D, BattlePlaceLayout_5657, BattlePlaceAttributes_5672, BattlePlacePalette_577D, BATTLE_PLACE_PALETTE_VARIANT_NEUTRAL ; map tile $1c
    battle_place_record BattlePlaceGraphics_5959, BattlePlaceLayout_5923, BattlePlaceAttributes_593E, BattlePlacePalette_5A59, BATTLE_PLACE_PALETTE_VARIANT_NEUTRAL ; map tile $1d
    battle_place_record BattlePlaceGraphics_5ACF, BattlePlaceLayout_5A99, BattlePlaceAttributes_5AB4, BattlePlacePalette_5B9F, BATTLE_PLACE_PALETTE_VARIANT_NEUTRAL ; map tile $1e
    battle_place_record BattlePlaceGraphics_5C15, BattlePlaceLayout_5BDF, BattlePlaceAttributes_5BFA, BattlePlacePalette_5D05, BATTLE_PLACE_PALETTE_VARIANT_NEUTRAL ; map tile $1f
    battle_place_record BattlePlaceGraphics_5D7B, BattlePlaceLayout_5D45, BattlePlaceAttributes_5D60, BattlePlacePalette_5E0B, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $20
    battle_place_record BattlePlaceGraphics_5E81, BattlePlaceLayout_5E4B, BattlePlaceAttributes_5E66, BattlePlacePalette_5F11, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $21
    battle_place_record BattlePlaceGraphics_5F87, BattlePlaceLayout_5F51, BattlePlaceAttributes_5F6C, BattlePlacePalette_6027, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $22
    battle_place_record BattlePlaceGraphics_609D, BattlePlaceLayout_6067, BattlePlaceAttributes_6082, BattlePlacePalette_613D, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $23
    battle_place_record BattlePlaceGraphics_61B3, BattlePlaceLayout_617D, BattlePlaceAttributes_6198, BattlePlacePalette_62A3, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $24
    battle_place_record BattlePlaceGraphics_6319, BattlePlaceLayout_62E3, BattlePlaceAttributes_62FE, BattlePlacePalette_63F9, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $25
    battle_place_record BattlePlaceGraphics_646F, BattlePlaceLayout_6439, BattlePlaceAttributes_6454, BattlePlacePalette_64FF, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $26
    battle_place_record BattlePlaceGraphics_6575, BattlePlaceLayout_653F, BattlePlaceAttributes_655A, BattlePlacePalette_6635, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $27
    battle_place_record BattlePlaceGraphics_66AB, BattlePlaceLayout_6675, BattlePlaceAttributes_6690, BattlePlacePalette_670B, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $28
    battle_place_record BattlePlaceGraphics_6781, BattlePlaceLayout_674B, BattlePlaceAttributes_6766, BattlePlacePalette_6831, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $29
    battle_place_record BattlePlaceGraphics_68A7, BattlePlaceLayout_6871, BattlePlaceAttributes_688C, BattlePlacePalette_6907, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $2a
    battle_place_record BattlePlaceGraphics_6781, BattlePlaceLayout_674B, BattlePlaceAttributes_6766, BattlePlacePalette_6831, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $2b
    battle_place_record BattlePlaceGraphics_6781, BattlePlaceLayout_674B, BattlePlaceAttributes_6766, BattlePlacePalette_6831, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $2c
    battle_place_record BattlePlaceGraphics_6781, BattlePlaceLayout_674B, BattlePlaceAttributes_6766, BattlePlacePalette_6831, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $2d
    battle_place_record BattlePlaceGraphics_6781, BattlePlaceLayout_674B, BattlePlaceAttributes_6766, BattlePlacePalette_6831, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $2e
    battle_place_record BattlePlaceGraphics_6781, BattlePlaceLayout_674B, BattlePlaceAttributes_6766, BattlePlacePalette_6831, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $2f
    battle_place_record BattlePlaceGraphics_6781, BattlePlaceLayout_674B, BattlePlaceAttributes_6766, BattlePlacePalette_6831, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $30
    battle_place_record BattlePlaceGraphics_6781, BattlePlaceLayout_674B, BattlePlaceAttributes_6766, BattlePlacePalette_6831, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $31
    battle_place_record BattlePlaceGraphics_697D, BattlePlaceLayout_6947, BattlePlaceAttributes_6962, BattlePlacePalette_6A1D, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $32
    battle_place_record BattlePlaceGraphics_6A93, BattlePlaceLayout_6A5D, BattlePlaceAttributes_6A78, BattlePlacePalette_6B73, BATTLE_PLACE_PALETTE_VARIANT_PRIMARY ; map tile $33
BattlePlaceMapTileRecords_End::
    assert BattlePlaceMapTileRecords_End - BattlePlaceMapTileRecords == $208
    assert @ == $49d3

; Battle-place animation-script selection. The table at $49D3 is indexed as:
;   row * 24 + side * 12 + subvariant * 4 + slot offset.
; This proves 33 WeaponData-indexed rows, two sides, three subvariants, and two
; animation-script slots. The two slots select scripts in the $7000 animation
; layer. /302 proves the row index is the combat used-weapon ID.
section "Battle Place Animation Subvariant State", romx[$4768], bank[$17]
; Called by the Bank $14 battle-scene resource controller before the used-weapon
; resource selector. C4B5 selects one byte from the C4BD scene-state array; the
; selected value is staged at C4D2 and C4D1 is cleared. Keep the higher-level
; identity neutral until the C4B5/C4BD producers are sourced.
BattlePlace_LoadResourceDelayFromActiveOrdinal::
BattlePlace_LoadAnimationSubvariantFromSceneState:: ; compatibility alias
    push hl
    ld bc, 0
    ld a, [wBattleSceneActiveSlotOrdinal]
    ld c, a
    ld hl, wBattleSceneRandomDelayTable
    add hl, bc
    ld a, [hl]
    ld [$c4d2], a
    xor a
    ld [$c4d1], a
    pop hl
    ; falls through to the shared RET at $477D

    assert @ == $477d

section "Battle Place Animation Pointer Access", romx[$477d], bank[$17]
BattlePlaceAnimationPointerAccess_PreviousReturn::
    ret

BattlePlace_SelectAnimationPointer:: ; callable entry at $477E
    cp 0
    jr nz, .second
    ld a, [$c4dc]
    ld [wBattlePlacePointerVariant], a
    ld a, [wBattleSceneSide0UsedWeapon]
    jr .lookup
.second
    ld a, [$c4dd]
    ld [wBattlePlacePointerVariant], a
    ld a, [wBattleSceneSide1UsedWeapon]
.lookup
    ld bc, 0
    call BattlePlace_GetAnimationPointer
    ret

BattlePlace_GetWeaponAnimationPointer::
BattlePlace_GetAnimationPointer:: ; compatibility alias
    push bc
    push af
    ld a, 24
    ld b, a
    pop af
    call MultiplyAByB
    ld bc, BattlePlaceWeaponAnimationPointerMatrix
    add hl, bc
    push hl
    ld a, [wBattlePlacePointerVariant]
    ld b, 4
    call MultiplyAByB
    ld b, h
    ld c, l
    pop hl
    add hl, bc
    ld a, [wBattleUnitSide]
    cp 1
    jr z, .side1
    jr .slot
.side1
    ld bc, 12
    add hl, bc
.slot
    pop bc
    add hl, bc
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a
    ret

    assert @ == $47cb

MACRO battle_place_animation_side
    dw \1, \2, \3, \4, \5, \6
ENDM

section "Battle Place Weapon Animation Pointer Matrix", romx[$49d3], bank[$17]
; Directly indexed by the used-weapon byte copied from the combat participant
; record. There are exactly 33 rows, matching WeaponData IDs $00-$20.
BattlePlaceWeaponAnimationPointerMatrix::
BattlePlaceAnimationPointerMatrix:: ; compatibility alias
    ; WEAPON_EMPTY ($00)
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_NONE ($01)
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_MACHINE_GUN_B ($02)
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7005, BattlePlaceAnim_7005, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_700A, BattlePlaceAnim_700A, BattlePlaceAnim_7005, BattlePlaceAnim_7005 ; side 1
    ; WEAPON_MACHINE_GUN_A ($03)
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7005, BattlePlaceAnim_7005, BattlePlaceAnim_700A, BattlePlaceAnim_700A ; side 0
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_700A, BattlePlaceAnim_700A, BattlePlaceAnim_7005, BattlePlaceAnim_7005 ; side 1
    ; WEAPON_AUTOCANNON_B ($04)
    battle_place_animation_side BattlePlaceAnim_700F, BattlePlaceAnim_700F, BattlePlaceAnim_7019, BattlePlaceAnim_7019, BattlePlaceAnim_701E, BattlePlaceAnim_701E ; side 0
    battle_place_animation_side BattlePlaceAnim_7014, BattlePlaceAnim_7014, BattlePlaceAnim_701E, BattlePlaceAnim_701E, BattlePlaceAnim_7019, BattlePlaceAnim_7019 ; side 1
    ; WEAPON_AUTOCANNON_B4 ($05)
    battle_place_animation_side BattlePlaceAnim_7023, BattlePlaceAnim_7023, BattlePlaceAnim_702D, BattlePlaceAnim_702D, BattlePlaceAnim_7032, BattlePlaceAnim_7032 ; side 0
    battle_place_animation_side BattlePlaceAnim_7028, BattlePlaceAnim_7028, BattlePlaceAnim_7032, BattlePlaceAnim_7032, BattlePlaceAnim_702D, BattlePlaceAnim_702D ; side 1
    ; WEAPON_AUTOCANNON_A ($06)
    battle_place_animation_side BattlePlaceAnim_7073, BattlePlaceAnim_7073, BattlePlaceAnim_707D, BattlePlaceAnim_707D, BattlePlaceAnim_70D3, BattlePlaceAnim_70D3 ; side 0
    battle_place_animation_side BattlePlaceAnim_7078, BattlePlaceAnim_7078, BattlePlaceAnim_7082, BattlePlaceAnim_7082, BattlePlaceAnim_70D8, BattlePlaceAnim_70D8 ; side 1
    ; WEAPON_AUTOCANNON_S ($07)
    battle_place_animation_side BattlePlaceAnim_7087, BattlePlaceAnim_7087, BattlePlaceAnim_7091, BattlePlaceAnim_7091, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_708C, BattlePlaceAnim_708C, BattlePlaceAnim_7096, BattlePlaceAnim_7096, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_GRENADE ($08)
    battle_place_animation_side BattlePlaceAnim_709B, BattlePlaceAnim_70A5, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_70A0, BattlePlaceAnim_70AA, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_TANK_GUN_B ($09)
    battle_place_animation_side BattlePlaceAnim_705F, BattlePlaceAnim_705F, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_7064, BattlePlaceAnim_7064, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_TANK_GUN_A ($0a)
    battle_place_animation_side BattlePlaceAnim_7069, BattlePlaceAnim_7069, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_706E, BattlePlaceAnim_706E, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_TANK_GUN_S ($0b)
    battle_place_animation_side BattlePlaceAnim_7069, BattlePlaceAnim_7069, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_706E, BattlePlaceAnim_706E, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_CANNON_B ($0c)
    battle_place_animation_side BattlePlaceAnim_709B, BattlePlaceAnim_70A5, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_70A0, BattlePlaceAnim_70AA, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_CANNON_A ($0d)
    battle_place_animation_side BattlePlaceAnim_709B, BattlePlaceAnim_70A5, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_70A0, BattlePlaceAnim_70AA, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_ROCKET_B ($0e)
    battle_place_animation_side BattlePlaceAnim_7041, BattlePlaceAnim_704B, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_7046, BattlePlaceAnim_7050, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_ROCKET_A ($0f)
    battle_place_animation_side BattlePlaceAnim_7041, BattlePlaceAnim_704B, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_7046, BattlePlaceAnim_7050, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_ANTI_TANK_MISSILE_B ($10)
    battle_place_animation_side BattlePlaceAnim_7037, BattlePlaceAnim_7037, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_703C, BattlePlaceAnim_703C, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_ANTI_TANK_MISSILE_A ($11)
    battle_place_animation_side BattlePlaceAnim_7037, BattlePlaceAnim_7037, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_704B, BattlePlaceAnim_704B ; side 0
    battle_place_animation_side BattlePlaceAnim_703C, BattlePlaceAnim_703C, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7050, BattlePlaceAnim_7050 ; side 1
    ; WEAPON_BOMBS ($12)
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_70AF, BattlePlaceAnim_70AF ; side 0
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_70AF, BattlePlaceAnim_70AF ; side 1
    ; WEAPON_ANTI_CITY_MISSILE ($13)
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_ANTI_CITY_BOMB ($14)
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_SURFACE_AIR_MISSILE_B ($15)
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_70BE, BattlePlaceAnim_70BE, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_70C3, BattlePlaceAnim_70C3, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_SURFACE_AIR_MISSILE_A ($16)
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_70BE, BattlePlaceAnim_70BE, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_70C3, BattlePlaceAnim_70C3, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_SURFACE_AIR_MISSILE_S ($17)
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_70BE, BattlePlaceAnim_70BE, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_70C3, BattlePlaceAnim_70C3, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_ANTI_AIR_MISSILE_B ($18)
    battle_place_animation_side BattlePlaceAnim_70B4, BattlePlaceAnim_70B4, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_70B9, BattlePlaceAnim_70B9, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_ANTI_AIR_MISSILE_A ($19)
    battle_place_animation_side BattlePlaceAnim_70B4, BattlePlaceAnim_70B4, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_70B9, BattlePlaceAnim_70B9, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_ANTI_AIR_MISSILE_S ($1a)
    battle_place_animation_side BattlePlaceAnim_70B4, BattlePlaceAnim_70B4, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_70B9, BattlePlaceAnim_70B9, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_ANTI_SHIP_MISSILE ($1b)
    battle_place_animation_side BattlePlaceAnim_70BE, BattlePlaceAnim_70B4, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_70C3, BattlePlaceAnim_70B9, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_PROXIMITY_TORPEDO ($1c)
    battle_place_animation_side BattlePlaceAnim_7055, BattlePlaceAnim_7055, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7055, BattlePlaceAnim_7055 ; side 0
    battle_place_animation_side BattlePlaceAnim_705A, BattlePlaceAnim_705A, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_705A, BattlePlaceAnim_705A ; side 1
    ; WEAPON_TORPEDO ($1d)
    battle_place_animation_side BattlePlaceAnim_7055, BattlePlaceAnim_7055, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7055, BattlePlaceAnim_7055 ; side 0
    battle_place_animation_side BattlePlaceAnim_705A, BattlePlaceAnim_705A, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_705A, BattlePlaceAnim_705A ; side 1
    ; WEAPON_SUPPLIES ($1e)
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_MATERIAL ($1f)
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 0
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000 ; side 1
    ; WEAPON_ROCKET ($20)
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_704B, BattlePlaceAnim_704B ; side 0
    battle_place_animation_side BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7000, BattlePlaceAnim_7050, BattlePlaceAnim_7050 ; side 1
BattlePlaceWeaponAnimationPointerMatrix_End::
BattlePlaceAnimationPointerMatrix_End:: ; compatibility alias
    assert BattlePlaceWeaponAnimationPointerMatrix_End - BattlePlaceWeaponAnimationPointerMatrix == (WEAPON_ROCKET + 1) * 24
    assert @ == $4ceb


; /302: battle-scene metasprite and animation-script layer selected by
; the WeaponData-indexed BattlePlaceWeaponAnimationPointerMatrix. Metasprites are count-prefixed OAM-style
; quads (x offset, y offset, tile id, attributes). Animation scripts are
; (metasprite pointer, duration) pairs terminated by a null pointer.

MACRO battle_place_oam
    db \1, \2, \3, \4
ENDM

MACRO battle_place_anim_frame
    dw \1
    db \2
ENDM

MACRO battle_place_anim_end
    dw 0
ENDM

section "Battle Place Metasprites", romx[$6f03], bank[$17]
BattlePlaceMetasprite_6F03::
    db 1
    battle_place_oam $fc, $fc, $00, $00
BattlePlaceMetasprite_6F08::
    db 1
    battle_place_oam $fc, $fc, $01, $00
BattlePlaceMetasprite_6F0D::
    db 1
    battle_place_oam $fc, $fc, $01, $20
BattlePlaceMetasprite_6F12::
    db 1
    battle_place_oam $fc, $fc, $02, $00
BattlePlaceMetasprite_6F17::
    db 1
    battle_place_oam $fc, $fc, $02, $20
BattlePlaceMetasprite_6F1C::
    db 1
    battle_place_oam $fc, $fc, $03, $00
BattlePlaceMetasprite_6F21::
    db 1
    battle_place_oam $fc, $fc, $03, $20
BattlePlaceMetasprite_6F26::
    db 1
    battle_place_oam $fc, $fb, $04, $00
BattlePlaceMetasprite_6F2B::
    db 1
    battle_place_oam $fc, $fd, $04, $20
BattlePlaceMetasprite_6F30::
    db 1
    battle_place_oam $fc, $fc, $05, $00
BattlePlaceMetasprite_6F35::
    db 1
    battle_place_oam $fc, $fc, $05, $20
BattlePlaceMetasprite_6F3A::
    db 1
    battle_place_oam $fc, $fc, $0d, $00
BattlePlaceMetasprite_6F3F::
    db 1
    battle_place_oam $fc, $fc, $0d, $20
BattlePlaceMetasprite_6F44::
    db 1
    battle_place_oam $fc, $fc, $0e, $00
BattlePlaceMetasprite_6F49::
    db 1
    battle_place_oam $fc, $fc, $0e, $20
BattlePlaceMetasprite_6F4E::
    db 1
    battle_place_oam $fc, $fc, $0e, $40
BattlePlaceMetasprite_6F53::
    db 1
    battle_place_oam $fc, $fc, $0e, $60
BattlePlaceMetasprite_6F58::
    db 1
    battle_place_oam $fc, $fc, $06, $00
BattlePlaceMetasprite_6F5D::
    db 1
    battle_place_oam $fc, $fc, $06, $20
BattlePlaceMetasprite_6F62::
    db 1
    battle_place_oam $fc, $fc, $07, $00
BattlePlaceMetasprite_6F67::
    db 1
    battle_place_oam $fc, $fc, $07, $20
BattlePlaceMetasprite_6F6C::
    db 1
    battle_place_oam $fc, $fc, $08, $00
BattlePlaceMetasprite_6F71::
    db 1
    battle_place_oam $fc, $fc, $08, $20
BattlePlaceMetasprite_6F76::
    db 1
    battle_place_oam $fc, $fc, $09, $00
BattlePlaceMetasprite_6F7B::
    db 1
    battle_place_oam $fc, $fc, $09, $20
BattlePlaceMetasprite_6F80::
    db 1
    battle_place_oam $fc, $fc, $16, $00
BattlePlaceMetasprite_6F85::
    db 1
    battle_place_oam $fc, $fc, $16, $20
BattlePlaceMetasprite_6F8A::
    db 1
    battle_place_oam $fc, $fc, $0c, $00
BattlePlaceMetasprite_6F8F::
    db 1
    battle_place_oam $fc, $fc, $0c, $20
BattlePlaceMetasprite_6F94::
    db 1
    battle_place_oam $fc, $fc, $0c, $40
BattlePlaceMetasprite_6F99::
    db 1
    battle_place_oam $fc, $fc, $0c, $60
BattlePlaceMetasprite_6F9E::
    db 1
    battle_place_oam $fc, $fc, $0b, $00
BattlePlaceMetasprite_6FA3::
    db 1
    battle_place_oam $fc, $fc, $0b, $20
BattlePlaceMetasprite_6FA8::
    db 2
    battle_place_oam $fc, $00, $12, $00
    battle_place_oam $fc, $f8, $11, $00
BattlePlaceMetasprite_6FB1::
    db 2
    battle_place_oam $fc, $f8, $12, $20
    battle_place_oam $fc, $00, $11, $20
BattlePlaceMetasprite_6FBA::
    db 3
    battle_place_oam $00, $f8, $15, $00
    battle_place_oam $f8, $00, $14, $00
    battle_place_oam $f8, $f8, $13, $00
BattlePlaceMetasprite_6FC7::
    db 3
    battle_place_oam $00, $00, $15, $20
    battle_place_oam $f8, $f8, $14, $20
    battle_place_oam $f8, $00, $13, $20
BattlePlaceMetasprite_6FD4::
    db 2
    battle_place_oam $00, $fc, $10, $00
    battle_place_oam $f8, $fc, $0f, $00
BattlePlaceMetasprite_6FDD::
    db 1
    battle_place_oam $fc, $fc, $0a, $00
BattlePlaceMetasprite_6FE2::
    db 1
    battle_place_oam $fc, $fc, $0a, $20
BattlePlaceMetasprite_6FE7::
    db 1
    battle_place_oam $fc, $fc, $17, $00
BattlePlaceMetasprite_6FEC::
    db 1
    battle_place_oam $fc, $fc, $18, $00
BattlePlaceMetasprite_6FF1::
    db 1
    battle_place_oam $fc, $fc, $19, $00
BattlePlaceMetasprite_6FF6::
    db 1
    battle_place_oam $fc, $fc, $07, $40
BattlePlaceMetasprite_6FFB::
    db 1
    battle_place_oam $fc, $fc, $07, $60
BattlePlaceMetasprites_End::
    assert @ == $7000

section "Battle Place Animation Scripts", romx[$7000], bank[$17]
BattlePlaceAnim_7000::
    battle_place_anim_frame BattlePlaceMetasprite_6F03, 1
    battle_place_anim_end
BattlePlaceAnim_7005::
    battle_place_anim_frame BattlePlaceMetasprite_6F08, 1
    battle_place_anim_end
BattlePlaceAnim_700A::
    battle_place_anim_frame BattlePlaceMetasprite_6F0D, 1
    battle_place_anim_end
BattlePlaceAnim_700F::
    battle_place_anim_frame BattlePlaceMetasprite_6F12, 1
    battle_place_anim_end
BattlePlaceAnim_7014::
    battle_place_anim_frame BattlePlaceMetasprite_6F17, 1
    battle_place_anim_end
BattlePlaceAnim_7019::
    battle_place_anim_frame BattlePlaceMetasprite_6F1C, 1
    battle_place_anim_end
BattlePlaceAnim_701E::
    battle_place_anim_frame BattlePlaceMetasprite_6F21, 1
    battle_place_anim_end
BattlePlaceAnim_7023::
    battle_place_anim_frame BattlePlaceMetasprite_6F26, 1
    battle_place_anim_end
BattlePlaceAnim_7028::
    battle_place_anim_frame BattlePlaceMetasprite_6F2B, 1
    battle_place_anim_end
BattlePlaceAnim_702D::
    battle_place_anim_frame BattlePlaceMetasprite_6F30, 1
    battle_place_anim_end
BattlePlaceAnim_7032::
    battle_place_anim_frame BattlePlaceMetasprite_6F35, 1
    battle_place_anim_end
BattlePlaceAnim_7037::
    battle_place_anim_frame BattlePlaceMetasprite_6F3A, 1
    battle_place_anim_end
BattlePlaceAnim_703C::
    battle_place_anim_frame BattlePlaceMetasprite_6F3F, 1
    battle_place_anim_end
BattlePlaceAnim_7041::
    battle_place_anim_frame BattlePlaceMetasprite_6F44, 1
    battle_place_anim_end
BattlePlaceAnim_7046::
    battle_place_anim_frame BattlePlaceMetasprite_6F49, 1
    battle_place_anim_end
BattlePlaceAnim_704B::
    battle_place_anim_frame BattlePlaceMetasprite_6F4E, 1
    battle_place_anim_end
BattlePlaceAnim_7050::
    battle_place_anim_frame BattlePlaceMetasprite_6F53, 1
    battle_place_anim_end
BattlePlaceAnim_7055::
    battle_place_anim_frame BattlePlaceMetasprite_6F80, 1
    battle_place_anim_end
BattlePlaceAnim_705A::
    battle_place_anim_frame BattlePlaceMetasprite_6F85, 1
    battle_place_anim_end
BattlePlaceAnim_705F::
    battle_place_anim_frame BattlePlaceMetasprite_6FDD, 1
    battle_place_anim_end
BattlePlaceAnim_7064::
    battle_place_anim_frame BattlePlaceMetasprite_6FE2, 1
    battle_place_anim_end
BattlePlaceAnim_7069::
    battle_place_anim_frame BattlePlaceMetasprite_6F9E, 1
    battle_place_anim_end
BattlePlaceAnim_706E::
    battle_place_anim_frame BattlePlaceMetasprite_6FA3, 1
    battle_place_anim_end
BattlePlaceAnim_7073::
    battle_place_anim_frame BattlePlaceMetasprite_6F58, 1
    battle_place_anim_end
BattlePlaceAnim_7078::
    battle_place_anim_frame BattlePlaceMetasprite_6F5D, 1
    battle_place_anim_end
BattlePlaceAnim_707D::
    battle_place_anim_frame BattlePlaceMetasprite_6F62, 1
    battle_place_anim_end
BattlePlaceAnim_7082::
    battle_place_anim_frame BattlePlaceMetasprite_6F67, 1
    battle_place_anim_end
BattlePlaceAnim_7087::
    battle_place_anim_frame BattlePlaceMetasprite_6F6C, 1
    battle_place_anim_end
BattlePlaceAnim_708C::
    battle_place_anim_frame BattlePlaceMetasprite_6F71, 1
    battle_place_anim_end
BattlePlaceAnim_7091::
    battle_place_anim_frame BattlePlaceMetasprite_6F76, 1
    battle_place_anim_end
BattlePlaceAnim_7096::
    battle_place_anim_frame BattlePlaceMetasprite_6F7B, 1
    battle_place_anim_end
BattlePlaceAnim_709B::
    battle_place_anim_frame BattlePlaceMetasprite_6F8A, 1
    battle_place_anim_end
BattlePlaceAnim_70A0::
    battle_place_anim_frame BattlePlaceMetasprite_6F8F, 1
    battle_place_anim_end
BattlePlaceAnim_70A5::
    battle_place_anim_frame BattlePlaceMetasprite_6F94, 1
    battle_place_anim_end
BattlePlaceAnim_70AA::
    battle_place_anim_frame BattlePlaceMetasprite_6F99, 1
    battle_place_anim_end
BattlePlaceAnim_70AF::
    battle_place_anim_frame BattlePlaceMetasprite_6FD4, 1
    battle_place_anim_end
BattlePlaceAnim_70B4::
    battle_place_anim_frame BattlePlaceMetasprite_6FA8, 1
    battle_place_anim_end
BattlePlaceAnim_70B9::
    battle_place_anim_frame BattlePlaceMetasprite_6FB1, 1
    battle_place_anim_end
BattlePlaceAnim_70BE::
    battle_place_anim_frame BattlePlaceMetasprite_6FBA, 1
    battle_place_anim_end
BattlePlaceAnim_70C3::
    battle_place_anim_frame BattlePlaceMetasprite_6FC7, 1
    battle_place_anim_end
BattlePlaceAnim_70C8::
    battle_place_anim_frame BattlePlaceMetasprite_6FE7, 6
    battle_place_anim_frame BattlePlaceMetasprite_6FEC, 5
    battle_place_anim_frame BattlePlaceMetasprite_6FF1, 4
    battle_place_anim_end
BattlePlaceAnim_70D3::
    battle_place_anim_frame BattlePlaceMetasprite_6FF6, 1
    battle_place_anim_end
BattlePlaceAnim_70D8::
    battle_place_anim_frame BattlePlaceMetasprite_6FFB, 1
    battle_place_anim_end
BattlePlaceAnimationScripts_End::
    assert @ == $70dd

section "Battle Place Animation Pointer Table", romx[$70dd], bank[$17]
BattlePlaceAnimationPointers::
    dw BattlePlaceAnim_7000
    dw BattlePlaceAnim_7005
    dw BattlePlaceAnim_700A
    dw BattlePlaceAnim_700F
    dw BattlePlaceAnim_7014
    dw BattlePlaceAnim_7019
    dw BattlePlaceAnim_701E
    dw BattlePlaceAnim_7023
    dw BattlePlaceAnim_7028
    dw BattlePlaceAnim_702D
    dw BattlePlaceAnim_7032
    dw BattlePlaceAnim_7037
    dw BattlePlaceAnim_703C
    dw BattlePlaceAnim_7041
    dw BattlePlaceAnim_7046
    dw BattlePlaceAnim_704B
    dw BattlePlaceAnim_7050
    dw BattlePlaceAnim_7055
    dw BattlePlaceAnim_705A
    dw BattlePlaceAnim_705F
    dw BattlePlaceAnim_7064
    dw BattlePlaceAnim_7069
    dw BattlePlaceAnim_706E
    dw BattlePlaceAnim_7073
    dw BattlePlaceAnim_7078
    dw BattlePlaceAnim_707D
    dw BattlePlaceAnim_7082
    dw BattlePlaceAnim_7087
    dw BattlePlaceAnim_708C
    dw BattlePlaceAnim_7091
    dw BattlePlaceAnim_7096
    dw BattlePlaceAnim_709B
    dw BattlePlaceAnim_70A0
    dw BattlePlaceAnim_70A5
    dw BattlePlaceAnim_70AA
    dw BattlePlaceAnim_70AF
    dw BattlePlaceAnim_70B4
    dw BattlePlaceAnim_70B9
    dw BattlePlaceAnim_70BE
    dw BattlePlaceAnim_70C3
    dw BattlePlaceAnim_70C8
    dw BattlePlaceAnim_70D3
    dw BattlePlaceAnim_70D8
BattlePlaceAnimationPointers_End::
    assert BattlePlaceAnimationPointers_End - BattlePlaceAnimationPointers == 43 * 2
    assert @ == $7133


; Copy the fixed $160-byte battle-place graphics window selected by raw map tile A.
; HL is the destination buffer supplied by the caller.
section "Battle Place Graphics Window Loader", romx[$4487], bank[$17]
BattlePlace_LoadGraphicsWindow::
    push hl
    ld b, 10
    call MultiplyAByB
    ld b, h
    ld c, l
    ld hl, BattlePlaceMapTileRecords
    add hl, bc
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a
    pop hl
    ld bc, $160
    call Memcpy
    ret

    assert @ == $449f

; Load the shared battle-place animation graphics window and its base BG
; palette. This entry is used by the battle-scene setup layer before the
; per-place records are rendered.
section "Battle Place Shared Graphics And Palette", romx[$44a1], bank[$17]
BattlePlace_LoadSharedGraphicsAndPalette::
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $88d0
    ld de, $6bb3
    ld bc, $0310
    call Memcpy
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    ld b, $01
    ld hl, $6ec3
    ld c, $17
    call Vram_SetFarPals
    call Vram_ApplyPals
    ret

    assert @ == $44cb

; Retail maintains two independently animated battle-place palette pairs.
; The renderer stages each pair's base colors and selector; these helpers
; alternate the highlighted colors every other update while enabled.
DEF wBattlePlacePalettePrimaryToggle   EQU $d364
DEF wBattlePlacePaletteSecondaryToggle EQU $d365
DEF wBattlePlacePalettePrimaryTimer    EQU $d366
DEF wBattlePlacePaletteSecondaryTimer  EQU $d367
DEF wBattlePlacePalettePrimarySelector EQU $d368
DEF wBattlePlacePaletteSecondarySelector EQU $d369
DEF wBattlePlacePalettePrimaryAnimate  EQU $d36a
DEF wBattlePlacePaletteSecondaryAnimate EQU $d36b
DEF wBattlePlacePalettePrimaryBase     EQU $d344
DEF wBattlePlacePaletteSecondaryBase   EQU $d354

section "Battle Place Primary Palette Animation", romx[$44cb], bank[$17]
BattlePlace_UpdatePrimaryPaletteAnimation::
    ld a, [wBattlePlacePalettePrimaryAnimate]
    cp $00
    jr z, .restore_base
    ld a, [wBattlePlacePalettePrimaryTimer]
    cp $01
    jr z, .advance_phase
    inc a
    ld [wBattlePlacePalettePrimaryTimer], a
    ret
.advance_phase
    xor a
    ld [wBattlePlacePalettePrimaryTimer], a
    ld a, [wBattlePlacePalettePrimaryToggle]
    cp $00
    jr z, .apply_highlight
    jr .restore_base
.restore_base
    ld a, $00
    ld [wBattlePlacePalettePrimaryToggle], a
    ld hl, wBattlePlacePalettePrimaryBase
    ld a, $02
    ld b, $02
    call Vram_SetPals
    call Vram_ApplyBGPals
    ret
.apply_highlight
    ld a, $01
    ld [wBattlePlacePalettePrimaryToggle], a
    ld a, [wBattlePlacePalettePrimarySelector]
    ld b, $08
    call MultiplyAByB
    ld bc, BattlePlacePaletteAnimationRows
    add hl, bc
    push hl
    ld a, $02
    call AddAtoHL
    ld d, h
    ld e, l
    ld hl, wPals + $12
    ld bc, $0002
    call MemcpyWaitLCD
    pop hl
    ld a, $08
    call AddAtoHL
    ld a, $02
    call AddAtoHL
    ld d, h
    ld e, l
    ld hl, wPals + $1a
    ld bc, $0002
    call MemcpyWaitLCD
    call Vram_ApplyBGPals
    ret

    assert @ == $453a

section "Battle Place Secondary Palette Animation", romx[$453a], bank[$17]
BattlePlace_UpdateSecondaryPaletteAnimation::
    ld a, [wBattlePlacePaletteSecondaryAnimate]
    cp $00
    jr z, .restore_base
    ld a, [wBattlePlacePaletteSecondaryTimer]
    cp $01
    jr z, .advance_phase
    inc a
    ld [wBattlePlacePaletteSecondaryTimer], a
    ret
.advance_phase
    xor a
    ld [wBattlePlacePaletteSecondaryTimer], a
    ld a, [wBattlePlacePaletteSecondaryToggle]
    cp $00
    jr z, .apply_highlight
    jr .restore_base
.restore_base
    ld a, $00
    ld [wBattlePlacePaletteSecondaryToggle], a
    ld hl, wBattlePlacePaletteSecondaryBase
    ld a, $04
    ld b, $02
    call Vram_SetPals
    call Vram_ApplyBGPals
    ret
.apply_highlight
    ld a, $01
    ld [wBattlePlacePaletteSecondaryToggle], a
    ld a, [wBattlePlacePaletteSecondarySelector]
    ld b, $08
    call MultiplyAByB
    ld bc, BattlePlacePaletteAnimationRows
    add hl, bc
    push hl
    ld a, $02
    call AddAtoHL
    ld d, h
    ld e, l
    ld hl, wPals + $22
    ld bc, $0002
    call MemcpyWaitLCD
    pop hl
    ld a, $08
    call AddAtoHL
    ld a, $02
    call AddAtoHL
    ld d, h
    ld e, l
    ld hl, wPals + $2a
    ld bc, $0002
    call MemcpyWaitLCD
    call Vram_ApplyBGPals
    ret

    assert @ == $45a9

BattlePlace_UpdatePaletteAnimations::
    call BattlePlace_UpdatePrimaryPaletteAnimation
    call BattlePlace_UpdateSecondaryPaletteAnimation
    ret

    assert @ == $45b0

; Render one 9x3 battle-place tilemap/attribute rectangle and load the
; associated two-palette variant. A selects the 52-entry map-tile record.
; BC is the tilemap origin. DE provides the tile/attribute base offsets used
; by the caller. H distinguishes the two retail render destinations.
section "Battle Place Record Renderer", romx[$45b0], bank[$17]
BattlePlace_RenderRecord::
    push af
    ld a, h
    ld [$cc64], a
    pop af
    push bc
    ld b, 10
    call MultiplyAByB
    ld b, h
    ld c, l
    ld hl, BattlePlaceMapTileRecords
    add hl, bc
    inc hl
    inc hl
    pop bc
    ld a, b
    ld [$cc52], a
    ld a, c
    ld [$cc53], a
    ld a, 9
    ld [$cc56], a
    ld a, 3
    ld [$cc57], a
    ld a, [hli]
    ld [$cc59], a
    ld a, [hli]
    ld [$cc58], a
    ld a, $17
    ld [$cc61], a
    ld a, [hli]
    ld [$cc5b], a
    ld a, [hli]
    push hl
    ld [$cc5a], a
    ld a, $17
    ld [$cc62], a
    ld a, d
    ld [$cc5c], a
    ld a, e
    ld [$cc63], a
    call BattlePlace_RenderTilemapAttributes
    pop hl
    ld a, [hli]
    ld c, a
    ld a, [hli]
    ld b, a
    ld a, [hl]
    push af
    ld a, [$cc64]
    cp 1
    jr z, .second_destination
    ld d, 2
    ld h, b
    ld l, c
    pop af
    ld [$d368], a
    farcall $17, BattlePlace_LoadPalettePair
    ld b, a
    ld de, $c4f0
    ld hl, $d344
    ld bc, $10
    call Memcpy
    jr .done
.second_destination
    ld h, b
    ld l, c
    pop af
    ld [$d369], a
    ld d, 4
    farcall $17, BattlePlace_LoadPalettePair
    ld b, a
    ld de, $c500
    ld hl, $d354
    ld bc, $10
    call Memcpy
.done
    ret

; Render the 9x3 tilemap bytes in VRAM bank 0 and their matching CGB
; attributes in VRAM bank 1. The source pointers and loop state are staged
; in the retail $CC50-$CC64 scratch block by BattlePlace_RenderRecord.
section "Battle Place Tilemap Attribute Renderer", romx[$4640], bank[$17]
BattlePlace_RenderTilemapAttributes::
    ldh a, [hROMBank]
    push af
    xor a
    ld [$cc50], a
    ld [$cc51], a
    ld a, [$cc64]
    cp 0
    jr z, .reverse
    jr .forward_setup
.reverse
    xor a
    ld [$cc54], a
    ld [$cc55], a
    jr .row_loop
.forward_setup
    ld a, [$cc56]
    dec a
    ld [$cc54], a
    xor a
    ld [$cc55], a
.row_loop
    ld a, [$cc57]
    ld c, a
    ld a, [$cc55]
    cp c
    jp nc, .done
    ld a, [$cc54]
    ld c, a
    ld a, [$cc52]
    add c
    ld b, a
    ld a, [$cc55]
    ld c, a
    ld a, [$cc53]
    add c
    ld c, a
    call Vram_TilemapCoord
    push hl

    xor a
    ldh [hVRAMBank], a
    ldh [rVBK], a
    push af
    ld a, [$cc61]
    ld a, a
    ldh [hROMBank], a
    ld [rROMB0], a
    pop af
    ld a, [$cc59]
    ld l, a
    ld a, [$cc58]
    ld h, a
    ld a, [$cc50]
    ld c, a
    ld a, [$cc51]
    ld b, a
    add hl, bc
    ld a, [hl]
    push af
    ld a, [$cc5c]
    ld c, a
    pop af
    add c
    pop hl
    push hl
    call Vram_Put

    ld a, 1
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$cc5b]
    ld l, a
    ld a, [$cc5a]
    ld h, a
    ld a, [$cc50]
    ld c, a
    ld a, [$cc51]
    ld b, a
    add hl, bc
    ld a, [hl]
    pop hl
    res 3, a
    push af
    ld a, [$cc63]
    ld c, a
    pop af
    push af
    and 7
    add c
    and 7
    ld d, a
    pop af
    and $f8
    add d
    push af
    ld a, [$cc64]
    cp 1
    jr z, .keep_flip
    pop af
    jr .write_attr
.keep_flip
    pop af
    xor $20
.write_attr
    call Vram_Put

    ld a, [$cc51]
    ld b, a
    ld a, [$cc50]
    ld c, a
    inc bc
    ld a, b
    ld [$cc51], a
    ld a, c
    ld [$cc50], a
    ld a, [$cc64]
    cp 0
    jr z, .advance_forward
    jr .advance_reverse
.advance_forward
    ld a, [$cc54]
    inc a
    ld [$cc54], a
    ld a, [$cc56]
    ld c, a
    ld a, [$cc54]
    cp c
    jp c, .row_loop
    xor a
    ld [$cc54], a
    ld a, [$cc55]
    inc a
    ld [$cc55], a
    jp .row_loop
.advance_reverse
    ld a, [$cc54]
    dec a
    ld [$cc54], a
    ld a, [$cc54]
    cp $ff
    jp nz, .row_loop
    ld a, [$cc56]
    dec a
    ld [$cc54], a
    ld a, [$cc55]
    inc a
    ld [$cc55], a
    jp .row_loop
.done
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ret

; HL points to the record's palette table. A is the record variant selector
; ($00/$02/$04), D is the destination BG palette index (2 or 4). Each variant
; advances by 16 bytes and loads exactly two palettes from Bank $17.
section "Battle Place Palette Pair Loader", romx[$4755], bank[$17]
BattlePlace_LoadPalettePair::
    push hl
    ld b, 8
    call MultiplyAByB
    ld b, h
    ld c, l
    pop hl
    add hl, bc
    ld a, d
    ld b, 2
    ld c, $17
    call Vram_SetFarPals
    ret

; Eight four-color BGR555 rows used by the two battle-place palette animators.
; The selector chooses an 8-byte row; the animation copies color 1 from the
; selected row and color 1 from the following row into the paired BG palettes.
; Valid animation selectors therefore consume adjacent rows from this table.
section "Battle Place Palette Animation Rows", romx[$72db], bank[$17]
BattlePlacePaletteAnimationRows::
    dw $1ce7, $779b, $281f, $1411
    dw $1ce7, $779b, $77bd, $59c6
    dw $1ce7, $779b, $6b5a, $4631
    dw $1ce7, $779b, $77bd, $59c6
    dw $1ce7, $779b, $03ec, $0280
    dw $1ce7, $779b, $77bd, $59c6
    dw $1fe7, $60ae, $7c10, $7c1f
    dw $401f, $4210, $6318, $7fff
BattlePlacePaletteAnimationRows_End::
    assert BattlePlacePaletteAnimationRows_End - BattlePlacePaletteAnimationRows == 8 * 8
    assert @ == $731b

; complete packed battle-place resource arena. The 24 graphics windows,
; 24 9x3 tilemaps, 24 9x3 attribute maps, and 24 64-byte palette tables
; overlap physically. This single section owns every byte exactly once while labels
; expose each logical pointer used by BattlePlaceMapTileRecords.
section "Battle Place Packed Resource Arena", romx[$4d53], bank[$17]
BattlePlacePackedResourceArena::
BattlePlaceLayout_4D53::
    incbin "gfx/environment/battle_places/resources/layout_4d53.tilemap"
BattlePlaceAttributes_4D6E::
    incbin "gfx/environment/battle_places/resources/attributes_4d6e.attrmap"
BattlePlaceGraphics_4D89::
    incbin "gfx/environment/battle_places/resources/graphics_4d89.2bpp"
BattlePlacePalette_4E59::
    incbin "gfx/environment/battle_places/resources/palette_4e59.pal"
BattlePlaceLayout_4E99::
    incbin "gfx/environment/battle_places/resources/layout_4e99.tilemap"
BattlePlaceAttributes_4EB4::
    incbin "gfx/environment/battle_places/resources/attributes_4eb4.attrmap"
BattlePlaceGraphics_4ECF::
    incbin "gfx/environment/battle_places/resources/graphics_4ecf.2bpp"
BattlePlacePalette_502F::
    incbin "gfx/environment/battle_places/resources/palette_502f.pal"
BattlePlaceLayout_506F::
    incbin "gfx/environment/battle_places/resources/layout_506f.tilemap"
BattlePlaceAttributes_508A::
    incbin "gfx/environment/battle_places/resources/attributes_508a.attrmap"
BattlePlaceGraphics_50A5::
    incbin "gfx/environment/battle_places/resources/graphics_50a5.2bpp"
BattlePlacePalette_51C5::
    incbin "gfx/environment/battle_places/resources/palette_51c5.pal"
BattlePlaceLayout_5205::
    incbin "gfx/environment/battle_places/resources/layout_5205.tilemap"
BattlePlaceAttributes_5220::
    incbin "gfx/environment/battle_places/resources/attributes_5220.attrmap"
BattlePlaceGraphics_523B::
    incbin "gfx/environment/battle_places/resources/graphics_523b.2bpp"
BattlePlacePalette_533B::
    incbin "gfx/environment/battle_places/resources/palette_533b.pal"
BattlePlaceLayout_537B::
    incbin "gfx/environment/battle_places/resources/layout_537b.tilemap"
BattlePlaceAttributes_5396::
    incbin "gfx/environment/battle_places/resources/attributes_5396.attrmap"
BattlePlaceGraphics_53B1::
    incbin "gfx/environment/battle_places/resources/graphics_53b1.2bpp"
BattlePlacePalette_54B1::
    incbin "gfx/environment/battle_places/resources/palette_54b1.pal"
BattlePlaceLayout_54F1::
    incbin "gfx/environment/battle_places/resources/layout_54f1.tilemap"
BattlePlaceAttributes_550C::
    incbin "gfx/environment/battle_places/resources/attributes_550c.attrmap"
BattlePlaceGraphics_5527::
    incbin "gfx/environment/battle_places/resources/graphics_5527.2bpp"
BattlePlacePalette_5617::
    incbin "gfx/environment/battle_places/resources/palette_5617.pal"
BattlePlaceLayout_5657::
    incbin "gfx/environment/battle_places/resources/layout_5657.tilemap"
BattlePlaceAttributes_5672::
    incbin "gfx/environment/battle_places/resources/attributes_5672.attrmap"
BattlePlaceGraphics_568D::
    incbin "gfx/environment/battle_places/resources/graphics_568d.2bpp"
BattlePlacePalette_577D::
    incbin "gfx/environment/battle_places/resources/palette_577d.pal"
BattlePlaceLayout_57BD::
    incbin "gfx/environment/battle_places/resources/layout_57bd.tilemap"
BattlePlaceAttributes_57D8::
    incbin "gfx/environment/battle_places/resources/attributes_57d8.attrmap"
BattlePlaceGraphics_57F3::
    incbin "gfx/environment/battle_places/resources/graphics_57f3.2bpp"
BattlePlacePalette_58E3::
    incbin "gfx/environment/battle_places/resources/palette_58e3.pal"
BattlePlaceLayout_5923::
    incbin "gfx/environment/battle_places/resources/layout_5923.tilemap"
BattlePlaceAttributes_593E::
    incbin "gfx/environment/battle_places/resources/attributes_593e.attrmap"
BattlePlaceGraphics_5959::
    incbin "gfx/environment/battle_places/resources/graphics_5959.2bpp"
BattlePlacePalette_5A59::
    incbin "gfx/environment/battle_places/resources/palette_5a59.pal"
BattlePlaceLayout_5A99::
    incbin "gfx/environment/battle_places/resources/layout_5a99.tilemap"
BattlePlaceAttributes_5AB4::
    incbin "gfx/environment/battle_places/resources/attributes_5ab4.attrmap"
BattlePlaceGraphics_5ACF::
    incbin "gfx/environment/battle_places/resources/graphics_5acf.2bpp"
BattlePlacePalette_5B9F::
    incbin "gfx/environment/battle_places/resources/palette_5b9f.pal"
BattlePlaceLayout_5BDF::
    incbin "gfx/environment/battle_places/resources/layout_5bdf.tilemap"
BattlePlaceAttributes_5BFA::
    incbin "gfx/environment/battle_places/resources/attributes_5bfa.attrmap"
BattlePlaceGraphics_5C15::
    incbin "gfx/environment/battle_places/resources/graphics_5c15.2bpp"
BattlePlacePalette_5D05::
    incbin "gfx/environment/battle_places/resources/palette_5d05.pal"
BattlePlaceLayout_5D45::
    incbin "gfx/environment/battle_places/resources/layout_5d45.tilemap"
BattlePlaceAttributes_5D60::
    incbin "gfx/environment/battle_places/resources/attributes_5d60.attrmap"
BattlePlaceGraphics_5D7B::
    incbin "gfx/environment/battle_places/resources/graphics_5d7b.2bpp"
BattlePlacePalette_5E0B::
    incbin "gfx/environment/battle_places/resources/palette_5e0b.pal"
BattlePlaceLayout_5E4B::
    incbin "gfx/environment/battle_places/resources/layout_5e4b.tilemap"
BattlePlaceAttributes_5E66::
    incbin "gfx/environment/battle_places/resources/attributes_5e66.attrmap"
BattlePlaceGraphics_5E81::
    incbin "gfx/environment/battle_places/resources/graphics_5e81.2bpp"
BattlePlacePalette_5F11::
    incbin "gfx/environment/battle_places/resources/palette_5f11.pal"
BattlePlaceLayout_5F51::
    incbin "gfx/environment/battle_places/resources/layout_5f51.tilemap"
BattlePlaceAttributes_5F6C::
    incbin "gfx/environment/battle_places/resources/attributes_5f6c.attrmap"
BattlePlaceGraphics_5F87::
    incbin "gfx/environment/battle_places/resources/graphics_5f87.2bpp"
BattlePlacePalette_6027::
    incbin "gfx/environment/battle_places/resources/palette_6027.pal"
BattlePlaceLayout_6067::
    incbin "gfx/environment/battle_places/resources/layout_6067.tilemap"
BattlePlaceAttributes_6082::
    incbin "gfx/environment/battle_places/resources/attributes_6082.attrmap"
BattlePlaceGraphics_609D::
    incbin "gfx/environment/battle_places/resources/graphics_609d.2bpp"
BattlePlacePalette_613D::
    incbin "gfx/environment/battle_places/resources/palette_613d.pal"
BattlePlaceLayout_617D::
    incbin "gfx/environment/battle_places/resources/layout_617d.tilemap"
BattlePlaceAttributes_6198::
    incbin "gfx/environment/battle_places/resources/attributes_6198.attrmap"
BattlePlaceGraphics_61B3::
    incbin "gfx/environment/battle_places/resources/graphics_61b3.2bpp"
BattlePlacePalette_62A3::
    incbin "gfx/environment/battle_places/resources/palette_62a3.pal"
BattlePlaceLayout_62E3::
    incbin "gfx/environment/battle_places/resources/layout_62e3.tilemap"
BattlePlaceAttributes_62FE::
    incbin "gfx/environment/battle_places/resources/attributes_62fe.attrmap"
BattlePlaceGraphics_6319::
    incbin "gfx/environment/battle_places/resources/graphics_6319.2bpp"
BattlePlacePalette_63F9::
    incbin "gfx/environment/battle_places/resources/palette_63f9.pal"
BattlePlaceLayout_6439::
    incbin "gfx/environment/battle_places/resources/layout_6439.tilemap"
BattlePlaceAttributes_6454::
    incbin "gfx/environment/battle_places/resources/attributes_6454.attrmap"
BattlePlaceGraphics_646F::
    incbin "gfx/environment/battle_places/resources/graphics_646f.2bpp"
BattlePlacePalette_64FF::
    incbin "gfx/environment/battle_places/resources/palette_64ff.pal"
BattlePlaceLayout_653F::
    incbin "gfx/environment/battle_places/resources/layout_653f.tilemap"
BattlePlaceAttributes_655A::
    incbin "gfx/environment/battle_places/resources/attributes_655a.attrmap"
BattlePlaceGraphics_6575::
    incbin "gfx/environment/battle_places/resources/graphics_6575.2bpp"
BattlePlacePalette_6635::
    incbin "gfx/environment/battle_places/resources/palette_6635.pal"
BattlePlaceLayout_6675::
    incbin "gfx/environment/battle_places/resources/layout_6675.tilemap"
BattlePlaceAttributes_6690::
    incbin "gfx/environment/battle_places/resources/attributes_6690.attrmap"
BattlePlaceGraphics_66AB::
    incbin "gfx/environment/battle_places/resources/graphics_66ab.2bpp"
BattlePlacePalette_670B::
    incbin "gfx/environment/battle_places/resources/palette_670b.pal"
BattlePlaceLayout_674B::
    incbin "gfx/environment/battle_places/resources/layout_674b.tilemap"
BattlePlaceAttributes_6766::
    incbin "gfx/environment/battle_places/resources/attributes_6766.attrmap"
BattlePlaceGraphics_6781::
    incbin "gfx/environment/battle_places/resources/graphics_6781.2bpp"
BattlePlacePalette_6831::
    incbin "gfx/environment/battle_places/resources/palette_6831.pal"
BattlePlaceLayout_6871::
    incbin "gfx/environment/battle_places/resources/layout_6871.tilemap"
BattlePlaceAttributes_688C::
    incbin "gfx/environment/battle_places/resources/attributes_688c.attrmap"
BattlePlaceGraphics_68A7::
    incbin "gfx/environment/battle_places/resources/graphics_68a7.2bpp"
BattlePlacePalette_6907::
    incbin "gfx/environment/battle_places/resources/palette_6907.pal"
BattlePlaceLayout_6947::
    incbin "gfx/environment/battle_places/resources/layout_6947.tilemap"
BattlePlaceAttributes_6962::
    incbin "gfx/environment/battle_places/resources/attributes_6962.attrmap"
BattlePlaceGraphics_697D::
    incbin "gfx/environment/battle_places/resources/graphics_697d.2bpp"
BattlePlacePalette_6A1D::
    incbin "gfx/environment/battle_places/resources/palette_6a1d.pal"
BattlePlaceLayout_6A5D::
    incbin "gfx/environment/battle_places/resources/layout_6a5d.tilemap"
BattlePlaceAttributes_6A78::
    incbin "gfx/environment/battle_places/resources/attributes_6a78.attrmap"
BattlePlaceGraphics_6A93::
    incbin "gfx/environment/battle_places/resources/graphics_6a93.2bpp"
BattlePlacePalette_6B73::
    incbin "gfx/environment/battle_places/resources/palette_6b73.pal"
BattlePlacePackedResourceArena_End::
    assert BattlePlacePackedResourceArena_End - BattlePlacePackedResourceArena == $1ea0
    assert @ == $6bf3
