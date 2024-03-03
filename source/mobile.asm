include "include/macros.inc"
include "include/char_main.inc"

setcharmap main
section "NetworkMenu_Messages", romx[$524c], bank[$19]
NetworkMenu_code524c:
    ld hl, service_settings_changed
    call CoordTextPut
    lb bc, 2, 7
    ld hl, service_settings
    call $2b38
    ret

NetworkMenu_code525c:
    lb bc, 2, 2
    ld hl, service_stopped
    call $2b38
    lb bc, 2, 7
    ld hl, service_stop_prompt
    call $2b38
    ret

NetworkMenu_code526f:
    lb bc, 2, 2
    ld hl, service_resumed
    call $2b38
    lb bc, 2, 7
    ld hl, service_resume_prompt
    call $2b38
    ret

service_settings_changed::
    coord_text 2, 2, "せつぞくせっていへんこう"

service_settings::
    text "ウォーズネットセンターに"
    line "せつぞくするためのせっていを"
    line "へんこうします。"
    done

service_stopped::
    text "ウォーズネットサービスの"
    line "ていし"
    done

service_stop_prompt::
    text "ウォーズネットサービスを"
    line "ていししますか?"
    done

service_resumed::
    text "ウォーズネットサービスの"
    line "さいかい"
    done

service_resume_prompt::
    text "ウォーズネットサービスを"
    line "さいかいしますか?"
    done

section "NetworkMenu_Main", romx[$55c3], bank[$19]
    ;coord_text 3, 6, "メッセージをよむ"
    coord_text 3, 6, "MESSAGES" ; READ MESSAGES
    ;coord_text 3, 7, "マップデータをダウンロード"
    coord_text 3, 7, "DOWNLOAD MAPS"
    ;coord_text 3, 8, "センターにアクセス"
    coord_text 3, 8, "ACCESS CENTER"

section "NetworkMenu_Registration", romx[$567a], bank[$19]
    text "ユーザーとうろくが"
    line "かんりょうしていないので"
    line "このサービスはりようできません。"
    done

section "Mobile_Header_Strings", romx[$43cd], bank[$32]
Mobile_Header_Strings:
    dw .wars_net_dialing
    dw .wars_net_connecting
    dw .map_downloading
    dw .map_uploading
    dw .map_deleting
    dw .map_submitted
    dw .map_downloaded
    dw .user_registration
    dw .user_registration_changes
    dw .map_download_accepting
    dw .map_upload_accepting
    dw .map_delete_request
    dw .map_contributions
    dw .service_unavailable
    dw .service_restored
    dw .connection_lost
    dw .interrupted_1 ; Map
    dw .interrupted_2 ; Wars Net
    dw .mercenary_called
    dw .interrupted_3 ; Mercenary
    dw .wars_net_unavailable
    dw .wars_net_restored
    dw .wars_net_connection_lost
    dw .wars_net_disconnected
    dw .timeout
    dw $00ff ; seemingly unused byte

.wars_net_dialing:
    text "ウォーズネットへ   "
    line "ダイヤルちゅう    "
    done

.wars_net_connecting:
    text "ウォーズネットへ   "
    line "せつぞくちゅう    "
    done

.map_downloading:
    text "マップデータの    "
    line "ダウンロードちゅう  "
    done

.map_uploading:
    text "マップデータの    "
    line "アップロードちゅう  "
    done

.map_deleting:
    text "マップデータの    "
    line "さくじょちゅう    "
    done

.map_submitted:
    text "マップデータの    "
    line "とうこうちゅう    "
    done

.map_downloaded:
    text "マップダウンロード  "
    line "しゅうりょう     "
    done

.user_registration:
    text "ユーザーとうろく   "
    line "うけつけちゅう    "
    done

.user_registration_changes:
    text "ユーザーとうろく   "
    line "へんこううけつけちゅう"
    done

.map_download_accepting:
    text "マップダウンロード  "
    line "うけつけちゅう    "
    done

.map_upload_accepting:
    text "マップアップロード  "
    line "うけつけちゅう    "
    done

.map_delete_request:
    text "マップデリート    "
    line "うけつけちゅう    "
    done

.map_contributions:
    text "マップとうこう    "
    line "うけつけちゅう    "
    done

.service_unavailable:
    text "サービスていし    "
    line "うけつけちゅう    "
    done

.service_restored:
    text "サービスさいかい   "
    line "うけつけちゅう    "
    done

.connection_lost:
    text "つうしんしっぱい   "
    line "           "
    done

.interrupted_1: ; Map
    text "ちゅうし       "
    line "           "
    done

.interrupted_2: ; Wars Net
    text "ちゅうし       "
    line "           "
    done

.mercenary_called:
    text "ようへいよびだし   "
    line "しゅうりょう     "
    done

.interrupted_3: ; Mercenary
    text "ちゅうし       "
    line "           "
    done

.wars_net_unavailable:
    text "ウォーズネットサービス"
    line "ていし        "
    done

.wars_net_restored:
    text "ウォーズネットサービス"
    line "さいかい       "
    done

.wars_net_connection_lost:
    text "ウォーズネット    "
    line "せつぞくしゅうりょう "
    done

.wars_net_disconnected:
    text "ウォーズネット    "
    line "せつだんちゅう    "
    done

.timeout:
    text "タイムアウト     "
    line "           "
    done

section "Mobile_Description_Strings", romx[$4689], bank[$32]
Mobile_Description_Strings:
    dw .map_downloading
    dw .map_downloaded
    dw .map_accepted
    dw .wars_net_connecting
    dw .map_uploading
    dw .map_deleting
    dw .map_updating
    dw .please_wait_1
    dw .user_registration
    dw .map_upload_accepting
    dw .map_delete_request
    dw .map_contributions
    dw .wars_net_interrupted
    dw .map_interrupted
    dw .service_interrupted
    dw .mercenary_called
    dw .mercenary_interrupted
    dw .please_wait_2
    dw .wars_net_unavailable
    dw .wars_net_restored
    dw .connection_ended
    dw .connection_lost
    dw .map_incorrect_number
    dw .connection_timeout
    dw $00ff ; seemingly unused byte

.map_downloading:
    text"<NO/    >"
    line "マップデータを"
    line "ダウンロードしています。"
    line "しばらくおまちください。"
    line "ちゅうししたいときは"
    line "Bボタンを おしてください。"
    done

.map_downloaded:
    text "<NO/    >"
    line "マップデータのダウンロードが"
    line "かんりょうしました。"
    skip 5
    line "   Aボタンをおしてください。"
    done

.map_accepted:
    text "<NO/       >"
    line "マップデータのダウンロードを"
    line "うけつけました。"
    line "ウォーズネットセンターに"
    line "アクセスしてマップデータを"
    line "うけとってください。"
    skip 2
    line "   Aボタンをおしてください。"
    done

.wars_net_connecting:
    text "ウォーズネットへ"
    line "せつぞくしています。"
    line "しばらくおまちください。"
    line "ちゅうししたいときは"
    line "Bボタンを おしてください。"
    done

.map_uploading:
    text "<        >"
    line "マップデータを"
    line "アップロードしています。"
    line "しばらくおまちください。"
    line "ちゅうししたいときは"
    line "Bボタンを おしてください。"
    done

.map_deleting:
    text "<NO/       >"
    line "マップデータを"
    line "さくじょしています。"
    line "しばらくおまちください。"
    line "ちゅうししたいときは"
    line "Bボタンを おしてください。"
    done

.map_updating:
    text "<NO/       >"
    line "マップデータを"
    line "とうこうしています。"
    line "しばらくおまちください。"
    line "ちゅうししたいときは"
    line "Bボタンを おしてください。"
    done

.please_wait_1:
    text "しばらくおまちください。"
    line "ちゅうししたいときは"
    line "Bボタンをおしてください。"
    done

.user_registration:
    text "ウォーズネットへの"
    line "ユーザーとうろくを"
    line "うけつけています。"
    line "ウォーズネットセンターに"
    line "アクセスしてユーザーとうろくの"
    line "かんりょうメッセージを"
    line "うけとってください。"
    skip 1
    line "   Aボタンをおしてください。"
    done

.map_upload_accepting:
    text "<        >"
    line "マップデータのアップロードを"
    line "うけつけています。"
    line "ウォーズネットセンターに"
    line "アクセスしてアップロードの"
    line "かんりょうメッセージを"
    line "うけとってください。"
    skip 1
    line "   Aボタンをおしてください。"
    done

.map_delete_request:
    text "<NO/       >"
    line "マップデータのさくじょを"
    line "うけつけています。"
    line "ウォーズネットセンターに"
    line "アクセスして"
    line "さくじょかんりょうの"
    line "メッセージをうけとってください。"
    skip 1
    line "   Aボタンをおしてください。"
    done

.map_contributions:
    text "<NO/       >"
    line "マップとうこうを"
    line "うけつけています。"
    line "ウォーズネットセンターに"
    line "アクセスしてとうこうの"
    line "かんりょうメッセージを"
    line "うけとってください。"
    skip 1
    line "   Aボタンをおしてください。"
    done

.wars_net_interrupted:
    text "げんざい"
    line "ウォーズネットサービスは"
    line "ていしちゅうです。"
    skip 5
    line "   Aボタンをおしてください。"
    done

.map_interrupted:
    text "<NO/       >"
    line "マップデータのダウンロードを"
    line "ちゅうししました。"
    skip 5
    line "   Aボタンをおしてください。"
    done

.service_interrupted:
    text "<            >"
    line "このサービスは"
    line "ちゅうししました。"
    skip 5
    line "   Aボタンをおしてください。"
    done

.mercenary_called:
    text "ようへいよびだしが"
    line "かんりょうしました。"
    skip 6
    line "   Aボタンをおしてください。"
    done

.mercenary_interrupted:
    text "ようへいよびだしを"
    line "ちゅうししました。"
    skip 6
    line "   Aボタンをおしてください。"
    done

.please_wait_2:
    text "しばらくおまちください"
    done

.wars_net_unavailable:
    text "ウォーズネットサービスの"
    line "ていしをうけつけています。"
    line "ウォーズネットセンターに"
    line "アクセスしてサービスていしの"
    line "かんりょうメッセージを"
    line "うけとってください。"
    skip 2
    line "   Aボタンをおしてください。"
    done

.wars_net_restored:
    text "ウォーズネットサービスの"
    line "さいかいをうけつけています。"
    line "ウォーズネットセンターに"
    line "アクセスしてサービスさいかいの"
    line "かんりょうメッセージを"
    line "うけとってください。"
    skip 2
    line "   Aボタンをおしてください。"
    done

.connection_ended:
    text "せつぞくが"
    line "しゅうりょうしました。"
    line "こんかいの"
    line "せつぞくじかんは"
    skip 1
    line "  ふん  びょうでした。"
    skip 2
    line "   Aボタンをおしてください。"
    done

.connection_lost:
    text "かいせんを"
    line "せつだんしています。"
    line "しばらくおまちください。"
    done

.map_incorrect_number:
    text "<NO/    >"
    line "このばんごうの"
    line "マップデータはありません。"
    line "マップばんごうを"
    line "にゅうりょくしなおしてください。"
    skip 3
    line "   Aボタンをおしてください。"
    done

.connection_timeout:
    text "タイムアウトです。"
    line "つうしんをせつだんしましたので"
    line "もういちど"
    line "やりなおしてください。"
    skip 4
    line "   Aボタンをおしてください。"
    done
