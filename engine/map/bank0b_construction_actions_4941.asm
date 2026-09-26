include "macros/macros.inc"
include "constants/unit_constants.inc"

; Construction Truck terrain-action selection/controller family.
; $C948 is the candidate count and $C949+ stores direction indices during
; this UI lifetime. Direction IDs 0-5 are the six adjacent hexes; ID 6 is the
; current cell and is tested between the two three-direction neighbor sweeps.
; The same scratch bytes are reused by other map-action subsystems.
DEF wConstructionActionDirectionCount EQU $c948
DEF wConstructionActionDirectionList EQU $c949
DEF wConstructionActionSelectionIndex EQU $c940
DEF wConstructionActionPreviewTileId EQU $c9a6
; $DD80 is bank-dependent. These names refer specifically to WRAM bank 1,
; where $DD80 is the count byte for the 100 three-byte records at $DD81.
DEF CONSTRUCTION_MAP_RECORD_CAPACITY EQU 100
DEF MAP_PROPERTY_SIDE_STRIDE EQU $0b

section "Bank $0B Construction terrain action controller", romx[$4941], bank[$0b]

; Return 0 when at least one BUILD-family terrain action is available, 1 when
; none is available. Only the Construction Truck can expose these actions.
Construction_HasTerrainActionCandidate::
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    srl a
    cp UNIT_TYPE_CONSTRUCTION_TRUCK
    jr nz, .unavailable

    call Construction_BuildDevelopableDirectionList
    and a
    jr nz, .available
    call Construction_BuildClearableDirectionList
    and a
    jr nz, .available
    call Construction_BuildRiverDirectionList
    and a
    jr z, .unavailable
.available
    xor a
    jr .done
.unavailable
    ld a, $01
.done
    ret

    assert @ == $4962

; Build the direction list accepted by the developable-terrain classifier.
; Returns A = candidate count.
Construction_BuildDevelopableDirectionList::
    push de
    ldh a, [hWRAMBank]
    push af
    ld a, $05
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    xor a
    ld [wConstructionActionDirectionCount], a

    ld e, $00
    ld d, $03
    call Construction_ScanDirectionRangeDevelopable

    ld e, $06
    call Construction_AddDirectionIfDevelopable

    ld e, $03
    ld d, $06
    call Construction_ScanDirectionRangeDevelopable

    ld a, [wConstructionActionDirectionCount]
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    pop de
    ret

    assert @ == $498f

; Scan direction IDs E..D-1. HexGrid_GetNeighborCoord sets carry for an
; out-of-bounds neighbor, which is simply skipped.
Construction_ScanDirectionRangeDevelopable::
.loop
    push bc
    call HexGrid_GetNeighborCoord
    jr c, .next
    call Construction_AddDirectionIfDevelopable
.next
    pop bc
    inc e
    ld a, e
    cp d
    jr nz, .loop
    ret

    assert @ == $499f

Construction_AddDirectionIfDevelopable::
    call Construction_GetDevelopableTerrainClassAtCoordinates
    cp $ff
    ret z

    ld a, [wConstructionActionDirectionCount]
    ld hl, wConstructionActionDirectionList
    call AddAtoHL
    ld [hl], e
    ld hl, wConstructionActionDirectionCount
    inc [hl]
    ret

    assert @ == $49b4

; Build the direction list accepted by the clearable-terrain classifier.
; Returns A = candidate count.
Construction_BuildClearableDirectionList::
    push bc
    push de
    ldh a, [hWRAMBank]
    push af
    ld a, $05
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    xor a
    ld [wConstructionActionDirectionCount], a

    ld e, $00
    ld d, $03
    call Construction_ScanDirectionRangeClearable

    ld e, $06
    call Construction_AddDirectionIfClearable

    ld e, $03
    ld d, $06
    call Construction_ScanDirectionRangeClearable

    ld a, [wConstructionActionDirectionCount]
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    pop de
    pop bc
    ret

    assert @ == $49e3

Construction_ScanDirectionRangeClearable::
.loop
    push bc
    call HexGrid_GetNeighborCoord
    jr c, .next
    call Construction_AddDirectionIfClearable
.next
    pop bc
    inc e
    ld a, e
    cp d
    jr nz, .loop
    ret

    assert @ == $49f3

Construction_AddDirectionIfClearable::
    call Construction_GetClearableTerrainClassAtCoordinates
    cp $ff
    ret z

    ld a, [wConstructionActionDirectionCount]
    ld hl, wConstructionActionDirectionList
    call AddAtoHL
    ld [hl], e
    ld hl, wConstructionActionDirectionCount
    inc [hl]
    ret

    assert @ == $4a08

; Build a six-neighbor list containing only River terrain-name cells.
Construction_BuildRiverDirectionList::
    push bc
    push de
    ldh a, [hWRAMBank]
    push af
    ld a, $05
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    xor a
    ld [wConstructionActionDirectionCount], a
    ld e, $00
.loop
    push bc
    call HexGrid_GetNeighborCoord
    jr c, .next
    call MapTile_GetBaseIdAtCoordinates
    call Terrain_GetNameIndex
    cp MOVEMENT_TERRAIN_RIVER
    jr nz, .next

    ld a, [wConstructionActionDirectionCount]
    ld hl, wConstructionActionDirectionList
    call AddAtoHL
    ld [hl], e
    ld hl, wConstructionActionDirectionCount
    inc [hl]
.next
    pop bc
    inc e
    ld a, e
    cp $06
    jr nz, .loop

    ld a, [wConstructionActionDirectionCount]
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    pop de
    pop bc
    ret

    assert @ == $4a4b

; Return the developable class transformed to the action-class values used by
; the controller: Plain -> 3, Wood/Wasteland -> 4, anything else -> $FF.
Construction_GetDevelopableTerrainClassAtCoordinates::
    call MapTile_GetBaseIdAtCoordinates
    call Construction_ClassifyDevelopableTerrain
    cp $ff
    jr z, .done
    add a, $03
.done
    ret

    assert @ == $4a58

; Return 1 for Wood/Wasteland and $FF for Plain/unsupported terrain.
Construction_GetClearableTerrainClassAtCoordinates::
    call MapTile_GetBaseIdAtCoordinates
    call Construction_ClassifyDevelopableTerrain
    and a
    jr nz, .done
    ld a, $ff
.done
    ret

    assert @ == $4a64

; A = raw map tile ID. Return 0 for Plain, 1 for Wood/Wasteland, $FF otherwise.
Construction_ClassifyDevelopableTerrain::
    push de
    ld d, $00
    call Terrain_GetNameIndex
    cp MOVEMENT_TERRAIN_PLAIN
    jr z, .done
    inc d
    cp MOVEMENT_TERRAIN_WOOD
    jr z, .done
    cp MOVEMENT_TERRAIN_WASTELAND
    jr z, .done
    ld d, $ff
.done
    ld a, d
    pop de
    ret

    assert @ == $4a7c

; Build the Construction Truck terrain-action submenu from the terrain around
; wMapActionTargetX/Y, run the shared selector, and dispatch the chosen action.
; Cancel returns $FF. A failed action branch also returns $FF and reopens the
; submenu, matching the retail retry loop.
Construction_RunTerrainActionController::
.menu_loop
    ld a, $c0
    call UnitActionMenu_Reset

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a

    call Construction_BuildRiverDirectionList
    and a
    jr z, .no_bridge
    ld a, UNIT_ACTION_BRIDGE
    call UnitActionMenu_AddEntry
.no_bridge

    call Construction_BuildDevelopableDirectionList
    and a
    jr z, .no_runway
    ld a, UNIT_ACTION_RUNWAY
    call UnitActionMenu_AddEntry
.no_runway

    call Construction_BuildClearableDirectionList
    and a
    jr z, .no_clear
    ld a, UNIT_ACTION_CLEAR
    call UnitActionMenu_AddEntry
.no_clear

    call UnitActionMenu_RunSelection
    cp UNIT_ACTION_RUNWAY
    jr z, .runway
    cp UNIT_ACTION_BRIDGE
    jr z, .bridge
    cp UNIT_ACTION_CLEAR
    jr z, .clear
    ld a, $ff
    jr .done

.runway
    call Construction_RunwayAction
    cp $ff
    jr z, .menu_loop
    call MapGrid_RebuildTileCountsAndHQCoordinates
    jr .done

.bridge
    call Construction_BridgeAction
    cp $ff
    jr z, .menu_loop
    call MapGrid_RebuildTileCountsAndHQCoordinates
    jr .done

.clear
    call Construction_ClearAction
    cp $ff
    jr z, .menu_loop
    call MapGrid_RebuildTileCountsAndHQCoordinates
.done
    ret

    assert @ == $4ae0

Construction_RunwayAction::
    ; RUNWAY creates a side-owned temporary airport on one of the developable
    ; cells selected by the shared direction picker. The WRAM-bank-1 map record
    ; table has room for 100 entries; unlike CLEAR/BRIDGE, RUNWAY must allocate
    ; a new map-analysis/property record after changing the terrain.
    xor a
    ld [wConstructionActionSelectionIndex], a

    ldh a, [hWRAMBank]
    push af
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [wMapPropertyStateRecordCount]
    ld b, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    cp CONSTRUCTION_MAP_RECORD_CAPACITY
    jr nz, .choose_direction

    ld a, SFX_ERROR
    call Audio_PlaySFX
    ld a, $15
    farcall $0b, MapControl_ResolutionSceneRefresh
    ld a, $ff
    ret

.choose_direction
    ld a, [wUnitRecordScratch + UNIT_RECORD_X_OFFSET]
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_Y_OFFSET]
    ld c, a
    call Construction_BuildDevelopableDirectionList
    call Construction_GetOwnedRunwayTileId
    ld [wConstructionActionPreviewTileId], a
    call Construction_SelectTerrainActionDirection
    cp $ff
    jr z, .done

    ; Plain costs three Construction Truck resource/ammo points; Wood and
    ; Wasteland cost four. Construction_GetDevelopableTerrainClassAtCoordinates
    ; already returns those exact cost values (3/4).
    call Construction_GetDevelopableTerrainClassAtCoordinates
    ld h, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET]
    sub h
    jr nc, .have_resource

    ld a, SFX_ERROR
    call Audio_PlaySFX
    ld a, $10
    farcall $0b, MapControl_ResolutionSceneRefresh
    jr .choose_direction

.have_resource
    ld [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET], a
    push bc
    ld a, $06
    farcall $0c, UnitAction_PresentActionEffect
    pop bc
    call Construction_GetOwnedRunwayTileId
    call MapTile_SetBaseIdAtCoordinates
    call $43d1
    ; Allocate the constructed property-state record and update income.
    farcall $0c, PropertyState_AddRecordAtCoordinates
    farcall $11, CampaignStats_SetProcuredFlag36ForPrimarySide
    farcall $11, CampaignStats_IncrementDevelopedProperties
    ld a, SFX_CONFIRM
    call Audio_PlaySFX
    xor a
.done
    ret

Construction_GetOwnedRunwayTileId::
    ld h, MAP_PROPERTY_OFFSET_RUNWAY
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    bit 0, a
    jr z, .done
    ld h, MAP_PROPERTY_OFFSET_RUNWAY + MAP_PROPERTY_SIDE_STRIDE
.done
    ld a, h
    ret

Construction_ClearAction::
    ; CLEAR converts Wood/Wasteland to Plain. The classifier returns cost 1 for
    ; either accepted terrain class, so the resource check is shared.
    xor a
    ld [wConstructionActionSelectionIndex], a

.retry
    ld a, [wUnitRecordScratch + UNIT_RECORD_X_OFFSET]
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_Y_OFFSET]
    ld c, a
    call Construction_BuildClearableDirectionList
    ld a, MAP_TERRAIN_PLAIN
    ld [wConstructionActionPreviewTileId], a
    call Construction_SelectTerrainActionDirection
    cp $ff
    jr z, .done

    call Construction_GetClearableTerrainClassAtCoordinates
    ld h, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET]
    sub h
    jr nc, .have_resource

    ld a, SFX_ERROR
    call Audio_PlaySFX
    ld a, $10
    farcall $0b, MapControl_ResolutionSceneRefresh
    jr .retry

.have_resource
    ld [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET], a
    push bc
    ld a, $07
    farcall $0c, UnitAction_PresentActionEffect
    pop bc
    ld a, MAP_TERRAIN_PLAIN
    call MapTile_SetBaseIdAtCoordinates
    call $43d1
    farcall $11, CampaignStats_SetProcuredFlag36ForPrimarySide
    ld a, SFX_CONFIRM
    call Audio_PlaySFX
    xor a
.done
    ret

Construction_BridgeAction::
    ; BRIDGE targets River neighbors, previews BRIDGE_1, and requires two
    ; resource/ammo points. The actual two-point subtraction and tile/stat
    ; mutation live in Unit_BuildBridgeAtCoordinates immediately at $4BF2.
    xor a
    ld [wConstructionActionSelectionIndex], a

.retry
    ld a, [wUnitRecordScratch + UNIT_RECORD_X_OFFSET]
    ld b, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_Y_OFFSET]
    ld c, a
    call Construction_BuildRiverDirectionList
    ld a, MAP_TERRAIN_BRIDGE_1
    ld [wConstructionActionPreviewTileId], a
    call Construction_SelectTerrainActionDirection
    cp $ff
    jr z, .done

    ld a, [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET]
    sub $02
    jr c, .insufficient_resource
    call Unit_BuildBridgeAtCoordinates
    xor a
    jr .done

.insufficient_resource
    ld a, SFX_ERROR
    call Audio_PlaySFX
    ld a, $10
    farcall $0b, MapControl_ResolutionSceneRefresh
    jr .retry
.done
    ret

    assert @ == $4bf2
