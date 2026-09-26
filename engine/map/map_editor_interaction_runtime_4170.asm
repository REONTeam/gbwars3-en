include "macros/macros.inc"

; Map Editor interaction, placement validation, placement preview, and main-menu
; selection runtime. These names are intentionally lifetime-scoped: the same
; scratch bytes are reused by other map/unit interfaces outside the editor.

DEF wMapEditorMenuSelectionIndex      EQU $c940
DEF wMapEditorSubmenuId               EQU $c945
DEF wMapEditorPreviewPulseCounter     EQU $ca51
DEF wMapEditorArrangeMode             EQU $ca52
DEF wMapEditorSelectedTerrainId       EQU $ca65
DEF wMapEditorSelectedUnitId          EQU $ca66
DEF wMapEditorPaintAfterMoveFlag      EQU $ca67
DEF wMapInteractionInputState         EQU $ca91

; $3A8F calls the word-table entry selected by A.
DEF WordTable_Call                    EQU $3a8f
; Shared single-tile draw helper: A = tile, B/C = tilemap coordinates.
; Still-structural editor arrange-palette controller reached from the main loop.

section "Map Editor Interaction Runtime", romx[$4170], bank[$0f]

MapEditor_RunInteractionController::
    call LCD_Disable
    call Vram_ClearBGTilemapBothBanks
    farcall $0b, Bank0B_MapSetupFrontend4000
    farcall $0b, Bank0B_MapSetup_428A
    farcall $0b, MapCursor_Show
    call FadeFromWhite8
    ld a, $1f
    call Audio_PlayMusic
    xor a
    ld [wMapEditorPaintAfterMoveFlag], a
    set 0, a
    ldh [hMapAnimationFlags], a
    call Joypad_Update

.input_loop
    farcall $0b, MapControl_UpdateInteractionInputState
    call MapEditor_UpdatePlacementPreviewBlink

    ld a, [wMapEditorPaintAfterMoveFlag]
    bit 0, a
    jr nz, .paint_after_move

.dispatch_input
    ld a, [wMapInteractionInputState]
    bit 0, a
    jr nz, .place
    bit 1, a
    jr nz, .open_arrange_selection
    bit 2, a
    jr nz, .coordinate_selection
    bit 3, a
    jr nz, .open_main_menu
    bit 5, a
    jp nz, .move_left
    bit 4, a
    jp nz, .move_right
    bit 6, a
    jp nz, .move_up
    bit 7, a
    jp nz, .move_down
    jr .input_loop

.paint_after_move
    xor a
    ld [wMapEditorPaintAfterMoveFlag], a
    call MapEditor_ApplyCurrentPlacement
    and a
    jr z, .dispatch_input
    jr .input_loop

.place
    call MapEditor_ApplyCurrentPlacement
    jr .input_loop

.open_arrange_selection
    call MapEditor_RestoreCellAtCursor
    farcall $0b, MapCursor_Hide
    call Sprite_Update
    call DelayFrame
    call MapEditor_RunArrangeSelectionController
    jr .input_loop

.coordinate_selection
    call MapTerrainAnimation_Reset
    xor a
    farcall $13, MapRecord_LoadSRAMSlotPrefix
    call MapEditor_RestoreCellAtCursor
    farcall $0b, MapCursor_Hide
    call Sprite_Update
    call DelayFrame
    call FadeToWhite8
    farcall $0b, MapRuntime_RunCoordinateSelectionController
    cp $ff
    jp z, MapEditor_RunInteractionController
    farcall $0b, MapViewport_CenterOnCoordinates
    jp MapEditor_RunInteractionController

.open_main_menu
    call MapEditor_RestoreCellAtCursor
    call MapEditor_SelectMainMenuItem
    cp $ff
    jr z, .redraw_after_menu
    ld hl, MapEditor_MenuHandlerPointers
    call WordTable_Call
    cp $ff
    jr z, .exit
    cp $fe
    jp z, MapEditor_RunInteractionController
.redraw_after_menu
    farcall $0b, MapCursor_LoadGraphics
    farcall $0b, MapCursor_Show
    jp .input_loop

.move_right
    call MapEditor_RestoreCellAtCursor
    farcall $0b, MapControl_AdvanceHorizontalMapPosition
    jr .finish_move

.move_left
    call MapEditor_RestoreCellAtCursor
    farcall $0b, MapControl_RetreatHorizontalMapPosition
    jr .finish_move

.move_up
    call MapEditor_RestoreCellAtCursor
    farcall $0b, MapControl_RetreatVerticalMapPosition
    jr .finish_move

.move_down
    call MapEditor_RestoreCellAtCursor
    farcall $0b, MapControl_AdvanceVerticalMapPosition
    jr .finish_move
.finish_move
    ldh a, [hJoyHeld]
    bit 0, a
    jp z, .input_loop
    ld a, [wMapEditorPaintAfterMoveFlag]
    set 0, a
    ld [wMapEditorPaintAfterMoveFlag], a
    jp .input_loop

.exit
    call MapTerrainAnimation_Reset
    call FadeToWhite8
    call SpriteObject_DestroyAll
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ret

MapEditor_MenuHandlerPointers::
    ; ARRANGE, MAPSIZE, FUNDS, MATERIAL, NAME, FILL, SAVE, END.
    dw MapEditor_HandleArrangeMenu, MapEditor_HandleMapSizeMenu
    dw MapEditor_HandleFundsMenu, MapEditor_HandleMaterialsMenu
    dw MapEditor_EditName, MapEditor_HandleFillMenu
    dw MapEditor_HandleSaveMenu, MapEditor_HandleEndMenu

MapEditor_ApplyCurrentPlacement::
    push bc
    push de
    ld a, [wMapEditorArrangeMode]
    and a
    jr nz, .unit

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call MapEditor_PrepareTerrainPlacement
    and a
    jr nz, .reject
    ld a, [wMapEditorSelectedTerrainId]
    farcall $0b, MapTile_SetBaseIdAtCoordinates
    jr .commit

.unit
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call MapEditor_PrepareUnitPlacement
    and a
    jr nz, .reject
    ld a, [wMapEditorSelectedUnitId]
    farcall $0b, MapTile_SetOverlayByteAtCoordinates

.commit
    farcall $0b, Bank0B_MapSetup_43D1
    ld a, $02
    call Audio_PlaySFX
    xor a
    jr .done
.reject
    ld a, $ff
.done
    pop de
    pop bc
    ret

; Validate terrain replacement at B/C and update the raw-tile histogram before
; the caller commits the new base tile. If a unit occupies the cell, reject
; terrain on which that unit's movement class has zero cost. Placing a new
; property/building into a previously non-property cell is capped at 100.
MapEditor_PrepareTerrainPlacement::
    push bc
    push hl
    farcall $0b, MapTile_GetOverlayIdAtCoordinates
    and a
    jr z, .check_property_limit

    push bc
    push de
    ld d, a
    ld a, [wMapEditorSelectedTerrainId]
    farcall $0b, Terrain_GetNameIndex
    ld b, a
    ld a, d
    ld c, $19
    farcall $12, UnitData_GetByte
    farcall $12, MovementData_GetCost
    pop de
    pop bc
    and a
    jr z, .reject

.check_property_limit
    ld a, [wMapEditorSelectedTerrainId]
    cp $20
    jr nc, .check_unique_hq
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    cp $20
    jr c, .check_unique_hq
    farcall $0c, MapGrid_CountPropertyTiles
    cp 100
    jr nz, .check_unique_hq
    call MapEditor_ShowPropertyLimitWarning
    ld a, $ff
    jr .done

.check_unique_hq
    call MapEditor_CheckUniqueHQPlacement
    and a
    jr nz, .reject

    ld a, [wMapEditorSelectedTerrainId]
    ld hl, wMapTileCountsById
    call AddAtoHL
    inc [hl]
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    ld hl, wMapTileCountsById
    call AddAtoHL
    dec [hl]
    xor a
    jr .done

.reject
    ld a, SFX_ERROR
    call Audio_PlaySFX
    ld a, $ff
    jr .done
.done
    pop hl
    pop bc
    ret

; Raw terrain IDs $01 and $0C are the two HQ classes. The editor permits only
; one occurrence of each, using the already-maintained raw-tile histogram.
MapEditor_CheckUniqueHQPlacement::
    ld a, [wMapEditorSelectedTerrainId]
    cp $01
    jr z, .hq
    cp $0c
    jr z, .hq
    xor a
    ret
.hq
    ld hl, wMapTileCountsById
    call AddAtoHL
    ld a, [hl]
    and a
    ret z
    ld a, $ff
    ret

; Validate unit placement and keep wUnitCountBySide synchronized. A selected
; unit ID of zero is the editor's delete-unit mode. Nonzero unit IDs encode the
; side in bit 0; each side is capped at 50 placed units.
MapEditor_PrepareUnitPlacement::
    push bc
    push hl
    ld a, [wMapEditorSelectedUnitId]
    and a
    jr z, .delete

    push bc
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    farcall $0b, Terrain_GetNameIndex
    ld b, a
    ld a, [wMapEditorSelectedUnitId]
    ld c, $19
    farcall $12, UnitData_GetByte
    farcall $12, MovementData_GetCost
    pop bc
    and a
    jr z, .reject

    farcall $0b, MapTile_GetOverlayIdAtCoordinates
    and a
    jr z, .new_unit

    and $01
    ld c, a
    ld a, [wMapEditorSelectedUnitId]
    and $01
    cp c
    jr nz, .replace_other_side
    xor a
    jr .done

.replace_other_side
    ld hl, wUnitCountBySide
    call AddAtoHL
    ld a, [hl]
    cp 50
    jr z, .unit_limit
    inc [hl]
    ld a, c
    ld hl, wUnitCountBySide
    call AddAtoHL
    dec [hl]
    xor a
    jr .done

.new_unit
    ld a, [wMapEditorSelectedUnitId]
    and $01
    ld hl, wUnitCountBySide
    call AddAtoHL
    ld a, [hl]
    cp 50
    jr z, .unit_limit
    inc [hl]
    xor a
    jr .done

; Preserved public/internal entry in the retail stream. No owned caller is
; currently proven; it increments the selected side's count without validation.
.increment_selected_side_count
    ld a, [wMapEditorSelectedUnitId]
    and $01
    ld hl, wUnitCountBySide
    call AddAtoHL
    inc [hl]
    xor a
    jr .done

.delete
    call MapEditor_DecrementExistingUnitCount
    and a
    jr nz, .reject
    xor a
    jr .done

.unit_limit
    call MapEditor_ShowUnitLimitWarning
    ld a, $ff
    jr .done

.reject
    ld a, SFX_ERROR
    call Audio_PlaySFX
    ld a, $ff
.done
    pop hl
    pop bc
    ret

MapEditor_DecrementExistingUnitCount::
    push bc
    push hl
    farcall $0b, MapTile_GetOverlayIdAtCoordinates
    and a
    jr z, .empty
    and $01
    ld hl, wUnitCountBySide
    call AddAtoHL
    dec [hl]
    xor a
    jr .done
.empty
    ld a, $ff
.done
    pop hl
    pop bc
    ret

MapEditor_ShowPropertyLimitWarning::
    ld a, $00
    jr MapEditor_ShowPlacementLimitWarning

MapEditor_ShowUnitLimitWarning::
    ld a, $01

MapEditor_ShowPlacementLimitWarning::
    push af
    farcall $0b, MapCursor_Hide
    call Sprite_Update
    call DelayFrame
    ld a, SFX_ERROR
    call Audio_PlaySFX
    farcall SharedGraphics_LoadMenuFontTiles
    ld bc, $0020
    ld de, $1405
    farcall $10, UIWindow_DrawFrame
    pop af
    and a
    jr nz, .unit
    ld hl, Editor_Warnings_BuildingLimit
    call CoordTextPut
    ld hl, Editor_Warnings_SharedLimit
    call CoordTextPut
    jr .wait
.unit
    ld hl, Editor_Warnings_UnitLimit
    call CoordTextPut
    ld hl, Editor_Warnings_SharedLimit
    call CoordTextPut
.wait
    ld a, $68
    farcall $0b, LCDScanlineTransition_RunToTarget
.input
    call Joypad_Update
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, .close
    bit 1, a
    jr nz, .close
    jr .input
.close
    farcall $0b, LCDScanlineTransition_Reset
    farcall $0b, MapCursor_LoadGraphics
    farcall $0b, MapCursor_Show
    ret

    assert @ == $4464

section "Map Editor Placement Preview and Menu Selector", romx[$4490], bank[$0f]

; Blink the selected terrain/unit preview every ten frames. At count 10 the
; selected placement is drawn; at count 20 the real cell is restored and the
; counter is reset by MapEditor_RestoreCellAtCursor.
MapEditor_UpdatePlacementPreviewBlink::
    ld a, [wMapEditorPreviewPulseCounter]
    inc a
    ld [wMapEditorPreviewPulseCounter], a
    cp 10
    jr z, .preview
    cp 20
    jr nz, .done
    call MapEditor_RestoreCellAtCursor
    jr .done
.preview
    call MapEditor_DrawSelectedPlacementPreview
.done
    ret

MapEditor_DrawSelectedPlacementPreview::
    ld a, [wMapEditorArrangeMode]
    and a
    jr nz, .unit
    ld a, [wMapEditorSelectedTerrainId]
    ld d, a
    jr .draw
.unit
    ld a, [wMapEditorSelectedUnitId]
    add $34
    ld d, a
    cp $34
    jr nz, .draw
    ld d, $35
.draw
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, d
    farcall $0b, Bank0B_MapSetup_444D
    ret

MapEditor_RestoreCellAtCursor::
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    farcall $0b, MapTile_GetOverlayIdAtCoordinates
    and a
    jr nz, .unit
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    jr .draw
.unit
    add $34
.draw
    farcall $0b, Bank0B_MapSetup_444D
    xor a
    ld [wMapEditorPreviewPulseCounter], a
    ret

MapEditor_SelectMainMenuItem::
    ld a, $ff
    ld [wMapEditorSubmenuId], a
    farcall $0b, MapCursor_Hide
    call Sprite_Update
    call DelayFrame
    farcall SharedGraphics_LoadMenuFontTiles
    ld bc, $0020
    ld de, $1406
    farcall $10, UIWindow_DrawFrame
    call MapEditor_DrawMainMenuLabels
    xor a
    ld [wMapEditorMenuSelectionIndex], a
    ld d, $55
    call MapEditor_DrawMainMenuCursor
    ld a, $60
    farcall $0b, LCDScanlineTransition_RunToTarget

.input
    call Joypad_Update
    call Sprite_Update
    ldh a, [hJoyRepeat]
    bit 1, a
    jr nz, .cancel
    bit 0, a
    jr nz, .confirm
    and $f0
    jr nz, .move
    jr .input

.confirm
    ld a, $02
    call Audio_PlaySFX
    jr .finish
.cancel
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    ld [wMapEditorMenuSelectionIndex], a
.finish
    farcall $0b, LCDScanlineTransition_Reset
    ld a, [wMapEditorMenuSelectionIndex]
    ret

.move
    ld a, [wMapEditorMenuSelectionIndex]
    ld hl, hJoyRepeat
    bit 6, [hl]
    jr nz, .up
    bit 7, [hl]
    jr nz, .down
    xor $01
    call MapEditor_UpdateMainMenuCursor
    jr .input
.up
    sub $02
    and $07
    call MapEditor_UpdateMainMenuCursor
    jr .input
.down
    add $02
    and $07
    call MapEditor_UpdateMainMenuCursor
    jr .input

MapEditor_UpdateMainMenuCursor::
    ld d, $80
    call MapEditor_DrawMainMenuCursor
    ld [wMapEditorMenuSelectionIndex], a
    ld d, $55
    call MapEditor_DrawMainMenuCursor
    ld a, $01
    call Audio_PlaySFX
    ret

; D is the tile ID used for erase/draw. A is preserved as the selection index.
MapEditor_DrawMainMenuCursor::
    push af
    ld a, [wMapEditorMenuSelectionIndex]
    add a
    ld hl, Map_Editor_Menu_Cursor_Coordinates
    call AddAtoHL
    ld b, [hl]
    inc hl
    ld c, [hl]
    ld a, d
    call Vram_DrawTileAtCoordinates
    pop af
    ret

    assert @ == $459a

section "Map Editor Main Menu Label Renderer", romx[$45aa], bank[$0f]
MapEditor_DrawMainMenuLabels::
    ld c, $00
.loop
    ld a, c
    ld hl, EditorMenu_Strings
    call WordTable_Get
    call CoordTextPut
    inc c
    ld a, c
    cp $08
    jr nz, .loop
    ret

    assert @ == $45bd
