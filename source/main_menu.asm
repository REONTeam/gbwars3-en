include "include/macros.inc"
include "include/bank_ends.inc"
include "include/char_main.inc"

section "15:4a3b", romx[$4a3b], bank[$15] ; Mode Names
    text "BEGINNER   "      ; ビギナーモード
    done
    
    text "CAMPAIGN   "      ; キャンペーンモード
    done
    
    text "STANDARD "        ; スタンダードモード
    done

section "MainMenu_Desc", romx[$55d2], bank[$15] ; Main Menu - Descriptions
MainMenu_Desc:
    dw MainMenu_Desc_Continue
    dw MainMenu_Desc_NewGame
    dw MainMenu_Desc_Vs
    dw MainMenu_Desc_Map
    dw MainMenu_Desc_Network

MainMenu_Desc_Continue:
    text "CONTINUE GAME。"   ; つづきからゲームをはじめます。
    done

MainMenu_Desc_NewGame:
    text "START NEW GAME。"  ; あたらしくゲームをはじめます。
    done

MainMenu_Desc_Vs:
    text "PLAY AGAINST"     ; ほかのプレイヤーと
    line "OTHER PLAYERS。"   ; たいせんします。
    done

MainMenu_Desc_Map:
    text "CREATE AND SHARE" ; マップをつくったり
    line "MAPS USING IR。"   ; IRつうしんでやりとりできます。
    done

    section_end $5640

section fragment "bank15_end", romx[bank15_end_addr], bank[$15]
MainMenu_Desc_Network:
    text "ACCESS THE WARS"  ; ウォーズネットセンターに
    line "NET CENTER。"      ; アクセスします。
    done

section "15:5ec1", romx[$5ec1], bank[$15]
    text "SAVED。  "         ; セーブしました。
    done
