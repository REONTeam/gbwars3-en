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

section "15:602c", romx[$602c], bank[$15] ; Pointer for "Mode_String", shifted one byte earlier into freed up space from "CO_String"
;db $6160
db $6060

; Suspend Menu Strings
section "CO_String", romx[$6058], bank[$15] ; Pointer at [$6026]
    ;coord_text 2, 2, "しれいかん:"
    coord_text 2, 2, "CO:"

section "Mode_String", romx[$6060], bank[$15] ; Pointer at [$602c] (section formerly started at $6061)
    ;coord_text 2, 3, "モード:"
    coord_text 2, 3, "MODE:" ; MODE

section "Map_String", romx[$6068], bank[$15] ; Pointer at [$6032]
    ;coord_text 2, 4, "マップ:"
    coord_text 2, 4, "MAP:"

section "Day_String", romx[$606f], bank[$15] ; Pointer at [$6038]
    ;coord_text 4, 5, "にちめ"
    coord_text 2, 5, "DAY"

section "Continue_String_1", romx[$6075], bank[$15] ; Pointer at [$603e]
    ;coord_text 3, 9, "とちゅうのデータがあります。"
    coord_text 3, 9, "CONTINUE FROM "

section "Continue_String_2", romx[$6086], bank[$15] ; Pointer at [$6044]
    ;coord_text 3, 10, "つづきからプレイしますか?"
    coord_text 3, 10, "LAST SESSION?"
