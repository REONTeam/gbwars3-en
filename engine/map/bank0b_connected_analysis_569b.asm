include "macros/macros.inc"
include "constants/map_analysis_constants.inc"

; Connected coordinate-analysis extent runtime.
; Builds a bounded queue of reachable/related hex-grid coordinates in WRAM bank 5.


section "Bank $0B connected analysis extent runtime", romx[$569b], bank[$0b]

; Build a connected coordinate queue in WRAM bank 5 beginning at B/C. The
; routine seeds wMapAnalysisQueue with coordinate pairs, expands through six
; hex-grid neighbors, and returns the final queue count minus one in A.
MapRuntime_ComputeConnectedAnalysisExtent::
    push bc
    push de
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, $05
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call MapRuntime_GetAnalysisRangeParameter
    ldh [hMapAnalysisRange], a
    xor a
    ld [wMapAnalysisQueueCount], a
    call MapGridCoord
    ld a, [hl]
    ldh [hMapAnalysisCellValue], a

.queue_loop
    ld a, [wMapAnalysisQueueCount]
    add a
    ld hl, wMapAnalysisQueue
    call AddAtoHL
    ld [hl], b
    inc hl
    ld [hl], c
    ld hl, wMapAnalysisQueueCount
    inc [hl]
    call MapGridCoord
    call MapRuntime_AnalysisHelper5624
    ld a, e
    cpl
    inc a
    ld e, a
    ldh a, [hMapAnalysisCellValue]
    and a
    jr z, .done
    add e
    ldh [hMapAnalysisCellValue], a
    ld e, $00

.neighbor_loop
    push bc
    call HexGrid_GetNeighborCoord
    jr c, .next_neighbor
    call MapGridCoord
    ld a, [hl]
    ld hl, hMapAnalysisCellValue
    cp [hl]
    jr z, .advance_queue
.next_neighbor
    pop bc
    inc e
    ld a, e
    cp $06
    jr nz, .neighbor_loop

.wait_until_input
    call Joypad_Update
    jr .wait_until_input

.advance_queue
    pop de
    jr .queue_loop

.done
    ld a, [wMapAnalysisQueueCount]
    dec a
    ld b, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    pop hl
    pop de
    pop bc
    ret

    assert @ == $5709
