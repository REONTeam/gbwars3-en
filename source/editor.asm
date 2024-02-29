include "include/macros.inc"
include "include/char_unit.inc"

setcharmap unit

section "0f:45bd", romx[$45bd], bank[$0f]
EditorMenu_Strings:
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
    coord_text 12, 33, "SIZE"

.funds:
    ;coord_text 2, 34, "しきん"
    coord_text 2, 34, "FUNDS"

.materials:
    ;coord_text c, 34, "しざい"
    coord_text 12, 34, "MATERIA"

.name:
    ;coord_text 2, 35, "マップのなまえ"
    coord_text 2, 35, "NAME"

.fill:
    ;coord_text 12, 35, "ぬりつぶし"
    coord_text 12, 35, "FILL"

.save:
    ;coord_text 2, 36, "セ―ブする"
    coord_text 2, 36, "SAVE"

.quit:
    ;coord_text 12, 36, "しゅうりょう"
    coord_text 12, 36, "END"

    section_end $460f

section "0f:4c3a", romx[$4c3a], bank[$0f]
EditorSubmenu:
    ld bc, $0020
    ld de, $1405
    farcall $10, $6a09
    ld d, $55
    call $4de2
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
    call $336e
    ld hl, .string_arrange_map
    call $336e
    ld hl, .string_arrange_unit
    call $336e
    ret

.size: ; Map Editor - Size
    ld hl, .string_size
    call $336e
    ld hl, .string_size_horz
    call $336e
    ld hl, .string_size_vert
    call $336e
    jr .end

.funds: ; Map Editor - Funds
    ld hl, .string_funds
    call $336e
    ld hl, .string_funds_red
    call $336e
    ld hl, .string_funds_white
    call $336e
    jr .end

.materials: ; Map Editor - Materials
    ld hl, .string_materials
    call $336e
    ld hl, .string_materials_red
    call $336e
    ld hl, .string_materials_white
    call $336e
    jr .end

.save: ; Map Editor - Save
    ld hl, .string_save
    call $336e
    ld hl, .string_save_no
    call $336e
    ld hl, .string_save_yes
    call $336e
    ret

.end:
    call $352e
    ld a, $01
    ld [$c940], a
    call $4d65
    xor a
    ld [$c940], a
    call $4d65
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
    coord_text 2, 33, "MTL"

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

section "0f:50ec", romx[$50ec], bank[$0f]
EditorSubmenu_Unit_Selection:
    ld bc, $0020
    ld de, $1406
    farcall $10, $6a09
    ld hl, .string_unit
    call $336e
    ld hl, .string_divider_1
    call $336e
    ld hl, .string_divider_2
    call $336e
    ld c, $00

.loop:
    ld a, c
    call $517e
    inc c
    ld a, c
    cp $06
    jr nz, .loop

    ld a, $00
    ldh [$83], a
    ldh [$4f], a
    ld a, $06
    call $5218
    ld a, $6a
    farcall $0b, $7675
    ld bc, $0d21
    call $0ed4
    ld d, $6a
    ld bc, $0003
    ld a, $06
    add a
    add a
    add $c0
    farcall $0b, $76c9
    ld a, [$c991]
    ld b, a
    ld a, [$c992]
    ld c, a
    farcall $0b, $4770
    ld c, a
    ld a, $00
    ldh [$83], a
    ldh [$4f], a
    ld a, $07
    call $5218
    ld a, c
    farcall $0b, $7677
    push bc
    ld bc, $1021
    call $0ed4
    pop bc
    ld d, c
    ld a, $07
    add a
    add a
    add $c0
    ld bc, $0003
    farcall $0b, $76cf
    ret

.string_unit:
    ;coord_text 1, 36, "ユニット/"
    coord_text 1, 36, "UNIT/"

; Two vertical dividers between the placeable units and the currently selected hex
.string_divider_1:
    coord_text 15, 33, "|"

.string_divider_2:
    coord_text 15, 34, "|"

section "EditorSubmenu_Unit_Delete", romx[$51f2], bank[$0f]
EditorSubmenu_Unit_Delete:
    push bc
    ld a, [$ca66]
    and a
    jr z, .delete
    farcall $12, $404f
    ld hl, $cd28
    jr z, .from_ram
.delete:
    ld hl, .string_delete
.from_ram:
    ld bc, $0624
    call $3353
    pop bc
    ret

.string_delete
    ;text "ユニットサクジョ  "
    text "DELETE    "    done

    section_end $5218
