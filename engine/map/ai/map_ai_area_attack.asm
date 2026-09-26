include "macros/macros.inc"
include "constants/unit_constants.inc"

; Area-attack runtime used by the map-AI area-effect action. The action applies
; unit damage to the selected hex and all six neighbors, then applies a second
; terrain/property effect chosen from the 23 terrain-name classes.
;
; The connected damage/death, signed-HP popup, and area-effect animation
; services are source-backed and referenced symbolically. Terrain/property,
; unit, sprite, and map-grid contracts in this module are behavior-backed.

DEF wMapEffectSpriteObjectId EQU $c998
DEF wMapAIAreaAttackCellDamage           EQU $c999
DEF wMapAIAreaAttackTotalDamage          EQU $c99a

section "Map AI Area Attack Runtime", romx[$504f], bank[$0c]

; B,C = target coordinates.
; Returns A = total HP removed from the center hex plus its six neighbors.
MapAI_ApplyAreaAttackAroundTarget::
    push bc
    push de
    push hl
    push af
    call MapActionEffect_LoadPalettes
    xor a
    ld [wMapAIAreaAttackTotalDamage], a
    call MapAI_ApplyAreaAttackAtCoordinate
    ld e, 0
.neighbor_loop
    push bc
    push de
    call HexGrid_GetNeighborCoord
    jr c, .neighbor_done
    call MapAI_ApplyAreaAttackAtCoordinate
    ld a, [wMapAIAreaAttackCellDamage]
    ld b, a
    ld a, [wMapAIAreaAttackTotalDamage]
    add b
    ld [wMapAIAreaAttackTotalDamage], a
.neighbor_done
    pop de
    pop bc
    inc e
    ld a, e
    cp 6
    jr nz, .neighbor_loop
    pop af
    ld a, [$cce5]
    inc a
    ld [$cce5], a
    ld a, [wMapAIAreaAttackTotalDamage]
    pop hl
    pop de
    pop bc
    ret

; Apply one cell of the area attack at B,C. The sprite loop plays the cell
; effect first, then unit HP is reduced if a live unit occupies the cell.
; wMapAIAreaAttackCellDamage records the actual HP removed (clamped to current
; HP). Terrain/property damage is applied afterward regardless of occupancy.
MapAI_ApplyAreaAttackAtCoordinate::
    push bc
    push de
    push hl
    call MapActionEffect_LoadPalettes
    push bc
    ld de, MapActionEffect_AreaAttackAnimation
    call MapAI_CreateAreaAttackEffectSprite
    ld a, $2b
    call Audio_PlaySFX
.animation_loop
    call Sprite_Update
    call DelayFrame
    ld a, [wMapEffectSpriteObjectId]
    ld b, $0b
    call SpriteObject_GetField
    cp $ff
    jr nz, .animation_loop
    ld a, [wMapEffectSpriteObjectId]
    call SpriteObject_Destroy
    call Sprite_Update
    pop bc

    xor a
    ld [wMapAIAreaAttackCellDamage], a
    farcall $12, UnitRecord_FindPrimaryAtCoordinates
    cp $ff
    jr z, .terrain_effect

    push bc
    ld d, a
    call MapAI_GetAreaAttackDamage
    ld e, a
    ld a, d
    ld c, UNIT_RECORD_HP_OFFSET
    farcall $12, UnitRecord_GetByte
    sub e
    pop bc
    jr c, .unit_destroyed
    jr z, .unit_destroyed

    push bc
    ld b, a
    ld a, d
    ld c, UNIT_RECORD_HP_OFFSET
    farcall $12, UnitRecord_SetByte
    pop bc
    ld a, e
    ld [wMapAIAreaAttackCellDamage], a
    and a
    jr z, .terrain_effect
    cpl
    inc a
    farcall $0c, MapHPChange_PresentSignedDelta
    jr .terrain_effect

.unit_destroyed
    add e
    ld [wMapAIAreaAttackCellDamage], a
    cpl
    inc a
    farcall $0c, MapHPChange_PresentSignedDelta
    ld a, d
    call Unit_DestroyWithMapAnimation

.terrain_effect
    call MapAI_ApplyAreaAttackTerrainEffect
    pop hl
    pop de
    pop bc
    ret

; A = victim live-unit index. Returns the per-hit HP damage selected from the
; victim target class and the acting unit's type. Bomber and Mercenary Bomber
; share one five-class profile; other callers use the alternate profile.
MapAI_GetAreaAttackDamage::
    push bc
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    ld c, UNIT_DATA_TARGET_CLASS_OFFSET
    farcall $12, UnitData_GetByte
    ld b, a
    ld hl, MapAI_BomberAreaAttackDamageByTargetClass
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    srl a
    cp UNIT_TYPE_BOMBER
    jr z, .index
    cp UNIT_TYPE_MERCENARY_BOMBER
    jr z, .index
    ld hl, MapAI_OtherAreaAttackDamageByTargetClass
.index
    ld a, b
    call AddAtoHL
    ld a, [hl]
    pop bc
    ret

MapAI_BomberAreaAttackDamageByTargetClass::
    db 1, 2, 3, 0, 1

MapAI_OtherAreaAttackDamageByTargetClass::
    db 2, 3, 0, 1, 0

    assert @ == $5138

; Apply the terrain/property half of one area-attack cell at B,C. The raw tile
; is reduced to the shared 23-class Terrain_GetNameIndex namespace and then
; dispatched through MapAI_AreaAttackTerrainEffectHandlers.
MapAI_ApplyAreaAttackTerrainEffect::
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    farcall $0b, Terrain_GetNameIndex
    ld hl, MapAI_AreaAttackTerrainEffectHandlers
    call WordTable_Get
    jp hl

; HQ and COM Tower state may be reduced, but retail never lets the area attack
; reduce either record below one point.
MapAI_AreaAttackDamageProtectedProperty:
    call MapAI_GetAreaAttackTerrainStateDelta
    ld d, a
    farcall $0c, PropertyState_GetAtCoordinates
    ld e, a
    ld a, d
    cpl
    inc a
    cp e
    jr c, .apply
    ld a, e
    dec a
    cpl
    inc a
    ld d, a
.apply
    ld a, d
    farcall $0c, PropertyState_ApplyDeltaWithPresentation
    jp MapAI_AreaAttackTerrainNoEffect

; CITY/BASE/AIRPORT/PORT state uses the normal signed area-attack delta. When
; it reaches zero the owned property is converted to its neutral ruins tile,
; its histogram entry is moved, and the surviving state record is reset to the
; base value for the ruins class.
MapAI_AreaAttackDamageDestructibleProperty:
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    call MapAI_GetAreaAttackTerrainStateDelta
    farcall $0c, PropertyState_ApplyDeltaWithPresentation
    and a
    jp nz, MapAI_AreaAttackTerrainNoEffect

    farcall $0b, MapTile_GetBaseIdAtCoordinates
    farcall $0b, MapGrid_DecrementTileCount
    farcall $0b, Terrain_GetNameIndex
    ld hl, MapAI_AreaAttackRuinsTileByTerrainClass
    call AddAtoHL
    ld a, [hl]
    ld d, a
    farcall $0b, MapTile_SetBaseIdAtCoordinates
    ld a, d
    farcall $0b, Terrain_GetNameIndex
    farcall $0c, PropertyState_GetBaseForTerrainClass
    farcall $0c, PropertyState_SetAtCoordinates
    ld a, d
    farcall $0b, MapGrid_IncrementTileCount
    ld a, d
    jr MapAI_AreaAttackReplaceTerrainAndRefresh

; RUNWAY is the one destructible property class whose zero-state transition
; removes the property-state record entirely and restores PLAIN terrain.
MapAI_AreaAttackDamageRunway:
    push bc
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    call MapAI_GetAreaAttackTerrainStateDelta
    farcall $0c, PropertyState_ApplyDeltaWithPresentation
    pop bc
    and a
    jp nz, MapAI_AreaAttackTerrainNoEffect
    farcall $0c, PropertyState_RemoveRecordAtCoordinates
    ld a, MAP_TERRAIN_PLAIN
    farcall $0b, MapTile_SetBaseIdAtCoordinates
    farcall $0b, Bank0B_MapSetup_43D1
    jr MapAI_AreaAttackTerrainNoEffect

; WOOD is cleared back to PLAIN.
MapAI_AreaAttackClearWood:
    ld a, MAP_TERRAIN_PLAIN
    jr MapAI_AreaAttackReplaceTerrainAndRefresh

; Both bridge classes collapse to RIVER. A ground unit (armored/unarmored)
; occupying the bridge is handed to the established $4ECB removal/death path;
; air/sea/submarine classes survive the terrain transition.
MapAI_AreaAttackDestroyBridge:
    push bc
    ld a, MAP_TERRAIN_RIVER
    farcall $0b, MapTile_SetBaseIdAtCoordinates
    farcall $0b, Bank0B_MapSetup_43D1
    pop bc
    farcall $12, UnitRecord_FindPrimaryAtCoordinates
    cp $ff
    jr z, MapAI_AreaAttackTerrainNoEffect
    ld d, a
    push bc
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    ld c, UNIT_DATA_TARGET_CLASS_OFFSET
    farcall $12, UnitData_GetByte
    pop bc
    cp UNIT_TARGET_CLASS_AIR
    jr nc, MapAI_AreaAttackTerrainNoEffect
    ld a, d
    call Unit_DestroyWithMapAnimation
    jr MapAI_AreaAttackTerrainNoEffect

; PLAIN and ROAD are scarred into WASTELAND.
MapAI_AreaAttackScarPlainOrRoad:
    ld a, MAP_TERRAIN_WASTELAND

; A = replacement raw terrain ID. Commit it at B,C and refresh the rendered
; map cell through the established Bank-$0B setup/presentation helper.
MapAI_AreaAttackReplaceTerrainAndRefresh:
    farcall $0b, MapTile_SetBaseIdAtCoordinates
    farcall $0b, Bank0B_MapSetup_43D1
    jr MapAI_AreaAttackTerrainNoEffect

MapAI_AreaAttackTerrainNoEffect:
    ret

; Return the signed property-state delta selected by the acting unit type.
; Bomber/Mercenary Bomber: -15; Mercenary Missile Frigate/Submarine-S: -25;
; all other unit types: 0.
MapAI_GetAreaAttackTerrainStateDelta:
    push bc
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    srl a
    cp UNIT_TYPE_BOMBER
    jr z, .bomber
    cp UNIT_TYPE_MERCENARY_BOMBER
    jr z, .bomber
    cp UNIT_TYPE_MERCENARY_MISSILE_FRIGATE
    jr z, .naval
    cp UNIT_TYPE_SUBMARINE_S
    jr z, .naval
    ld b, 0
    jr .done
.bomber
    ld b, -15
    jr .done
.naval
    ld b, -25
.done
    ld a, b
    pop bc
    ret

; Terrain-name classes 0-$0B. Only intact CITY/BASE/AIRPORT/PORT entries use
; the replacement table; each becomes the matching neutral ruins raw tile.
MapAI_AreaAttackRuinsTileByTerrainClass:
    db 0
    db 0
    db MAP_TILE_NEUTRAL_CITY_RUINS
    db 0
    db MAP_TILE_NEUTRAL_BASE_RUINS
    db 0
    db MAP_TILE_NEUTRAL_AIRPORT_RUINS
    db 0
    db 0
    db MAP_TILE_NEUTRAL_PORT_RUINS
    db 0
    db 0

; Exact Terrain_GetNameIndex order (23 entries).
MapAI_AreaAttackTerrainEffectHandlers:
    dw MapAI_AreaAttackTerrainNoEffect              ; 00 unused/empty
    dw MapAI_AreaAttackDamageProtectedProperty      ; 01 HQ
    dw MapAI_AreaAttackDamageDestructibleProperty   ; 02 CITY
    dw MapAI_AreaAttackTerrainNoEffect              ; 03 CITY ruins
    dw MapAI_AreaAttackDamageDestructibleProperty   ; 04 BASE
    dw MapAI_AreaAttackTerrainNoEffect              ; 05 BASE ruins
    dw MapAI_AreaAttackDamageDestructibleProperty   ; 06 AIRPORT
    dw MapAI_AreaAttackTerrainNoEffect              ; 07 AIRPORT ruins
    dw MapAI_AreaAttackDamageRunway                 ; 08 RUNWAY
    dw MapAI_AreaAttackDamageDestructibleProperty   ; 09 PORT
    dw MapAI_AreaAttackTerrainNoEffect              ; 0A PORT ruins
    dw MapAI_AreaAttackDamageProtectedProperty      ; 0B COM TOWER
    dw MapAI_AreaAttackScarPlainOrRoad              ; 0C PLAIN
    dw MapAI_AreaAttackScarPlainOrRoad              ; 0D ROAD
    dw MapAI_AreaAttackDestroyBridge                ; 0E BRIDGE 1
    dw MapAI_AreaAttackDestroyBridge                ; 0F BRIDGE 2
    dw MapAI_AreaAttackTerrainNoEffect              ; 10 MOUNTAIN
    dw MapAI_AreaAttackClearWood                    ; 11 WOOD
    dw MapAI_AreaAttackTerrainNoEffect              ; 12 WASTELAND
    dw MapAI_AreaAttackTerrainNoEffect              ; 13 DESERT
    dw MapAI_AreaAttackTerrainNoEffect              ; 14 RIVER
    dw MapAI_AreaAttackTerrainNoEffect              ; 15 SEA
    dw MapAI_AreaAttackTerrainNoEffect              ; 16 SHOAL

    assert @ == $5259

; Create and position the per-cell visual effect. DE supplies the existing
; Bank-$0C animation resource pointer ($53AE in the current caller).
MapAI_CreateAreaAttackEffectSprite::
    push bc
    ld a, $20
    ld c, $80
    ld b, $0c
    call SpriteObject_Create
    ld [wMapEffectSpriteObjectId], a
    ld b, $05
    call SpriteObject_SetPalette
    pop bc
    ld a, [wMapEffectSpriteObjectId]
    call MapAI_PositionAreaAttackEffectSprite
    ret

; A = sprite-object ID, B/C = map coordinates. Convert the map coordinate to
; viewport-relative pixels; coordinates above/left of the viewport are ignored.
MapAI_PositionAreaAttackEffectSprite::
    push bc
    push de
    ld h, a
    ld a, [wMapViewportOriginX]
    ld d, a
    ld a, b
    sub d
    jr c, .done
    ld d, a
    ld a, [wMapViewportOriginY]
    ld e, a
    ld a, c
    sub e
    jr c, .done
    ld e, a
    ld a, d
    swap a
    add $10
    ld d, a
    ld a, e
    swap a
    add $18
    ld e, a
    ld a, c
    and $01
    jr z, .position
    ld a, d
    add $08
    ld d, a
.position
    ld b, d
    ld c, e
    ld a, h
    call SpriteObject_SetPosition
.done
    pop de
    pop bc
    ret

    assert @ == $52a6
