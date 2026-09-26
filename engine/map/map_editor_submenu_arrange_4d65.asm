include "macros/macros.inc"

; Shared Map Editor submenu value/cursor presentation and the ARRANGE selection
; controller. The two small inline tables are retained as data: $4DC0 selects
; value columns/suffix resources by submenu type, while $4DFA supplies the
; cursor X coordinate for each submenu ID.

DEF wMapEditorMenuSelectionIndex      EQU $c940
DEF wMapEditorSubmenuValue0           EQU $c941
DEF wMapEditorSubmenuId               EQU $c945
DEF wMapEditorArrangeMode             EQU $ca52
DEF wMapEditorArrangeSelectionClass   EQU $ca57
DEF wMapEditorSelectedTerrainId       EQU $ca65
DEF wMapEditorArrangeSelectionValues  EQU $ca59


section "Map Editor Submenu Value Renderer", romx[$4d65], bank[$0f]

; Redraw the currently selected value for the active editor submenu.
; The ordinary size path is a two-digit numeric draw. FUNDS appends two zero
; glyphs to nonzero values, while FUNDS/MATERIALS use dedicated zero-value
; tile strings. ARRANGE does not call this renderer.
MapEditor_DrawSubmenuValues::
    ld a, [wMapEditorSubmenuId]
    ld c, a
    ld b, $00
    ld hl, MapEditor_SubmenuValueColumnById
    add hl, bc
    ld b, [hl]
    ld a, [wMapEditorMenuSelectionIndex]
    add $22
    ld c, a
    ld hl, wMapEditorSubmenuValue0
    ld a, [wMapEditorMenuSelectionIndex]
    ld e, a
    ld d, $00
    add hl, de
    ld a, [hl]
    ld d, $02
    ld a, [wMapEditorSubmenuId]
    cp $02
    jr z, .funds
    cp $03
    jr z, .materials
    ld a, [hl]
    farcall DrawNumber3Digits
    jr .done

.funds
    ld a, [hl]
    and a
    jr nz, .funds_nonzero
    ld hl, MapEditor_FundsZeroValueTiles
    call TextPut
    jr .done
.funds_nonzero
    farcall DrawNumber3Digits
    inc b
    inc b
    ld hl, MapEditor_FundsHundredsSuffixTiles
    call TextPut
    jr .done

.materials
    ld a, [hl]
    and a
    jr nz, .materials_nonzero
    ld hl, MapEditor_MaterialsZeroValueTiles
    call TextPut
    jr .done
.materials_nonzero
    farcall DrawNumber3Digits
.done
    ret

    assert @ == $4dc0

MapEditor_SubmenuValueColumnById:
    db $ff, $0a, $0c, $0c
MapEditor_FundsZeroValueTiles:
    db $80, $80, $80, $80, $00
MapEditor_FundsHundredsSuffixTiles:
    db $81, $81, $00
MapEditor_MaterialsZeroValueTiles:
    db $80, $80, $00

    assert @ == $4dcf

section "Map Editor Submenu Cursor Runtime", romx[$4dcf], bank[$0f]

; A = new zero-based submenu row. Erase the previous cursor tile, store A, draw
; the new cursor tile, and play the navigation SFX.
MapEditor_UpdateSubmenuSelection::
    ld d, $80
    call MapEditor_InitializeSubmenuSelection
    ld [wMapEditorMenuSelectionIndex], a
    ld d, $55
    call MapEditor_InitializeSubmenuSelection
    ld a, $01
    call Audio_PlaySFX
    ret

; A = submenu row, D = tile ID to draw. The active submenu ID selects the fixed
; X coordinate and row 0/1 selects virtual-window Y $22/$23.
MapEditor_InitializeSubmenuSelection::
    push af
    ld a, [wMapEditorSubmenuId]
    ld c, a
    ld b, $00
    ld hl, MapEditor_SubmenuCursorXById
    add hl, bc
    ld b, [hl]
    ld a, [wMapEditorMenuSelectionIndex]
    add $22
    ld c, a
    ld a, d
    call Vram_DrawTileAtCoordinates
    pop af
    ret

    assert @ == $4dfa

MapEditor_SubmenuCursorXById:
    ; IDs 0-3 and 8-9 are live in the retail editor; $FF marks unused IDs.
    db $05, $06, $03, $03, $ff, $ff, $ff, $ff, $08, $03

    assert @ == $4e04

section "Map Editor Arrange Selection Controller", romx[$4e04], bank[$0f]

MapEditor_RunArrangeSelectionController::
    ld a, [wMapEditorArrangeMode]
    and a
    jp nz, MapEditor_RunUnitArrangeController

    call MapEditor_Arrange_DrawPanel
    call MapEditor_Arrange_RedrawSelection
    ld a, $60
    farcall LCDScanlineTransition_RunToTarget
    farcall MapCursor_Show

.input_loop
    call Joypad_Update
    call MapEditor_Arrange_UpdateCursorSprite
    call Sprite_Update
    ldh a, [hJoyRepeat]
    bit 0, a
    jr nz, .accept_or_cancel
    bit 1, a
    jr nz, .accept_or_cancel
    bit 5, a
    jr nz, .class_left
    bit 4, a
    jr nz, .class_right
    bit 6, a
    jr nz, .value_down
    bit 7, a
    jr nz, .value_up
    bit 2, a
    jr nz, .switch_arrange_mode
    jr .input_loop

.accept_or_cancel
    ld a, $02
    call Audio_PlaySFX
    jr .close

.switch_arrange_mode
    ld a, $02
    call Audio_PlaySFX
    farcall MapCursor_Hide
    call Sprite_Update
    call DelayFrame
    farcall LCDScanlineTransition_Reset
    ld a, $01
    ld [wMapEditorArrangeMode], a
    jp MapEditor_RunUnitArrangeController

.class_left
    ld a, [wMapEditorArrangeSelectionClass]
    dec a
    cp $ff
    jr nz, .store_class
    ld a, $04
    jr .store_class

.class_right
    ld a, [wMapEditorArrangeSelectionClass]
    inc a
    cp $05
    jr c, .store_class
    xor a
.store_class
    ld [wMapEditorArrangeSelectionClass], a
    ld a, $01
    call Audio_PlaySFX
    call MapEditor_Arrange_RebuildSelection
    call MapEditor_Arrange_RedrawSelection
    jr .input_loop

.value_down
    call MapEditor_Arrange_GetCurrentValueAndMaximum
    dec a
    and a
    jr nz, .store_value_down
    ld a, b
.store_value_down
    ld [hl], a
    jr .redraw_value

.value_up
    call MapEditor_Arrange_GetCurrentValueAndMaximum
    cp b
    jr nz, .increment_value
    xor a
.increment_value
    inc a
    ld [hl], a

.redraw_value
    call MapEditor_Arrange_RebuildSelection
    call MapEditor_Arrange_RedrawSelection
    ld a, [wMapEditorArrangeSelectionClass]
    call MapEditor_Arrange_DrawOption
    ld a, $01
    call Audio_PlaySFX
    jp .input_loop

.close
    farcall LCDScanlineTransition_Reset
    ret

; Returns A = current value, B = maximum value, HL = current value byte.
MapEditor_Arrange_GetCurrentValueAndMaximum:
    ld a, [wMapEditorArrangeSelectionClass]
    ld hl, MapEditor_TerrainArrangeClassPointers
    call WordTable_Get
    ld b, [hl]
    ld a, [wMapEditorArrangeSelectionClass]
    ld hl, wMapEditorArrangeSelectionValues
    call AddAtoHL
    ld a, [hl]
    ret

MapEditor_Arrange_DrawPanel:
    ld bc, $0020
    ld de, $1406
    farcall UIWindow_DrawFrame
    ld hl, EditorSubmenu_Map_Label
    call CoordTextPut
    ld c, $00
.loop
    ld a, c
    call MapEditor_Arrange_DrawOption
    inc c
    ld a, c
    cp $05
    jr nz, .loop
    ret

    assert @ == $4eea


section "Map Editor Terrain Arrange Presentation", romx[$4ef1], bank[$0f]

DEF wMapEditorTerrainLabelBuffer EQU $c011
DEF wMapEditorTerrainLabelEnd    EQU $c01a

; A = arrange class (0-4). Resolve the current value within that class to a
; terrain ID, upload its metatile graphics, and draw the corresponding option
; card in the lower editor panel.
MapEditor_Arrange_DrawOption::
    push bc
    push de
    ld b, a
    ld hl, wMapEditorArrangeSelectionValues
    call AddAtoHL
    ld c, [hl]
    ld a, b
    ld hl, MapEditor_TerrainArrangeClassPointers
    call WordTable_Get
    ld a, c
    call AddAtoHL
    ld c, [hl]
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, b
    call MapEditor_Arrange_GetOptionTileDestination
    ld a, c
    farcall MapMetatile_LoadTiles
    push bc
    ld a, b
    add a
    add b
    add $03
    ld b, a
    ld c, $21
    call Vram_TilemapCoord
    pop bc
    ld d, c
    ld a, b
    add a
    add a
    add $c0
    ld bc, $0003
    farcall MapMetatile_DrawTilemap
    pop de
    pop bc
    ret

; Keep the editor cursor sprite centered on the currently selected terrain
; class in the five-column arrange panel.
MapEditor_Arrange_UpdateCursorSprite::
    push bc
    ld a, [wMapEditorArrangeSelectionClass]
    ld b, a
    add a
    add b
    add $03
    rlca
    rlca
    rlca
    add $10
    ld b, a
    ld a, $0d
    rlca
    rlca
    rlca
    add $18
    ld c, a
    ld a, [wMapCursorSpriteObjectId]
    call SpriteObject_SetPosition
    pop bc
    ret

; Redraw the selected terrain preview and its name in the lower panel.
MapEditor_Arrange_RedrawSelection::
    push bc
    ld a, [wMapEditorSelectedTerrainId]
    farcall Terrain_GetNameIndex
    call MapEditor_Arrange_CopyTerrainNameToBuffer
    ld hl, wMapEditorTerrainLabelBuffer
    ld bc, $0624
    call TextPut
    pop bc
    ret

; A = terrain name index. Copy its zero-terminated tile string into the fixed
; nine-byte editor label buffer, prefilled with blank tile $80.
MapEditor_Arrange_CopyTerrainNameToBuffer::
    push bc
    push de
    push af
    ld hl, wMapEditorTerrainLabelBuffer
    ld bc, $0009
    ld a, $80
    call Memset
    ld a, $00
    ld [wMapEditorTerrainLabelEnd], a
    pop af
    ld hl, Terrain_Name_Strings
    call WordTable_Get
    ld de, wMapEditorTerrainLabelBuffer
.copy
    ld a, [hli]
    and a
    jr z, .done
    ld [de], a
    inc de
    jr .copy
.done
    pop de
    pop bc
    ret

    assert @ == $4f90

section "Map Editor Unit Arrange Controller", romx[$502b], bank[$0f]

DEF wMapEditorUnitArrangeSelectionClass  EQU $ca58
DEF wMapEditorUnitArrangeSelectionValues EQU $ca5e

MapEditor_RunUnitArrangeController::
    call EditorSubmenu_Unit_Selection
    call EditorSubmenu_Unit_Delete
    ld a, $60
    farcall LCDScanlineTransition_RunToTarget
    farcall MapCursor_Show

.input_loop
    call Joypad_Update
    call MapEditor_UnitArrange_UpdateCursorSprite
    call Sprite_Update
    ldh a, [hJoyRepeat]
    bit 0, a
    jr nz, .accept_or_cancel
    bit 1, a
    jr nz, .accept_or_cancel
    bit 5, a
    jr nz, .class_left
    bit 4, a
    jr nz, .class_right
    bit 6, a
    jr nz, .value_down
    bit 7, a
    jr nz, .value_up
    bit 2, a
    jr nz, .switch_arrange_mode
    jr .input_loop

.accept_or_cancel
    ld a, $02
    call Audio_PlaySFX
    jr .close

.switch_arrange_mode
    farcall MapCursor_Hide
    call Sprite_Update
    call DelayFrame
    farcall LCDScanlineTransition_Reset
    xor a
    ld [wMapEditorArrangeMode], a
    jp MapEditor_RunArrangeSelectionController

.class_left
    ld a, [wMapEditorUnitArrangeSelectionClass]
    dec a
    cp $ff
    jr nz, .store_class
    ld a, $06
    jr .store_class

.class_right
    ld a, [wMapEditorUnitArrangeSelectionClass]
    inc a
    cp $07
    jr c, .store_class
    xor a
.store_class
    ld [wMapEditorUnitArrangeSelectionClass], a
    ld a, $01
    call Audio_PlaySFX
    call MapEditor_Arrange_RebuildSelection
    call EditorSubmenu_Unit_Delete
    jr .input_loop

.value_down
    call MapEditor_UnitArrange_GetCurrentValueAndMaximum
    dec a
    and a
    jr nz, .store_value_down
    ld a, b
.store_value_down
    ld [hl], a
    jr .redraw_value

.value_up
    call MapEditor_UnitArrange_GetCurrentValueAndMaximum
    cp b
    jr nz, .increment_value
    xor a
.increment_value
    inc a
    ld [hl], a

.redraw_value
    call MapEditor_Arrange_RebuildSelection
    call EditorSubmenu_Unit_Delete
    ld a, [wMapEditorUnitArrangeSelectionClass]
    cp $06
    jp z, .input_loop
    call MapEditor_UnitArrange_DrawOption
    ld a, $01
    call Audio_PlaySFX
    jp .input_loop

.close
    farcall LCDScanlineTransition_Reset
    ret

; Returns A = current value, B = maximum value, HL = current value byte.
MapEditor_UnitArrange_GetCurrentValueAndMaximum:
    ld a, [wMapEditorUnitArrangeSelectionClass]
    ld hl, MapEditor_UnitArrangeClassPointers
    call WordTable_Get
    ld b, [hl]
    ld a, [wMapEditorUnitArrangeSelectionClass]
    ld hl, wMapEditorUnitArrangeSelectionValues
    call AddAtoHL
    ld a, [hl]
    ret

    assert @ == $50ec
