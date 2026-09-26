include "macros/macros.inc"

DEF wVBlankTwoPlaneTileValue EQU $cc4e
DEF wVBlankTwoPlaneAttrValue EQU $cc4f

; Queue one BG tile plus its attribute byte at the same B/C coordinate. A is
; the tile value and D is the attribute value. The helper temporarily selects
; FIFO VRAM bank 0 for the tile and bank 1 for the attribute, then restores the
; caller's queue-bank selector.
section "VBlank FIFO Two-Plane Tile", rom0[$37c2]
VBlankFIFO_QueueTileAndAttrAtCoordinates::
    ld [wVBlankTwoPlaneTileValue], a
    ld a, d
    ld [wVBlankTwoPlaneAttrValue], a
    ld a, [hVBlankFIFO_Bank]
    push af
    push bc
    xor a
    ld [hVBlankFIFO_Bank], a
    ld a, [wVBlankTwoPlaneTileValue]
    call Vram_DrawTileAtCoordinates
    pop bc
    ld a, $01
    ld [hVBlankFIFO_Bank], a
    ld a, [wVBlankTwoPlaneAttrValue]
    call Vram_DrawTileAtCoordinates
    pop af
    ld [hVBlankFIFO_Bank], a
    ret

    assert @ == $37e9
