include "include/macros.inc"
include "include/char_main.inc"

setcharmap main
section "Versus_Menu_Type_Header", romx[$5e5b], bank[$18]
    ;text "たいせん ほうほう"
    text " VS STYLE"
    done

section "Versus_Menu_Country_Select", romx[$6031], bank[$18]
    coord_text 8, 6, "レッドスター"
    coord_text 8, 9, "ホワイトムーン"

section "Versus_Menu_Country_Same", romx[$6075], bank[$18]
    text "レッドスターでたたかいます。"
    line "たいせんあいてとちがうぐんを"
    line "えらんでください。"
    done

    text "ホワイトムーンでたたかいます。"
    line "たいせんあいてとちがうぐんを"
    line "えらんでください。"
    done

section "Versus_Menu_Map_Type_Description", romx[$6504], bank[$18]
    text "スタンダードモードの"
    line "マップをえらんで"
    line "たいせんします。"
    done

    text "エディットしたマップや"
    line "ダウンロードしたマップを"
    line "えらんでたいせんします。"
    done

section "Versus_Menu_Map_Type", romx[$65cc], bank[$18]
    coord_text 5, 5, "スタンダードモード"
    ;coord_text 5, 5, "STANDARD "

    coord_text 5, 8, "エディット"
    ;coord_text 5, 8, "EDIT "

section "Versus_Menu_Type_Description", romx[$6b1a], bank[$27]
    text "ゲームボーイをてわたしして"
    line "たいせんします。"
    done

    text "IRつうしんをつかって"
    line "たいせんします。"
    done
