include "macros/macros.inc"

; selected-unit detail renderer core. This is shared by the normal
; selected-unit interaction flow and the carried-child selection resolver.
; It stages the common detail-panel graphics, draws the selected unit graphic
; and several record-derived rows, and delegates the compact state marker to
; the local helper at $66BF. The following $66F2+ bytes are renderer data and
; later helper code and remain a separate ownership tranche.

section "Bank $0B selected-unit detail renderer core", romx[$656e], bank[$0b]

UnitSelection_DrawSelectedUnitDetails::
    push bc
    push de
    push hl
    ld hl, UnitSelection_DetailPanelResourceData
    ld a, $07
    ld b, $01
    call $06bc
    ld bc, $8000
    call $0703
    ld hl, UnitSelection_DetailHeaderData
    call $336e

    ld a, $ae
    ld bc, $0421
    call Vram_DrawTileAtCoordinates
    ld a, $af
    ld bc, $0821
    call Vram_DrawTileAtCoordinates
    ld a, $b0
    ld bc, $0c21
    call Vram_DrawTileAtCoordinates
    ld a, $52
    ld bc, $1021
    call Vram_DrawTileAtCoordinates

    ld a, [$ccdd]
    ld b, a
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $8fc0
    ld a, b
    add $34
    call MapMetatile_LoadTiles
    ld hl, $9c21
    ld a, b
    add $34
    ld d, a
    ld b, $00
    ld c, $03
    ld a, $fc
    call MapMetatile_DrawTilemap

    ld a, [$ccde]
    ld b, a
    ld a, [$ccdf]
    ld c, a
    call $4770
    ld b, a
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $8c40
    ld a, b
    call MapMetatile_LoadTiles
    ld hl, $9c61
    ld d, b
    ld bc, $0003
    ld a, $c4
    call MapMetatile_DrawTilemap

    call UnitSelection_DrawSelectedUnitStateIndicator

    ld a, [$ccdd]
    farcall $12, UnitData_CopyNameToBuffer
    ld hl, $cd28
    ld bc, $0420
    call $3353

    ld a, [$ccdd]
    ld c, $0d
    farcall $12, UnitData_GetByte
    and a
    jr z, .alternate_status_rows
    ld bc, $1220
    ld d, $01
    call DrawNumber3Digits
    ld a, [$cce2]
    ld bc, $1020
    ld d, $01
    call DrawNumber3Digits
    ld a, $b5
    ld bc, $0f20
    call Vram_DrawTileAtCoordinates
    ld a, $a6
    ld bc, $1120
    call Vram_DrawTileAtCoordinates
    jr .status_rows_done
.alternate_status_rows
    ld hl, UnitSelection_AlternateStatusRowsData
    call $336e
.status_rows_done
    call VBlankFIFO_WaitEmpty

    ld a, [$c9d8]
    farcall $12, UnitWeapon_BuildSummary
    ld hl, $cced
    ld bc, $0423
    call UnitSelection_DrawDetailRecordRows
    ld hl, $ccfb
    ld bc, $0424
    call UnitSelection_DrawDetailRecordRows

    ld a, [$cce1]
    ld bc, $0521
    ld d, $02
    call DrawNumber3Digits
    ld hl, UnitSelection_DetailScaleHighData
    ld a, [$cce1]
    cp $04
    jr nc, .draw_first_status_scale
    ld hl, UnitSelection_DetailScaleLowData
.draw_first_status_scale
    call UnitSelection_DrawDetailRowWithMode

    ld a, [$ccdd]
    ld c, $0c
    farcall $12, UnitData_GetByte
    ld bc, $0921
    ld d, $02
    call DrawNumber3Digits
    ld a, [$cce4]
    ld bc, $0d21
    ld d, $02
    call DrawNumber3Digits
    ld hl, UnitSelection_DetailScaleHighData
    ld a, [$cce4]
    cp $15
    jr nc, .draw_second_status_scale
    ld hl, UnitSelection_DetailScaleLowData
.draw_second_status_scale
    call UnitSelection_DrawDetailRowWithMode

    ld a, [$cce7]
    ld e, a
    ld a, [$cce8]
    ld d, a
    ld bc, $0064
    call $2a21
    ld a, e
    ld hl, UnitSelection_DetailValueGlyphTable
    call $29bc
    ld a, [hl]
    ld bc, $1121
    call Vram_DrawTileAtCoordinates
    call VBlankFIFO_WaitEmpty

    pop hl
    pop de
    pop bc
    ret

; Compact selected-unit state marker used by the renderer above. The exact
; player-facing meaning of the three variants remains structural because the
; producer semantics of $CCE2 / $CCE0 bit 7 are not yet fully closed.
UnitSelection_DrawSelectedUnitStateIndicator::
    push bc
    ld b, $00
    ld a, [$cce2]
    and a
    jr z, .check_flag
    inc b
.check_flag
    ld a, [$cce0]
    bit 7, a
    jr z, .select_variant
    inc b
    inc b
.select_variant
    ld a, b
    and a
    jr z, .clear_marker
    dec b
    ld a, $b5
    add b
    ld bc, $0222
    call Vram_DrawTileAtCoordinates
    ld a, $01
    ld [$ffcb], a
    xor a
    ld bc, $0222
    call Vram_DrawTileAtCoordinates
    xor a
    ld [$ffcb], a
.clear_marker
    pop bc
    ret

    assert @ == $66f2
