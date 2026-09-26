include "macros/macros.inc"
include "constants/unit_constants.inc"

; Shared Map Editor ARRANGE option presentation and selection-resolution data.
; The terrain ARRANGE controller owns five classes; the unit ARRANGE controller
; owns six visible classes plus a seventh DELETE class. Per-class values are
; one-based indexes into the class lists below. Each list stores its maximum at
; offset 0 followed by the selectable terrain/unit IDs.

DEF wMapEditorArrangeSelectionClass       EQU $ca57
DEF wMapEditorUnitArrangeSelectionClass   EQU $ca58
DEF wMapEditorArrangeSelectionValues      EQU $ca59
DEF wMapEditorUnitArrangeSelectionValues  EQU $ca5e
DEF wMapEditorSelectedTerrainId           EQU $ca65
DEF wMapEditorSelectedUnitId              EQU $ca66
DEF wMapCursorSpriteObjectId              EQU $c98d

DEF MAP_EDITOR_UNIT_CLASS_SIDE0_GROUND EQU 0
DEF MAP_EDITOR_UNIT_CLASS_SIDE0_AIR    EQU 1
DEF MAP_EDITOR_UNIT_CLASS_SIDE0_SEA    EQU 2
DEF MAP_EDITOR_UNIT_CLASS_SIDE1_GROUND EQU 3
DEF MAP_EDITOR_UNIT_CLASS_SIDE1_AIR    EQU 4
DEF MAP_EDITOR_UNIT_CLASS_SIDE1_SEA    EQU 5
DEF MAP_EDITOR_UNIT_CLASS_DELETE       EQU 6

section "Map Editor Unit Arrange Option Renderer", romx[$517e], bank[$0f]

; A = unit arrange class (0..5). Resolve the class's current one-based value,
; load that side-specific unit graphic into its class slot, and draw the 2x2
; metatile in the six-column unit panel.
MapEditor_UnitArrange_DrawOption::
    push bc
    push de
    ld b, a
    ld hl, wMapEditorUnitArrangeSelectionValues
    call AddAtoHL
    ld c, [hl]
    ld a, b
    ld hl, MapEditor_UnitArrangeClassPointers
    call WordTable_Get
    ld a, c
    call AddAtoHL
    ld a, [hl]
    add a
    ld c, a
    ld a, b
    cp MAP_EDITOR_UNIT_CLASS_SIDE1_GROUND
    jr c, .have_side
    inc c
.have_side
    ld a, 0
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, b
    call MapEditor_Arrange_GetOptionTileDestination
    ld a, c
    farcall UnitGraphic_LoadTiles
    push bc
    ld a, b
    ld hl, MapEditor_UnitArrangeOptionXCoordinates
    call AddAtoHL
    ld b, [hl]
    ld c, $21
    call Vram_TilemapCoord
    pop bc
    ld d, c
    ld a, b
    add a
    add a
    add $c0
    ld bc, $0003
    farcall UnitGraphic_DrawMetatile
    pop de
    pop bc
    ret

    assert @ == $51ca

section "Map Editor Unit Arrange Option Coordinates", romx[$51ca], bank[$0f]

; Tilemap X columns for the six visible unit classes plus the DELETE class.
MapEditor_UnitArrangeOptionXCoordinates::
    db $01, $03, $05, $07, $09, $0b, $0d

    assert @ == $51d1

section "Map Editor Unit Arrange Cursor", romx[$51d1], bank[$0f]

; Position the shared map-cursor sprite over the current unit-arrange class.
MapEditor_UnitArrange_UpdateCursorSprite::
    push bc
    ld a, [wMapEditorUnitArrangeSelectionClass]
    ld hl, MapEditor_UnitArrangeOptionXCoordinates
    call AddAtoHL
    ld a, [hl]
    rlca
    rlca
    rlca
    add $10
    ld b, a
    ld a, $0d
    rlca
    rlca
    rlca
    add $18
    ld c, a
    ld a, [wMapCursorSpriteObjectId]
    call SpriteObject_SetPosition
    pop bc
    ret

    assert @ == $51f2

section "Map Editor Arrange Option VRAM Destination", romx[$5218], bank[$0f]

; A = option slot. Return HL = $8C00 + slot * 64 bytes, preserving DE.
; Each slot therefore owns four 2bpp tiles for one 2x2 option metatile.
MapEditor_Arrange_GetOptionTileDestination::
    push de
    swap a
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    ld de, $8c00
    add hl, de
    pop de
    ret

    assert @ == $5226

section "Map Editor Arrange Selection Resolver", romx[$5226], bank[$0f]

; Resolve the current terrain and unit class/value selections into the raw map
; tile ID and packed unit type/side byte consumed by the placement controller.
MapEditor_Arrange_RebuildSelection::
    ld a, [wMapEditorArrangeSelectionClass]
    ld c, a
    ld b, 0
    ld hl, wMapEditorArrangeSelectionValues
    add hl, bc
    ld d, [hl]
    ld a, [wMapEditorArrangeSelectionClass]
    ld hl, MapEditor_TerrainArrangeClassPointers
    call WordTable_Get
    ld c, d
    ld b, 0
    add hl, bc
    ld a, [hl]
    ld [wMapEditorSelectedTerrainId], a

    ld a, [wMapEditorUnitArrangeSelectionClass]
    ld c, a
    ld b, 0
    ld hl, wMapEditorUnitArrangeSelectionValues
    add hl, bc
    ld d, [hl]
    ld a, [wMapEditorUnitArrangeSelectionClass]
    ld hl, MapEditor_UnitArrangeClassPointers
    call WordTable_Get
    ld c, d
    ld b, 0
    add hl, bc
    ld a, [hl]
    add a
    ld b, a
    ld a, [wMapEditorUnitArrangeSelectionClass]
    cp MAP_EDITOR_UNIT_CLASS_SIDE1_GROUND
    jr c, .store_unit
    cp MAP_EDITOR_UNIT_CLASS_DELETE
    jr z, .store_unit
    inc b
.store_unit
    ld a, b
    ld [wMapEditorSelectedUnitId], a
    ret

    assert @ == $526e

section "Map Editor Terrain Arrange Classes", romx[$526e], bank[$0f]

MapEditor_TerrainArrangeClassPointers::
    dw MapEditor_TerrainArrange_Side0Properties
    dw MapEditor_TerrainArrange_Side1Properties
    dw MapEditor_TerrainArrange_NeutralProperties
    dw MapEditor_TerrainArrange_Land
    dw MapEditor_TerrainArrange_Water

; The first byte of each list is the maximum one-based selection value.
MapEditor_TerrainArrange_Side0Properties:
    db 5
    db MAP_TILE_SIDE0_HQ
    db MAP_TILE_SIDE0_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_CITY - 1
    db MAP_TILE_SIDE0_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_BASE - 1
    db MAP_TILE_SIDE0_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_AIRPORT - 1
    db MAP_TILE_SIDE0_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_PORT - 1

MapEditor_TerrainArrange_Side1Properties:
    db 5
    db MAP_TILE_SIDE1_HQ
    db MAP_TILE_SIDE1_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_CITY - 1
    db MAP_TILE_SIDE1_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_BASE - 1
    db MAP_TILE_SIDE1_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_AIRPORT - 1
    db MAP_TILE_SIDE1_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_PORT - 1

MapEditor_TerrainArrange_NeutralProperties:
    db 8
    db MAP_TILE_NEUTRAL_CITY, MAP_TILE_NEUTRAL_CITY_RUINS
    db MAP_TILE_NEUTRAL_BASE, MAP_TILE_NEUTRAL_BASE_RUINS
    db MAP_TILE_NEUTRAL_AIRPORT, MAP_TILE_NEUTRAL_AIRPORT_RUINS
    db MAP_TILE_NEUTRAL_PORT, MAP_TILE_NEUTRAL_PORT_RUINS

MapEditor_TerrainArrange_Land:
    db 6
    db MAP_TERRAIN_PLAIN, MAP_TERRAIN_MOUNTAIN, MAP_TERRAIN_WOOD
    db MAP_TERRAIN_WASTELAND, MAP_TERRAIN_DESERT, MAP_TERRAIN_ROAD

MapEditor_TerrainArrange_Water:
    db 4
    db MAP_TERRAIN_RIVER, MAP_TERRAIN_BRIDGE_1, MAP_TERRAIN_SHOAL, MAP_TERRAIN_SEA

    assert @ == $5299

section "Map Editor Unit Arrange Classes", romx[$5299], bank[$0f]

MapEditor_UnitArrangeClassPointers::
    dw MapEditor_UnitArrange_Ground
    dw MapEditor_UnitArrange_Air
    dw MapEditor_UnitArrange_Sea
    dw MapEditor_UnitArrange_Ground
    dw MapEditor_UnitArrange_Air
    dw MapEditor_UnitArrange_Sea
    dw MapEditor_UnitArrange_Delete

MapEditor_UnitArrange_Ground:
    db 25
    db UNIT_TYPE_INFANTRY
    db UNIT_TYPE_MISSILE_INFANTRY
    db UNIT_TYPE_CONSTRUCTION_TRUCK
    db UNIT_TYPE_SUPPLY_TRUCK
    db UNIT_TYPE_SUPPLY_TRUCK_S
    db UNIT_TYPE_TRANSPORT_TRUCK
    db UNIT_TYPE_TRANSPORT_TRUCK_S
    db UNIT_TYPE_COMBAT_BUGGY
    db UNIT_TYPE_COMBAT_BUGGY_S
    db UNIT_TYPE_COMBAT_VEHICLE
    db UNIT_TYPE_COMBAT_VEHICLE_S
    db UNIT_TYPE_APC
    db UNIT_TYPE_APC_S
    db UNIT_TYPE_ROCKET_LAUNCHER
    db UNIT_TYPE_ROCKET_LAUNCHER_S
    db UNIT_TYPE_ANTI_AIR_TANK
    db UNIT_TYPE_ANTI_AIR_MISSILES
    db UNIT_TYPE_ANTI_AIR_MISSILES_S
    db UNIT_TYPE_ARTILLERY
    db UNIT_TYPE_ARTILLERY_S
    db UNIT_TYPE_IFV
    db UNIT_TYPE_IFV_S
    db UNIT_TYPE_TANK_DESTROYER
    db UNIT_TYPE_TANK_DESTROYER_S
    db UNIT_TYPE_TANK

MapEditor_UnitArrange_Air:
    db 14
    db UNIT_TYPE_FIGHTER_PLANE_A
    db UNIT_TYPE_FIGHTER_PLANE_B
    db UNIT_TYPE_FIGHTER_PLANE_S
    db UNIT_TYPE_ATTACK_PLANE_A
    db UNIT_TYPE_ATTACK_PLANE_B
    db UNIT_TYPE_ATTACK_PLANE_S
    db UNIT_TYPE_BOMBER
    db UNIT_TYPE_TRANSPORT_PLANE
    db UNIT_TYPE_REFUELING_PLANE
    db UNIT_TYPE_BATTLE_HELICOPTER
    db UNIT_TYPE_BATTLE_HELICOPTER_S
    db UNIT_TYPE_ANTI_SUB_HELICOPTER
    db UNIT_TYPE_TRANSPORT_HELICOPTER
    db UNIT_TYPE_TRANSPORT_HELICOPTER_S

MapEditor_UnitArrange_Sea:
    db 7
    db UNIT_TYPE_AEGIS_WARSHIP
    db UNIT_TYPE_LARGE_CARRIER
    db UNIT_TYPE_SMALL_CARRIER
    db UNIT_TYPE_TRANSPORT_SHIP
    db UNIT_TYPE_SUPPLY_TANKER
    db UNIT_TYPE_SUBMARINE
    db UNIT_TYPE_SUBMARINE_S

MapEditor_UnitArrange_Delete:
    db 1
    db UNIT_TYPE_EMPTY

    assert @ == $52da
