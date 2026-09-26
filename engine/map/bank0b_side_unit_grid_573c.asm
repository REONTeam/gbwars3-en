include "macros/macros.inc"
include "constants/map_analysis_constants.inc"

; Side-unit occupancy / adjacency mask builder used by tactical map analysis.


section "Bank $0B side unit occupancy mask", romx[$573c], bank[$0b]

; A selects one of the two 50-record live-unit pools. This helper clears the
; WRAM-bank-6 map workspace, scans every occupied record in the selected pool,
; sets bit 1 at each unit coordinate, and, when analysis option bit 4 is set,
; marks all valid six-neighbor coordinates with bit 0.
MapAI_BuildSideUnitOccupancyAdjacencyGrid::
    push bc
    push de
    ld e, a
    ldh a, [hWRAMBank]
    push af
    ld a, $06
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ld hl, $d000
    ld bc, $0d80
    xor a
    call Memset

    ld h, $32
    ld a, $32
    ld [wMapAnalysisUnitIndex], a
    ld a, e
    and a
    jr nz, .scan_units
    xor a
    ld [wMapAnalysisUnitIndex], a

.scan_units
    push hl
    ld a, [wMapAnalysisUnitIndex]
    ld c, $00
    farcall $12, UnitRecord_GetByte
    and a
    jr z, .next_unit

    ld a, [wMapAnalysisUnitIndex]
    ld c, $01
    farcall $12, UnitRecord_GetWord
    ld b, e
    ld c, d
    call MapGridCoord
    set 1, [hl]

    ld a, [wMapAnalysisOptions]
    bit 4, a
    jr z, .next_unit
    ld e, $00
.neighbor_loop
    push de
    push bc
    call HexGrid_GetNeighborCoord
    jr c, .neighbor_done
    call MapGridCoord
    set 0, [hl]
.neighbor_done
    pop bc
    pop de
    inc e
    ld a, e
    cp $06
    jr nz, .neighbor_loop

.next_unit
    pop hl
    ld a, [wMapAnalysisUnitIndex]
    inc a
    ld [wMapAnalysisUnitIndex], a
    dec h
    jr nz, .scan_units

    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

    assert @ == $57ae
