include "include/macros.inc"
include "include/bank_ends.inc"
include "include/char_main.inc"
include "include/char_unit.inc"
include "include/char_news.inc"

section "Image_Charmap", romx[$4118], bank[$01]
incbin "gfx/charmap.2bpp"

section "Image_Symbols", romx[$5120], bank[$01]
incbin "gfx/symbols.2bpp"

section "Image_Units", romx[$5898], bank[$01]
incbin "gfx/units.2bpp"

section "Attrmap_Title_Screen", romx[$5080], bank[$10]
incbin "gfx/title_screen.attrmap"

section "Image_Title_Screen", romx[$51e8], bank[$10]
incbin "gfx/title_screen.2bpp"

section "Pals_Title_Screen", romx[$6868], bank[$10]
incbin "gfx/title_screen.orig.pal"

section "Image_Action_Menu", romx[$4e88], bank[$11]
incbin "gfx/action_menu.2bpp"

section "Image_System_Messages", romx[$5e10], bank[$11]
incbin "gfx/system_messages.2bpp"

section "Image_Map_Menu", romx[$57cc], bank[$13]
incbin "gfx/map_menu.2bpp"

section "Image_Name_Screen", romx[$5708], bank[$14]
incbin "gfx/name_screen.2bpp"

section "Image_File_Select_Numbers", romx[$6341], bank[$14]
incbin "gfx/file_select_numbers.2bpp" ; Unused?

section "Image_File_Select_General1", romx[$6401], bank[$14]
incbin "gfx/file_select_general1.2bpp" ; Unused?

section "Image_File_Select_Modes", romx[$65b1], bank[$14]
incbin "gfx/file_select_modes.2bpp"

section "Image_File_Select_Medals", romx[$6b41], bank[$14]
incbin "gfx/file_select_medals.2bpp"

section "Image_File_Select_Ranks", romx[$73e1], bank[$14]
incbin "gfx/file_select_ranks.2bpp"

section "Image_Configuration", romx[$4513], bank[$15]
incbin "gfx/config.2bpp"

section "Image_VS_Menu_Type", romx[$76f2], bank[$15]
incbin "gfx/vs_menu_type.2bpp"

setcharmap main
section "18:5e5b", romx[$5e5b], bank[$18] ; VS Menu - Type Selection Header
    ;text "たいせん ほうほう"
    text " VS STYLE"
    done

section "Image_Unit_Status", romx[$7ab8], bank[$18]
incbin "gfx/unit_status.2bpp"

section "Image_Mobile_Menu", romx[$720c], bank[$19]
incbin "gfx/mobile_menu.2bpp"

setcharmap news
section "Mobile_Mail_Header", romx[$792c], bank[$19]
    ;coord_text 2, 1, "メッセージサービス"
    coord_text 2, 1, "MESSAGES "

section "Image_Charmap_News", romx[$64d4], bank[$22]
incbin "gfx/charmap_news.2bpp"

setcharmap main
section "25:48a0", romx[$48a0], bank[$25] ; Campaign Mode - Map - Win Count
    ;text "しょうりかいすう   /"
    text "WINS       /"
    done

section "27:65a0", romx[$65a0], bank[$27] ; Battle - Status Menu
    ;text "ユニット"
    text "UNIT"
    done
    ;text "せいさんユニット"
    text "DEPLOYED"
    done
    ;text "ぜんめつユニット"
    text "LOST    "
    done

section "Image_Results", romx[$65e3], bank[$27]
incbin "gfx/results.2bpp"

section "27:6c30", romx[$6c2e], bank[$27] ; File Select - Save/Mode Prompts
    ;coord_text 1, 3, "どこにセーブしますか?      "
    coord_text 1, 3, "SAVE WHERE?      "

    ;coord_text 1, 3, "ビギナーモードをあそびますか?  "
    coord_text 1, 3, "PLAY BEGINNER?   "

    ;coord_text 1, 3, "キャンペーンモードをあそびますか?"
    coord_text 1, 3, "PLAY CAMPAIGN?   "

    ;coord_text 1, 3, "スタンダードモードをあそびますか?"
    coord_text 1, 3, "PLAY STANDARD?"

section "27:6caa", romx[$6ca8], bank[$27]
    ;coord_text 6, 4, "セーブしました"
    coord_text 6, 4, "SAVED. "

section "Image_File_Select_General2", romx[$7577], bank[$27]
incbin "gfx/file_select_general2.2bpp"
