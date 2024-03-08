include "include/macros.inc"
include "include/bank_ends.inc"
include "include/char_main.inc"

setcharmap main
section "BattleInfo_Strings", romx[$4d9f], bank[$0c]
BattleInfo_Strings:
    dw .attackOrder
    dw .attackPower
    dw .defensePower
    dw .terrainDefense
    dw .level
    dw .flanking
    dw BattleInfo_Strings_combined1
    dw BattleInfo_Strings_combinedAttackPower
    dw BattleInfo_Strings_combined2
    dw BattleInfo_Strings_combinedDefensePower

; 9 Character Limit
.attackOrder:
    ;coord_text 1, 5,  "こうげき"
    coord_text 1, 5,  "ORDER"

.attackPower:
    ;coord_text 1, 6,  "こうげきりょく"
    coord_text 1, 6,  "ATTACK"

.defensePower:
    ;coord_text 1, 7,  "ぼうぎょりょく"
    coord_text 1, 7,  "DEFENSE"

.terrainDefense:
    ;coord_text 1, 8,  "ちけいこうか"
    coord_text 1, 8,  "TERRAIN"

.level:
    ;coord_text 1, 9,  "けいけんち"
    coord_text 1, 9,  "LEVEL"

.flanking:
    ;coord_text 1, 10, "ほういこうか"
    coord_text 1, 10, "FLANKING"

    section_end $4e0a

section fragment "BattleInfo_Strings_Fragment", romx[bank0c_end_addrB], bank[$0c]
BattleInfo_Strings_combined1:
    ;coord_text 1, 12, "そうごう"
    coord_text 1, 12, "TOTAL"

BattleInfo_Strings_combinedAttackPower:
    ;coord_text 2, 13, "こうげきりょく"
    coord_text 2, 13, "ATTACK"

BattleInfo_Strings_combined2:
    ;coord_text 1, 14, "そうごう"
    coord_text 1, 14, "TOTAL"

BattleInfo_Strings_combinedDefensePower:
    ;coord_text 2, 15, "ぼうぎょりょく"
    coord_text 2, 15, "DEFENSE"

section "BattleInfo_Order_Strings", romx[$4e0a], bank[$0c]
BattleInfo_Order_Strings:
    dw .invalid
    dw .same
    dw .first
    dw .second

; 4 Character Limit
.first:
    ;text "せんこう"
    text " 1ST"
    done

.second:
    ;text "こうこう"
    text " 2ND"
    done

.same:
    ;text " どうじ"
    text "SAME"
    done

.invalid:
    text "  ーー"
    done