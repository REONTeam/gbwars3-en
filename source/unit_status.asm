include "include/macros.inc"
include "include/bank_ends.inc"
include "include/char_unit.inc"
include "include/char_main.inc"

setcharmap unit
section "UnitCreation_Menu", romx[$5a0d], bank[$0b]
UnitCreation_code5a0d:
    ld a, $07
    call $7a9d
    ld a, [$c9ca]
    and a
    jr nz, $5a1d

    ld hl, UnitCreation_Create
    jr $5a20

UnitCreation_code5a1d:
    ld hl, UnitCreation_Call

UnitCreation_code5a20:
    lb bc, 1, 32
    call TextPut
    ld hl, UnitCreation_Gold
    lb bc, 4, 35
    call TextPut
    ld hl, UnitCreation_Material
    lb bc, 12, 35
    call TextPut
    ld hl, UnitCreation_Movement
    lb bc, 1, 37
    call TextPut
    ld hl, UnitCreation_Fuel
    lb bc, 1, 38
    call TextPut
    ld hl, UnitCreation_Separator
    lb bc, 1, 36
    call TextPut
    call $352e
    ret

UnitCreation_Create:
    ;text "どのユニットをせいさんしますか"
    text "BUILD WHICH UNIT?"
    done

UnitCreation_Call:
    ;text "どのユニットをよびますか"
    text "CALL WHICH UNIT?"
    done

UnitCreation_Gold:
    db $b1, "-   00"
    done

UnitCreation_Material:
    db $b2, "-"
    done

UnitCreation_Movement:
    db $af, "  :"
    done

UnitCreation_Fuel:
    db $b0, "  :"
    done

    section_end $5a9c

section fragment "bank0b_end", romx[bank0b_end_addr], bank[$0b]
UnitCreation_Separator:
    text "___________________"
    done

setcharmap main
section "UnitStatus_Types", romx[$5e49], bank[$25]
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
    text "SEA      "
    done
    ;text "せんすいかん   "
    text "SUB      "
    done

section "UnitStatus_Header", romx[$60d8], bank[$25]
    ;text "ユニットについての くわしい"
    ;line "じょうほうを みることができます。"
    text "VIEW DETAILED UNIT"
    line "INFORMATION。 "
    done

section "UnitStatus_Strings", romx[$6349], bank[$25]
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

section "UnitStatus_None", romx[$66fe], bank[$25]
    text "なし"
    ;text "NONE"
    done
    ;text "ふかのう " ; Need to find pointer for this string so it can be shifted forward two bytes
    text "N/A  "
    done

section "UnitStatus_Costs", romx[$6ad0], bank[$25]
    ;coord_text 1, 3, "せいさんしょうひしきん"
    coord_text 1, 3, "GOLD COST  "
    ;coord_text 1, 4, "せいさんしょうひしざい"
    coord_text 1, 4, "MTL COST   "
