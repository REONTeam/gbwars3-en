include "include/macros.inc"
include "include/char_main.inc"

section "MapMenu_code4213", romx[$4213], bank[$13]
    ld hl, MapMenu_Strings.edit
    call $336e
    ld hl, MapMenu_Strings.play
    call $336e
    ld hl, MapMenu_Strings.copy
    call $336e
    ld hl, MapMenu_Strings.delete
    call $336e
    ld hl, MapMenu_Strings.map_communication
    call $336e

section "MapMenu_Menu_Alternate_code43e3", romx[$43e3], bank[$13]
MapMenu_Menu_Alternate_code43e3:
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
.get:
    ld hl, MapMenu_Strings.IR_get_where
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
    call $336e

section "MapMenu_Display_Data_code4638", romx[$4638], bank[$13]
MapMenu_Display_Data_code4638:
    cp $00
    jr z, .no_map
    ld hl, $ca6a
    ld bc, $020d
    call $3353
    ld hl, MapMenu_Strings.map_number
    call $336e
    ld hl, $dc44
    ld bc, $080e
    call $3353
    jr ._465f
.no_map:
    ld hl, MapMenu_Strings.no_map_data
    ld bc, $020d
    call $3353
._465f:
    call $059b
    ret

section "MapMenu_code46af", romx[$46af], bank[$13]
    ld hl, MapMenu_Strings.map_number
    call $336e

section "MapMenu_code46ff", romx[$46ff], bank[$13]
    ld hl, MapMenu_Strings.no_map_data
    ld bc, $020d
    call $3353

section "MapMenu_code4a75", romx[$4a75], bank[$13]
    ld hl, MapMenu_Strings.main_menu
    ld bc, $0302
    call $2b38

section "MapMenu_Menu", romx[$4b49], bank[$13]
MapMenu_Menu:
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
.get:
    ld hl, MapMenu_Strings.IR_get_where
    jr .select_map
.select_map:
    call $336e
    ret

section "MapMenu_code4d4f", romx[$4d4f], bank[$13]
    ld hl, MapMenu_Strings.copy_where
    call $336e

section "MapMenu_code51f3", romx[$51f3], bank[$13]
    ld hl, MapMenu_Strings.copy_where
    call $336e

section "MapMenu_Confirm_Prompt_code532b", romx[$532b], bank[$13]
MapMenu_Confirm_Prompt_code532b:
    cp $00
    jr nz, .copy
    ld hl, MapMenu_Strings.delete_prompt
    call $336e
    jr .end
.copy:
    ld hl, MapMenu_Strings.copy_prompt_overwrite
    call $336e
.end:
    ld bc, $070f
    call $53d7

section "MapMenu_Suspend", romx[$5400], bank[$13]
MapMenu_Suspend:
    call $04f3
    call $34ce
    call $2d7c
    xor a
    ldh [$95], a
    ldh [$96], a
    rst $28
    db $10, $a8, $68
    rst $28
    db $01, $00, $40
    call $0618
    call $0f02
    ld a, $00
    ldh [$83], a
    ldh [$4f], a
    ld a, $00
    rst $28
    db $15, $91, $66
    ld bc, $0101
    ld de, $1205
    rst $28
    db $22, $47, $62
    ld bc, $0106
    ld de, $120b
    rst $28
    db $22, $47, $62
    ld hl, MapMenu_Strings.suspend_continue_1
    call $336e
    ld hl, MapMenu_Strings.suspend_continue_2
    call $336e
    ld bc, $070b
    call $53ae
    xor a
    ld [$dc4f], a
    ld hl, MapMenu_Strings.suspend_map_label
    call $336e
    ld a, [$c633]
    srl a
    inc a
    ld bc, $0203
    ld d, $02
    call $31f5
    ld hl, MapMenu_Strings.suspend_day_count
    call $336e
    ld a, [$ca1f]
    inc a
    ld bc, $0602
    ld d, $02
    call $3237
    ld de, $ca41
    ld hl, $dc3b
    ld bc, $0008
    call $3b50
    ld hl, $dc3b
    ld bc, $0902
    call $3353
    ld hl, MapMenu_Strings.suspend_warning_1
    call $336e
    ld hl, MapMenu_Strings.suspend_warning_2
    call $336e
    ld hl, MapMenu_Strings.suspend_warning_3
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
    ld hl, MapMenu_Strings.IR_battle
    call $336e
    ret

._54b9:
    ld hl, MapMenu_Strings.battle
    call $336e
    ret

section "MapMenu_Strings", romx[$5541], bank[$13]
MapMenu_Strings:

.edit:
    ;db 7, 5, "エディット", 0
    db 7, 5, "EDIT", 0

.play:
    db 7, 6, "プレイ", 0
    ;db 7, 6, "PLAY", 0

.copy:
    db 7, 7, "コピー", 0
    ;db 7, 7, "COPY", 0

.delete:
    db 7, 8, "デリート", 0
    ;db 7, 8, "ERASE", 0

.map_communication:
    db 7, 9, "マップつうしん", 0
    ;db 7, 9, "MAP COMM", 0

.edit_which:
    ;db 2, 2, "どのデータをエディットしますか?", 0
    db 2, 2, "EDIT WHICH DATA?", 0

.play_which:
    db 2, 2, "どのデータをプレイしますか?", 0
    ;db 2, 2, "PLAY WHICH DATA?", 0

.copy_which:
    db 2, 2, "どのデータをコピーしますか?", 0
    ;db 2, 2, "COPY WHICH DATA?", 0

.delete_which:
    db 2, 2, "どのデータをさくじょしますか?", 0
    ;db 2, 2, "ERASE WHICH DATA?", 0

.IR_send_which:
    db 2, 2, "どのデータをあげますか?", 0
    ;db 2, 2, "SEND WHICH DATA?", 0

.IR_get_where:
    db 2, 2, "どこにデータをもらいますか?", 0
    ;db 2, 2, "GET DATA WHERE?", 0

.upload_where:
    db 2, 2, "どこにアップロードしますか?", 0
    ;db 2, 2, "UPLOAD DATA WHERE?", 0

.delete_what:
    db 2, 2, "どれをさくじょしますか?", 0
    ;db 2, 2, "DELETE WHAT DATA?", 0

.submit_what:
    db 2, 2, "どれをとうこうしますか?", 0
    ;db 2, 2, "SUBMIT WHAT DATA?", 0

.upload_which:
    db 2, 2, "どのデータをアップしますか?", 0
    ;db 2, 2, "UPLOAD WHICH DATA?", 0

.save_where: ; Which map to save over when downloading on mobile
    db 2, 2, "どこにデータをセーブしますか?", 0
    ;db 2, 2, "SAVE DATA WHERE?", 0

    section_end $561f
.current_map_download:  ; not found
    ;db 3, 13, "げんざいマップダウンロードの", 0
    db 3, 13, "げんざいマップダウンロードの", 0

    section_end $5630
.current_map_upload:  ; not found
    ;db 3, 13, "げんざいマップアップロードの", 0
    db 3, 13, "げんざいマップアップロードの", 0

    section_end $5641
.requesting:  ; not found
    ;db 3, 14, "リクエストちゅうです", 0
    db 3, 14, "REQUESTING", 0

.map_number:
    db 2, 14, "マップNO/", 0
    ;db 2, 14, "MAP NO/", 0 ; Need to find the coordinate for the number after it to shift it as well

.main_menu:
    ;db "エディット コピー   あげる", 1
    ;DB "プレイ   デリート  もらう", 0
    db "EDIT COPY  SEND", 1
    db "PLAY ERASE GET ", 0

.copy_where:
    db 2, 2, "どこにコピーしますか?", 0

    section_end $5685
.this_data:  ; not found
    db 3, 13, "このデータを", 0

.delete_prompt:
    db 3, 13, "さくじょしますか?", 0

.copy_prompt_overwrite:
    db 3, 13, "うわがきしますか?", 0

    section_end $56a6
.ok_prompt:  ; not found
    db 3, 14, "OK?", 0

.suspend_continue_1:
    db 3, 7, "ぜんかいのセーブデータの", 0

.suspend_continue_2:
    db 3, 8, "つづきからプレイしますか?", 0

.suspend_map_label:
    db 2, 2, "MAP:", 0

.suspend_warning_1:
    ;db 7, 13, "ちゅうい", 0
    db 7, 11, "WARNING", 0

.suspend_warning_2:
    ;db 6, 14, "NOをえらぶと", 0
    db 6, 14, "NOをえらぶと", 0

.suspend_warning_3:
    ;db 4, 15, "セーブデータはきえます。", 0
    db 4, 15, "セーブデータはきえます。", 0

.suspend_day_count:
    db 4, 3, "にちめ", 0

.IR_battle: ; May be used for suspending an IR battle on a custom map?
    db 2, 4, "IRつうしんたいせん", 0
    ;db 2, 4, "IR COMM BATTLE", 0

.battle:
    db 2, 4, "たいせん", 0
    ;db 2, 4, "BATTLE", 0

    section_end $570f
.edit_description:  ; not found
    ;db "マップをつくります。", 0
    db "EDIT MAPS。", 0

    section_end $571a
.play_description:  ; not found
    ;db "エディットしたマップや[LF]ダウンロードしたマップを[LF]あそびます。", 0
    db "PLAY EDITED OR[LF]DOWNLOADED MAPS。", 0

    section_end $573a
.copy_description:  ; not found
    ;db "マップデータをコピーします。", 0
    db "COPY MAP DATA。", 0

    section_end $5749
.erase_description:  ; not found
    ;db "マップデータをさくじょします。", 0
    db "ERASE MAP DATA。", 0

    section_end $5759
.IR_get_description:  ; not found
    ;db "IRつうしんで[LF]マップデータをあげたり[LF]もらったりできます。", 0
    db "IRつうしんで[LF]マップデータをあげたり[LF]もらったりできます。", 0

    section_end $5778
.IR_send_description:  ; not found
    db "IRつうしんをつかって[LF]じぶんがつくったマップデータを[LF]あいてにあげます。", 0

    section_end $579e
.IR_unknown:  ; not found
    db "IRつうしんをつかって[LF]マップデータを[LF]あいてからもらいます。", 0

.no_map_data:
    ;db "マップデータがありません。", 0
    db "NO MAP DATA。", 0

    section_end $57cc

