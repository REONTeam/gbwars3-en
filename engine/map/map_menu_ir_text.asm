include "macros/macros.inc"
include "charmaps/char_main.inc"

section "Map Menu IR Transfer Text", romx[$632f], bank[$18]
MapMenu_IRSendLabel::
    coord_text 6, 5, "マップをあげる" ; "Send map"; pointer use not yet located.

MapMenu_IRReceiveLabel::
    coord_text 6, 8, "マップをもらう" ; "Receive map"; pointer use not yet located.

    ; Duplicate of the send/receive descriptions in the main map-menu text block.
MapMenu_IRSendDescription::
    text "IRつうしんをつかって"
    line "じぶんがつくったマップデータを"
    line "あいてにあげます。"
    done

MapMenu_IRReceiveDescription::
    text "IRつうしんをつかって"
    line "マップデータを"
    line "あいてからもらいます。"
    done
