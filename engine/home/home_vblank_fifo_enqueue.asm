include "macros/macros.inc"

; Low-level producer side of the deferred VBlank FIFO. The queue itself lives
; at $C300-$C3FF and hVBlankFIFO_Head/Tail/Count track producer/consumer state.
section "VBlank FIFO Enqueue Runtime", rom0[$34d8]
VBlankFIFO_Write::
    push hl
    push af
.wait_for_space
    ldh a, [hVBlankFIFO_Head]
    ld l, a
    ldh a, [hVBlankFIFO_Tail]
    dec a
    cp l
    jr z, .wait_for_space
    pop af
    ld h, $c3
    ld [hl], a
    ld a, l
    inc a
    ldh [hVBlankFIFO_Head], a
    pop hl
    ret

; Queue one tile byte at BG tilemap coordinate B/C. hVBlankFIFO_Bank selects
; whether the destination address is encoded for VRAM bank 0 or 1.
Vram_DrawTileAtCoordinates::
    push hl
    push af
    call Vram_TilemapCoord
    ld a, $01
    call VBlankFIFO_Write
    ld a, l
    call VBlankFIFO_Write
    ldh a, [hVBlankFIFO_Bank]
    and a
    jr z, .address_ready
    res 7, h
.address_ready
    ld a, h
    call VBlankFIFO_Write
    pop af
    call VBlankFIFO_Write
    call VBlankFIFO_Commit
    pop hl
    ret

; Queue B bytes from HL for deferred copy to VRAM destination DE.
VBlankFIFO_Queue::
    ld a, b
    call VBlankFIFO_Write
    ld a, e
    call VBlankFIFO_Write
    ldh a, [hVBlankFIFO_Bank]
    and a
    jr z, .destination_ready
    res 7, d
.destination_ready
    ld a, d
    call VBlankFIFO_Write
.copy
    ld a, [hl+]
    call VBlankFIFO_Write
    dec b
    jr nz, .copy

VBlankFIFO_Commit::
    ld hl, hVBlankFIFO_Count
    inc [hl]
    ret

    assert @ == $352e
