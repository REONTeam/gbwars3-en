include "include/macros.inc"
include "include/char_main.inc"

section "Map_Menu_code4213", romx[$4213], bank[$13]
    ld hl, Map_Menu_Strings.edit
    call $336e
    ld hl, Map_Menu_Strings.play
    call $336e
    ld hl, Map_Menu_Strings.copy
    call $336e
    ld hl, Map_Menu_Strings.delete
    call $336e
    ld hl, Map_Menu_Strings.map_communication
    call $336e

section "Map_Menu_Menu_Alternate_code43e3", romx[$43e3], bank[$13]
Map_Menu_Menu_Alternate_code43e3:
    ld [$dc4d], a
    cp $00
    jr z, .edit
    cp $01
    jr z, .play
    cp $02
    jr z, .copy
    cp $03
    jr z, .delete_1
    cp $04
    jr z, .send
    cp $05
    jr z, .get
    cp $06
    jr z, .save
    cp $08
    jr z, .upload_1
    cp $09
    jr z, .delete_2
    cp $0a
    jr z, .submit
    cp $07
    jr z, .upload_2

.edit:
    ld hl, Map_Menu_Strings.edit_which
    jr .select_map
.play:
    ld hl, Map_Menu_Strings.play_which
    jr .select_map
.copy:
    ld hl, Map_Menu_Strings.copy_which
    jr .select_map
.delete_1:
    ld hl, Map_Menu_Strings.delete_which
    jr .select_map
.send:
    ld hl, Map_Menu_Strings.IR_send_which
    jr .select_map
.get:
    ld hl, Map_Menu_Strings.IR_get_where
    jr .select_map
.upload_1:
    ld hl, Map_Menu_Strings.upload_where
    jr .select_map
.delete_2:
    ld hl, Map_Menu_Strings.delete_what
    jr .select_map
.submit:
    ld hl, Map_Menu_Strings.submit_what
    jr .select_map
.upload_2:
    ld hl, Map_Menu_Strings.upload_which
    jr .select_map
.save:
    ld hl, Map_Menu_Strings.save_where
    jr .select_map
.select_map:
    call $336e

section "Map_Menu_Display_Data_code4638", romx[$4638], bank[$13]
Map_Menu_Display_Data_code4638:
    cp $00
    jr z, .no_map
    ld hl, $ca6a
    lb bc, 2, 13 ; Description Coordinates
    call $3353
    ld hl, Map_Menu_Strings.map_number
    call $336e
    ld hl, $dc44
    lb bc, 8, 14 ; Download Map Number Coordinates
    call $3353
    jr ._465f
.no_map:
    ld hl, Map_Menu_Strings.no_map_data
    lb bc, 2, 13 ; No Map Data Coordinates
    call $3353
._465f:
    call $059b
    ret

section "Map_Menu_code46af", romx[$46af], bank[$13]
    ld hl, Map_Menu_Strings.map_number
    call $336e

section "Map_Menu_code46ff", romx[$46ff], bank[$13]
    ld hl, Map_Menu_Strings.no_map_data
    lb bc, 2, 13 ; No Map Data Coordinates
    call $3353

section "Map_Menu_User_Map", romx[$4709], bank[$13]
    text "ユーザーマップ"
    ;text "USER MAP"
    done

section "Map_Menu_My_Map", romx[$4711], bank[$13]
    text "マイマップ"
    ;text "MY MAP"
    done

section "Map_Menu_Cannot_Upload", romx[$47b4], bank[$13]
    ;text "MAP CANNOT BE"
    ;line "UPLOADED。"
    text "このマップはアップロード"
    line "できません。"
    done

section "Map_Menu_Cannot_Send", romx[$47c8], bank[$13]
    ;text "MAP CANNOT BE"
    ;line "SENT WITH IR。"
    text "このマップはIRつうしんで"
    line "あげることはできません。"
    done

section "Map_Menu_code4a75", romx[$4a75], bank[$13]
    ld hl, Map_Menu_Strings.main_menu
    lb bc, 3, 2 ; Menu Coordinates
    call $2b38

section "Map_Menu_Cursor_code4ac3", romx[$4ac3], bank[$13] 
Map_Menu_Cursor_code4ac3:
    ld a, [$dc36]
    ld b, $03
    rst $28
    inc d
    dec de
    ld e, a
    ; The cursor needs to increment 4 tiles, then 5 tiles when moving right, instead of the same amount each time, not sure how to accomplish that.
    ld b, $30 ; Cursor's horizontal increment
    call $2995
    ld a, l
    add $1c ; Cursor's base horizontal offset for screen
    ld [$dc38], a
    ld a, [$dc36]
    ld b, $03
    rst $28
    inc d
    dec de
    ld e, a
    ld a, b
    ld b, $08 ; Cursor's vertical increment 
    call $2995
    ld a, l
    add $24 ; Cursor's base vertical offset for screen
    ld [$dc39], a
    ld a, [$dc3a]
    cp $01
    jr nz, jr_013_4afb

    ld a, [$dc39]
    sub $28
    ld [$dc39], a

jr_013_4afb:
    ld a, [$dc38]
    ld b, a
    ld a, [$dc39]
    ld c, a
    ld a, [$dc37]
    call $2eae
    ret

section "Map_Menu_Menu", romx[$4b49], bank[$13]
Map_Menu_Menu:
    ld a, [$dc36]
    cp $00
    jr z, .edit
    cp $01
    jr z, .copy
    cp $02
    jr z, .send
    cp $03
    jr z, .play
    cp $04
    jr z, .delete
    cp $05
    jr z, .get

.edit:
    ld hl, Map_Menu_Strings.edit_which
    jr .select_map
.copy:
    ld hl, Map_Menu_Strings.copy_which
    jr .select_map
.send:
    ld hl, Map_Menu_Strings.IR_send_which
    jr .select_map
.play:
    ld hl, Map_Menu_Strings.play_which
    jr .select_map
.delete:
    ld hl, Map_Menu_Strings.delete_which
    jr .select_map
.get:
    ld hl, Map_Menu_Strings.IR_get_where
    jr .select_map
.select_map:
    call $336e
    ret

section "Map_Menu_code4d4f", romx[$4d4f], bank[$13]
    ld hl, Map_Menu_Strings.copy_where
    call $336e

section "Map_Menu_code51f3", romx[$51f3], bank[$13]
    ld hl, Map_Menu_Strings.copy_where
    call $336e

section "Map_Menu_Confirm_Prompt_code532b", romx[$532b], bank[$13]
Map_Menu_Confirm_Prompt_code532b:
    cp $00
    jr nz, .copy
    ld hl, Map_Menu_Strings.delete_prompt
    call $336e
    jr .end
.copy:
    ld hl, Map_Menu_Strings.copy_prompt_overwrite
    call $336e
.end:
    lb bc, 7, 16 ; Unknown Coordinates
    call $53d7

section "Map_Menu_Suspend", romx[$5400], bank[$13]
Map_Menu_Suspend:
    call $04f3
    call $34ce
    call $2d7c
    xor a
    ldh [$95], a
    ldh [$96], a
    farcall $10, $68a8
    farcall $01, $4000
    call $0618
    call $0f02
    ld a, $00
    ldh [$83], a
    ldh [$4f], a
    ld a, $00
    farcall $15, $6691
    ld bc, $0101
    ld de, $1205
    farcall $22, $6247
    lb bc, 1, 6
    ld de, $120b
    farcall $22, $6247
    ld hl, Map_Menu_Strings.suspend_continue_1
    call $336e
    ld hl, Map_Menu_Strings.suspend_continue_2
    call $336e
    lb bc, 7, 11
    call $53ae
    xor a
    ld [$dc4f], a
    ld hl, Map_Menu_Strings.suspend_map_label
    call $336e
    ld a, [$c633]
    srl a
    inc a
    lb bc, 5, 3 ; Day Count Coordinates (2,3)
    ld d, $02
    call $31f5
    ld hl, Map_Menu_Strings.suspend_day_count
    call $336e
    ld a, [$ca1f]
    inc a
    lb bc, 6, 2
    ld d, $02
    call $3237
    ld de, $ca41
    ld hl, $dc3b
    ld bc, $0008
    call $3b50
    ld hl, $dc3b
    lb bc, 9, 2
    call $3353
    ld hl, Map_Menu_Strings.suspend_warning_1
    call $336e
    ld hl, Map_Menu_Strings.suspend_warning_2
    call $336e
    ld hl, Map_Menu_Strings.suspend_warning_3
    call $336e
    ld a, [$c62f]
    cp $03
    jr nz, ._54a7
    ret

; These three seem to be for a menu for a suspended IR battle, need to look for the menu in-game.
._54a7:
    ld a, [$c630]
    cp $01
    jr z, ._54b2
    cp $00
    jr z, ._54b9

._54b2:
    ld hl, Map_Menu_Strings.IR_battle
    call $336e
    ret

._54b9:
    ld hl, Map_Menu_Strings.battle
    call $336e
    ret

section "Map_Menu_Strings", romx[$5541], bank[$13]
Map_Menu_Strings:

.edit:
    ;coord_text 7, 5, "エディット"
    coord_text 7, 5, "EDIT"

.play:
    coord_text 7, 6, "プレイ"
    ;coord_text 7, 6, "PLAY"

.copy:
    coord_text 7, 7, "コピー"
    ;coord_text 7, 7, "COPY"

.delete:
    coord_text 7, 8, "デリート"
    ;coord_text 7, 8, "ERASE"

.map_communication:
    coord_text 7, 9, "マップつうしん"
    ;coord_text 7, 9, "MAP COMM"

.edit_which:
    ;coord_text 2, 2, "どのデータをエディットしますか?"
    coord_text 2, 2, "EDIT WHICH DATA?"

.play_which:
    coord_text 2, 2, "どのデータをプレイしますか?"
    ;coord_text 2, 2, "PLAY WHICH DATA?"

.copy_which:
    coord_text 2, 2, "どのデータをコピーしますか?"
    ;coord_text 2, 2, "COPY WHICH DATA?"

.delete_which:
    coord_text 2, 2, "どのデータをさくじょしますか?"
    ;coord_text 2, 2, "ERASE WHICH DATA?"

.IR_send_which:
    coord_text 2, 2, "どのデータをあげますか?"
    ;coord_text 2, 2, "SEND WHICH DATA?"

.IR_get_where:
    coord_text 2, 2, "どこにデータをもらいますか?"
    ;coord_text 2, 2, "GET DATA WHERE?"

.upload_where:
    coord_text 2, 2, "どこにアップロードしますか?"
    ;coord_text 2, 2, "UPLOAD DATA WHERE?"

.delete_what:
    coord_text 2, 2, "どれをさくじょしますか?"
    ;coord_text 2, 2, "DELETE WHAT DATA?"

.submit_what:
    coord_text 2, 2, "どれをとうこうしますか?"
    ;coord_text 2, 2, "SUBMIT WHAT DATA?"

.upload_which:
    coord_text 2, 2, "どのデータをアップしますか?"
    ;coord_text 2, 2, "UPLOAD WHICH DATA?"

.save_where: ; Which map to save over when downloading on mobile
    coord_text 2, 2, "どこにデータをセーブしますか?"
    ;coord_text 2, 2, "SAVE DATA WHERE?"

    section_end $561f
.current_map_download:  ; not found
    ;coord_text 3, 13, "げんざいマップダウンロードの"
    coord_text 3, 13, "げんざいマップダウンロードの"

    section_end $5630
.current_map_upload:  ; not found
    ;coord_text 3, 13, "げんざいマップアップロードの"
    coord_text 3, 13, "げんざいマップアップロードの"

    section_end $5641
.requesting:  ; not found
    ;coord_text 3, 14, "リクエストちゅうです"
    coord_text 3, 14, "REQUESTING"

.map_number:
    coord_text 2, 14, "マップNO/"
    ;coord_text 2, 14, "MAP NO/"

.main_menu:
    ;text "エディット コピー   あげる"
    ;line "プレイ   デリート  もらう"
    text "EDIT COPY  SEND"
    line "PLAY ERASE GET "
    done

.copy_where:
    coord_text 2, 2, "どこにコピーしますか?"
    ;coord_text 2, 2, "COPY DATA WHERE?"

    section_end $5685
.this_data:  ; not found
    coord_text 3, 13, "このデータを"
    ;coord_text 3, 13, "THIS DATA"

.delete_prompt:
    ;coord_text 3, 13, "さくじょしますか?"
    coord_text 3, 13, "DELETE?"

.copy_prompt_overwrite:
    ;coord_text 3, 13, "うわがきしますか?"
    coord_text 3, 13, "OVERWRITE?"

    section_end $56a6
.ok_prompt:  ; not found
    coord_text 3, 14, "OK?"

.suspend_continue_1:
    coord_text 3, 7, "ぜんかいのセーブデータの"
    ;coord_text 3, 7, "CONTINUE PLAYING"

.suspend_continue_2:
    coord_text 3, 8, "つづきからプレイしますか?"
    ;coord_text 3, 8, "FROM SAVE DATA?"

.suspend_map_label:
    coord_text 2, 2, "MAP:"

.suspend_warning_1:
    ;coord_text 7, 13, "ちゅうい"
    coord_text 6, 13, "WARNING"

.suspend_warning_2:
    coord_text 6, 14, "NOをえらぶと"
    ;coord_text 6, 14, "PICKING NO WILL"

.suspend_warning_3:
    coord_text 4, 15, "セーブデータはきえます。"
    ;coord_text 4, 15, "DELETE THE DATA。"

.suspend_day_count:
    ;coord_text 4, 3, "にちめ"
    coord_text 2, 3, "DAY"

.IR_battle: ; May be used for suspending an IR battle on a custom map?
    coord_text 2, 4, "IRつうしんたいせん"
    ;coord_text 2, 4, "IR COMM BATTLE"

.battle:
    coord_text 2, 4, "たいせん"
    ;coord_text 2, 4, "BATTLE"

    section_end $570f
.edit_description:  ; not found
    ;text "マップをつくります。"
    text "EDIT MAPS。"
    done

    section_end $571a
.play_description:  ; not found
    ;text "エディットしたマップや"
    ;line "ダウンロードしたマップを"
    ;line "あそびます。"
    text "PLAY EDITED OR"
    line "DOWNLOADED MAPS。"
    done

    section_end $573a
.copy_description:  ; not found
    ;text "マップデータをコピーします。"
    text "COPY MAP DATA。"
    done

    section_end $5749
.erase_description:  ; not found
    ;text "マップデータをさくじょします。"
    text "ERASE MAP DATA。"
    done

    section_end $5759
.IR_get_description:  ; not found
    ;text "IRつうしんで"
	;line "マップデータをあげたり"
	;line "もらったりできます。"
    text "IRつうしんで"
    line "マップデータをあげたり"
    line "もらったりできます。"
    done

    section_end $5778
.IR_send_description:  ; not found
    text "IRつうしんをつかって"
	line "じぶんがつくったマップデータを"
	line "あいてにあげます。"
    done

    section_end $579e
.IR_unknown:  ; not found
    text "IRつうしんをつかって"
	line "マップデータを"
	line "あいてからもらいます。"
    done

.no_map_data:
    ;text "マップデータがありません。"
    text "NO MAP DATA。"
    done

    section_end $57cc

