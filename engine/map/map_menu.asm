include "macros/macros.inc"
include "charmaps/char_main.inc"

; Main six-entry map menu layout (MapMenu_Menu).
DEF MAP_MENU_ACTION_EDIT    EQU $00
DEF MAP_MENU_ACTION_COPY    EQU $01
DEF MAP_MENU_ACTION_SEND    EQU $02
DEF MAP_MENU_ACTION_PLAY    EQU $03
DEF MAP_MENU_ACTION_DELETE  EQU $04
DEF MAP_MENU_ACTION_RECEIVE EQU $05

; Extended/alternate map menu layout (MapMenu_ShowAlternateActionPrompt).
; This menu uses a different ordering from the six-entry main menu.
DEF MAP_MENU_ALT_ACTION_EDIT         EQU $00
DEF MAP_MENU_ALT_ACTION_PLAY         EQU $01
DEF MAP_MENU_ALT_ACTION_COPY         EQU $02
DEF MAP_MENU_ALT_ACTION_DELETE       EQU $03
DEF MAP_MENU_ALT_ACTION_SEND         EQU $04
DEF MAP_MENU_ALT_ACTION_RECEIVE      EQU $05
DEF MAP_MENU_ALT_ACTION_SAVE         EQU $06
DEF MAP_MENU_ALT_ACTION_UPLOAD_WHICH EQU $07
DEF MAP_MENU_ALT_ACTION_UPLOAD_WHERE EQU $08
DEF MAP_MENU_ALT_ACTION_DELETE_WHAT  EQU $09
DEF MAP_MENU_ALT_ACTION_SUBMIT_WHAT  EQU $0a

section "MapMenu_DrawMainActionLabels", romx[$4213], bank[$13]
MapMenu_DrawMainActionLabels:
    ld hl, MapMenu_Strings.edit
    call CoordTextPut
    ld hl, MapMenu_Strings.play
    call CoordTextPut
    ld hl, MapMenu_Strings.copy
    call CoordTextPut
    ld hl, MapMenu_Strings.delete
    call CoordTextPut
    ld hl, MapMenu_Strings.map_communication
    call CoordTextPut

section "MapMenu_ShowAlternateActionPrompt", romx[$43e3], bank[$13]
MapMenu_ShowAlternateActionPrompt:
    ld [wMapMenuAlternateActionIndex], a
    cp MAP_MENU_ALT_ACTION_EDIT
    jr z, .edit
    cp MAP_MENU_ALT_ACTION_PLAY
    jr z, .play
    cp MAP_MENU_ALT_ACTION_COPY
    jr z, .copy
    cp MAP_MENU_ALT_ACTION_DELETE
    jr z, .delete_1
    cp MAP_MENU_ALT_ACTION_SEND
    jr z, .send
    cp MAP_MENU_ALT_ACTION_RECEIVE
    jr z, .receive
    cp MAP_MENU_ALT_ACTION_SAVE
    jr z, .save
    cp MAP_MENU_ALT_ACTION_UPLOAD_WHERE
    jr z, .upload_1
    cp MAP_MENU_ALT_ACTION_DELETE_WHAT
    jr z, .delete_2
    cp MAP_MENU_ALT_ACTION_SUBMIT_WHAT
    jr z, .submit
    cp MAP_MENU_ALT_ACTION_UPLOAD_WHICH
    jr z, .upload_2

.edit:
    ld hl, MapMenu_Strings.edit_which
    jr .select_map
.play:
    ld hl, MapMenu_Strings.play_which
    jr .select_map
.copy:
    ld hl, MapMenu_Strings.copy_which
    jr .select_map
.delete_1:
    ld hl, MapMenu_Strings.delete_which
    jr .select_map
.send:
    ld hl, MapMenu_Strings.IR_send_which
    jr .select_map
.receive:
    ld hl, MapMenu_Strings.IR_receive_where
    jr .select_map
.upload_1:
    ld hl, MapMenu_Strings.upload_where
    jr .select_map
.delete_2:
    ld hl, MapMenu_Strings.delete_what
    jr .select_map
.submit:
    ld hl, MapMenu_Strings.submit_what
    jr .select_map
.upload_2:
    ld hl, MapMenu_Strings.upload_which
    jr .select_map
.save:
    ld hl, MapMenu_Strings.save_where
    jr .select_map
.select_map:
    call CoordTextPut

section "MapMenu_DisplayMapDataStatus", romx[$4638], bank[$13]
MapMenu_DisplayMapDataStatus:
    cp $00
    jr z, .no_map
    ld hl, $ca6a
    lb bc, 2, 13 ; Description Coordinates
    call TextPut
    ld hl, MapMenu_Strings.map_number
    call CoordTextPut
    ld hl, wMapMenuDownloadMapNumber
    lb bc, 8, 14 ; Download Map Number Coordinates
    call TextPut
    jr .finish
.no_map:
    ld hl, MapMenu_Strings.no_map_data
    lb bc, 2, 13 ; No Map Data Coordinates
    call TextPut
.finish:
    call SRAM_Disable
    ret

; closes the control bridge immediately before the selected-map
; summary renderer. The caller supplies A as the map-selection value preserved
; across the setup calls. Bit 1 of wMapRecordFlags gates whether the name/size
; body is drawn; a clear bit branches to the existing no-data fallback.
section "MapMenu Selected Map Summary Control", romx[$4663], bank[$13]
MapMenu_PrepareSelectedMapSummary::
    push af
    farcall $28, MapRuntime_LoadCurrentModeRecord
    call $4581
    ld a, 1
    ld hl, wMapRecordFlags
    call Bitfield_Test
    jp z, $46fe

    assert @ == $4676

; Straight-line portion of the selected-map summary renderer. composes
; the physical 8-byte name plus the header sidecar without shifting the later
; width/height code or its caller-visible addresses.
section "MapMenu Selected Map Name and Size", romx[$4676], bank[$13]
MapMenu_DrawSelectedMapNameAndSize::
    lb bc, 2, 13
    call MapName9_DrawLoadedViaDC3B
    ; Keep following retail instruction addresses stable for overlay callers.
    ds 15, 0
    ld a, [wMapRecordWidth]
    lb bc, 13, 13
    ld d, $02
    call $31f5
    ld a, $58
    lb bc, 15, 13
    call Vram_DrawTileAtCoordinates
    ld a, [wMapRecordHeight]
    lb bc, 16, 13
    ld d, $02
    call $31f5
    pop af

    assert @ == $46aa

section "MapMenu_ShowMapNumberLabel", romx[$46af], bank[$13]
MapMenu_ShowMapNumberLabel:
    ld hl, MapMenu_Strings.map_number
    call CoordTextPut

section "MapMenu_ShowNoMapDataMessage", romx[$46ff], bank[$13]
MapMenu_ShowNoMapDataMessage:
    ld hl, MapMenu_Strings.no_map_data
    lb bc, 2, 13 ; "No Map Data" String Coordinates
    call TextPut

section "MapMenu_User_Map", romx[$4709], bank[$13]
MapMenu_User_Map:
    text "ユーザーマップ"
    ;text "USER MAP"
    done

    assert @ <= $4711, "USER MAP text overlaps MY MAP text"
section "MapMenu_My_Map", romx[$4711], bank[$13]
MapMenu_My_Map:
    text "マイマップ"
    ;text "MY MAP"
    done

    assert @ <= $4717, "MY MAP text overlaps control runtime"

; Control/runtime that follows the two short map-category labels. These routines
; are reached by the surrounding Map Menu state machine and all stay before the
; preserved upload/send restriction strings at $47B4/$47C8.
section "MapMenu Selection Control Runtime", romx[$4717], bank[$13]
MapMenu_DrawCurrentSelectionSummary::
    ld a, [$dc50]
    cp $08
    jr c, .draw
    call $45f8
    ret
.draw
    ld a, [$dc2b]
    call MapMenu_PrepareSelectedMapSummary
    ret

MapMenu_DrawFiveSelectionRows::
    xor a
.loop
    push af
    push bc
    push de
    call $452e
    ld de, $0202
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    pop de
    inc d
    pop bc
    inc b
    inc b
    inc b
    pop af
    inc a
    cp $05
    jr z, .done
    push af
    jr .loop
.done
    ret

; A selects which preserved restriction string to display:
;   0 -> MapMenu_Cannot_Upload
; nonzero -> MapMenu_Cannot_Send
; The routine saves/restores the active VRAM-bank state around the dialog,
; waits for either of the accepted joypad buttons, requests SFX $02, and then
; restores the surrounding Map Menu presentation state.
MapMenu_ShowTransferRestrictionMessage::
    push af
    call DelayFrame
    ld a, [$dc2c]
    call SpriteObject_Hide
    call Sprite_Update
    call DelayFrame
    lb bc, 6, 1
    ld de, $1205
    farcall UIWindowStack_PushAndDrawAnimated
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    lb bc, 7, 2
    ld de, $1003
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop af
    cp $00
    jr z, .upload
    jr .send
.upload
    ld hl, MapMenu_Cannot_Upload
    jr .draw_message
.send
    ld hl, MapMenu_Cannot_Send
.draw_message
    lb bc, 7, 2
    call $2b38
.wait_input
    farcall $22, MapMenuMessage_ServiceFrame
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, .accepted
    bit 1, a
    jr nz, .accepted
    jr .wait_input
.accepted
    ld a, $02
    call Audio_RequestSFX
    call DelayFrame
    farcall UIWindowStack_PopRestore
    ld a, [$dc2c]
    call SpriteObject_Show
    ret

    assert @ == $47b4

section "MapMenu_Cannot_Upload", romx[$47b4], bank[$13]
MapMenu_Cannot_Upload:
    ;text "MAP CANNOT BE"
    ;line "UPLOADED。"
    text "このマップはアップロード"
    line "できません。"
    done

    assert @ <= $47c8, "Upload restriction overlaps IR-send restriction"
section "MapMenu_Cannot_Send", romx[$47c8], bank[$13]
MapMenu_Cannot_Send:
    ;text "MAP CANNOT BE"
    ;line "SENT WITH IR。"
    text "このマップはIRつうしんで"
    line "あげることはできません。"
    done

    assert @ <= $47e3, "IR-send restriction overlaps runtime"
section "MapMenu_ShowMainMenuTitle", romx[$4a75], bank[$13]
MapMenu_ShowMainMenuTitle:
    ld hl, MapMenu_Strings.main_menu
    lb bc, 3, 2 ; Menu Coordinates
    call TextPrint

section "MapMenu_UpdateCursor", romx[$4ac3], bank[$13]
MapMenu_UpdateCursor:
    ld a, [wMapMenuActionIndex]
    ld b, $03
    rst $28
    inc d
    dec de
    ld e, a
    ; The cursor needs to increment 4 tiles, then 5 tiles when moving right, instead of the same amount each time, not sure how to accomplish that.
    ld b, $30 ; Cursor's horizontal increment
    call MultiplyAByB
    ld a, l
    add $1c ; Cursor's base horizontal offset for screen
    ld [wMapMenuCursorX], a
    ld a, [wMapMenuActionIndex]
    ld b, $03
    rst $28
    inc d
    dec de
    ld e, a
    ld a, b
    ld b, $08 ; Cursor's vertical increment
    call MultiplyAByB
    ld a, l
    add $24 ; Cursor's base vertical offset for screen
    ld [wMapMenuCursorY], a
    ld a, [$dc3a]
    cp $01
    jr nz, .draw_cursor

    ld a, [wMapMenuCursorY]
    sub $28
    ld [wMapMenuCursorY], a

.draw_cursor:
    ld a, [wMapMenuCursorX]
    ld b, a
    ld a, [wMapMenuCursorY]
    ld c, a
    ld a, [$dc37]
    call SpriteObject_SetPosition
    ret

section "MapMenu_Menu", romx[$4b49], bank[$13]
MapMenu_Menu:
    ld a, [wMapMenuActionIndex]
    cp MAP_MENU_ACTION_EDIT
    jr z, .edit
    cp MAP_MENU_ACTION_COPY
    jr z, .copy
    cp MAP_MENU_ACTION_SEND
    jr z, .send
    cp MAP_MENU_ACTION_PLAY
    jr z, .play
    cp MAP_MENU_ACTION_DELETE
    jr z, .delete
    cp MAP_MENU_ACTION_RECEIVE
    jr z, .receive

.edit:
    ld hl, MapMenu_Strings.edit_which
    jr .select_map
.copy:
    ld hl, MapMenu_Strings.copy_which
    jr .select_map
.send:
    ld hl, MapMenu_Strings.IR_send_which
    jr .select_map
.play:
    ld hl, MapMenu_Strings.play_which
    jr .select_map
.delete:
    ld hl, MapMenu_Strings.delete_which
    jr .select_map
.receive:
    ld hl, MapMenu_Strings.IR_receive_where
    jr .select_map
.select_map:
    call CoordTextPut
    ret
    assert @ <= $4b86, "MapMenu_Menu must not overlap runtime"


section "MapMenu_ShowCopyDestinationPrompt", romx[$4d4f], bank[$13]
MapMenu_ShowCopyDestinationPrompt:
    ld hl, MapMenu_Strings.copy_where
    call CoordTextPut
    assert @ <= $4f40, "MapMenu_ShowCopyDestinationPrompt must not overlap runtime"

section "MapMenu Copy Destination Controller", romx[$51f3], bank[$13]
MapMenu_RunCopyDestinationSelection::
    ld hl, MapMenu_Strings.copy_where
    call CoordTextPut
    ld a, [$dc2c]
    call SpriteObject_DisableAutoAnimation
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f44
    call SpriteObject_Create
    ld [$dc31], a
    call $44e7
    ld a, [wMapMenuCopyDestinationSlot]
    call MapMenu_PrepareSelectedMapSummary

.input_loop
    call DelayFrame
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyPressed]
    bit 6, a
    jr z, .down
    ld a, $01
    call Audio_RequestSFX
    ld a, [wMapMenuCopyDestinationSlot]
    sub $05
    jr c, .input_loop
    ld [wMapMenuCopyDestinationSlot], a
    call $44e7
    ld a, [wMapMenuCopyDestinationSlot]
    call MapMenu_PrepareSelectedMapSummary
    jr .input_loop

.down
    bit 7, a
    jr z, .left
    ld a, $01
    call Audio_RequestSFX
    ld a, [wMapMenuCopyDestinationSlot]
    add $05
    cp $0a
    jr nc, .input_loop
    ld [wMapMenuCopyDestinationSlot], a
    call $44e7
    ld a, [wMapMenuCopyDestinationSlot]
    call MapMenu_PrepareSelectedMapSummary
    jr .input_loop

.left
    bit 5, a
    jr z, .right
    ld a, $01
    call Audio_RequestSFX
    ld a, [wMapMenuCopyDestinationSlot]
    dec a
    cp $ff
    jr nz, .store_horizontal
    ld a, $09
.store_horizontal
    ld [wMapMenuCopyDestinationSlot], a
    call $44e7
    ld a, [wMapMenuCopyDestinationSlot]
    call MapMenu_PrepareSelectedMapSummary
    jr .input_loop

.right
    bit 4, a
    jr z, .accept
    ld a, $01
    call Audio_RequestSFX
    ld a, [wMapMenuCopyDestinationSlot]
    inc a
    cp $0a
    jr nz, .store_right
    xor a
.store_right
    ld [wMapMenuCopyDestinationSlot], a
    call $44e7
    ld a, [wMapMenuCopyDestinationSlot]
    call MapMenu_PrepareSelectedMapSummary
    jr .continue_input

.accept
    bit 0, a
    jr z, .cancel
    ld a, $02
    call Audio_RequestSFX
    ld a, [wMapMenuCopyDestinationSlot]
    call MapMenu_TestSelectedSlot
    jr z, .copy
    ld a, $01
    call MapMenu_OpenConfirmPrompt
    cp $01
    jr z, .continue_input
.copy
    call MapMenu_CopySelectedSlotData
    ld a, [$dc31]
    call SpriteObject_Destroy
    farcall UIWindowStack_PopRestore
    jr .exit
    call MapMenu_DrawSlotPairRows
    call MapMenu_DrawCurrentSelectionSummary
    jr .continue_input

.cancel
    bit 1, a
    jr z, .continue_input
    ld a, SFX_ERROR
    call Audio_RequestSFX
    ld a, [$dc31]
    call SpriteObject_Destroy
    farcall UIWindowStack_PopRestore
    jr .exit

.continue_input
    jp .input_loop
.exit
    ld a, [$dc2c]
    call SpriteObject_EnableAutoAnimation
    ret

MapMenu_CopySelectedSlotData::
    ld a, [$dc2b]
    ld b, a
    ld a, [wMapMenuCopyDestinationSlot]
    ld c, a
    farcall $13, MapSRAM_CopySlot
    ret

MapMenu_OpenConfirmPrompt::
    push af
    ld a, $01
    ld [wMapMenuConfirmChoice], a
    ld bc, $010c
    ld de, $1205
    farcall UIWindowStack_PushAndDraw
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $020d
    ld de, $0f03
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop af

    assert @ == $532b

section "MapMenu Confirm Prompt", romx[$532b], bank[$13]
MapMenu_RunConfirmPrompt::
    cp $00
    jr nz, .copy
    ld hl, MapMenu_Strings.delete_prompt
    call CoordTextPut
    jr .draw_initial_choice
.copy
    ld hl, MapMenu_Strings.copy_prompt_overwrite
    call CoordTextPut
.draw_initial_choice
    ld bc, $0710
    call MapMenu_DrawConfirmChoiceRight

.input_loop
    call DelayFrame
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyPressed]
    bit 5, a
    jr z, .right
    ld a, $01
    call Audio_RequestSFX
    xor a
    ld [wMapMenuConfirmChoice], a
    ld bc, $070f
    call MapMenu_DrawConfirmChoiceLeft
    jr .input_loop

.right
    bit 4, a
    jr z, .accept
    ld a, $01
    call Audio_RequestSFX
    ld a, $01
    ld [wMapMenuConfirmChoice], a
    ld bc, $070f
    call MapMenu_DrawConfirmChoiceRight
    jr .input_loop

.accept
    bit 0, a
    jr z, .cancel
    ld a, [wMapMenuConfirmChoice]
    cp $00
    jr nz, .confirm_yes
    ld a, $02
    call Audio_RequestSFX
    xor a
    jr .finish
.confirm_yes
    ld a, SFX_CANCEL
    call Audio_RequestSFX
    ld a, $01
    jr .finish

.cancel
    bit 1, a
    jr z, .input_loop
    ld a, SFX_CANCEL
    call Audio_RequestSFX
    ld a, $01
    jr .finish
    jr .input_loop ; unreachable retail branch retained for byte-exact layout

.finish
    push af
    farcall UIWindowStack_PopRestore
    pop af
    ret

MapMenu_DrawConfirmChoiceLeft::
    push bc
    ld a, $0f
    ld de, $0201
    ld h, $fb
    farcall Gfx_DrawSequentialTileRectWithAttributes
    pop bc
    inc b
    inc b
    push bc
    ld a, $08
    ld de, $0101
    ld h, $fd
    farcall Gfx_DrawSequentialTileRectWithAttributes
    pop bc
    inc b
    ld a, $08
    ld de, $0201
    ld h, $fe
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret

MapMenu_DrawConfirmChoiceRight::
    push bc
    ld a, $08
    ld de, $0201
    ld h, $fb
    farcall Gfx_DrawSequentialTileRectWithAttributes
    pop bc
    inc b
    inc b
    push bc
    ld a, $08
    ld de, $0101
    ld h, $fd
    farcall Gfx_DrawSequentialTileRectWithAttributes
    pop bc
    inc b
    ld a, $0f
    ld de, $0201
    ld h, $fe
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret

    assert @ == $5400

section "MapMenu_Suspend", romx[$5400], bank[$13]
MapMenu_Suspend:
    call LCD_Disable
    call VBlankFIFO_Clear
    call $2d7c
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ld bc, $0101
    ld de, $1205
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    lb bc, 1, 6
    ld de, $120b
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, MapMenu_Strings.suspend_continue_1
    call CoordTextPut
    ld hl, MapMenu_Strings.suspend_continue_2
    call CoordTextPut
    lb bc, 7, 11
    call MapMenu_DrawConfirmChoiceLeft
    xor a
    ld [$dc4f], a
    ld hl, MapMenu_Strings.suspend_map_label
    call CoordTextPut
    ld a, [wMapPhaseNumber]
    srl a
    inc a
    lb bc, 5, 3 ; Day Count Coordinates (2,3)
    ld d, $02
    call $31f5
    ld hl, MapMenu_Strings.suspend_day_count
    call CoordTextPut
    ld a, [wMapRecordIndex]
    inc a
    lb bc, 6, 2
    ld d, $02
    call DrawNumberFixedWidth
    lb bc, 9, 2
    call MapName9_DrawLoadedViaDC3B
    ; Preserve all later labels in this mixed sourced/overlay routine.
    ds 15, 0
    ld hl, MapMenu_Strings.suspend_warning_1
    call CoordTextPut
    ld hl, MapMenu_Strings.suspend_warning_2
    call CoordTextPut
    ld hl, MapMenu_Strings.suspend_warning_3
    call CoordTextPut
    ld a, [wActiveGameMode]
    cp GAME_MODE_MAP_EDITOR
    jr nz, .check_suspended_battle_type
    ret

; These three seem to be for a menu for a suspended IR battle, need to look for the menu in-game.
.check_suspended_battle_type:
    ld a, [wMapControlInfraredBattleMode]
    cp $01
    jr z, .show_ir_battle
    cp $00
    jr z, .show_battle

.show_ir_battle:
    ld hl, MapMenu_Strings.IR_battle
    call CoordTextPut
    ret

.show_battle:
    ld hl, MapMenu_Strings.battle
    call CoordTextPut
    ret

    assert @ == $54c0, "MapMenu_Suspend must end before the earlier continue-save controller"

; Cache the selected map name and record index for the adjacent map-menu state
; machine. stores the header sidecar at $CC91 and keeps the index at
; $CC92; display helpers temporarily zero the index as the terminator.
section "MapMenu Cache Selected Map Name", romx[$5a89], bank[$13]
MapMenu_CacheSelectedMapName::
    jp MapName9_CacheSelectedMapName

    assert @ <= $5aa2
