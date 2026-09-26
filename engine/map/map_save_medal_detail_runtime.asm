include "macros/macros.inc"

DEF wMapSaveMedalPage EQU $cc77
DEF wMapSaveMedalCursorX EQU $cc78
DEF wMapSaveMedalCursorY EQU $cc79
DEF wMapSaveSelectedMedal EQU $cc7a
DEF wMapSaveMedalCursorSprite EQU $cc7b
DEF wMapSaveMedalAuxSpriteA EQU $cc7c
DEF wMapSaveMedalAuxSpriteB EQU $cc7d
DEF wMapSaveMedalDrawIndex EQU $cc80
DEF wMapSaveMedalFlags EQU $cc97

; Configure the LCD-STAT/window state used by the selected-slot medal view.
section "Map Save Medal Detail LCD Setup", romx[$5b4c], bank[$14]
MapSave_ConfigureMedalDetailDisplay::
    di
    ld hl, MapSave_MedalDetailLCDStatInterrupt
    call SetLCDStatInterrupt
    xor a
    ldh [$ffcd], a
    ld hl, rSTAT
    set 6, [hl]
    ld a, $07
    ldh [rLYC], a
    xor a
    ldh [rIF], a
    call Interrupt_EnableLCDStat
    call MapSave_UpdateMedalDetailWindowX
    ei
    call LCD_EnableWindow
    ret

    assert @ == $5b6d

section "Map Save Medal Detail Runtime", romx[$5b79], bank[$14]
MapSave_GetMedalGridCellCoord:
    add a
    ld hl, MapSave_MedalGridCellCoords
    call AddAtoHL
    ld a, [hl+]
    ld c, a
    ld a, [hl]
    ld b, a
    ret

MapSave_DrawMedalGridIcons:
    ld a, $01
    ld [wMapSaveMedalDrawIndex], a
.loop
    ld a, [wMapSaveMedalDrawIndex]
    call MapSave_GetMedalGridCellCoord
    ld de, $0203
    ld a, [wMapSaveMedalDrawIndex]
    dec a
    ld hl, wMapSaveMedalFlags
    call Bitfield_Test
    jr nz, .owned
    xor a
    jr .draw
.owned
    ld a, [wMapSaveMedalDrawIndex]
    jr .draw
.draw
    call MapSave_DrawMedalGridCell
    ld a, [wMapSaveMedalDrawIndex]
    cp $19
    jr z, .done
    inc a
    ld [wMapSaveMedalDrawIndex], a
    jr .loop
.done
    ret

MapSave_MedalGridCellCoords:
    db $ff, $ff, $04, $01, $04, $04, $04, $07, $04, $0a
    db $04, $0d, $04, $10, $08, $01, $08, $04, $08, $07
    db $08, $0a, $08, $0d, $08, $10, $0c, $01, $0c, $04
    db $0c, $07, $0c, $0a, $0c, $0d, $0c, $10, $10, $01
    db $10, $04, $10, $07, $10, $0a, $10, $0d, $10, $10

; Entry used by the selected-slot view. It loads the 24 medal-ownership bits,
; builds the medal screen and its cursor sprites, then draws the initial item.
MapSave_OpenMedalDetailView::
    ld a, [$c62a]
    farcall $13, MapSRAM_LoadSlotMedalFlags
    call MapSave_SetupMedalDetailScreen
    call MapSave_CreateMedalCursorSprites
    call MapSave_PositionMedalCursor
    call MapSave_DrawSelectedMedalDetails
    ret

MapSave_SetupMedalDetailScreen:
    call MapSave_ConfigureMedalDetailDisplay
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    ldh [$ff97], a
    ldh [$ff98], a
    farcall $10, UIWindowStack_Init
    farcall $01, SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    xor a
    ld [wMapSaveMedalPage], a
    ld [wMapSaveMedalCursorX], a
    ld [wMapSaveMedalCursorY], a
    ld [wMapSaveSelectedMedal], a
    ldh [$ff95], a
    ldh [$ff96], a
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $9c00
    ld bc, $0400
    xor a
    call Memset
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $9c00
    ld bc, $0400
    xor a
    call Memset
    ld a, $40
    farcall $15, Gfx_LoadCommonScreenAssets
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $6b31
    ld hl, $9100
    ld bc, $01d0
    call Memcpy
    ld de, $790d
    ld hl, $8800
    ld bc, $0590
    call Memcpy
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    ld b, $08
    ld hl, $6d01
    call Vram_SetPals
    call Vram_SetDefaultBGPal
    call Vram_ApplyPals
    ld a, $0a
    ld bc, $0420
    ld de, $0c02
    ld h, $11
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0023
    ld de, $1405
    farcall $10, MapSave_DrawMedalDetailBackground
    call MapSave_SetMedalGridRendererSource
    call MapSave_DrawMedalGridIcons
    ret

; Switch to the lower 12 medals by sliding the window down one 64-pixel page.
MapSave_ShowLowerMedalGridPage::
    ld a, [wMapSaveMedalPage]
    cp $01
    ret z
    ld a, SFX_MEDAL_DETAIL
    call Audio_PlaySFX
    ld a, [wMapSaveMedalCursorSprite]
    call SpriteObject_Hide
.loop
    call Joypad_Update
    call Sprite_Update
    ldh a, [$ff96]
    inc a
    inc a
    inc a
    ldh [$ff96], a
    cp $40
    jr c, .loop
    ld a, $40
    ldh [$ff96], a
    ld a, $01
    ld [wMapSaveMedalPage], a
    ld a, [wMapSaveMedalCursorSprite]
    call SpriteObject_Show
    ld a, [wMapSaveMedalAuxSpriteA]
    call SpriteObject_Show
    ld a, [wMapSaveMedalAuxSpriteB]
    call SpriteObject_Hide
    ret

; Switch back to the upper 12 medals.
MapSave_ShowUpperMedalGridPage::
    ld a, [wMapSaveMedalPage]
    cp $00
    ret z
    ld a, SFX_MEDAL_DETAIL
    call Audio_PlaySFX
    ld a, [wMapSaveMedalCursorSprite]
    call SpriteObject_Hide
    ld c, $00
.loop
    push bc
    call Joypad_Update
    call Sprite_Update
    ldh a, [$ff96]
    dec a
    dec a
    dec a
    pop bc
    inc c
    inc c
    inc c
    ldh [$ff96], a
    ld a, c
    cp $40
    jr c, .loop
    ld a, $00
    ldh [$ff96], a
    xor a
    ld [wMapSaveMedalPage], a
    ld a, [wMapSaveMedalCursorSprite]
    call SpriteObject_Show
    ld a, [wMapSaveMedalAuxSpriteA]
    call SpriteObject_Hide
    ld a, [wMapSaveMedalAuxSpriteB]
    call SpriteObject_Show
    ret

    assert @ == $5d30

section "Map Save Medal Detail Render Support", romx[$5e3f], bank[$14]
MapSave_SetMedalGridRendererSource:
    ld a, $e1
    ld [$cc59], a
    ld a, $77
    ld [$cc58], a
    ld a, $77
    ld [$cc5b], a
    ld a, $78
    ld [$cc5a], a
    ld a, $80
    ld [$cc5c], a
    ld a, $14
    ld [$cc61], a
    ret

MapSave_DrawMedalGridCell:
    ld [$cc50], a
    ld a, b
    ld [$cc52], a
    ld a, c
    ld [$cc53], a
    xor a
    ld [$cc54], a
    ld [$cc55], a
    ld a, d
    ld [$cc56], a
    ld a, e
    ld [$cc57], a
    ld a, [$cc50]
    ld b, $06
    call MultiplyAByB
    ld a, l
    ld [$cc50], a
    call Vram_DrawBGRectIndexed
    ret

; Convert the 0-23 selection index into the cursor sprite position. The lower
; page is displayed through the window scroll, so its Y coordinate is shifted.
MapSave_PositionMedalCursor::
    ld a, [wMapSaveSelectedMedal]
    ld b, $06
    call Math_DivideAByB
    ld b, $18
    call MultiplyAByB
    ld a, l
    add $18
    ld [wMapSaveMedalCursorX], a
    ld a, [wMapSaveSelectedMedal]
    ld b, $06
    call Math_DivideAByB
    ld a, b
    ld b, $20
    call MultiplyAByB
    ld a, l
    add $28
    ld [wMapSaveMedalCursorY], a
    ld a, [wMapSaveMedalPage]
    cp $01
    jr nz, .position
    ld a, [wMapSaveMedalCursorY]
    sub $40
    ld [wMapSaveMedalCursorY], a
.position
    ld a, [wMapSaveMedalCursorX]
    ld b, a
    ld a, [wMapSaveMedalCursorY]
    ld c, a
    ld a, [wMapSaveMedalCursorSprite]
    call SpriteObject_SetPosition
    ret

MapSave_CreateMedalCursorSprites:
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f44
    call SpriteObject_Create
    ld [wMapSaveMedalCursorSprite], a
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f52
    call SpriteObject_Create
    ld [wMapSaveMedalAuxSpriteA], a
    ld bc, $a038
    call SpriteObject_SetPosition
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f60
    call SpriteObject_Create
    ld [wMapSaveMedalAuxSpriteB], a
    ld bc, $a060
    call SpriteObject_SetPosition
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [wMapSaveMedalAuxSpriteA]
    call SpriteObject_Hide
    ret

    assert @ == $5f1b

section "Map Save Medal Detail Text Entry", romx[$5f29], bank[$14]
MapSave_DrawSelectedMedalDetails::
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0224
    ld de, $1003
    xor a
    farcall $15, Gfx_TilemapFill
    ld a, [wMapSaveSelectedMedal]
    ld hl, wMapSaveMedalFlags
    call Bitfield_Test
    jr nz, Medal_DrawSelectedNameAndDescription
    jr Medal_DrawNone

    assert @ == $5f4a
