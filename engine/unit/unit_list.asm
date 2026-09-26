include "macros/macros.inc"
include "charmaps/char_main.inc"

setcharmap main
section "UnitList_Badges", romx[$6c70], bank[$18]
UnitList_Badges:
    ;text "こ"
    text "B"
    done

assert @ <= $70cd

section "UnitList_Delete_Prompt", romx[$70cd], bank[$18]
UnitList_Delete_Prompt::
    coord_text 6, 7, "しょぶんしますか?"

assert @ == $70d9

section "UnitList_Promoted", romx[$7343], bank[$18]
UnitList_Promoted::
    ; Unit String...
    text "が"
    done
    ; ...Promotion String...
    text "に しんかした!"

assert @ == $734d

section "UnitList_Filter", romx[$7a74], bank[$18]
UnitList_Filter:
    ; Filter types for the unit list submenu
    coord_text 4,  5, "ユニットのしゅるい"
    coord_text 4,  6, "レベル"
    coord_text 4,  7, "ねんりょう"
    coord_text 4,  8, "ユニットすう"
    coord_text 4,  9, "みはいちユニット"
    coord_text 4, 10, "みこうどうユニット"

    ; Unit Ranks displayed in the Unit list submenu.
    text "D"
    done

    text "C"
    done

    text "B"
    done

    text "A"
    done

    text "S"
    done

assert @ == $7ab8

section "UnitList_Count", romx[$7f5c], bank[$18]
UnitList_Count::
    coord_text 16, 1, "/50"

assert @ == $7f62

