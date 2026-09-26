include "macros/macros.inc"
include "constants/map_analysis_constants.inc"

; Coordinate-analysis / map-grid workspace runtime.

section "Bank $0B coordinate analysis runtime", romx[$54e0], bank[$0b]

; Build the temporary analysis workspace used by the connected tactical helpers.
; The routine temporarily selects WRAM bank 5, clears the $D000-$DD7F workspace,
; and seeds the queue/geometry expansion from the staged context coordinates.
MapRuntime_BuildCoordinateAnalysisWorkspace::
    push bc
    push de
    ldh a, [hWRAMBank]
    push af
    ld a, $05
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [wMapAnalysisOptions]
    push af
    ld hl, wMapAnalysisOptions
    set 4, [hl]
    ld a, [wMapAnalysisContext0]
    srl a
    cp $22
    jr z, .clear_option4
    cp $24
    jr z, .clear_option4
    jr .option_ready
.clear_option4
    ld hl, wMapAnalysisOptions
    res 4, [hl]
.option_ready
    ld a, [wMapAnalysisContext0]
    and $01
    xor $01
    call MapAI_BuildSideUnitOccupancyAdjacencyGrid
    pop af
    ld [wMapAnalysisOptions], a
    ld a, $ff
    ld hl, $d000
    ld bc, $0d80
    call Memset
    call MapRuntime_GetAnalysisRangeParameter
    ldh [hMapAnalysisRange], a
    ld a, [wMapAnalysisContextX]
    ld b, a
    ld a, [wMapAnalysisContextY]
    ld c, a
    call MapRuntime_AnalysisHelper555F
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

; Read and pack the two UnitData-derived analysis parameters associated with
; the staged context. The exact higher-level policy remains intentionally
; structural; the bounded value is returned in the high nibble of A.
MapRuntime_GetAnalysisRangeParameter::
    push bc
    push de
    ld a, [wMapAnalysisContext0]
    ld c, $19
    farcall $12, UnitData_GetByte
    farcall $12, MovementData_BuildMapTileCosts
    ld a, [wMapAnalysisContext0]
    ld c, $0c
    farcall $12, UnitData_GetByte
    ld d, a
    ld a, [wMapAnalysisContext1]
    cp d
    jr nc, .bounded
    ld d, a
.bounded
    ld a, d
    swap a
    pop de
    pop bc
    ret

; Breadth-first expansion over the coordinate queue. Coordinates are staged in
; the WRAM-bank-5 pair table rooted at $DE00 while the map-grid visited flag is
; maintained in WRAM bank 2.
MapRuntime_AnalysisHelper555F::
    xor a
    ldh [hMapAnalysisQueueIndex], a
    ldh [hMapAnalysisQueueCount], a
    ldh [hMapAnalysisCellValue], a
    call MapGridCoord
    xor a
    ld [hl], a
    ldh a, [hWRAMBank]
    push af
    ld a, $02
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    set 7, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ldh a, [hMapAnalysisQueueCount]
    ld l, a
    ld h, $00
    add hl, hl
    ld a, h
    add a, $de
    ld h, a
    ld [hl], b
    inc hl
    ld [hl], c
    ld hl, hMapAnalysisQueueCount
    inc [hl]

.queue_entry
    ldh a, [hMapAnalysisQueueIndex]
    ld l, a
    ld h, $00
    add hl, hl
    ld a, h
    add a, $de
    ld h, a
    ld b, [hl]
    inc hl
    ld c, [hl]
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add a, $d0
    ld h, a
    ld a, l
    and $f0
    add a, b
    ld l, a
    ld a, [hl]
    ldh [hMapAnalysisCellValue], a
    ld e, $00

.neighbor_loop
    push bc
    push de
    call HexGrid_GetNeighborCoord
    jr c, .neighbor_done
    call MapRuntime_AnalysisHelper55F4
    and a
    jr nz, .neighbor_done
    ld [hl], d
    ldh a, [hWRAMBank]
    push af
    ld a, $02
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    set 7, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call MapAI_TestSideAdjacencyGridAtPointer
    jr nz, .neighbor_done

    ldh a, [hMapAnalysisQueueCount]
    ld l, a
    ld h, $00
    add hl, hl
    ld a, h
    add a, $de
    ld h, a
    ld [hl], b
    inc hl
    ld [hl], c
    ld hl, hMapAnalysisQueueCount
    inc [hl]

.neighbor_done
    pop de
    pop bc
    inc e
    ld a, e
    cp $06
    jr nz, .neighbor_loop
    ldh a, [hMapAnalysisQueueIndex]
    inc a
    ldh [hMapAnalysisQueueIndex], a
    ld hl, hMapAnalysisQueueCount
    cp [hl]
    jr nz, .queue_entry
    ret

; Test whether a candidate coordinate may enter the expansion queue and return
; A=0 when it is accepted. The routine also returns the candidate map cost/value
; in D when accepted.
MapRuntime_AnalysisHelper55F4::
    push bc
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add a, $d0
    ld h, a
    ld a, l
    and $f0
    add a, b
    ld l, a
    call MapAI_TestSideOccupancyGridAtPointer
    jr nz, .reject
    call MapRuntime_AnalysisHelper5624
    ld a, e
    and a
    jr z, .reject
    ldh a, [hMapAnalysisCellValue]
    add a, e
    jr c, .reject
    ld d, a
    cp [hl]
    jr nc, .reject
    ldh a, [hMapAnalysisRange]
    cp d
    jr c, .reject
    xor a
    jr .done
.reject
    ld a, $01
.done
    pop bc
    ret

; Resolve the per-cell analysis cost/value. Terrain class $2A has a special
; unit-sensitive substitution path; the final value is loaded from the table
; rooted at $CD43.
MapRuntime_AnalysisHelper5624::
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [hl]
    and $3f
    cp $2a
    jr nz, .lookup
    ld a, $02
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [hl]
    and $7f
    jr z, .terrain_2a
    farcall $12, UnitRecord_FindPrimaryAtCoordinates
    cp $ff
    jr z, .terrain_2a
    push bc
    ld c, $00
    farcall $12, UnitRecord_GetByte
    pop bc
    srl a
    cp $30
    jr nz, .terrain_2a
    ld a, $21
    jr .lookup
.terrain_2a
    ld a, $2a
.lookup
    ld e, a
    ld d, $00
    ld hl, $cd43
    add hl, de
    ld e, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    ret

; Clear the analysis visited flag (bit 7) across every active map cell in WRAM
; bank 2, preserving the caller's bank and registers.
MapGrid_ClearAnalysisFlagAcrossGrid::
    push bc
    push de
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, $02
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [wMapGridWidth]
    ld d, a
    ld a, [wMapGridHeight]
    ld e, a
    ld c, $00
.row_loop
    ld b, $00
.column_loop
    call MapGridCoord
    res 7, [hl]
    inc b
    ld a, b
    cp d
    jr c, .column_loop
    inc c
    ld a, c
    cp e
    jr c, .row_loop
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret

    assert @ == $569b
