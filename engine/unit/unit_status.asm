include "macros/macros.inc"
include "constants/bank_ends.inc"
include "charmaps/char_main.inc"

setcharmap main
; Map-selection status helper used by the Unit Status/map setup UI. 
; renders the 8-byte base plus the header sidecar through the bank-4 scratch
; without relocating the live byte that follows it.
section "UnitStatus Map Selection Summary", romx[$47bc], bank[$25]
UnitStatus_DrawMapSelectionSummary::
    call $47a3
    farcall MapRecord_SelectCampaign
    ld a, [wMapRecordIndex]
    inc a
    lb bc, 2, 14
    ld d, $02
    call DrawNumberFixedWidth
    lb bc, 5, 14
    call Vram_TilemapCoord
    farcall MapName9_DrawLoadedUnitStatus
    ld a, [wMapRecordIndex]
    ld hl, wCampaignMapClearCounts
    call AddAtoHL
    ld a, [hl]
    lb bc, 11, 15
    ld d, $02
    call DrawNumberFixedWidth
    ret

    section_end $4819

; Alternate map-selection renderer used by the same Bank $25 UI. It uses the
; same sidecar-aware scratch path before passing the temporary terminated
; string into the shared ROM0 row-text helper at $0F63.
section "UnitStatus Alternate Map Name", romx[$491f], bank[$25]
UnitStatus_DrawAlternateMapName::
    ld a, [wMapRecordIndex]
    inc a
    lb bc, 2, 4
    ld d, $02
    call DrawNumberFixedWidth
    lb bc, 5, 4
    call Vram_TilemapCoord
    farcall MapName9_DrawLoadedUnitStatusAlt
    ret

    section_end $4963

section "UnitStatus_Types", romx[$5e49], bank[$25]
UnitStatus_Types::
UnitStatus_Type_Armored::
    ;text "そうこうユニット "
    text "ARMORED  "
    done
UnitStatus_Type_Unarmored::
    ;text "ひそうこうユニット"
    text "UNARMORED"
    done
UnitStatus_Type_Air::
    ;text "そらユニット   "
    text "AIR      "
    done
UnitStatus_Type_Sea::
    ;text "うみユニット   "
    text "SEA      "
    done
UnitStatus_Type_Submarine::
    ;text "せんすいかん   "
    text "SUB      "
    done

assert @ <= $60d8

section "UnitStatus_Header", romx[$60d8], bank[$25]
UnitStatus_Header::
    ;text "ユニットについての くわしい"
    ;line "じょうほうを みることができます。"
    text "VIEW DETAILED UNIT"
    line "INFORMATION。 "
    done

assert @ <= $62d6

section "UnitStatus_Menu", romx[$62d6], bank[$25]
UnitStatus_Menu::
    lb bc, 4, 7
    ld hl, UnitStatus_String_Movement
    call TextPut
    lb bc, 2, 12 ; Initiative Coordinates
    ld hl, UnitStatus_String_Initiative
    call TextPut
    lb bc, 13, 12 ; Initiative '/' Coordinates (10, 12)
    ld hl, UnitReference_String_Slash
    call TextPut
    ld hl, UnitStatus_String_Load
    call CoordTextPut
    lb bc, 7, 13
    ld hl, UnitReference_String_Slash
    call TextPut
    ld hl, UnitStatus_String_Promotion
    call CoordTextPut
    ld a, $08
    lb bc, 5, 14
    ld de, $0101
    ld h, $ec
    farcall Gfx_DrawSequentialTileRectWithAttributes
    lb bc, 7, 14
    ld hl, UnitReference_String_Slash
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
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    lb bc, 2, 8
    ld de, $0101
    ld h, $f2
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret

UnitStatus_String_Movement:
    ;text "いどうりょく    /"
    text "MOVE      /"
    done

UnitStatus_String_Gas::
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
UnitStatus_String_Load::
    ;coord_text 2, 13, "とうさい"
    coord_text 2, 13, "LOAD"

UnitStatus_String_Promotion:
    ;coord_text 2, 14, "しんか" ; Promotion
    coord_text 2, 14, "PRM"

UnitStatus_String_Defense:
    ;text "ぼうぎょりょく"
    text "DEFENSE"
    done

UnitStatus_String_Resupply_Repair::
    ;coord_text 2, 16, "ほきゅう•ほじゅう"
    coord_text 2, 16, "RESUPPLY•REPAIR"

assert @ <= $66fe

section "UnitStatus_String_None", romx[$66fe], bank[$25]
UnitStatus_String_None::
    text "なし"
    ;text "NONE"
    done

    ; Code referencing the below text is at $6602, need to add it to move it's pointer forward a bit.
    ; A pointer within it ($6702) also references it without it's first character for when a unit can be loaded.
    ; Needs to pointed to a completely new string for YES.
    ;text "ふかのう "
UnitStatus_String_Unavailable::
    text "N"
UnitStatus_String_LoadAvailableTail::
    text "O   "
    done

assert @ <= $6ad0

section "UnitStatus_String_Costs", romx[$6ad0], bank[$25]
UnitStatus_String_Costs::
    ;coord_text 1, 3, "せいさんしょうひしきん"
    coord_text 1, 3, "GOLD COST  "
UnitStatus_String_MaterialCost::
    ;coord_text 1, 4, "せいさんしょうひしざい"
    coord_text 1, 4, "MTL COST   "

assert @ <= $6f34

section "UnitStatus_Submenu_Move", romx[$6f34], bank[$25]
UnitStatus_Submenu_Move::
    text "いどうロス" ; Move Loss
    done

assert @ <= $7139

section "UnitStatus_Submenu_Terrain_Def", romx[$7139], bank[$25]
UnitStatus_Submenu_Terrain_Def::
    text "ぼうぎょこうか/" ; Def(ensive) (Terrain) Cover
    done

assert @ <= $731d

section "UnitStatus_Submenu_Upkeep", romx[$731d], bank[$25]
UnitStatus_Submenu_Upkeep::
    text "たいくうしょうひねんりょう /" ; Flight Gas Cost
    done

UnitStatus_Submenu_Upkeep_MaxFuel::
    text "さいだいねんりょう   /" ; Max Gas
    done

assert @ <= $74f0

section "UnitStatus_Submenu_Weapon", romx[$74f0], bank[$25]
UnitStatus_Submenu_Weapon::
    text "ほきゅうかかく" ; Resupply Cost
    done

UnitStatus_Submenu_Weapon_Range::
    coord_text 1, 2, "しゃてい" ; Range
UnitStatus_Submenu_Weapon_AttackPower::
    coord_text 1, 4, "こうげきりょく" ; Offensive Power

assert @ <= $758c

section "UnitStatus_Submenu_Initiative", romx[$758c], bank[$25]
UnitStatus_Submenu_Initiative::
    text "しょうひイニシアティブ /" ; Initiative Cost
    done

assert @ <= $7783

section "UnitStatus_Submenu_Load", romx[$7783], bank[$25]
UnitStatus_Submenu_Load::
    text "ユニットまで とうさいかのう" ; Up to # can be loaded. (Starts with a number that needs moving)
    done

UnitStatus_Submenu_Load_UnitTypes::
    text "とうさいかのうユニット" ; Loadable Units
    done

assert @ <= $7875

section "UnitStatus_Submenu_Promotion", romx[$7875], bank[$25]
UnitStatus_Submenu_Promotion::
    ;text "しんか"
    text "PRM" ; Change to "Promotion" when more room is available.
    done

assert @ <= $7f4d

section "UnitStatus_Submenu_ResupplyRepair", romx[$7f4d], bank[$25]
UnitStatus_Submenu_ResupplyRepair:
    text "ほきゅうかのう       "
    done

    text "ほじゅうかのう       "
    done

    text "              " ; Used for every empty line in the submenu.
    done
assert @ <= $8000
