include "macros/macros.inc"
include "charmaps/char_main.inc"

setcharmap main
section "NetworkMenu_Messages", romx[$524c], bank[$19]
NetworkMenu_ServiceSettings:
    ld hl, NetworkMenu_ServiceSettingsChangedText
    call CoordTextPut
    lb bc, 2, 7
    ld hl, NetworkMenu_ServiceSettingsText
    call TextPrint
    ret

NetworkMenu_ServiceStop:
    lb bc, 2, 2
    ld hl, NetworkMenu_ServiceStoppedText
    call TextPrint
    lb bc, 2, 7
    ld hl, NetworkMenu_ServiceStopPromptText
    call TextPrint
    ret

NetworkMenu_ServiceResume:
    lb bc, 2, 2
    ld hl, NetworkMenu_ServiceResumedText
    call TextPrint
    lb bc, 2, 7
    ld hl, NetworkMenu_ServiceResumePromptText
    call TextPrint
    ret

NetworkMenu_ServiceSettingsChangedText:
    coord_text 2, 2, "せつぞくせっていへんこう"

NetworkMenu_ServiceSettingsText:
    text "ウォーズネットセンターに"
    line "せつぞくするためのせっていを"
    line "へんこうします。"
    done

NetworkMenu_ServiceStoppedText:
    text "ウォーズネットサービスの"
    line "ていし"
    done

NetworkMenu_ServiceStopPromptText:
    text "ウォーズネットサービスを"
    line "ていししますか?"
    done

NetworkMenu_ServiceResumedText:
    text "ウォーズネットサービスの"
    line "さいかい"
    done

NetworkMenu_ServiceResumePromptText:
    text "ウォーズネットサービスを"
    line "さいかいしますか?"
    done

    section_end $5306

section "NetworkMenu_Main", romx[$55c3], bank[$19]
    ;coord_text 3, 6, "メッセージをよむ"
    coord_text 3, 6, "MESSAGES" ; READ MESSAGES
    ;coord_text 3, 7, "マップデータをダウンロード"
    coord_text 3, 7, "DOWNLOAD MAPS"
    ;coord_text 3, 8, "センターにアクセス"
    coord_text 3, 8, "ACCESS CENTER"
    assert @ <= $567a, "Network main-menu strings overlap registration message"

section "NetworkMenu_Registration", romx[$567a], bank[$19]
    text "ユーザーとうろくが"
    line "かんりょうしていないので"
    line "このサービスはりようできません。"
    done

