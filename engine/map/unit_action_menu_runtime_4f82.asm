include "macros/macros.inc"

; Shared in-map Action Menu list, renderer, and selector.
;
; $C9BE = number of staged action IDs.
; $C9B6-$C9BD = up to eight staged action IDs.
; $C9BF = first VRAM tile used by the staged entry graphics.
; $C9C0 = selected entry index.
; $C9C1 = horizontal menu placement selected from the map cursor position.
; $C9C2 = 16-frame blink phase for the selected row.
DEF wUnitActionMenuEntryCount  EQU $c9be
EXPORT wUnitActionMenuEntryCount
DEF wUnitActionMenuEntries     EQU $c9b6
DEF wUnitActionMenuTileBase    EQU $c9bf
DEF wUnitActionMenuSelection   EQU $c9c0
DEF wUnitActionMenuLayoutState EQU $c9c1
DEF wUnitActionMenuAnimState   EQU $c9c2

DEF UNIT_ACTION_MENU_MAX_ENTRIES EQU 8
DEF UNIT_ACTION_MENU_GFX_BYTES   EQU $80
DEF UNIT_ACTION_MENU_ROW_WIDTH   EQU 4
DEF UNIT_ACTION_MENU_ROW_HEIGHT  EQU 2
DEF UNIT_ACTION_MENU_BLINK_TILE  EQU $b8

section "Bank $0B Unit Action Menu Runtime", romx[$4f82], bank[$0b]

; A = first VRAM tile allocated to staged action graphics.
; Reset the list, clear all eight slots, and reload graphics slice 0 at $8B80.
; The routine deliberately falls through into UnitActionMenu_ClearEntries.
UnitActionMenu_Reset::
    ld [wUnitActionMenuTileBase], a
    xor a
    ld [wUnitActionMenuEntryCount], a

; A must be zero on entry from UnitActionMenu_Reset.
UnitActionMenu_ClearEntries::
    ld hl, wUnitActionMenuEntries
    ld b, UNIT_ACTION_MENU_MAX_ENTRIES
.clear_loop
    ld [hli], a
    dec b
    jr nz, .clear_loop

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, Image_Action_Menu
    ld hl, $8b80
    ld bc, UNIT_ACTION_MENU_GFX_BYTES
    farcall $11, MemcpyWaitLCD
    ret

; A = action ID. Append it to the staged list. Retail deliberately locks if a
; caller attempts to exceed the eight-entry fixed buffer.
UnitActionMenu_AddEntry::
    push bc
    push hl
    ld b, a
    ld a, [wUnitActionMenuEntryCount]
    cp UNIT_ACTION_MENU_MAX_ENTRIES
    jr z, .overflow
    ld hl, wUnitActionMenuEntries
    call AddAtoHL
    ld [hl], b
    ld hl, wUnitActionMenuEntryCount
    inc [hl]
    pop hl
    pop bc
    ret
.overflow
    jr .overflow

; Run the shared selector. Returns A = selected action ID, or zero on B/cancel.
; D-pad Up/Down wraps through the staged list; A accepts and B cancels.
UnitActionMenu_RunSelection::
    push bc
    push de
    push hl

    ld a, $04
    ldh [hJoyRepeatRate], a
    call UnitActionMenu_LoadEntryGraphics
    call MapCursor_Hide
    call UnitActionMenu_DrawEntries

.input_loop
    call Joypad_Update
    call $3056
    call Joypad_Update
    call UnitActionMenu_AdvanceAnimationState
    ldh a, [hJoyRepeat]
    bit 6, a
    jr nz, .up
    bit 7, a
    jr nz, .down
    bit 0, a
    jr nz, .accept
    bit 1, a
    jr nz, .cancel
    jr .input_loop

.up
    ld a, $01
    call Audio_PlaySFX
    call UnitActionMenu_DrawSelectionMarker
    ld a, [wUnitActionMenuSelection]
    sub 1
    jr nc, .store_selection
    ld a, [wUnitActionMenuEntryCount]
    dec a
    jr .store_selection

.down
    ld a, $01
    call Audio_PlaySFX
    call UnitActionMenu_DrawSelectionMarker
    ld a, [wUnitActionMenuEntryCount]
    ld b, a
    ld a, [wUnitActionMenuSelection]
    inc a
    cp b
    jr nz, .store_selection
    xor a
.store_selection
    ld [wUnitActionMenuSelection], a
    xor a
    ld [wUnitActionMenuAnimState], a
    jr .input_loop

.accept
    ld a, $02
    call Audio_PlaySFX
    ld a, [wUnitActionMenuSelection]
    ld hl, wUnitActionMenuEntries
    call AddAtoHL
    ld a, [hl]
    jr .finish

.cancel
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    xor a

.finish
    push af
    call DelayFrame
    call DelayFrame
    call DelayFrame
    call MapCursor_Show
    call UnitActionMenu_RestoreMapPresentation
    ld a, $02
    ldh [hJoyRepeatRate], a
    pop af
    pop hl
    pop de
    pop bc
    ret

; Initialize selection/blink state, choose left/right screen placement from the
; map cursor X offset, save the covered map rectangle, then draw each 4x2 entry.
UnitActionMenu_DrawEntries::
    xor a
    ld [wUnitActionMenuSelection], a
    ld [wUnitActionMenuAnimState], a
    ld b, $0f
    ld a, [wMapCursorOffsetX]
    cp $05
    jr c, .have_x
    ld b, $01
.have_x
    ld a, b
    ld [wUnitActionMenuLayoutState], a
    ld c, $01
    ld d, $04
    ld a, [wUnitActionMenuEntryCount]
    rlca
    ld e, a
    call MapPresentation_PrepareCoordinatesAndDraw
    call Vram_TilemapCoord
    ld a, [wUnitActionMenuTileBase]
    ld e, a
    ld a, [wUnitActionMenuEntryCount]
    ld c, a
.draw_loop
    call UnitActionMenu_DrawRowBlock
    dec c
    jr nz, .draw_loop
    ret

UnitActionMenu_RestoreMapPresentation::
    call MapPresentation_RunSharedRefresh
    ret

; HL = top-left tilemap destination, E = first tile. Draw a 4x2 block in VRAM
; bank 0 while clearing its matching attribute bytes in VRAM bank 1.
UnitActionMenu_DrawRowBlock::
    push bc
    ld c, UNIT_ACTION_MENU_ROW_HEIGHT
.row_loop
    ld b, UNIT_ACTION_MENU_ROW_WIDTH
    push hl
.column_loop
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, e
    call Vram_PutWaitBlank
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    call Vram_PutWaitBlank
    call Vram_TilemapAdvanceColumnWrapped
    inc e
    dec b
    jr nz, .column_loop
    pop hl
    call Vram_TilemapAdvanceRowWrapped
    dec c
    jr nz, .row_loop
    pop bc
    ret

; Alternate the selected row between the staged entry tiles and the fixed
; $B8-$BF block every eight frames. The exact visual meaning of slice 0 is kept
; neutral; this simply preserves the retail blink behavior.
UnitActionMenu_AdvanceAnimationState::
    ld a, [wUnitActionMenuAnimState]
    and a
    jr z, .draw_blink_block
    cp $08
    jr nz, .advance
    call UnitActionMenu_DrawSelectionMarker
    jr .advance
.draw_blink_block
    call UnitActionMenu_ClearSelectionMarker
.advance
    ld a, [wUnitActionMenuAnimState]
    inc a
    and $0f
    ld [wUnitActionMenuAnimState], a
    ret

; Redraw the selected row from its staged action graphics.
UnitActionMenu_DrawSelectionMarker::
    ld a, [wUnitActionMenuLayoutState]
    ld b, a
    ld a, [wUnitActionMenuSelection]
    add a
    add 1
    ld c, a
    call MapPresentation_ConvertViewportTileToBGMapCoordinates
    call Vram_TilemapCoord
    ld a, [wUnitActionMenuSelection]
    add a
    add a
    add a
    ld e, a
    ld a, [wUnitActionMenuTileBase]
    add e
    ld e, a
    call UnitActionMenu_DrawRowBlock
    ret

; Draw the fixed $B8-$BF blink block over the selected row.
UnitActionMenu_ClearSelectionMarker::
    ld a, [wUnitActionMenuLayoutState]
    ld b, a
    ld a, [wUnitActionMenuSelection]
    add a
    add 1
    ld c, a
    call MapPresentation_ConvertViewportTileToBGMapCoordinates
    call Vram_TilemapCoord
    ld e, UNIT_ACTION_MENU_BLINK_TILE
    call UnitActionMenu_DrawRowBlock
    ret

; Small current-day window used by the selected-map command controller. The
; game stores alternating side phases in wMapPhaseNumber, so (phase >> 1) + 1
; is rendered as the displayed day number. Compatibility alias retained for
; the earlier structural name.
MapControl_DrawDayCounterWindow::
UnitActionMenu_DrawFrame::
    push bc
    push de
    push hl
    ld b, $01
    ld a, [wMapCursorOffsetX]
    cp $05
    jr c, .have_x
    ld b, $0e
.have_x
    ld c, $01
    call MapPresentation_ConvertViewportTileToBGMapCoordinates
    ld de, $0503
    farcall UIWindowStack_PushAndDraw
    ld a, b
    inc a
    and $1f
    ld b, a
    ld a, c
    inc a
    and $1f
    ld c, a
    call Vram_TilemapCoord
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [wMapPhaseNumber]
    srl a
    inc a
    call Number_ByteToPackedBCD
    push af
    swap a
    and $0f
    add $81
    call Vram_PutWaitBlank
    call Vram_TilemapAdvanceColumnWrapped
    pop af
    and $0f
    add $81
    call Vram_PutWaitBlank
    call Vram_TilemapAdvanceColumnWrapped
    ld a, $a8
    call Vram_PutWaitBlank
    pop hl
    pop de
    pop bc
    ret

; Pop the current-day window backing rectangle. Compatibility alias retained.
MapControl_CloseDayCounterWindow::
UnitActionMenu_Helper515F::
    farcall UIWindowStack_PopRestore
    ret

; Upload each staged action's 128-byte graphics slice from Image_Action_Menu
; into the caller-selected VRAM tile range.
UnitActionMenu_LoadEntryGraphics::
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld b, $00
.upload_loop
    push bc
    ld a, b
    ld hl, wUnitActionMenuEntries
    call AddAtoHL
    ld a, [hl]
    call UnitActionMenu_GetGraphicPointer
    ld a, b
    call UnitActionMenu_GetVRAMDestination
    ld bc, UNIT_ACTION_MENU_GFX_BYTES
    farcall $11, MemcpyWaitLCD
    pop bc
    inc b
    ld a, [wUnitActionMenuEntryCount]
    cp b
    jr nz, .upload_loop
    ret

; A = action ID -> DE = 128-byte graphic slice in Bank $11 Image_Action_Menu.
UnitActionMenu_GetGraphicPointer::
    push hl
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, Image_Action_Menu
    add hl, de
    ld d, h
    ld e, l
    pop hl
    ret

; A = staged entry index -> HL = VRAM destination derived from the tile base.
UnitActionMenu_GetVRAMDestination::
    push de
    rlca
    rlca
    rlca
    ld l, a
    ld a, [wUnitActionMenuTileBase]
    add l
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, $8000
    add hl, de
    pop de
    ret

    assert @ == $51b5
