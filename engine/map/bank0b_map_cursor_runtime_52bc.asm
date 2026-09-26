include "macros/macros.inc"
include "constants/unit_constants.inc"
include "constants/map_analysis_constants.inc"

; Shared selected-map coordinate/cursor interaction runtime.

DEF wMapCoordinateSelectionX EQU $c9c3
DEF wMapCoordinateSelectionY EQU $c9c4

section "Bank $0B selected-map cursor runtime", romx[$52bc], bank[$0b]

; Shared selected-map coordinate/cursor interaction controller. It is reached
; from both the map runtime and the map/editor path.
MapRuntime_RunCoordinateSelectionController::
    call LCD_Disable
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $6638
    ld hl, $9000
    ld bc, $0320
    farcall $01, Memcpy
    call MapCursor_LoadGraphics
    ld a, $00
    ld b, $06
    ld c, $01
    ld hl, $6958
    call Vram_SetFarPals
    call Vram_ApplyPals
    call $4057
    call MapCursor_CreateFixedVariant
    call MapCursor_Show
    call Vram_ClearBGTilemapBothBanks
    call MapCursor_WaitForStablePosition
    call MapCursor_EnableSelectionPresentation
    call FadeFromWhite8
.loop
    call Joypad_Update
    call Sprite_Update
    call MapCursor_UpdateFromJoypad
    ldh a, [hMapTileUpdateFlags]
    bit 7, a
    jr nz, .loop
    ldh a, [hJoyRepeat]
    bit 0, a
    jr nz, .accept
    bit 1, a
    jr nz, .cancel
    bit 2, a
    jr nz, .cancel
    bit 4, a
    jr nz, .move_up
    bit 5, a
    jr nz, .move_down
    bit 6, a
    jr nz, .move_left
    bit 7, a
    jr nz, .move_right
    jr .loop

.accept
    ld a, SFX_CONFIRM
    call Audio_PlaySFX
    call FadeToWhite8
    call MapCursor_DisableSelectionPresentation
    ld a, [wMapCoordinateSelectionX]
    add a, $09
    ld b, a
    ld a, [wMapCoordinateSelectionY]
    add a, $09
    ld c, a
    xor a
    jr .done

.cancel
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    call FadeToWhite8
    call MapCursor_DisableSelectionPresentation
    ld a, $ff
    jr .done

.move_up
    call MapCursor_TryMoveUp
    jr .loop
.move_down
    call MapCursor_TryMoveDown
    jr .loop
.move_left
    call MapCursor_TryMoveLeft
    jr .loop
.move_right
    call MapCursor_TryMoveRight
    jr .loop
.done
    ret

; Copy the current map cursor position into the staged coordinate pair, then
; visit the surrounding presentation cells while preserving the active WRAM bank.
MapCursor_WaitForStablePosition::
    ldh a, [hWRAMBank]
    push af
    call MapCursor_CopyMapCoordinatesToSelection
    ld a, [wMapCoordinateSelectionY]
    ld c, a
    ld e, $12
.row_loop
    ld d, $14
    ld a, [wMapCoordinateSelectionX]
    ld b, a
    bit 0, c
    jr z, .column_loop
    dec b
    inc d
.column_loop
    call $2814
    inc b
    dec d
    jr nz, .column_loop
    inc c
    dec e
    jr nz, .row_loop
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

; Copies the current map viewport coordinates into the controller's selection pair.
MapCursor_CopyMapCoordinatesToSelection::
    ld a, [wMapViewportOriginX]
    sub $05
    ld [wMapCoordinateSelectionX], a
    ld a, [wMapViewportOriginY]
    sub $05
    ld [wMapCoordinateSelectionY], a
    ret

; Install the temporary LCD/STAT presentation state used by coordinate selection.
MapCursor_EnableSelectionPresentation::
    push hl
    di
    ld hl, $26cb
    call SetLCDStatInterrupt
    ld hl, rSTAT
    set 3, [hl]
    call Interrupt_EnableLCDStat
    ld hl, $26ff
    call SetVBlankInterrupt
    ei
    pop hl
    ret

; Restore the normal LCD/STAT presentation state after coordinate selection.
MapCursor_DisableSelectionPresentation::
    di
    call Interrupt_DisableLCDStat
    ld hl, rSTAT
    res 3, [hl]
    call DisableLCDStatInterrupt
    call InstallDefaultVBlankInterrupt
    ei
    ret

; Apply directional repeat input to the staged coordinate pair.
MapCursor_UpdateFromJoypad::
    ldh a, [hMapTileUpdateFlags]
    bit 6, a
    ret z
    bit 0, a
    jr nz, .decrement_x
    bit 1, a
    jr nz, .increment_x
    bit 2, a
    jr nz, .decrement_y
    bit 3, a
    jr nz, .increment_y
    ret
.decrement_x
    ld a, [wMapCoordinateSelectionX]
    dec a
    ld [wMapCoordinateSelectionX], a
    jr .after_x
.increment_x
    ld a, [wMapCoordinateSelectionX]
    inc a
    ld [wMapCoordinateSelectionX], a
.after_x
    jr .clear_repeat
.decrement_y
    ld a, [wMapCoordinateSelectionY]
    dec a
    ld [wMapCoordinateSelectionY], a
    jr .clear_repeat
.increment_y
    ld a, [wMapCoordinateSelectionY]
    inc a
    ld [wMapCoordinateSelectionY], a
.clear_repeat
    xor a
    ldh [hMapTileUpdateFlags], a
    ret

; Bounded movement branch for one map axis.
MapCursor_TryMoveUp::
    ld a, [wMapGridWidth]
    add a, $05
    ld b, a
    ld a, [wMapCoordinateSelectionX]
    add a, $13
    cp b
    jr z, .done
    ldh a, [hMapTileUpdateFlags]
    set 1, a
    ldh [hMapTileUpdateFlags], a
    ld a, [wMapCoordinateSelectionX]
    add a, $14
    ld b, a
    ld a, [wMapCoordinateSelectionY]
    ld c, a
    ld a, SFX_WAIT_ACTION
    call MapCursor_ApplyCoordinateMove
    ld a, SFX_CURSOR_MOVE
    call Audio_PlaySFX
    jr .done
.done
    ret

; Bounded movement branch for the opposite direction on the same map axis.
MapCursor_TryMoveDown::
    ld a, [wMapCoordinateSelectionX]
    cp $fb
    jr z, .done
    ldh a, [hMapTileUpdateFlags]
    set 0, a
    ldh [hMapTileUpdateFlags], a
    ld a, [wMapCoordinateSelectionX]
    dec a
    ld b, a
    ld a, [wMapCoordinateSelectionY]
    ld c, a
    ld a, SFX_WAIT_ACTION
    call MapCursor_ApplyCoordinateMove
    ld a, SFX_CURSOR_MOVE
    call Audio_PlaySFX
    jr .done
.done
    ret

; Bounded movement branch for one direction on the second map axis.
MapCursor_TryMoveRight::
    ld a, [wMapGridHeight]
    add a, $04
    ld c, a
    ld a, [wMapCoordinateSelectionY]
    add a, $12
    cp c
    jr z, .done
    ldh a, [hMapTileUpdateFlags]
    set 3, a
    ldh [hMapTileUpdateFlags], a
    ld a, [wMapCoordinateSelectionX]
    ld b, a
    ld a, [wMapCoordinateSelectionY]
    add a, $12
    ld c, a
    call MapCursor_GetMoveSFX
    ld a, SFX_CURSOR_MOVE
    call Audio_PlaySFX
    jr .done
.done
    ret

; Bounded movement branch for the opposite direction on the second map axis.
MapCursor_TryMoveLeft::
    ld a, [wMapCoordinateSelectionY]
    cp $fb
    jr z, .done
    ldh a, [hMapTileUpdateFlags]
    set 2, a
    ldh [hMapTileUpdateFlags], a
    ld a, [wMapCoordinateSelectionX]
    ld b, a
    ld a, [wMapCoordinateSelectionY]
    dec a
    ld c, a
    call MapCursor_GetMoveSFX
    ld a, SFX_CURSOR_MOVE
    call Audio_PlaySFX
    jr .done
.done
    ret

; Select one of the two movement feedback IDs, then fall through to stage the
; map-tile update coordinates.
MapCursor_GetMoveSFX::
    ld a, $14
    bit 0, c
    jr z, MapCursor_ApplyCoordinateMove
    dec b
    ld a, $15

MapCursor_ApplyCoordinateMove::
    ldh [hMapTileUpdateCount], a
    ld a, b
    ldh [hMapTileUpdateX], a
    ld a, c
    ldh [hMapTileUpdateY], a
    ldh a, [hMapTileUpdateFlags]
    set 7, a
    ldh [hMapTileUpdateFlags], a
    ret

; Stage selected-unit/map scratch fields for the following coordinate-analysis path.
MapCursor_StageSelectedUnitContext::
    ld a, [wUnitRecordScratch]
    ld [wMapAnalysisContext0], a
    ld a, [wUnitRecordScratch + UNIT_RECORD_FUEL_OFFSET]
    ld [wMapAnalysisContext1], a
    ld a, [wUnitRecordScratch + 1]
    ld [wMapAnalysisContextX], a
    ld a, [wUnitRecordScratch + 2]
    ld [wMapAnalysisContextY], a
    ld a, [wUnitRecordScratch + 8]
    ld [wMapAnalysisContext4], a
    ld a, [$c9dd]
    and a
    jp z, MapRuntime_BuildCoordinateAnalysisWorkspace
    farcall $0c, UnitPave_BuildRouteAnalysisWorkspace
    ret

    assert @ == $54e0
