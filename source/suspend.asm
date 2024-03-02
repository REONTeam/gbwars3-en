include "include/macros.inc"
include "include/char_main.inc"

setcharmap main
; Suspend Menu Coordinates
section "Mode_Coordinates", romx[$5f80], bank[$15]
    ;coord 3, 6
    coord 3, 7

section "CO_Coordinates", romx[$5f97], bank[$15]
    ;coord 2, 8
    coord 2, 5

section "Map_Number_Coordinates", romx[$5fa4], bank[$15]
    coord 4, 6

section "Map_Name_Coordinates", romx[$5faf], bank[$15]
    coord 4, 9

section "Day_Coordinates", romx[$5fbb], bank[$15]
    ;coord 5, 2
    coord 5, 5

section "Suspend_Mode_Strings", romx[$5fc3], bank[$15]
Suspend_Mode_Strings:
    dw .beginner
    dw .campaign
    dw .standard

.beginner:
    ;text "ビギナーモード"
    text "BEGINNER"
    done

.campaign:
    ;text "キャンペーンモード"
    text "CAMPAIGN"
    done

.standard:
    ;text "スタンダードモード"
    text "STANDARD"
    done

    section_end $5fe5

section "SuspendMenu_code6025", romx[$6025], bank[$15]
    ld hl, SuspendMenu_Strings.CO
    call CoordTextPut
    ld hl, SuspendMenu_Strings.Mode
    call CoordTextPut
    ld hl, SuspendMenu_Strings.Map
    call CoordTextPut
    ld hl, SuspendMenu_Strings.Day
    call CoordTextPut
    ld hl, SuspendMenu_Strings.Continue_1
    call CoordTextPut
    ld hl, SuspendMenu_Strings.Continue_2
    call CoordTextPut

section "SuspendMenu_Strings", romx[$6058], bank[$15]
SuspendMenu_Strings:

.CO:
    ;coord_text 2, 2, "しれいかん:"
    coord_text 2, 2, "CO:"

.Mode:
    ;coord_text 2, 3, "モード:"
    coord_text 2, 3, "MODE:"

.Map:
    ;coord_text 2, 4, "マップ:"
    coord_text 2, 4, "MAP:"

.Day:
    ;coord_text 4, 5, "にちめ"
    coord_text 2, 5, "DAY"

.Continue_1:
    ;coord_text 3, 9, "とちゅうのデータがあります。"
    coord_text 3, 9, "CONTINUE FROM " ; OLD DATA EXISTS.

.Continue_2:
    ;coord_text 3, 10, "つづきからプレイしますか?"
    coord_text 3, 10, "LAST SESSION?" ; CONTINUE PLAYING?

    section_end $6096
