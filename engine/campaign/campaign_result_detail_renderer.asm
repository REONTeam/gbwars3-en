include "macros/macros.inc"

; Campaign result-detail page.  The helper at $7A63 prepares the two-column
; statistic header/band used by both sides; $7AA8 builds the complete page,
; including common assets, labels, phase/day count and per-side campaign totals.
section "Campaign Result Detail Header Helper", romx[$7a63], bank[$27]
CampaignResult_DrawStatisticBand::
    ld a, $0a
    ld bc, $0106
    ld de, $0101
    ld h, $22
    farcall Gfx_DrawSequentialTileRectWithAttributes

    ld a, $aa
    ld bc, $1206
    ld de, $0101
    ld h, $22
    farcall Gfx_DrawSequentialTileRectWithAttributes

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0206
    call Vram_TilemapCoord
    ld a, $23
    ld bc, $0010
    call MemsetWaitLCD

    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0206
    call Vram_TilemapCoord
    ld a, $0a
    ld bc, $0010
    call MemsetWaitLCD
    ret

    assert @ == $7aa8

section "Campaign Result Detail Renderer", romx[$7aa8], bank[$27]
CampaignResult_DrawSummaryScreen::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll

    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    ldh [$ff97], a
    ldh [$ff98], a

    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    call Vram_ClearBGTilemapBothBanks

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets

    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $65d3
    ld hl, $9000
    ld bc, $0220
    farcall $27, Memcpy
    ld de, $7587
    ld hl, $9220
    ld bc, $0030
    farcall $27, Memcpy
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ld a, $00
    ld b, $08
    ld hl, $67f3
    ld c, $27
    call Vram_SetFarPals
    call Vram_SetDefaultBGPal
    call Vram_ApplyPals

    ld a, $0a
    ld bc, $0401
    ld de, $0c02
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes

    ld bc, $0104
    ld de, $1203
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, CampaignResult_SummaryTitle
    call CoordTextPut

    ld a, [wMapPhaseNumber]
    srl a
    inc a
    ld bc, $0d05
    ld d, $02
    call $31f5

    ld a, $08
    ld bc, $0f05
    ld de, $0101
    ld h, $19
    farcall Gfx_DrawSequentialTileRectWithAttributes

    ld bc, $0106
    ld de, $120b
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    call CampaignResult_DrawStatisticBand

    ld a, $0b
    ld bc, $0208
    ld de, $0202
    ld h, $1a
    farcall Gfx_DrawSequentialTileRectWithAttributes

    ld bc, $0507
    ld hl, CampaignResult_UnitBuiltLabel
    call TextPut
    ld a, [wUnitBuiltCountSide0 + 1]
    ld h, a
    ld a, [wUnitBuiltCountSide0]
    ld l, a
    ld bc, $0f07
    ld d, $03
    call $3251

    ld bc, $0508
    ld hl, CampaignResult_UnitLostLabel
    call TextPut
    ld a, [wUnitLostCountSide0 + 1]
    ld h, a
    ld a, [wUnitLostCountSide0]
    ld l, a
    ld bc, $0f08
    ld d, $03
    call $3251

    ld bc, $0509
    ld hl, CampaignResult_GoldLabel
    call TextPut
    ld hl, wMapSide0Gold
    ld bc, $0d09
    ld d, $05
    call $32a3

    ld bc, $050a
    ld hl, CampaignResult_MaterialsLabel
    call TextPut
    ld a, [wMapSide0Materials]
    ld l, a
    ld a, [wMapSide0Materials + 1]
    ld h, a
    ld bc, $0d0a
    ld d, $05
    call $3251

    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $020b
    ld de, $1001
    ld a, $24
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $020b
    ld de, $1001
    ld a, $08
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ld a, $0b
    ld bc, $020d
    ld de, $0202
    ld h, $1e
    farcall Gfx_DrawSequentialTileRectWithAttributes

    ld bc, $050c
    ld hl, CampaignResult_UnitBuiltLabel
    call TextPut
    ld a, [wUnitBuiltCountSide1 + 1]
    ld h, a
    ld a, [wUnitBuiltCountSide1]
    ld l, a
    ld bc, $0f0c
    ld d, $03
    call $3251

    ld bc, $050d
    ld hl, CampaignResult_UnitLostLabel
    call TextPut
    ld a, [wUnitLostCountSide1 + 1]
    ld h, a
    ld a, [wUnitLostCountSide1]
    ld l, a
    ld bc, $0f0d
    ld d, $03
    call $3251

    ld bc, $050e
    ld hl, CampaignResult_GoldLabel
    call TextPut
    ld hl, wMapSide1Gold
    ld bc, $0d0e
    ld d, $05
    call $32a3

    ld bc, $050f
    ld hl, CampaignResult_MaterialsLabel
    call TextPut
    ld a, [wMapSide1Materials]
    ld l, a
    ld a, [wMapSide1Materials + 1]
    ld h, a
    ld bc, $0d0f
    ld d, $05
    call $3251

    call VBlankFIFO_Process
    ret

CampaignResult_SummaryTitle::
    db $04, $05, $6b, $62, $6c, $ad, $63, $c0, $2d, $dd, $00
CampaignResult_UnitBuiltLabel::
    db $6e, $62, $6b, $8d, $d5, $c6, $ff, $c4, $00
CampaignResult_UnitLostLabel::
    db $96, $8d, $82, $72, $d5, $c6, $ff, $c4, $00
CampaignResult_GoldLabel::
    db $6c, $67, $8d, $00
CampaignResult_MaterialsLabel::
    db $6c, $93, $62, $00

    assert @ == $7c84
