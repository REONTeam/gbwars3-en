include "macros/macros.inc"

; Small in-map economy/status panel used by Unit Creation and related map UI.
; It draws the current side's Gold and Materials values over a viewport-relative
; panel.  The Gold path is 24-bit/five-digit; Materials are obtained from the
; source-backed current-side Materials helper and rendered as a 16-bit value.

section "Map economy status panel", romx[$7a53], bank[$0b]
MapEconomy_DrawStatusPanel::
    ld bc, $0201
    call MapPresentation_ConvertViewportTileToBGMapCoordinates
    ld de, $0f03
    farcall UIWindowStack_PushAndDraw

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ld bc, $0302
    call MapPresentation_ConvertViewportTileToBGMapCoordinates
    call Vram_TilemapCoord
    ld de, MapEconomy_StatusPanelLabels
    call Vram_DrawZeroTerminatedRow

    ld bc, $0502
    call MapPresentation_ConvertViewportTileToBGMapCoordinates
    call MapEconomy_DrawCurrentSideGold

    ld bc, $0d02
    call MapPresentation_ConvertViewportTileToBGMapCoordinates
    call MapEconomy_GetCurrentSideMaterials
    ld d, $03
    call DrawNumber5Digits
    ret

MapEconomy_StatusPanelLabels:
    db $b1, $a7, $80, $80, $80, $80, $80, $80
    db $b2, $a7, $00

MapEconomy_CloseStatusPanel::
    farcall UIWindowStack_PopRestore
    ret

    assert @ == $7a9d
