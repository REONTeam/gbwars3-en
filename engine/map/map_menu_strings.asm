include "macros/macros.inc"
include "charmaps/char_main.inc"

section "MapMenu_Strings", romx[$5541], bank[$13]
MapMenu_Strings:

.edit::
    ;coord_text 7, 5, "エディット"
    coord_text 7, 5, "EDIT"

.play::
    coord_text 7, 6, "プレイ"
    ;coord_text 7, 6, "PLAY"

.copy::
    coord_text 7, 7, "コピー"
    ;coord_text 7, 7, "COPY"

.delete::
    coord_text 7, 8, "デリート"
    ;coord_text 7, 8, "ERASE"

.map_communication::
    coord_text 7, 9, "マップつうしん"
    ;coord_text 7, 9, "MAP COMM"

.edit_which::
    ;coord_text 2, 2, "どのデータをエディットしますか?"
    coord_text 2, 2, "EDIT WHICH DATA?"

.play_which::
    coord_text 2, 2, "どのデータをプレイしますか?"
    ;coord_text 2, 2, "PLAY WHICH DATA?"

.copy_which::
    coord_text 2, 2, "どのデータをコピーしますか?"
    ;coord_text 2, 2, "COPY WHICH DATA?"

.delete_which::
    coord_text 2, 2, "どのデータをさくじょしますか?"
    ;coord_text 2, 2, "ERASE WHICH DATA?"

.IR_send_which::
    coord_text 2, 2, "どのデータをあげますか?"
    ;coord_text 2, 2, "SEND WHICH DATA?"

.IR_receive_where::
    coord_text 2, 2, "どこにデータをもらいますか?"
    ;coord_text 2, 2, "GET DATA WHERE?"

.upload_where::
    coord_text 2, 2, "どこにアップロードしますか?"
    ;coord_text 2, 2, "UPLOAD DATA WHERE?"

.delete_what::
    coord_text 2, 2, "どれをさくじょしますか?"
    ;coord_text 2, 2, "DELETE WHAT DATA?"

.submit_what::
    coord_text 2, 2, "どれをとうこうしますか?"
    ;coord_text 2, 2, "SUBMIT WHAT DATA?"

.upload_which::
    coord_text 2, 2, "どのデータをアップしますか?"
    ;coord_text 2, 2, "UPLOAD WHICH DATA?"

.save_where:: ; Which map to save over when downloading on mobile
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

.map_number::
    coord_text 2, 14, "マップNO/"
    ;coord_text 2, 14, "MAP NO/"

.main_menu::
    ;text "エディット コピー   あげる"
    ;line "プレイ   デリート  もらう"
    text "EDIT COPY  SEND"
    line "PLAY ERASE GET "
    done

.copy_where::
    coord_text 2, 2, "どこにコピーしますか?"
    ;coord_text 2, 2, "COPY DATA WHERE?"

    section_end $5685
.this_data:  ; not found
    coord_text 3, 13, "このデータを"
    ;coord_text 3, 13, "THIS DATA"

.delete_prompt::
    ;coord_text 3, 13, "さくじょしますか?"
    coord_text 3, 13, "DELETE?"

.copy_prompt_overwrite::
    ;coord_text 3, 13, "うわがきしますか?"
    coord_text 3, 13, "OVERWRITE?"

    section_end $56a6
.ok_prompt:  ; not found
    coord_text 3, 14, "OK?"

.suspend_continue_1::
    coord_text 3, 7, "ぜんかいのセーブデータの"
    ;coord_text 3, 7, "CONTINUE PLAYING"

.suspend_continue_2::
    coord_text 3, 8, "つづきからプレイしますか?"
    ;coord_text 3, 8, "FROM SAVE DATA?"

.suspend_map_label::
    coord_text 2, 2, "MAP:"

.suspend_warning_1::
    ;coord_text 7, 13, "ちゅうい"
    coord_text 6, 13, "WARNING"

.suspend_warning_2::
    coord_text 6, 14, "NOをえらぶと"
    ;coord_text 6, 14, "PICKING NO WILL"

.suspend_warning_3::
    coord_text 4, 15, "セーブデータはきえます。"
    ;coord_text 4, 15, "DELETE THE DATA。"

.suspend_day_count::
    ;coord_text 4, 3, "にちめ"
    coord_text 2, 3, "DAY"

.IR_battle:: ; May be used for suspending an IR battle on a custom map?
    coord_text 2, 4, "IRつうしんたいせん"
    ;coord_text 2, 4, "IR COMM BATTLE"

.battle::
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
.IR_transfer_description:  ; pointer use not yet located
    ;text "IRつうしんで"
	;line "マップデータをあげたり"
	;line "もらったりできます。"
    text "IRつうしんで"
    line "マップデータをあげたり"
    line "もらったりできます。"
    done

    section_end $5778
.IR_send_description:  ; pointer use not yet located
    text "IRつうしんをつかって"
	line "じぶんがつくったマップデータを"
	line "あいてにあげます。"
    done

    section_end $579e
.IR_receive_description:  ; pointer use not yet located
    text "IRつうしんをつかって"
	line "マップデータを"
	line "あいてからもらいます。"
    done

.no_map_data::
    ;text "マップデータがありません。"
    text "NO MAP DATA。"
    done

    section_end $57cc

