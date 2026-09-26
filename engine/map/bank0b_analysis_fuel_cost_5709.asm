include "macros/macros.inc"
include "constants/map_analysis_constants.inc"
include "constants/unit_constants.inc"

; Apply the movement/analysis cost encoded in the first analysis-queue cell
; to the active live unit's fuel value.


section "Bank $0B analysis fuel-cost consumer", romx[$5709], bank[$0b]

MapAI_ApplyAnalysisQueueFuelCost::
    ldh a, [hWRAMBank]
    push af
    ld a, $05
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_CopyToScratch

    ld hl, wMapAnalysisQueue
    ld b, [hl]
    inc hl
    ld c, [hl]
    call MapGridCoord
    ld a, [hl]
    swap a
    and $0f
    ld d, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_FUEL_OFFSET]
    sub d
    ld [wUnitRecordScratch + UNIT_RECORD_FUEL_OFFSET], a

    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_CopyFromScratch

    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

    assert @ == $573c
