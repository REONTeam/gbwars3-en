include "macros/macros.inc"
include "charmaps/char_main.inc"
include "charmaps/char_unit.inc"

; Initialize a fresh editor map-record buffer. The editor uses the same logical
; 46-byte prefix layout as loaded ROM/SRAM maps: 32-byte header, 8-byte name,
; four map fields, width, and height. This makes the live bytes immediately
; following the retail 8-byte name explicit before any width migration.
section "Editor New Map Record Initialize", romx[$40eb], bank[$0f]
MapEditor_InitNewMapRecord::
    ld hl, wEditorMapRecordBuffer
    ld bc, MAP_RECORD_HEADER_SIZE
    xor a
    call Memset
    ld a, MAP_RECORD_HEADER_SIZE
    ld [wEditorMapRecordBuffer], a
    xor a
    ld [wEditorMapRecordParameter0], a
    ld [wEditorMapRecordParameter1], a
    ld [wEditorMapRecordParameter2], a
    ld [wEditorMapRecordParameter3], a
    ld a, 20
    ld [wEditorMapRecordWidth], a
    ld [wEditorMapRecordHeight], a
    ld [$c989], a
    ld [$c98a], a
    call MapEditor_InitDefaultName
    farcall MapGrid_ResetWorkingState
    ld bc, $0000
    ld a, [$c989]
    ld d, a
    dec d
    ld a, [$c98a]
    ld e, a
    dec e
    ld a, $29
    call MapEditor_FillRectangle
    farcall MapGrid_RebuildTileCountsAndHQCoordinates
    ret

    assert @ == $4133

; Initialize the editor's private map-name buffer. Retail reserves eight bytes
; at wEditorMapName, starts with "MAP", appends the map number, and writes a
; zero terminator after the generated digits.
section "Editor Map Name Initialize", romx[$4133], bank[$0f]
MapEditor_InitDefaultName::
    ld hl, wEditorMapName
    ld bc, MAP_RECORD_NAME_SIZE
    ld a, $20
    call Memset
    ld de, Editor_Default_Name
    ld hl, wEditorMapName
    ld bc, 3
    call Memcpy
    ld a, [$ca4f]
    cp 9
    jr nz, .single_digit
    ld a, $31
    ld [wEditorMapName + 3], a
    ld a, $30
    ld [wEditorMapName + 4], a
    jr .terminate
.single_digit
    add $31
    ld [wEditorMapName + 4], a
    ld a, $30
    ld [wEditorMapName + 3], a
.terminate
    ld a, 0
    ld [wEditorMapName + 5], a
    ret

    assert @ == $416d

setcharmap main
section "Editor_Default_Name", romx[$416d], bank[$0f]
Editor_Default_Name:
    ;text "マップ"
    text "MAP"

setcharmap unit
    assert @ <= $4464, "Editor default name overlaps warnings"
section "Editor_Warnings", romx[$4464], bank[$0f]
Editor_Warnings::
Editor_Warnings_BuildingLimit::
    coord_text 2, 33, "たてものをせっちできる" ; Building Limit first line
Editor_Warnings_UnitLimit::
    coord_text 2, 33, "ぶたいをはいちできる" ; Unit limit first line
Editor_Warnings_SharedLimit::
    coord_text 2, 34, "さいだいすうをこえています。" ; Second line for both limit warnings

    assert @ <= $459a, "Editor warnings overlap menu coordinates"
section "EditorMenu_Coordinates", romx[$459a], bank[$0f]
Map_Editor_Menu_Cursor_Coordinates::
    db $01, $21, $0a, $21 ; db $01, $21, $0b, $21
    db $01, $22, $0a, $22 ; db $01, $22, $0b, $22
    db $01, $23, $0a, $23 ; db $01, $23, $0b, $23
    db $01, $24, $0a, $24 ; db $01, $24, $0b, $24

    assert @ <= $45bd, "Editor menu coordinates overlap menu strings"
section "EditorMenu_Strings", romx[$45bd], bank[$0f]
EditorMenu_Strings::
    dw .layout
    dw .size
    dw .funds
    dw .materials
    dw .name
    dw .fill
    dw .save
    dw .quit

; Map Editor - Menu
.layout:
    ;coord_text 2, 33, "はいちモ―ド "
    coord_text 2, 33, "ARRANGE"

.size:
    ;coord_text 12, 33, "マップサイズ"
    coord_text 11, 33, "MAPSIZE" ; MAP SIZE

.funds:
    ;coord_text 2, 34, "しきん"
    coord_text 2, 34, "FUNDS"

.materials:
    ;coord_text c, 34, "しざい"
    coord_text 11, 34, "MATERIAL"

.name:
    ;coord_text 2, 35, "マップのなまえ"
    coord_text 2, 35, "NAME"

.fill:
    ;coord_text 12, 35, "ぬりつぶし"
    coord_text 11, 35, "FILL"

.save:
    ;coord_text 2, 36, "セ―ブする"
    coord_text 2, 36, "SAVE"

.quit:
    ;coord_text 12, 36, "しゅうりょう"
    coord_text 11, 36, "END"

    section_end $460f

; Preserve the retail entry point, but route mode-2 editing to the expanded
; sidecar-aware implementation in the otherwise-unused Bank $0F tail.
section "Editor Map Name Edit", romx[$4789], bank[$0f]
MapEditor_EditName::
    jp MapEditor_EditName9

    assert @ <= $47b3

; Edit a logical nine-character map name without widening the record prefix.
; Characters 1-8 use the retail text buffer. Character 9 reuses the retail
; terminator byte at $CC37 while text-input mode 2 is active, and is copied
; to/from header byte $1F through wEditorMapNameExtra.
section "Editor Map Name Edit 9 Character", romx[$5400], bank[$0f]
MapEditor_EditName9::
    call MapTerrainAnimation_Reset
    call FadeToWhite8
    ld de, wEditorMapName
    ld bc, MAP_RECORD_NAME_SIZE
    ld hl, wTextInputBuffer
    call Memcpy
    ld a, [wEditorMapNameExtra]
    ld [wTextInputMapNameExtra], a
    ld a, 2
    farcall $14, TextInput_Run
    ld de, wTextInputBuffer
    ld hl, wEditorMapName
    ld bc, MAP_RECORD_NAME_SIZE
    call Memcpy
    ld a, [wTextInputMapNameExtra]
    ld [wEditorMapNameExtra], a
    ld a, $fe
    ret

    assert @ <= $5480, "9-character map-name editor exceeds reserved Bank $0F tail budget"

section "EditorSubmenu_Message_HQ", romx[$4837], bank[$0f]
EditorSubmenu_Message_HQ::
    coord_text 2, 33, "シュトのかずがただしくないので"
EditorSubmenu_Message_HQ_Line2::
    coord_text 2, 34, "セ―ブできません。"
EditorSubmenu_Message_HQ_Line3::
    coord_text 2, 35, "1こずつはいちしてください。"

    assert @ <= $4954, "Editor HQ warning overlaps save prompt"
section "EditorSubmenu_Save", romx[$4954], bank[$0f]
EditorSubmenu_Save::
    coord_text 2, 33, "しゅうりょうしますか?"
EditorSubmenu_Save_Line2::
    coord_text 4, 34, "セ―ブしてしゅうりょう"
EditorSubmenu_Save_Line3::
    coord_text 4, 35, "セ―ブしないでしゅうりょう"
EditorSubmenu_Save_Line4::
    coord_text 4, 36, "もどる"

    assert @ <= $49ed, "Editor save prompt overlaps fill restriction"
section "EditorSubmenu_Message_Limit", romx[$49ed], bank[$0f]
EditorSubmenu_Message_Limit::
    coord_text 2, 33, "ぶたいやたてものは"
EditorSubmenu_Message_Limit_Line2::
    coord_text 2, 34, "ぬりつぶしできません。"

    assert @ <= $4b08, "Editor fill restriction overlaps fill-range prompt"
section "EditorSubmenu_Message_Fill", romx[$4b08], bank[$0f]
EditorSubmenu_Message_Fill::
    coord_text 2, 33, "ぬりつぶすはんいの"
EditorSubmenu_Message_Fill_First::
    coord_text 2, 34, "さいしょのHEXを"
EditorSubmenu_Message_Fill_Last::
    coord_text 2, 34, "さいごのHEXを"
EditorSubmenu_Message_Fill_Confirm::
    coord_text 2, 35, "けっていしてください。"

    assert @ <= $4c3a, "Editor fill-range prompt overlaps submenu code"
section "EditorSubmenu", romx[$4c3a], bank[$0f]
EditorSubmenu::
    ld bc, $0020
    ld de, $1405
    farcall UIWindow_DrawFrame
    ld d, $55
    call MapEditor_InitializeSubmenuSelection
    ld a, [$c945]
    cp $00
    jr z, .arrange ; Submenu - Arrange Mode
    cp $01
    jr z, .size ; Submenu - Size
    cp $02
    jr z, .funds ; Submenu - Funds
    cp $03
    jr z, .materials ; Submenu - Materials
    cp $08
    jr z, .save ; Save

.arrange: ; Map Editor - Arrange Mode
    ld hl, .string_arrange
    call CoordTextPut
    ld hl, .string_arrange_map
    call CoordTextPut
    ld hl, .string_arrange_unit
    call CoordTextPut
    ret

.size: ; Map Editor - Size
    ld hl, .string_size
    call CoordTextPut
    ld hl, .string_size_horz
    call CoordTextPut
    ld hl, .string_size_vert
    call CoordTextPut
    jr .end

.funds: ; Map Editor - Funds
    ld hl, .string_funds
    call CoordTextPut
    ld hl, .string_funds_red
    call CoordTextPut
    ld hl, .string_funds_white
    call CoordTextPut
    jr .end

.materials: ; Map Editor - Materials
    ld hl, .string_materials
    call CoordTextPut
    ld hl, .string_materials_red
    call CoordTextPut
    ld hl, .string_materials_white
    call CoordTextPut
    jr .end

.save: ; Map Editor - Save
    ld hl, .string_save
    call CoordTextPut
    ld hl, .string_save_no
    call CoordTextPut
    ld hl, .string_save_yes
    call CoordTextPut
    ret

.end:
    call VBlankFIFO_WaitEmpty
    ld a, $01
    ld [$c940], a
    call MapEditor_DrawSubmenuValues
    xor a
    ld [$c940], a
    call MapEditor_DrawSubmenuValues
    ret

; Map Editor - Submenu - Map Size
.string_size:
    coord_text 2, 33, "SIZE"

.string_size_horz:
    coord_text 7, 34, "HOR"

.string_size_vert:
    coord_text 7, 35, "VER"

; Map Editor - Submenu - Funds
.string_funds:
    coord_text 2, 33, "FUNDS"

.string_funds_red:
    coord_text 4, 34, "O.STAR    000"

.string_funds_white:
    coord_text 4, 35, "W.MOON    000"

; Map Editor - Submenu - Materials
.string_materials:
    ;coord_text 2, 33, "しざい"
    coord_text 2, 33, "MTL" ; MATERIAL

.string_materials_red:
    ;coord_text 4, 34, "レッドスタ―    0"
    coord_text 4, 34, "O.STAR    0"

.string_materials_white:
    ;coord_text 4, 35, "ホワイトム―ン   0"
    coord_text 4, 35, "W.MOON    0"

; Map Editor - Submenu - Arrange Mode
.string_arrange:
    ;coord_text 2, 33, "はいちモ―ド"
    coord_text 2, 33, "ARRANGE"

.string_arrange_map:
    ;coord_text 6, 34, "マップエディット"
    coord_text 6, 34, "MAP EDIT"

.string_arrange_unit:
    ;coord_text 6, 35, "ユニットはいち "
    coord_text 6, 35, "PLACE UNIT"

; Map Editor - Submenu - Save Prompt
.string_save:
    ;coord_text 2, 33, "よろしいですか?"
    coord_text 2, 33, "OK?"

.string_save_no:
    ;coord_text 9, 34, "いいえ"
    coord_text 9, 34, "NO"

.string_save_yes:
    ;coord_text 9, 35, "はい"
    coord_text 9, 35, "YES"

    section_end $4d65

section "EditorSubmenu_Map_Label", romx[$4eea], bank[$0f]
EditorSubmenu_Map_Label::
    ;coord_text 2, 36, "チケイ/"
    coord_text 2, 36, "MAP/"

DEF wMapEditorSelectedUnitId EQU $ca66

section "EditorSubmenu_Unit_Selection", romx[$50ec], bank[$0f]
EditorSubmenu_Unit_Selection::
    ld bc, $0020
    ld de, $1406
    farcall UIWindow_DrawFrame
    ld hl, .string_unit
    call CoordTextPut
    ld hl, .string_divider_1
    call CoordTextPut
    ld hl, .string_divider_2
    call CoordTextPut
    ld c, $00

.loop:
    ld a, c
    call MapEditor_UnitArrange_DrawOption
    inc c
    ld a, c
    cp $06
    jr nz, .loop

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $06
    call MapEditor_Arrange_GetOptionTileDestination
    ld a, $6a
    farcall UnitGraphic_LoadTiles
    ld bc, $0d21
    call Vram_TilemapCoord
    ld d, $6a
    ld bc, $0003
    ld a, $06
    add a
    add a
    add $c0
    farcall UnitGraphic_DrawMetatile
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    ld c, a
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $07
    call MapEditor_Arrange_GetOptionTileDestination
    ld a, c
    farcall MapMetatile_LoadTiles
    push bc
    ld bc, $1021
    call Vram_TilemapCoord
    pop bc
    ld d, c
    ld a, $07
    add a
    add a
    add $c0
    ld bc, $0003
    farcall MapMetatile_DrawTilemap
    ret

.string_unit:
    ;coord_text 1, 36, "ユニット/"
    coord_text 1, 36, "UNIT/"

; Two vertical dividers between the placeable units and the currently selected hex
.string_divider_1:
    coord_text 15, 33, ":"

.string_divider_2:
    coord_text 15, 34, ":"

section "EditorSubmenu_Unit_Delete", romx[$51f2], bank[$0f]
EditorSubmenu_Unit_Delete::
    push bc
    ld a, [wMapEditorSelectedUnitId]
    and a
    jr z, .delete
    farcall UnitData_CopyNameToBuffer
    ld hl, wUnitNameBuffer
    jr z, .from_ram
.delete:
    ld hl, .string_delete
.from_ram:
    ld bc, $0624
    call TextPut
    pop bc
    ret

.string_delete
    ;text "ユニットサクジョ  "
    text "DELETE    "
    done

    section_end $5218
