include "macros/macros.inc"

; File-select presentation/runtime for the three SRAM slots.
; The nine-character map-name row patches at $731A/$73A7/$7460 are
; separate fixed-address owners in engine/map/map_name_ui.asm.

section "Map Save File Select Presentation A", romx[$6eea], bank[$27]
MapSave_DrawSlotFrames::
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $0107
    ld de, $1201
    ld a, $13
    farcall $15, Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $0107
    ld de, $1201
    ld a, $08
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $0a
    ld bc, $0108
    ld de, $0202
    ld h, $24
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $010b
    ld de, $0202
    ld h, $28
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $010e
    ld de, $0202
    ld h, $2c
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $2f
    ld bc, $0e09
    call Vram_DrawTileAtCoordinates
    ld a, $2f
    ld bc, $0e0c
    call Vram_DrawTileAtCoordinates
    ld a, $2f
    ld bc, $0e0f
    call Vram_DrawTileAtCoordinates
    ret
MapSave_HidePreviewPane::
    ld a, [$cc82]
    cp $01
    jr z, MapSave_Loc_6F9F
    ld a, $01
    ld [$cc82], a
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld hl, $9000
    ld bc, $0010
    xor a
    call $3b84
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, [$cc84]
    call $2f5f
    ld a, [$cc85]
    call $2f5f
    ld a, [$cc86]
    call $2f5f
    ld de, $0001
    ld bc, $0000
    farcall $27, Presentation_WaitFramesOrCancel
    call $0514
    call $04d2
MapSave_Loc_6F9F:
    ld a, [$cc70]
    call $2f5f
    ret
MapSave_LoadSelectedSlotPreview::
    ld [$cc83], a
    farcall $13, MapSRAM_GetSlotStatusByte
    bit 0, a
    jr z, MapSave_Loc_6FDA
    ld a, [$cc82]
    cp $01
    jr z, MapSave_Loc_6FBD
    call MapSave_DrawSelectedSlotPreview
    jr MapSave_Loc_6FD8
MapSave_Loc_6FBD:
    ld a, $00
    ld [$cc82], a
    call MapSave_DrawSelectedSlotPreview
    call MapSave_UpdateCategoryFromSelectedSlot
    call MapSave_UpdatePreviewSpriteVisibility
    call MapSave_DrawPrompt
    call $352e
    call $051f
    farcall $14, MapSave_LoadPreviewGraphics
MapSave_Loc_6FD8:
    jr MapSave_Loc_6FDD
MapSave_Loc_6FDA:
    call MapSave_HidePreviewPane
MapSave_Loc_6FDD:
    ret
MapSave_DrawSelectedSlotPreview::
    ld a, [$cc83]
    farcall $13, MapSRAM_GetSlotStatusByte
    bit 0, a
    jp z, MapSave_DrawSelectedSlotPreview_Finalize
    call MapSave_DrawSlotFrames
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, [$cc83]
    ld hl, $cc2f
    farcall $13, MapSRAM_LoadSlotPreviewHeader
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $0205
    ld de, $0601
    xor a
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $0205
    ld hl, $cc2f
    call $3353
    ld a, [$cc83]
    farcall $13, MapSRAM_ReadSlotModeByte
    push af
    farcall $14, MapSave_SetPreviewRendererSourceB
    pop af
    push af
    ld bc, $0d05
    ld de, $0602
    farcall $14, MapSave_DrawPreviewRect12
    farcall $14, MapSave_SetPreviewRendererSourceA
    pop af
    ld bc, $0905
    ld de, $0302
    farcall $14, MapSave_DrawPreviewRect6
    call MapSave_DrawSlot0Details
    call MapSave_DrawSlot1Details
    call MapSave_DrawSlot2Details
MapSave_DrawSelectedSlotPreview_Finalize::
    ld de, $0001
    ld bc, $0000
    farcall $27, Presentation_WaitFramesOrCancel
    ret
MapSave_UpdateCategoryFromSelectedSlot::
    ld a, [$c629]
    cp $01
    jr nz, MapSave_Loc_7090
    ld a, [$c62a]
    ld c, $0e
    farcall $13, MapSRAM_ReadSlotMetadataByte
    cp $00
    jr z, MapSave_Loc_7079
    cp $01
    jr z, MapSave_Loc_707C
    cp $02
    jr z, MapSave_Loc_7080
    xor a
    jr MapSave_Loc_7084
MapSave_Loc_7079:
    xor a
    jr MapSave_Loc_7084
MapSave_Loc_707C:
    ld a, $01
    jr MapSave_Loc_7084
MapSave_Loc_7080:
    ld a, $02
    jr MapSave_Loc_7084
MapSave_Loc_7084:
    ld [$cc81], a
    call MapSave_PositionCategoryCursor
    call $3056
    call $04d2
MapSave_Loc_7090:
    ret
MapSave_ClearPrimaryDetailRow::
    ld a, $0a
    ld bc, $0002
    ld de, $0101
    ld h, $11
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $aa
    ld bc, $1302
    ld de, $0101
    ld h, $11
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $0102
    call $0ed4
    ld a, $12
    ld bc, $0012
    call $3b84
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $0102
    call $0ed4
    ld a, $0a
    ld bc, $0012
    call $3b84
    ret
MapSave_ClearSecondaryDetailRow::
    ld a, $0a
    ld bc, $0020
    ld de, $0101
    ld h, $11
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $aa
    ld bc, $1320
    ld de, $0101
    ld h, $11
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $0120
    call $0ed4
    ld a, $12
    ld bc, $0012
    call $3b84
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $0120
    call $0ed4
    ld a, $0a
    ld bc, $0012
    call $3b84
    ret
MapSave_SetupFileSelectScreen::
    call $04f3
    call $34ce
    call $2d7c
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    ld [$cc82], a
    farcall $10, UIWindowStack_Init
    farcall $01, SharedGraphics_LoadMainFontBG
    call $0618
    call $0f02
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $70
    farcall $15, Gfx_LoadCommonScreenAssets
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld de, Image_File_Select_General2
    ld hl, $9100
    ld bc, $03e0
    farcall $27, Memcpy
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $00
    ld b, $08
    ld hl, $7957
    ld c, $27
    call $06d9
    call $06af
    call $06f2
    ld a, [$c629]
    cp $01
    jr nz, MapSave_Loc_71B4
    ld a, $0a
    ld bc, $0b11
    ld de, $0301
    ld h, $14
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0e11
    ld de, $0501
    ld h, $17
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0111
    ld de, $0301
    ld h, $45
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0411
    ld de, $0601
    ld h, $48
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    jr MapSave_Loc_71D0
MapSave_Loc_71B4:
    ld a, $0a
    ld bc, $0e11
    ld de, $0101
    ld h, $32
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0f11
    ld de, $0301
    ld h, $33
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
MapSave_Loc_71D0:
    ld bc, $0000
    ld de, $1403
    farcall $22, UIWindow_DrawFrameAndClearInteriorAttributes
    ld bc, $0002
    ld de, $140f
    farcall $22, UIWindow_DrawFrameAndClearInteriorAttributes
    call MapSave_ClearPrimaryDetailRow
    ld a, $08
    ld bc, $0201
    ld de, $0401
    ld h, $1c
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0801
    ld de, $0301
    ld h, $1c
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0b01
    ld de, $0101
    ld h, $20
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0e01
    ld de, $0301
    ld h, $1c
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1101
    ld de, $0101
    ld h, $21
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    farcall $14, MapSave_LoadPreviewGraphics
    ld a, $0d
    ld b, $01
    ld c, $22
    ld hl, $6144
    call $06d9
    call $06f2
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld de, $5f4c
    ld hl, $8000
    ld bc, $01d0
    farcall $22, Memcpy
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $80
    ld b, $22
    ld de, $5f25
    call $2de8
    ld [$cc84], a
    ld bc, $9a56
    call $2eae
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $80
    ld b, $22
    ld de, $5f25
    call $2de8
    ld [$cc85], a
    ld bc, $9a6e
    call $2eae
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $80
    ld b, $22
    ld de, $5f25
    call $2de8
    ld [$cc86], a
    ld bc, $9a86
    call $2eae
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $07
    ldh [$ff97], a
    ld a, $10
    ldh [$ff98], a
    ld bc, $0020
    ld de, $140f
    farcall $10, UIWindow_DrawFrame
    call MapSave_ClearSecondaryDetailRow
    ld a, $08
    ld bc, $0727
    ld de, $0601
    ld h, $3f
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, [$c629]
    cp $01
    jr z, MapSave_Loc_72F8
    ld a, $0a
    ld bc, $0e2f
    ld de, $0101
    ld h, $32
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0f2f
    ld de, $0301
    ld h, $33
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
MapSave_Loc_72F8:
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld hl, $9000
    ld bc, $0010
    xor a
    call $3b79
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ret
MapSave_DrawSlot0Details::
    ld a, [$cc83]
    ld b, $00
    farcall $13, MapSRAM_LoadSlotSummaryRow
section "Map Save File Select Presentation B", romx[$732f], bank[$27]
    ld a, [$cc93]
    cp $ff
    jr z, MapSave_Loc_735D
    srl a
    inc a
    ld bc, $0409
    ld d, $02
    call $31f5
    ld a, $22
    ld d, $08
    ld bc, $0609
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    ld a, $23
    ld d, $08
    ld bc, $0709
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    ld a, [$cc84]
    call $2f45
    jr MapSave_Loc_7387
MapSave_Loc_735D:
    xor a
    ld d, $00
    ld bc, $0409
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    xor a
    ld d, $00
    ld bc, $0509
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    xor a
    ld d, $00
    ld bc, $0609
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    xor a
    ld d, $00
    ld bc, $0709
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    ld a, [$cc84]
    call $2f5f
MapSave_Loc_7387:
    ld a, [$cc95]
    ld bc, $0c09
    ld d, $02
    call $31f5
    ld a, [$cc96]
    ld bc, $0f09
    ld d, $02
    call $31f5
    ret
MapSave_DrawSlot1Details::
    ld a, [$cc83]
    ld b, $01
    farcall $13, MapSRAM_LoadSlotSummaryRow
section "Map Save File Select Presentation C", romx[$73bc], bank[$27]
    ld a, [$cc93]
    cp $ff
    jr z, MapSave_Loc_73EA
    srl a
    inc a
    ld bc, $040c
    ld d, $02
    call $31f5
    ld a, $22
    ld d, $08
    ld bc, $060c
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    ld a, $23
    ld d, $08
    ld bc, $070c
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    ld a, [$cc85]
    call $2f45
    jr MapSave_Loc_7414
MapSave_Loc_73EA:
    xor a
    ld d, $00
    ld bc, $040c
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    xor a
    ld d, $00
    ld bc, $050c
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    xor a
    ld d, $00
    ld bc, $060c
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    xor a
    ld d, $00
    ld bc, $070c
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    ld a, [$cc85]
    call $2f5f
MapSave_Loc_7414:
    ld a, [$cc95]
    ld bc, $0c0c
    ld d, $02
    call $31f5
    ld a, [$cc96]
    ld bc, $0f0c
    ld d, $02
    call $31f5
    ld a, [$cc94]
    ld [$cc76], a
    ret
MapSave_DrawSlot2Details::
    ld a, [$cc83]
    ld b, $02
    farcall $13, MapSRAM_LoadSlotSummaryRow
    ld a, [$cc93]
    cp $ff
    jr z, MapSave_Loc_747D
    srl a
    inc a
    ld bc, $040f
    ld d, $02
    call $31f5
    ld a, $22
    ld d, $08
    ld bc, $060f
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    ld a, $23
    ld d, $08
    ld bc, $070f
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
section "Map Save File Select Presentation D", romx[$7475], bank[$27]
    ld a, [$cc86]
    call $2f45
    jr MapSave_Loc_74D1
MapSave_Loc_747D:
    xor a
    ld d, $00
    ld bc, $040f
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    xor a
    ld d, $00
    ld bc, $050f
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    xor a
    ld d, $00
    ld bc, $060f
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    xor a
    ld d, $00
    ld bc, $070f
    call VBlankFIFO_QueueTileAndAttrAtCoordinates
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $040e
    ld de, $0b01
    xor a
    farcall $15, Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $040e
    ld de, $0b01
    xor a
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, [$cc86]
    call $2f5f
MapSave_Loc_74D1:
    ld a, [$cc95]
    ld bc, $0c0f
    ld d, $02
    call $31f5
    ld a, [$cc96]
    ld bc, $0f0f
    ld d, $02
    call $31f5
    ret
MapSave_CreateCursorSprites::
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6ffa
    call $2de8
    ld [$cc6f], a
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call $2de8
    ld [$cc70], a
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ret
MapSave_DestroyCursorSprites::
    call $2e67
    ret
MapSave_PositionSlotCursor::
    ld a, [$c62a]
    ld b, $30
    call $2995
    ld a, l
    add $27
    ld b, a
    ld a, $1c
    ld c, a
    ld a, [$cc6f]
    call $2eae
    ld a, [$cc6e]
    cp $01
    jr z, MapSave_Loc_753B
    ld a, [$cc70]
    call $2f5f
MapSave_Loc_753B:
    ret
MapSave_UpdatePreviewSpriteVisibility::
    ld a, [$c62a]
    farcall $13, MapSRAM_GetSlotStatusByte
    bit 0, a
    jr nz, MapSave_Loc_7554
    ld a, [$cc70]
    call $2f5f
    call $3056
    call $04d2
    ret
MapSave_Loc_7554:
    ld a, [$cc70]
    call $2f45
    call $3056
    call $04d2
    ret
MapSave_PositionCategoryCursor::
    ld a, [$cc81]
    ld b, $18
    call $2995
    ld a, l
    add $58
    ld c, a
    ld a, $14
    ld b, a
    ld a, [$cc70]
    call $2eae
    ret
