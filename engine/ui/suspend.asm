include "macros/macros.inc"
include "charmaps/char_main.inc"

setcharmap main
; The saved-session value coordinates are instruction operands inside
; SuspendResume_DrawSavedSessionPreview in suspend_saved_session_preview.asm.

section "Suspend_Mode_Strings", romx[$5fc3], bank[$15]
Suspend_Mode_Strings::
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

section "Suspend Menu Labels", romx[$6025], bank[$15]
SuspendMenu_DrawLabels::
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
    assert @ <= $6058, "Suspend menu label code overlaps suspend menu strings"

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
