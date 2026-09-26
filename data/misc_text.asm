; Miscellaneous fixed-placement translated text patches.
; Split from main.asm in ; bytes and ROM locations are unchanged.

include "macros/macros.inc"
include "charmaps/char_main.inc"
include "charmaps/char_news.inc"

setcharmap main
section "Unk_End_Game_Message", romx[$658a], bank[$15] ; Near Rank up messages?
    text "ゲームを しゅうりょうしますか?"
    done

setcharmap news
section "Mobile_Mail_Header", romx[$792c], bank[$19]
Mobile_Mail_Header::
    ;coord_text 2, 1, "メッセージサービス"
    coord_text 2, 1, "MESSAGES "
    assert @ == $7938

setcharmap main
section "Campaign_Menu_Wins", romx[$48a0], bank[$25]
    ;text "しょうりかいすう   /"
    text "WINS       /"
    done

section "Battle_Status", romx[$65a0], bank[$27]
    ;text "ユニット"
    text "UNIT"
    done
    ;text "せいさんユニット"
    text "DEPLOYED"
    done
    ;text "ぜんめつユニット"
    text "LOST    "
    done

section "File_Menu_Strings", romx[$6c2e], bank[$27]
File_Menu_Strings::
    ;coord_text 1, 3, "どこにセーブしますか?      "
    coord_text 1, 3, "SAVE WHERE?      "

    ;coord_text 1, 3, "ビギナーモードをあそびますか?  "
    coord_text 1, 3, "PLAY BEGINNER?   "

    ;coord_text 1, 3, "キャンペーンモードをあそびますか?"
    coord_text 1, 3, "PLAY CAMPAIGN?   "

    ;coord_text 1, 3, "スタンダードモードをあそびますか?"
    coord_text 1, 3, "PLAY STANDARD?"

section "Unk_Save_Confirmation", romx[$6ca8], bank[$27]
Unk_Save_Confirmation::
    ;coord_text 6, 4, "セーブしました"
    coord_text 6, 4, "SAVED。 "

