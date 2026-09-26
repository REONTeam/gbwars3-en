include "macros/macros.inc"
include "constants/unit_constants.inc"

; Construction Truck FORTIFY executor used by the player Unit Action dispatcher
; and the corresponding map-AI development path. Existing properties consume one
; unit of the Construction Truck's first-ammo/resource counter; restoring a
; neutral ruined property requires two. The Bank-$0C property-state runtime
; adds current HP, clamps to the terrain-specific maximum, and when a ruin is
; completed the tile is converted to the current side's owned property variant
; before the map economy is rebuilt.

section "Unit Terrain Development Action", romx[$489c], bank[$0b]

Unit_DevelopTerrainAtCurrentPosition::
    push bc
    push de

    ld a, [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET]
    and a
    jp z, .insufficient_resource

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call MapTile_GetBaseIdAtCoordinates
    call MapTile_IsNeutralPropertyRuins
    and a
    jr nz, .resource_check_done

    ld a, [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET]
    cp $02
    jr c, .insufficient_resource

.resource_check_done
    farcall $11, CampaignStats_SetProcuredFlag36ForPrimarySide
    ld a, $01
    farcall $0c, UnitAction_PresentActionEffect

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_HP_OFFSET]
    farcall $0c, PropertyState_ApplyDeltaWithPresentation

    ld a, [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET]
    dec a
    ld [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET], a
    farcall $0c, PropertyState_CompareCurrentToTerrainMaximum
    jr nz, .done

    ld a, SFX_DEVELOP_PROPERTY
    call Audio_PlaySFX
    ld a, $00
    call MapControl_ResolutionSceneRefresh

    call MapTile_GetBaseIdAtCoordinates
    ld e, a
    call MapTile_IsNeutralPropertyRuins
    and a
    jr nz, .done

    ; Convert a completed neutral ruin to the property variant owned by the
    ; current side. The two $41xx helpers are retained structurally until their
    ; exact terrain-state side effects are independently proven.
    ld a, e
    call MapGrid_DecrementTileCount
    call Terrain_GetNameIndex
    ld d, a
    ld e, $00
    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    jr z, .have_side_property_offset
    ld e, $0b
.have_side_property_offset
    ld a, d
    add a, e
    dec a
    ld e, a
    call MapTile_SetBaseIdAtCoordinates

    ld a, e
    call Terrain_GetNameIndex
    farcall $0c, PropertyState_GetBaseForTerrainClass
    farcall $0c, PropertyState_SetAtCoordinates
    ld a, e
    call MapGrid_IncrementTileCount
    call MapEconomy_RecalculateIncome

    ld a, [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET]
    dec a
    ld [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET], a
    farcall $11, CampaignStats_IncrementDevelopedProperties
    xor a

.done
    pop de
    pop bc
    ret

.insufficient_resource
    ld a, SFX_ERROR
    call Audio_PlaySFX
    ld a, $10
    call MapControl_ResolutionSceneRefresh
    ld a, $ff
    jr .done

    assert @ == $4941

section "Terrain Development Predicates", romx[$7d54], bank[$0b]

; Return A = 0 only for terrain-name classes Plain, Wood, or Wasteland.
; These are the natural-terrain classes accepted by the development action.
MapTile_IsDevelopableNaturalTerrain::
    call Terrain_GetNameIndex
    cp MOVEMENT_TERRAIN_PLAIN
    jr c, .reject
    jr z, .accept
    cp MOVEMENT_TERRAIN_WOOD
    jr z, .accept
    cp MOVEMENT_TERRAIN_WASTELAND
    jr z, .accept
    jr .reject
.accept
    xor a
    jr .done
.reject
    ld a, $01
.done
    ret

    assert @ == $7d6d

; Return A = 0 only for one of the four neutral property-ruin tile IDs.
MapTile_IsNeutralPropertyRuins::
    cp MAP_TILE_NEUTRAL_CITY_RUINS
    jr z, .accept
    cp MAP_TILE_NEUTRAL_BASE_RUINS
    jr z, .accept
    cp MAP_TILE_NEUTRAL_AIRPORT_RUINS
    jr z, .accept
    cp MAP_TILE_NEUTRAL_PORT_RUINS
    jr z, .accept
    ld a, $01
    jr .done
.accept
    xor a
.done
    ret

    assert @ == $7d83
