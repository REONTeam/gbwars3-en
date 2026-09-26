include "macros/macros.inc"

; Bank $0B side-unit adjacency-grid bit test.
; $57AE is independently farcalled from Bank $0C and stops exactly before the
; separately reached $57C2 companion entry.

section "Bank $0B side adjacency-grid test", romx[$57ae], bank[$0b]

; Input: HL = address in the WRAM-bank-6 side-unit grid produced by
; MapAI_BuildSideUnitOccupancyAdjacencyGrid.
; Output: Z flag reflects bit 0 of that grid byte (set = adjacency mask).
; Preserves BC and restores the caller's WRAM bank.
MapAI_TestSideAdjacencyGridAtPointer::
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
    bit 0, b
    pop bc
    ret

    assert @ == $57c2
