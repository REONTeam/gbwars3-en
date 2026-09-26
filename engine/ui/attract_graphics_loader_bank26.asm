include "macros/macros.inc"

; Load the 0x800-byte attract-screen graphics payload into both $9000 and
; $8800 in VRAM bank 0. The graphics data itself begins immediately at $6A42.
section "Attract Text Graphics Loader", romx[$6a26], bank[$26]
AttractText_LoadGraphics::
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $6a42
    ld hl, $9000
    ld bc, $0800
    call Memcpy
    ld hl, $8800
    ld bc, $0800
    call Memcpy
    ret
