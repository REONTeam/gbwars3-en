include "macros/macros.inc"

; Clear the WRAM4 scratch used by the Map Menu before a new top-level mode is
; entered. The two nine-byte buffers at $DC3B/$DC44 are part of the same
; lifetime and are cleared with the shared memset helper.
section "Map Menu Runtime State Reset", romx[$40fb], bank[$13]
MapMenu_ResetRuntimeState::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$dc2a], a
    ld [$dc2b], a
    ld [$dc2c], a
    ld [$dc2d], a
    ld [$dc2e], a
    ld [$dc2f], a
    ld [$dc31], a
    ld [$dc32], a
    ld [$dc33], a
    ld [$dc34], a
    ld [$dc4d], a
    ld [$dc4e], a
    ld [$dc4f], a
    ld [$dc50], a
    ld [$dc35], a
    ld [$dc36], a
    ld [$dc37], a
    ld [$dc38], a
    ld [$dc39], a
    ld [$dc3a], a
    ld hl, $dc3b
    ld bc, $0009
    ld a, $00
    call Memset
    ld hl, $dc44
    ld bc, $0009
    ld a, $00
    call Memset
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

    assert @ == $415d
