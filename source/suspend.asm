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
    ;db "ビギナーモード", 0
    db "BEGINNER", 0

.campaign:
    ;db "キャンペーンモード", 0
    db "CAMPAIGN ", 0

.standard:
    ;db "スタンダードモード"
    db "STANDARD ", 0

section "15:602c", romx[$602c], bank[$15]
db $61
;db $60

; Suspend Menu Strings
section "CO_String", romx[$6058], bank[$15]
    ;db 2, 2, "しれいかん:", 0
    db 2, 2, "CO:", 0

section "Mode_String", romx[$6061], bank[$15]
    ;db 2, 3, "モード:", 0
    db 2, 3, "MOD:", 0

section "Map_String", romx[$6068], bank[$15]
    ;db 2, 4, "マップ:", 0
    db 2, 4, "MAP:", 0

section "Day_String", romx[$606f], bank[$15]
    ;db 4, 5, "にちめ", 0
    db 2, 5, "DAY", 0

section "Continue_String_1", romx[$6075], bank[$15]
    ;db 3, 9, "とちゅうのデータがあります。", 0
    db 3, 9, "CONTINUE FROM ", 0

section "Continue_String_2", romx[$6086], bank[$15]
    ;db 3, 10, "つづきからプレイしますか?", 0
    db 3, 10, "LAST SESSION?", 0
