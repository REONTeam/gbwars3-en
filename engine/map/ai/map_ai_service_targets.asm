include "macros/macros.inc"
include "constants/unit_constants.inc"

; AI target-list builders used by the repair/resupply routing paths.
; $C949-$C988 is a lifetime-scoped 64-byte list buffer. Property-list entries
; are side-relative raw property offsets; a zero byte terminates the list.

DEF wMapAIServiceTargetList EQU $c949
DEF MAP_AI_SERVICE_TARGET_LIST_SIZE EQU $40

section "Map AI Service Target Builders", romx[$6f70], bank[$0c]

MapAI_ClearServiceTargetList::
    push bc
    ld hl, wMapAIServiceTargetList
    ld bc, MAP_AI_SERVICE_TARGET_LIST_SIZE
    xor a
    call $3b79
    pop bc
    ret

; A = unit type (not encoded with side). If the definition's first accepted
; carried class is class 3, return the Large/Small Carrier type pair.
MapAI_BuildCompatibleCarrierTypeList::
    push bc
    add a
    ld b, a
    call MapAI_ClearServiceTargetList
    ld a, b
    ld c, UNIT_DATA_CARRIED_TYPE1_OFFSET
    farcall $12, UnitData_GetByte
    cp 3
    jr nz, .done
    ld a, UNIT_TYPE_LARGE_CARRIER
    ld [wMapAIServiceTargetList], a
    ld a, UNIT_TYPE_SMALL_CARRIER
    ld [wMapAIServiceTargetList + 1], a
.done
    pop bc
    ret

; A = unit type. Build the side-relative property offsets accepted for repair.
; Ground units use HQ/City/Base, Construction/Supply Trucks omit City, aircraft
; use Airport only, and sea/submarine units use Port.
MapAI_BuildRepairPropertyOffsets::
    push bc
    ld b, a
    call MapAI_ClearServiceTargetList
    ld a, b
    add a
    ld c, UNIT_DATA_TARGET_CLASS_OFFSET
    farcall $12, UnitData_GetByte
    cp UNIT_TARGET_CLASS_AIR
    jr z, .air
    cp UNIT_TARGET_CLASS_SEA
    jr z, .naval
    cp UNIT_TARGET_CLASS_SUBMARINE
    jr z, .naval
    ld a, b
    cp UNIT_TYPE_CONSTRUCTION_TRUCK
    jr z, .ground_service
    cp UNIT_TYPE_SUPPLY_TRUCK
    jr z, .ground_service
    cp UNIT_TYPE_SUPPLY_TRUCK_S
    jr z, .ground_service
    ld a, MAP_PROPERTY_OFFSET_HQ
    ld [wMapAIServiceTargetList], a
    ld a, MAP_PROPERTY_OFFSET_CITY
    ld [wMapAIServiceTargetList + 1], a
    ld a, MAP_PROPERTY_OFFSET_BASE
    ld [wMapAIServiceTargetList + 2], a
    jr .done
.ground_service
    ld a, MAP_PROPERTY_OFFSET_HQ
    ld [wMapAIServiceTargetList], a
    ld a, MAP_PROPERTY_OFFSET_BASE
    ld [wMapAIServiceTargetList + 1], a
    jr .done
.air
    ld a, MAP_PROPERTY_OFFSET_AIRPORT
    ld [wMapAIServiceTargetList], a
    jr .done
.naval
    ld a, MAP_PROPERTY_OFFSET_PORT
    ld [wMapAIServiceTargetList], a
.done
    pop bc
    ret

; A = recipient unit type. Build a list of unit types that can resupply it.
; The main loop tests unit types 5..49 through Unit_CanReceiveSupplyFrom; units
; whose carried-class contract is class 3 also admit Large/Small Carriers.
MapAI_BuildResupplyProviderTypeList::
    push bc
    add a
    ld c, a
    call MapAI_ClearServiceTargetList
    ld b, UNIT_TYPE_SUPPLY_TRUCK
    ld hl, wMapAIServiceTargetList
.loop
    push bc
    push hl
    ld a, b
    add a
    ld b, a
    ld a, c
    farcall $12, Unit_CanReceiveSupplyFrom
    pop hl
    pop bc
    and a
    jr nz, .next
    ld [hl], b
    inc hl
.next
    inc b
    ld a, b
    cp UNIT_TYPE_SUBMARINE
    jr nz, .loop
    push hl
    ld a, c
    ld c, UNIT_DATA_CARRIED_TYPE1_OFFSET
    farcall $12, UnitData_GetByte
    pop hl
    cp 3
    jr nz, .done
    ld a, UNIT_TYPE_LARGE_CARRIER
    ld [hl+], a
    ld a, UNIT_TYPE_SMALL_CARRIER
    ld [hl], a
.done
    pop bc
    ret

; Resupply uses the same property family as repair, except aircraft may also
; use Runway. This byte-level difference mirrors Unit_CanResupplyAtCurrentTerrain.
MapAI_BuildResupplyPropertyOffsets::
    push bc
    ld b, a
    call MapAI_ClearServiceTargetList
    ld a, b
    add a
    ld c, UNIT_DATA_TARGET_CLASS_OFFSET
    farcall $12, UnitData_GetByte
    cp UNIT_TARGET_CLASS_AIR
    jr z, .air
    cp UNIT_TARGET_CLASS_SEA
    jr z, .naval
    cp UNIT_TARGET_CLASS_SUBMARINE
    jr z, .naval
    ld a, b
    cp UNIT_TYPE_CONSTRUCTION_TRUCK
    jr z, .ground_service
    cp UNIT_TYPE_SUPPLY_TRUCK
    jr z, .ground_service
    cp UNIT_TYPE_SUPPLY_TRUCK_S
    jr z, .ground_service
    ld a, MAP_PROPERTY_OFFSET_HQ
    ld [wMapAIServiceTargetList], a
    ld a, MAP_PROPERTY_OFFSET_CITY
    ld [wMapAIServiceTargetList + 1], a
    ld a, MAP_PROPERTY_OFFSET_BASE
    ld [wMapAIServiceTargetList + 2], a
    jr .done
.ground_service
    ld a, MAP_PROPERTY_OFFSET_HQ
    ld [wMapAIServiceTargetList], a
    ld a, MAP_PROPERTY_OFFSET_BASE
    ld [wMapAIServiceTargetList + 1], a
    jr .done
.air
    ld a, MAP_PROPERTY_OFFSET_AIRPORT
    ld [wMapAIServiceTargetList], a
    ld a, MAP_PROPERTY_OFFSET_RUNWAY
    ld [wMapAIServiceTargetList + 1], a
    jr .done
.naval
    ld a, MAP_PROPERTY_OFFSET_PORT
    ld [wMapAIServiceTargetList], a
.done
    pop bc
    ret

    assert @ == $7078
