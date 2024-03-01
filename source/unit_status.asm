include "include/macros.inc"
include "include/char_main.inc"
include "include/char_unit.inc"

setcharmap main
section "Unit_Status_Types", romx[$5e49], bank[$25]
    ;text "そうこうユニット "
    text "ARMORED  "
    done
    ;text "ひそうこうユニット"
    text "UNARMORED"
    done
    ;text "そらユニット   "
    text "AIR      "
    done
    ;text "うみユニット   "
    text "NAVAL    "
    done
    ;text "せんすいかん   "
    text "SUB      "
    done

section "Unit_Status_Header", romx[$60d8], bank[$25]
    ;text "ユニットについての くわしい"
    ;line "じょうほうを みることができます。"
    text "VIEW DETAILED UNIT"
    line "INFORMATION。 "
    done

section "Unit_Status_Strings", romx[$6349], bank[$25]
    ;text "いどうりょく    /"
    text "MOVE      /"
    done
    ;text "さいだいねんりょう /"
    text "MAX GAS   /"
    done
    text "イニシアティブ"
    ;text "INITIATIVE"
    done
    ;coord_text 2, 13, "とうさい"
    coord_text 2, 13, "LOAD"
    ;coord_text 2, 14, "しんか" ; Promotion
    coord_text 2, 14, "PRM"
    ;text "ぼうぎょりょく"
    text "DEFENSE"
    done
    coord_text 2, 16, "ほきゅう•ほじゅう"
    ;coord_text 2, 16, "RESUPPLY•REPAIR"

section "Unit_Status_None", romx[$66fe], bank[$25]
    text "なし"
    ;text "NONE"
    done
    ;text "ふかのう " ; Need to find pointer for this string so it can be shifted forward two bytes
    text "N/A  "
    done

section "25:6ad2", romx[$6ad0], bank[$25] ; Unit Creation
    ;coord_text 1, 3, "せいさんしょうひしきん"
    coord_text 1, 3, "GOLD COST  "
    ;coord_text 1, 4, "せいさんしょうひしざい"
    coord_text 1, 4, "MTL COST   "
