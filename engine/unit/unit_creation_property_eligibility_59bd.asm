include "macros/macros.inc"

; Unit Creation property eligibility helper.
; B/C are the candidate map coordinates. Return A = the accepted terrain-name
; property index (HQ/City/Base/Airport/Port) when the cell is empty, belongs to
; the current side, and lies within three hexes of that side's HQ; otherwise 0.
section "Bank $0B Unit Creation property eligibility", romx[$59bd], bank[$0b]

UnitCreation_GetEligiblePropertyTypeNearHQ::
    push bc
    push de
    push hl

    call MapTile_GetOverlayIdAtCoordinates
    and a
    jr nz, .not_eligible

    call MapTile_GetBaseIdAtCoordinates
    ld e, a
    call MapTile_GetPhaseOwnershipClass
    cp MAP_TILE_PHASE_CLASS_CURRENT_PROPERTY
    jr nz, .not_eligible

    ld a, e
    call Terrain_GetNameIndex
    cp MAP_PROPERTY_OFFSET_HQ
    jr z, .accepted_property_type
    cp MAP_PROPERTY_OFFSET_CITY
    jr z, .accepted_property_type
    cp MAP_PROPERTY_OFFSET_BASE
    jr z, .accepted_property_type
    cp MAP_PROPERTY_OFFSET_AIRPORT
    jr z, .accepted_property_type
    cp MAP_PROPERTY_OFFSET_PORT
    jr z, .accepted_property_type
    jr .not_eligible

.accepted_property_type
    ld e, a
    push de
    ld a, [wMapPhaseNumber]
    and $01
    rlca
    ld e, a
    ld d, $00
    ld hl, wMapSide0HQCoordinates
    add hl, de
    ld d, [hl]
    inc hl
    ld e, [hl]
    call HexGrid_GetDistance
    pop de
    cp $04
    jr nc, .not_eligible
    ld a, e
    jr .done

.not_eligible
    xor a

.done
    pop hl
    pop de
    pop bc
    ret

    assert @ == $5a0d
