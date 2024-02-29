include "include/macros.inc"
include "include/char_main.inc"

setcharmap main
; Suspend Menu Coordinates
section "Mode_Coordinates", romx[$5f80], bank[$15]
    ;db 3, 6
    db 3, 7

section "CO_Coordinates", romx[$5f97], bank[$15]
    ;db 2, 8
    db 2, 5

section "Map_Coordinates", romx[$5fa4], bank[$15]
    db 4, 6

section "Day_Coordinates", romx[$5fbb], bank[$15]
    ;db 5, 2
    db 5, 5

section "Suspend_Mode_Strings", romx[$5fc3], bank[$15]
Suspend_Mode_Strings:
    dw .beginner
    dw .campaign
    dw .standard

.beginner:
    ;text "ビギナーモード"
    text "BEGINNER"

.campaign:
    ;text "キャンペーンモード"
    text "CAMPAIGN "

.standard:
    text "スタンダードモード"
    ;text "STANDARD "

    section_end $5fe5

section "15:602c", romx[$602c], bank[$15]
db $61
;db $60

; Suspend Menu Strings
section "CO_String", romx[$6058], bank[$15]
    ;coord_text 2, 2, "しれいかん:"
    coord_text 2, 2, "CO:"
    done

section "Mode_String", romx[$6061], bank[$15]
    ;coord_text 2, 3, "モード:"
    coord_text 2, 3, "MOD:"
    done

section "Map_String", romx[$6068], bank[$15]
    ;coord_text 2, 4, "マップ:"
    coord_text 2, 4, "MAP:"
    done

section "Day_String", romx[$606f], bank[$15]
    ;coord_text 4, 5, "にちめ"
    coord_text 2, 5, "DAY"
    done

section "Continue_String_1", romx[$6075], bank[$15]
    ;coord_text 3, 9, "とちゅうのデータがあります。"
    coord_text 3, 9, "CONTINUE FROM "
    done

section "Continue_String_2", romx[$6086], bank[$15]
    ;coord_text 3, 10, "つづきからプレイしますか?"
    coord_text 3, 10, "LAST SESSION?"
    done
