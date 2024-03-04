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
    ld hl, UnitCreation_Gas
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

UnitCreation_Gold:      ; $b1 is the Gold Icon
    db $b1, "-   00"
    done

UnitCreation_Material:  ; $b2 is the Material Icon
    db $b2, "-"
    done

UnitCreation_Movement:  ; $af is the Gold Icon
    db $af, "  :"
    done

UnitCreation_Gas:      ; $b0 is the Gas Icon
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

section "UnitStatus_Menu", romx[$62d6], bank[$25]
UnitStatus_Menu:
    lb bc, 4, 7
    ld hl, UnitStatus_String_Movement
    call TextPut
    lb bc, 2, 12 ; Initiative Coordinates
    ld hl, UnitStatus_String_Initiative
    call TextPut
    lb bc, 13, 12 ; Initiative '/' Coordinates (10, 12)
    ld hl, $64fe
    call TextPut
    ld hl, UnitStatus_String_Load
    call CoordTextPut
    lb bc, 7, 13
    ld hl, $64fe
    call TextPut
    ld hl, UnitStatus_String_Promotion
    call CoordTextPut
    ld a, $08
    lb bc, 5, 14
    ld de, $0101
    ld h, $ec
    farcall $15, $67fd
    lb bc, 7, 14
    ld hl, $64fe
    call TextPut
    lb bc, 2, 15
    ld hl, UnitStatus_String_Defense
    call TextPut
    ld hl, UnitStatus_String_Resupply_Repair
    call CoordTextPut
    ld a, $08
    lb bc, 2, 7
    ld de, $0101
    ld h, $f1
    farcall $15, $67fd
    ld a, $08
    lb bc, 2, 8
    ld de, $0101
    ld h, $f2
    farcall $15, $67fd
    ret

UnitStatus_String_Movement:
    ;text "いどうりょく    /"
    text "MOVE      /"
    done

UnitStatus_String_Gas:
    ;text "さいだいねんりょう /"
    text "MAX GAS   /"
    done

    section_end $6361

section fragment "bank25_end", romx[bank25_end_addr], bank[$25]

UnitStatus_String_Initiative:
    ;text "イニシアティブ"
    text "INITIATIVE"
    done

    section_end $8000

section "UnitStatus_Menu_Continued", romx[$6361], bank[$25]
UnitStatus_String_Load:
    ;coord_text 2, 13, "とうさい"
    coord_text 2, 13, "LOAD"

UnitStatus_String_Promotion:
    ;coord_text 2, 14, "しんか" ; Promotion
    coord_text 2, 14, "PRM"

UnitStatus_String_Defense:
    ;text "ぼうぎょりょく"
    text "DEFENSE"
    done

UnitStatus_String_Resupply_Repair:
    ;coord_text 2, 16, "ほきゅう•ほじゅう"
    coord_text 2, 16, "RESUPPLY•REPAIR"

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
