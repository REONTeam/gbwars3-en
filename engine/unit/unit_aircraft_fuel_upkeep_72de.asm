include "macros/macros.inc"
include "constants/unit_constants.inc"

; End-phase aircraft fuel servicing. The routine scans the active side's
; 50-unit live pool. Non-carried/non-reserve aircraft consume their UnitData
; fuel-upkeep value unless they are parked on a current-side AIRPORT or RUNWAY.
; Aircraft that cannot pay the upkeep are destroyed with the normal map effect.
DEF wAircraftFuelScanUnitIndex EQU $c940
DEF wAircraftFuelScanTypeSide  EQU $c941
DEF wAircraftFuelScanX         EQU $c942
DEF wAircraftFuelScanY         EQU $c943

section "End Phase Aircraft Fuel Upkeep", romx[$72de], bank[$0c]

UnitPhase_ProcessAircraftFuelUpkeep::
    push bc
    push de
    xor a
    ld [wAircraftFuelScanUnitIndex], a
    ld e, UNITS_PER_SIDE
    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    jr z, .scan
    ld a, UNITS_PER_SIDE
    ld [wAircraftFuelScanUnitIndex], a

.scan
    push de
    ld a, [wAircraftFuelScanUnitIndex]
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    and a
    jp z, .next
    ld [wAircraftFuelScanTypeSide], a

    ld a, [wAircraftFuelScanUnitIndex]
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall $12, UnitRecord_GetByte
    bit UNIT_RECORD_STATUS_RESERVE_F, a
    jp nz, .next
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jp nz, .next

    ld a, [wAircraftFuelScanTypeSide]
    ld c, UNIT_DATA_TARGET_CLASS_OFFSET
    farcall $12, UnitData_GetByte
    cp UNIT_TARGET_CLASS_AIR
    jr nz, .next

    ld a, [wAircraftFuelScanUnitIndex]
    ld c, UNIT_RECORD_X_OFFSET
    farcall $12, UnitRecord_GetWord
    ld a, e
    ld b, a
    ld [wAircraftFuelScanX], a
    ld a, d
    ld c, a
    ld [wAircraftFuelScanY], a

    farcall $0b, MapTile_GetBaseIdAtCoordinates
    ld c, a
    farcall $0b, MapTile_GetPhaseOwnershipClass
    cp MAP_TILE_PHASE_CLASS_CURRENT_PROPERTY
    jr nz, .apply_upkeep
    ld a, c
    farcall $0b, Terrain_GetNameIndex
    cp MOVEMENT_TERRAIN_AIRPORT
    jr z, .next
    cp MOVEMENT_TERRAIN_RUNWAY
    jr z, .next

.apply_upkeep
    ld a, [wAircraftFuelScanTypeSide]
    ld c, UNIT_DATA_FUEL_UPKEEP_OFFSET
    farcall $12, UnitData_GetByte
    ld b, a
    ld a, [wAircraftFuelScanUnitIndex]
    ld c, UNIT_RECORD_FUEL_OFFSET
    farcall $12, UnitRecord_GetByte
    sub b
    jr c, .destroy
    jr z, .destroy
    ld b, a
    ld a, [wAircraftFuelScanUnitIndex]
    ld c, UNIT_RECORD_FUEL_OFFSET
    farcall $12, UnitRecord_SetByte
    jr .next

.destroy
    ld a, [wAircraftFuelScanX]
    ld b, a
    ld a, [wAircraftFuelScanY]
    ld c, a
    push bc
    farcall $0b, MapControl_PanToCoordinates
    farcall $0b, MapCursor_UpdatePropertyEligibilityAppearance
    call Sprite_Update
    pop bc
    ld a, [wAircraftFuelScanUnitIndex]
    farcall $0c, Unit_DestroyWithMapAnimation
    ld a, $0a
    farcall $0b, MapControl_ResolutionSceneRefresh

.next
    pop de
    ld a, [wAircraftFuelScanUnitIndex]
    inc a
    ld [wAircraftFuelScanUnitIndex], a
    dec e
    jp nz, .scan

    pop de
    pop bc
    ret

    assert @ == $73a5
