include "macros/macros.inc"
include "charmaps/char_main.inc"

setcharmap main
section "Versus_Menu_Type_Header", romx[$5e5b], bank[$18]
Versus_Menu_Type_Header:
    ;text "たいせん ほうほう"
    text " VS STYLE"
    done

    assert @ <= $6031, "Versus type header overlaps country select"
section "Versus_Menu_Country_Select", romx[$6031], bank[$18]
Versus_Menu_Country_Select:
    coord_text 8, 6, "レッドスター"
    coord_text 8, 9, "ホワイトムーン"

    assert @ <= $6075, "Versus country select overlaps country message"
section "Versus_Menu_Country_Same", romx[$6075], bank[$18]
Versus_Menu_Country_Same:
    text "レッドスターでたたかいます。"
    line "たいせんあいてとちがうぐんを"
    line "えらんでください。"
    done

    text "ホワイトムーンでたたかいます。"
    line "たいせんあいてとちがうぐんを"
    line "えらんでください。"
    done

    assert @ == $60c6, "Versus country message boundary moved"
section "Versus_Menu_Map_Type_Description", romx[$6504], bank[$18]
Versus_Menu_Map_Type_Description::
    text "スタンダードモードの"
    line "マップをえらんで"
    line "たいせんします。"
    done

Versus_Menu_Map_Type_Description_Edit::
    text "エディットしたマップや"
    line "ダウンロードしたマップを"
    line "えらんでたいせんします。"
    done

    assert @ == $6547, "Versus map type description boundary moved"
section "Versus_Menu_Map_Type", romx[$65cc], bank[$18]
Versus_Menu_Map_Type::
    coord_text 5, 5, "スタンダードモード"
    ;coord_text 5, 5, "STANDARD "

Versus_Menu_Map_Type_Edit::
    coord_text 5, 8, "エディット"
    ;coord_text 5, 8, "EDIT "

    assert @ == $65e0, "Versus map type menu boundary moved"

section "Versus_Menu_Type_Description", romx[$6b1a], bank[$27]
Versus_Menu_Type_Description::
    text "ゲームボーイをてわたしして"
    line "たいせんします。"
    done

Versus_Menu_Type_Description_Infrared::
    text "IRつうしんをつかって"
    line "たいせんします。"
    done
