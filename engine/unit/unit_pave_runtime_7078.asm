include "macros/macros.inc"
include "constants/unit_constants.inc"
include "constants/map_analysis_constants.inc"

; Construction Truck PAVE support. PAVE reuses the MOVE interaction with a
; dedicated route-analysis workspace: WRAM bank 5 stores movement cost, WRAM
; bank 7 stores cumulative paving cost, WRAM bank 6 stores opposing-unit
; occupancy/adjacency, and WRAM bank 2 bit 7 marks selectable cells.
;
; The paving resource is the Construction Truck's weapon-1 ammunition field.
; PLAIN costs 1 point; WOOD and WASTELAND cost 2; all other terrain costs 0
; and therefore cannot be paved.

DEF wUnitPaveModeFlag              EQU $c9dd
DEF hUnitPaveQueueReadIndex        EQU $ff99
DEF hUnitPaveQueueCount            EQU $ff9a
DEF hUnitPaveMovementLimit         EQU $ff9b
DEF hUnitPaveCurrentMovementCost   EQU $ff9c
DEF hUnitPaveStock                 EQU $ff9d
DEF hUnitPaveCurrentCost           EQU $ff9e
DEF wUnitPaveRouteQueue            EQU $de00

section "Unit Pave Availability and Terrain Cost", romx[$7078], bank[$0c]

; Return A=0 when the selected unit can PAVE its current cell or at least one
; adjacent cell. Only an uncarried Construction Truck is eligible, and its
; weapon-1 ammunition must cover the terrain's paving cost.
UnitPave_CheckAvailableAtOrAdjacent::
    push bc
    push de
    push hl
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    srl a
    cp UNIT_TYPE_CONSTRUCTION_TRUCK
    jr nz, .unavailable
    ld a, [wUnitRecordScratch + UNIT_RECORD_STATUS_OFFSET]
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr nz, .unavailable

    farcall $0b, MapTile_GetBaseIdAtCoordinates
    call UnitPave_GetTerrainCost
    and a
    jr z, .scan_neighbors
    ld h, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET]
    cp h
    jr nc, .available
    jr .unavailable

.scan_neighbors
    ld e, 0
.neighbor_loop
    push bc
    push de
    call HexGrid_GetNeighborCoord
    jr c, .neighbor_done
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    call UnitPave_GetTerrainCost
    pop de
    pop bc
    and a
    jr z, .next_neighbor
    ld h, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET]
    cp h
    jr nc, .available
    jr .next_neighbor
.neighbor_done
    pop de
    pop bc
.next_neighbor
    inc e
    ld a, e
    cp 6
    jr nz, .neighbor_loop
.unavailable
    ld a, 1
    jr .done
.available
    xor a
.done
    pop hl
    pop de
    pop bc
    ret

; A = raw map-tile ID. Return A = paving resource cost:
;   PLAIN      -> 1
;   WOOD       -> 2
;   WASTELAND  -> 2
;   everything else -> 0
UnitPave_GetTerrainCost::
    push hl
    farcall $0b, Terrain_GetNameIndex
    ld h, 1
    cp MOVEMENT_TERRAIN_PLAIN
    jr z, .done
    inc h
    cp MOVEMENT_TERRAIN_WOOD
    jr z, .done
    cp MOVEMENT_TERRAIN_WASTELAND
    jr z, .done
    ld h, 0
.done
    ld a, h
    pop hl
    ret

    assert @ == $70e6

section "Unit Pave Route Analysis", romx[$70e6], bank[$0c]

; Build the selectable PAVE/MOVE route workspace from B/C. Movement cost is
; bounded by the unit's normal movement/fuel-derived range while paving cost is
; independently bounded by weapon-1 ammunition. Cells occupied by the opposing
; side are rejected; cells adjacent to opposing units may be selected but do
; not propagate the breadth-first expansion any farther.
UnitPave_BuildRouteAnalysisWorkspace::
    ldh a, [hWRAMBank]
    push af
    ld a, 5
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ld a, [wMapAnalysisContext0]
    and 1
    xor 1
    farcall $0b, MapAI_BuildSideUnitOccupancyAdjacencyGrid

    ld a, $ff
    ld hl, $d000
    ld bc, $0d80
    call Memset

    ldh a, [hWRAMBank]
    push af
    ld a, 7
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld hl, $d000
    ld bc, $0d80
    call Memset
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    farcall $0b, MapRuntime_GetAnalysisRangeParameter
    ldh [hUnitPaveMovementLimit], a
    ld a, $0d
    farcall $12, MovementData_BuildMapTileCosts

    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    ld a, [wMapAnalysisContext4]
    ldh [hUnitPaveStock], a
    call .seed_start
    farcall $0b, Bank0B_MapSetup_428A

    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

.seed_start
    xor a
    ldh [hUnitPaveQueueReadIndex], a
    ldh [hUnitPaveQueueCount], a
    ldh [hUnitPaveCurrentMovementCost], a

    call MapGridCoord
    xor a
    ld [hl], a

    ldh a, [hWRAMBank]
    push af
    ld a, 1
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [hl]
    and $3f
    push hl
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    call UnitPave_GetTerrainCost
    ld d, a
    ld a, 7
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    ld [hl], d
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ldh a, [hWRAMBank]
    push af
    ld a, 2
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    set 7, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ldh a, [hUnitPaveQueueCount]
    call .queue_pointer
    ld [hl], b
    inc hl
    ld [hl], c
    ld hl, hUnitPaveQueueCount
    inc [hl]

.queue_entry
    ldh a, [hUnitPaveQueueReadIndex]
    call .queue_pointer
    ld b, [hl]
    inc hl
    ld c, [hl]
    call MapGridCoord
    ld a, [hl]
    ldh [hUnitPaveCurrentMovementCost], a

    ldh a, [hWRAMBank]
    push af
    ld a, 7
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [hl]
    ldh [hUnitPaveCurrentCost], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ld e, 0
.neighbor_loop
    push bc
    push de
    call HexGrid_GetNeighborCoord
    jr c, .candidate_done
    call .check_candidate
    and a
    jr nz, .candidate_done

    ldh a, [hWRAMBank]
    push af
    ld a, 1
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [hl]
    and $3f
    call UnitPave_GetTerrainCost
    ld e, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ldh a, [hUnitPaveCurrentCost]
    add a, e
    ld e, a
    ldh a, [hUnitPaveStock]
    cp e
    jr c, .candidate_done

    ldh a, [hWRAMBank]
    push af
    ld a, 7
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld [hl], e
    ld a, 2
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    set 7, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ld [hl], d
    farcall $0b, MapAI_TestSideAdjacencyGridAtPointer
    jr nz, .candidate_done

    ldh a, [hUnitPaveQueueCount]
    call .queue_pointer
    ld [hl], b
    inc hl
    ld [hl], c
    ld hl, hUnitPaveQueueCount
    inc [hl]

.candidate_done
    pop de
    pop bc
    inc e
    ld a, e
    cp 6
    jr nz, .neighbor_loop

    ldh a, [hUnitPaveQueueReadIndex]
    inc a
    ldh [hUnitPaveQueueReadIndex], a
    ld hl, hUnitPaveQueueCount
    cp [hl]
    jp nz, .queue_entry
    ret

.queue_pointer
    ld l, a
    ld h, 0
    add hl, hl
    ld a, h
    add a, HIGH(wUnitPaveRouteQueue)
    ld h, a
    ret

; B/C = candidate coordinate. Returns A=0 and D=new cumulative movement cost
; when the cell is traversable, unoccupied, cheaper than any previous visit,
; and within the movement limit.
.check_candidate
    push bc
    call MapGridCoord
    farcall $0b, MapAI_TestSideOccupancyGridAtPointer
    jr nz, .reject

    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, 1
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [hl]
    and $3f
    ld e, a
    ld d, 0
    ld hl, wMovementCostByMapTile
    add hl, de
    ld e, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl

    ld a, e
    and a
    jr z, .reject
    ldh a, [hUnitPaveCurrentMovementCost]
    add a, e
    jr c, .reject
    ld d, a
    cp [hl]
    jr nc, .reject
    ldh a, [hUnitPaveMovementLimit]
    cp d
    jr c, .reject
    xor a
    jr .done
.reject
    ld a, 1
.done
    pop bc
    ret

    assert @ == $725f

section "Unit Pave Route Execution", romx[$725f], bank[$0c]

; Convert every coordinate in the selected movement path to ROAD, consuming the
; per-terrain paving cost from weapon-1 ammunition. The route queue itself is
; the standard WRAM-bank-5 movement-analysis queue built by the MOVE selector.
UnitPave_ExecuteSelectedRoute::
    ldh a, [hWRAMBank]
    push af
    ld a, 5
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ld a, 9
    farcall $0c, UnitAction_PresentActionEffect
    ld d, 0
.loop
    ld a, d
    add a, a
    ld hl, wMapAnalysisQueue
    call AddAtoHL
    ld b, [hl]
    inc hl
    ld c, [hl]

    farcall $0b, MapTile_GetBaseIdAtCoordinates
    call UnitPave_GetTerrainCost
    and a
    jr z, .next
    ld h, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET]
    sub h
    ld [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET], a

    ld a, MAP_TERRAIN_ROAD
    farcall $0b, MapTile_SetBaseIdAtCoordinates
    ldh a, [hWRAMBank]
    push af
    farcall $0b, Bank0B_MapSetup_43D1
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
.next
    inc d
    ld a, [wMapAnalysisQueueCount]
    cp d
    jr nz, .loop

    farcall $11, CampaignStats_SetProcuredFlag36ForPrimarySide
    farcall $11, CampaignStats_IncrementDevelopedProperties

    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

    assert @ == $72b4
