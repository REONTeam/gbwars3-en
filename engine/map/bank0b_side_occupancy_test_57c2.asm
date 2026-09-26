include "macros/macros.inc"

; Bank $0B side-unit occupancy-grid bit test.
; $57C2 is independently farcalled from Bank $0C and is the matching companion
; to the earlier bit-0 adjacency-grid test. The helper returns before $57D6.

section "Bank $0B side occupancy-grid test", romx[$57c2], bank[$0b]

; Input: HL = address in the WRAM-bank-6 side-unit grid produced by
; MapAI_BuildSideUnitOccupancyAdjacencyGrid.
; Output: Z flag reflects bit 1 of that grid byte (set = occupied unit cell).
; Preserves BC and restores the caller's WRAM bank.
MapAI_TestSideOccupancyGridAtPointer::
    push bc
    ldh a, [hWRAMBank]
    push af
    ld a, 6
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld b, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    bit 1, b
    pop bc
    ret

    assert @ == $57d6
