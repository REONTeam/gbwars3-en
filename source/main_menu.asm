include "include/macros.inc"
include "include/bank_ends.inc"
include "include/char_main.inc"

section "15:4a3b", romx[$4a3b], bank[$15] ; Mode Names
    ;db "ビギナーモード    ", 0
    db "BEGINNER   ", 0
    ;db "キャンペーンモード  ", 0
    db "CAMPAIGN   ", 0
    ;db "スタンダードモード", 0
    db "STANDARD ", 0

section "MainMenu_Desc", romx[$55d2], bank[$15] ; Main Menu - Descriptions
MainMenu_Desc:
    dw MainMenu_Desc_Continue
    dw MainMenu_Desc_NewGame
    dw MainMenu_Desc_Vs
    dw MainMenu_Desc_Map
    dw MainMenu_Desc_Network

MainMenu_Desc_Continue:
    ;db "つづきからゲームをはじめます。", 0
    db "CONTINUE GAME。", 0

MainMenu_Desc_NewGame:
    ;db "あたらしくゲームをはじめます。", 0
    db "START NEW GAME。", 0

MainMenu_Desc_Vs:
    ;db "ほかのプレイヤーと", 1
    ;db "たいせんします。", 0
    db "PLAY AGAINST", 1
    db "OTHER PLAYERS。", 0

MainMenu_Desc_Map:
    ;db "マップをつくったり", 1
    ;db "IRつうしんでやりとりできます。", 0
    db "CREATE AND SHARE", 1
    db "MAPS USING IR。", 0

    section_end $5640

section fragment "bank15_end", romx[bank15_end_addr], bank[$15]
MainMenu_Desc_Network:
    ;db "ウォーズネットセンターに", 1
    ;db "アクセスします。", 0
    db "ACCESS THE WARS", 1
    db "NET CENTER。", 0

section "15:5ec1", romx[$5ec1], bank[$15]
    ;db "セーブしました。"
    db "SAVED。  "
