include "macros/macros.inc"

; Standard-map selection controller used after overwrite/save flow.
; Structural names are retained for state whose exact player-facing identity is not yet proven.

DEF MAP_SELECTION_COPY_BANK    EQU $27

DEF wMapSelectionSpriteID       EQU $ccd0
DEF wMapSelectionCursorColumn   EQU $ccd4
DEF wMapSelectionCurrentIndex   EQU $ccd5
DEF wMapSelectionDrawIndex      EQU $ccd6
DEF wMapSelectionRangeStart     EQU $ccd7
DEF wMapSelectionRangeEnd       EQU $ccd8
DEF wMapSelectionPageMode       EQU $ccd9
DEF wMapSelectionClassScratch   EQU $ccda
DEF wMapSelectionAvailability   EQU $ccdb
DEF wMapSelectionEntryColumn    EQU $ccce
DEF wMapSelectionEntryRow       EQU $cccf

section "Map Selection Runtime", romx[$7158], bank[$15]
MapSelection_SetupScreen::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    call Vram_ClearBGTilemapBothBanks
    xor a
    ld [wMapSelectionSpriteID], a
    ldh [$ff95], a
    ldh [$ff96], a
    ldh [$ff97], a
    ldh [$ff98], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, Image_MapSelection_BlankTile
    ld hl, $9000
    ld bc, $0260
    call Memcpy
    ld a, $00
    ld b, $08
    ld hl, Pals_MapSelection
    ld c, $15
    call Vram_SetFarPals
    call Vram_SetDefaultBGPal
    call Vram_ApplyPals
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $517b
    ld hl, $9260
    ld bc, $0140
    call Memcpy
    ld de, $77d7
    ld hl, $93a0
    ld bc, $0040
    farcall MAP_SELECTION_COPY_BANK, Memcpy
    ld de, $7697
    ld hl, $93e0
    ld bc, $0010
    farcall MAP_SELECTION_COPY_BANK, Memcpy
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $0a
    ld bc, $0501
    ld de, $0a02
    ld h, $26
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0d11
    ld de, $0101
    ld h, $21
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0e11
    ld de, $0301
    ld h, $22
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0204
    ld de, $100d
    farcall UIWindow_DrawFrame
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0305
    ld de, $0e0b
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call SpriteObject_Create
    ld [wMapSelectionSpriteID], a
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fb4
    call SpriteObject_Create
    ld bc, $5832
    call SpriteObject_SetPosition
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call SpriteObject_Create
    ld bc, $5896
    call SpriteObject_SetPosition
    call MapSelection_TestAvailabilityFlag
    jr c, .loc_7266
    jr .loc_728a
.loc_7266:
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f98
    call SpriteObject_Create
    ld bc, $9663
    call SpriteObject_SetPosition
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fc2
    call SpriteObject_Create
    ld bc, $1a63
    call SpriteObject_SetPosition
.loc_728a:
    call MapSelection_UpdateCursorSprite
    ret
MapSelection_MoveLeft::
    ld a, $01
    call Audio_PlaySFX
    ld a, [wMapSelectionCursorColumn]
    dec a
    cp $ff
    jr z, .loc_72a0
    ld [wMapSelectionCursorColumn], a
    jr .loc_72bf
.loc_72a0:
    ld a, [wMapSelectionCurrentIndex]
    dec a
    push af
    ld a, [wMapSelectionRangeStart]
    ld c, a
    dec c
    pop af
    cp c
    jr z, .loc_72b6
    ld [wMapSelectionCurrentIndex], a
    call MapSelection_DrawVisibleEntries
    jr .loc_72bf
.loc_72b6:
    ld a, [wMapSelectionRangeEnd]
    ld [wMapSelectionCurrentIndex], a
    call MapSelection_DrawVisibleEntries
.loc_72bf:
    call MapSelection_UpdateCursorSprite
    ret
MapSelection_MoveRight::
    ld a, $01
    call Audio_PlaySFX
    call MapSelection_UpdateCursorSprite
    ld a, [wMapSelectionCursorColumn]
    inc a
    cp $04
    jr z, .loc_72d8
    ld [wMapSelectionCursorColumn], a
    jr .loc_72f8
.loc_72d8:
    ld a, [wMapSelectionCurrentIndex]
    inc a
    push af
    ld a, [wMapSelectionRangeEnd]
    inc a
    ld c, a
    pop af
    cp c
    jr z, .loc_72ee
    ld [wMapSelectionCurrentIndex], a
    call MapSelection_DrawVisibleEntries
    jr .loc_72f8
.loc_72ee:
    xor a
    ld a, [wMapSelectionRangeStart]
    ld [wMapSelectionCurrentIndex], a
    call MapSelection_DrawVisibleEntries
.loc_72f8:
    call MapSelection_UpdateCursorSprite
    ret
MapSelection_ClassifyBoundaryIndex::
    cp $0f
    jr z, .loc_730b
    jr c, .loc_730d
    ld c, a
    ld a, $1d
    cp c
    jr z, .loc_730b
    jr c, .loc_730d
    ld a, c
.loc_730b:
    scf
    ret
.loc_730d:
    ld a, c
    ld d, a
    xor a
    ld a, d
    ret
MapSelection_UpdateAvailabilityClass::
    ld a, $00
    ld [wMapSelectionAvailability], a
    farcall MapRuntime_GetStandardFlagTier
    ld [wMapSelectionClassScratch], a
    ld a, [wMapSelectionClassScratch]
    cp $00
    jr z, .loc_7341
    cp $01
    jr z, .loc_7341
    cp $02
    jr z, .loc_7347
    cp $03
    jr z, .loc_7347
    cp $04
    jr z, .loc_734d
    cp $05
    jr z, .loc_734d
    cp $06
    jr z, .loc_7353
    cp $07
    jr z, .loc_7353
.loc_7341:
    ld a, $00
    ld [wMapSelectionAvailability], a
    ret
.loc_7347:
    ld a, $01
    ld [wMapSelectionAvailability], a
    ret
.loc_734d:
    ld a, $03
    ld [wMapSelectionAvailability], a
    ret
.loc_7353:
    ld a, $07
    ld [wMapSelectionAvailability], a
    ret
MapSelection_RefreshAvailabilityClass::
    call MapSelection_UpdateAvailabilityClass
    ret
MapSelection_TestAvailabilityFlag::
    call MapSelection_RefreshAvailabilityClass
    ld a, $01
    ld hl, wMapSelectionAvailability
    call Bitfield_Test
    jr nz, .loc_736c
    xor a
    ret
.loc_736c:
    scf
    ret
MapSelection_PageForward::
    call MapSelection_TestAvailabilityFlag
    jr c, .loc_7375
    jr .loc_73ac
.loc_7375:
    ld a, $01
    call Audio_PlaySFX
    call MapSelection_TogglePageMode
    call MapSelection_ConfigureVisibleRange
    ld a, [wMapSelectionCurrentIndex]
    add a, $1e
    ld [wMapSelectionCurrentIndex], a
    ld c, a
    ld a, [wMapSelectionRangeEnd]
    cp c
    jr c, .loc_7391
    jr .loc_73a9
.loc_7391:
    ld a, [wMapSelectionCurrentIndex]
    sub $1e
    call MapSelection_ClassifyBoundaryIndex
    jr c, .loc_739d
    jr .loc_73a4
.loc_739d:
    add a, $0f
    ld [wMapSelectionCurrentIndex], a
    jr .loc_73a9
.loc_73a4:
    sub $1e
    ld [wMapSelectionCurrentIndex], a
.loc_73a9:
    call MapSelection_DrawVisibleEntries
.loc_73ac:
    ret
MapSelection_RefreshCurrentPage::
    call MapSelection_TestAvailabilityFlag
    jr c, .loc_73b4
    jr .loc_73c2
.loc_73b4:
    ld a, $01
    call Audio_PlaySFX
    call MapSelection_TogglePageMode
    call MapSelection_ConfigureVisibleRange
    call MapSelection_DrawVisibleEntries
.loc_73c2:
    ret
MapSelection_GetGroupAnchor::
    cp $00
    jr z, .loc_73e3
    cp $01
    jr z, .loc_73e6
    cp $02
    jr z, .loc_73e9
    cp $03
    jr z, .loc_73ec
    cp $04
    jr z, .loc_73ef
    cp $05
    jr z, .loc_73f2
    cp $06
    jr z, .loc_73f5
    cp $07
    jr z, .loc_73f8
.loc_73e3:
    ld a, $0e
    ret
.loc_73e6:
    ld a, $0f
    ret
.loc_73e9:
    ld a, $1d
    ret
.loc_73ec:
    ld a, $1e
    ret
.loc_73ef:
    ld a, $2c
    ret
.loc_73f2:
    ld a, $2d
    ret
.loc_73f5:
    ld a, $3b
    ret
.loc_73f8:
    ld a, $3c
    ret
MapSelection_TestSelectionThreshold::
    call MapSelection_GetCurrentMapIndex
    ld d, a
    push de
    farcall MapRuntime_GetStandardFlagTier
    call MapSelection_GetGroupAnchor
    ld c, a
    pop de
    ld a, d
    cp c
    jr c, .loc_740f
    jr .loc_7411
.loc_740f:
    scf
    ret
.loc_7411:
    xor a
    ret
MapSelection_Run::
    call MapSelection_SetupScreen
    call MapSelection_ConfigureVisibleRange
    call MapSelection_DrawVisibleEntries
    call VBlankFIFO_Process
    ld a, $02
    call Audio_PlayMusic
    call FadeFromWhite8
.loc_7427:
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    bit 0, a
    jr z, .loc_745d
    call MapSelection_TestSelectionThreshold
    jr c, .loc_7445
    ld a, SFX_ERROR
    call Audio_PlaySFX
    jr .loc_7427
.loc_7445:
    ld a, [wMapSelectionSpriteID]
    farcall SpriteTransition_SlideRightOffscreen
    call MapSelection_GetCurrentMapIndex
    farcall MapRecord_SelectStandard
    call FadeToWhite8
    call SpriteObject_DestroyAll
    xor a
    jp z, .loc_7496
.loc_745d:
    bit 1, a
    jr z, .loc_7471
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    call FadeToWhite8
    call SpriteObject_DestroyAll
    ld a, $ff
    jp z, .loc_7496
.loc_7471:
    bit 6, a
    jr z, .loc_747a
    call MapSelection_MoveLeft
    jr .loc_7427
.loc_747a:
    bit 7, a
    jr z, .loc_7483
    call MapSelection_MoveRight
    jr .loc_7427
.loc_7483:
    bit 4, a
    jr z, .loc_748c
    call MapSelection_PageForward
    jr .loc_7427
.loc_748c:
    bit 5, a
    jr z, .loc_7493
    call MapSelection_PageForward
.loc_7493:
    jp .loc_7427
.loc_7496:
    ret
MapSelection_TogglePageMode::
    ld a, [wMapSelectionPageMode]
    cp $00
    jr z, .loc_74a4
    xor a
    ld [wMapSelectionPageMode], a
    jr .loc_74a9
.loc_74a4:
    ld a, $01
    ld [wMapSelectionPageMode], a
.loc_74a9:
    ret
MapSelection_ConfigureVisibleRange::
    call MapSelection_RefreshAvailabilityClass
    ld a, [wMapSelectionPageMode]
    cp $00
    jr z, .loc_74b6
    jr .loc_74d4
.loc_74b6:
    ld a, $00
    ld hl, wMapSelectionAvailability
    call Bitfield_Test
    jr nz, .loc_74ca
    xor a
    ld [wMapSelectionRangeStart], a
    ld a, $0e
    ld [wMapSelectionRangeEnd], a
    ret
.loc_74ca:
    xor a
    ld [wMapSelectionRangeStart], a
    ld a, $1d
    ld [wMapSelectionRangeEnd], a
    ret
.loc_74d4:
    ld a, $02
    ld hl, wMapSelectionAvailability
    call Bitfield_Test
    jr nz, .loc_74e9
    ld a, $1e
    ld [wMapSelectionRangeStart], a
    ld a, $2c
    ld [wMapSelectionRangeEnd], a
    ret
.loc_74e9:
    ld a, $1e
    ld [wMapSelectionRangeStart], a
    ld a, $3b
    ld [wMapSelectionRangeEnd], a
    ret
MapSelection_UpdateCursorSprite::
    ld a, [wMapSelectionCursorColumn]
    ld b, $18
    call MultiplyAByB
    ld a, l
    add a, $40
    ld c, a
    ld b, $18
    ld a, [wMapSelectionSpriteID]
    call SpriteObject_SetPosition
    ret
MapSelection_DrawVisibleEntries::
    ld a, [wMapSelectionCurrentIndex]
    ld [wMapSelectionDrawIndex], a
    xor a
    ld [wMapSelectionEntryRow], a
    ld a, $05
    ld [wMapSelectionEntryColumn], a
.loc_7518:
    ld a, [wMapSelectionDrawIndex]
    farcall MapRecord_SelectStandard
    ld a, [wMapSelectionDrawIndex]
    inc a
    push af
    ld a, [wMapSelectionRangeEnd]
    inc a
    ld c, a
    pop af
    cp c
    jr z, .loc_752f
    jr .loc_7532
.loc_752f:
    ld a, [wMapSelectionRangeStart]
.loc_7532:
    ld [wMapSelectionDrawIndex], a
    call MapSelection_DrawEntryNumber
    call MapSelection_DrawEntryAvailability
    call MapSelection_DrawEntryClassIcon
    call MapSelection_DrawEntryName
    call MapSelection_DrawEntryStats
    call MapSelection_DrawEntryAuxiliaryValue
    ld a, [wMapSelectionEntryColumn]
    inc a
    inc a
    inc a
    ld [wMapSelectionEntryColumn], a
    ld a, [wMapSelectionEntryRow]
    inc a
    ld [wMapSelectionEntryRow], a
    cp $04
    jr nz, .loc_7518
    ret
MapSelection_DrawEntryAvailability::
    ld b, $05
    ld a, [wMapSelectionEntryColumn]
    ld c, a
    ld hl, $ca1d
    ld a, $00
    call Bitfield_Test
    jr z, .loc_758b
    ld a, [$ffcb]
    push af
    push bc
    xor a
    ld [$ffcb], a
    ld a, $25
    call Vram_DrawTileAtCoordinates
    pop bc
    ld a, $01
    ld [$ffcb], a
    ld a, $08
    call Vram_DrawTileAtCoordinates
    pop af
    ld [$ffcb], a
    jr .loc_75a8
.loc_758b:
    ld a, [$ffcb]
    push af
    push bc
    xor a
    ld [$ffcb], a
    xor a
    call Vram_DrawTileAtCoordinates
    pop bc
    ld a, $01
    ld [$ffcb], a
    xor a
    call Vram_DrawTileAtCoordinates
    pop af
    ld [$ffcb], a
    jr .loc_75a8
.loc_75a8:
    ret
MapSelection_DrawEntryClassIcon::
    ld a, [wMapSelectionEntryRow]
    call MapSelection_AddOffsetWrapped
    cp $0f
    jr c, .loc_75bf
    cp $1e
    jr c, .loc_75c3
    cp $2d
    jr c, .loc_75c7
    cp $3c
    jr c, .loc_75cb
.loc_75bf:
    ld h, $3a
    jr .loc_75cf
.loc_75c3:
    ld h, $3b
    jr .loc_75cf
.loc_75c7:
    ld h, $3c
    jr .loc_75cf
.loc_75cb:
    ld h, $3d
    jr .loc_75cf
.loc_75cf:
    ld a, [wMapSelectionEntryColumn]
    ld c, a
    ld b, $06
    ld a, $0b
    ld de, $0101
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
MapSelection_DrawEntryNumber::
    ld a, [wMapSelectionEntryRow]
    call MapSelection_AddOffsetWrapped
    inc a
    ld d, $02
    push af
    ld a, [wMapSelectionEntryColumn]
    ld c, a
    pop af
    ld b, $03
    call DrawNumberFixedWidth
    ret
MapSelection_DrawEntryName::
    ld hl, $ccc5
    ld bc, $0009
    ld a, $00
    call MemsetWaitLCD
    ld hl, $ca1a
    ld bc, $0027
    add hl, bc
    ld d, h
    ld e, l
    ld bc, $0008
    ld hl, $ccc5
    call MemcpyWaitLCD
    ld a, [wMapSelectionEntryColumn]
    ld c, a
    ld b, $08
    ld hl, $ccc5
    call TextPut
    ret
MapSelection_DrawEntryStats::
    ld b, $0c
    ld a, [wMapSelectionEntryColumn]
    inc a
    ld c, a
    push bc
    ld a, [$ca4d]
    ld d, $02
    call $31f5
    pop bc
    inc b
    inc b
    push bc
    ld hl, $7644
    call TextPut
    pop bc
    ld b, $0f
    ld a, [$ca4e]
    ld d, $02
    call $31f5
    ret
    db $19, $00
MapSelection_DrawEntryAuxiliaryValue::
    ld a, [wMapSelectionEntryRow]
    call MapSelection_AddOffsetWrapped
    farcall CampaignStats_ReadIndexedSRAMValue
    cp $ff
    jr z, .loc_7687
    push af
    ld a, [wMapSelectionEntryColumn]
    inc a
    ld c, a
    ld b, $07
    ld d, $02
    pop af
    call $31f5
    ld a, [wMapSelectionEntryColumn]
    inc a
    ld c, a
    ld b, $09
    ld a, [$ffcb]
    push af
    push bc
    xor a
    ld [$ffcb], a
    ld a, $3e
    call Vram_DrawTileAtCoordinates
    pop bc
    ld a, $01
    ld [$ffcb], a
    ld a, $08
    call Vram_DrawTileAtCoordinates
    pop af
    ld [$ffcb], a
    ret
.loc_7687:
    ld a, [wMapSelectionEntryColumn]
    inc a
    ld c, a
    ld b, $07
    call Vram_TilemapCoord
    ld d, h
    ld e, l
    ld a, [$ffcb]
    push af
    push de
    xor a
    ld [$ffcb], a
    ld b, $03
    ld hl, $76b7
    call VBlankFIFO_Queue
    pop de
    ld a, $01
    ld [$ffcb], a
    ld b, $03
    ld hl, $76b7
    call VBlankFIFO_Queue
    pop af
    ld [$ffcb], a
    ret
    db $00, $00, $00
MapSelection_GetCurrentMapIndex::
    ld a, [wMapSelectionCursorColumn]
    call MapSelection_AddOffsetWrapped
    ret
MapSelection_AddOffsetWrapped::
    push af
    ld a, [wMapSelectionCurrentIndex]
    ld c, a
    pop af
    add a, c
    ld c, a
    ld a, [wMapSelectionRangeEnd]
    cp c
    jr c, .loc_76d1
    jr .loc_76e0
.loc_76d1:
    ld a, c
    push af
    ld a, [wMapSelectionRangeEnd]
    inc a
    ld c, a
    pop af
    sub c
    ld c, a
    ld a, [wMapSelectionRangeStart]
    add a, c
    ld c, a
.loc_76e0:
    ld a, c
    ret

    assert @ == $76e2
