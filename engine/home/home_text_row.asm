include "macros/macros.inc"

section "VRAM Zero-Terminated Row Text", rom0[$0f63]

; Draw a zero-terminated byte string from DE into the BG tilemap at HL.
; Each byte is written through the LCD-safe fixed-bank VRAM primitive.  HL
; advances across the low five tilemap-column bits and wraps within the same
; 32-tile row, matching the callers that precompute a tilemap coordinate.
Vram_DrawZeroTerminatedRow::
.loop
    ld a, [de]
    inc de
    and a
    jr z, .done

    call Vram_PutWaitBlank

    push de
    ld a, l
    and $e0
    ld d, a
    ld a, l
    inc a
    and $1f
    or d
    ld l, a
    pop de
    jr .loop
.done
    ret

    assert @ == $0f7a
