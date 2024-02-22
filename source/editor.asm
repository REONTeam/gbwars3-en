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
    ;db 2, 33, "はいちモ―ド ", 0
    db 2, 33, "ARRANGE", 0

.size:
    ;db 12, 33, "マップサイズ", 0
    db 12, 33, "SIZE", 0

.funds:
    ;db 2, 34, "しきん", 0
    db 2, 34, "FUNDS", 0

.materials:
    ;db c, 34, "しざい", 0
    db 12, 34, "MATERIA", 0

.name:
    ;db 2, 35, "マップのなまえ", 0
    db 2, 35, "NAME", 0

.fill:
    ;db 12, 35, "ぬりつぶし", 0
    db 12, 35, "FILL", 0

.save:
    ;db 2, 36, "セ―ブする", 0
    db 2, 36, "SAVE", 0

.quit:
    ;db 12, 36, "しゅうりょう", 0
    db 12, 36, "END", 0

    section_end $460f

section "0f:4c3a", romx[$4c3a], bank[$0f]
EditorSubmenu:
    ld bc, $0020
    ld de, $1405
    rst $28
    db $10, $09, $6a
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
    db 2, 33, "SIZE", 0

.string_size_horz:
    db 7, 34, "HOR", 0

.string_size_vert:
    db 7, 35, "VER", 0

; Map Editor - Submenu - Funds
.string_funds:
    db 2, 33, "FUNDS", 0

.string_funds_red:
    db 4, 34, "O.STAR    000", 0

.string_funds_white:
    db 4, 35, "W.MOON    000", 0

; Map Editor - Submenu - Materials
.string_materials:
    ;db 2, 33, "しざい", 0
	db 2, 33, "MTL", 0

.string_materials_red:
    ;db 4, 34, "レッドスタ―    0", 0
    db 4, 34, "O.STAR    0", 0

.string_materials_white:
    ;db 4, 35, "ホワイトム―ン   0", 0
    db 4, 35, "W.MOON    0", 0

; Map Editor - Submenu - Arrange Mode
.string_arrange:
    ;db 2, 33, "はいちモ―ド", 0
    db 2, 33, "ARRANGE", 0

.string_arrange_map:
    ;db 6, 34, "マップエディット", 0
    db 6, 34, "MAP EDIT", 0

.string_arrange_unit:
    ;db 6, 35, "ユニットはいち ", 0
    db 6, 35, "PLACE UNIT", 0

; Map Editor - Submenu - Save Prompt
.string_save:
	;db 2, 33, "よろしいですか?", 0
    db 2, 33, "OK?", 0

.string_save_no:
    ;db 9, 34, "いいえ", 0
	db 9, 34, "NO", 0

.string_save_yes:
    ;db 9, 35, "はい", 0
	db 9, 35, "YES", 0

    section_end $4d65

section "0f:50ec", romx[$50ec], bank[$0f]
EditorSubmenu_Unit_Selection:
    ld bc, $0020
    ld de, $1406
    rst $28
    db $10, $09, $6a
    ld hl, .string_unit
    call $336e
    ld hl, .divider1
    call $336e
    ld hl, .divider2
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
    rst $28
    db $0b, $75, $76
    ld bc, $0d21
    call $0ed4
    ld d, $6a
    ld bc, $0003
    ld a, $06
    add a
    add a
    add $c0
    rst $28
    db $0b, $c9, $76
    ld a, [$c991]
    ld b, a
    ld a, [$c992]
    ld c, a
    rst $28
    db $0b, $70, $47
    ld c, a
    ld a, $00
    ldh [$83], a
    ldh [$4f], a
    ld a, $07
    call $5218
    ld a, c
    rst $28
    db $0b, $77, $76
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
    rst $28
    db $0b, $cf, $76
    ret

.string_unit:
    ;db 1, 36, "ユニット/", 0
    db 1, 36, "UNIT/", 0

.divider1:
    db 15, 33, "|", 0

.divider2:
    db 15, 34, "|", 0

section "0f:51f2", romx[$51f2], bank[$0f]
EditorSubmenu_Unit_Delete:
    push bc
    ld a, [$ca66]
    and a
    jr z, .delete
    rst $28
    db $12, $4f, $40
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
    ;db "ユニットサクジョ  ", 0
    db "DELETE    ", 0

    section_end $5218
