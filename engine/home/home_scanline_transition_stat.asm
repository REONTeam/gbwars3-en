include "constants/hardware.inc"

; LCD STAT interrupt handler installed by
; LCDScanlineTransition_RunToTarget. It waits for STAT mode bit 1 to clear,
; applies the prepared LCDC value, restores registers, and returns from the
; interrupt. This closes the exact ROM0 gap between home_map.asm and the
; TerrainNameIndexByMapTile table.

section "LCD scanline transition STAT handler", rom0[$1899]

LCDScanlineTransition_STATHandler::
    push af
    push hl
    ld hl, rSTAT
    ldh a, [rLCDC]
    set LCDC_TILE_DATA_F, a ; select the unsigned $8000-$8FFF BG/window tile-data area
.wait_stat_mode
    bit STAT_BUSY_F, [hl]
    jr nz, .wait_stat_mode
    ldh [rLCDC], a
    pop hl
    pop af
    reti

    assert @ == $18ab
