include "macros/macros.inc"

; Clear A tile rows beginning at BG map $9C00 in both VRAM banks.  Each row is
; 20 tiles wide and the next row begins 32 bytes later.  Used before drawing
; Unit Creation and selected-unit detail panels.
section "Clear BG map rows in both VRAM banks", romx[$7a9d], bank[$0b]
Vram_ClearPanelRowsBothBanks::
    push bc
    push de
    ld d, a
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call .clear_bank
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call .clear_bank
    pop de
    pop bc
    ret

.clear_bank
    push de
    ld hl, $9c00
.loop
    push hl
    ld bc, $0014
    xor a
    call Memset
    pop hl
    ld bc, $0020
    add hl, bc
    dec d
    jr nz, .loop
    pop de
    ret

    assert @ == $7acb
